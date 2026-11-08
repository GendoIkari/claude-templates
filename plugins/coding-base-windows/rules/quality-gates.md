# Quality gates and review

- All code passes every quality gate the stack template defines: formatter, linter, type checker when the language has one, unit tests, system tests, and any others it adds.
- The project exposes a single command that runs all gates; the stack template defines it, together with the command that prepares a fresh copy of the working tree (for example installing dependencies). Run them in WSL from the session's working directory, on an ext4 copy of it:
  `bash .claude/scripts/coding-base-windows/ext4-run.sh "<preparation command> && <gates command>"`
  - The project lives on the Windows filesystem, where tooling in WSL reads files slowly; the script runs the command on a copy in `~/.cache/ext4-run/<name>/` that keeps its dependencies between runs.
  - The script prints the copy's path and the working tree it mirrors. Paths in the output under the copy are the same relative paths in the working tree: read and fix files there, never in the copy.
  - Files the command writes stay in the copy. Run commands that change project files, such as formatters, directly in the working directory.
  - The copy has no `.git` and none of the working tree's ignored files (such as `.env`). If the gates need one, the stack template says how it reaches the copy.
- Run the gates before declaring any task done, and fix each failure at its cause. Never weaken, skip or disable a check, test or lint rule to get a pass unless the user explicitly asks.
- New behavior comes with tests that assert meaningful behavior. No trivial, tautological or implementation-mirroring tests.
- After the gates pass on a non-trivial change, launch the `coding-base-windows:simplicity-reviewer` and `coding-base-windows:correctness-reviewer` agents in parallel on it, together with any reviewer the stack template's rules add, giving each the working directory (as a Windows path), the scope and a one-line summary of the change's intent. Fix every finding you agree with, explain to the user any you reject, and run the gates again before declaring the task done.
