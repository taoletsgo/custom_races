# You can use this script to get a single file from Rockstar Social Club. 
# Contribute to this project to get the automated script for batch obtaining JSON files.

import requests
import json
import threading
from concurrent.futures import ThreadPoolExecutor, as_completed

MAX_CONCURRENT_REQUESTS = 20

def crawl_url(url, found_data):
    if found_data.is_set():
        # Data found by another thread, no need to continue
        return False

    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
    }

    try:
        response = requests.get(url, headers=headers)

        if response.status_code == 200:
            try:
                data = response.json()
                if data:
                    print(f"Json data found:{url}")
                    found_data.set()
                    return True
            except json.JSONDecodeError:
                print(f"Invalid JSON response for URL: {url}")
        elif response.status_code == 404:
            print(f"URL not found: {url}")
        else:
            print(f"Error for URL {url}: {response.status_code}")

    except requests.RequestException as e:
        print(f"Error for URL {url}: {str(e)}")

    return False

def crawl_urls_concurrently(base_url):
    found_data = threading.Event()

    urls = []
    for i in range(3):
        for j in range(500):
            for lang in ["en", "ja", "zh", "zh-cn", "fr", "de", "it", "ru", "pt", "pl", "ko", "es", "es-mx"]:
                old_url = f"{base_url}/2_0.jpg"
                url = f"{base_url.rsplit('/', 1)[0]}/{i}_{j}_{lang}.json"
                urls.append(url)

    with ThreadPoolExecutor(max_workers=MAX_CONCURRENT_REQUESTS) as executor:
        futures = [executor.submit(crawl_url, url, found_data) for url in urls]
        for future in as_completed(futures):
            if future.result():
                break

if __name__ == "__main__":
    while True:
        base_url = input("Please paste the job image URL（For example https://prod.cloud.rockstargames.com/ugc/gta5mission/1966/b5qPg2UtVkyK90ynmAl2-A/2_0.jpg）: ")

        if base_url.lower() == 'exit':
            break
        crawl_urls_concurrently(base_url)