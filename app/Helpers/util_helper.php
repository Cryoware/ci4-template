<?php

use App\Libraries\ConfigManager;

if (!function_exists('isMobileDevice')) {
    function isMobileDevice(): bool
    {
        return preg_match(
            "/(android|avantgo|blackberry|bolt|boost|cricket|docomo|fone|hiptop|mini|mobi|palm|phone|pie|tablet|up\.browser|up\.link|webos|wos)/i",
            $_SERVER["HTTP_USER_AGENT"] ?? ''
        );
    }
}

if (!function_exists('get_config_units')) {
    function get_config_units(): int
    {
        return ConfigManager::getInstance()->getReportUnits();
    }
}

if (!function_exists('get_app_config')) {
    function get_app_config(string $key, $default = null)
    {
        return ConfigManager::getInstance()->getConfig($key, $default);
    }
}

if (!function_exists('get_config_units_label')) {
    function get_config_units_label(): string
    {
        return ConfigManager::getInstance()->getReportUnitsLabel();
    }
}

if (!function_exists('amt_conversion')) {
    function amt_conversion($from_units, $to_units, $dispense_amount)
    {

        $converted_amount = $dispense_amount;
        $match = $from_units . $to_units;
        switch ($match) {
            case 41: //\\ GALLONS -- DISPENSE QUARTS
                $converted_amount = ($dispense_amount * 4);
                break;
            case 42: //\\ GALLONS -- DISPENSE LITERS
                $converted_amount = ($dispense_amount * 3.78541);
                break;
            case 43: //\\ GALLONS -- DISPENSE PINTS
                $converted_amount = ($dispense_amount * 8);
                break;
            case 12: //\\ QUARTS -- DISPENSE  LITERS
                $converted_amount = ($dispense_amount * 0.946353);
                break;
            case 13: //\\ QUARTS -- DISPENSE  PINTS
                $converted_amount = ($dispense_amount * 2);
                break;
            case 14: //\\ QUARTS -- DISPENSE  GALLONS
                $converted_amount = ($dispense_amount * 0.25);
                break;
            case 21: //\\ LITERS -- DISPENSE  QUARTS
                $converted_amount = ($dispense_amount * 1.05669);
                break;
            case 23: //\\ LITERS -- DISPENSE  PINTS
                $converted_amount = ($dispense_amount * 2.11338);
                break;
            case 24: //\\ LITERS -- DISPENSE  GALLONS
                $converted_amount = ($dispense_amount * 0.264172);
                break;
            case 31: //\\ PINTS -- DISPENSE  QUARTS
                $converted_amount = ($dispense_amount * 0.5);
                break;
            case 32: //\\ PINTS -- DISPENSE  LITERS
                $converted_amount = ($dispense_amount * 0.473176);
                break;
            case 34: //\\ PINTS -- DISPENSE  GALLONS
                $converted_amount = ($dispense_amount * 0.125);
                break;
            default:
                $converted_amount = $dispense_amount;
        }
        return round($converted_amount ?? 0, 2);
    }
}