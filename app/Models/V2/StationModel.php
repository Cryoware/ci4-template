<?php

namespace App\Models\V2;

use CodeIgniter\Model;

class StationModel extends Model
{
    protected $table            = 'stations';
    protected $primaryKey       = 'station_id';
    protected $useAutoIncrement = true;
    protected $returnType       = 'array';
    protected $allowedFields    = ['station_name', 'location_description', 'is_active', 'display_priority', 'created_at', 'updated_at'];

    /**
     * Return full station rows the user has any access to (can_access=1) via user_station_permissions.
     */
    public function stationsForUser(int $userId): array
    {
        return $this->db->table('user_station_permissions usp')
            ->select('s.*')
            ->join('stations s', 's.station_id = usp.station_id', 'inner')
            ->where('usp.user_id', $userId)
            ->where('usp.can_access', 1)
            ->orderBy('s.display_priority', 'ASC')
            ->get()
            ->getResultArray();
    }
}
