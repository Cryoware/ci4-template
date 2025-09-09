<?php

namespace App\Models\V2;

use CodeIgniter\Model;

class UserRoleModel extends Model
{
    protected $table            = 'user_roles';
    protected $primaryKey       = null; // composite key
    protected $useAutoIncrement = false;
    protected $returnType       = 'array';
    protected $allowedFields    = ['user_id', 'role_id'];

    /**
     * Return roles for a user as an array of [role_id, role_name]
     */
    public function rolesForUser(int $userId): array
    {
        return $this->db->table($this->table . ' ur')
            ->select('r.role_id, r.role_name')
            ->join('roles r', 'r.role_id = ur.role_id', 'inner')
            ->where('ur.user_id', $userId)
            ->get()
            ->getResultArray();
    }
}
