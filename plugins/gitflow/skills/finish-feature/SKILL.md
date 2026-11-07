---
name: finish-feature
description: Finish the current feature - rebase it on the latest master, merge it fast-forward only, push master, rebuild the app in the main checkout, and remove the feature worktree and branch. Use when the task is complete and its quality gates pass.
---

Integrate the current feature into master. Do not rely on earlier conversation; read the state from git. Run every git command as the project's environment rules require.

1. Identify the feature from inside its worktree: `<wt>` is `git rev-parse --show-toplevel`, `<branch>` is `git branch --show-current`, and `<root>` is the parent directory of `git rev-parse --path-format=absolute --git-common-dir`. If `<wt>` equals `<root>`, or `<branch>` does not start with `feature/`, stop: you are not in a feature worktree.
2. In `<wt>`, check that `git status --porcelain` prints nothing and that every commit in `master..<branch>` follows the commit rules. Fold work-in-progress and fix-up commits: create them with `git commit --fixup <sha>`, then run `GIT_SEQUENCE_EDITOR=true git rebase -i --autosquash master`.
3. If `origin` exists, update master: `git -C <root> pull --ff-only origin master`.
4. In `<wt>`, run `git rebase master`. Resolve conflicts so that both sides keep their intent. If the right resolution is unclear, stop and ask the user.
5. In `<wt>`, run all quality gates. Fix any failure with a commit, fold it as in step 2, and repeat from step 3.
6. If you are in `<wt>` through the EnterWorktree tool, leave it with ExitWorktree and keep the worktree. From now on work in `<root>`.
7. In `<root>`, run `git merge --ff-only <branch>`. If it fails because master moved meanwhile, go back into `<wt>` and repeat from step 3.
8. If `origin` exists, run `git -C <root> push origin master`. If the push is rejected because origin moved, run `git -C <root> pull --rebase origin master`, run the quality gates in `<root>`, and push again. If that rebase has conflicts, run `git -C <root> rebase --abort`, stop and report to the user.
9. Rebuild the app in `<root>` with the build command the stack template defines, so the user can run the integrated version right away. If no build command is defined, tell the user. If the build fails, stop and report: `master` is not runnable.
10. Clean up: `git -C <root> worktree remove .claude/worktrees/<name>`, then `git -C <root> branch -d <branch>`. Never use `-D`: if git refuses, the branch is not fully merged, so stop and report.
11. Check that `git -C <root> status --porcelain` prints nothing and that the session's working directory is `<root>`.
12. Report the merged commit subjects and the build result, and tell the user the feature is complete and the session can be cleared.
