<?php

namespace App\Controllers\Api\V1;

use App\Controllers\BaseController;
use App\Models\UserDetailModel;
use App\Models\UserDetailModel as UserDetail;
use CodeIgniter\HTTP\ResponseInterface;

class UsersApiController extends BaseController
{
    protected UserDetailModel $model;

    public function __construct()
    {
        $this->model = new UserDetail();
        helper(['form', 'text']);
    }

    // DataTables server-side + index listing
    public function index()
    {
        $params = $this->request->getGet() + $this->request->getPost();

        $dt = $this->model->datatablesQuery($params);

        $data = [
            'draw'            => (int) ($params['draw'] ?? 0),
            'recordsTotal'    => $dt['total'],
            'recordsFiltered' => $dt['filtered'],
            'data'            => array_map(static function (array $row) {
                // Ensure ordering columns match the table in the view
                return [
                    $row['f_user_id'] ?? '',
                    $row['f_first_name'] ?? '',
                    $row['f_user_email'] ?? '',
                    $row['f_last_name'] ?? '',
                    $row['f_status'] ?? '',
                    $row['f_created_at'] ?? '',
                    $row['f_user_id'] ?? '', // for actions column
                ];
            }, $dt['data']),
        ];

        return $this->response->setJSON($data);
    }

    // Show single user
    public function show(?int $f_user_id = null)
    {
        if ($f_user_id === null) {
            return $this->failValidationError('ID is required');
        }

        $user = $this->model->find($f_user_id);
        if (!$user) {
            return $this->failNotFound("User {$f_user_id} not found");
        }

        return $this->response->setJSON($user);
    }

    // Create
    public function create()
    {
        $data = $this->request->getJSON(true) ?? $this->request->getPost();

        $rules = [
            'f_first_name'   => 'required|min_length[2]|max_length[100]',
            'f_user_email'  => 'required|valid_email|max_length[150]',
            'f_last_name'   => 'permit_empty|max_length[50]',
            'f_status' => 'permit_empty|in_list[active,inactive,banned]',
        ];

        if (!$this->validate($rules)) {
            return $this->response->setStatusCode(ResponseInterface::HTTP_UNPROCESSABLE_ENTITY)
                ->setJSON(['errors' => $this->validator->getErrors()]);
        }

        // Unique email check (adjust if unique index exists)
        $exists = $this->model->where('f_user_email', $data['f_user_email'])->first();
        if ($exists) {
            return $this->response->setStatusCode(ResponseInterface::HTTP_CONFLICT)
                ->setJSON(['errors' => ['f_user_email' => 'Email already exists']]);
        }

        $f_user_id = $this->model->insert([
            'f_first_name'   => $data['f_first_name'],
            'f_user_email'  => $data['f_user_email'],
            'f_last_name'   => $data['f_last_name']   ?? null,
            'f_status' => $data['f_status'] ?? 'active',
        ], true);

        $created = $this->model->find($f_user_id);

        return $this->response->setStatusCode(ResponseInterface::HTTP_CREATED)->setJSON($created);
    }

    // Update
    public function update($f_user_id = null)
    {
        if ($f_user_id === null) {
            return $this->failValidationError('ID is required');
        }

        $payload = $this->request->getJSON(true) ?? $this->request->getRawInput();

        $rules = [
            'f_first_name'   => 'permit_empty|min_length[2]|max_length[100]',
            'f_user_email'  => 'permit_empty|valid_email|max_length[150]',
            'f_last_name'   => 'permit_empty|max_length[50]',
            'f_status' => 'permit_empty|in_list[active,inactive,banned]',
        ];

        if (!$this->validate($rules)) {
            return $this->response->setStatusCode(ResponseInterface::HTTP_UNPROCESSABLE_ENTITY)
                ->setJSON(['errors' => $this->validator->getErrors()]);
        }

        if (isset($payload['f_user_email'])) {
            $exists = $this->model->where('f_user_email', $payload['f_user_email'])
                ->where('f_user_id !=', $f_user_id)->first();
            if ($exists) {
                return $this->response->setStatusCode(ResponseInterface::HTTP_CONFLICT)
                    ->setJSON(['errors' => ['f_user_email' => 'Email already exists']]);
            }
        }

        if (!$this->model->find($f_user_id)) {
            return $this->failNotFound("User {$f_user_id} not found");
        }

        $this->model->update($f_user_id, $payload);
        $updated = $this->model->find($f_user_id);

        return $this->response->setJSON($updated);
    }

    // Delete
    public function delete($f_user_id = null)
    {
        if ($f_user_id === null) {
            return $this->failValidationError('ID is required');
        }

        if (!$this->model->find($f_user_id)) {
            return $this->failNotFound("User {$f_user_id} not found");
        }

        $this->model->delete($f_user_id);

        return $this->response->setJSON(['f_status' => 'ok']);
    }

    // Helpers for consistent error JSON
    protected function failValidationError(string $message)
    {
        return $this->response->setStatusCode(ResponseInterface::HTTP_BAD_REQUEST)
            ->setJSON(['error' => $message]);
    }

    protected function failNotFound(string $message)
    {
        return $this->response->setStatusCode(ResponseInterface::HTTP_NOT_FOUND)
            ->setJSON(['error' => $message]);
    }
}
