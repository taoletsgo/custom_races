// ==UserScript==
// @name			Rockstar UGC JSON Searcher
// @version			0.2
// @description		Search GTA Online jobs for FiveM server
// @match			https://socialclub.rockstargames.com/*
// @match			https://prod.cloud.rockstargames.com/ugc/*
// @grant			GM_xmlhttpRequest
// @grant			GM_setClipboard
// @connect			prod.cloud.rockstargames.com
// ==/UserScript==

(function () {
	'use strict';

	let lang = (function () {
		const navLang = navigator.language || navigator.userLanguage || 'en';
		return navLang.toLowerCase().includes('zh') ? 'zh' : 'en';
	})();

	const textMap = {
		zh: {
			copyImage: '复制图片地址',
			copyJson: '复制 JSON 地址',
			fastQueryJson: '更快的查询',
			cancel: '取消',
			progressQuery: '已查询 {tried} 次',
			copiedSuccessImage: '已复制图片地址',
			copiedSuccessJson: '已复制 JSON 地址',
			copyingFailed: '复制失败：无法访问剪贴板权限',
			networkError: '网络请求失败，请刷新页面',
			notFoundJson: '未找到有效 JSON'
		},
		en: {
			copyImage: 'Copy image URL',
			copyJson: 'Copy JSON URL',
			fastQueryJson: 'Quickly query',
			cancel: 'Cancel',
			progressQuery: 'Queried {tried} times',
			copiedSuccessImage: 'Image URL copied',
			copiedSuccessJson: 'JSON URL copied',
			copyingFailed: 'Copy failed: clipboard permission deny',
			networkError: 'Network request failed, please refresh the page',
			notFoundJson: 'No valid JSON found'
		}
	};

	const T = textMap[lang] || textMap.en;

	function tpl(template, vars = {}) {
		return template.replace(/\{([^}]+)\}/g, (_, k) => (k in vars ? vars[k] : `{${k}}`));
	}

	const MAX_CONCURRENT = 13;
	const LANGS = ["en", "ja", "zh", "zh-cn", "fr", "de", "it", "ru", "pt", "pl", "ko", "es", "es-mx"];
	const MAX_I = 3;
	const MAX_J = 500;
	const MAX_RETRY = 3;
	const RETRY_DELAY_MS = 500;

	const style = document.createElement('style');
	style.textContent = `
	.tm-ugc-btn-wrap {
		position: absolute;
		top: 6px;
		left: 6px;
		display: flex;
		gap: 6px;
		z-index: 99999;
		pointer-events: auto;
	}
	.tm-ugc-btn {
		background: rgba(0,0,0,0.75);
		color: #fff;
		border: none;
		padding: 6px 8px;
		border-radius: 6px;
		font-size: 12px;
		cursor: pointer;
		line-height: 1;
	}
	.tm-ugc-btn[disabled] {
		opacity: 0.55;
		cursor: not-allowed;
	}
	.tm-ugc-wrapper-inline {
		display: inline-block;
		position: relative;
		line-height: 0;
	}
	body > .tm-ugc-wrapper-inline {
		display: block;
		margin: auto;
	}
	body > .tm-ugc-wrapper-inline > img {
		display: block;
		margin: 0 auto;
	}
	`;
	document.head.appendChild(style);

	let globalCopyLocked = false;

	function setAllCopyButtonsDisabled(state) {
		globalCopyLocked = !!state;
		const btns = document.querySelectorAll('.tm-ugc-btn');
		btns.forEach(b => {
			try {
				if (b.classList && b.classList.contains('tm-ugc-btn-cancel')) return;
				b.disabled = globalCopyLocked;
			} catch (e) {}
		});
	}

	async function copyToClipboard(text) {
		try {
			if (navigator.clipboard && navigator.clipboard.writeText) {
				await navigator.clipboard.writeText(text);
			} else {
				GM_setClipboard(text);
			}
			return true;
		} catch {
			try {
				GM_setClipboard(text);
				return true;
			} catch {
				return false;
			}
		}
	}

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
		if (location.hostname === 'prod.cloud.rockstargames.com') {
			return (async () => {
				try {
					const controller = new AbortController();
					const signal = controller.signal;

					try { if (activeReqs && controller) activeReqs.add(controller); } catch (e) {}

					const resp = await fetch(url, { method: 'GET', signal });
					const text = await resp.text();

					try { if (activeReqs) activeReqs.delete(controller); } catch (e) {}

					return { status: resp.status, responseText: text };
				} catch (e) {
					try {
						if (activeReqs) {
							for (const it of Array.from(activeReqs)) {
								try {
									if (it instanceof AbortController) activeReqs.delete(it);
								} catch (ee) {}
							}
						}
					} catch (ee) {}
					return null;
				}
			})();
		} else {
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
	}

	async function findJsonUrlForImage(imageUrl, onProgress, token = { cancelled: false }) {
		const folder = imageUrl.replace(/\/[^/]+$/, '');
		const nextUrl = createUrlGenerator(folder);
		let triedCount = 0;
		let found = null;
		let activeTasks = 0;
		const activeReqs = new Set();

		token._abort = function () {
			try {
				for (const r of activeReqs) {
					try {
						if (!r) continue;
						if (typeof r.abort === 'function') {
							try { r.abort(); } catch (e) {}
						} else if (r instanceof AbortController) {
							try { r.abort(); } catch (e) {}
						}
					} catch (e) {}
				}
			} catch (e) {}
			activeReqs.clear();
		};

		function delay(ms) { return new Promise(res => setTimeout(res, ms)); }

		async function attemptUrl(url) {
			for (let attempt = 0; attempt <= MAX_RETRY && !found && !token.cancelled; attempt++) {
				if (attempt > 0) await delay(RETRY_DELAY_MS);
				const res = await gmRequest(url, activeReqs);
				if (token.cancelled) return;

				if (res && res.status === 200) {
					found = url;
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

		try {
			token._abort = null;
			for (const r of activeReqs) {
				try {
					if (!r) continue;
					if (typeof r.abort === 'function') {
						try { r.abort(); } catch (e) {}
					} else if (r instanceof AbortController) {
						try { r.abort(); } catch (e) {}
					}
				} catch (e) {}
			}
			activeReqs.clear();
		} catch (e) {}

		return found;
	}

	function wrapImageInline(img) {
		if (!img || !img.parentElement) return null;
		let p = img.parentElement;
		if (p.classList && p.classList.contains('tm-ugc-wrapper-inline')) return p;

		const wrapper = document.createElement('div');
		wrapper.className = 'tm-ugc-wrapper-inline';

		try {
			p.insertBefore(wrapper, img);
			wrapper.appendChild(img);
			return wrapper;
		} catch (e) {
			return null;
		}
	}

	function injectButtons(card) {
		if (card._tmAdded) return;

		let img = card.querySelector('img') || (card.tagName === 'IMG' ? card : null);

		if ((location.hostname === 'prod.cloud.rockstargames.com') && (!img || img.parentElement === document.body)) {
			const bodyImg = document.querySelector('body > img');
			if (bodyImg) {
				const wrapper = wrapImageInline(bodyImg) || document.body;
				img = bodyImg;
				card = wrapper;
			}
		}

		if (!img) return;
		if (getComputedStyle(card).position === 'static') {
			card.style.position = 'relative';
		}

		const wrap = document.createElement('div');
		wrap.className = 'tm-ugc-btn-wrap';

		const btnImg = document.createElement('button');
		btnImg.className = 'tm-ugc-btn';
		btnImg.textContent = T.copyImage;
		btnImg.type = 'button';

		const btnJson = document.createElement('button');
		btnJson.className = 'tm-ugc-btn';
		btnJson.textContent = T.copyJson;
		btnJson.type = 'button';

		const btnCancel = document.createElement('button');
		btnCancel.className = 'tm-ugc-btn tm-ugc-btn-cancel';
		btnCancel.textContent = T.cancel;
		btnCancel.type = 'button';
		btnCancel.style.display = 'none';

		let btnFast = null;
		if (location.hostname === 'socialclub.rockstargames.com') {
			btnFast = document.createElement('button');
			btnFast.className = 'tm-ugc-btn tm-ugc-btn-fast';
			btnFast.textContent = T.fastQueryJson;
			btnFast.type = 'button';
		}

		if (globalCopyLocked) {
			btnImg.disabled = true;
			btnJson.disabled = true;
			if (btnFast) btnFast.disabled = true;
		}

		if (btnFast) wrap.append(btnImg, btnJson, btnFast, btnCancel);
		else wrap.append(btnImg, btnJson, btnCancel);

		card.appendChild(wrap);
		card._tmAdded = true;

		function stopEvent(e) {
			e?.preventDefault?.();
			e?.stopImmediatePropagation?.();
			e?.stopPropagation?.();
		}

		btnImg.addEventListener('click', async e => {
			stopEvent(e);
			if (globalCopyLocked) return;

			setAllCopyButtonsDisabled(true);
			try {
				const ok = await copyToClipboard(img.src || '');
				alert(ok ? T.copiedSuccessImage : T.copyingFailed);
			} finally {
				setAllCopyButtonsDisabled(false);
			}
		}, { capture: true });

		btnJson.addEventListener('click', async e => {
			stopEvent(e);
			if (globalCopyLocked) return;

			const token = { cancelled: false, _abort: null };
			btnJson._tmToken = token;
			setAllCopyButtonsDisabled(true);
			btnJson.textContent = tpl(T.progressQuery, { tried: 0 });
			btnCancel.style.display = '';
			btnCancel.disabled = false;

			const onCancel = () => {
				if (token.cancelled) return;
				token.cancelled = true;

				try {
					if (token._abort && typeof token._abort === 'function') {
						token._abort();
					}
				} catch (e) {}

				btnJson.textContent = T.copyJson;
				btnCancel.style.display = 'none';
				setAllCopyButtonsDisabled(false);
			};

			btnCancel.onclick = (ev) => {
				stopEvent(ev);
				onCancel();
			};

			try {
				const foundUrl = await findJsonUrlForImage(img.src, (tried) => {
					if (token.cancelled) return;
					btnJson.textContent = tpl(T.progressQuery, { tried });
				}, token);

				if (token.cancelled) return;

				if (foundUrl) {
					const ok = await copyToClipboard(foundUrl);
					alert(ok ? T.copiedSuccessJson : T.copyingFailed);
				} else {
					alert(T.notFoundJson);
				}
			} catch (err) {
				if (!token.cancelled) alert(T.networkError);
			} finally {
				btnJson.textContent = T.copyJson;
				btnCancel.style.display = 'none';
				setAllCopyButtonsDisabled(false);
			}
		}, { capture: true });

		if (btnFast) {
			btnFast.addEventListener('click', e => {
				stopEvent(e);
				try { window.open(img.src || '', '_blank'); } catch (e) {}
			}, { capture: true });
		}
	}

	function scan() {
		const selectors = [
			'a.UgcCard__wrap__DALsI',
			'.UgcCard__wrap__DALsI',
			'.Ugc__missionImageWrapper__FCyA3',
			'img.Ugc__missionImage__NnYdM'
		];

		const nodes = document.querySelectorAll(selectors.join(','));
		nodes.forEach(node => {
			if (node.tagName === 'IMG') {
				const wrapper = node.closest('.Ugc__missionImageWrapper__FCyA3') || node.parentElement || node;
				injectButtons(wrapper);
			} else {
				injectButtons(node);
			}
		});

		try {
			if (location.hostname === 'prod.cloud.rockstargames.com') {
				const bodyImg = document.querySelector('body > img');
				if (bodyImg) {
					const wrapper = wrapImageInline(bodyImg) || document.body;
					injectButtons(wrapper);
				}
			}
		} catch (e) {}
	}

	new MutationObserver(scan).observe(document.body, {
		childList: true,
		subtree: true
	});
	scan();

})();