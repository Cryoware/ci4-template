<?php

namespace App\Controllers\Api\V2;

class TimeZonesController extends BaseApiResourceController
{
    protected $modelName = 'App\\Models\\V2\\TimeZoneModel';
    protected $format    = 'json';
}
