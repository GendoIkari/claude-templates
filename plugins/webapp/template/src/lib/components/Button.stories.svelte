<script module lang="ts">
	import { defineMeta } from '@storybook/addon-svelte-csf';
	import { fn } from 'storybook/test';
	import Button from './Button.svelte';

	const { Story } = defineMeta({
		title: 'Components/Button',
		component: Button,
		args: { onclick: fn() }
	});
</script>

{#snippet template(args: Record<string, unknown>)}
	<Button {...args}>Save changes</Button>
{/snippet}

<Story name="Primary" args={{ variant: 'primary' }} {template} />

<Story name="Secondary" args={{ variant: 'secondary' }} {template} />

<Story name="Danger" args={{ variant: 'danger' }} {template} />

<Story name="Small" args={{ size: 'sm' }} {template} />

<Story name="Disabled" args={{ disabled: true }} {template} />
