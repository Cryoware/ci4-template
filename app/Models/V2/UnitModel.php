<?php

namespace App\Models\V2;

use CodeIgniter\Model;

class UnitModel extends Model
{
    protected $table            = 'units';
    protected $primaryKey       = 'unit_id';
    protected $useAutoIncrement = true;
    protected $returnType       = 'array';
    protected $allowedFields    = ['unit_name', 'unit_abbreviation', 'is_volume'];
}
