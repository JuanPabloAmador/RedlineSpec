import { defineConfig } from 'astro/config';
import { SITE_URL } from './src/i18n/site';

export default defineConfig({
  site: SITE_URL,
  i18n: {
    defaultLocale: 'en',
    locales: ['en', 'es'],
    routing: {
      prefixDefaultLocale: false,
    },
  },
  trailingSlash: 'ignore',
});
