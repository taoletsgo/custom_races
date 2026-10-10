// ==UserScript==
// @name			Rockstar Bookmarked Jobs Exporter
// @version			0.1
// @description		Export GTA Online bookmarked jobs to FiveM server
// @match			https://socialclub.rockstargames.com/jobs*
// @grant			none
// @require			https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js
// ==/UserScript==

(function () {
	'use strict';

	let lang = (function () {
		const navLang = navigator.language || navigator.userLanguage || 'en';
		return navLang.toLowerCase().includes('zh') ? 'zh' : 'en';
	})();

	const textMap = {
		zh: {
			pc: '💻 PC 收藏任务',
			ps5: '🎮 PS5 收藏任务',
			xbox: '🟢 Xbox 收藏任务',
			exporting: '正在导出 ...',
			copied: '✅ 已复制 {count} 条 收藏任务',
			unauthorized: '❌ 未授权，请刷新页面重新登录 Rockstar',
			networkError: '❌ 网络请求失败，请检查网络或刷新页面',
		},
		en: {
			pc: '💻 PC Bookmarked Jobs',
			ps5: '🎮 PS5 Bookmarked Jobs',
			xbox: '🟢 Xbox Bookmarked Jobs',
			exporting: 'Exporting ...',
			copied: '✅ Copied {count} bookmarked jobs',
			unauthorized: '❌ Unauthorized, please refresh the page and login again',
			networkError: '❌ Network request failed, please check your connection or refresh the page',
		}
	};

	function getCookie(e) {
		for (var t = e + "=", r = decodeURIComponent(document.cookie).split(";"), o = 0; o < r.length; o++) {
			for (var n = r[o];
				 " " == n.charAt(0);) n = n.substring(1);
			if (0 == n.indexOf(t)) return n.substring(t.length, n.length)
		}
		return ""
	}

	function sleep(ms) { return new Promise(r => setTimeout(r, ms)); }
	function copy(text) { navigator.clipboard.writeText(text); }

	function createUI() {
		if ($('#rsBookmarkExportContainer').length) return;

		const container = $(`
			<div id="rsBookmarkExportContainer" style="
				position: fixed;
				top: 0;
				left: 0;
				height: 100vh;
				display: flex;
				flex-direction: column;
				justify-content: center;
				align-items: flex-start;
				gap: 6px;
				padding-left: 6px;
				z-index: 99999;
			"></div>
		`);

		const langBtn = $(`
			<div class="langBtn" style="
				background:#111;
				color:#fff;
				padding:8px 16px;
				border-radius:0 6px 6px 0;
				cursor:pointer;
				font-size:13px;
				box-shadow:0 0 10px rgba(0,0,0,.6);
				user-select:none;
				white-space:nowrap;
				width:10vw;
				display:flex;
				align-items:center;
				justify-content:center;
				text-align:center;
			">English / 中文</div>
		`);
		langBtn.data('origStyle', langBtn.attr('style'));
		container.append(langBtn);

		langBtn.on('click', function () {
			lang = (lang === 'zh') ? 'en' : 'zh';
			updateAllTexts();
		});

		const buttonsCfg = [
			{ platform: 'pcalt', key: 'pc' },
			{ platform: 'ps5', key: 'ps5' },
			{ platform: 'xboxsx', key: 'xbox' }
		];

		const allBtns = [];

		buttonsCfg.forEach(cfg => {
			const btn = $(`
				<div class="rsExportBtn" style="
					background:#111;
					color:#fff;
					padding:8px 16px;
					border-radius:0 6px 6px 0;
					cursor:pointer;
					font-size:13px;
					box-shadow:0 0 10px rgba(0,0,0,.6);
					user-select:none;
					white-space:nowrap;
					width:10vw;
					display:flex;
					align-items:center;
					justify-content:center;
					text-align:center;
				">${textMap[lang][cfg.key]}</div>
			`);
			btn.data('platform', cfg.platform);
			btn.data('key', cfg.key);
			btn.data('exporting', false);
			btn.data('disabled', false);
			btn.data('origStyle', btn.attr('style'));
			allBtns.push(btn);
			container.append(btn);

			btn.on('click', async function () {
				if ($(this).data('disabled')) return;

				const activeBtn = $(this);

				[...allBtns, langBtn].forEach($b => {
					$b.data('disabled', true);
					const orig = $b.attr('style') || '';
					$b.attr('style', orig + '; opacity:0.6; cursor:not-allowed; pointer-events:none; filter:grayscale(30%);');
				});

				activeBtn.data('exporting', true);
				activeBtn.text(`${textMap[lang].exporting} (0%)`);

				try {
					await exportPlatform(activeBtn.data('platform'), activeBtn);
				} catch (err) {
					if (err === 401) alert(textMap[lang].unauthorized);
					else alert(textMap[lang].networkError + `\n(${err.status || err})`);
				}

				[...allBtns, langBtn].forEach($b => {
					$b.data('disabled', false);
					const origStyle = $b.data('origStyle');
					if (origStyle) $b.attr('style', origStyle);
				});

				activeBtn.data('exporting', false);
				updateAllTexts();
			});
		});

		$('body').append(container);

		function updateAllTexts() {
			allBtns.forEach($b => $b.text(textMap[lang][$b.data('key')]));
		}

		updateAllTexts();
	}

	async function exportPlatform(platform, activeBtn) {
		const bearer = getCookie('BearerToken');
		if (!bearer) throw 401;

		const results = new Map();
		let pageIndex = 0;
		let hasMore = true;
		let total = 0;

		const BASE_DELAY = 800;
		const RETRY_DELAY = 3000;
		const MAX_RETRY = 3;

		while (hasMore) {
			let data = null;
			let retry = 0;

			while (retry <= MAX_RETRY) {
				try {
					const url =
						'https://scapi.rockstargames.com/search/mission?' +
						'dateRangeCreated=any' +
						'&sort=createdDate' +
						'&filter=myBookmarks' +
						'&title=gtav' +
						'&includeCommentCount=true' +
						'&pageSize=15' +
						'&searchTerm=' +
						`&platform=${platform}` +
						`&pageIndex=${pageIndex}`;

					data = await $.ajax({
						method: 'GET',
						url,
						beforeSend: req => {
							req.setRequestHeader('Authorization', 'Bearer ' + bearer);
							req.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
						}
					});
					break;
				} catch (err) {
					if (err.status === 401) throw 401;
					if (err.status === 429 && retry < MAX_RETRY) {
						retry++;
						console.warn(`[429] ${platform} page ${pageIndex}, retry ${retry}`);
						await sleep(RETRY_DELAY * retry);
					} else throw err;
				}
			}

			if (!data || data.status !== true) break;

			const items = data.content?.items || [];
			total = data.total || total;

			for (const job of items) {
				if (!results.has(job.id)) results.set(job.id, { name: job.name, image: job.imgSrc });
			}

			if (total > 0) {
				const progress = Math.min(100, (results.size / total) * 100);
				activeBtn.text(`${textMap[lang].exporting} (${progress.toFixed(2)}%)`);
			}

			hasMore = data.hasMore === true;
			pageIndex++;
			await sleep(BASE_DELAY);
		}

		const resultArray = Array.from(results.values());
		copy(JSON.stringify(resultArray, null, 2));
		alert(textMap[lang].copied.replace('{count}', resultArray.length));
	}

	setTimeout(createUI, 3000);
})();