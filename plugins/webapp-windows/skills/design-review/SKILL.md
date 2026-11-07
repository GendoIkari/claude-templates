---
name: design-review
description: Run the design reviewer on the current change and list its findings.
disable-model-invocation: true
argument-hint: "[git range or paths]"
---

Review the design of the change given by `$ARGUMENTS`. If it is empty, review `master...HEAD` plus the uncommitted changes.

1. Launch the `webapp-windows:design-reviewer` agent. Give it the working directory (as a Windows path), the scope and a one-line summary of what the change is meant to do.
2. Present its findings, most important first, and ask which ones to fix. Do not change any code before the user answers.
