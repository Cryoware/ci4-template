<?php

namespace App\Controllers\Api\V2;

use CodeIgniter\Controller;
use CodeIgniter\RESTful\ResourceController;
use CodeIgniter\API\ResponseTrait;
use App\Models\UsersModel;
use Firebase\JWT\JWT;
use Firebase\JWT\Key;


class AuthApiController extends ResourceController
{
    use ResponseTrait;

    protected $model;
    protected $key;

    // Refresh token settings
    private string $refreshCookie = 'refresh_token';
    private int $accessTtl = 3600;           // 1 hour
    private int $refreshTtl = 2592000;       // 30 days

    public function __construct()
    {
        $this->model = new UsersModel();
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

            // Generate tokens (access + refresh)
            $accessToken = $this->buildAccessToken($user);
            $refreshToken = $this->buildRefreshToken($user);
            $this->setRefreshCookie($refreshToken);

            return $this->respond([
                'success' => true,
                'message' => 'Authentication successful',
                'token' => $accessToken,
                'expires_in' => $this->accessTtl
            ]);
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

        // Generate tokens (access + refresh)
        $accessToken = $this->buildAccessToken($user);
        $refreshToken = $this->buildRefreshToken($user);
        $this->setRefreshCookie($refreshToken);

        return $this->respond([
            'success' => true,
            'message' => 'Authentication successful',
            'token' => $accessToken,
            'expires_in' => $this->accessTtl
        ]);
    }

    // POST /api/refresh - rotate refresh token and return new access token
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

    // POST /api/logout - clear refresh token cookie
    public function logout()
    {
        $this->clearRefreshCookie();
        return $this->respond([
            'success' => true,
            'message' => 'Logged out'
        ]);
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

            if ($headerLine === '') {
                return $this->failUnauthorized('Authorization header required');
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
}