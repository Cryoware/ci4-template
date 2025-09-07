1. [ ] Replace the default README.md with a project-specific guide: environment requirements (PHP 8.1+, extensions), installation, serving locally (php spark serve), Docker quick start (ports, services, credentials), baseURL configuration, and routes overview (public, admin, api/v1). Include test commands and coverage instructions.
2. [ ] Consolidate duplicate admin route groups in app\Config\Routes.php to a single, clear grouping (e.g., /admin with 'auth' filter) and remove redundant root-level duplicates. Verify no route shadowing/conflicts.
3. [ ] Consolidate API routing: keep a single $routes->group('api/v1', ...) block. Remove session-based 'auth' filter from API routes to uphold statelessness; move auth enforcement to a dedicated API auth filter.
4. [ ] Introduce ApiAuthFilter (token-based) to validate Authorization: Bearer <token> for api/v1/*, set request user context (without using PHP sessions), and return standardized JSON 401/403 on failure.
5. [ ] Implement a CORS filter for api/v1/*: set Access-Control-Allow-* headers, allow configured origins, methods, and headers; short-circuit OPTIONS preflight with 204.
6. [ ] Standardize API envelope across all controllers (AuthApiController, UsersApiController, TankApiController, etc.) per docs\api-format.md: success, code, message, data, errors[], meta{ request_id, timestamp, version }.
7. [ ] Extract a reusable ResponseEnvelope trait/helper to build consistent envelopes and status codes; refactor controllers to use it.
8. [ ] Remove session usage from AuthApiController (stateless principle). Issue signed access tokens (e.g., JWT) on successful login; include token expiry and scopes/role claims. Adjust logout semantics (client-side token discard, optional server revocation list).
9. [ ] Add refresh token flow (optional): long-lived refresh stored securely (httpOnly cookie for web or secure storage for mobile) with a /api/v1/auth/refresh endpoint.
10. [ ] Enforce content negotiation for api/v1: require Accept: application/json; respond with application/json; charset=utf-8 and 406/415 when appropriate.
11. [ ] Implement Idempotency-Key support for POST/PUT/PATCH on critical endpoints to avoid duplicate processing for mobile/poor networks.
12. [ ] Apply ETag/If-None-Match to list/show endpoints consistently (UsersApiController and others), following TankApiController’s example; return 304 when unchanged.
13. [ ] Implement If-Match for conditional updates (update/delete): return 412 Precondition Failed on ETag mismatch.
14. [ ] Add pagination envelope (meta.pagination + meta.links) to index/list endpoints; support page, per_page, sort, filter, fields query params per docs\api-format.md.
15. [ ] Refactor UsersApiController: separate DataTables-specific concerns from core CRUD; move business logic to a Service/Library; keep controller thin.
16. [ ] Centralize validation rules/messages per resource (e.g., Validation classes or dedicated FormRequest-like helpers) to avoid duplication; ensure 422 responses with structured errors.
17. [ ] Ensure all API errors use machine-readable codes (dot.notation) and include a human-friendly message; map common exceptions to standardized responses (404, 405, 409, 422, 500).
18. [ ] Add a global API exception handler (or filter) to transform uncaught exceptions into the standard envelope with correlation id.
19. [ ] Add request correlation IDs: generate request_id (UUID v4) per request, include in meta and logs.
20. [ ] Security headers: enable/adjust SecureHeaders filter (CSP, X-Content-Type-Options, X-Frame-Options) for web; tune for API responses (JSON only).
21. [ ] Rate limiting/throttling for api/v1 (by IP and/or token) with proper 429 responses and headers (Retry-After, RateLimit-*) where feasible.
22. [ ] Harden input handling: sanitize/escape outputs where needed, enforce strict typing where possible, and prefer Query Builder/Models to avoid injection.
23. [ ] Database: review and create migrations for critical tables (users, tokens, roles). Ensure appropriate unique indexes (e.g., email), foreign keys, and needed query indexes for DataTables filters.
24. [ ] Move any raw SQL in models to query builder methods; add typed return annotations and PHP 8.1+ types to models and services.
25. [ ] Implement repository/service boundaries for complex business logic (auth post-checks, shift validations) so controllers delegate and remain thin.
26. [ ] Normalize date/time handling to UTC in storage and provide client-friendly time zones via meta; avoid PHP date() scattered usage—use Time class or DateTimeImmutable.
27. [ ] Add consistent logging with context (user_id, route, request_id); ensure sensitive data (passwords, tokens) is never logged.
28. [ ] Improve composer tooling: add phpstan/psalm (static analysis), squizlabs/php_codesniffer (PSR-12), friendsofphp/php-cs-fixer config; wire scripts: composer analyse, composer cs, composer cs:fix, composer test:cov.
29. [ ] Integrate a CI workflow (GitHub Actions or similar): install deps, run linters, static analysis, tests with coverage, and archive build/logs artifacts.
30. [ ] Expand tests:
    - Unit tests for ResponseEnvelope helper and validation rules.
    - Feature tests for auth login/logout/refresh (stateless), CORS preflight, ETag 304 paths, and 412 precondition failures.
    - Controller tests for Users CRUD with envelope + pagination.
    - Security tests for rate limiting and auth-required endpoints.
31. [ ] Add test fixtures/factories and seeders for users/roles to support repeatable tests; use a dedicated test database via phpunit.xml.dist env vars.
32. [ ] Document and validate OpenAPI 3.1.1 spec at docs\openapi.yaml for all /api/v1 endpoints; align components/schemas with docs\api-format.md; add validation to CI.
33. [ ] Serve docs\openapi.yaml statically (e.g., /docs/openapi.yaml) and add instructions for visualizing with Swagger UI/Redoc (no runtime dependency required).
34. [ ] Create a simple CORS configuration in app\Config to manage allowed origins per environment; document defaults and overrides in .env.
35. [ ] Audit Routes.php for localized routes: ensure localized and non-localized routes do not conflict; add redirects where needed.
36. [ ] Ensure CSRF remains disabled for api/v1 but enabled where appropriate for session-based admin forms; document rationale.
37. [ ] Replace any magic numbers/strings (role ids, statuses) with enums (App\Enums) where missing; ensure validation aligns with enums.
38. [ ] Implement consistent HTTP method checks returning 405 with Allow header when method is not supported.
39. [ ] Add Location header on 201 Created responses with the canonical URI of new resources.
40. [ ] Normalize JSON parsing: prefer $this->request->getJSON(true) with fallback to getPost(); return 415 for bad or missing JSON when required.
41. [ ] Improve DataTables integration: align columns mapping, support server-side filtering securely, and cap max page/per_page to avoid heavy queries.
42. [ ] Add caching strategy for read-heavy endpoints (HTTP caching via ETag/Cache-Control; optional server caching with invalidation hooks).
43. [ ] Ensure writable/ directories permissions are handled in Docker and documented; avoid storing secrets in the repo.
44. [ ] Verify Cookie and Session configurations: keep sessions for admin UI only; set secure, httpOnly, sameSite appropriately in production.
45. [ ] Add a secrets management approach for JWT keys/API keys (env vars, Docker secrets); rotate keys and document rotation procedure.
46. [ ] Add health and readiness endpoints for ops (/health, /ready) that return basic service status without leaking sensitive info.
47. [ ] Implement structured error codes registry (docs) mapping to HTTP statuses and messages to avoid ad-hoc codes.
48. [ ] Review and remove legacy/unused routes (e.g., optional legacy alias dashboard/get_reels) or guard behind feature flags.
49. [ ] Add localization/i18n plan for API messages (or map codes to client-side localization); ensure meta.version is kept in sync.
50. [ ] Create developer onboarding checklist in docs (tools, PHP extensions, Xdebug for coverage, common commands) and link from README.
