<script lang="ts">
	import HomeView from '#lib/views/HomeView.svelte';

	function start() {
		// Wire the first real user flow here, through a system in #lib/systems.
	}
</script>

<svelte:head>
	<title>Home</title>
</svelte:head>

<HomeView appName="App" onstart={start} />
