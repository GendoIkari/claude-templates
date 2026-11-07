# Execution environment: Windows host, tooling in WSL

- Claude Code runs as a native Windows program. Use its own file tools (Read, Edit, Write, Glob, Grep) directly on the project's Windows paths.
- Every development tool runs inside WSL (Ubuntu): git, compilers, build tools, package managers, formatters, linters, test runners and project scripts. Never use a Windows-native binary for these, even when one is installed.
- Run WSL commands from the shell tool with:
  `wsl.exe --cd "<project root as a Windows path>" -- bash -lc '<command>'`
  - `bash -lc` loads the login profile, so version managers and PATH entries are available.
  - From Git Bash, prefix the call with `MSYS_NO_PATHCONV=1` so Unix paths inside the command are not rewritten.
- Inside WSL the project is under `/mnt/<drive>/...`. Use those paths inside WSL commands and Windows paths with Claude's file tools.
- Build artifacts may target Linux, Windows, or both. Build every target from WSL with the toolchain the stack template specifies (for example a cross-compilation target), unless the stack template says otherwise.
- Files use LF line endings, and git ignores file modes (`core.autocrlf false`, `core.filemode false`). Never introduce CRLF.
- Git worktrees are read both by Claude Code on Windows and by git in WSL, so they must record relative paths: `worktree.useRelativePaths` must be `true`, which needs git 2.48 or later in WSL.
