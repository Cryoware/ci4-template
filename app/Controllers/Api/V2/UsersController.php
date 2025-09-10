<?php

namespace App\Controllers\Api\V2;

class UsersController extends BaseApiResourceController
{
    protected $modelName = 'App\\Models\\V2\\UserModel';
    protected $format    = 'json';
}
