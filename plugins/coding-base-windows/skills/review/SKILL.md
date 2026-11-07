---
name: review
description: Run the simplicity and correctness reviewers on the current change and merge their findings.
disable-model-invocation: true
argument-hint: "[git range or paths]"
---

Review the change given by `$ARGUMENTS`. If it is empty, review the uncommitted changes, including untracked files. Run git through WSL as the environment rules describe.

1. Collect the changed files and the diff.
2. Launch the `coding-base-windows:simplicity-reviewer` and `coding-base-windows:correctness-reviewer` agents in parallel. Give each the scope (range or file list) and a one-line summary of what the change is meant to do.
3. Merge their findings into one list without duplicates, ordered by severity: bugs and security issues first, then simplicity and layering, then tests.
4. Present the list and ask which findings to fix. Do not change any code before the user answers.
