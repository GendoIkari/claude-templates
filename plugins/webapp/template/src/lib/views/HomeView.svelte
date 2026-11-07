<!--
	Reference view: the whole content of one page, built only from design-system
	components and layout utilities. It receives data as props and reports user
	actions through callbacks, so it can be rendered in stories and component
	tests without the route, its load function or a server.
-->
<script lang="ts">
	import Button from '$lib/components/Button.svelte';

	type Props = {
		appName: string;
		onstart: () => void;
	};

	let { appName, onstart }: Props = $props();
</script>

<main class="mx-auto flex max-w-2xl flex-col items-start gap-6 px-6 py-16">
	<h1 class="text-4xl font-semibold tracking-tight">{appName}</h1>
	<p class="text-lg text-fg-muted">The app is ready. Replace this view with the first real page.</p>
	<Button onclick={onstart}>Get started</Button>
</main>
