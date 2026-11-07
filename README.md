# claude-templates

A Claude Code plugin marketplace of composable project templates. Each template is a plugin; stack templates depend on base templates.

## Plugins

| Plugin | Description |
| --- | --- |
| `coding-base-windows` | Base rules and reviewers for projects developed on Windows with tooling in WSL |
| `gitflow` | Worktree-based feature-branch workflow with fast-forward-only `master` and AI-free commits |

## Use

In a Claude Code session:

```
/plugin marketplace add GendoIkari/claude-templates
/plugin install coding-base-windows@claude-templates
/coding-base-windows:setup
```

Install the plugin with project scope so it is recorded in the project's `.claude/settings.json`, then commit `.claude/`.

## Layout

```
.claude-plugin/marketplace.json   marketplace definition
plugins/<plugin-name>/            one directory per template
```
