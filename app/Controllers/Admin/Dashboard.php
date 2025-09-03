<?php
// app/Controllers/Admin/Dashboard.php
namespace App\Controllers\Admin;

use App\Controllers\BaseController;

/**
 * Depending on the user's role, change what the user sees as the dashboard.
 * i.e., Admin, Manager, Employee, Tech, Installer, etc.
 */
class Dashboard extends BaseController
{
    public function index()
    {
        $data = [
            'PageTitle' => 'Admin Dashboard',
            'page' => [
                'key' => 'admin.settings',
                'title' => 'Admin Dashboard',
                'subtitle' => 'Main Operations',
                'page_menu' => [
                    ['label' => 'Settings', 'url' => site_url('/admin/settings')],
                ],
                'breadcrumbs' => [
                    ['label' => 'Home', 'url' => site_url('/')],
                    ['label' => 'Admin', 'url' => site_url('/admin/dashboard')],
                    ['label' => 'Dashboard', 'active' => true],
                ],
            ],
        ];

        return view('admin/dashboard', $data);
    }
}
