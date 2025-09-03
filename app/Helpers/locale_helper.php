<?php

use CodeIgniter\HTTP\IncomingRequest;

if (! function_exists('localized_site_url')) {
    /**
     * Generate a site_url() optionally prefixed with a locale.
     *
     * Behavior:
     * - If $locale is provided, always prefix with that locale.
     * - Else, if the current request URL starts with a supported locale segment, prefix with that segment.
     * - Otherwise, do NOT add a locale prefix (use plain URLs).
     *
     * @param string|null $path   Path without leading slash (e.g., 'admin/login')
     * @param string|null $locale Optional locale to force.
     */
    function localized_site_url(?string $path = '', ?string $locale = null): string
    {
        $app  = config('App');
        $path = ltrim((string) $path, '/');

        // If a locale is explicitly forced, always prefix
        if ($locale !== null && $locale !== '') {
            $prefix = rtrim($locale, '/');
            return site_url($path === '' ? $prefix : $prefix . '/' . $path);
        }

        // Otherwise, only prefix when the first segment is a supported locale
        /** @var IncomingRequest|null $request */
        $request = service('request');
        $first = '';
        try {
            $uri = $request ? $request->getUri() : service('uri');
            if ($uri) {
                $first = $uri->getSegment(1) ?? '';
            }
        } catch (\Throwable $e) {
            $first = '';
        }

        if ($first !== '' && in_array($first, $app->supportedLocales, true)) {
            $prefix = rtrim($first, '/');
            return site_url($path === '' ? $prefix : $prefix . '/' . $path);
        }

        // Default: no locale prefix
        return site_url($path);
    }
}

if (! function_exists('localized_redirect')) {
    /**
     * Helper to redirect to a (optionally) localized path.
     */
    function localized_redirect(string $path, ?string $locale = null)
    {
        return redirect()->to(localized_site_url($path, $locale));
    }
}
