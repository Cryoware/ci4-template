<?php

if (!function_exists('get_app_version')) {
    function get_app_version()
    {
        $versionFile = ROOTPATH . 'VERSION';

        if (file_exists($versionFile)) {
            return trim(file_get_contents($versionFile));
        }

        // Fallback if the VERSION file doesn't exist
        return '0.0.0-dev';
    }
}