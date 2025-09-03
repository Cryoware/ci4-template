<?php

namespace App\Libraries;

use Config\Database;

class ConfigManager
{
    private static $instance = null;
    private $cache = [];
    private $db;

    private function __construct()
    {
        $this->db = Database::connect();
    }

    public static function getInstance(): self
    {
        if (self::$instance === null) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    public function getReportUnits(): int
    {
        if (!isset($this->cache['report_units'])) {
            $builder = $this->db->table('t_adminstrative_options');
            $res = $builder->get()->getRow();
            $this->cache['report_units'] = $res->f_report_units ?? 0;
        }
        return $this->cache['report_units'];
    }

    public function getReportUnitsLabel(): string
    {
        if (!isset($this->cache['report_units_label'])) {
            $units = $this->getReportUnits();
            
            switch ($units) {
                case 1:
                    $label = lang('Lang.quarts');
                    break;
                case 2:
                    $label = lang('Lang.litres');
                    break;
                case 3:
                    $label = lang('Lang.pints');
                    break;
                case 4:
                    $label = lang('Lang.gallons');
                    break;
                default:
                    $label = '';
                    break;
            }
            
            $this->cache['report_units_label'] = $label;
        }
        return $this->cache['report_units_label'];
    }

    public function getMenuExpand(): int
    {
        if (!isset($this->cache['menu_expand'])) {
            $builder = $this->db->table('t_adminstrative_options');
            $res = $builder->get()->getRow();
            $this->cache['menu_expand'] = $res->f_menu_expand ?? 0;
        }
        return $this->cache['menu_expand'];
    }

    public function getConfig(string $key, $default = null)
    {
        if (!isset($this->cache[$key])) {
            $builder = $this->db->table('t_adminstrative_options');
            $res = $builder->get()->getRow();

            // Map database fields to config keys
            $mapping = [
                'report_units' => 'f_report_units',
                'tank_monitor' => 'f_tank_monitor',
                'menu_expand' => 'f_menu_expand',
                'report_units_label' => 'report_units_label',
                // Add other configuration fields as needed
            ];

            if (isset($mapping[$key])) {
                $this->cache[$key] = $res->{$mapping[$key]} ?? $default;
            } else {
                $this->cache[$key] = $default;
            }
        }
        return $this->cache[$key];
    }

    public function clearCache(): void
    {
        $this->cache = [];
    }
}