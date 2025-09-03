<?php

namespace App\Models;

use CodeIgniter\Model;

class UserDetailModel extends Model
{
    protected $table            = 't_users_details';
    protected $primaryKey       = 'f_user_id';
    protected $useAutoIncrement = true;

    protected $returnType       = 'array';
    protected $useSoftDeletes   = false;

    protected $allowedFields    = [
        'f_first_name',
        'f_last_name',
        'f_user_email',
        'f_user_pin',
        'f_user_email',
        'f_password',
        'f_user_enabled',
        'f_company_name',
        'f_department_name',
        'f_emergency_stop',
        'f_calibrate',
        'f_kfactor',
        'f_default',
        'f_agrmt_accept',
        'f_agrmt_email_copy',
        'f_agrmt_downloaded',
        'f_last_logout',
        'f_locked_until',
        'f_failed_login_count',
        'f_lockout_until',
        'f_status',
        'f_failed_login_attempts',
        'f_last_failed_login',
        'f_last_login',
        'f_created_at',
        'f_updated_at',
        'f_updated_by',
        'f_last_updated',
        'f_created_by',
        'f_create_by',
    ];

    protected $useTimestamps = true;
    protected $createdField  = 'f_created_at';
    protected $updatedField  = 'f_updated_at';

    // Columns allowed for ordering and searching via DataTables
    public const ORDERABLE = ['f_user_id', 'f_first_name', 'f_user_email', 'f_last_name', 'f_status', 'f_created_at'];
    public const SEARCHABLE = ['f_first_name', 'f_user_email', 'f_last_name', 'f_status'];

    public function datatablesQuery(array $params): array
    {
        $builder = $this->builder();

        // Normalize search param (handle string or array)
        $searchValue = '';
        if (isset($params['search'])) {
            if (is_array($params['search'])) {
                $searchValue = (string) ($params['search']['value'] ?? '');
            } elseif (is_string($params['search'])) {
                $searchValue = $params['search']; // fallback if client sent plain string
            }
        }

        if ($searchValue !== '') {
            $builder->groupStart();
            foreach (self::SEARCHABLE as $col) {
                $builder->orLike($col, $searchValue);
            }
            $builder->groupEnd();
        }

        // Ordering (guard against malformed 'order')
        if (isset($params['order']) && is_array($params['order']) && isset($params['order'][0]) && is_array($params['order'][0])) {
            $orderIndex = (int) ($params['order'][0]['column'] ?? 0);
            $dirRaw     = $params['order'][0]['dir'] ?? 'asc';
            $orderDir   = strtolower((string) $dirRaw) === 'desc' ? 'DESC' : 'ASC';
            $orderCol   = self::ORDERABLE[$orderIndex] ?? 'f_user_id';
            $builder->orderBy($orderCol, $orderDir);
        } else {
            $builder->orderBy('f_user_id', 'DESC');
        }

        // Total count before filtering
        $total = $this->countAll();

        // Filtered count
        $countBuilder = clone $builder;
        $countBuilder->select('COUNT(*) as filtered_count');
        $row = $countBuilder->get()->getRowArray();
        $filteredCount = isset($row['filtered_count']) ? (int) $row['filtered_count'] : 0;
        if ($searchValue === '') {
            $filteredCount = $total;
        }

        // Paging
        $length = (int) ($params['length'] ?? 10);
        $start  = (int) ($params['start'] ?? 0);
        if ($length > 0) {
            $builder->limit($length, $start);
        }

        $data = $builder->get()->getResultArray();

        return [
            'total'    => $total,
            'filtered' => $filteredCount,
            'data'     => $data,
        ];
    }
}
