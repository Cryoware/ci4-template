<?php

declare(strict_types=1);

namespace Config;

use CodeIgniter\Config\BaseConfig;
use App\Enums\RoleId;

class AuthUI extends BaseConfig
{
    /**
     * When true, render the PIN keypad login UI.
     * When false, render the Username/Password login UI.
     */
    public bool $usePinLogin = true;

    /**
     * Map of role ID to dashboard path.
     * Override in environment-specific configs if needed.
     */
    public array $redirectByRole = [];

    /**
     * Default redirect if role is not mapped.
     */
    public string $defaultRedirect = '/admin/dashboard';

    public function __construct()
    {
        parent::__construct();

        $this->redirectByRole = [
            RoleId::ADMIN->value     => '/admin/dashboard',
            RoleId::INSTALLER->value => '/admin/dashboard', // shares the same UI
            RoleId::MANAGER->value   => '/admin/manager_dashboard',
            RoleId::TECH->value      => '/admin/tech_dashboard',
        ];
    }
}
