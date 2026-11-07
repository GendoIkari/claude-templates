---
name: setup
description: Install or update the coding-base-windows rules in the current project's .claude/rules/ folder.
disable-model-invocation: true
---

Install this plugin's rules into the current project.

1. Read every file in `${CLAUDE_PLUGIN_ROOT}/rules/`.
2. Write an identical copy of each one to `${CLAUDE_PROJECT_DIR}/.claude/rules/coding-base-windows/`, replacing files with the same name. Do not touch any other folder under `.claude/rules/`: other templates own them.
3. If `.claude/rules/coding-base-windows/` holds files that are no longer in the plugin's `rules/`, list them and ask the user before removing them.
4. Report which files were created, updated or left unchanged. Tell the user to commit `.claude/rules/` and that the rules take effect in the next session.
