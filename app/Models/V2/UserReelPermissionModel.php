<?php

namespace App\Models\V2;

use CodeIgniter\Model;

class UserReelPermissionModel extends Model
{
    protected $table            = 'user_reel_permissions';
    protected $primaryKey       = null; // composite key
    protected $useAutoIncrement = false;
    protected $returnType       = 'array';
    protected $allowedFields    = ['user_id', 'reel_id', 'can_dispense'];

    public function permissionsWithNamesForUser(int $userId): array
    {
        return $this->db->table($this->table . ' urp')
            ->select('r.reel_id, r.reel_name, urp.can_dispense')
            ->join('reels r', 'r.reel_id = urp.reel_id', 'inner')
            ->where('urp.user_id', $userId)
            ->get()
            ->getResultArray();
    }
}
