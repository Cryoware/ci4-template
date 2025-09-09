<?php

namespace App\Models\V2;

use CodeIgniter\Model;

class CompanyModel extends Model
{
    protected $table            = 'companies';
    protected $primaryKey       = 'company_id';
    protected $useAutoIncrement = true;
    protected $returnType       = 'array';
    protected $allowedFields    = ['company_name', 'is_active', 'created_at', 'updated_at'];
}
