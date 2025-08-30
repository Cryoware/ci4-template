<?php namespace App\Models;

use CodeIgniter\Model;

class ConfigModel extends Model
{
    protected $table      = 'app_config';
    protected $primaryKey = 'config_key';
    protected $returnType = 'array';
    protected $allowedFields = ['config_key', 'config_value', 'config_type', 'updated_at'];

    /**
     * Fetch all configs as key => value array
     */
    public function getAllConfigs(): array
    {
        $result = $this->select(['config_key', 'config_value'])->findAll();
        $configs = [];
        foreach ($result as $row) {
            $configs[$row['config_key']] = $row['config_value'];
        }
        return $configs;
    }
}
