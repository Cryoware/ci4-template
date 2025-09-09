<?php

namespace App\Models\V2;

use CodeIgniter\Model;

class DepartmentModel extends Model
{
    protected $table            = 'departments';
    protected $primaryKey       = 'department_id';
    protected $useAutoIncrement = true;
    protected $returnType       = 'array';
    protected $allowedFields    = ['company_id', 'department_name', 'is_active', 'created_at', 'updated_at'];
}
