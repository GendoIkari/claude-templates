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
| `rules/quality-gates.md` | All gates must pass, run on an ext4 copy; reviewers run before a task is done |
| `rules/language.md` | Everything persisted is in English |
| `rules/error-handling.md` | One error-handling approach, defined by the stack template |
| `scripts/ext4-run.sh` | Runs a command on an ext4 copy of the working tree, away from the slow Windows filesystem |
| `agents/simplicity-reviewer.md` | Simplicity, redundancy, dead code, layering, useless tests |
| `agents/correctness-reviewer.md` | Bugs, corner cases, error handling, security |
| `/coding-base-windows:setup` | Copies the rules into the project's `.claude/rules/coding-base-windows/` and the script into `.claude/scripts/coding-base-windows/`, enforces LF line endings |
| `/coding-base-windows:review` | Runs both reviewers in parallel and lets the user pick what to fix (the agent itself launches the reviewers directly, as `quality-gates.md` says) |

## Why rules are copied

Plugins cannot ship `CLAUDE.md` or `.claude/rules/`, so the `setup` skill copies the rules into the project. Each template owns its own subfolder of `.claude/rules/`, so templates stack without overwriting each other.

## Quality gates on ext4

Projects live on the Windows filesystem, where every file read from WSL crosses into Windows; tools that read thousands of small files (linters, type checkers, test runners with their dependencies) slow down by an order of magnitude. `ext4-run.sh` mirrors the working tree's tracked and untracked files into `~/.cache/ext4-run/` with `rsync`, using git's own ignore rules, keeps the copy's ignored files (dependencies, caches) between runs and runs the gates there. Each worktree gets its own copy, removed on a later run once the worktree is gone. Commands that write project files, such as formatters, still run in place.

## What a stack template must define

- Source root and exact layer directory names
- The single command that runs all quality gates, and the tools behind it
- The command that prepares a fresh ext4 copy of the working tree before the gates run (for example installing dependencies)
- The error-handling approach
- Build targets (Linux, Windows or both) and their toolchains
- The command that builds the runnable app, run in the main checkout after every merge
- `.gitignore` entries for every build and tool output, so the main checkout stays clean after a build
- How to prepare a fresh worktree (for example installing dependencies)
