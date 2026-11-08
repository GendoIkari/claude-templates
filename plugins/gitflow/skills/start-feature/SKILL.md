---
name: start-feature
description: Start a task that changes files - update master, then create an isolated git worktree and feature branch for it, or resume an unfinished one the user names. Use before making the first change of any task.
argument-hint: "[short-feature-name]"
---

Prepare an isolated workspace for the task. Do not rely on earlier conversation; read the state from git. Run every git command as the project's environment rules require. Git in WSL prints WSL paths: convert them with `wslpath -w` before using them with Claude's own tools.

1. Find the main checkout `<root>`: it is the parent directory of `git rev-parse --path-format=absolute --git-common-dir`.
2. If the session is already inside a feature worktree (`git rev-parse --show-toplevel` differs from `<root>`), it is an unfinished feature. Tell the user its branch and ask whether to continue it or start a new one from `<root>`.
3. Check the main checkout: `git -C <root> status --porcelain` must print nothing and `git -C <root> branch --show-current` must print `master`. Otherwise stop and report to the user. Never clean the main checkout up yourself.
4. If the user asks to continue an existing feature, find it in `git -C <root> worktree list`, enter it as in step 8, and stop here.
5. If a remote named `origin` exists (`git -C <root> remote`), update master with `git -C <root> pull --ff-only origin master`. If that fails, stop and report.
6. Choose a short kebab-case name that describes the task, or use `$ARGUMENTS` if given. Check that neither the branch `feature/<name>` nor the directory `<root>/.claude/worktrees/<name>` exists; if one does, choose another name.
7. Create the worktree: `git -C <root> worktree add .claude/worktrees/<name> -b feature/<name> master`.
8. Move into it with the EnterWorktree tool, passing `path` (never `name`, which would create a different worktree) set to the Windows path of `<root>/.claude/worktrees/<name>`. If that tool is not available or refuses the path (a Windows git cannot read a worktree that git in WSL created), change the session's working directory to that path with the shell tool, in a call of its own, and make every edit and run every command under it from now on.
9. If the stack template says how to prepare a new worktree (for example by installing dependencies), do it now.
10. Tell the user the branch name and worktree path in one line.
