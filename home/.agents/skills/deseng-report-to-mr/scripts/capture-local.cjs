#!/usr/bin/env node
'use strict';
/**
 * Capture light and dark screenshots of one region of the local Dash server
 * (the Rex `prod` tab, https://localhost:7445) through the debug Chrome on
 * port 9222 that dash-browser-verify uses.
 *
 * Usage (from the Stratus repo root, so Playwright resolves):
 *   NODE_PATH=$(ls -d node_modules/.pnpm/playwright@*\/node_modules | head -1) \
 *   ROUTE='workers/services/view/<worker>/production/settings' \
 *   TARGET='button[aria-label="E2E_VERSION"]' \
 *   CLIP_TO='table' HEADER='variables and secrets' \
 *   node capture-local.cjs <label> [outDir]
 *
 * Writes <outDir>/<label>-light.png and <outDir>/<label>-dark.png (default
 * outDir /tmp). Prints the target's class attribute for each capture so you
 * can confirm which code version rendered.
 *
 * Env:
 *   ACCOUNT_NAME  account to test in (default "Burrito Bot"; resolved by name)
 *   ROUTE         path after /<accountId>/
 *   TARGET        CSS selector for the changed element (must be unique)
 *   CLIP_TO       closest() selector to crop to (default: the target itself)
 *   HEADER        optional regex for a heading just above CLIP_TO to include
 *   DASH_BASE     default https://localhost:7445
 *
 * Dark mode is toggled client-side (html.dark-mode + data-mode) so the user's
 * persisted Appearance preference is never changed.
 */

const { chromium } = require('playwright');

const SESSION_COOKIES = ['vses2', 'edgesessions_enabled', 'CF_AppSession', '__cf_logged_in', 'curr-account'];
const label = process.argv[2];
const outDir = process.argv[3] || '/tmp';
const base = process.env.DASH_BASE || 'https://localhost:7445';
const accountName = process.env.ACCOUNT_NAME || 'Burrito Bot';
const { ROUTE, TARGET } = process.env;
const clipTo = process.env.CLIP_TO || '';
const header = process.env.HEADER || '';

if (!label || !ROUTE || !TARGET) {
  console.error('Usage: ROUTE=... TARGET=... node capture-local.cjs <label> [outDir]');
  process.exit(1);
}

(async () => {
  const browser = await chromium.connectOverCDP('http://127.0.0.1:9222');
  const context = browser.contexts()[0];

  const live = await context.cookies('https://dash.cloudflare.com');
  const seed = live
    .filter(c => SESSION_COOKIES.includes(c.name))
    .map(c => ({ name: c.name, value: c.value, domain: new URL(base).hostname, path: '/', httpOnly: c.httpOnly, secure: true, sameSite: 'Lax' }));
  if (!seed.some(c => c.name === 'vses2')) throw new Error('No vses2 cookie: log the debug Chrome into dash.cloudflare.com first.');
  await context.addCookies(seed);

  const page = await context.newPage();
  await page.setViewportSize({ width: 1440, height: 1000 });
  await page.goto(base + '/', { waitUntil: 'domcontentloaded', timeout: 120000 });
  const accountId = await page.evaluate(async name => {
    const j = await (await fetch('/api/v4/accounts?per_page=50&name=' + encodeURIComponent(name))).json();
    const match = (j.result || []).find(a => a.name === name);
    return match ? match.id : null;
  }, accountName);
  if (!accountId) throw new Error(`Account "${accountName}" not found for this login.`);

  await page.goto(`${base}/${accountId}/${ROUTE}`, { waitUntil: 'domcontentloaded', timeout: 120000 });
  const target = page.locator(TARGET);
  await target.waitFor({ state: 'visible', timeout: 90000 });
  if ((await target.count()) !== 1) throw new Error(`TARGET matched ${await target.count()} elements; it must be unique.`);

  for (const mode of ['light', 'dark']) {
    await page.evaluate(m => {
      const el = document.documentElement;
      el.classList.toggle('dark-mode', m === 'dark');
      if (m === 'dark') el.setAttribute('data-mode', 'dark');
      else el.removeAttribute('data-mode');
    }, mode);
    await page.mouse.move(0, 0);
    await target.scrollIntoViewIfNeeded();
    await page.evaluate(() => window.scrollBy(0, -180));
    await page.waitForTimeout(1500);

    const clip = await page.evaluate(
      ({ selector, clipSelector, headerPattern }) => {
        const t = document.querySelector(selector);
        const region = (clipSelector && t.closest(clipSelector)) || t;
        const r = region.getBoundingClientRect();
        let top = r.top;
        if (headerPattern) {
          const re = new RegExp(headerPattern, 'i');
          for (const el of document.querySelectorAll('h1,h2,h3,h4,[role="heading"],span,div')) {
            const hr = el.getBoundingClientRect();
            if (hr.bottom <= r.top && r.top - hr.bottom < 120 && re.test(el.textContent || '') && el.children.length < 6) top = Math.min(top, hr.top);
          }
        }
        top = Math.max(0, top - 16);
        return { x: Math.max(0, r.left - 16), y: top, width: r.width + 32, height: r.bottom - top + 16 };
      },
      { selector: TARGET, clipSelector: clipTo, headerPattern: header }
    );

    const path = `${outDir}/${label}-${mode}.png`;
    await page.screenshot({ path, clip });
    console.log(`${path}  target class: ${await target.getAttribute('class')}`);
  }

  await page.close();
  await browser.close();
})().catch(error => {
  console.error(error.message || error);
  process.exit(1);
});
