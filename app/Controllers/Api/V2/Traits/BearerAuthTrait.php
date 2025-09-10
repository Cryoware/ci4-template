<?php

namespace App\Controllers\Api\V2\Traits;

use Firebase\JWT\JWT;
use Firebase\JWT\Key;
use CodeIgniter\HTTP\ResponseInterface;

trait BearerAuthTrait
{
    protected string $jwtKey;

    protected function initJwtKey(): void
    {
        if (!isset($this->jwtKey) || $this->jwtKey === '') {
            $this->jwtKey = (string) (getenv('JWT_SECRET_KEY') ?: '');
        }
    }

    /**
     * Returns authenticated userId from Authorization: Bearer <token> or null if invalid/missing.
     */
    protected function userIdFromBearer(): ?int
    {
        $this->initJwtKey();
        $request = service('request');
        $headerLine = $request->getHeaderLine('Authorization');
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
            $decoded = JWT::decode($token, new Key($this->jwtKey, 'HS256'));
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
     * Ensures bearer token is valid; returns userId or sends 401 JSON and exits by throwing.
     */
    protected function requireBearerOrFail(): int
    {
        $userId = $this->userIdFromBearer();
        if ($userId === null) {
            // Controllers using this trait should also use ResponseTrait
            $response = service('response');
            $response->setStatusCode(ResponseInterface::HTTP_UNAUTHORIZED)
                ->setJSON([
                    'success' => false,
                    'code' => 'UNAUTHORIZED',
                    'message' => 'Missing or invalid access token',
                ])
                ->send();
            // Stop further execution
            exit;
        }
        return $userId;
    }
}
