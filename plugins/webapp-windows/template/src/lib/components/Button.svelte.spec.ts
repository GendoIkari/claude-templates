import { createRawSnippet } from 'svelte';
import { page } from 'vitest/browser';
import { describe, expect, it, vi } from 'vitest';
import { render } from 'vitest-browser-svelte';
import Button from './Button.svelte';

const label = createRawSnippet(() => ({ render: () => '<span>Save changes</span>' }));

describe('Button', () => {
	it('calls onclick when pressed', async () => {
		const onclick = vi.fn();
		render(Button, { children: label, onclick });

		await page.getByRole('button', { name: 'Save changes' }).click();

		expect(onclick).toHaveBeenCalledOnce();
	});

	it('does not call onclick while disabled', async () => {
		const onclick = vi.fn();
		render(Button, { children: label, onclick, disabled: true });

		await page.getByRole('button', { name: 'Save changes' }).click({ force: true });

		expect(onclick).not.toHaveBeenCalled();
	});
});
