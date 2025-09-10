# API Tasks Checklist (OpenAPI 3.1.1, SPA-ready)

This checklist enumerates the actionable work to expose a stateless REST API for the SPA, aligned with OpenAPI 3.1.1 and the database schema (see docs/Docker_8_4-2025_09_06_17_18_11-dump.sql). Each item starts with [ ] so it can be checked off when completed.

1. [ ] Foundations: API strategy and standards
   1. [ ] Confirm API base path `/api/v2` and content negotiation `application/json; charset=utf-8`.
   2. [ ] Ensure stateless auth (Authorization: Bearer <token>) for all `/api/v2/*`; do not use session AuthFilter (see Filters.php). Add an `ApiAuthFilter` for token validation. 
   3. [ ] CORS: Implement a CORS filter for SPA origins; handle OPTIONS preflight for `/api/v2/*`.
   4. [ ] Envelope: Adopt docs/api-format.md standard across all endpoints (success, code, message, data, errors, meta).
   5. [ ] Error model: Use 4xx/5xx with structured errors; 422 for validation, 409 for conflicts, 412 for ETag mismatch.
   6. [ ] Pagination/sorting/filtering/fields: Implement query params page, per_page, sort, q, fields consistently.
   7. [ ] ETag: Add conditional GETs for read endpoints; support If-None-Match and 304.
   8. [ ] Idempotency: For critical POST/PUT, accept Idempotency-Key header.
   9. [ ] Rate limiting: Define strategy (gateway/web server) and common 429 response format.

2. [ ] OpenAPI 3.1.1 specification
   1. [ ] Author docs/openapi.yaml with `openapi: 3.1.1`, bearer auth, tags, reusable schemas (envelope, pagination, error).
   2. [ ] Add entity schemas reflecting DB: users, roles, capabilities, companies, departments, stations, tanks, reels, sensors, devices, device_types, products, units, work_orders, dispense_transactions, audit_log, app_config, languages, time_zones, system_events, permission maps, tank_station_map.
   3. [ ] Include notes on foreign keys and ON DELETE rules in schema descriptions (e.g., departments.company_id ON DELETE CASCADE).
   4. [ ] Define endpoints: list/detail for read, CRUD where needed; include parameters, responses, examples, ETag headers.
   5. [ ] Validate the spec with an external validator (Redocly/Swagger CLI) and fix issues.
   6. [ ] Document how to serve the spec statically (e.g., /docs/openapi.yaml via web server).

3. [ ] Authentication endpoints (stateless)
   1. [ ] POST /api/v2/auth/login: validate credentials (e.g., PIN), issue JWT/access token; 201 on success.
   2. [ ] POST /api/v2/auth/logout: optional server-side token revocation/blacklist.
   3. [ ] POST /api/v2/auth/agreement/accept: record acceptance (returns 204/200).
   4. [ ] Define token TTL, refresh mechanism (optional), and error codes for blocked/expired/shift-invalid.

4. [ ] Users and access control
   1. [ ] GET /api/v2/users: list with pagination/filtering; projection fields.
   2. [ ] GET /api/v2/users/{id}
   3. [ ] POST /api/v2/users (admin only)
   4. [ ] PUT/PATCH /api/v2/users/{id}
   5. [ ] DELETE /api/v2/users/{id}
   6. [ ] GET /api/v2/users/{id}/roles
   7. [ ] PUT /api/v2/users/{id}/roles: replace roles (respect user_roles ON DELETE CASCADE)
   8. [ ] GET /api/v2/roles, GET /api/v2/capabilities
   9. [ ] GET /api/v2/roles/{id}/capabilities
   10. [ ] PUT /api/v2/roles/{id}/capabilities (role_capabilities ON DELETE CASCADE)

5. [ ] Companies and departments
   1. [ ] GET /api/v2/companies
   2. [ ] GET /api/v2/companies/{id}
   3. [ ] CRUD /api/v2/companies (consider preventing DELETE if cascading effects undesired)
   4. [ ] GET /api/v2/companies/{id}/departments
   5. [ ] Departments CRUD; note: departments.company_id ON DELETE CASCADE

6. [ ] Products and units
   1. [ ] GET /api/v2/products; GET /api/v2/products/{id}
   2. [ ] Units lookup: GET /api/v2/units
   3. [ ] CRUD products (FK: products.default_unit_id -> units)

7. [ ] Stations, tanks, reels, sensors (dispensing topology)
   1. [ ] Stations: GET /api/v2/stations, GET /api/v2/stations/{id}
   2. [ ] Reels: GET /api/v2/reels, GET /api/v2/reels/{id}
   3. [ ] Tanks: GET /api/v2/tanks, GET /api/v2/tanks/{id} (include ETag; aligns with existing TankApiController)
   4. [ ] Sensors: GET /api/v2/sensors, GET /api/v2/sensors/{id}
   5. [ ] Tank-Station visibility map: GET /api/v2/tank-station-map; CRUD respecting composite PK and CASCADE.
   6. [ ] FK notes: reels.station_id/tank_id; sensors.tank_id ON DELETE CASCADE; sensors.device_id ON DELETE SET NULL.

8. [ ] Devices and device types
   1. [ ] GET /api/v2/device-types
   2. [ ] GET /api/v2/devices, GET /api/v2/devices/{id}
   3. [ ] CRUD devices (FK: device_type_id; parent_device_id self-ref; no cascade on delete; enforce business rules)

9. [ ] Work orders and dispensing
   1. [ ] Work Orders: GET list/detail; CRUD as needed (FK: work_orders.created_by -> users)
   2. [ ] Dispense transactions: GET list/detail; creation is typically from device workflow; read-only for SPA initially. FKs: many refs (users, stations, reels, tanks, products, units, work_orders).

10. [ ] Audit log
   1. [ ] GET /api/v2/audit-log with filters (user_id, event_id, station_id, device_id, tank_id, date range)
   2. [ ] Note: audit_log uses ON DELETE SET NULL for most FKs; ensure joins handle nulls.

11. [ ] App configuration and lookups
   1. [ ] GET /api/v2/config (public subset is_public=1)
   2. [ ] Admin config CRUD: POST/PUT/PATCH /api/v2/config/{config_key} (PK is string; useAutoIncrement=false)
   3. [ ] Lookups: GET /api/v2/languages, /time-zones, /units, /device-types, /system-events, /capabilities, /roles

12. [ ] Permissions endpoints
   1. [ ] User-station permissions: GET/PUT/DELETE composite entries (ON DELETE CASCADE on user_id/station_id)
   2. [ ] User-tank permissions: GET/PUT/DELETE (can_dispense/can_override)
   3. [ ] User-reel permissions: GET/PUT/DELETE

13. [ ] Concurrency, caching, and headers
   1. [ ] Support ETag/If-None-Match on list and detail endpoints.
   2. [ ] For updates, support If-Match with 412 on mismatch (optimistic concurrency) where applicable.
   3. [ ] Standard headers in meta: request_id, timestamp, version.

14. [ ] Security and filtering
   1. [ ] Enforce authorization by capability/role where required (e.g., user.manage, role.manage, tank.manage).
   2. [ ] Ensure sensitive fields (password_hash, pin_hash) are never returned.

15. [ ] Routing & filters
   1. [ ] Consolidate api/v2 route groups to avoid mixed filters; ensure CSRF is disabled for `/api/v2/*` and no session AuthFilter.
   2. [ ] Add routes for read endpoints first (stations, tanks, reels, products, lookups), then CRUD routes.

16. [ ] Implementation milestones (initial subset for SPA)
   1. [ ] Align TankApiController responses with the standard envelope (add success/code/message, keep ETag).
   2. [ ] Implement GET /api/v2/stations using StationModel.
   3. [ ] Implement GET /api/v2/reels using ReelModel.
   4. [ ] Implement GET /api/v2/products (add ProductModel) and GET /api/v2/units.
   5. [ ] Add bearer token enforcement via ApiAuthFilter and apply to non-auth endpoints.

17. [ ] Testing
   1. [ ] Add PHPUnit tests for envelope, status codes, pagination, and ETag behavior.
   2. [ ] Add tests for auth flow and protected endpoints requiring Authorization header.

18. [ ] Documentation
   1. [ ] Update docs/api-format.md to explicitly state OpenAPI 3.1.1 alignment and examples.
   2. [ ] Keep docs/openapi.yaml in sync with implemented endpoints.
   3. [ ] Provide examples and curl snippets for common endpoints.
