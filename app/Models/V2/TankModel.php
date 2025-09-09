<?php

namespace App\Models\V2;

use CodeIgniter\Model;

class TankModel extends Model
{
    protected $table            = 'tanks';
    protected $primaryKey       = 'tank_id';
    protected $useAutoIncrement = true;
    protected $returnType       = 'array';
    protected $allowedFields    = [
        'tank_name','product_id','station_id','tank_shape','height','diameter','width','length',
        'capacity','current_volume','current_height','high_level_alarm','high_level_warning',
        'reorder_level','shutoff_level','is_active','created_at','updated_at'
    ];

    public function tanksForUser(int $userId): array
    {
        return $this->db->table('user_tank_permissions utp')
            ->select('t.*')
            ->join('tanks t', 't.tank_id = utp.tank_id', 'inner')
            ->where('utp.user_id', $userId)
            ->get()
            ->getResultArray();
    }
}
