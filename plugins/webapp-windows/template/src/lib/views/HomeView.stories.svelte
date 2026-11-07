<script module lang="ts">
	import { defineMeta } from '@storybook/addon-svelte-csf';
	import { fn } from 'storybook/test';
	import HomeView from './HomeView.svelte';

	const { Story } = defineMeta({
		title: 'Views/HomeView',
		component: HomeView,
		args: { appName: 'Example app', onstart: fn() },
		parameters: { layout: 'fullscreen' }
	});
</script>

<Story name="Default" />

<Story name="Long name" args={{ appName: 'An application with a much longer name than usual' }} />
