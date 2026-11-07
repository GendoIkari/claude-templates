# Quality gates and review

- All code passes every quality gate the stack template defines: formatter, linter, type checker when the language has one, unit tests, system tests, and any others it adds.
- The project exposes a single command that runs all gates; the stack template defines it. Run it inside WSL, in the session's working directory.
- Run the gates before declaring any task done, and fix each failure at its cause. Never weaken, skip or disable a check, test or lint rule to get a pass unless the user explicitly asks.
- New behavior comes with tests that assert meaningful behavior. No trivial, tautological or implementation-mirroring tests.
- After the gates pass on a non-trivial change, launch the `coding-base-windows:simplicity-reviewer` and `coding-base-windows:correctness-reviewer` agents in parallel on it, giving each the working directory (as a Windows path), the scope and a one-line summary of the change's intent. Fix every finding you agree with, explain to the user any you reject, and run the gates again before declaring the task done.
