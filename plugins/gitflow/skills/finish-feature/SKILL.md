---
name: finish-feature
description: Finish the current feature - rebase it on the latest master, merge it fast-forward only, push master, rebuild the app in the main checkout, and remove the feature worktree and branch. Use when the task is complete and its quality gates pass.
---

Integrate the current feature into master. Do not rely on earlier conversation; read the state from git. Run every git command as the project's environment rules require. Git in WSL prints WSL paths: convert them with `wslpath -w` before using them with Claude's own tools.

1. Identify the feature from inside its worktree: `<wt>` is `git rev-parse --show-toplevel`, `<branch>` is `git branch --show-current`, and `<root>` is the parent directory of `git rev-parse --path-format=absolute --git-common-dir`. If `<wt>` equals `<root>`, or `<branch>` does not start with `feature/`, stop: you are not in a feature worktree.
2. In `<wt>`, check that `git status --porcelain` prints nothing and that every commit in `master..<branch>` follows the commit rules. Fold work-in-progress and fix-up commits into the commit they belong to:
   - for a new correction, commit it with `git commit --fixup <sha>` (never `--squash` or `--fixup=amend:`, which need an editor);
   - for an existing work-in-progress commit, run `GIT_SEQUENCE_EDITOR="sed -i s/^pick\ <short-sha>\ /fixup\ <short-sha>\ /" git rebase -i master` (no single quotes, so it fits inside the `bash -ilc '...'` wrapper), once per commit, where `<short-sha>` is the abbreviated hash the rebase todo list shows;
   - then run `GIT_SEQUENCE_EDITOR=true GIT_EDITOR=true git rebase -i --autosquash master`.
   If a commit message itself breaks the rules, stop and ask the user before rewriting it.
3. If `origin` exists, update master: `git -C <root> pull --ff-only origin master`.
4. In `<wt>`, run `git rebase master`. Resolve conflicts so that both sides keep their intent. If the right resolution is unclear, run `git rebase --abort`, stop and ask the user.
5. In `<wt>`, run all quality gates. Fix any failure with a commit, fold it as in step 2, and repeat from step 3.
6. Leave `<wt>`: if you entered it through the EnterWorktree tool, use ExitWorktree (`action: "keep"`); otherwise change the session's working directory to the Windows path of `<root>` with the shell tool, in a call of its own. The shell tool starts every command in the session's working directory, and Windows cannot delete a directory that is a process's current directory, so step 10 fails while the session is still in `<wt>`. From now on the working directory is `<root>`.
7. In `<root>`, run `git merge --ff-only <branch>`. If it fails because master moved meanwhile, go back into `<wt>` as in step 8 of the `gitflow:start-feature` skill and repeat from step 3.
8. If `origin` exists, run `git -C <root> push origin master`. If the push is rejected because origin moved:
   1. Run `git -C <root> pull --rebase origin master`. If the rebase has conflicts, run `git -C <root> rebase --abort`, stop and report to the user.
   2. Run the quality gates in `<root>`, then push again.
   3. In `<wt>`, run `git rebase master`. The feature commits are already in master, so the rebase skips them and the branch ends at master's tip; if `git log master..<branch>` still lists commits, stop and report.
9. Rebuild the app in `<root>` with the build command the stack template defines, so the user can run the integrated version right away. If no build command is defined, tell the user. If the build fails, stop and report: `master` is not runnable.
10. Clean up: `git -C <root> worktree remove <wt>`, then `git -C <root> branch -d <branch>`. Never use `--force` or `-D`: if git refuses, the worktree has changes or the branch is not fully merged, so stop and report. Read the output of `worktree remove`, not only its exit code: if it prints `failed to delete '<wt>'`, git has already removed the files and unregistered the worktree, but a process still holds the empty directory. Check that the session's working directory is `<root>` (step 6), stop any process started from `<wt>` (dev server, watcher), then run `rmdir <wt>` in a new call. If it still fails, another program holds it (an editor or a terminal opened there): tell the user.
11. Check that `git -C <root> status --porcelain` prints nothing (build outputs must be ignored by `.gitignore`) and that the session's working directory is `<root>`.
12. Report the merged commit subjects and the build result, and tell the user the feature is complete and the session can be cleared.
