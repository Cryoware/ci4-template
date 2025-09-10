<?php

namespace App\Controllers\Api\V2;

use CodeIgniter\RESTful\ResourceController;
use CodeIgniter\API\ResponseTrait;
use App\Controllers\Api\V2\Traits\BearerAuthTrait;

abstract class BaseApiResourceController extends ResourceController
{
    use ResponseTrait, BearerAuthTrait;

    protected $format = 'json';

    public function index()
    {
        $this->requireBearerOrFail();
        $data = $this->model->findAll();
        return $this->respond([
            'success' => true,
            'data' => $data,
        ]);
    }

    public function show($id = null)
    {
        $this->requireBearerOrFail();
        if ($id === null) {
            return $this->failValidationErrors('ID is required');
        }
        $row = $this->model->find($id);
        if ($row === null) {
            return $this->failNotFound('Resource not found');
        }
        return $this->respond([
            'success' => true,
            'data' => $row,
        ]);
    }

    public function create()
    {
        $this->requireBearerOrFail();
        $payload = $this->request->getJSON(true);
        if (!is_array($payload)) {
            $payload = $this->request->getPost();
        }
        if (!$this->model->insert($payload)) {
            return $this->failValidationErrors($this->model->errors());
        }
        $id = $this->model->getInsertID();
        $row = $id ? $this->model->find($id) : $payload;
        return $this->respondCreated([
            'success' => true,
            'data' => $row,
        ]);
    }

    public function update($id = null)
    {
        $this->requireBearerOrFail();
        if ($id === null) {
            return $this->failValidationErrors('ID is required');
        }
        $payload = $this->request->getJSON(true);
        if (!is_array($payload)) {
            $payload = $this->request->getRawInput();
        }
        if (!$this->model->update($id, $payload)) {
            return $this->failValidationErrors($this->model->errors());
        }
        $row = $this->model->find($id);
        return $this->respond([
            'success' => true,
            'data' => $row,
        ]);
    }

    public function delete($id = null)
    {
        $this->requireBearerOrFail();
        if ($id === null) {
            return $this->failValidationErrors('ID is required');
        }
        $row = $this->model->find($id);
        if ($row === null) {
            return $this->failNotFound('Resource not found');
        }
        if (!$this->model->delete($id)) {
            return $this->failServerError('Failed to delete');
        }
        return $this->respondDeleted([
            'success' => true,
            'data' => $row,
        ]);
    }
}
