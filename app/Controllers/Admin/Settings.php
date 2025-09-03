<?php namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Libraries\ConfigService;

class Settings extends BaseController
{
    public function index()
    {
        // Load all settings (for settings page form)
        $settings = ConfigService::bulkGet();

        $data = [
            'PageTitle' => 'Settings Dashboard',
            'page' => [
                'key'   => 'admin.settings',
                'title' => 'Settings',
                'subtitle' => 'Configure application settings',
                'breadcrumbs' => [
                    ['label' => 'Home', 'url' => site_url('/')],
                    ['label' => 'Admin', 'url' => site_url('/admin/dashboard')],
                    ['label' => 'Settings', 'active' => true],
                ],
                'actions' => [
                    // Top-right buttons in the header/top area:
                    [
                        'type'  => 'submit',                 // button or 'submit' or 'link'
                        'label' => 'Save',
                        'class' => 'btn btn-primary btn-sm',
                        'attrs' => ['form' => 'settingsForm'] // submit the form from outside
                    ],
                    [
                        'type'  => 'link',
                        'label' => 'Cancel',
                        'class' => 'btn btn-outline-secondary btn-sm',
                        'href'  => site_url('/admin/dashboard')
                    ],
                    [
                        'type'  => 'link',
                        'label' => 'Refresh',
                        'class' => 'btn btn-secondary btn-sm',
                        'href'  => current_url(),
                        'attrs' => ['data-action' => 'refresh']
                    ],
                ],
            ],
            'settings' => $settings
        ];

        return view('admin/settings', $data);

    }

    public function save()
    {
        // Example: pull form values
        $siteName        = $this->request->getPost('site_name');
        $maxLogin        = $this->request->getPost('max_login_attempts');
        $maintenanceMode = $this->request->getPost('maintenance_mode');
        $allowedIps      = $this->request->getPost('allowed_ips'); // comma separated

        try {
            ConfigService::bulkSet([
                'site_name' => [
                    'value' => (string) $siteName,
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
                    // Allow either array or comma-separated string; service will normalize
                    'value' => is_array($allowedIps)
                        ? $allowedIps
                        : array_map('trim', array_filter(explode(',', (string) $allowedIps))),
                    'type'  => 'array'
                ]
            ]);

            // Ensure next request reloads fresh values
            ConfigService::clearCache();

            return redirect()->to('/admin/settings')->with('message', 'Settings saved!');
        } catch (\Throwable $e) {
            log_message('error', 'Settings save failed: {msg}', ['msg' => $e->getMessage()]);
            return redirect()->to('/admin/settings')->with('message', 'Failed to save settings. Please try again.');
        }
    }
}
