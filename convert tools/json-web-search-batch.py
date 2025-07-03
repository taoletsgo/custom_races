import json
import requests
import time
import re
import threading
import os
import shutil
from concurrent.futures import ThreadPoolExecutor, as_completed

headers_api = {
	"X-AMC": "true",
	"X-Requested-With": "XMLHttpRequest",
	"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36",
	"Host": "scapi.rockstargames.com",
	"Cookie": "TS0178249a=01e681cfdb54472c42fa293b267ad0bb90b78660056b784a1f0aa090438d4bd1bfe84a98689a274c7698b7a962eb50a93b29921b74"
}
headers_crawl = {
	'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
}

def sanitize_filename(filename):
	illegal_chars = r'[\\/:"*?<>|]'
	return re.sub(illegal_chars, '', filename)

def extract_and_save(json_data, file):
	items = []
	name_counts = {}
	for item in json_data["content"]["items"]:
		name = item.get("name", "")
		img_src = item.get("imgSrc", "")
		name = sanitize_filename(name)
		if name and img_src:
			name_counts[name] = name_counts.get(name, 0) + 1
			items.append((name, img_src))

	name_indices = {}
	with open(file, "a", encoding="utf-8") as f:
		for name, img_src in items:
			if name_counts[name] > 1:
				name_indices[name] = name_indices.get(name, 0) + 1
				unique_name = f"{name} ({name_indices[name]})"
			else:
				unique_name = name
			f.write(f"{unique_name}\n{img_src}\n")

def fetch_rockstar_data(creator_rockstar_id, max_index, output_file):
	print(f"{'-'*50}")
	platforms = ['pcalt', 'ps5', 'xboxsx']
	base_url = "https://scapi.rockstargames.com/search/mission?dateRangeCreated=any&sort=updatedDate&title=gtav&pageSize=30&creatorRockstarId={}&platform={}&pageIndex={}"

	for platform in platforms:
		page_index = 0
		while True:
			url = base_url.format(creator_rockstar_id, platform, page_index)
			response = requests.get(url, headers=headers_api)
			if response.status_code == 200:
				json_data = response.json()
				total = json_data.get("total", 0)
				if total == 0:
					print(f"No results found for platform {platform}, pausing further requests")
					break
				extract_and_save(json_data, output_file)
				print(f"Content from platform {platform}, page {page_index + 1} extracted and saved to {output_file}")
				page_index += 1
				if max_index > 0 and page_index >= max_index:
					break
			else:
				print(f"Failed to fetch platform {platform}, page {page_index + 1}. Status code: {response.status_code}")
				break
			time.sleep(0)

def extract_text_and_urls_from_file(file_path):
	with open(file_path, 'r', encoding='utf-8') as file:
		lines = file.readlines()
	data = []
	current_text = None
	for line in lines:
		if line.startswith("http"):
			url = line.strip()
			if current_text:
				data.append((current_text, url))
			current_text = None
		else:
			current_text = line.strip()
	return data

def crawl_url(text, url, found_data, max_retries=10):
	if found_data.is_set():
		return None
	for i in range(max_retries):
		try:
			response = requests.get(url, headers=headers_crawl)
			if response.status_code == 200:
				print(f"JSON URL found: {url}")
				found_data.set()
				return url
			elif response.status_code == 404:
				print(f"URL not found: {url}")
				break
			else:
				print(f"Error for URL {url}: Status code {response.status_code}")
				time.sleep(2)
		except requests.RequestException as e:
			print(f"Error for URL {url}: {str(e)}")
			time.sleep(2)
	return None

def crawl_urls_concurrently(text, base_url, found_data):
	urls = []
	for i in range(1):
		for j in range(500):
			for lang in ["en", "ja", "zh", "zh-cn", "fr", "de", "it", "ru", "pt", "pl", "ko", "es", "es-mx"]:
				url = f"{base_url.rsplit('/', 1)[0]}/{i}_{j}_{lang}.json"
				urls.append(url)
	results = []
	with ThreadPoolExecutor(max_workers=13) as executor:
		futures = [executor.submit(crawl_url, text, url, found_data) for url in urls]
		for future in as_completed(futures):
			result = future.result()
			if result:
				results.append(result)
	return results

def process_url(text_url_tuple):
	text, url = text_url_tuple
	found_data = threading.Event()
	results = crawl_urls_concurrently(text, url, found_data)
	return (text, url, results)

def download_file(job, img_url, json_url, output_file_path):
	print(f"Downloading file and image for : {job}")
	try:
		img_response = requests.get(img_url)
		with open(os.path.join(output_file_path, f"{job}.jpg"), "wb") as f:
			f.write(img_response.content)

		response = requests.get(json_url)
		with open(os.path.join(output_file_path, f"{job}.json"), "w", encoding="utf-8") as f:
			f.write(response.text)
	except Exception as e:
		print(f"Failed to download files for : {job}, error: {str(e)}")

def process_and_download(file_path):
	print(f"{'-'*50}")
	input_dir, input_filename = os.path.split(file_path)
	input_name_without_ext = os.path.splitext(input_filename)[0]
	output_file_path = os.path.join(input_dir, input_name_without_ext)
	os.makedirs(output_file_path, exist_ok=True)

	data = extract_text_and_urls_from_file(file_path)
	all_results = []
	with ThreadPoolExecutor(max_workers=3) as executor:
		results = list(executor.map(process_url, data))
		for result in results:
			all_results.append(result)

	with open(file_path, 'w', encoding="utf-8") as output_file:
		for result in all_results:
			output_file.write(f"{result[0]}\n{result[1]}\n")
			for json_url in result[2]:
				output_file.write(f"{json_url}\n")

	img_url_dict = {}
	json_url_dict = {}
	sql_values = []

	with open(file_path, "r", encoding="utf-8") as f:
		lines = f.readlines()

	for i in range(0, len(lines), 3):
		job = lines[i].strip()
		img_url = lines[i+1].strip()
		json_url = lines[i+2].strip()
		img_url_dict[job] = img_url
		json_url_dict[job] = json_url
		sql_values.append(f"('local_files/{job}.json', '{img_url}', '{input_name_without_ext}', '[]')")

	sql_statement = """INSERT INTO `custom_race_list` (`route_file`, `route_image`, `category`, `besttimes`) VALUES
""" + ",\n".join(sql_values) + ";"

	sql_file_path = os.path.join(output_file_path, f"{input_name_without_ext}.sql")
	with open(sql_file_path, "w", encoding="utf-8") as f:
		f.write(sql_statement)

	print(f"{'-'*50}")
	with ThreadPoolExecutor(max_workers=10) as executor:
		future_to_job = {executor.submit(download_file, job, img_url_dict[job], json_url_dict[job], output_file_path): job for job in img_url_dict.keys()}
		for future in as_completed(future_to_job):
			job = future_to_job[future]
			try:
				future.result()
			except Exception as e:
				print(f"Failed to process {job}: {str(e)}")
	print(f"SQL file generated at: {sql_file_path}")
	print(f"{'-'*50}")

def main():
	tutorial_text = "📖 Tutorial: https://github.com/taoletsgo/custom_races/blob/main/README.md#import--export"
	terminal_width = shutil.get_terminal_size().columns
	line_length = min(len(tutorial_text) + 1, terminal_width)
	print(f"{'>'*line_length}\n{tutorial_text}\n{'>'*line_length}\n")
	while True:
		user_name = input("Enter category (username): ")
		creator_rockstar_id = input("Enter rockstar ID: ")
		max_index = input("Enter max page index (default 0): ")
		try:
			max_index = int(max_index) if max_index.strip() else 0
		except ValueError:
			max_index = 0
		output_file_path = input("Enter save path: ").strip('\"')
		output_file = f"{output_file_path}\\{user_name}.txt"

		fetch_rockstar_data(creator_rockstar_id, max_index, output_file)
		process_and_download(output_file)

		exit_command = input("Type 'exit' to exit, or press Enter to continue...\n").strip().lower()
		if exit_command == "exit":
			print(f"\nProgram Exited\n")
			break

if __name__ == "__main__":
	main()