#!/usr/bin/env bash
# Scaffolds a SvelteKit web app into a project root that has no package.json
# yet, then applies the webapp template on top of it.
#
# Usage: scaffold.sh <project root> <plugin root>   (both as WSL paths)

set -euo pipefail

root=$(realpath "$1")
plugin=$(realpath "$2")
sv_version=1.3.0

if [ -e "$root/package.json" ]; then
	echo "scaffold: $root already has a package.json; nothing to scaffold" >&2
	exit 1
fi

export COREPACK_ENABLE_DOWNLOAD_PROMPT=0
if ! command -v pnpm >/dev/null; then
	corepack enable pnpm
fi

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

echo "scaffold: creating the SvelteKit app with sv $sv_version"
CI=1 pnpm dlx "sv@$sv_version" create "$tmp/app" \
	--template minimal --types ts \
	--add prettier eslint \
	vitest="usages:unit,component" \
	playwright="demo:no" \
	tailwindcss="plugins:none" \
	sveltekit-adapter="adapter:node" \
	storybook \
	--no-install </dev/null

cd "$tmp/app"

echo "scaffold: replacing the demo content with the webapp template"
rm -rf src/stories src/lib/vitest-examples src/routes/page.svelte.e2e.ts node_modules
cp -r "$plugin/template/." .
# vite.config.ts already imports from vitest/config; the generated reference
# directive is redundant and fails the linter.
sed -i '\|^/// <reference types="vitest/config" />$|d' vite.config.ts

cat >>.gitignore <<'EOF'

# Tooling output
/storybook-static
/.design-review
/playwright-report
/coverage
__screenshots__
EOF

node --input-type=module <<'EOF'
import { readFileSync, writeFileSync } from 'node:fs';
const pkg = JSON.parse(readFileSync('package.json', 'utf8'));
pkg.devDependencies['eslint-plugin-better-tailwindcss'] = '^4.10.0';
Object.assign(pkg.scripts, {
	lint: 'prettier --check . && eslint .',
	'test:unit': 'vitest run',
	'test:e2e': 'playwright test',
	test: 'vitest run && playwright test',
	gates: 'pnpm lint && pnpm check && pnpm test',
	start: 'node build',
	'design:screenshots': 'storybook build --quiet && node scripts/screenshot-stories.js'
});
writeFileSync('package.json', JSON.stringify(pkg, null, '\t') + '\n');
EOF

echo "scaffold: moving the app into $root"
# Files the project already has (README, .gitignore, ...) are kept; .gitignore
# lines from the app are appended when missing.
for entry in $(ls -A); do
	if [ "$entry" = .gitignore ] && [ -e "$root/.gitignore" ]; then
		while IFS= read -r line; do
			grep -qxF -- "$line" "$root/.gitignore" || printf '%s\n' "$line" >>"$root/.gitignore"
		done <.gitignore
	elif [ ! -e "$root/$entry" ]; then
		cp -r "$entry" "$root/$entry"
	else
		echo "scaffold: kept the project's existing $entry"
	fi
done

cd "$root"
echo "scaffold: installing dependencies"
pnpm install </dev/null
pnpm exec playwright install chromium </dev/null
pnpm format </dev/null >/dev/null

echo "scaffold: done"
