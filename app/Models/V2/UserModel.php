<?php

namespace App\Models\V2;

use CodeIgniter\Model;

class UserModel extends Model
{
    protected $table            = 'users';
    protected $primaryKey       = 'user_id';
    protected $useAutoIncrement = true;

    protected $returnType       = 'array';
    protected $useSoftDeletes   = false;

    protected $allowedFields    = [
        'external_uuid',
        'username',
        'email',
        'first_name',
        'last_name',
        'password_hash',
        'pin_hash',
        'company_id',
        'department_id',
        'language_id',
        'time_zone_id',
        'is_active',
        'is_locked',
        'lockout_reason',
        'lockout_until',
        'must_change_password',
        'agreed_to_terms',
        'agreed_to_terms_at',
        'last_login_at',
        'last_login_ip',
        'last_login_user_agent',
        'last_logout_at',
        'last_logout_type',
        'account_expires_at',
        'created_at',
        'updated_at',
        'updated_by',
        'created_by',
    ];

    protected $useTimestamps = true;
    protected $createdField  = 'created_at';
    protected $updatedField  = 'updated_at';
}
