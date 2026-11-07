# Error handling

- A project uses exactly one error-handling approach, consistently, across all layers. The stack template defines it in its own rules (for example result types, or exceptions with a fixed hierarchy).
- If no stack template defines it, ask the user before writing error-handling code. Do not invent a convention.
- Never mix approaches, silently swallow errors, or add ad-hoc handling that differs from the defined one.
