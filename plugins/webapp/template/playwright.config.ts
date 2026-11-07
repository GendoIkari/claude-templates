import { defineConfig } from '@playwright/test';
import { createHash } from 'node:crypto';

// Several worktrees may run their end-to-end tests at the same time, so each
// checkout serves the app on its own port, derived from its path.
const port =
	4200 + (parseInt(createHash('sha1').update(process.cwd()).digest('hex').slice(0, 6), 16) % 1000);

export default defineConfig({
	testDir: 'e2e',
	testMatch: '**/*.e2e.ts',
	forbidOnly: true,
	use: { baseURL: `http://localhost:${port}` },
	webServer: {
		command: `pnpm build && pnpm preview --port ${port} --strictPort`,
		port,
		reuseExistingServer: false
	}
});
