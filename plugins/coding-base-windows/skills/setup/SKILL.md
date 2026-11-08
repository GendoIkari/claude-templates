---
name: setup
description: Install or update the coding-base-windows rules and git line-ending settings in the current project.
disable-model-invocation: true
---

Install this plugin's rules into the current project. `<root>` is the project root: the session's working directory, which must be the main checkout, not a worktree. Run git through WSL as the environment rules describe.

1. Read every file in `${CLAUDE_PLUGIN_ROOT}/rules/`.
2. Write an identical copy of each one to `<root>/.claude/rules/coding-base-windows/`, replacing files with the same name. Do not touch any other folder under `.claude/rules/`: other templates own them.
3. If `.claude/rules/coding-base-windows/` holds files that are no longer in the plugin's `rules/`, list them and ask the user before removing them.
4. Copy `${CLAUDE_PLUGIN_ROOT}/scripts/ext4-run.sh` to `<root>/.claude/scripts/coding-base-windows/ext4-run.sh` with LF line endings, replacing it if present. In WSL, check that `rsync` is installed; if it is missing, ask the user to run `sudo apt install rsync`.
5. Make sure `<root>/.gitattributes` contains the line `* text=auto eol=lf`, keeping its other lines. If you added it, run `git add --renormalize .` so files already committed with CRLF are converted, and list them in the report.
6. Run `git config core.autocrlf false` and `git config core.filemode false`. These are local settings: tell the user that this skill must run again in every new clone.
7. In WSL, check whether `~/.hushlogin` exists. If it does not, suggest creating it with `touch ~/.hushlogin`, so the login banner of `bash -ilc` stops filling command output. Do not create it without the user's consent.
8. Report which files were created, updated or left unchanged. Tell the user to commit `.claude/rules/`, `.claude/scripts/` and `.gitattributes`, and that the rules take effect in the next session.
