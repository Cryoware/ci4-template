<?php

namespace App\Models;

use CodeIgniter\Model;

class StationModel extends Model
{
    protected $table      = 't_stations';
    protected $primaryKey = 'f_station_id';
    protected $returnType = 'array';

    public function getDefaultStationId(): ?int
    {
        $row = $this->orderBy('f_station_priority', 'ASC')
            ->select('f_station_id')
            ->get(1)
            ->getRowArray();

        return $row['f_station_id'] ?? null;
    }
}
