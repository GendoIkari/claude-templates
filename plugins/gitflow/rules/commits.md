# Commit messages

- English only.
- No reference to AI or to the tool that wrote the change: no `Co-Authored-By` or `Signed-off-by` trailers, no "Generated with" lines, no signatures, no emoji tags.
- Subject line: what changed, in the imperative mood, at most 72 characters, no trailing period (for example `Add CSV export for invoices`).
- Then a blank line and a body that explains how the change works and why it was needed, so an agent reading the history understands it without the diff. Wrap it at 72 characters.
- Each commit is one coherent step that passes the quality gates. Fold work-in-progress and fix-up commits into the commit they belong to before the branch is merged.
- The project's `commit-msg` hook enforces part of these rules. Never bypass it with `--no-verify`.
