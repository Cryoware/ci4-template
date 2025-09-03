<?php

namespace App\Filters;

use CodeIgniter\HTTP\RequestInterface;
use CodeIgniter\HTTP\ResponseInterface;
use CodeIgniter\Filters\FilterInterface;

class EnforceLocale implements FilterInterface
{
    public function before(RequestInterface $request, $arguments = null)
    {
        // Only set the request locale if the first URI segment is a supported locale.
        // Do NOT redirect or enforce locale in the URL.
        $uri  = service('uri');
        $app  = config('App');
        $first = $uri->getSegment(1) ?? '';

        if ($first !== '' && in_array($first, $app->supportedLocales, true)) {
            // Set the request locale to match explicit URL segment
            if (method_exists($request, 'setLocale')) {
                $request->setLocale($first);
            }
        }

        // Otherwise, do nothing. CI's negotiateLocale (if enabled) will select
        // the locale from Accept-Language headers or fall back to defaultLocale.
        return;
    }

    public function after(RequestInterface $request, ResponseInterface $response, $arguments = null)
    {
        // No-op
    }
}
