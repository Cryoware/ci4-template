<?php

namespace Config;

use App\Filters\AuthFilter;
use CodeIgniter\Config\BaseConfig;
use CodeIgniter\Filters\CSRF;
use CodeIgniter\Filters\DebugToolbar;
use CodeIgniter\Filters\Honeypot;
use CodeIgniter\Filters\InvalidChars;
use CodeIgniter\Filters\SecureHeaders;

class Filters extends BaseConfig
{
    /**
     * Configures aliases for Filter classes to
     * make reading things nicer and simpler.
     *
     * @var array<string, list<string>|string>
     */
    public array $aliases = [
        'csrf'         => CSRF::class,
        'toolbar'      => DebugToolbar::class,
        'honeypot'     => Honeypot::class,
        'invalidchars' => InvalidChars::class,
        'secureheaders'=> SecureHeaders::class,

        // Project-specific
        'auth'         => AuthFilter::class,
    ];

    /**
     * List of filter aliases that are always
     * applied before and after every request.
     *
     * @var array<string, array<string, list<string>|string>>
     */
    public array $globals = [
        'before' => [
            // 'honeypot',
            // 'csrf',
            // 'invalidchars',
        ],
        'after' => [
            'toolbar',
            // 'honeypot',
            // 'secureheaders',
        ],
    ];

    /**
     * List of filter aliases that work on a
     * particular HTTP method (GET, POST, etc.).
     *
     * Example:
     *  'post' => ['foo', 'bar']
     *
     * @var array<string, list<string>>
     */
    public array $methods = [];

    /**
     * List of filter aliases that should run on any
     * before or after URI patterns.
     *
     * Example:
     *  'isLoggedIn' => ['before' => ['account/*', 'profiles/*']]
     *
     * @var array<string, array<string, list<string>>>|
     *     array<string, list<string>>
     */
    public array $filters = [
        // 'auth' => ['before' => ['admin/*']], // Route-level used instead for parallel migration
    ];
}
