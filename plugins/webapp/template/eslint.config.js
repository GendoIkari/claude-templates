import prettier from 'eslint-config-prettier';
import path from 'node:path';
import js from '@eslint/js';
import svelte from 'eslint-plugin-svelte';
import betterTailwindcss from 'eslint-plugin-better-tailwindcss';
import { defineConfig, includeIgnoreFile } from 'eslint/config';
import globals from 'globals';
import ts from 'typescript-eslint';

const gitignorePath = path.resolve(import.meta.dirname, '.gitignore');

export default defineConfig(
	includeIgnoreFile(gitignorePath),
	js.configs.recommended,
	ts.configs.recommended,
	svelte.configs.recommended,
	prettier,
	svelte.configs.prettier,
	{
		languageOptions: { globals: { ...globals.browser, ...globals.node } },
		rules: {
			// typescript-eslint recommends turning no-undef off in TypeScript projects.
			'no-undef': 'off'
		}
	},
	{
		files: ['**/*.svelte', '**/*.svelte.ts', '**/*.svelte.js'],
		languageOptions: {
			parserOptions: {
				projectService: true,
				extraFileExtensions: ['.svelte'],
				parser: ts.parser
			}
		}
	},
	{
		// Design system: only classes generated from src/lib/theme/theme.css exist.
		files: ['src/**/*.svelte', 'src/**/*.ts'],
		plugins: { 'better-tailwindcss': betterTailwindcss },
		settings: { 'better-tailwindcss': { entryPoint: 'src/routes/layout.css' } },
		rules: {
			'better-tailwindcss/no-unknown-classes': 'error',
			'better-tailwindcss/no-conflicting-classes': 'error',
			'better-tailwindcss/no-duplicate-classes': 'error',
			'better-tailwindcss/no-deprecated-classes': 'error',
			'better-tailwindcss/no-restricted-classes': [
				'error',
				{
					restrict: [
						{
							pattern: '\\[.*\\]',
							message: 'Arbitrary values bypass the theme. Use a theme token or add one to src/lib/theme/theme.css.'
						}
					]
				}
			]
		}
	},
	{
		// Design-system components, views and pages never set inline styles.
		files: ['src/**/*.svelte'],
		rules: {
			'svelte/no-inline-styles': 'error'
		}
	}
);
