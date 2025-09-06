# Project Development Guidelines (CI4 Template)

Audience: Advanced PHP/CodeIgniter 4 developers working on this repository.

Last updated: 2025-09-06

## 1) Build & Configuration

Environment
- PHP: >= 8.1 with intl, mbstring, json, curl (for HTTP client), mysqlnd if using MySQL.
- Composer installed locally.
- Node is not required for PHP runtime; AdminLTE assets are vendored.

Install
- PowerShell (Windows):
  - composer install
- Linux/macOS: composer install

Application bootstrap
- Copy env to .env and adjust at least:
  - app.baseURL = http://localhost:8484/ (when using Docker web) or your local domain.
  - database.* when you use DB features.
- Public dir is ./public; your web server must point there (or use php spark serve for local dev).

Serve locally (no Docker)
- PowerShell: php .\spark serve --port 8080
- Browse: http://localhost:8080/

Dockerized stack (provided)
- Compose file: docker\docker-compose.yml
  - Web (Apache+PHP) maps host port 8484 -> container 80 and binds the repo at /var/www/html
  - MySQL 8.4 on 3306 with preconfigured DB oilcop_g2 and credentials (see compose)
  - phpMyAdmin on http://localhost:8080
- Quick start from project root:
  - docker compose -f .\docker\docker-compose.yml up -d --build
  - App: http://localhost:8484/
  - phpMyAdmin: http://localhost:8080 (root/rootpassword)

Autoloading & structure
- PSR-4 namespaces: App\ -> app/, Config\ -> app/Config/ (composer.json)
- CI4 framework is a dependency (vendor/codeigniter4/framework)

Routing & filters (project specifics)
- Routes: app\Config\Routes.php
  - Public: /, /login, /logout, avatar
  - Admin (requires session-auth via AuthFilter): /dashboard, /settings, /admin/*
  - API v1: /api/v1/... (see below)
- Filters: app\Config\Filters.php
  - Alias auth => App\Filters\AuthFilter (session-based for admin UI)
  - csrf-exempt configured for api/v1/* (stateless APIs typically disable CSRF; rely on Authorization headers)
  - Debug toolbar enabled globally after request

Sessions/cookies
- app\Config\Session.php, app\Config\Cookie.php contain defaults. Admin UI uses session; APIs should be stateless (see Section 4).

## 2) Testing

Tooling
- PHPUnit ^10.5 is required. Root phpunit.xml.dist configures CI4 bootstrap and coverage output under build/logs.
- Composer script: composer test (runs phpunit)

Run tests (Windows / PowerShell)
- .\vendor\bin\phpunit -c .\phpunit.xml.dist --testdox
- Or: composer test

Run tests (Linux/macOS)
- ./vendor/bin/phpunit -c ./phpunit.xml.dist --testdox

Coverage (requires Xdebug, with xdebug.mode=coverage)
- .\vendor\bin\phpunit -c .\phpunit.xml.dist --coverage-html build\logs\html --coverage-text
- Outputs:
  - HTML: build/logs/html/index.html
  - Text summary to console

Test layout & helpers
- Tests are under tests/; CI4’s bootstrap is vendor/codeigniter4/framework/system/Test/bootstrap.php, configured in phpunit.xml.dist.
- Useful existing example: tests\unit\HealthTest.php checks APPPATH and baseURL validity.
- CI4 service helpers are available in tests (e.g., service('validation')).

Adding a new test (example used for verification)
- File path (temporary): tests\unit\GuidelinesSmokeTest.php
- Contents:
  - final class GuidelinesSmokeTest extends CodeIgniter\Test\CIUnitTestCase { public function testPhpunitBootstrapsAndBaseUrlIsSet(): void { $this->assertTrue(defined('APPPATH')); $this->assertSame('http://example.com/', $_SERVER['app.baseURL'] ?? null); } }
- Run just this test:
  - .\vendor\bin\phpunit -c .\phpunit.xml.dist --filter GuidelinesSmokeTest --testdox
- Notes:
  - This file was created solely to demonstrate the process and was removed after running (see project history). Keep your actual tests within tests\unit, tests\database, tests\session as appropriate.

Database tests
- phpunit.xml.dist includes commented environment variables for a dedicated tests connection. Prefer using a separate DB/schema when you need DB-dependent tests.

## 3) Additional Development Information

Coding standards
- Follow PSR-12. CI4 files are namespaced; class and file names are StudlyCaps.
- Keep controllers thin; push logic to Services/Libraries/Models.

Debugging
- CI4 Toolbar is enabled in Filters globals[after]. It surfaces queries, logs, etc.
- Kint (k(), d(), dd()) is available in dev; ensure display_errors is off in production.
- Writable directories: ensure ./writable and subfolders are writeable by the web user.

Docs inside repo
- docs\api-format.md defines the API response envelope, statuses, pagination, and ETag/caching guidance used by this project.
- docs\server-side_datatables.md covers DataTables integration used by the admin UI.
- docs\use-cases.md contains functional scenarios.

Routing/API controllers
- API routes: see app\Config\Routes.php groups under 'api/v1'. Controllers are in app\Controllers\Api\V1.
- For DataTables endpoints, follow docs\server-side_datatables.md and docs\api-format.md envelope.

Docker specifics
- Web container binds the repo into /var/www/html. If you see permission issues on Linux hosts, set USER_ID/GROUP_ID env vars for the container to your local UID/GID.
- MySQL container initializes from docker\mysql\mysql-init.sql. Credentials are defined in the compose file.

## 4) Stateless APIs (SPA/Mobile) & OpenAPI 3.1.1

Principles
- Statelessness: Do not rely on PHP sessions or cookies. Authenticate via Authorization: Bearer <token> (e.g., JWT) or signed API keys.
- Content negotiation: Accept: application/json; respond with application/json; charset=utf-8.
- Idempotency: For mutating endpoints, consider Idempotency-Key headers (especially for mobile clients).
- CORS: Enable for SPA/mobile origins. Implement a CORS filter/middleware to set Access-Control-* headers, and handle OPTIONS preflights for api/v1/*.
- Error model: Use the envelope in docs\api-format.md with success=false, code, message, and errors[].
- Versioning: Keep under /api/v1; plan for /api/v2 when breaking changes are needed.
- Caching: Support ETag/If-None-Match. For conditional updates use If-Match (412 on mismatch).

OpenAPI 3.1.1 compatibility
- Schema: All endpoints must be describable in an OpenAPI 3.1.1 document (openapi: 3.1.1). Prefer YAML at docs\openapi.yaml.
- Recommended approach (no new runtime dependency required):
  1) Author docs\openapi.yaml manually and keep it versioned alongside docs\api-format.md.
  2) Validate with an external tool (swagger-cli, Redocly CLI) in CI or locally.
  3) Serve the spec statically (e.g., /docs/openapi.yaml via web server) and use Swagger UI/Redoc for visualization.
- Optional generation (if you decide to add tooling in the future): use zircote/swagger-php (annotations) or league/openapi-psr7. This repo does not currently include those dependencies; keep APIs decoupled from annotations.

Controller patterns for stateless endpoints
- Do not call session() or use AuthFilter for /api/v1. Rely on a token validator (e.g., a custom filter like ApiAuthFilter) to enforce Authorization header and set request user context.
- Return JSON with explicit status codes. Example skeleton:
  - if ($this->request->getMethod() !== 'POST') { return $this->response->setStatusCode(405)->setJSON([ 'success' => false, 'code' => 'method.not_allowed', 'message' => 'Use POST' ]); }
  - return $this->response->setStatusCode(200)->setJSON([ 'success' => true, 'code' => '...', 'data' => [] ]);

Where to place the spec
- docs\openapi.yaml (recommended). Keep components/schemas aligned with docs\api-format.md (envelope, error object, pagination, links).

## 5) Project-specific gotchas & tips

- app\Config\Routes.php defines two api/v1 groups; ensure you consolidate when adding routes to avoid confusion (there is one with filter=auth for users and another for auth endpoints). For public stateless APIs, avoid the session-driven AuthFilter.
- Filters.php disables CSRF for api/v1/* via 'csrf-exempt'. Required for non-cookie auth; keep your APIs protected via Authorization headers.
- Datatables endpoints: server-side processing helper docs\server-side_datatables.md applies; keep responses compatible with the standard envelope.
- Default locale-based groups exist; be mindful when introducing localized routes.
- CI4 CLI: php .\spark list to discover handy commands (migrate, db:seed, routes, etc.).

## 6) Reproduced test run (process) and cleanup

Process used to demonstrate testing flow on Windows (PowerShell):
1) Create a simple unit test at tests\unit\GuidelinesSmokeTest.php (see content above).
2) Run it: .\vendor\bin\phpunit -c .\phpunit.xml.dist --filter GuidelinesSmokeTest --testdox
3) Confirmed the CI4 test bootstrap and app.baseURL injection are functioning.
4) Remove the temporary test file after verification to keep repository clean.

Only .junie\guidelines.md remains from this exercise. No other files were added.
