// ==UserScript==
// @name		Rockstar Social Club Enhanced
// @namespace	https://socialclub.rockstargames.com/
// @version		0.2
// @description	An experimental script
// @author		taoletsgo
// @match		https://socialclub.rockstargames.com/jobs*
// @grant		GM_xmlhttpRequest
// @grant		GM_setClipboard
// @connect		scapi.rockstargames.com
// @connect		prod.cloud.rockstargames.com
// ==/UserScript==

(function () {
	'use strict';

	const DEBUG = true;

	const MAX_CONCURRENT = 13;
	const LANGS = ["en", "ja", "zh", "zh-cn", "fr", "de", "it", "ru", "pt", "pl", "ko", "es", "es-mx"];
	const MAX_I = 3;
	const MAX_J = 500;
	const MAX_RETRY = 3;
	const RETRY_DELAY_MS = 500;

	const I18N = {
		zh: {
			panelTitle: "⚡ Rockstar Social Club 增强 v0.2",
			authorLabel: "作者昵称",
			authorPlaceholder: "输入 Social Club 昵称...",
			platformLabel: "平台",
			sortLabel: "排序",
			dateLabel: "时间范围",
			searchBtn: "🔍 搜索差事",
			pcalt: "PC 增强版",
			pc: "PC 经典版",
			ps5: "PS5",
			ps4: "PS4",
			xboxone: "Xbox One",
			xboxsx: "Xbox Series X/S",
			sortLikes: "点赞数",
			sortPlays: "游玩数",
			sortUpdatedDate: "更新时间",
			sortCreatedDate: "创建时间",
			dateAny: "不限",
			dateToday: "今天",
			dateLast7: "近 7 天",
			dateLastmonth: "近一个月",
			dateLastyear: "近一年",
			placeholderInit: "请在上方输入作者昵称后点击“搜索差事”",
			loading: "正在查询数据中，请稍候...",
			searchError: "搜索拦截/失败: ",
			emptyAuthorErr: "请先在“作者昵称”输入框中输入目标玩家昵称",
			noResults: "未找到符合条件的差事结果",
			resultsTitle: "搜索结果 (共 {total} 条)",
			pageText: "页码: {current} / {total}",
			bookmarked: "🔖 已收藏",
			publishedDate: "发布: ",
			firstPage: "首页",
			prevPage: "上一页",
			nextPage: "下一页",
			lastPage: "末页",
			jumpBtn: "跳页",
			debugTitle: "🐞 调试日志 (已脱敏)",
			copyDebugBtn: "📋 复制调试日志",
			copySuccess: "✅ 已复制脱敏日志!",
			copyFail: "复制失败，请手动选中文本复制。",
			sysReady: "系统就绪，等待发起搜索...",
			logReqStart: "网络请求发起",
			logReqDone: "网络请求完成",
			logParseFail: "数据解析失败: 返回文本无法解析为 JSON",
			logAuthFail: "网络请求异常: 凭证失效 (401)",
			logHttpErr: "网络请求异常",
			logNetErr: "网络请求错误",
			logCacheHit: "缓存命中: 作者 “{nickname}” 直接复用 Rockstar ID: {id}",
			logStep1: "步骤 1/2: 开始反查作者昵称 -> Rockstar ID: “{nickname}”",
			logParseSuccess: "解析成功: 作者 “{nickname}” -> Rockstar ID: {id}",
			logStep2: "步骤 2/2: 开始拉取作者 [{author}] (ID: {id}) 的差事列表数据...",
			logApiResp: "API 返回数据: 差事搜索接口原始响应体",
			logRender: "结果渲染: 获取到 {count} 条差事条目 (总计: {total} 条 / {pages} 页)",
			logInit: "统一 UI 面板初始化完成 (v0.2)",
			logLangChange: "语言切换: 当前语言已更改为 {lang}",
			logSearchCancel: "搜索终止: 未输入作者昵称",
			logSearchStart: "=== 开始触发搜索任务 [第 {page} 页] ===",
			logSearchErr: "搜索终止: 捕获到异常错误: {msg}",
			logPageSwitch: "分页切换: 原请求 index: {orig} -> 自动纠偏控制为 index: {target} (第 {page} 页)",
			logDetails: "详细数据",
			btnDownloadSingle: "📥 下载",
			btnDownloadSelected: "📦 下载所选 ({count})",
			btnDownloadPage: "📄 下载当前页",
			selectAll: "全选",
			processing: "处理中 ({current}/{total})...",
			noJobSelected: "请先勾选需要下载的差事！",
			logDownloadStart: "开始处理下载: “{name}”",
			logDownloadSuccess: "成功获取 JSON & SQL: “{name}”",
			logDownloadFailed: "抓取 JSON 失败 (使用元数据备用): “{name}”"
		},
		en: {
			panelTitle: "⚡ Rockstar Social Club Enhanced v0.2",
			authorLabel: "Author Nickname",
			authorPlaceholder: "Enter Social Club Nickname...",
			platformLabel: "Platform",
			sortLabel: "Sort By",
			dateLabel: "Date Range",
			searchBtn: "🔍 Search Jobs",
			pcalt: "PC Enhanced",
			pc: "PC Legacy",
			ps5: "PS5",
			ps4: "PS4",
			xboxone: "Xbox One",
			xboxsx: "Xbox Series X/S",
			sortLikes: "Likes",
			sortPlays: "Plays",
			sortUpdatedDate: "Updated Date",
			sortCreatedDate: "Created Date",
			dateAny: "Anytime",
			dateToday: "Today",
			dateLast7: "Last 7 Days",
			dateLastmonth: "Last Month",
			dateLastyear: "Last Year",
			placeholderInit: "Please enter an author nickname above and click 'Search Jobs'",
			loading: "Fetching data, please wait...",
			searchError: "Search Failed: ",
			emptyAuthorErr: "Please enter a target player nickname first",
			noResults: "No jobs found matching the criteria",
			resultsTitle: "Search Results ({total} items)",
			pageText: "Page: {current} / {total}",
			bookmarked: "🔖 Bookmarked",
			publishedDate: "Published: ",
			firstPage: "First",
			prevPage: "Prev",
			nextPage: "Next",
			lastPage: "Last",
			jumpBtn: "Go",
			debugTitle: "🐞 Debug Log (Sanitized)",
			copyDebugBtn: "📋 Copy Debug Log",
			copySuccess: "✅ Copied Sanitized Log!",
			copyFail: "Copy failed. Please select text manually.",
			sysReady: "System ready, waiting for search...",
			logReqStart: "Network Request Initiated",
			logReqDone: "Network Request Completed",
			logParseFail: "Data Parse Failed: Response text is not valid JSON",
			logAuthFail: "Network Request Exception: Token Expired / Unauthorized (401)",
			logHttpErr: "Network Request Exception",
			logNetErr: "Network Request Error",
			logCacheHit: "Cache Hit: Author '{nickname}' reusing Rockstar ID: {id}",
			logStep1: "Step 1/2: Resolving nickname -> Rockstar ID: '{nickname}'",
			logParseSuccess: "Resolved: Author '{nickname}' -> Rockstar ID: {id}",
			logStep2: "Step 2/2: Fetching jobs for author [{author}] (ID: {id})...",
			logApiResp: "API Response: Raw mission search payload",
			logRender: "Render: Loaded {count} jobs (Total: {total} items / {pages} pages)",
			logInit: "Unified UI Panel initialized (v0.2)",
			logLangChange: "Language Changed: Switched to {lang}",
			logSearchCancel: "Search Cancelled: No author nickname provided",
			logSearchStart: "=== Executing Search Task [Page {page}] ===",
			logSearchErr: "Search Aborted: Caught exception: {msg}",
			logPageSwitch: "Page Switch: Original index: {orig} -> Corrected to index: {target} (Page {page})",
			logDetails: "Detailed Data",
			btnDownloadSingle: "📥 Download",
			btnDownloadSelected: "📦 Download Selected ({count})",
			btnDownloadPage: "📄 Download Page",
			selectAll: "Select All",
			processing: "Processing ({current}/{total})...",
			noJobSelected: "Please select at least one job!",
			logDownloadStart: "Start processing download: '{name}'",
			logDownloadSuccess: "Successfully fetched JSON & SQL: '{name}'",
			logDownloadFailed: "Failed to fetch JSON (used metadata fallback): '{name}'"
		}
	};

	const detectDefaultLang = () => {
		const lang = (navigator.language || navigator.userLanguage || '').toLowerCase();
		return lang.startsWith('zh') ? 'zh' : 'en';
	};

	const STATE = {
		lang: detectDefaultLang(),
		currentPage: 0,
		pageSize: 30,
		totalPages: 1,
		totalItems: 0,
		hasSearched: false,
		cachedRockstarId: null,
		lastAuthorQuery: '',
		lastQueryParams: null,
		lastResponseData: null,
		currentJobs: [],
		selectedJobIds: new Set(),
		isDownloadingBatch: false
	};

	const t = (key, replacements = {}) => {
		let text = I18N[STATE.lang]?.[key] || I18N.en[key] || key;
		Object.keys(replacements).forEach(k => {
			text = text.replace(`{${k}}`, replacements[k]);
		});
		return text;
	};

	function createUrlGenerator(folder) {
		let i = 0, j = 0, langIdx = 0;
		return function () {
			if (i >= MAX_I) return null;
			const url = `${folder}/${i}_${j}_${LANGS[langIdx]}.json`;
			langIdx++;
			if (langIdx >= LANGS.length) {
				langIdx = 0;
				j++;
				if (j >= MAX_J) {
					j = 0;
					i++;
				}
			}
			return url;
		};
	}

	function gmRequest(url, activeReqs) {
		return new Promise(resolve => {
			try {
				const req = GM_xmlhttpRequest({
					method: 'GET',
					url,
					onload: res => {
						try { if (activeReqs && req) activeReqs.delete(req); } catch(e){}
						resolve({ status: res.status, responseText: res.responseText });
					},
					onerror: () => {
						try { if (activeReqs && req) activeReqs.delete(req); } catch(e){}
						resolve(null);
					},
					ontimeout: () => {
						try { if (activeReqs && req) activeReqs.delete(req); } catch(e){}
						resolve(null);
					}
				});
				try { if (activeReqs && req && typeof req.abort === 'function') activeReqs.add(req); } catch (e) {}
			} catch (e) {
				resolve(null);
			}
		});
	}

	async function findJsonForImage(imageUrl, onProgress, token = { cancelled: false }) {
		if (!imageUrl) return null;
		const folder = imageUrl.replace(/\/[^/]+$/, '');
		const nextUrl = createUrlGenerator(folder);
		let triedCount = 0;
		let found = null;
		let activeTasks = 0;
		const activeReqs = new Set();

		function delay(ms) { return new Promise(res => setTimeout(res, ms)); }

		async function attemptUrl(url) {
			for (let attempt = 0; attempt <= MAX_RETRY && !found && !token.cancelled; attempt++) {
				if (attempt > 0) await delay(RETRY_DELAY_MS);
				const res = await gmRequest(url, activeReqs);
				if (token.cancelled) return;

				if (res && res.status === 200) {
					found = { url, content: res.responseText };
					return;
				} else if (res && res.status === 404) {
					return;
				}
			}
		}

		async function runNext() {
			if (token.cancelled || found) return;
			const url = nextUrl();
			if (!url) return;
			activeTasks++;
			triedCount++;
			if (onProgress) onProgress(triedCount);
			await attemptUrl(url);
			activeTasks--;
			await runNext();
		}

		const initialTasks = [];
		for (let k = 0; k < MAX_CONCURRENT; k++) {
			initialTasks.push(runNext());
		}
		await Promise.all(initialTasks);

		return found;
	}

	const Utils = {
		getCookie(name) {
			const value = `; ${document.cookie}`;
			const parts = value.split(`; ${name}=`);
			if (parts.length === 2) return parts.pop().split(';').shift();
			return '';
		},

		getHighResTimestamp() {
			const now = new Date();
			const timeStr = now.toTimeString().split(' ')[0];
			const ms = String(now.getMilliseconds()).padStart(3, '0');
			return `${timeStr}.${ms}`;
		},

		sanitizeText(input) {
			if (!input) return '';
			let str = typeof input === 'string' ? input : JSON.stringify(input, null, 2);

			return str
				.replace(/Bearer\s+[A-Za-z0-9\-._~+/]+=*/gi, 'Bearer [TOKEN_HIDDEN]')
				.replace(/BearerToken=[^;\s"']+/gi, 'BearerToken=[HIDDEN]')
				.replace(/(TS01[a-zA-Z0-9_]+)=[^;\s"']+/gi, '$1=[HIDDEN]')
				.replace(/(["']?authorization["']?\s*:\s*["'])[^"']+(["'])/gi, '$1Bearer [TOKEN_HIDDEN]$2');
		},

		logDebug(msg, data = null) {
			if (!DEBUG) return;
			const timestamp = this.getHighResTimestamp();
			const logMsg = `[${timestamp}] ${msg}`;
			const sanitizedDataStr = data !== null ? `\n--> ${t('logDetails')}: ${this.sanitizeText(data)}` : '';

			console.log(`[RSC-Search ${timestamp}]`, msg, data !== null ? JSON.parse(this.sanitizeText(data)) : '');

			const debugPre = document.getElementById('rsc-debug-content');
			if (debugPre) {
				debugPre.textContent = `${logMsg}${sanitizedDataStr}\n${'-'.repeat(60)}\n${debugPre.textContent}`;
			}
		},

		async copyToClipboard(text) {
			try {
				if (typeof GM_setClipboard !== 'undefined') {
					GM_setClipboard(text);
					return true;
				} else if (navigator.clipboard && navigator.clipboard.writeText) {
					await navigator.clipboard.writeText(text);
					return true;
				}
			} catch (e) {
				console.error('复制失败:', e);
			}
			return false;
		},

		formatDate(dateStr) {
			if (!dateStr) return 'N/A';
			const d = new Date(dateStr);
			return isNaN(d.getTime()) ? dateStr : d.toLocaleDateString();
		},

		sanitizeJobName(rawName) {
			if (!rawName) return 'unnamed_job';
			return rawName
				.replace(/[\\/:"*?<>|]/g, '')
				.replace(/\s+/g, ' ')
				.replace(/^\s+/, '')
				.replace(/\s+$/, '');
		},

		downloadFile(filename, textContent, mimeType = 'text/plain') {
			const blob = new Blob([textContent], { type: `${mimeType};charset=utf-8;` });
			const url = URL.createObjectURL(blob);
			const link = document.createElement('a');
			link.href = url;
			link.setAttribute('download', filename);
			document.body.appendChild(link);
			link.click();
			document.body.removeChild(link);
			setTimeout(() => URL.revokeObjectURL(url), 10000);
		},

		generateJobSql(job, authorName) {
			const name = this.sanitizeJobName(job.name);
			const thumbnail = job.imgSrc || '';
			const author = authorName || STATE.lastAuthorQuery || 'socialclub';

			const dataObj = {
				desc: "Import from socialclub",
				filePath: "tracks/" + name + ".json",
				thumbnail: thumbnail,
				published: true,
				likeCount: 0,
				playedCount: 0,
				createdDate: null,
				updatedDate: null,
				category: author,
				tags: [],
				bestTimes: [],
				contributors: []
			};

			const jsonStr = JSON.stringify(dataObj);
			const escapedName = name.replace(/'/g, "''");
			const escapedData = jsonStr.replace(/'/g, "''");

			return `INSERT INTO tracks (name, data) VALUES ('${escapedName}', '${escapedData}');`;
		}
	};

	const API = {
		request(url) {
			const bearerToken = Utils.getCookie('BearerToken');
			const startTime = performance.now();

			return new Promise((resolve, reject) => {
				const headers = { 'X-Requested-With': 'XMLHttpRequest' };
				if (bearerToken) headers['Authorization'] = 'Bearer ' + bearerToken;

				Utils.logDebug(`[${t('logReqStart')}] GET -> ${url}`, {
					hasAuthHeader: !!bearerToken,
					headers: headers
				});

				GM_xmlhttpRequest({
					method: 'GET',
					url: url,
					headers: headers,
					onload: function (response) {
						const duration = (performance.now() - startTime).toFixed(2);
						const responseSize = response.responseText ? response.responseText.length : 0;

						Utils.logDebug(`[${t('logReqDone')}] Status: ${response.status} | Duration: ${duration}ms | Size: ${responseSize} bytes`);

						if (response.status >= 200 && response.status < 300) {
							try {
								const json = JSON.parse(response.responseText);
								resolve({ status: response.status, data: json, duration });
							} catch (e) {
								Utils.logDebug(`[${t('logParseFail')}]`, { raw: response.responseText.substring(0, 200) });
								reject({ status: response.status, message: 'JSON Parse Error' });
							}
						} else if (response.status === 401) {
							Utils.logDebug(`[${t('logAuthFail')}]`, { responseText: response.responseText });
							reject({ status: 401, message: 'Token Expired / Authorization Failed' });
						} else {
							Utils.logDebug(`[${t('logHttpErr')}] HTTP Status ${response.status}`, { responseText: response.responseText });
							reject({ status: response.status, message: `HTTP Error ${response.status}` });
						}
					},
					onerror: function (err) {
						const duration = (performance.now() - startTime).toFixed(2);
						Utils.logDebug(`[${t('logNetErr')}] Duration: ${duration}ms`, err);
						reject({ status: 0, message: 'Network Error' });
					}
				});
			});
		},

		async getRockstarIdByNickname(nickname) {
			if (!nickname) return null;
			if (STATE.lastAuthorQuery === nickname && STATE.cachedRockstarId) {
				Utils.logDebug(t('logCacheHit', { nickname, id: STATE.cachedRockstarId }));
				return STATE.cachedRockstarId;
			}

			Utils.logDebug(t('logStep1', { nickname }));
			const url = `https://scapi.rockstargames.com/profile/getprofile?nickname=${encodeURIComponent(nickname)}&maxFriends=3`;
			const res = await this.request(url);

			if (res.data && res.data.status === true && res.data.accounts && res.data.accounts.length > 0) {
				const scid = res.data.accounts[0].rockstarAccount?.rockstarId;
				if (scid) {
					STATE.lastAuthorQuery = nickname;
					STATE.cachedRockstarId = scid;
					Utils.logDebug(t('logParseSuccess', { nickname, id: scid }));
					return scid;
				}
			}
			throw new Error(`User "${nickname}" not found.`);
		},

		async fetchJobs(params) {
			if (!params.author) throw new Error(t('emptyAuthorErr'));

			const scid = await this.getRockstarIdByNickname(params.author);
			if (!scid) throw new Error(`User "${params.author}" invalid.`);

			Utils.logDebug(t('logStep2', { author: params.author, id: scid }));
			const url = `https://scapi.rockstargames.com/search/mission?dateRangeCreated=${params.dateRange}&platform=${params.platform}&sort=${params.sort}&title=gtav&pageSize=${params.pageSize}&pageIndex=${params.pageIndex}&creatorRockstarId=${scid}`;

			const res = await this.request(url);
			Utils.logDebug(t('logApiResp'), res.data);
			return res.data;
		}
	};

	const UI = {
		injectStyles() {
			const style = document.createElement('style');
			style.textContent = `
				#rsc-unified-panel {
					position: fixed;
					top: 10px;
					right: 10px;
					width: 860px;
					max-width: calc(100vw - 20px);
					height: 780px;
					max-height: calc(100vh - 20px);
					background: #121212;
					color: #fff;
					border: 1px solid #333;
					border-radius: 8px;
					box-shadow: 0 10px 30px rgba(0,0,0,0.85);
					z-index: 999999;
					font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
					display: flex;
					flex-direction: column;
					overflow: hidden;
					transition: all 0.2s ease;
				}
				#rsc-unified-panel.rsc-collapsed {
					height: auto !important;
					max-height: none !important;
					width: auto !important;
					background: transparent !important;
					border: none !important;
					box-shadow: none !important;
				}
				#rsc-unified-panel.rsc-collapsed .rsc-panel-header {
					background: #121212;
					border: 1px solid #444;
					border-radius: 6px;
					padding: 4px;
					box-shadow: 0 4px 12px rgba(0,0,0,0.5);
				}
				#rsc-unified-panel.rsc-collapsed #rsc-txt-panelTitle,
				#rsc-unified-panel.rsc-collapsed #rsc-lang-select {
					display: none !important;
				}
				#rsc-unified-panel.rsc-collapsed #rsc-panel-content {
					display: none !important;
				}

				.rsc-panel-header {
					background: #1e1e1e;
					padding: 10px 16px;
					font-weight: bold;
					font-size: 14px;
					color: #fcaf17;
					border-bottom: 1px solid #333;
					display: flex;
					justify-content: space-between;
					align-items: center;
					user-select: none;
					flex-shrink: 0;
				}
				.rsc-header-tools {
					display: flex;
					align-items: center;
					gap: 10px;
				}
				.rsc-lang-select {
					background: #2a2a2a;
					color: #fcaf17;
					border: 1px solid #444;
					border-radius: 4px;
					padding: 2px 6px;
					font-size: 11px;
					outline: none;
					cursor: pointer;
				}
				.rsc-icon-btn {
					background: transparent;
					border: none;
					color: #aaa;
					cursor: pointer;
					font-size: 16px;
					padding: 2px 6px;
					line-height: 1;
				}
				.rsc-icon-btn:hover { color: #fff; }

				.rsc-panel-body {
					padding: 14px;
					display: flex;
					flex-direction: column;
					gap: 12px;
					flex: 1;
					overflow: hidden;
				}

				.rsc-controls-card {
					background: #1a1a1a;
					padding: 12px;
					border-radius: 6px;
					border: 1px solid #2a2a2a;
					flex-shrink: 0;
				}
				.rsc-grid-5 {
					display: grid;
					grid-template-columns: 2fr 1fr 1fr 1fr auto;
					gap: 10px;
					align-items: flex-end;
				}
				@media (max-width: 800px) {
					.rsc-grid-5 { grid-template-columns: 1fr 1fr; }
				}
				.rsc-form-group {
					display: flex;
					flex-direction: column;
					gap: 4px;
				}
				.rsc-form-group label {
					font-size: 11px;
					color: #aaa;
				}
				.rsc-input, .rsc-select {
					background: #242424;
					border: 1px solid #444;
					color: #fff;
					padding: 6px 10px;
					border-radius: 4px;
					font-size: 12px;
					outline: none;
					box-sizing: border-box;
				}
				.rsc-input:focus, .rsc-select:focus {
					border-color: #fcaf17;
				}
				.rsc-btn {
					background: #fcaf17;
					color: #000;
					border: none;
					padding: 7px 16px;
					font-weight: bold;
					border-radius: 4px;
					cursor: pointer;
					font-size: 12px;
					transition: background 0.2s;
				}
				.rsc-btn:hover { background: #e5a100; }
				.rsc-btn-sm {
					background: #333;
					color: #ccc;
					border: 1px solid #444;
					padding: 2px 8px;
					font-size: 10px;
					border-radius: 3px;
					cursor: pointer;
				}
				.rsc-btn-sm:hover { background: #444; color: #fff; }

				.rsc-results-area {
					flex: 1;
					min-height: 150px;
					overflow-y: auto;
					display: flex;
					flex-direction: column;
					padding-right: 4px;
				}
				.rsc-placeholder {
					text-align: center;
					padding: 50px 20px;
					color: #666;
					font-size: 13px;
				}
				.rsc-jobs-grid {
					display: grid;
					grid-template-columns: repeat(3, 1fr);
					gap: 12px;
					margin-top: 10px;
				}
				@media (max-width: 640px) {
					.rsc-jobs-grid { grid-template-columns: repeat(2, 1fr); }
				}
				.rsc-card {
					background: #222;
					border-radius: 6px;
					overflow: hidden;
					border: 1px solid #333;
					display: flex;
					flex-direction: column;
					position: relative;
				}
				.rsc-card-img-wrap {
					width: 100%;
					aspect-ratio: 16 / 9;
					background: #000;
					position: relative;
				}
				.rsc-card-img {
					width: 100%;
					height: 100%;
					object-fit: cover;
				}
				.rsc-card-type {
					position: absolute;
					bottom: 4px;
					right: 4px;
					background: rgba(0,0,0,0.8);
					color: #fcaf17;
					padding: 2px 6px;
					font-size: 10px;
					border-radius: 2px;
				}
				.rsc-card-bookmark {
					position: absolute;
					top: 4px;
					right: 4px;
					background: rgba(252, 175, 23, 0.9);
					color: #000;
					padding: 2px 6px;
					font-size: 10px;
					font-weight: bold;
					border-radius: 2px;
					z-index: 5;
				}
				.rsc-card-body {
					padding: 8px 10px;
					display: flex;
					flex-direction: column;
					gap: 4px;
					flex-grow: 1;
				}
				.rsc-card-title {
					font-size: 12px;
					font-weight: bold;
					color: #fff;
					text-decoration: none;
					white-space: nowrap;
					overflow: hidden;
					text-overflow: ellipsis;
				}
				.rsc-card-title:hover { color: #fcaf17; }
				.rsc-card-meta { font-size: 10px; color: #888; }
				.rsc-card-stats {
					display: flex;
					gap: 10px;
					font-size: 10px;
					color: #bbb;
					margin-top: auto;
					padding-top: 4px;
					border-top: 1px solid #2a2a2a;
				}

				.rsc-pagination {
					display: flex;
					justify-content: center;
					align-items: center;
					gap: 6px;
					margin-top: 14px;
					padding-top: 10px;
					border-top: 1px solid #222;
				}
				.rsc-page-btn {
					background: #2a2a2a;
					color: #fff;
					border: 1px solid #333;
					padding: 4px 8px;
					border-radius: 3px;
					cursor: pointer;
					font-size: 11px;
				}
				.rsc-page-btn:hover { background: #333; }
				.rsc-page-btn:disabled { opacity: 0.3; cursor: not-allowed; }
				.rsc-page-info { font-size: 11px; color: #aaa; margin: 0 4px; }

				details.rsc-debug-box {
					background: #080808;
					border: 1px solid #222;
					border-radius: 4px;
					padding: 8px;
					flex-shrink: 0;
				}
				.rsc-debug-summary {
					font-size: 11px;
					color: #888;
					cursor: pointer;
					display: flex;
					justify-content: space-between;
					align-items: center;
				}
				#rsc-debug-content {
					font-family: monospace;
					font-size: 10px;
					color: #00ff00;
					height: 120px;
					max-height: 120px;
					overflow-y: auto;
					white-space: pre-wrap;
					word-break: break-all;
					margin-top: 8px;
					padding: 6px;
					background: #000;
					border-radius: 3px;
				}
			`;
			document.head.appendChild(style);
		},

		buildUnifiedPanel() {
			if (document.getElementById('rsc-unified-panel')) return;

			const panel = document.createElement('div');
			panel.id = 'rsc-unified-panel';

			const debugBoxStyle = DEBUG ? '' : 'style="display: none;"';

			panel.innerHTML = `
				<div class="rsc-panel-header">
					<span id="rsc-txt-panelTitle">${t('panelTitle')}</span>
					<div class="rsc-header-tools">
						<select id="rsc-lang-select" class="rsc-lang-select">
							<option value="en" ${STATE.lang === 'en' ? 'selected' : ''}>English</option>
							<option value="zh" ${STATE.lang === 'zh' ? 'selected' : ''}>中文</option>
						</select>
						<button id="rsc-toggle-btn" class="rsc-icon-btn" type="button" title="Collapse / Expand">—</button>
					</div>
				</div>
				<div id="rsc-panel-content" class="rsc-panel-body">
					<div class="rsc-controls-card">
						<div class="rsc-grid-5">
							<div class="rsc-form-group">
								<label id="rsc-txt-authorLabel">${t('authorLabel')}</label>
								<input type="text" id="rsc-author" class="rsc-input" placeholder="${t('authorPlaceholder')}">
							</div>
							<div class="rsc-form-group">
								<label id="rsc-txt-platformLabel">${t('platformLabel')}</label>
								<select id="rsc-platform" class="rsc-select">
									<option value="pcalt" selected>${t('pcalt')}</option>
									<option value="pc">${t('pc')}</option>
									<option value="ps5">${t('ps5')}</option>
									<option value="ps4">${t('ps4')}</option>
									<option value="xboxone">${t('xboxone')}</option>
									<option value="xboxsx">${t('xboxsx')}</option>
								</select>
							</div>
							<div class="rsc-form-group">
								<label id="rsc-txt-sortLabel">${t('sortLabel')}</label>
								<select id="rsc-sort" class="rsc-select">
									<option value="likes">${t('sortLikes')}</option>
									<option value="plays">${t('sortPlays')}</option>
									<option value="updatedDate" selected>${t('sortUpdatedDate')}</option>
									<option value="createdDate">${t('sortCreatedDate')}</option>
								</select>
							</div>
							<div class="rsc-form-group">
								<label id="rsc-txt-dateLabel">${t('dateLabel')}</label>
								<select id="rsc-date" class="rsc-select">
									<option value="any" selected>${t('dateAny')}</option>
									<option value="today">${t('dateToday')}</option>
									<option value="last7">${t('dateLast7')}</option>
									<option value="lastmonth">${t('dateLastmonth')}</option>
									<option value="lastyear">${t('dateLastyear')}</option>
								</select>
							</div>
							<div class="rsc-form-group">
								<button id="rsc-search-btn" class="rsc-btn" type="button" style="height: 31px; white-space: nowrap;">${t('searchBtn')}</button>
							</div>
						</div>
					</div>

					<div id="rsc-results-area" class="rsc-results-area">
						<div class="rsc-placeholder" id="rsc-txt-placeholder">${t('placeholderInit')}</div>
					</div>

					<details id="rsc-debug-box" class="rsc-debug-box" ${debugBoxStyle}>
						<summary class="rsc-debug-summary">
							<span id="rsc-txt-debugTitle">${t('debugTitle')}</span>
							<button id="rsc-copy-debug-btn" class="rsc-btn-sm" type="button">${t('copyDebugBtn')}</button>
						</summary>
						<pre id="rsc-debug-content">${t('sysReady')}</pre>
					</details>
				</div>
			`;
			document.body.appendChild(panel);
		},

		updateLanguageUI() {
			document.getElementById('rsc-txt-panelTitle').textContent = t('panelTitle');
			document.getElementById('rsc-txt-authorLabel').textContent = t('authorLabel');
			document.getElementById('rsc-author').placeholder = t('authorPlaceholder');
			document.getElementById('rsc-txt-platformLabel').textContent = t('platformLabel');
			document.getElementById('rsc-txt-sortLabel').textContent = t('sortLabel');
			document.getElementById('rsc-txt-dateLabel').textContent = t('dateLabel');
			document.getElementById('rsc-search-btn').textContent = t('searchBtn');
			document.getElementById('rsc-txt-debugTitle').textContent = t('debugTitle');
			document.getElementById('rsc-copy-debug-btn').textContent = t('copyDebugBtn');

			const updateOptions = (selectId, map) => {
				const select = document.getElementById(selectId);
				if (!select) return;
				Array.from(select.options).forEach(opt => {
					if (map[opt.value]) opt.textContent = t(map[opt.value]);
				});
			};

			updateOptions('rsc-platform', { pcalt: 'pcalt', pc: 'pc', ps5: 'ps5', ps4: 'ps4', xboxone: 'xboxone', xboxsx: 'xboxsx' });
			updateOptions('rsc-sort', { likes: 'sortLikes', plays: 'sortPlays', updatedDate: 'sortUpdatedDate', createdDate: 'sortCreatedDate' });
			updateOptions('rsc-date', { any: 'dateAny', today: 'dateToday', last7: 'dateLast7', lastmonth: 'dateLastmonth', lastyear: 'dateLastyear' });

			if (STATE.hasSearched && STATE.lastResponseData) {
				this.renderResults(STATE.lastResponseData);
			} else {
				const placeholder = document.getElementById('rsc-txt-placeholder');
				if (placeholder) placeholder.textContent = t('placeholderInit');
			}
		},

		renderLoading() {
			const container = document.getElementById('rsc-results-area');
			if (container) {
				container.innerHTML = `<div class="rsc-placeholder" style="color:#fcaf17;">${t('loading')}</div>`;
			}
		},

		renderError(msg) {
			const container = document.getElementById('rsc-results-area');
			if (container) {
				container.innerHTML = `<div class="rsc-placeholder" style="color:#ff4d4d;">${t('searchError')}${msg}</div>`;
			}
		},

		renderResults(data) {
			STATE.lastResponseData = data;
			const container = document.getElementById('rsc-results-area');
			if (!container) return;

			const items = data.content?.items || [];
			STATE.currentJobs = items;
			STATE.selectedJobIds.clear();
			STATE.totalItems = data.total || 0;
			STATE.totalPages = Math.max(1, Math.ceil(STATE.totalItems / STATE.pageSize));

			Utils.logDebug(t('logRender', { count: items.length, total: STATE.totalItems, pages: STATE.totalPages }), data);

			if (items.length === 0) {
				container.innerHTML = `<div class="rsc-placeholder">${t('noResults')}</div>`;
				return;
			}

			let html = `
				<div style="display:flex; justify-content:space-between; align-items:center; padding-bottom:6px; border-bottom:1px solid #222;">
					<span style="color:#fcaf17; font-size:13px; font-weight:bold;">${t('resultsTitle', { total: STATE.totalItems })}</span>
					<span style="font-size:11px; color:#aaa;">${t('pageText', { current: STATE.currentPage + 1, total: STATE.totalPages })}</span>
				</div>
				<div class="rsc-batch-bar" style="display:flex; align-items:center; justify-content:space-between; margin-top:8px; padding:6px 10px; background:#1a1a1a; border:1px solid #333; border-radius:4px;">
					<label style="font-size:12px; color:#ccc; display:flex; align-items:center; gap:6px; cursor:pointer;">
						<input type="checkbox" id="rsc-select-all-cb" style="cursor:pointer;" />
						<span id="rsc-txt-selectAll">${t('selectAll')}</span>
					</label>
					<div style="display:flex; gap:8px;">
						<button id="rsc-btn-dl-selected" class="rsc-btn-sm" type="button" style="background:#28a745; color:#fff; font-weight:bold; padding:4px 10px;">${t('btnDownloadSelected', { count: 0 })}</button>
						<button id="rsc-btn-dl-page" class="rsc-btn-sm" type="button" style="background:#17a2b8; color:#fff; font-weight:bold; padding:4px 10px;">${t('btnDownloadPage')}</button>
					</div>
				</div>
				<div class="rsc-jobs-grid">
			`;

			items.forEach(job => {
				const jobUrl = `https://socialclub.rockstargames.com/job/gtav/${job.id}`;
				const category = job.type || job.category || 'Job';
				const createdDate = Utils.formatDate(job.createdDate || job.updatedDate);
				const likes = job.likeCount ?? 0;
				const dislikes = job.dislikeCount ?? 0;
				const plays = job.playedCount ?? 0;
				const isBookmarked = job.bookmarked === true;

				html += `
					<div class="rsc-card" data-job-id="${job.id}">
						<div class="rsc-card-img-wrap">
							<input type="checkbox" class="rsc-job-cb" data-job-id="${job.id}" style="position:absolute; top:6px; left:6px; z-index:10; width:16px; height:16px; cursor:pointer;" />
							<a href="${jobUrl}" target="_blank" style="display:block; width:100%; height:100%;">
								<img class="rsc-card-img" src="${job.imgSrc}" alt="${job.name}" onerror="this.src='https://s.rsg.sc/sc/images/react/default-job.jpg'" />
							</a>
							<button class="rsc-btn-dl-single rsc-btn-sm" data-job-id="${job.id}" type="button" style="position:absolute; bottom:4px; left:4px; z-index:10; background:#fcaf17; color:#000; padding:2px 6px; font-size:10px; border-radius:2px; border:none; cursor:pointer;">${t('btnDownloadSingle')}</button>
							${isBookmarked ? `<span class="rsc-card-bookmark">${t('bookmarked')}</span>` : ''}
							<span class="rsc-card-type">${category}</span>
						</div>
						<div class="rsc-card-body">
							<a class="rsc-card-title" href="${jobUrl}" target="_blank" title="${job.name}">${job.name}</a>
							<div class="rsc-card-meta">
								<span>${t('publishedDate')}${createdDate}</span>
							</div>
							<div class="rsc-card-stats">
								<span>👍 ${likes}</span>
								<span>👎 ${dislikes}</span>
								<span>🎮 ${plays}</span>
							</div>
						</div>
					</div>
				`;
			});

			html += `</div>`;

			html += `
				<div class="rsc-pagination">
					<button class="rsc-page-btn" id="rsc-pg-first" type="button" ${STATE.currentPage === 0 ? 'disabled' : ''}>${t('firstPage')}</button>
					<button class="rsc-page-btn" id="rsc-pg-prev" type="button" ${STATE.currentPage === 0 ? 'disabled' : ''}>${t('prevPage')}</button>
					<span class="rsc-page-info">${STATE.currentPage + 1} / ${STATE.totalPages}</span>
					<button class="rsc-page-btn" id="rsc-pg-next" type="button" ${STATE.currentPage >= STATE.totalPages - 1 ? 'disabled' : ''}>${t('nextPage')}</button>
					<button class="rsc-page-btn" id="rsc-pg-last" type="button" ${STATE.currentPage >= STATE.totalPages - 1 ? 'disabled' : ''}>${t('lastPage')}</button>
					<input type="number" id="rsc-pg-jump-num" class="rsc-input" style="width:50px; text-align:center; padding:2px;" min="1" max="${STATE.totalPages}" value="${STATE.currentPage + 1}">
					<button class="rsc-page-btn" id="rsc-pg-jump" type="button">${t('jumpBtn')}</button>
				</div>
			`;

			container.innerHTML = html;
			this.bindResultsEvents();
		},

		bindPaginationEvents() {
			const firstBtn = document.getElementById('rsc-pg-first');
			const prevBtn = document.getElementById('rsc-pg-prev');
			const nextBtn = document.getElementById('rsc-pg-next');
			const lastBtn = document.getElementById('rsc-pg-last');
			const jumpBtn = document.getElementById('rsc-pg-jump');
			const jumpInput = document.getElementById('rsc-pg-jump-num');

			if (firstBtn) firstBtn.onclick = () => App.goToPage(0);
			if (prevBtn) prevBtn.onclick = () => App.goToPage(STATE.currentPage - 1);
			if (nextBtn) nextBtn.onclick = () => App.goToPage(STATE.currentPage + 1);
			if (lastBtn) lastBtn.onclick = () => App.goToPage(STATE.totalPages - 1);

			const handleJump = () => {
				if (!jumpInput) return;
				let targetPage = parseInt(jumpInput.value, 10);

				if (isNaN(targetPage)) targetPage = 1;
				if (targetPage < 1) targetPage = 1;
				if (targetPage > STATE.totalPages) targetPage = STATE.totalPages;

				jumpInput.value = targetPage;
				App.goToPage(targetPage - 1);
			};

			if (jumpBtn) jumpBtn.onclick = handleJump;
			if (jumpInput) {
				jumpInput.onkeydown = (e) => {
					if (e.key === 'Enter') {
						e.preventDefault();
						handleJump();
					}
				};
			}
		},

		bindResultsEvents() {
			this.bindPaginationEvents();

			const selectAllCb = document.getElementById('rsc-select-all-cb');
			const jobCbs = document.querySelectorAll('.rsc-job-cb');
			const btnDlSelected = document.getElementById('rsc-btn-dl-selected');
			const btnDlPage = document.getElementById('rsc-btn-dl-page');
			const singleBtns = document.querySelectorAll('.rsc-btn-dl-single');

			const updateSelectedBtn = () => {
				if (btnDlSelected) {
					btnDlSelected.textContent = t('btnDownloadSelected', { count: STATE.selectedJobIds.size });
				}
			};

			if (selectAllCb) {
				selectAllCb.onclick = (e) => {
					const checked = e.target.checked;
					jobCbs.forEach(cb => {
						cb.checked = checked;
						const id = cb.getAttribute('data-job-id');
						if (checked) STATE.selectedJobIds.add(id);
						else STATE.selectedJobIds.delete(id);
					});
					updateSelectedBtn();
				};
			}

			jobCbs.forEach(cb => {
				cb.onclick = () => {
					const id = cb.getAttribute('data-job-id');
					if (cb.checked) STATE.selectedJobIds.add(id);
					else STATE.selectedJobIds.delete(id);

					if (selectAllCb) {
						selectAllCb.checked = STATE.selectedJobIds.size === STATE.currentJobs.length;
					}
					updateSelectedBtn();
				};
			});

			singleBtns.forEach(btn => {
				btn.onclick = async (e) => {
					e.preventDefault();
					const jobId = btn.getAttribute('data-job-id');
					const job = STATE.currentJobs.find(j => String(j.id) === String(jobId));
					if (job) {
						await App.downloadSingleJob(job, btn);
					}
				};
			});

			if (btnDlSelected) {
				btnDlSelected.onclick = () => App.downloadSelectedJobs();
			}

			if (btnDlPage) {
				btnDlPage.onclick = () => App.downloadPageJobs();
			}
		}
	};

	const App = {
		init() {
			UI.injectStyles();
			UI.buildUnifiedPanel();
			this.bindEvents();
			Utils.logDebug(`${t('logInit')} [Language: ${STATE.lang}]`);
		},

		bindEvents() {
			const panel = document.getElementById('rsc-unified-panel');
			const searchBtn = document.getElementById('rsc-search-btn');
			const toggleBtn = document.getElementById('rsc-toggle-btn');
			const copyDebugBtn = document.getElementById('rsc-copy-debug-btn');
			const langSelect = document.getElementById('rsc-lang-select');

			langSelect.addEventListener('change', (e) => {
				STATE.lang = e.target.value;
				Utils.logDebug(t('logLangChange', { lang: STATE.lang }));
				UI.updateLanguageUI();
			});

			searchBtn.addEventListener('click', (e) => {
				e.preventDefault();
				STATE.currentPage = 0;
				this.executeSearch();
			});

			['rsc-sort', 'rsc-platform', 'rsc-date'].forEach(selectId => {
				const selectEl = document.getElementById(selectId);
				if (selectEl) {
					selectEl.addEventListener('change', () => {
						if (STATE.hasSearched) {
							STATE.currentPage = 0;
							this.executeSearch();
						}
					});
				}
			});

			let isCollapsed = false;
			toggleBtn.addEventListener('click', (e) => {
				e.preventDefault();
				isCollapsed = !isCollapsed;
				panel.classList.toggle('rsc-collapsed', isCollapsed);
				toggleBtn.textContent = isCollapsed ? '+' : '—';
			});

			copyDebugBtn.addEventListener('click', async (e) => {
				e.preventDefault();
				e.stopPropagation();
				const debugContent = document.getElementById('rsc-debug-content');
				if (debugContent && debugContent.textContent) {
					const success = await Utils.copyToClipboard(debugContent.textContent);
					if (success) {
						const originalText = copyDebugBtn.textContent;
						copyDebugBtn.textContent = t('copySuccess');
						setTimeout(() => {
							copyDebugBtn.textContent = originalText;
						}, 2000);
					} else {
						alert(t('copyFail'));
					}
				}
			});
		},

		getFormParams() {
			return {
				author: document.getElementById('rsc-author').value.trim(),
				platform: document.getElementById('rsc-platform').value,
				sort: document.getElementById('rsc-sort').value,
				dateRange: document.getElementById('rsc-date').value,
				pageSize: STATE.pageSize,
				pageIndex: STATE.currentPage
			};
		},

		async executeSearch() {
			const params = this.getFormParams();
			STATE.lastQueryParams = params;

			if (!params.author) {
				Utils.logDebug(t('logSearchCancel'));
				UI.renderError(t('emptyAuthorErr'));
				return;
			}

			UI.renderLoading();
			Utils.logDebug(t('logSearchStart', { page: params.pageIndex + 1 }), params);

			try {
				const data = await API.fetchJobs(params);
				STATE.hasSearched = true;
				UI.renderResults(data);
			} catch (err) {
				Utils.logDebug(t('logSearchErr', { msg: err.message }), err);
				UI.renderError(err.message || 'Error occurred during network request.');
			}
		},

		goToPage(pageIndex) {
			let targetIndex = pageIndex;

			if (targetIndex < 0) {
				targetIndex = 0;
			}
			if (targetIndex >= STATE.totalPages) {
				targetIndex = Math.max(0, STATE.totalPages - 1);
			}

			if (STATE.hasSearched && targetIndex === STATE.currentPage) return;

			Utils.logDebug(t('logPageSwitch', { orig: pageIndex, target: targetIndex, page: targetIndex + 1 }));
			STATE.currentPage = targetIndex;
			this.executeSearch();

			const resultsArea = document.getElementById('rsc-results-area');
			if (resultsArea) resultsArea.scrollTop = 0;
		},

		async processJobDownload(job, onProgress) {
			const sanitizedName = Utils.sanitizeJobName(job.name);
			Utils.logDebug(t('logDownloadStart', { name: job.name }));

			let jsonContent = null;
			try {
				const res = await findJsonForImage(job.imgSrc, onProgress);
				if (res && res.content) {
					jsonContent = res.content;
					Utils.logDebug(t('logDownloadSuccess', { name: job.name }));
				}
			} catch (e) {
				console.error(e);
			}

			if (!jsonContent) {
				Utils.logDebug(t('logDownloadFailed', { name: job.name }));
				jsonContent = JSON.stringify(job, null, 2);
			}

			const sqlContent = Utils.generateJobSql(job, STATE.lastAuthorQuery);

			return {
				sanitizedName,
				jsonContent,
				sqlContent
			};
		},

		async downloadSingleJob(job, btnEl) {
			if (STATE.isDownloadingBatch) return;
			const origText = btnEl ? btnEl.textContent : '';
			if (btnEl) {
				btnEl.disabled = true;
				btnEl.textContent = '⌛...';
			}

			try {
				const { sanitizedName, jsonContent, sqlContent } = await this.processJobDownload(job, (tried) => {
					if (btnEl) btnEl.textContent = `⌛ ${tried}`;
				});

				Utils.downloadFile(`${sanitizedName}.json`, jsonContent, 'application/json');
				Utils.downloadFile(`${sanitizedName}.sql`, sqlContent, 'text/plain');
			} finally {
				if (btnEl) {
					btnEl.disabled = false;
					btnEl.textContent = origText;
				}
			}
		},

		async downloadMultipleJobs(jobs, batchName) {
			if (STATE.isDownloadingBatch || !jobs || jobs.length === 0) return;
			STATE.isDownloadingBatch = true;

			const btnDlSelected = document.getElementById('rsc-btn-dl-selected');
			const btnDlPage = document.getElementById('rsc-btn-dl-page');
			if (btnDlSelected) btnDlSelected.disabled = true;
			if (btnDlPage) btnDlPage.disabled = true;

			const sqlList = [];
			const total = jobs.length;

			for (let idx = 0; idx < total; idx++) {
				const job = jobs[idx];
				if (btnDlSelected) {
					btnDlSelected.textContent = t('processing', { current: idx + 1, total });
				}

				const btnEl = document.querySelector(`.rsc-btn-dl-single[data-job-id="${job.id}"]`);
				const origText = btnEl ? btnEl.textContent : '';
				if (btnEl) {
					btnEl.disabled = true;
					btnEl.textContent = '⌛...';
				}

				let sanitizedName, jsonContent, sqlContent;
				try {
					const result = await this.processJobDownload(job, (tried) => {
						if (btnEl) btnEl.textContent = `⌛ ${tried}`;
					});
					sanitizedName = result.sanitizedName;
					jsonContent = result.jsonContent;
					sqlContent = result.sqlContent;
				} finally {
					if (btnEl) {
						btnEl.disabled = false;
						btnEl.textContent = origText;
					}
				}

				sqlList.push(`-- Track: ${job.name}\n${sqlContent}`);

				Utils.downloadFile(`${sanitizedName}.json`, jsonContent, 'application/json');
				await new Promise(res => setTimeout(res, 250));
			}

			const author = STATE.lastAuthorQuery || 'author';
			const combinedSql = `-- Generated SQL for ${author} (${batchName})\n-- Total Tracks: ${sqlList.length}\n\n` + sqlList.join('\n\n');
			const sqlFileName = `${author}_${batchName}_tracks.sql`.replace(/[\\/:"*?<>|]/g, '_');
			Utils.downloadFile(sqlFileName, combinedSql, 'text/plain');

			STATE.isDownloadingBatch = false;
			if (btnDlSelected) btnDlSelected.disabled = false;
			if (btnDlPage) btnDlPage.disabled = false;

			const btnSelect = document.getElementById('rsc-btn-dl-selected');
			if (btnSelect) {
				btnSelect.textContent = t('btnDownloadSelected', { count: STATE.selectedJobIds.size });
			}
		},

		async downloadSelectedJobs() {
			const selectedJobs = STATE.currentJobs.filter(j => STATE.selectedJobIds.has(String(j.id)));
			if (selectedJobs.length === 0) {
				alert(t('noJobSelected'));
				return;
			}
			await this.downloadMultipleJobs(selectedJobs, `selected_${selectedJobs.length}`);
		},

		async downloadPageJobs() {
			if (!STATE.currentJobs || STATE.currentJobs.length === 0) return;
			await this.downloadMultipleJobs(STATE.currentJobs, `page_${STATE.currentPage + 1}`);
		}
	};

	setTimeout(() => {
		App.init();
	}, 1500);

})();