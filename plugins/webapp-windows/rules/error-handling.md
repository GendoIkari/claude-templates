# Web app error handling

This project's single error-handling approach, as the base error-handling rule requires:

- Expected failures (invalid input, missing record, conflict, an external service that refused) are values, not exceptions. Functions that can fail this way return `Result<T, E>` from `#lib/models/result.ts`, where `E` is a discriminated union of the failures the caller must handle (`{ kind: 'not-found' } | { kind: 'invalid'; field: string }`).
- Business logic returns `Result` and never throws for expected failures.
- I/O adapters catch exceptions from libraries and the platform at the boundary and convert them into `Result` failures. Nothing else catches exceptions.
- Unexpected failures (bugs, broken invariants) are thrown and never caught locally. SvelteKit logs them (customize logging with a `handleError` hook in `src/hooks.server.ts`) and `src/routes/+error.svelte` shows the error page.
- Routes translate `Result` failures into SvelteKit responses: `error(status, message)` in load functions and endpoints, `fail(status, data)` in form actions, so the view shows the failure next to the field or action it concerns.
- Components and views receive failures as props and render them; they never decide how to recover.
