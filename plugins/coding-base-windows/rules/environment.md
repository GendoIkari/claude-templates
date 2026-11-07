# Execution environment: Windows host, tooling in WSL

- Claude Code runs as a native Windows program. Use its own file tools (Read, Edit, Write, Glob, Grep) directly on the project's Windows paths.
- Every development tool runs inside WSL (Ubuntu): git, compilers, build tools, package managers, formatters, linters, test runners and project scripts. Never use a Windows-native binary for these, even when one is installed.
- Run WSL commands from the shell tool with:
  `wsl.exe --cd "<working directory as a Windows path>" -- bash -ilc '<command>'`
  - The working directory is the session's current one: the feature worktree when the session is in one, otherwise the project root. Never run a command meant for a worktree in the project root, or the reverse.
  - The shell must be interactive and login (`-ilc`), so it runs the same startup scripts as a manually opened Ubuntu terminal: version managers, PATH entries and the SSH agent that git needs to reach remotes.
  - Warnings such as `cannot set terminal process group` or `no job control in this shell` are expected and harmless.
  - If git cannot authenticate to a remote, stop and tell the user. Do not try other credentials or transports.
  - From Git Bash, prefix the call with `MSYS_NO_PATHCONV=1` so Unix paths inside the command are not rewritten.
- Inside WSL the project is under `/mnt/<drive>/...`. Use those paths inside WSL commands and Windows paths with Claude's file tools and tools such as EnterWorktree. Convert a path printed by a WSL command with `wslpath -w '<path>'`, and the other way with `wslpath -u '<path>'`.
- Build artifacts may target Linux, Windows, or both. Build every target from WSL with the toolchain the stack template specifies (for example a cross-compilation target), unless the stack template says otherwise.
- Files use LF line endings (`.gitattributes` holds `* text=auto eol=lf`), and git ignores file modes (`core.autocrlf false`, `core.filemode false`). Never introduce CRLF.
