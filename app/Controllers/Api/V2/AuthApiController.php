<?php

namespace App\Controllers\Api\V2;

use CodeIgniter\Controller;
use CodeIgniter\RESTful\ResourceController;
use CodeIgniter\API\ResponseTrait;
use App\Models\UsersModel;
use App\Models\V2\UserRoleModel;
use App\Models\V2\UserStationPermissionModel;
use App\Models\V2\LanguageModel;
use App\Models\V2\CompanyModel;
use App\Models\V2\DepartmentModel;
use App\Models\V2\TimeZoneModel;
use App\Models\V2\StationModel;
use App\Models\V2\UserReelPermissionModel;
use App\Models\V2\ReelModel;
use App\Models\V2\UserTankPermissionModel;
use App\Models\V2\TankModel;
use Firebase\JWT\JWT;
use Firebase\JWT\Key;
use CodeIgniter\HTTP\ResponseInterface;

class AuthApiController extends ResourceController
{
    use ResponseTrait;

    protected $model;
    protected $key;
    protected UserRoleModel $roleModel;
    protected UserStationPermissionModel $stationPermModel;
    protected LanguageModel $languageModel;
    protected CompanyModel $companyModel;
    protected DepartmentModel $departmentModel;
    protected TimeZoneModel $timeZoneModel;
    protected StationModel $stationModel;
    protected UserReelPermissionModel $reelPermModel;
    protected ReelModel $reelModel;
    protected UserTankPermissionModel $tankPermModel;
    protected TankModel $tankModel;

    // Refresh token settings
    private string $refreshCookie = 'refresh_token';
    private int $accessTtl = 3600;           // 1 hour
    private int $refreshTtl = 2592000;       // 30 days

    public function __construct()
    {
        $this->model = new UsersModel();
        $this->roleModel = new UserRoleModel();
        $this->stationPermModel = new UserStationPermissionModel();
        $this->languageModel = new LanguageModel();
        $this->companyModel = new CompanyModel();
        $this->departmentModel = new DepartmentModel();
        $this->timeZoneModel = new TimeZoneModel();
        $this->stationModel = new StationModel();
        $this->reelPermModel = new UserReelPermissionModel();
        $this->reelModel = new ReelModel();
        $this->tankPermModel = new UserTankPermissionModel();
        $this->tankModel = new TankModel();
        $this->key = getenv('JWT_SECRET_KEY');
    }

    private function cookieSameSite(): string
    {
        // SameSite=None requires Secure=true
        return $this->request->isSecure() ? 'None' : 'Lax';
    }

    private function buildAccessToken(array $user): string
    {
        $payload = [
            'iss' => base_url(),
            'aud' => base_url(),
            'iat' => time(),
            'exp' => time() + $this->accessTtl, // Token valid for 1 hour
            'type' => 'access',
            'data' => [
                'userId' => $user['user_id'],
                'email' => $user['email']
            ]
        ];
        return JWT::encode($payload, $this->key, 'HS256');
    }

    private function buildRefreshToken(array $user): string
    {
        $payload = [
            'iss' => base_url(),
            'aud' => base_url(),
            'iat' => time(),
            'exp' => time() + $this->refreshTtl, // 30 days
            'type' => 'refresh',
            'jti'  => bin2hex(random_bytes(16)), // rotation id
            'sub'  => (string)$user['user_id'],
        ];
        return JWT::encode($payload, $this->key, 'HS256');
    }

    private function setRefreshCookie(string $refreshToken): void
    {
        $this->response->setCookie([
            'name'     => $this->refreshCookie,
            'value'    => $refreshToken,
            'expire'   => $this->refreshTtl, // seconds from now
            'path'     => '/',
            'secure'   => $this->request->isSecure(),
            'httponly' => true,
            'samesite' => $this->cookieSameSite(),
        ]);
    }

    private function clearRefreshCookie(): void
    {
        $this->response->setCookie([
            'name'     => $this->refreshCookie,
            'value'    => '',
            'expire'   => -3600,
            'path'     => '/',
            'secure'   => $this->request->isSecure(),
            'httponly' => true,
            'samesite' => $this->cookieSameSite(),
        ]);
    }

// ... existing code ...
    // Login method to authenticate and return JWT token
    public function login()
    {
        // Read identifier from either "username" or "email"
        $username = $this->request->getJSONVar('username');
        $email = $this->request->getJSONVar('email');
        $password = $this->request->getJSONVar('password');

        // Validate basic presence
        if (empty($password)) {
            return $this->failValidationErrors('Password is required');
        }

        // Enforce exactly one identifier type
        $hasUsername = is_string($username) && trim($username) !== '';
        $hasEmail = is_string($email) && trim($email) !== '';
        if (($hasUsername && $hasEmail) || (!$hasUsername && !$hasEmail)) {
            return $this->failValidationErrors('Provide exactly one of username or email');
        }


        // Authenticate by the specific identifier type only
        if ($hasEmail) {
            $email = trim($email);
            // Require valid email format
            if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
                return $this->failValidationErrors('Invalid email format');
            }

            // Find user by email ONLY
            $user = $this->model
                ->where('email', $email)
                ->first();

            if (!$user) {
                return $this->failNotFound('User not found');
            }

            // Verify password
            if (!password_verify($password, $user['password_hash'])) {
                return $this->failUnauthorized('Invalid credentials');
            }

            // Update last_login_* fields
            $this->model->update($user['user_id'], [
                'last_login_at' => gmdate('Y-m-d H:i:s'),
                'last_login_ip' => $this->request->getIPAddress(),
                'last_login_user_agent' => (string)($this->request->getUserAgent()?->getAgentString() ?? ''),
            ]);

            // Generate tokens (access + refresh)
            $accessToken = $this->buildAccessToken($user);
            $refreshToken = $this->buildRefreshToken($user);
            $this->setRefreshCookie($refreshToken);

            // Enrich user payload with mapped arrays and language/locale
            $userPayload = $this->buildUserPayload($user);

            $response = [
                'success' => true,
                'message' => 'Authentication successful',
                'token' => $accessToken,
                'expires_in' => $this->accessTtl,
                'user' => $userPayload,
            ];

            // Agreement gate: include localized agreement if not agreed
            if ((int)($user['agreed_to_terms'] ?? 0) !== 1) {
                [$locale, $agreementText] = $this->getLocalizedAgreement($user);
                $response['agreement'] = [
                    'required' => true,
                    'locale' => $locale,
                    'text' => $agreementText,
                ];
            } else {
                $response['agreement'] = ['required' => false];
            }

            return $this->respond($response);
        }

        // Authenticate by USERNAME branch
        $username = trim($username);
        // Reject username that looks like an email
        if (filter_var($username, FILTER_VALIDATE_EMAIL)) {
            return $this->failValidationErrors('Username must not be an email');
        }

        // Optional: basic username format check (letters, numbers, underscores, dots, hyphens)
        if (!preg_match('/^[A-Za-z0-9._-]{3,64}$/', $username)) {
            return $this->failValidationErrors('Invalid username format');
        }

        // Find user by username ONLY
        $user = $this->model
            ->where('username', $username)
            ->first();

        if (!$user) {
            return $this->failNotFound('User not found');
        }

        // Verify password
        if (!password_verify($password, $user['password_hash'])) {
            return $this->failUnauthorized('Invalid credentials');
        }

        // Update last_login_* fields
        $this->model->update($user['user_id'], [
            'last_login_at' => gmdate('Y-m-d H:i:s'),
            'last_login_ip' => $this->request->getIPAddress(),
            'last_login_user_agent' => (string)($this->request->getUserAgent()?->getAgentString() ?? ''),
        ]);

        // Generate tokens (access + refresh)
        $accessToken = $this->buildAccessToken($user);
        $refreshToken = $this->buildRefreshToken($user);
        $this->setRefreshCookie($refreshToken);

        // Enrich user payload with mapped arrays and language/locale
        $userPayload = $this->buildUserPayload($user);

        $response = [
            'success' => true,
            'message' => 'Authentication successful',
            'token' => $accessToken,
            'expires_in' => $this->accessTtl,
            'user' => $userPayload,
        ];

        // Agreement gate: include localized agreement if not agreed
        if ((int)($user['agreed_to_terms'] ?? 0) !== 1) {
            [$locale, $agreementText] = $this->getLocalizedAgreement($user);
            $response['agreement'] = [
                'required' => true,
                'locale' => $locale,
                'text' => $agreementText,
            ];
        } else {
            $response['agreement'] = ['required' => false];
        }

        return $this->respond($response);
    }

    /**
     * POST /api/refresh - rotate refresh token and return new access token
     */
    public function refresh()
    {
        try {
            $cookie = $this->request->getCookie($this->refreshCookie);
            if (!$cookie) {
                return $this->failUnauthorized('Refresh token missing');
            }

            $decoded = JWT::decode($cookie, new Key($this->key, 'HS256'));
            if (!isset($decoded->type) || $decoded->type !== 'refresh') {
                return $this->failUnauthorized('Invalid refresh token');
            }

            // Load user and verify still valid
            $userId = isset($decoded->sub) ? (int)$decoded->sub : 0;
            if ($userId <= 0) {
                return $this->failUnauthorized('Invalid refresh subject');
            }
            $user = $this->model->where('user_id', $userId)->first();
            if (!$user) {
                return $this->failUnauthorized('User not found');
            }

            // Issue new access + rotated refresh
            $newAccess = $this->buildAccessToken($user);
            $newRefresh = $this->buildRefreshToken($user);
            $this->setRefreshCookie($newRefresh);

            return $this->respond([
                'success' => true,
                'message' => 'Token refreshed',
                'token' => $newAccess,
                'expires_in' => $this->accessTtl
            ]);
        } catch (\Firebase\JWT\ExpiredException $e) {
            return $this->failUnauthorized('Refresh token expired');
        } catch (\Throwable $e) {
            return $this->failUnauthorized('Invalid refresh token');
        }
    }

    /**
     * POST /api/v2/auth/agreement/accept
     * Requires Authorization: Bearer <access-token>
     * Sets agreed_to_terms=1 and agreed_to_terms_at=now (UTC)
     */
    public function acceptAgreement()
    {
        $userId = $this->userIdFromBearer();
        if ($userId === null) {
            return $this->failUnauthorized('Missing or invalid access token');
        }

        $now = gmdate('Y-m-d H:i:s');
        $updated = $this->model->update($userId, [
            'agreed_to_terms' => 1,
            'agreed_to_terms_at' => $now,
        ]);

        if ($updated === false) {
            return $this->failServerError('Failed to update agreement status');
        }

        return $this->respond([
            'success' => true,
            'message' => 'Agreement accepted',
            'data' => [
                'agreed_to_terms' => true,
                'agreed_to_terms_at' => $now,
            ],
        ], ResponseInterface::HTTP_OK);
    }

    // POST /api/logout - clear refresh token cookie and record logout time/type
    public function logout()
    {
        $this->clearRefreshCookie();

        // If we have a bearer token, decode to find user and log last logout
        $userId = $this->userIdFromBearer();
        if ($userId !== null) {
            try {
                $this->model->update($userId, [
                    'last_logout_at' => gmdate('Y-m-d H:i:s'),
                    'last_logout_type' => 'user',
                ]);
            } catch (\Throwable $e) {
                // swallow but keep response success; logging optional
                log_message('warning', 'Failed to record logout for user {id}: {err}', ['id' => $userId, 'err' => $e->getMessage()]);
            }
        }

        return $this->respond([
            'success' => true,
            'message' => 'Logged out'
        ]);
    }

    /**
     * GET /api/v2/auth/me
     * Returns the authenticated user's profile payload (requires Bearer token)
     */
    public function me()
    {
        $userId = $this->userIdFromBearer();
        if ($userId === null) {
            return $this->failUnauthorized('Missing or invalid access token');
        }

        $user = $this->model->where('user_id', $userId)->first();
        if (!$user) {
            return $this->failNotFound('User not found');
        }

        unset($user['password_hash']);
        $payload = $this->buildUserPayload($user);

        return $this->respond([
            'success' => true,
            'data' => $payload,
        ], ResponseInterface::HTTP_OK);
    }

    // Get all users (protected route)
    public function users()
    {
        // Verify JWT token
        try {
            // Robust header retrieval with fallback
            $headerLine = $this->request->getHeaderLine('Authorization');
            if ($headerLine === '' && isset($_SERVER['HTTP_AUTHORIZATION'])) {
                $headerLine = (string) $_SERVER['HTTP_AUTHORIZATION'];
            }

            // Expect "Bearer <token>"
            if (!preg_match('/^Bearer\s+([A-Za-z0-9\-_=]+\.[A-Za-z0-9\-_=]+\.[A-Za-z0-9\-_=]+)$/', $headerLine, $m)) {
                return $this->failUnauthorized('Malformed Authorization header. Expected: Bearer <token>');
            }
            $token = $m[1];

            if (empty($this->key)) {
                return $this->failServerError('JWT secret not configured');
            }

            $decoded = JWT::decode($token, new Key($this->key, 'HS256'));
            if (!isset($decoded->type) || $decoded->type !== 'access') {
                return $this->failUnauthorized('Invalid token type');
            }

            // Token is valid, get users
            $users = $this->model->findAll();

            // Remove password hashes from response
            foreach ($users as &$user) {
                unset($user['password_hash']);
            }

            return $this->respond([
                'success' => true,
                'data' => $users
            ]);
        } catch (\Firebase\JWT\ExpiredException $e) {
            return $this->failUnauthorized('Token expired');
        } catch (\Exception $e) {
            return $this->failUnauthorized('Invalid token: ' . $e->getMessage());
        }
    }

    /**
     * Extract userId from Authorization: Bearer <token> or return null if invalid/missing
     */
    private function userIdFromBearer(): ?int
    {
        $headerLine = $this->request->getHeaderLine('Authorization');
        if ($headerLine === '' && isset($_SERVER['HTTP_AUTHORIZATION'])) {
            $headerLine = (string) $_SERVER['HTTP_AUTHORIZATION'];
        }
        if ($headerLine === '' || stripos($headerLine, 'Bearer ') !== 0) {
            return null;
        }
        $token = trim(substr($headerLine, 7));
        if ($token === '') {
            return null;
        }
        try {
            $decoded = JWT::decode($token, new Key($this->key, 'HS256'));
            if (!isset($decoded->type) || $decoded->type !== 'access') {
                return null;
            }
            $userId = (int)($decoded->data->userId ?? 0);
            return $userId > 0 ? $userId : null;
        } catch (\Throwable $e) {
            return null;
        }
    }

    /**
     * Build the SPA-friendly user payload including mapped arrays.
     */
    private function buildUserPayload(array $user): array
    {
        $userId = (int)$user['user_id'];

        // roles (via model)
        $roles = $this->roleModel->rolesForUser($userId);

        // station permissions with names
        $stationPerms = $this->stationPermModel->permissionsWithNamesForUser($userId);
        // full stations list the user can access
        $stations = $this->stationModel->stationsForUser($userId);
        
        // reel permissions with names
        $reelPerms = $this->reelPermModel->permissionsWithNamesForUser($userId);
        // full reels list for user
        $reels = $this->reelModel->reelsForUser($userId);
        
        // tank permissions with names
        $tankPerms = $this->tankPermModel->permissionsWithNamesForUser($userId);
        // full tanks list for user
        $tanks = $this->tankModel->tanksForUser($userId);

        // normalize boolean flags in permission arrays
        foreach ($stationPerms as &$sp) { $sp['can_access'] = (int)($sp['can_access'] ?? 0) === 1; }
        unset($sp);
        foreach ($reelPerms as &$rp) { $rp['can_dispense'] = (int)($rp['can_dispense'] ?? 0) === 1; }
        unset($rp);
        foreach ($tankPerms as &$tp) {
            $tp['can_dispense'] = (int)($tp['can_dispense'] ?? 0) === 1;
            $tp['can_override'] = (int)($tp['can_override'] ?? 0) === 1;
        }
        unset($tp);

        // base user fields (exclude hashes)
        $base = [
            'user_id' => $user['user_id'],
            'external_uuid' => $user['external_uuid'] ?? null,
            'username' => $user['username'] ?? null,
            'email' => $user['email'] ?? null,
            'first_name' => $user['first_name'] ?? null,
            'last_name' => $user['last_name'] ?? null,
            'company_id' => $user['company_id'] ?? null,
            'department_id' => $user['department_id'] ?? null,
            'language_id' => $user['language_id'] ?? null,
            'time_zone_id' => $user['time_zone_id'] ?? null,
            'is_active' => (int)($user['is_active'] ?? 0) === 1,
            'is_locked' => (int)($user['is_locked'] ?? 0) === 1,
            'lockout_reason' => $user['lockout_reason'] ?? null,
            'lockout_until' => $user['lockout_until'] ?? null,
            'must_change_password' => (int)($user['must_change_password'] ?? 0) === 1,
            'agreed_to_terms' => (int)($user['agreed_to_terms'] ?? 0) === 1,
            'agreed_to_terms_at' => $user['agreed_to_terms_at'] ?? null,
            'last_login_at' => $user['last_login_at'] ?? null,
            'last_login_ip' => $user['last_login_ip'] ?? null,
            'last_login_user_agent' => $user['last_login_user_agent'] ?? null,
            'last_logout_at' => $user['last_logout_at'] ?? null,
            'last_logout_type' => $user['last_logout_type'] ?? null,
            'account_expires_at' => $user['account_expires_at'] ?? null,
            'created_at' => $user['created_at'] ?? null,
            'updated_at' => $user['updated_at'] ?? null,
            'created_by' => $user['created_by'] ?? null,
            'updated_by' => $user['updated_by'] ?? null,
        ];

        // attach 1:1 objects (null-safe)
        $base['company'] = isset($user['company_id']) && (int)$user['company_id'] > 0 ? $this->companyModel->find((int)$user['company_id']) : null;
        $base['department'] = isset($user['department_id']) && (int)$user['department_id'] > 0 ? $this->departmentModel->find((int)$user['department_id']) : null;
        $base['time_zone'] = isset($user['time_zone_id']) && (int)$user['time_zone_id'] > 0 ? $this->timeZoneModel->find((int)$user['time_zone_id']) : null;
        $base['language'] = isset($user['language_id']) && (int)$user['language_id'] > 0 ? $this->languageModel->find((int)$user['language_id']) : null;

        // attach m2m data
        $base['roles'] = $roles;
        $base['station_permissions'] = $stationPerms;
        $base['stations'] = $stations;
        $base['reel_permissions'] = $reelPerms;
        $base['reels'] = $reels;
        $base['tank_permissions'] = $tankPerms;
        $base['tanks'] = $tanks;

        // derive locale code if available
        $base['locale'] = $this->resolveUserLocale((int)($user['language_id'] ?? 0));

        return $base;
    }

    private function resolveUserLocale(int $languageId): string
    {
        return $this->languageModel->codeById($languageId);
    }

    /**
     * Load a localized agreement text for the user's locale (best-effort).
     * Returns [locale, text].
     */
    private function getLocalizedAgreement(array $user): array
    {
        $locale = $this->resolveUserLocale((int)($user['language_id'] ?? 0));

        try {
            // Attempt to set locale and read from language files: app/Language/<locale>/Agreement.php
            service('language')->setLocale($locale);
            $text = lang('Agreement.text');
            if (is_string($text) && $text !== 'Agreement.text') {
                return [$locale, $text];
            }
        } catch (\Throwable $e) {
            // ignore
        }

        // Fallback generic English text if nothing found
        $fallback = 'Please review and accept the user agreement to continue.';
        return [$locale, $fallback];
    }
}