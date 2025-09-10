<?php

use CodeIgniter\Router\RouteCollection;

/**
 * @var RouteCollection $routes
 */

$routes->get('home', 'Home::index');

$routes->group('api/v2',['namespace' => 'App\\Controllers\\Api\\V2'], static function ($routes) {
    // Auth endpoints
    $routes->post('auth/login', 'AuthApiController::login', ['as' => 'api.v2.auth.login']);
    $routes->post('auth/logout', 'AuthApiController::logout', ['as' => 'api.v2.auth.logout']);
    $routes->post('auth/agreement/accept', 'AuthApiController::acceptAgreement', ['as' => 'api.v2.auth.agreement.accept']);
    $routes->post('refresh', 'AuthApiController::refresh', ['as' => 'api.v2.auth.refresh']);
    $routes->get('auth/me', 'AuthApiController::me', ['as' => 'api.v2.auth.me']);

    // Swagger spec (served as text)
    $routes->get('swagger.yaml', 'Swagger::index', ['as' => 'api.v2.swagger']);

    // Serve isolated Swagger UI page
    $routes->get('docs', 'Swagger::ui', ['as' => 'api.v2.docs']);

    // Resource routes (CRUD) for catalog-like entities
    // Note: Use singular controller names and explicit placeholders to match primary keys
    $routes->resource('languages', [
        'controller'   => 'LanguagesController',
        'placeholder'  => 'language_id',
        'names'        => [
            'index'  => 'api.v2.languages.index',
            'show'   => 'api.v2.languages.show',
            'create' => 'api.v2.languages.create',
            'update' => 'api.v2.languages.update',
            'delete' => 'api.v2.languages.delete',
            'new'    => 'api.v2.languages.new',
            'edit'   => 'api.v2.languages.edit',
        ],
    ]);

    $routes->resource('companies', [
        'controller'   => 'CompaniesController',
        'placeholder'  => 'company_id',
        'names'        => [
            'index'  => 'api.v2.companies.index',
            'show'   => 'api.v2.companies.show',
            'create' => 'api.v2.companies.create',
            'update' => 'api.v2.companies.update',
            'delete' => 'api.v2.companies.delete',
            'new'    => 'api.v2.companies.new',
            'edit'   => 'api.v2.companies.edit',
        ],
    ]);

    $routes->resource('departments', [
        'controller'   => 'DepartmentsController',
        'placeholder'  => 'department_id',
        'names'        => [
            'index'  => 'api.v2.departments.index',
            'show'   => 'api.v2.departments.show',
            'create' => 'api.v2.departments.create',
            'update' => 'api.v2.departments.update',
            'delete' => 'api.v2.departments.delete',
            'new'    => 'api.v2.departments.new',
            'edit'   => 'api.v2.departments.edit',
        ],
    ]);

    $routes->resource('time-zones', [
        'controller'   => 'TimeZonesController',
        'placeholder'  => 'time_zone_id',
        'names'        => [
            'index'  => 'api.v2.timezones.index',
            'show'   => 'api.v2.timezones.show',
            'create' => 'api.v2.timezones.create',
            'update' => 'api.v2.timezones.update',
            'delete' => 'api.v2.timezones.delete',
            'new'    => 'api.v2.timezones.new',
            'edit'   => 'api.v2.timezones.edit',
        ],
    ]);

    $routes->resource('roles', [
        'controller'   => 'RolesController',
        'placeholder'  => 'role_id',
        'names'        => [
            'index'  => 'api.v2.roles.index',
            'show'   => 'api.v2.roles.show',
            'create' => 'api.v2.roles.create',
            'update' => 'api.v2.roles.update',
            'delete' => 'api.v2.roles.delete',
            'new'    => 'api.v2.roles.new',
            'edit'   => 'api.v2.roles.edit',
        ],
    ]);

    $routes->resource('users', [
        'controller'   => 'UsersController',
        'placeholder'  => 'user_id',
        'names'        => [
            'index'  => 'api.v2.users.index',
            'show'   => 'api.v2.users.show',
            'create' => 'api.v2.users.create',
            'update' => 'api.v2.users.update',
            'delete' => 'api.v2.users.delete',
            'new'    => 'api.v2.users.new',
            'edit'   => 'api.v2.users.edit',
        ],
    ]);

    $routes->resource('products', [
        'controller'   => 'ProductsController',
        'placeholder'  => 'product_id',
        'names'        => [
            'index'  => 'api.v2.products.index',
            'show'   => 'api.v2.products.show',
            'create' => 'api.v2.products.create',
            'update' => 'api.v2.products.update',
            'delete' => 'api.v2.products.delete',
            'new'    => 'api.v2.products.new',
            'edit'   => 'api.v2.products.edit',
        ],
    ]);

    $routes->resource('units', [
        'controller'   => 'UnitsController',
        'placeholder'  => 'unit_id',
        'names'        => [
            'index'  => 'api.v2.units.index',
            'show'   => 'api.v2.units.show',
            'create' => 'api.v2.units.create',
            'update' => 'api.v2.units.update',
            'delete' => 'api.v2.units.delete',
            'new'    => 'api.v2.units.new',
            'edit'   => 'api.v2.units.edit',
        ],
    ]);

    $routes->resource('tanks', [
        'controller'   => 'TanksController',
        'placeholder'  => 'tank_id',
        'names'        => [
            'index'  => 'api.v2.tanks.index',
            'show'   => 'api.v2.tanks.show',
            'create' => 'api.v2.tanks.create',
            'update' => 'api.v2.tanks.update',
            'delete' => 'api.v2.tanks.delete',
            'new'    => 'api.v2.tanks.new',
            'edit'   => 'api.v2.tanks.edit',
        ],
    ]);
});

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

    // Tanks (stateless)
    $routes->get('tanks', 'Api\V1\TankApiController::index');
    $routes->get('tanks/stream', 'Api\V1\TankApiController::stream');
    $routes->get('tanks/(:num)', 'Api\V1\TankApiController::show/$1');
});
