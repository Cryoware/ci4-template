<?php

namespace App\Models\V2;

use CodeIgniter\Model;

class ProductModel extends Model
{
    protected $table            = 'products';
    protected $primaryKey       = 'product_id';
    protected $useAutoIncrement = true;
    protected $returnType       = 'array';
    protected $allowedFields    = [
        'customer_product_id', 'product_name', 'description', 'specific_gravity',
        'default_unit_id', 'max_preset_amount', 'max_open_amount',
        'is_collection_only', 'is_active', 'created_at', 'updated_at'
    ];
}
