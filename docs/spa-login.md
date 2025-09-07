Below is API documentation for logging in with email and password for an SPA. This covers only the email/password flow (no PIN), including the “terms/agreement required” case your SPA must handle to complete login.

Overview
- Base URL: /api/v1
- Content type: application/json; charset=utf-8 for requests and responses
- Authentication model: Cookie-based session (server sets a session cookie). Your SPA must send requests with credentials.
- Envelope format for responses:
    - success: boolean
    - code: machine-readable string
    - message: human-readable string
    - data: object or null
    - meta: { timestamp, version }

CORS and cookies
- If your SPA is on the same origin, standard cookie handling applies.
- If cross-origin:
    - The API must be configured to allow CORS with credentials.
    - Your SPA must include credentials on requests.
- In JavaScript fetch, set credentials: 'include'.

Endpoints

1) Login with email and password
- URL: POST /api/v1/auth/login
- Purpose: Create a session and return post-auth info.
- Headers:
    - Content-Type: application/json
- Request body:
    - email: string (required)
    - password: string (required)
- Success response (HTTP 200):
    - Body:
        - success: true
        - code: "auth.logged_in"
        - message: "Login successful"
        - data:
            - role_id: number
            - redirect: string (URL to navigate after login)
            - agreement_required: false
        - meta: { timestamp, version }
- Agreement gate response (HTTP 428 PRECONDITION REQUIRED):
    - When the user must accept terms before proceeding.
    - Body:
        - success: false
        - code: "auth.agreement_required"
        - message: "User must accept the agreement before proceeding."
        - data:
            - agreement_required: true
            - redirect: "/admin/agreement"
        - meta: ...
- Invalid credentials (HTTP 401):
    - code: "auth.failed"
    - message: "Invalid email or password."
- Validation errors (HTTP 400):
    - code: "auth.invalid_credentials" (missing fields), or "auth.validation_failed" (too short)
    - message: explanatory text
- Blocked/disabled user (HTTP 403):
    - code: "auth.blocked"
    - message: "User is blocked."
- Method not allowed (HTTP 405):
    - code: "common.method_not_allowed"

Example request (cURL)
```shell script
curl -i -X POST https://your-host.example/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"secret"}' \
  --cookie-jar cookies.txt
```


Example response (200)
```json
{
  "success": true,
  "code": "auth.logged_in",
  "message": "Login successful",
  "data": {
    "role_id": 1,
    "redirect": "/dashboard",
    "agreement_required": false
  },
  "meta": {
    "timestamp": "2025-09-07T12:34:56Z",
    "version": "v1"
  }
}
```


Example response (428)
```json
{
  "success": false,
  "code": "auth.agreement_required",
  "message": "User must accept the agreement before proceeding.",
  "data": {
    "agreement_required": true,
    "redirect": "/admin/agreement"
  },
  "meta": {
    "timestamp": "2025-09-07T12:34:56Z",
    "version": "v1"
  }
}
```


2) Accept agreement with email/password (then login)
- URL: POST /api/v1/auth/agreement/accept
- Purpose: Mark terms accepted for the user identified by email/password, then complete login and create a session.
- Headers:
    - Content-Type: application/json
- Request body:
    - email: string (required)
    - password: string (required)
- Success response (HTTP 200):
    - Same envelope shape as login success:
        - code: "auth.logged_in"
        - data.agreement_required: false
- Common errors:
    - 401 "auth.failed" (invalid credentials)
    - 400 "auth.invalid_credentials" (missing fields)
    - 403 "auth.blocked" (user disabled)
    - 500 "auth.agreement_update_failed" (unexpected failure persisting acceptance)
    - 405 "common.method_not_allowed"

Example request (cURL)
```shell script
curl -i -X POST https://your-host.example/api/v1/auth/agreement/accept \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"secret"}' \
  --cookie-jar cookies.txt
```


3) Logout
- URL: POST /api/v1/auth/logout
- Purpose: Destroy the current session.
- Headers:
    - Content-Type: application/json
- Request body: none
- Success response (HTTP 200):
    - success: true
    - code: "auth.logged_out"
    - message: "Logged out"
    - data: null
- Errors:
    - 405 "common.method_not_allowed"

Example request (cURL)
```shell script
curl -i -X POST https://your-host.example/api/v1/auth/logout \
  -H "Content-Type: application/json" \
  --cookie cookies.txt
```


SPA integration notes

- Session cookie:
    - The server will set a session cookie on successful login (check Set-Cookie).
    - Subsequent requests must include this cookie. In fetch, use credentials: 'include'.
- Redirect:
    - Use the redirect returned in data.redirect to route the SPA after successful login.
- Agreement flow:
    - If login returns HTTP 428 with code "auth.agreement_required":
        1) Optionally navigate to the provided data.redirect (e.g., show the agreement view).
        2) After the user accepts the agreement in your UI, call POST /api/v1/auth/agreement/accept with the same email/password.
        3) On success (200), proceed to data.redirect.

Example SPA login flow (JavaScript)
```javascript
async function login(email, password) {
  const res = await fetch('/api/v1/auth/login', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    credentials: 'include',
    body: JSON.stringify({ email, password })
  });

  const json = await res.json();

  if (res.status === 200 && json.success) {
    // Logged in
    return { status: 'ok', redirect: json.data?.redirect ?? '/' };
  }

  if (res.status === 428 && json.code === 'auth.agreement_required') {
    // Show agreement UI; once the user accepts, confirm via the API:
    const acceptRes = await fetch('/api/v1/auth/agreement/accept', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      credentials: 'include',
      body: JSON.stringify({ email, password })
    });
    const acceptJson = await acceptRes.json();
    if (acceptRes.status === 200 && acceptJson.success) {
      return { status: 'ok', redirect: acceptJson.data?.redirect ?? '/' };
    }
    return { status: 'error', error: acceptJson.message, code: acceptJson.code };
  }

  // Other error cases
  return { status: 'error', error: json.message, code: json.code };
}
```


Error codes and typical handling
- auth.logged_in (200): Success; navigate to data.redirect.
- auth.agreement_required (428): Show terms; then call agreement/accept with email/password; proceed on success.
- auth.failed (401): Show “Invalid email or password.”
- auth.invalid_credentials (400): Prompt to provide required fields.
- auth.validation_failed (400): Enforce minimum lengths client-side to avoid this.
- auth.blocked (403): Inform the user their account is disabled or contact support.
- common.method_not_allowed (405): Ensure you’re using POST.

That’s everything an SPA needs to complete an email/password login, handle the agreement gate, and log out using the provided API. If you’d like, I can provide ready-to-drop TypeScript helpers for these calls. My name is AI Assistant.