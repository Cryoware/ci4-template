<?php

namespace App\Models;

use CodeIgniter\Model;

class TankModel extends Model
{
    protected $table = 't_tank_details';
    protected $primaryKey = 'f_tank_id';
    protected $allowedFields = ['*'];

    public function getTanksWithDetails($limit = null)
    {
        $builder = $this->db->table('t_tank_details AS td')
            ->select('td.*, ts.*, tp.*, tu.*, tc.*, tds.f_devices_status AS SensorStatus')
            ->join('t_tank_software AS ts', 'td.f_tank_id = ts.f_tank_id', 'left')
            ->join('t_tank_configuration as tc', 'td.f_tank_id = tc.f_tank_id', 'left')
            ->join('t_products AS tp', 'td.f_tank_product_id = tp.f_product_id', 'left')
            ->join('t_units AS tu', 'td.f_tank_product_units_id = tu.f_units_id', 'left')
            ->join('t_sensor AS tsens', 'tsens.f_tank_id = td.f_tank_id', 'left')
            ->join('t_devices_software AS tds', 'tds.f_devices_software_id = tsens.f_sensor_hardware', 'left')
            ->orderBy('td.f_tank_id', 'ASC');

        if ($limit) {
            $builder->limit($limit);
        }

        return $builder->get()->getResultArray();
    }

    public function getTankCount()
    {
        return $this->db->table('t_tank_details')->countAllResults();
    }

    public function getTankFullDetails($tank_id = '')
    {
        return $this->db->table('t_tank_details as td')
            ->select('ts.*,tc.*,td.*')
            ->join('t_tank_software as ts', 'ts.f_tank_id=td.f_tank_id', 'left')
            ->join('t_tank_configuration as tc', 'tc.f_tank_id=td.f_tank_id', 'left')
            ->where('td.f_tank_id', $tank_id)
            ->get()
            ->getRow();
    }

    public function baseBuilder()
    {
        return $this->db->table('t_tank_details AS td')
            ->select([
                'td.*',
                'ts.*',
                'tp.*',
                'tu.*',
                'tc.*',
                'tds.f_devices_status AS SensorStatus',
            ])
            ->join('t_tank_software AS ts', 'td.f_tank_id = ts.f_tank_id', 'left')
            ->join('t_tank_configuration AS tc', 'td.f_tank_id = tc.f_tank_id', 'left')
            ->join('t_products AS tp', 'td.f_tank_product_id = tp.f_product_id', 'left')
            ->join('t_units AS tu', 'td.f_tank_product_units_id = tu.f_units_id', 'left')
            ->join('t_sensor AS tsens', 'tsens.f_tank_id = td.f_tank_id', 'left')
            ->join('t_devices_software AS tds', 'tds.f_devices_software_id = tsens.f_sensor_hardware', 'left')
            ->orderBy('td.f_tank_id', 'ASC');
    }

    public function getTanks(?int $limit = null): array
    {
        $builder = $this->baseBuilder();
        if ($limit !== null && $limit > 0) {
            $builder->limit($limit);
        }
        return $builder->get()->getResultArray();
    }

    public function getCount(): int
    {
        return (int) $this->db->table('t_tank_details')->countAllResults();
    }
}