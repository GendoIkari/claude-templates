# Git workflow: one worktree per task, fast-forward only

- The main checkout (the project root) always stays on `master`, clean, built and runnable. Never edit files, commit or switch branches there. It changes only through the steps of the `gitflow:finish-feature` skill.
- Every task that changes files runs in its own git worktree and feature branch, so several agents can work in the same project at the same time without touching each other's files:
  - before the first change, run the `gitflow:start-feature` skill;
  - when the task is complete and its quality gates pass, run the `gitflow:finish-feature` skill.
- A feature is one self-contained session: it usually starts right after the user clears the conversation, and the user clears it again when the feature ends. Never rely on earlier conversation: derive the state (worktree, branch, main checkout) from git and the filesystem.
- A feature is done only when it is merged into `master`, pushed (when `origin` exists), the app is rebuilt in the main checkout, its worktree and branch are removed, and the session is back in the main checkout.
- One task, one branch, one worktree. Other worktrees under `.claude/worktrees/` may belong to agents working right now: never work in them or remove them, unless the user asks you to continue that feature.
- `master` history is linear: fast-forward merges only, no merge commits, never force-push `master`.
- Run git the way the project's environment rules require, in the session's working directory: the feature worktree while a feature is in progress.
- A worktree records the absolute path of the repository in the form of the git that created it. When the project's environment rules run git in WSL, worktrees get `/mnt/c/...` paths that a Windows git cannot resolve: create, use and remove worktrees only with git in WSL, and never open a worktree with a Windows git tool (IDE source control, Git for Windows). The main checkout is not affected.
- Git takes lock files in the shared repository. If a git command fails because a `.lock` file exists, another agent is running git: wait a few seconds and retry. Never delete a lock file.
