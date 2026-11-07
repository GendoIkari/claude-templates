# gitflow

Feature-branch workflow built on git worktrees, so several agents can change the same project at the same time while the main checkout always holds an integrated, runnable `master`.

## How it works

1. `start-feature`: pull `master` (when `origin` exists), create `.claude/worktrees/<name>` on branch `feature/<name>`, work there.
2. Commit in English, subject = what, body = how and why, no AI references.
3. `finish-feature`: pull `master`, rebase the branch, run the quality gates, merge fast-forward only, push, rebuild the app in the main checkout, remove worktree and branch.

Each feature is a self-contained session that typically starts after a `/clear` and ends before the next one. The skills read all state from git, never from earlier conversation.

## Contents

| Component | Purpose |
| --- | --- |
| `rules/workflow.md` | Main checkout stays clean on `master`; one worktree per task; linear history |
| `rules/commits.md` | Commit message rules |
| `git-hooks/commit-msg` | Rejects messages with AI references, a missing body or a bad subject |
| `/gitflow:setup` | Installs rules and hook, sets fast-forward-only and relative worktree paths, removes AI attribution |
| `gitflow:start-feature` | Skill Claude runs before the first change of a task |
| `gitflow:finish-feature` | Skill Claude runs when the task is done |

## Requirements

- Main branch named `master`.
- Git 2.48 or later for relative worktree paths, required when more than one git client (for example Windows and WSL) uses the repository.
- A stack template that defines the quality gates, which `finish-feature` runs before every merge, and the build command it runs after every merge.
