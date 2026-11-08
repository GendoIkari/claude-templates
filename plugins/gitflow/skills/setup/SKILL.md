---
name: setup
description: Install or update the gitflow rules, commit-msg hook and git settings in the current project.
disable-model-invocation: true
---

Set up the gitflow workflow in the current project. Run every git command as the project's environment rules require. `<root>` is the project root: the session's working directory, which must be the main checkout, not a worktree.

1. Copy every file in `${CLAUDE_PLUGIN_ROOT}/rules/` to `<root>/.claude/rules/gitflow/`, replacing files with the same name. Do not touch any other folder under `.claude/rules/`. If `.claude/rules/gitflow/` holds files that are no longer in the plugin, list them and ask the user before removing them.
2. Copy `${CLAUDE_PLUGIN_ROOT}/git-hooks/commit-msg` to `<root>/.githooks/commit-msg` with LF line endings. Make it executable with `chmod +x .githooks/commit-msg`, then record the mode in git with `git add .githooks/commit-msg && git update-index --chmod=+x .githooks/commit-msg`: with `core.filemode false`, git would otherwise commit it as non-executable and silently skip it in new clones. Run `git config core.hooksPath .githooks`.
3. Allow fast-forward merges only: `git config pull.ff only` and `git config merge.ff only`.
4. If `git config --get worktree.useRelativePaths` prints anything (set by an earlier version of this plugin), remove it with `git config --unset worktree.useRelativePaths`.
5. Make sure `<root>/.gitignore` contains `.claude/worktrees/` and `.claude/settings.local.json`.
6. Merge these keys into `<root>/.claude/settings.json`, keeping every existing key, to remove AI attribution and Claude Code's built-in git instructions, which this workflow replaces:
   ```json
   { "attribution": { "commit": "", "pr": "" }, "includeGitInstructions": false }
   ```
7. If the current branch is not `master`, tell the user that this workflow requires `master` as the main branch.
8. Report what changed. Tell the user:
   - the git settings of steps 2 and 3 are local, so this skill must run again in every new clone;
   - to commit these files directly on `master` (the one exception to the worktree rule, because the workflow is not active yet) and to start a new session.
