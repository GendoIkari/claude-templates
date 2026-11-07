# coding-base-windows

Base template for projects developed on Windows, where Claude Code runs as a Windows program and all development tooling runs in WSL. Stack templates (one per language or framework) depend on this plugin and add their own rules.

## Install

```
/plugin install coding-base-windows --marketplace GendoIkari/claude-templates
/coding-base-windows:setup
```

`setup` copies the rules and sets local git options (`core.autocrlf false`, `core.filemode false`), so run it again in every new clone.

## Contents

| Component | Purpose |
| --- | --- |
| `rules/environment.md` | Claude on Windows, every dev tool through `wsl.exe` |
| `rules/architecture.md` | models / business-logic / io / systems layers and descriptive file names |
| `rules/reuse-first.md` | Search for existing code before writing new code |
| `rules/quality-gates.md` | All gates must pass; reviewers run before a task is done |
| `rules/language.md` | Everything persisted is in English |
| `rules/error-handling.md` | One error-handling approach, defined by the stack template |
| `agents/simplicity-reviewer.md` | Simplicity, redundancy, dead code, layering, useless tests |
| `agents/correctness-reviewer.md` | Bugs, corner cases, error handling, security |
| `/coding-base-windows:setup` | Copies the rules into the project's `.claude/rules/coding-base-windows/`, enforces LF line endings |
| `/coding-base-windows:review` | Runs both reviewers in parallel and lets the user pick what to fix (the agent itself launches the reviewers directly, as `quality-gates.md` says) |

## Why rules are copied

Plugins cannot ship `CLAUDE.md` or `.claude/rules/`, so the `setup` skill copies the rules into the project. Each template owns its own subfolder of `.claude/rules/`, so templates stack without overwriting each other.

## What a stack template must define

- Source root and exact layer directory names
- The single command that runs all quality gates, and the tools behind it
- The error-handling approach
- Build targets (Linux, Windows or both) and their toolchains
- The command that builds the runnable app, run in the main checkout after every merge
- `.gitignore` entries for every build and tool output, so the main checkout stays clean after a build
- How to prepare a fresh worktree (for example installing dependencies)
