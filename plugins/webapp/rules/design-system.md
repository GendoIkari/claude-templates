# Design system: one theme for every page and component

`src/lib/theme/theme.css` defines every color, font, radius and shadow the app may use, as Tailwind 4 `@theme` tokens. It is the single source of the app's look.

- Style only with Tailwind utilities generated from the theme tokens (`bg-surface`, `text-fg-muted`, `border-border`, `rounded-control`, `shadow-raised`) and with Tailwind's own spacing, sizing and type scales.
- Never use arbitrary values (`p-[13px]`, `bg-[#0af]`), inline `style`, hex or rgb colors outside the theme, or `<style>` blocks that set colors, fonts, radii or shadows. ESLint rejects arbitrary values, inline styles and classes the theme does not define, such as Tailwind's default palette.
- Use semantic tokens by role, not by appearance: `text-danger` for an error message, not a red that happens to match.
- When a needed value is missing, add a token to `theme.css` instead of working around it: a semantic name, a value for light mode in `@theme`, and a value for dark mode in the `prefers-color-scheme: dark` block. Changing the theme is a design decision, so state it in the commit body.
- Every interactive element has visible hover, `focus-visible` and disabled states; forms show error states; lists and pages show empty and loading states.
- Layouts work from 360 px wide upward.

## Storybook

- Every component and every view has a `*.stories.svelte` file next to it, with one story per variant and per meaningful state (disabled, error, empty, loading, long text).
- Stories run as tests in `pnpm gates`, including accessibility checks: an accessibility violation fails the gates.

## Design review

Before running `gitflow:finish-feature` on a feature that changes anything under `src/lib/theme/`, `src/lib/components/`, `src/lib/views/` or a `.svelte` file in `src/routes/`, launch the `webapp:design-reviewer` agent, in parallel with the base reviewers. Give it the working directory (as a Windows path), the scope of the change and a one-line summary of its intent. Fix every finding you agree with, explain to the user any you reject, and run `pnpm gates` again before merging.
