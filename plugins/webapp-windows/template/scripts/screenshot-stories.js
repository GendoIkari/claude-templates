// Screenshots Storybook stories so a reviewer can look at the design.
//
// Usage: node scripts/screenshot-stories.js [filter...]
// Needs a static Storybook in storybook-static/ (pnpm build-storybook).
// Each filter keeps the stories whose id or title contains it (case-insensitive);
// without filters every story is captured. Every story is captured at desktop
// width in light mode and at phone width in dark mode, into .design-review/.

import { chromium } from 'playwright';
import { createServer } from 'node:http';
import { mkdir, readFile, rm } from 'node:fs/promises';
import { extname, join, normalize, resolve } from 'node:path';

const root = resolve('storybook-static');
const out = resolve('.design-review');
const filters = process.argv.slice(2).map((filter) => filter.toLowerCase());

const variants = [
	{ name: 'desktop-light', viewport: { width: 1280, height: 800 }, colorScheme: 'light' },
	{ name: 'mobile-dark', viewport: { width: 390, height: 844 }, colorScheme: 'dark' }
];

const contentTypes = {
	'.html': 'text/html',
	'.js': 'text/javascript',
	'.mjs': 'text/javascript',
	'.css': 'text/css',
	'.json': 'application/json',
	'.svg': 'image/svg+xml',
	'.png': 'image/png',
	'.woff2': 'font/woff2'
};

const index = JSON.parse(await readFile(join(root, 'index.json'), 'utf8'));
const stories = Object.values(index.entries).filter(
	(entry) =>
		entry.type === 'story' &&
		(filters.length === 0 ||
			filters.some((filter) => `${entry.id} ${entry.title}`.toLowerCase().includes(filter)))
);

if (stories.length === 0) {
	console.error('No story matches the filters.');
	process.exit(1);
}

const server = createServer(async (request, response) => {
	const path = normalize(decodeURIComponent(new URL(request.url, 'http://localhost').pathname));
	const file = join(root, path.endsWith('/') ? join(path, 'index.html') : path);
	if (!file.startsWith(root)) {
		response.writeHead(403).end();
		return;
	}
	try {
		const body = await readFile(file);
		response.writeHead(200, { 'content-type': contentTypes[extname(file)] ?? 'application/octet-stream' });
		response.end(body);
	} catch {
		response.writeHead(404).end();
	}
});
await new Promise((done) => server.listen(0, '127.0.0.1', done));
const { port } = server.address();

await rm(out, { recursive: true, force: true });
await mkdir(out, { recursive: true });

const browser = await chromium.launch();
try {
	for (const variant of variants) {
		const context = await browser.newContext({
			viewport: variant.viewport,
			colorScheme: variant.colorScheme
		});
		const page = await context.newPage();
		for (const story of stories) {
			await page.goto(`http://127.0.0.1:${port}/iframe.html?id=${story.id}&viewMode=story`);
			await page.waitForSelector('#storybook-root > *', { timeout: 15000 });
			await page.waitForLoadState('networkidle');
			const file = join(out, `${story.id}--${variant.name}.png`);
			await page.screenshot({ path: file, fullPage: true });
			console.log(file);
		}
		await context.close();
	}
} finally {
	await browser.close();
	server.close();
}
