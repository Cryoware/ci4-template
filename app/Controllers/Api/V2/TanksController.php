<?php

namespace App\Controllers\Api\V2;

class TanksController extends BaseApiResourceController
{
    protected $modelName = 'App\\Models\\V2\\TankModel';
    protected $format    = 'json';
}
