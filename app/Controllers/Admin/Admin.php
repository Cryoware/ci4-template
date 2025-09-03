<?php
declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use CodeIgniter\HTTP\RedirectResponse;
use CodeIgniter\HTTP\ResponseInterface;

/**
 * Minimal Admin controller for Wave 0 (Dashboard & Logout)
 * - Provides index(), dashboard(), logout() mapped to parallel routes
 * - Does not replace legacy Modules routes yet
 */
class Admin extends BaseController
{
    /**
     * Render the Admin dashboard (parallel to legacy index)
     */
    public function index()
    {
        // Just render the dashboard view
        return view('admin/dashboard');
    }

    /**
     * Destroy session and redirect to base (or legacy entry)
     */
    public function logout(): RedirectResponse
    {
        // End the user session
        session()->destroy();

        // Redirect to base URL; legacy entry point (/) maps to legacy Admin::index
        return redirect()->to(site_url('/'));
    }
}
