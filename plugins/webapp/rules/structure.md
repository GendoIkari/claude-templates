# Web app structure: layers, components, views, pages

The base architecture rule (models / business logic / io / systems) maps onto SvelteKit like this. The source root is `src/`.

| Directory | Contains | May import |
| --- | --- | --- |
| `src/lib/models/` | Types and their validation (`invoice.ts`, `result.ts`) | models |
| `src/lib/business-logic/` | Pure functions (`invoice-totals.ts`) | models |
| `src/lib/io/` | Browser-safe I/O: calls to the app's own API, browser storage | models |
| `src/lib/server/io/` | Server-only I/O: database, files, secrets, external services. SvelteKit refuses to bundle `$lib/server` into client code | models |
| `src/lib/systems/` | State and wiring: rune classes in `*.svelte.ts` for client state, server services that combine business logic and I/O | models, business-logic, io, server/io (server only) |
| `src/lib/theme/` | Design tokens (`theme.css`). See the design-system rule | nothing |
| `src/lib/components/` | Design-system components | models, other components |
| `src/lib/views/` | One view per page: the page's whole content | models, components |
| `src/routes/` | SvelteKit routes: load functions, form actions, API endpoints and thin pages | everything in `$lib` |
| `e2e/` | Playwright tests of user flows | nothing from `src/` |

## Components

- A component is presentational: data in through typed `$props()`, user actions out through callback props (`onsave`, `onselect`). No I/O, no systems, no `fetch`, no `$app/*` imports.
- One component per file, named in PascalCase after what it is (`InvoiceTable.svelte`, `DateField.svelte`). Keep `src/lib/components/` flat until a clear family needs a subfolder.
- A component does not accept `class` or `style` props, so callers cannot restyle it. Add a variant prop instead.
- Before creating a component, look in `src/lib/components/` and in Storybook for one that fits or can gain a variant. `src/lib/components/Button.svelte` is the reference shape.

## Views and pages

- Each page has a view in `src/lib/views/` named `<Page>View.svelte` (`InvoiceListView.svelte`). It receives everything it shows as props and reports actions through callbacks, so it renders in Storybook and in component tests without a server.
- `+page.svelte` stays thin: it takes `data` from the load function, passes it to the view, and connects the view's callbacks to systems, form actions or navigation.
- Load functions and form actions (`+page.server.ts`, `+page.ts`) call systems; they hold no business decisions.
- Views and pages use only layout utilities (flex, grid, gap, padding, width) around components. Any other visual element becomes a component first.

## File names

- TypeScript modules use kebab-case (`invoice-totals.ts`); Svelte components use PascalCase.
- Tests sit next to the file they test: `invoice-totals.spec.ts`, `Button.svelte.spec.ts`, `Button.stories.svelte`.
