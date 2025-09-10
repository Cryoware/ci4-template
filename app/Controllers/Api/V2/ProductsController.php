<?php

namespace App\Controllers\Api\V2;

class ProductsController extends BaseApiResourceController
{
    protected $modelName = 'App\\Models\\V2\\ProductModel';
    protected $format    = 'json';
}
