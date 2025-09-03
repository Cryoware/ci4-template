<?php
namespace Config;

use CodeIgniter\Config\BaseConfig;

class AuthConfig extends BaseConfig
{
    // PIN rules (override in .env if desired, e.g., auth.pinMinLength = 4)
    public int $pinMinLength = 4;
    public int $pinMaxLength = 10;

    // Credential rules
    public int $minCredentialLength = 3;

    // Time math
    public int $secondsPerHour = 3600;
}
