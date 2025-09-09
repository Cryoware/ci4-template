<?php

namespace App\Models\V2;

use CodeIgniter\Model;

class UserTankPermissionModel extends Model
{
    protected $table            = 'user_tank_permissions';
    protected $primaryKey       = null; // composite key
    protected $useAutoIncrement = false;
    protected $returnType       = 'array';
    protected $allowedFields    = ['user_id', 'tank_id', 'can_dispense', 'can_override'];

    /**
     * Returns permissions for user with tank names included.
     * Each row: tank_id, tank_name, can_dispense, can_override
     */
    public function permissionsWithNamesForUser(int $userId): array
    {
        return $this->db->table($this->table . ' utp')
            ->select('t.tank_id, t.tank_name, utp.can_dispense, utp.can_override')
            ->join('tanks t', 't.tank_id = utp.tank_id', 'inner')
            ->where('utp.user_id', $userId)
            ->get()
            ->getResultArray();
    }
}
