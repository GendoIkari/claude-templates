---
name: setup
description: Install or update the webapp rules, and scaffold the SvelteKit app when the project has none yet.
disable-model-invocation: true
---

Set up the web app stack in the current project. `<root>` is `${CLAUDE_PROJECT_DIR}`, which must be the main checkout on `master`, not a worktree. Run every command in WSL as the environment rules describe; scaffolding downloads packages and takes a few minutes, so run it in the background.

1. Check that `<root>/.claude/rules/coding-base-windows/` and `<root>/.claude/rules/gitflow/` exist. If one is missing, stop and tell the user to run `/coding-base-windows:setup` and `/gitflow:setup` first.
2. Copy every file in `${CLAUDE_PLUGIN_ROOT}/rules/` to `<root>/.claude/rules/webapp/`, replacing files with the same name. Do not touch any other folder under `.claude/rules/`. If `.claude/rules/webapp/` holds files that are no longer in the plugin, list them and ask the user before removing them.
3. Check the toolchain in WSL: `node --version` must be 22 or later (if not, tell the user to install it with nvm); if `pnpm` is missing, run `corepack enable pnpm`.
4. If `<root>/package.json` does not exist, scaffold the app:
   `bash "<plugin root as a WSL path>/setup/scaffold.sh" "<root as a WSL path>" "<plugin root as a WSL path>"`
   The script creates a SvelteKit app with `sv` (TypeScript, Tailwind, ESLint, Prettier, Vitest, Playwright, Storybook, adapter-node), replaces the demo content with the template in `${CLAUDE_PLUGIN_ROOT}/template/` (theme, reference component, view, error page, configuration), keeps files the project already has, merges `.gitignore`, installs dependencies and Chromium.
   If `package.json` exists, do not scaffold: compare the project with the template and report what differs (missing theme, ESLint design rules, `gates` script, stories setup), without changing it.
5. Run `pnpm gates` in `<root>`. If Chromium cannot start because system libraries are missing, ask the user to run `sudo pnpm exec playwright install-deps chromium` in Ubuntu, then run the gates again. Report any other failure to the user.
6. Report what was created. Tell the user to commit everything directly on `master` (the workflow is not active for this first commit), to start a new session, and that `pnpm dev` runs the app and `pnpm storybook` opens the design catalog.
