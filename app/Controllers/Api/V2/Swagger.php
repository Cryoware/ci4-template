<?php

namespace App\Controllers\Api\V2;

use App\Controllers\BaseController;
use CodeIgniter\HTTP\ResponseInterface;

class Swagger extends BaseController
{
    public function index(): ResponseInterface
    {
        $yamlPath = APPPATH . 'Views/api/swagger.yaml';

        if (! is_file($yamlPath)) {
            return $this->response
                ->setStatusCode(404)
                ->setBody('Swagger file not found');
        }

        $yaml = file_get_contents($yamlPath);

        return $this->response
            ->setStatusCode(200)
            ->setContentType('application/yaml')
            ->setBody($yaml);
    }

    // ... existing code ...

    public function ui(): string
    {
        // This renders a minimal, isolated UI (no app CSS).
        return view('api/swagger_ui');
    }
}