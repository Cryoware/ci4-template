<?php
declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use CodeIgniter\HTTP\RedirectResponse;
use CodeIgniter\HTTP\ResponseInterface;
use App\Models\AuthModel; // added

/**
 * Wave 1: Authentication endpoints (parallel to legacy)
 * - check_session_time_out (GET)
 */
final class AuthController extends BaseController
{
    /**
     * Render login form. If already logged in, send to dashboard.
     */
    public function login(): ResponseInterface|RedirectResponse|string
    {
        if (session()->get('userid')) {
            return redirect()->to(site_url('/dashboard'));
        }

        return view('admin/login', [
            'PageTitle'   => 'Admin Login',
            'agree'       => false,
            'usePinLogin' => (bool) (config('AuthUI')->usePinLogin ?? true),
        ]);
    }

    /**
     * Use POST /api/v1/auth/logout for API clients.
     */
    public function logout(): ResponseInterface|RedirectResponse
    {
        $accept = $this->request->getHeaderLine('Accept');
        if (stripos($accept, 'application/json') !== false) {
            $api = new \App\Controllers\Api\V1\AuthApiController();
            return $api->logout();
        }
        session()->destroy();
        return redirect()->to(site_url('/'));
    }
}
