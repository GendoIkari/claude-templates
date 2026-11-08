# webapp-windows

Stack template for SvelteKit web apps. It builds on `coding-base-windows` (environment, layers, quality gates, reviewers) and `gitflow` (one worktree per feature, fast-forward-only `master`), which it declares as dependencies.

## Install

```
/plugin install webapp-windows --marketplace GendoIkari/claude-templates
/coding-base-windows:setup
/gitflow:setup
/webapp-windows:setup
```

In a project without `package.json`, `setup` scaffolds the app with `sv` and applies the template. In an existing app it only installs the rules and reports how the app differs from the template.

## Stack

SvelteKit with Svelte 5 runes and TypeScript, Tailwind CSS 4, adapter-node, pnpm, ESLint and Prettier, Vitest (Node and browser mode through Playwright), Playwright end-to-end tests, Storybook with its Vitest and accessibility addons.

## Contents

| Component | Purpose |
| --- | --- |
| `rules/stack.md` | Stack, commands, worktree preparation, build command |
| `rules/structure.md` | Layers mapped onto SvelteKit; components, views and thin pages |
| `rules/design-system.md` | The theme as the single source of style; stories; when to run the design reviewer |
| `rules/testing.md` | Which kind of test covers which layer |
| `rules/error-handling.md` | `Result` values for expected failures, thrown errors for bugs |
| `agents/design-reviewer.md` | Checks a change against the design system, in code and in story screenshots |
| `/webapp-windows:setup` | Installs the rules and scaffolds the app |
| `/webapp-windows:design-review` | Runs the design reviewer on demand |
| `setup/scaffold.sh` | Creates the app with `sv` and applies `template/` |
| `template/` | Theme, reference component and view with stories and tests, error page, ESLint design rules, Playwright and Storybook configuration, screenshot script |

## Design system

`src/lib/theme/theme.css` defines every color, font, radius and shadow as Tailwind tokens and removes Tailwind's defaults. ESLint rejects classes the theme does not define, arbitrary values and inline styles, so most deviations fail the quality gates. The design reviewer covers what a linter cannot: reuse, consistency, states, accessibility and the rendered result.

## Known limits

- Projects live on the Windows filesystem (`/mnt/c`), where Node tooling in WSL reads files slowly. The quality gates avoid it by running on an ext4 copy (see `coding-base-windows`), but the dev server, Storybook and the story screenshots still run in place and stay slow.
- The scaffold pins `sv` 1.3.0; the packages it installs follow their latest versions.
