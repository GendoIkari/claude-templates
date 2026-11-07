<script lang="ts">
	import { resolve } from '$app/paths';
	import { page } from '$app/state';
</script>

<svelte:head>
	<title>{page.status}</title>
</svelte:head>

<main class="mx-auto flex max-w-2xl flex-col gap-4 px-6 py-16">
	<p class="text-sm font-medium text-danger">Error {page.status}</p>
	<h1 class="text-3xl font-semibold tracking-tight">
		{page.status === 404 ? 'Page not found' : 'Something went wrong'}
	</h1>
	{#if page.error?.message}
		<p class="text-fg-muted">{page.error.message}</p>
	{/if}
	<a class="font-medium text-accent hover:text-accent-hover" href={resolve('/')}
		>Back to the home page</a
	>
</main>
