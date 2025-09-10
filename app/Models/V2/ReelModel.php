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

    public function getReelsByStation(int $stationId): array
    {
        return $this->db->table('user_reel_permissions urp')
            ->select('r.*')
            ->join('reels r', 'r.reel_id = urp.reel_id', 'inner')
            ->where('urp.user_id', $userId)
            ->get()
            ->getResultArray();

        $builder = $db->table('reels r');
        $builder
            ->select([
                'r.*',
                'u.f_units_name',
                'tp.f_product_name',
                'td.f_tank_name',
                'td.f_tank_product_exe',
                'td.f_tank_product_id',
                'ds.f_serial_number',
            ])
            ->join('t_devices_software ds', 'r.f_fcm_id = ds.f_devices_software_id', 'left')
            ->join('t_units u', 'r.f_reel_units_id = u.f_units_id', 'left')
            ->join('t_tank_details td', 'r.f_tank_id = td.f_tank_id', 'left')
            ->join('t_products tp', 'td.f_tank_product_id = tp.f_product_id', 'left')
            ->where('r.f_station_id', $stationId)
            ->orderBy('r.f_reel_id', 'ASC');

        return $builder->get()->getResultArray();
    }

}
