# Web app stack: SvelteKit, Tailwind, pnpm

This project is a SvelteKit app written in TypeScript, styled with Tailwind CSS 4, built with `@sveltejs/adapter-node` and managed with pnpm. It follows the base rules of `coding-base-windows` and the workflow of `gitflow`; this file fills in what they leave to the stack template.

- Svelte 5 runes only (`$state`, `$derived`, `$props`, `$effect`). No legacy `export let`, `$:` or stores for new code.
- SvelteKit configuration lives in `vite.config.ts` (there is no `svelte.config.js`).
- Import from `src/lib` with `#lib/...` (declared in `package.json` `imports`). SvelteKit 3 removed the `$lib` alias, so `$lib` imports fail the build.
- Every command runs in WSL with pnpm, never npm or yarn. Add dependencies with `pnpm add` / `pnpm add -D` and commit `pnpm-lock.yaml`.

## Commands

| Purpose | Command |
| --- | --- |
| All quality gates | `pnpm gates` (format check, ESLint, svelte-check, Vitest, Playwright), run on an ext4 copy with preparation command `pnpm install --frozen-lockfile --prefer-offline`, as the quality-gate rules describe |
| Fix formatting | `pnpm format` |
| Dev server | `pnpm dev` |
| Design catalog | `pnpm storybook` |
| Story screenshots | `pnpm design:screenshots [filter...]` (into `.design-review/`) |
| Build the app | `pnpm build` (output in `build/`) |
| Run the built app | `pnpm start` (`PORT` sets the port) |

## Worktrees and builds

- The quality gates need no `node_modules` in the worktree: their ext4 copy installs its own. Run `pnpm install --frozen-lockfile` in a fresh worktree only before running commands there directly (`pnpm format`, dev server, Storybook, story screenshots). Playwright's Chromium is installed once per machine; if a browser test cannot launch it, run `pnpm exec playwright install chromium` and, when system libraries are missing, ask the user to run `sudo pnpm exec playwright install-deps chromium`.
- The build command run in the main checkout after every merge is `pnpm install --frozen-lockfile && pnpm build`.
- The only build target is Node on Linux. There is no Windows build.
- Everything the tools generate (`build/`, `.svelte-kit/`, `storybook-static/`, `.design-review/`, `test-results/`, `playwright-report/`, `__screenshots__/`) is in `.gitignore`. Add new tool outputs there too.
