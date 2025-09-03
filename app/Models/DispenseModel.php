<?php

namespace App\Models;

use CodeIgniter\Model;

class DispenseModel extends Model
{
    protected $table      = 't_dispense';
    protected $primaryKey = 'f_dispense_id'; // adjust if needed
    protected $returnType = 'array';

    public function getActiveReelIds(): array
    {
        $rows = $this->select('f_reel_id')
            ->where('f_dispense_time_completed', 0)
            ->findAll();

        $ids = [];
        foreach ($rows as $r) {
            if (isset($r['f_reel_id'])) {
                $ids[] = (int) $r['f_reel_id'];
            }
        }
        return $ids;
    }
}
