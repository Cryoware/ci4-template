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
        // Prefer GET for DataTables requests
        $params = $this->request->getGet();

        // Normalize search into $params['search']['value']
        $search = $this->request->getVar('search'); // handles nested arrays
        if (is_array($search) && array_key_exists('value', $search)) {
            $params['search'] = ['value' => (string) $search['value']];
        } elseif (($flat = $this->request->getGet('search[value]')) !== null) {
            $params['search'] = ['value' => (string) $flat];
        }

        // Optional: normalize order too (guard for malformed inputs)
        $order = $this->request->getVar('order');
        if (is_array($order)) {
            $params['order'] = $order;
        }

        $dt = $this->model->datatablesQuery($params);

        // Gate meta SQL by environment and query flag
        $allowDebug = (ENVIRONMENT !== 'production');
        $debugFlag  = (bool) ($this->request->getGet('debug_sql') ?? false);
        $debug      = $allowDebug && $debugFlag;

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

        if ($debug) {
            $data['meta'] = [
                'sql_data'  => $dt['sql_data']  ?? null,
                'sql_count' => $dt['sql_count'] ?? null,
                'search'    => $params['search']['value'] ?? null,
            ];
        }

        return $this->response->setJSON($data);
    }

    // Show single user

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
