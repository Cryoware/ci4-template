<?php

namespace App\Models;

use CodeIgniter\Model;

class UsersModel extends Model
{
    protected $table            = 'users';
    protected $primaryKey       = 'user_id';
    protected $useAutoIncrement = true;

    protected $returnType       = 'array';
    protected $useSoftDeletes   = false;

    protected $allowedFields    = [
        'external_uuid',
        'username',
        'email',
        'first_name',
        'last_name',
        'password_hash',
        'pin_hash',
        'company_id',
        'department_id',
        'language_id',
        'time_zone_id',
        'is_active',
        'is_locked',
        'lockout_reason',
        'lockout_until',
        'must_change_password',
        'agreed_to_terms',
        'agreed_to_terms_at',
        'last_login_at',
        'last_login_ip',
        'last_login_user_agent',
        'last_logout_at',
        'last_logout_type',
        'account_expires_at',
        'created_at',
        'updated_at',
        'updated_by',
        'created_by',
    ];

    protected $useTimestamps = true;
    protected $createdField  = 'created_at';
    protected $updatedField  = 'updated_at';

    // Columns allowed for ordering and searching via DataTables (aligned with schema)
    public const ORDERABLE = ['user_id', 'first_name', 'email', 'last_name', 'is_active', 'created_at'];
    public const SEARCHABLE = ['first_name', 'email', 'last_name'];

    public function datatablesQuery(array $params): array
    {
        $builder = $this->builder();

        // Normalize search param: support both nested (search[value]) and flat ('search[value]')
        $searchValue = '';
        if (isset($params['search'])) {
            if (is_array($params['search'])) {
                $searchValue = (string) ($params['search']['value'] ?? '');
            } elseif (is_string($params['search'])) {
                $searchValue = $params['search']; // fallback if client sent plain string
            }
        }
        if ($searchValue === '' && isset($params['search[value]'])) {
            $searchValue = (string) $params['search[value]'];
        }

        $searchValue = trim($searchValue);

        if ($searchValue !== '') {
            // Escape LIKE wildcards and apply contains-match across all searchable columns
            $escaped = $this->db->escapeLikeString($searchValue);

            $builder->groupStart();
            $first = true;
            foreach (self::SEARCHABLE as $col) {
                // CI4.6 like(field, match, side='both', escape=null)
                if ($first) {
                    $builder->like($col, $escaped, 'both', null);
                    $first = false;
                } else {
                    $builder->orLike($col, $escaped, 'both', null);
                }
            }
            $builder->groupEnd();
        }

        // Total count BEFORE any filtering (use a separate fresh builder so we don't reset the active one)
        $total = $this->db->table($this->table)->countAllResults();

        // IMPORTANT: Get filtered count BEFORE applying ORDER BY (so count has no ORDER)
        $countBuilder = clone $builder;
        $countBuilder->select('COUNT(*) as filtered_count');
        $compiledCountSql = $countBuilder->getCompiledSelect(false);
        $row = $countBuilder->get()->getRowArray();
        $filteredCount = isset($row['filtered_count']) ? (int) $row['filtered_count'] : 0;
        if ($searchValue === '') {
            $filteredCount = $total;
        }

        // Now apply ordering (used only for the data query)
        if (isset($params['order']) && is_array($params['order']) && isset($params['order'][0]) && is_array($params['order'][0])) {
            $orderIndex = (int) ($params['order'][0]['column'] ?? 0);
            $dirRaw     = $params['order'][0]['dir'] ?? 'asc';
            $orderDir   = strtolower((string) $dirRaw) === 'desc' ? 'DESC' : 'ASC';
            $orderCol   = self::ORDERABLE[$orderIndex] ?? 'user_id';
            $builder->orderBy($orderCol, $orderDir);
        } else {
            $builder->orderBy('user_id', 'DESC');
        }

        // Take compiled SQL snapshot for data BEFORE pagination is applied
        $compiledDataSql = $builder->getCompiledSelect(false);

        // Paging
        $length = (int) ($params['length'] ?? 10);
        $start  = (int) ($params['start'] ?? 0);
        if ($length > 0) {
            $builder->limit($length, $start);
        }

        $data = $builder->get()->getResultArray();

        // Optional debug logs controlled by .env flag app.logDTSQL
        $logSql = (bool) (env('app.logDTSQL') ?? false);
        if ($logSql) {
            log_message('debug', 'DT compiled data SQL: {sql}', ['sql' => $compiledDataSql]);
            log_message('debug', 'DT compiled count SQL: {sql}', ['sql' => $compiledCountSql]);
        }

        return [
            'total'     => $total,
            'filtered'  => $filteredCount,
            'data'      => $data,
            'sql_data'  => $compiledDataSql,   // for debug passthrough
            'sql_count' => $compiledCountSql,  // for debug passthrough
        ];
    }
}
