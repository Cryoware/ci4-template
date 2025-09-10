# API Response Format and Guidelines

This document defines the standard response envelope, HTTP status usage, and conventions for building and consuming the
OilCop G2 API. Use this as the single source of truth when converting legacy controllers to API endpoints.

Notes:

- Base versioned path: `/api/v2/...`
- Content type: `application/json; charset=utf-8`
- For existing web controllers (e.g., `/admin/login`), keep backward compatibility by either adding a parallel API route
  that follows this spec or by honoring content negotiation (`Accept: application/json`).
- `TankApiController` (app/Controllers/api/v2/TankApiController.php) already follows the general shape of this standard
  with `data` and `meta` and ETag support.
- OpenAPI spec: This guide aligns with OpenAPI 3.1.1; see `docs/openapi.yaml` for the canonical specification.
- Legacy naming note: All examples use the normalized schema (no legacy t_ table or f_ field prefixes). Field names like tank_id, station_id, product_id, etc., match the current database dump in docs\\Docker_8_4-2025_09_06_17_18_11-dump.sql.

## 1. Response Envelope

All JSON responses (success or error) SHOULD use the standard envelope below. For some simpler endpoints (e.g., existing
Tank endpoints), a subset is acceptable as long as it’s forward-compatible.

```jsonc
{
  "success": true,               // boolean: true for 2xx
  "code": "auth.logged_in",     // machine-readable, dot.notation
  "message": "Login successful",// human-friendly message (localized if feasible)
  "data": {                      // object|array|null: the payload
    "...": "..."
  },
  "errors": [                    // array of structured errors for non-2xx
    { "code": "validation.required", "message": "PIN is required", "field": "pin" }
  ],
  "meta": {                      // optional metadata
    "request_id": "<uuid>",
    "timestamp": "2025-08-20T16:02:00Z", // RFC 3339 UTC
    "version": "v1",
    "pagination": {              // when listing items
      "page": 1,
      "per_page": 50,
      "total": 123,
      "total_pages": 3
    },
    "links": {
        "self": "/api/v2/tanks?page=1",
        "first": "/api/v2/tanks?page=1",
        "prev": null,
        "next": "/api/v2/tanks?page=2",
        "last": "/api/v2/tanks?page=3"
    },
    "etag": "\"abc123\""       // when caching is used (see ETag)
  }
}
```

Minimum required fields:

- Success responses (2xx): `success: true`, may include `code`, `message`, `data`, optional `meta`.
- Error responses (4xx/5xx): `success: false`, MUST include an appropriate HTTP status, SHOULD include `code`,`message`,
  MAY include `errors` and `meta`.

## 2. HTTP Status Codes

- 200 OK: Success (GET/POST/PUT/PATCH/DELETE where a body is returned)
- 201 Created: Resource created (Location header recommended)
- 202 Accepted: Async processing started
- 204 No Content: Success, empty body
- 304 Not Modified: With `ETag` and `If-None-Match`

Client errors:

- 400 Bad Request: Invalid input/parameters
- 401 Unauthorized: Not authenticated or bad credentials
- 403 Forbidden: Authenticated but not allowed / business rule prevents action
- 404 Not Found
- 405 Method Not Allowed
- 409 Conflict: State conflict (e.g., resource already exists, special business rule)
- 410 Gone: Resource no longer available
- 412 Precondition Failed: ETag precondition failed
- 415 Unsupported Media Type
- 422 Unprocessable Entity: Validation errors (field-level)
- 428 Precondition Required: Additional step is required before proceeding (e.g., EULA)
- 429 Too Many Requests

Server errors:

- 5xx for server-side failures; include `code` and correlation details if possible.

Note on HTTP method checks (CodeIgniter 4.6.3):

- `$this->request->getMethod()` returns the HTTP method in uppercase (e.g., `POST`).
- Compare against uppercase tokens: `GET`, `POST`, `PUT`, `PATCH`, `DELETE`.
- Example: `if ($this->request->getMethod() !== 'POST') { /* 405 */ }`

## 3. Error Object Schema

When returning non-2xx, include `errors` to help clients act on issues:

```jsonc
{
  "success": false,
  "code": "validation.failed",
  "message": "One or more fields are invalid.",
  "errors": [
    { "code": "validation.required", "message": "PIN is required", "field": "pin" },
    { "code": "validation.digits", "message": "PIN must be numeric", "field": "pin" }
  ],
  "meta": { "request_id": "..." }
}
```

## 4. Pagination, Sorting, Filtering, Fields

- Query parameters:
    - `page` (default 1), `per_page` (default 50; max 1000 unless otherwise noted)
    - `sort`: comma-separated fields, prefix with `-` for desc, e.g. `sort=created_at,-name`
    - `q` or resource-specific filter params (e.g., `status=active`)
    - `fields`: comma-separated projection, e.g., `fields=id,name`
- Response should include `meta.pagination` and, optionally, `links` with `self`, `next`, `prev`.

## 5. Caching with ETag

- For list/detail GET endpoints, include an `ETag` header and `meta.etag` when practical.
- If the request includes `If-None-Match` with the same ETag, respond with `304 Not Modified` and no body.
- See `TankApiController@index` and `@show` for an example implementation.


### **6. Authentication and CSRF (Revised for Stateless API)**

The OilCop G2 API is **strictly stateless** and does not use server-side sessions for authentication. All endpoints under `/api/v2` **MUST** be authenticated using a bearer token provided in the `Authorization` header.

-   **Authentication:** `Authorization: Bearer <your-api-token>`
-   **CSRF Protection:** **CSRF protection is disabled for all API routes.** Stateless, token-based authentication is inherently immune to CSRF attacks, making CSRF tokens unnecessary.
-   **Token Management:** Clients are responsible for obtaining, securely storing, and refreshing tokens as needed. See the specific authentication endpoints for details.

> **Legacy Note:** During the transition period, some non-API web forms may still use sessions and CSRF. This does not apply to the `/api/v2/*` routes, which follow the stateless pattern.

### **6.1. Token-Based Authentication Flow**

To consume this API from your Vue.js app, you will need to follow this standard authentication flow:

1.  **Login:** The client `POST`s user credentials (e.g., `pin`) to `/api/v2/auth/login`.
2.  **Receive Token:** The API responds with a `201 Created` status and a JSON payload containing an access token.
    ```json
    {
      "success": true,
      "code": "auth.logged_in",
      "message": "Login successful",
      "data": {
        "user": { "id": 123, "name": "Jane Doe", "role_id": 2 },
        "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJ...",
        "token_type": "Bearer",
        "expires_in": 3600
      }
    }
    ```
3.  **Store Token:** The client (your Vue app) must securely store this token (e.g., in memory, or in an `HttpOnly` cookie if served from the same domain, but **not** in `localStorage` for maximum security).
4.  **API Requests:** The client includes this token in the `Authorization` header of all subsequent requests to protected endpoints.
    ```http
    GET /api/v2/tanks HTTP/1.1
    Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJ...
    Accept: application/json
    ```
5.  **Token Expiry:** The client must handle `401 Unauthorized` responses by attempting to refresh the token (if a refresh mechanism is implemented) or by redirecting the user to the login page.

## 7. Idempotency

- For POST endpoints that could be retried (e.g., payment, commands), support an `Idempotency-Key` header to safely
  retry the same request.

## 8. Versioning

- Prefix version in the path: `/api/v2/...`.
- Breaking changes require a new version (e.g., `/api/v2`).

## 9. Login Controller Migration Guide

Legacy endpoint: `POST /admin/login` expects form field `pass1` and returns plain text tokens which the frontend
interprets.

Observed legacy tokens (not exhaustive):

- Success/role routing: `"1"`, `"2"`, `"3"`, `"4"`, `"installer"`, `"admn"`, `"mngr"`, `"tech"`
- Validation: `"n"` (invalid PIN format)
- Auth failures: `"no_user"`, `"Login Failed"`
- Business rules: `"invalid_shift"`, `"blocked"`, `"expired"`, `"monitor_enabled"`, `"Not Agree"`
- Other: `"bad_method"`

Recommended migration options:

- Option A (preferred): Introduce a new endpoint `POST /api/v2/auth/login` that follows this spec and keep`/admin/login`
  unchanged for existing UIs.
- Option B: Content negotiation on `/admin/login`:
    - If `Accept: application/json` respond with the standardized JSON and appropriate HTTP status.
    - Otherwise, keep returning the legacy text token for backward compatibility.

### New standardized endpoint shape

Request (either JSON or form-encoded):

```http
POST /api/v2/auth/login
Content-Type: application/json

{ "pin": "1234" }
```

Success response:

```json
{
  "success": true,
  "code": "auth.logged_in",
  "message": "Login successful",
  "data": {
    "role_id": 2,
    "redirect": "/admin/manager_dashboard",
    "agreement_required": false
  },
  "meta": {
    "timestamp": "2025-08-20T16:02:00Z",
    "version": "v1"
  }
}
```

Agreement required (legacy: `Not Agree`):

```http
HTTP/1.1 428 Precondition Required
```

```json
{
  "success": false,
  "code": "auth.agreement_required",
  "message": "User must accept the agreement before proceeding.",
  "errors": [],
  "data": {
    "agreement_required": true,
    "redirect": "/admin/agreement"
  }
}
```

Invalid PIN format (legacy: `n`):

```http
HTTP/1.1 400 Bad Request
```

```json
{
  "success": false,
  "code": "auth.invalid_pin",
  "message": "PIN must be 4–10 digits.",
  "errors": [
    {
      "code": "validation.digits",
      "field": "pin"
    }
  ]
}
```

Bad credentials / user not found (legacy: `no_user` or `Login Failed`):

```http
HTTP/1.1 401 Unauthorized
```

```json
{
  "success": false,
  "code": "auth.failed",
  "message": "Invalid PIN or user not found."
}
```

Blocked user (legacy: `blocked`):

```http
HTTP/1.1 403 Forbidden
```

```json
{
  "success": false,
  "code": "auth.blocked",
  "message": "User is blocked."
}
```

Installer PIN expired (legacy: `expired`):

```http
HTTP/1.1 403 Forbidden
```

```json
{
  "success": false,
  "code": "auth.installer_pin_expired",
  "message": "Installer PIN has expired."
}
```

Invalid shift (legacy: `invalid_shift`):

```http
HTTP/1.1 403 Forbidden
```

```json
{
  "success": false,
  "code": "auth.shift_invalid",
  "message": "User is outside allowed shift window."
}
```

Tank monitor enabled (legacy: `monitor_enabled`):

```http
HTTP/1.1 409 Conflict
```

```json
{
  "success": false,
  "code": "auth.monitor_enabled",
  "message": "Tank monitor mode is enabled and prevents login."
}
```

Wrong method (legacy: `bad_method`):

```http
HTTP/1.1 405 Method Not Allowed
```

```json
{
  "success": false,
  "code": "common.method_not_allowed",
  "message": "Use POST for this endpoint."
}
```

### Redirect logic reference

For convenience, include a recommended `redirect` value in `data` upon success:

- role_id 1 or 4 (admin/installer admin): `/admin/admin_dashboard`
- role_id 2 (manager): `/admin/manager_dashboard`
- role_id 3 (tech): `/admin/tech_dashboard`
- installer shortcut: `/admin/installer_dashboard`

Clients may still choose their own routing logic; the redirect is advisory.

## 10. Tank endpoints example (existing)

`GET /api/v2/tanks` (implemented in TankApiController)

- Responds with:

```json
{
  "data": [
    {
      "tank_id": 1
    },
    {
      "tank_id": 2
    }
  ],
  "meta": {
    "count": 2,
    "etag": "\"abc123\""
  }
}
```

- Supports `ETag` and `If-None-Match`.

To fully align with this standard, controllers can add `success: true`, a `code` like `tanks.list_ok`, and `message`
fields without breaking existing clients.

---

Adopting this guide will let us gradually convert legacy controllers to proper API controllers with consistent,
debuggable, and self-descriptive responses, while keeping the current UI functional during the transition.
