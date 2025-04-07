import requests
import json
import threading
import os
import time
import re
import random
import platform
from concurrent.futures import ThreadPoolExecutor, as_completed
import multiprocessing

# Configurations
MAX_CONCURRENT_REQUESTS = 50
PREFERRED_LANGUAGES = ["es-mx", "de", "en"] # Select your language prefer ["ja", "zh", "zh-cn", "fr", "de", "it", "ru", "pt", "pl", "ko"]
MAIN_FOLDER = "local_files"
SQL_FILE = "import_races.sql"
COMMON_PATTERNS = [(0, 0), (0, 1), (1, 0), (2, 0)]

def clear_console():
    """Clears the console based on the operating system"""
    if platform.system() == "Windows":
        os.system('cls')
    else:
        os.system('clear')

def ensure_directories_exist():
    """Creates the folder structure if it doesn't exist"""
    if not os.path.exists(MAIN_FOLDER):
        os.makedirs(MAIN_FOLDER)
        print(f"Main folder '{MAIN_FOLDER}' created.")
    
    for lang in PREFERRED_LANGUAGES:
        lang_folder = os.path.join(MAIN_FOLDER, f"maps_{lang}")
        if not os.path.exists(lang_folder):
            os.makedirs(lang_folder)
            print(f"Folder '{lang_folder}' created.")

def sanitize_filename(name):
    """Converts the race name into a valid filename"""
    if not name or not isinstance(name, str):
        return f"unnamed_race_{random.randint(1000, 9999)}"
        
    sanitized = re.sub(r'[\\/*?:"<>|]', "", name)
    sanitized = re.sub(r'[\s\-\+\.,;=]', "_", sanitized)
    sanitized = re.sub(r'_+', "_", sanitized)
    if len(sanitized) > 100:
        sanitized = sanitized[:100]
    sanitized = sanitized.strip("_")
    return sanitized if sanitized else f"unnamed_race_{random.randint(1000, 9999)}"

def find_value_by_key(obj, key, depth=0, max_depth=10):
    """Recursively searches for a value by its key in a JSON object"""
    if depth > max_depth:
        return None
    
    if isinstance(obj, dict):
        if key in obj:
            return obj[key]
        for k, v in obj.items():
            result = find_value_by_key(v, key, depth + 1, max_depth)
            if result is not None:
                return result
    elif isinstance(obj, list):
        for item in obj:
            result = find_value_by_key(item, key, depth + 1, max_depth)
            if result is not None:
                return result
    
    return None

def extract_race_name(data):
    """Extracts the race name from the JSON"""
    print("DEBUG - Main keys in JSON:", list(data.keys()) if isinstance(data, dict) else "Not a dictionary")
    
    race_name = find_value_by_key(data, "nm")
    if race_name and isinstance(race_name, str):
        print(f"DEBUG - Name found in 'nm' field: {race_name}")
        return race_name
    
    for field in ["name", "title", "Name", "Title"]:
        value = find_value_by_key(data, field)
        if value and isinstance(value, str):
            print(f"DEBUG - Name found in '{field}' field: {value}")
            return value
    
    random_name = f"unnamed_race_{random.randint(1000, 9999)}"
    print(f"DEBUG - No name found, using: {random_name}")
    return random_name

def get_last_race_id():
    """Gets the last race ID from the existing SQL file"""
    if not os.path.exists(SQL_FILE):
        return 0
    
    try:
        with open(SQL_FILE, 'r', encoding='utf-8') as f:
            content = f.read()
            ids = re.findall(r'\((\d+),', content)
            if ids:
                return max(map(int, ids))
            return 0
    except:
        return 0

def generate_sql_import(downloaded_files, image_url):
    """Generates or updates an SQL file with the downloaded race data"""
    if not downloaded_files:
        return
    
    last_id = get_last_race_id()
    mode = 'a' if os.path.exists(SQL_FILE) and last_id > 0 else 'w'
    
    with open(SQL_FILE, mode, encoding='utf-8') as sql_file:
        if mode == 'w':
            sql_file.write("INSERT INTO `custom_race_list` (`raceid`, `route_file`, `route_image`, `category`, `besttimes`) VALUES\n")
        else:
            with open(SQL_FILE, 'r+', encoding='utf-8') as f:
                content = f.read()
                f.seek(0)
                
                if content.strip().endswith(';'):
                    content = content.rsplit(';', 1)[0]
                
                f.write(content)
                f.truncate()
            
            sql_file.write(",\n")
        
        for i, info in enumerate(downloaded_files, start=last_id + 1):
            json_path = os.path.join(MAIN_FOLDER, os.path.basename(info['filename']))
            sql_line = f"  ({i}, '{json_path}', '{image_url}', 'Custom', '[]')"
            
            if i < last_id + len(downloaded_files):
                sql_line += ",\n"
            else:
                sql_line += ";\n"
            
            sql_file.write(sql_line)
    
    print(f"\n📄 SQL file {'updated' if mode == 'a' else 'generated'}: {SQL_FILE}")

def download_json_directly(json_url, image_url=None):
    """Downloads a JSON file directly from a URL"""
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
    }
    
    try:
        print(f"Downloading JSON directly from: {json_url}")
        response = requests.get(json_url, headers=headers, timeout=5)
        
        if response.status_code == 200:
            try:
                data = response.json()
                if data:
                    parts = json_url.split('/')
                    filename = parts[-1]
                    lang = filename.split('_')[-1].split('.')[0]
                    
                    if lang not in PREFERRED_LANGUAGES:
                        lang = PREFERRED_LANGUAGES[0]
                    
                    print(f"✅ JSON found (Language: {lang})")
                    
                    print("DEBUG - JSON sample:")
                    json_str = json.dumps(data, ensure_ascii=False)[:500]
                    print(json_str + "..." if len(json_str) >= 500 else json_str)
                    
                    race_name = extract_race_name(data)
                    print(f"📝 Race name: {race_name}")
                    
                    safe_name = sanitize_filename(race_name)
                    lang_folder = os.path.join(MAIN_FOLDER, f"maps_{lang}")
                    save_filename = os.path.join(lang_folder, f"{safe_name}_{lang}.json")
                    
                    with open(save_filename, 'w', encoding='utf-8') as f:
                        json.dump(data, f, ensure_ascii=False, indent=2)
                    
                    print(f"📁 File saved as: {save_filename}")
                    
                    if image_url:
                        generate_sql_import([{
                            'filename': save_filename,
                            'race_name': race_name
                        }], image_url)
                    
                    return {
                        'url': json_url,
                        'language': lang,
                        'race_name': race_name,
                        'filename': save_filename
                    }
                    
            except json.JSONDecodeError:
                print("❌ Error: File is not a valid JSON.")
        else:
            print(f"❌ Error: Could not download file (Code: {response.status_code}).")
    
    except requests.RequestException as e:
        print(f"❌ Connection error: {e}")
    
    return None

def crawl_url(url, found_data, download_info, total_requests, completed_requests, race_names):
    if found_data.is_set():
        with completed_requests.get_lock():
            completed_requests.value += 1
        return False

    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
    }

    try:
        response = requests.get(url, headers=headers, timeout=5)

        with completed_requests.get_lock():
            completed_requests.value += 1

        if response.status_code == 200:
            try:
                data = response.json()
                if data:
                    parts = url.split('/')
                    filename = parts[-1]
                    lang = filename.split('_')[-1].split('.')[0]
                    
                    print(f"\n✅ JSON found: {url} (Language: {lang})")
                    
                    if lang in PREFERRED_LANGUAGES:
                        print("DEBUG - JSON sample:")
                        json_str = json.dumps(data, ensure_ascii=False)[:500]
                        print(json_str + "..." if len(json_str) >= 500 else json_str)
                        
                        race_name = extract_race_name(data)
                        print(f"📝 Race name: {race_name}")
                        
                        race_names[lang] = race_name
                        safe_name = sanitize_filename(race_name)
                        lang_folder = os.path.join(MAIN_FOLDER, f"maps_{lang}")
                        save_filename = os.path.join(lang_folder, f"{safe_name}_{lang}.json")
                        
                        with open(save_filename, 'w', encoding='utf-8') as f:
                            json.dump(data, f, ensure_ascii=False, indent=2)
                        
                        print(f"📁 File saved as: {save_filename}")
                        
                        download_info.append({
                            'url': url,
                            'language': lang,
                            'race_name': race_name,
                            'filename': save_filename
                        })
                        
                    found_data.set()
                    return True
            except json.JSONDecodeError:
                pass
        elif response.status_code == 404:
            pass
        elif response.status_code == 429:
            print("\n⚠️ Too many requests. Waiting 2 seconds...")
            time.sleep(2)
        else:
            pass

    except requests.RequestException:
        pass

    progress = int((completed_requests.value / total_requests.value) * 50)
    print(f"\rProgress: [{'#' * progress}{' ' * (50-progress)}] {completed_requests.value}/{total_requests.value} URLs checked", end="")

    return False

def generate_optimized_urls(base_url):
    """Generates URLs in an optimized order to find results faster"""
    urls = []
    base_path = base_url.rsplit('/', 1)[0]
    
    for i, j in COMMON_PATTERNS:
        for lang in PREFERRED_LANGUAGES:
            url = f"{base_path}/{i}_{j}_{lang}.json"
            urls.append(url)
    
    for i in range(2):
        for j in range(10):
            if (i, j) not in COMMON_PATTERNS:
                for lang in PREFERRED_LANGUAGES:
                    url = f"{base_path}/{i}_{j}_{lang}.json"
                    urls.append(url)
    
    return urls

def crawl_urls_concurrently(base_url):
    clear_console()
    found_data = threading.Event()
    download_info = []
    race_names = {lang: "" for lang in PREFERRED_LANGUAGES}
    
    total_requests = multiprocessing.Value('i', 0)
    completed_requests = multiprocessing.Value('i', 0)
    
    urls = generate_optimized_urls(base_url)
    
    with total_requests.get_lock():
        total_requests.value = len(urls)
    
    print(f"Searching for JSON files for {base_url}...")
    print(f"Prioritizing languages: {', '.join(PREFERRED_LANGUAGES)}")
    print(f"Checking {len(urls)} possible URLs with optimized strategy")
    
    print("Progress: [" + " " * 50 + "] 0/0 URLs checked", end="")
    
    start_time = time.time()
    
    with ThreadPoolExecutor(max_workers=MAX_CONCURRENT_REQUESTS) as executor:
        futures = [executor.submit(crawl_url, url, found_data, download_info, total_requests, completed_requests, race_names) for url in urls]
        for future in as_completed(futures):
            if future.result():
                for f in futures:
                    f.cancel()
                break
    
    end_time = time.time()
    duration = end_time - start_time
    
    print(f"\n\nSearch completed in {duration:.2f} seconds")
    
    if not download_info:
        print("❌ No JSON files found in preferred languages.")
    else:
        print("\n📋 Download summary:")
        for info in download_info:
            print(f"✓ Race name: {info['race_name']}")
            print(f"  File saved as: {info['filename']}")
            print(f"  URL: {info['url']}")
            print(f"  Language: {info['language']}")
        
        generate_sql_import(download_info, base_url)
    
    input("\nPress Enter to continue...")
    clear_console()
    return download_info

def check_mission_exists(base_url):
    """Quickly checks if the mission exists before searching for JSON files"""
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
    }
    
    try:
        response = requests.head(base_url, headers=headers, timeout=5)
        return response.status_code == 200
    except:
        return False

def is_json_url(url):
    """Checks if the URL is directly to a JSON file"""
    return url.lower().endswith('.json')

if __name__ == "__main__":
    clear_console()
    ensure_directories_exist()
    
    while True:
        print("=== Fast GTA V Race JSON Files Downloader ===")
        print("This script will automatically download JSON files and generate/update an SQL for import")
        print(f"Files will be saved in '{MAIN_FOLDER}' and SQL in '{SQL_FILE}'")
        print("Type 'exit' to quit\n")
        base_url = input("\nPaste the image or JSON URL of the race: ")

        if base_url.lower() == 'exit':
            clear_console()
            break
            
        if not base_url.startswith("http"):
            print("❌ Invalid URL. Must start with http:// or https://")
            time.sleep(2)
            clear_console()
            continue
        
        if is_json_url(base_url):
            image_url = base_url.rsplit('.', 1)[0] + '.jpg'
            result = download_json_directly(base_url, image_url)
            if result:
                print("\n📋 Download summary:")
                print(f"✓ Race name: {result['race_name']}")
                print(f"  File saved as: {result['filename']}")
                print(f"  URL: {result['url']}")
                print(f"  Language: {result['language']}")
            
            input("\nPress Enter to continue...")
            clear_console()
        else:
            print("Checking if mission exists...")
            if not check_mission_exists(base_url):
                print("❌ The provided URL doesn't seem valid or the mission doesn't exist.")
                time.sleep(2)
                clear_console()
                continue
                
            crawl_urls_concurrently(base_url)
