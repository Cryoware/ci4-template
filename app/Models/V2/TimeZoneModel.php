<?php

namespace App\Models\V2;

use CodeIgniter\Model;

class TimeZoneModel extends Model
{
    protected $table            = 'time_zones';
    protected $primaryKey       = 'time_zone_id';
    protected $useAutoIncrement = true;
    protected $returnType       = 'array';
    protected $allowedFields    = ['time_zone_name', 'utc_offset', 'is_dst'];
}
