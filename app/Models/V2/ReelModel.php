<?php

namespace App\Models\V2;

use CodeIgniter\Model;

class ReelModel extends Model
{
    protected $table            = 'reels';
    protected $primaryKey       = 'reel_id';
    protected $useAutoIncrement = true;
    protected $returnType       = 'array';
    protected $allowedFields    = ['reel_name', 'station_id', 'tank_id', 'is_active', 'k_factor', 'pulse_count', 'last_calibration_date', 'created_at', 'updated_at'];

    public function reelsForUser(int $userId): array
    {
        return $this->db->table('user_reel_permissions urp')
            ->select('r.*')
            ->join('reels r', 'r.reel_id = urp.reel_id', 'inner')
            ->where('urp.user_id', $userId)
            ->get()
            ->getResultArray();
    }
}
