<?php

namespace App\Models;

use CodeIgniter\Model;

class CapabilityModel extends Model
{
    protected $table      = 't_user_capabilities_map';
    protected $primaryKey = 'f_user_capabilities_map_id'; // adjust if needed
    protected $returnType = 'array';

    public function getCapabilityIdsByUser(int $userId): array
    {
        if ($userId <= 0) {
            return [];
        }

        $rows = $this->where('f_user_id', $userId)->findAll();

        // In case multiple rows exist, combine and deduplicate
        $ids = [];
        foreach ($rows as $row) {
            $parts = array_filter(array_map('trim', explode(',', $row['f_capabilities_id'] ?? '')));
            foreach ($parts as $p) {
                $ids[(int) $p] = true;
            }
        }

        return array_keys($ids);
    }
}
