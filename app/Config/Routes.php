<?php

use CodeIgniter\Router\RouteCollection;

/**
 * @var RouteCollection $routes
 */

// -----------------------------------------------------------------------------
// Public Routes
// -----------------------------------------------------------------------------
$routes->get('/', 'AuthController::login', ['namespace' => 'App\\Controllers\\Admin']);
$routes->get('/login', 'AuthController::login', ['namespace' => 'App\\Controllers\\Admin']);
$routes->get('/logout', 'AuthController::logout', ['namespace' => 'App\\Controllers\\Admin']);

$routes->get('avatar', 'Avatar::index', ['namespace' => 'App\Controllers']);

// -----------------------------------------------------------------------------
// Authenticated Routes
// -----------------------------------------------------------------------------
$routes->group('/',['namespace' => 'App\\Controllers\\Admin', 'filter' => 'auth'], static function (RouteCollection $routes) {
    $routes->get('dashboard', 'Dashboard::index', ['namespace' => 'App\\Controllers\\Admin']);
    $routes->get('settings', 'Settings::index', ['namespace' => 'App\\Controllers\\Admin']);

});

$routes->group('admin',['namespace' => 'App\\Controllers\\Admin', 'filter' => 'auth'], static function (RouteCollection $routes) {
    $routes->get('login', 'AuthController::login');
    $routes->get('logout', 'AuthController::logout');
    $routes->get('dashboard', 'Dashboard::index');
    $routes->get('settings', 'Settings::index');
    $routes->post('settings/save', 'Settings::save');

    // Admin Users UI
    $routes->get('users', 'Users::index');
    // Optional: if you plan to have a dedicated edit page route (not used with modal)
    $routes->get('users/(:num)', 'Users::edit/$1');

});
$routes->group('{locale}', static function (RouteCollection $routes) {

});

// API v1 routes for users
$routes->group('api/v1',['namespace' => 'App\Controllers', 'filter' => 'auth'], static function ($routes) {
    // DataTables index (GET), create (POST)
    $routes->get('users', 'Api\V1\UsersApiController::index');
    $routes->post('users', 'Api\V1\UsersApiController::create');

    // Show, update, delete
    $routes->get('users/(:num)', 'Api\V1\UsersApiController::show/$1');
    $routes->put('users/(:num)', 'Api\V1\UsersApiController::update/$1');
    $routes->patch('users/(:num)', 'Api\V1\UsersApiController::update/$1');
    $routes->delete('users/(:num)', 'Api\V1\UsersApiController::delete/$1');
});

// -----------------------------------------------------------------------------
// Localized public routes (first URL segment is the locale)
// Example: /en/reels, /zh/reels
// -----------------------------------------------------------------------------
$routes->group('{locale}', ['namespace' => 'App\Controllers'], static function ($routes) {
    // If you later localize more public pages, add them here, e.g.:
});

// -----------------------------------------------------------------------------
// Public fallbacks (non-localized -> redirect to default locale)
// -----------------------------------------------------------------------------
$routes->match(['GET', 'POST'], 'reels', 'ReelsController::index', ['namespace' => 'App\Controllers']);

// Optional legacy alias (if something still calls this path)
$routes->match(['GET', 'POST'], 'dashboard/get_reels', 'ReelsController::index', ['namespace' => 'App\Controllers']);

// -----------------------------------------------------------------------------
// API
// -----------------------------------------------------------------------------
$routes->group('api/v1', ['namespace' => 'App\Controllers'], static function($routes) {
    // Auth
    $routes->post('auth/login', 'Api\V1\AuthApiController::login');
    $routes->post('auth/logout', 'Api\V1\AuthApiController::logout');
    $routes->post('auth/agreement/accept', 'Api\V1\AuthApiController::agreementAccept');
});
