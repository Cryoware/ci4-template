<?php

namespace App\Controllers\Api\V1;

use CodeIgniter\API\ResponseTrait;
use CodeIgniter\HTTP\ResponseInterface;
use App\Controllers\BaseController;
use App\Models\AuthModel;
use Config\AuthConfig as AuthConfig;
use Config\AuthUI;
use App\Enums\RoleId;

class AuthApiController extends BaseController
{
    use ResponseTrait;

    private function envelope(array $payload, int $status = 200): ResponseInterface
    {
        // Add basic meta
        $payload['meta'] = $payload['meta'] ?? [];
        $payload['meta']['timestamp'] = gmdate('c'); 
        $payload['meta']['version'] = 'v1';

        // Content type JSON UTF-8
        return $this->respond($payload, $status, '', 'application/json; charset=utf-8');
    }

    /**
     * Centralized role-based redirect
     */
    private function resolveRedirectByRole(int $roleId): string
    {
        $ui = config(AuthUI::class);
        return $ui->redirectByRole[$roleId] ?? $ui->defaultRedirect;
    }

    /**
     * Compute timezone info for the current user/context
     */
    private function computeTimezone(AuthModel $model, AuthConfig $config): array
    {
        $secondsPerHour = $config->secondsPerHour ?? 3600;
        $timezoneValSeconds = 0;
        $daylightSave = false;
        $tzRes = $model->get_user_timezone();
        if ($tzRes) {
            $daylightSave = (date('I') === '1');
            $baseSeconds = (int)($tzRes->t_timezone_val ?? 0) * $secondsPerHour;
            $timezoneValSeconds = $baseSeconds + ($daylightSave ? $secondsPerHour : 0);
        }
        return [$tzRes, $timezoneValSeconds, $daylightSave];
    }

    /**
     * Apply post-auth checks, build session, and return appropriate response.
     */
    private function handlePostAuthentication(AuthModel $model, object $user, AuthConfig $config, bool $skipAgreementGate = false): ResponseInterface
    {
        // Enabled check
        if ((int)$user->f_user_enabled !== 1) {
            return $this->envelope([
                'success' => false,
                'code' => 'auth.blocked',
                'message' => 'User is blocked.'
            ], ResponseInterface::HTTP_FORBIDDEN);
        }

        // Timezone info
        [$tzRes, $timezoneValSeconds, $daylightSave] = $this->computeTimezone($model, $config);

        // Technician checks
        if ((int)$user->f_role_id === RoleId::TECH->value) {
            $shiftOk = $model->check_shift((int)$user->f_user_id, $timezoneValSeconds);
            if (!$shiftOk) {
                return $this->envelope([
                    'success' => false,
                    'code' => 'auth.shift_invalid',
                    'message' => 'User is outside allowed shift window.'
                ], ResponseInterface::HTTP_FORBIDDEN);
            }
            $tankMonitor = $model->tank_monitor_sol();
            if ($tankMonitor) {
                return $this->envelope([
                    'success' => false,
                    'code' => 'auth.monitor_enabled',
                    'message' => 'Tank monitor mode is enabled and prevents login.'
                ], ResponseInterface::HTTP_CONFLICT);
            }
        }

        // Agreement gate (unless explicitly skipped, e.g., after accepting)
        if (!$skipAgreementGate && (int)$user->f_agrmt_accept === 0) {
            return $this->envelope([
                'success' => false,
                'code' => 'auth.agreement_required',
                'message' => 'User must accept the agreement before proceeding.',
                'errors' => [],
                'data' => ['agreement_required' => true, 'redirect' => '/admin/agreement'],
            ], ResponseInterface::HTTP_PRECONDITION_REQUIRED);
        }

        // Language and session build
        $language = $model->get_language();
        $timeZoneMeta = [
            'time_zone' => $tzRes->f_time_zone ?? '',
            'time_zone_value' => $tzRes->f_time ?? '',
            'date_format' => $tzRes->f_date_format ?? '',
            'time_hours' => $tzRes->f_user_time_hours ?? 24,
            'utc_zone' => $tzRes->f_utc_zone ?? '',
        ];

        session()->set([
            'userid' => $user->f_user_id,
            'email' => $user->f_user_email,
            'role_id' => $user->f_role_id,
            'tzone' => $timezoneValSeconds,
            'time_zone' => $timeZoneMeta['time_zone'],
            'time_zone_value' => $timeZoneMeta['time_zone_value'],
            'date_format' => $timeZoneMeta['date_format'],
            'time_hours' => $timeZoneMeta['time_hours'],
            'utc_zone' => $timeZoneMeta['utc_zone'],
            'session_start' => time(),
            'user_language' => $language,
            'daylight_save' => $daylightSave,
        ]);

        $redirect = $this->resolveRedirectByRole((int)$user->f_role_id);

        return $this->envelope([
            'success' => true,
            'code' => 'auth.logged_in',
            'message' => 'Login successful',
            'data' => [
                'role_id' => (int)$user->f_role_id,
                'redirect' => $redirect,
                'agreement_required' => false,
            ],
        ], ResponseInterface::HTTP_OK);
    }

    /**
     * POST /api/v1/auth/login
     * Accepts JSON { pin } or form-encoded pin/pass1
     * Also accepts { email, password } for email/password login.
     */
    public function login()
    {
        // Method check
        if ($this->request->getMethod() !== 'POST') {
            return $this->envelope([
                'success' => false,
                'code' => 'common.method_not_allowed',
                'message' => 'Use POST for this endpoint.',
            ], ResponseInterface::HTTP_METHOD_NOT_ALLOWED);
        }

        // Parse input (JSON or form)
        $ct = (string)$this->request->getHeaderLine('Content-Type');
        $body = [];
        if (stripos($ct, 'application/json') !== false) {
            $body = $this->request->getJSON(true) ?: [];
        }

        $pin = $body['pin'] ?? $body['pass1'] ?? $this->request->getPost('pin') ?? $this->request->getPost('pass1');
        $email = $body['email'] ?? $this->request->getPost('email');
        $password = $body['password'] ?? $this->request->getPost('password');

        $config = config(AuthConfig::class);

        // Branch: PIN login
        if ($pin !== null && $pin !== '') {
            $pin = is_string($pin) ? trim($pin) : '';
            if (
                $pin === '' || !ctype_digit($pin) ||
                strlen($pin) < $config->pinMinLength ||
                strlen($pin) > $config->pinMaxLength
            ) {
                return $this->envelope([
                    'success' => false,
                    'code' => 'auth.invalid_pin',
                    'message' => "PIN must be {$config->pinMinLength}–{$config->pinMaxLength} digits.",
                    'errors' => [['code' => 'validation.digits', 'field' => 'pin']],
                ], ResponseInterface::HTTP_BAD_REQUEST);
            }

            $model = new AuthModel();

            $user = $model->loginByPin($pin);
            if (!$user) {
                return $this->envelope([
                    'success' => false,
                    'code' => 'auth.failed',
                    'message' => 'Invalid PIN or user not found.'
                ], ResponseInterface::HTTP_UNAUTHORIZED);
            }

            // Common post-auth flow (checks, session, redirect)
            return $this->handlePostAuthentication($model, $user, $config);
        }

        // Branch: Email/Password login (unified to match PIN path)
        $email = is_string($email) ? trim($email) : '';
        $password = is_string($password) ? trim($password) : '';
        if ($email === '' || $password === '') {
            return $this->envelope([
                'success' => false,
                'code' => 'auth.invalid_credentials',
                'message' => 'Email and password are required.',
            ], ResponseInterface::HTTP_BAD_REQUEST);
        }
        if (strlen($email) < $config->minCredentialLength || strlen($password) < $config->minCredentialLength) {
            return $this->envelope([
                'success' => false,
                'code' => 'auth.validation_failed',
                'message' => "Email and password must be at least {$config->minCredentialLength} characters.",
            ], ResponseInterface::HTTP_BAD_REQUEST);
        }

        $model = new AuthModel();

        $user = $model->verifyPassword($email, $password);
        if (!$user) {
            return $this->envelope([
                'success' => false,
                'code' => 'auth.failed',
                'message' => 'Invalid email or password.'
            ], ResponseInterface::HTTP_UNAUTHORIZED);
        }

        // Common post-auth flow (checks, session, redirect)
        return $this->handlePostAuthentication($model, $user, $config);
    }

    /**
     * POST /api/v1/auth/agreement/accept
     * Accepts JSON { pin } or { email, password } and marks agreement accepted, then logs in.
     */
    public function agreementAccept()
    {
        if ($this->request->getMethod() !== 'POST') {
            return $this->envelope([
                'success' => false,
                'code' => 'common.method_not_allowed',
                'message' => 'Use POST for this endpoint.',
            ], ResponseInterface::HTTP_METHOD_NOT_ALLOWED);
        }

        // Parse input (JSON or form)
        $ct = (string)$this->request->getHeaderLine('Content-Type');
        $body = [];
        if (stripos($ct, 'application/json') !== false) {
            $body = $this->request->getJSON(true) ?: [];
        }
        $pin = $body['pin'] ?? $body['pass1'] ?? $this->request->getPost('pin') ?? $this->request->getPost('pass1');
        $email = $body['email'] ?? $this->request->getPost('email');
        $password = $body['password'] ?? $this->request->getPost('password');

        $config = config(AuthConfig::class);

        if ($pin !== null && $pin !== '') {
            $pin = is_string($pin) ? trim($pin) : '';
            // Validate using config bounds
            if ($pin === '' || !ctype_digit($pin) || strlen($pin) < $config->pinMinLength || strlen($pin) > $config->pinMaxLength) {
                return $this->envelope([
                    'success' => false,
                    'code' => 'auth.invalid_pin',
                    'message' => "PIN must be {$config->pinMinLength}–{$config->pinMaxLength} digits.",
                    'errors' => [['code' => 'validation.digits', 'field' => 'pin']],
                ], ResponseInterface::HTTP_BAD_REQUEST);
            }

            $model = new AuthModel();

            $user = $model->loginByPin($pin);
            if (!$user) {
                return $this->envelope([
                    'success' => false,
                    'code' => 'auth.failed',
                    'message' => 'Invalid PIN or user not found.'
                ], ResponseInterface::HTTP_UNAUTHORIZED);
            }

            // Respect enabled check before updating agreement
            if ((int)$user->f_user_enabled !== 1) {
                return $this->envelope([
                    'success' => false,
                    'code' => 'auth.blocked',
                    'message' => 'User is blocked.'
                ], ResponseInterface::HTTP_FORBIDDEN);
            }

            // Mark agreement accepted
            try {
                $db = db_connect();
                $db->table('t_users_details')
                    ->where('f_user_id', $user->f_user_id)
                    ->update(['f_agrmt_accept' => 1]);
                // reflect the in-memory object so post handler won’t gate
                $user->f_agrmt_accept = 1;
            } catch (\Throwable $e) {
                return $this->envelope([
                    'success' => false,
                    'code' => 'auth.agreement_update_failed',
                    'message' => 'Failed to update agreement status.'
                ], ResponseInterface::HTTP_INTERNAL_SERVER_ERROR);
            }

            // Common post-auth, skip agreement gate (it’s been accepted now)
            return $this->handlePostAuthentication($model, $user, $config, true);
        }

        // Email/password agreement accept branch
        $email = is_string($email) ? trim($email) : '';
        $password = is_string($password) ? trim($password) : '';
        if ($email === '' || $password === '') {
            return $this->envelope([
                'success' => false,
                'code' => 'auth.invalid_credentials',
                'message' => 'Email and password are required.',
            ], ResponseInterface::HTTP_BAD_REQUEST);
        }

        $model = new AuthModel();

        $user = $model->verifyPassword($email, $password);
        if (!$user) {
            return $this->envelope([
                'success' => false,
                'code' => 'auth.failed',
                'message' => 'Invalid email or password.'
            ], ResponseInterface::HTTP_UNAUTHORIZED);
        }

        // Respect enabled check before updating agreement
        if ((int)$user->f_user_enabled !== 1) {
            return $this->envelope([
                'success' => false,
                'code' => 'auth.blocked',
                'message' => 'User is blocked.'
            ], ResponseInterface::HTTP_FORBIDDEN);
        }

        // Mark agreement accepted
        try {
            $db = db_connect();
            $db->table('t_users_details')
                ->where('f_user_id', $user->f_user_id)
                ->update(['f_agrmt_accept' => 1]);
            $user->f_agrmt_accept = 1;
        } catch (\Throwable $e) {
            return $this->envelope([
                'success' => false,
                'code' => 'auth.agreement_update_failed',
                'message' => 'Failed to update agreement status.'
            ], ResponseInterface::HTTP_INTERNAL_SERVER_ERROR);
        }

        // Common post-auth, skip agreement gate (it’s been accepted now)
        return $this->handlePostAuthentication($model, $user, $config, true);
    }

    /**
     * POST /api/v1/auth/logout
     */
    public function logout()
    {
        if ($this->request->getMethod() !== 'POST') {
            return $this->envelope([
                'success' => false,
                'code' => 'common.method_not_allowed',
                'message' => 'Use POST for this endpoint.',
            ], ResponseInterface::HTTP_METHOD_NOT_ALLOWED);
        }

        session()->destroy();
        return $this->envelope([
            'success' => true,
            'code' => 'auth.logged_out',
            'message' => 'Logged out',
            'data' => null,
        ], ResponseInterface::HTTP_OK);
    }
}
