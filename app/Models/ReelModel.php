<?php

namespace App\Models;

use CodeIgniter\Model;
use CodeIgniter\Database\BaseBuilder;

class ReelModel extends Model
{
    protected $table      = 't_reel_data';
    protected $primaryKey = 'f_reel_id';
    protected $returnType = 'array';

    public function getReelsByStation(int $stationId): array
    {
        $db = $this->db;
        $builder = $db->table('t_reel_data tr');
        $builder
            ->select([
                'tr.*',
                'u.f_units_name',
                'tp.f_product_name',
                'td.f_tank_name',
                'td.f_tank_product_exe',
                'td.f_tank_product_id',
                'ds.f_serial_number',
            ])
            ->join('t_devices_software ds', 'tr.f_fcm_id = ds.f_devices_software_id', 'left')
            ->join('t_units u', 'tr.f_reel_units_id = u.f_units_id', 'left')
            ->join('t_tank_details td', 'tr.f_tank_id = td.f_tank_id', 'left')
            ->join('t_products tp', 'td.f_tank_product_id = tp.f_product_id', 'left')
            ->where('tr.f_station_id', $stationId)
            ->orderBy('tr.f_reel_id', 'ASC');

        return $builder->get()->getResultArray();
    }
}
