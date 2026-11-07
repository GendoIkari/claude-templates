# Web app testing

`pnpm gates` runs four kinds of tests. Each layer is tested with the cheapest kind that proves its behavior.

| What | How | File |
| --- | --- | --- |
| Models and business logic | Vitest in Node | `src/**/<name>.spec.ts` |
| Components and views | Vitest browser mode in Chromium, through Playwright, with `vitest-browser-svelte` | `src/**/<Name>.svelte.spec.ts` |
| Stories | Storybook's Vitest addon renders every story and checks accessibility | `src/**/<Name>.stories.svelte` |
| User flows across pages | Playwright against the built app | `e2e/<flow>.e2e.ts` |

- Component and view tests assert what a user sees and does: query by role, label or text, interact, and check the rendered result or the callback that fired. Never assert on CSS classes or internal state. `Button.svelte.spec.ts` is the reference.
- A story that only renders adds nothing as a separate component test: write a component test when there is behavior (interaction, conditional rendering, validation).
- End-to-end tests cover the main user flows and the routing, load and form-action wiring that component tests cannot reach. Keep them few and stable.
- Server I/O is tested through systems with fakes at the io boundary, or end to end. Never call real external services from tests.
- Each worktree serves the app for end-to-end tests on its own port, derived from its path in `playwright.config.ts`, so parallel features do not collide. Do not hard-code ports in tests: use relative URLs.
