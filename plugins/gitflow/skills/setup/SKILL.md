---
name: setup
description: Install or update the gitflow rules, commit-msg hook and git settings in the current project.
disable-model-invocation: true
---

Set up the gitflow workflow in the current project. Run every git command as the project's environment rules require. `<root>` is `${CLAUDE_PROJECT_DIR}`.

1. Copy every file in `${CLAUDE_PLUGIN_ROOT}/rules/` to `<root>/.claude/rules/gitflow/`, replacing files with the same name. Do not touch any other folder under `.claude/rules/`. If `.claude/rules/gitflow/` holds files that are no longer in the plugin, list them and ask the user before removing them.
2. Copy `${CLAUDE_PLUGIN_ROOT}/git-hooks/commit-msg` to `<root>/.githooks/commit-msg` with LF line endings, make it executable with `chmod +x`, and run `git config core.hooksPath .githooks`.
3. Allow fast-forward merges only: `git config pull.ff only` and `git config merge.ff only`.
4. If `git --version` reports 2.48 or later, run `git config worktree.useRelativePaths true`, so every git client that sees the repository can read its worktrees. Otherwise tell the user that their git is older than 2.48 and worktrees will record absolute paths.
5. Make sure `<root>/.gitignore` contains `.claude/worktrees/` and `.claude/settings.local.json`.
6. Merge these keys into `<root>/.claude/settings.json`, keeping every existing key, to remove AI attribution and Claude Code's built-in git instructions, which this workflow replaces:
   ```json
   { "attribution": { "commit": "", "pr": "" }, "includeGitInstructions": false }
   ```
7. If the current branch is not `master`, tell the user that this workflow requires `master` as the main branch.
8. Report what changed. Tell the user to commit these files directly on `master` (the one exception to the worktree rule, because the workflow is not active yet) and to start a new session.
