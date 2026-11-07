import type { Preview } from '@storybook/sveltekit';
import '../src/routes/layout.css';

const preview: Preview = {
	parameters: {
		controls: {
			matchers: {
				color: /(background|color)$/i,
				date: /Date$/i
			}
		},
		// Accessibility violations fail the story tests, and so the quality gates.
		a11y: { test: 'error' }
	}
};

export default preview;
