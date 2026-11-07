<!--
	Reference design-system component: copy its shape for new components.
	Props in, callbacks out, no I/O, styled only with theme utilities, and no
	`class` or `style` prop, so callers cannot restyle it.
-->
<script lang="ts">
	import type { Snippet } from 'svelte';
	import type { HTMLButtonAttributes } from 'svelte/elements';

	type Props = Omit<HTMLButtonAttributes, 'class' | 'style'> & {
		variant?: 'primary' | 'secondary' | 'danger';
		size?: 'sm' | 'md';
		children: Snippet;
	};

	let { variant = 'primary', size = 'md', type = 'button', children, ...rest }: Props = $props();

	const variantClasses = {
		primary: 'bg-accent text-fg-on-accent hover:bg-accent-hover',
		secondary: 'border border-border bg-surface text-fg hover:bg-surface-sunken',
		danger: 'bg-danger text-fg-on-accent hover:bg-danger-hover'
	};

	const sizeClasses = {
		sm: 'h-8 px-3 text-sm',
		md: 'h-10 px-4 text-base'
	};
</script>

<button
	{type}
	class={[
		'inline-flex items-center justify-center gap-2 rounded-control font-medium transition-colors disabled:cursor-not-allowed disabled:opacity-50',
		variantClasses[variant],
		sizeClasses[size]
	]}
	{...rest}
>
	{@render children()}
</button>
