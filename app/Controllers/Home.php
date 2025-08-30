<?php

namespace App\Controllers;

use App\Libraries\ConfigService;

class Home extends BaseController
{
    public function index(): string
    {
//        $siteName = ConfigService::get('site_name', 'My Default Site');
//        ConfigService::set('site_name', 'Awesome App');
//        ConfigService::clearCache();

        // Strings
        ConfigService::set('site_name', 'My Website', 'string');
        echo ConfigService::get('site_name'); // "My Website"

        // Integers
        ConfigService::set('max_login_attempts', 5, 'integer');
        echo ConfigService::get('max_login_attempts'); // 5 (int)

        // Booleans
        ConfigService::set('maintenance_mode', true, 'boolean');
        var_dump(ConfigService::get('maintenance_mode')); // bool(true)

        // Arrays
        ConfigService::set('allowed_ips', ['127.0.0.1', '192.168.0.1'], 'array');
        print_r(ConfigService::get('allowed_ips')); // ["127.0.0.1","192.168.0.1"]

        // Dictionaries
        ConfigService::set('mail_settings', [
            'host' => 'smtp.example.com',
            'port' => 587,
        ], 'dictionary');
        print_r(ConfigService::get('mail_settings')); // ["host"=>"smtp.example.com","port"=>587]

        // Get multiple configs at once:
        $settings = ConfigService::bulkGet(['site_name', 'max_login_attempts', 'maintenance_mode']);
        /*
        [
          'site_name' => "My Website",
          'max_login_attempts' => 5,
          'maintenance_mode' => true
        ]
        */
        // Get all configs (useful to render settings page form):
        $allSettings = ConfigService::bulkGet();
        // Update multiple configs at once (e.g. from settings form):
        ConfigService::bulkSet([
            'site_name' => [
                'value' => 'New Name',
                'type'  => 'string'
            ],
            'max_login_attempts' => [
                'value' => 10,
                'type'  => 'integer'
            ],
            'maintenance_mode' => [
                'value' => false,
                'type'  => 'boolean'
            ],
            'allowed_ips' => [
                'value' => ['127.0.0.1', '10.0.0.1'],
                'type'  => 'array'
            ]
        ]);


        return view('welcome_message', ['siteName' => $siteName]);
    }
}
