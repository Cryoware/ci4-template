<?php namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Libraries\ConfigService;

class Settings extends BaseController
{
    public function index()
    {
        // Load all settings (for settings page form)
        $settings = ConfigService::bulkGet();

        return view('admin/settings', [
            'settings' => $settings
        ]);
    }

    public function save()
    {
        // Example: pull form values
        $siteName        = $this->request->getPost('site_name');
        $maxLogin        = $this->request->getPost('max_login_attempts');
        $maintenanceMode = $this->request->getPost('maintenance_mode');
        $allowedIps      = $this->request->getPost('allowed_ips'); // comma separated

        // Bulk save configs (creates or updates as needed)
        ConfigService::bulkSet([
            'site_name' => [
                'value' => $siteName,
                'type'  => 'string'
            ],
            'max_login_attempts' => [
                'value' => (int) $maxLogin,
                'type'  => 'integer'
            ],
            'maintenance_mode' => [
                'value' => ($maintenanceMode === '1'),
                'type'  => 'boolean'
            ],
            'allowed_ips' => [
                'value' => array_map('trim', explode(',', $allowedIps)),
                'type'  => 'array'
            ]
        ]);

        return redirect()->to('/admin/settings')->with('message', 'Settings saved!');
    }
}
