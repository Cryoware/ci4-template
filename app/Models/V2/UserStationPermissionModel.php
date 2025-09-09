<?php

namespace App\Models\V2;

use CodeIgniter\Model;

class UserStationPermissionModel extends Model
{
    protected $table            = 'user_station_permissions';
    protected $primaryKey       = null; // composite key
    protected $useAutoIncrement = false;
    protected $returnType       = 'array';
    protected $allowedFields    = ['user_id', 'station_id', 'can_access'];

    /**
     * Return station permissions for a user as an array of
     * [station_id, can_access]
     */
    public function permissionsForUser(int $userId): array
    {
        return $this->db->table($this->table)
            ->select('station_id, can_access')
            ->where('user_id', $userId)
            ->get()
            ->getResultArray();
    }

    /**
     * Return station permissions with station names.
     * Each item: station_id, station_name, can_access
     */
    public function permissionsWithNamesForUser(int $userId): array
    {
        return $this->db->table($this->table . ' usp')
            ->select('s.station_id, s.station_name, usp.can_access')
            ->join('stations s', 's.station_id = usp.station_id', 'inner')
            ->where('usp.user_id', $userId)
            ->get()
            ->getResultArray();
    }
}
