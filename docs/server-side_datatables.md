# Server-side DataTables in this project: How it works and how to replicate

This doc explains the current Users listing implementation (server-side DataTables with CodeIgniter 4.6 + MySQL 8.4), why it works, and how to build the same pattern for any other table.

Contents:
- Overview
- Request and response shape
- Controller responsibilities
- Model responsibilities
- View (DataTables) setup
- Debugging and environment gating
- Common pitfalls and fixes
- Performance tips
- Step-by-step: create a new Controller/API/Model/View for a different table
- Minimal templates

---

## Overview

- The table in the Admin UI uses DataTables with serverSide=true.
- The UI sends paging, ordering, and a global search term to an API endpoint.
- The API controller normalizes those request params and passes them to the model.
- The model builds a Query Builder SELECT with optional WHERE (search), ORDER BY (ordering), LIMIT/OFFSET (paging), and produces:
    - total (all rows in table, no filters)
    - filtered (rows matching current search only)
    - data (rows for the current page)
- Optional debug of the compiled SQL is available via query string and .env flag.

---

## Request and response shape

DataTables (client) sends a GET like:
- draw, start, length
- search[value], search[regex]
- order[0][column], order[0][dir]
- columns[i][data], columns[i][searchable], etc. (we only use order index)

API responds with JSON:
- draw: integer echo
- recordsTotal: total row count in table (no filters)
- recordsFiltered: count of rows after filters (search)
- data: array of arrays, each inner array matches the column order the table displays

Example response for search “Jim”:
- recordsTotal: 5
- recordsFiltered: 1
- data: only the “Jim” row

---

## Controller responsibilities

- Accept DataTables GET parameters.
- Normalize search so the model always sees it as $params['search']['value'].
- Normalize order payload (not strictly required but helpful).
- Invoke the model’s datatablesQuery($params).
- Gate “meta SQL” in the JSON by environment and a query flag.

Key details:
- We prefer GET for DataTables.
- Normalization handles both nested (search[value]) and flat forms.
- Meta SQL is only returned when ENVIRONMENT !== 'production' and debug_sql=1 is present.

Example (conceptual) snippet:

```php
// PHP (Controller)
public function index()
{
    $params = $this->request->getGet();

    // Normalize search
    $search = $this->request->getVar('search');
    if (is_array($search) && array_key_exists('value', $search)) {
        $params['search'] = ['value' => (string) $search['value']];
    } elseif (($flat = $this->request->getGet('search[value]')) !== null) {
        $params['search'] = ['value' => (string) $flat];
    }

    // Optional normalize order
    $order = $this->request->getVar('order');
    if (is_array($order)) {
        $params['order'] = $order;
    }

    $dt = $this->model->datatablesQuery($params);

    // Gate meta by environment + URL switch
    $allowDebug = (ENVIRONMENT !== 'production');
    $debugFlag  = (bool) ($this->request->getGet('debug_sql') ?? false);
    $debug      = $allowDebug && $debugFlag;

    $data = [
        'draw'            => (int) ($params['draw'] ?? 0),
        'recordsTotal'    => $dt['total'],
        'recordsFiltered' => $dt['filtered'],
        'data'            => array_map(static function (array $row) {
            return [
                $row['f_user_id'] ?? '',
                $row['f_first_name'] ?? '',
                $row['f_user_email'] ?? '',
                $row['f_last_name'] ?? '',
                $row['f_status'] ?? '',
                $row['f_created_at'] ?? '',
                $row['f_user_id'] ?? '',
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
```


---

## Model responsibilities

- Build the query with search, ordering, and pagination.
- Compute:
    - total = count of all rows in the table (must NOT reset the active builder).
    - filtered = count with WHERE (search), no ORDER BY, no LIMIT.
    - data = rows for the current page with ORDER BY + LIMIT.
- Escape LIKE search input to avoid wildcard troubles.
- Expose compiled SQL strings for optional debug.
- Optionally log compiled SQL lines controlled by an .env flag.

Important: Do NOT call Model::countAll() on the same model instance while building the query — it may reset the builder state. Instead, use a fresh builder for total.

Example responsibilities:

```php
// PHP (Model)
public const ORDERABLE   = ['f_user_id', 'f_first_name', 'f_user_email', 'f_last_name', 'f_status', 'f_created_at'];
public const SEARCHABLE  = ['f_first_name', 'f_user_email', 'f_last_name', 'f_status'];

public function datatablesQuery(array $params): array
{
    $builder = $this->builder();

    // 1) Search
    $searchValue = '';
    if (isset($params['search'])) {
        $searchValue = is_array($params['search'])
            ? (string) ($params['search']['value'] ?? '')
            : (string) $params['search'];
    } elseif (isset($params['search[value]'])) {
        $searchValue = (string) $params['search[value]'];
    }

    $searchValue = trim($searchValue);
    if ($searchValue !== '') {
        $escaped = $this->db->escapeLikeString($searchValue);
        $builder->groupStart();
        $first = true;
        foreach (self::SEARCHABLE as $col) {
            if ($first) {
                $builder->like($col, $escaped, 'both', null);
                $first = false;
            } else {
                $builder->orLike($col, $escaped, 'both', null);
            }
        }
        $builder->groupEnd();
    }

    // 2) Total count (fresh builder)
    $total = $this->db->table($this->table)->countAllResults();

    // 3) Filtered count (no ORDER/LIMIT)
    $countBuilder = clone $builder;
    $countBuilder->select('COUNT(*) as filtered_count');
    $compiledCountSql = $countBuilder->getCompiledSelect(false);
    $row = $countBuilder->get()->getRowArray();
    $filteredCount = isset($row['filtered_count']) ? (int) $row['filtered_count'] : 0;
    if ($searchValue === '') $filteredCount = $total;

    // 4) Ordering (only for data query)
    if (isset($params['order'][0]) && is_array($params['order'][0])) {
        $orderIndex = (int) ($params['order'][0]['column'] ?? 0);
        $dirRaw     = $params['order'][0]['dir'] ?? 'asc';
        $orderDir   = strtolower((string) $dirRaw) === 'desc' ? 'DESC' : 'ASC';
        $orderCol   = self::ORDERABLE[$orderIndex] ?? 'f_user_id';
        $builder->orderBy($orderCol, $orderDir);
    } else {
        $builder->orderBy('f_user_id', 'DESC');
    }

    // Snapshot of final data SQL before LIMIT
    $compiledDataSql = $builder->getCompiledSelect(false);

    // 5) Paging
    $length = (int) ($params['length'] ?? 10);
    $start  = (int) ($params['start'] ?? 0);
    if ($length > 0) {
        $builder->limit($length, $start);
    }

    $rows = $builder->get()->getResultArray();

    // Optional file logs controlled by .env
    if ((bool) (env('app.logDTSQL') ?? false)) {
        log_message('debug', 'DT compiled data SQL: {sql}', ['sql' => $compiledDataSql]);
        log_message('debug', 'DT compiled count SQL: {sql}', ['sql' => $compiledCountSql]);
    }

    return [
        'total'     => $total,
        'filtered'  => $filteredCount,
        'data'      => $rows,
        'sql_data'  => $compiledDataSql,  // for API meta debug only
        'sql_count' => $compiledCountSql, // for API meta debug only
    ];
}
```


Key notes:
- Starting with like() then orLike() avoids edge cases of “leading OR”.
- escapeLikeString() neutralizes user-supplied % or _ so they don’t break the match.
- Filtered count is taken before ORDER BY is applied to keep the count lean.
- ORDER BY is applied only to the data query.

---

## View (DataTables) setup

- Uses jQuery DataTables 2.x with serverSide: true.
- Columns are defined in the same order as the API returns them.
- DataTables expects the API to return data as array-of-arrays matching columns.
- A small helper builds the query string in “PHP-style” bracketed keys (search[value], order[0][column], etc).

Key options:
- processing: true
- serverSide: true
- order: [[0, 'desc']]
- columns: match API mapping
- ajax: custom function that constructs GET URL with all DataTables parameters

Example columns vs API mapping:
- Index 0: ID
- Index 1: Name (f_first_name)
- Index 2: Email (f_user_email)
- Index 3: Role or Last Name (ensure consistent with API mapping)
- Index 4: Status
- Index 5: Created
- Index 6: Actions (non-searchable, non-orderable)

---

## Debugging and environment gating

- Return compiled SQL in responses by appending ?debug_sql=1 — but only when ENVIRONMENT !== 'production'.
- Log compiled SQL lines to files by setting in .env:
    - app.logDTSQL = true
- Logging uses debug level. Ensure your Logger threshold allows debug (default is fine for non-production).

Why logs may not appear:
- If threshold is set too high in production, debug-level logs won’t be written.
- With the new env flag, you can independently control whether to write the SQL lines.

---

## Common pitfalls and fixes

- Builder resets: Calling Model::countAll() (or similar) mid-build can reset the active builder. Always use a fresh builder for total.
- Search shape: DataTables may provide search[value] nested or flat; normalize to ['search' => ['value' => '...']].
- Case-insensitivity: MySQL’s default collations (e.g., utf8mb4_0900_ai_ci) are case-insensitive, so LIKE already matches “jim” vs “Jim”. If you swap to a case-sensitive collation, adjust accordingly (e.g., LOWER(column) LIKE LOWER(:term:)).
- Start with like() then orLike() to avoid "all rows" edge cases on some drivers.
- Count efficiency: Don’t include ORDER BY in the count; it is unnecessary overhead.

---

## Performance tips

- Index searchable columns: add indexes on columns in SEARCHABLE for large tables (e.g., f_first_name, f_last_name, f_user_email, f_status).
- Narrow SELECT: In large schemas, select only the columns you actually display.
- Limit lengths: reasonable length menu (10/25/50/100) helps reduce load.

---

## Step-by-step: Create a new Controller/API/Model/View for another table

1) Model
- Create YourEntityModel extending Model.
- Set $table, $primaryKey, $returnType, $allowedFields (as needed).
- Add constants ORDERABLE and SEARCHABLE to control DataTables behavior.
- Implement datatablesQuery(array $params): array using the same pattern as above.

2) API Controller
- Create YourEntitiesApiController with an index() method:
    - Read GET params.
    - Normalize search and order.
    - Call $model->datatablesQuery($params).
    - Map rows to array-of-arrays matching your View’s columns.
    - Gate meta SQL by ENVIRONMENT and debug_sql=1.

3) View
- Add a page with a table and DataTables init:
    - serverSide: true, processing: true
    - columns: define correct order and titles
    - ajax: build request URL with all DataTables parameters
    - Ensure the mapping between displayed columns and API row array is consistent.

4) Routes
- Add routes for the new API endpoint and the new Admin page if needed.

5) Test
- Verify search, ordering, paging.
- Try ?debug_sql=1 in non-production to see compiled SQL.
- Turn on .env flag app.logDTSQL=true to write SQL to logs.

---

## Minimal templates you can copy

Model skeleton:

```php
// PHP
class YourEntityModel extends \CodeIgniter\Model
{
    protected $table      = 'your_table';
    protected $primaryKey = 'id';
    protected $returnType = 'array';

    public const ORDERABLE  = ['id', 'col_a', 'col_b', 'created_at'];
    public const SEARCHABLE = ['col_a', 'col_b'];

    public function datatablesQuery(array $params): array
    {
        $builder = $this->builder();

        // Search
        $sv = '';
        if (isset($params['search'])) {
            $sv = is_array($params['search']) ? (string) ($params['search']['value'] ?? '') : (string) $params['search'];
        } elseif (isset($params['search[value]'])) {
            $sv = (string) $params['search[value]'];
        }
        $sv = trim($sv);
        if ($sv !== '') {
            $esc = $this->db->escapeLikeString($sv);
            $builder->groupStart();
            $first = true;
            foreach (self::SEARCHABLE as $col) {
                if ($first) { $builder->like($col, $esc, 'both', null); $first = false; }
                else { $builder->orLike($col, $esc, 'both', null); }
            }
            $builder->groupEnd();
        }

        // Total
        $total = $this->db->table($this->table)->countAllResults();

        // Filtered count
        $countBuilder = clone $builder;
        $countBuilder->select('COUNT(*) as filtered_count');
        $compiledCountSql = $countBuilder->getCompiledSelect(false);
        $row = $countBuilder->get()->getRowArray();
        $filtered = (int) ($row['filtered_count'] ?? 0);
        if ($sv === '') $filtered = $total;

        // Ordering
        if (isset($params['order'][0])) {
            $idx   = (int) ($params['order'][0]['column'] ?? 0);
            $dir   = strtolower((string) ($params['order'][0]['dir'] ?? 'asc')) === 'desc' ? 'DESC' : 'ASC';
            $col   = self::ORDERABLE[$idx] ?? 'id';
            $builder->orderBy($col, $dir);
        } else {
            $builder->orderBy('id', 'DESC');
        }

        // Snapshot data SQL
        $compiledDataSql = $builder->getCompiledSelect(false);

        // Paging
        $length = (int) ($params['length'] ?? 10);
        $start  = (int) ($params['start'] ?? 0);
        if ($length > 0) $builder->limit($length, $start);

        $data = $builder->get()->getResultArray();

        if ((bool) (env('app.logDTSQL') ?? false)) {
            log_message('debug', 'DT compiled data SQL: {sql}', ['sql' => $compiledDataSql]);
            log_message('debug', 'DT compiled count SQL: {sql}', ['sql' => $compiledCountSql]);
        }

        return [
            'total'     => $total,
            'filtered'  => $filtered,
            'data'      => $data,
            'sql_data'  => $compiledDataSql,
            'sql_count' => $compiledCountSql,
        ];
    }
}
```


API controller skeleton:

```php
// PHP
class YourEntitiesApiController extends \App\Controllers\BaseController
{
    protected YourEntityModel $model;

    public function __construct()
    {
        $this->model = new YourEntityModel();
    }

    public function index()
    {
        $params = $this->request->getGet();

        $search = $this->request->getVar('search');
        if (is_array($search) && array_key_exists('value', $search)) {
            $params['search'] = ['value' => (string) $search['value']];
        } elseif (($flat = $this->request->getGet('search[value]')) !== null) {
            $params['search'] = ['value' => (string) $flat];
        }

        $order = $this->request->getVar('order');
        if (is_array($order)) $params['order'] = $order;

        $dt = $this->model->datatablesQuery($params);

        $allowDebug = (ENVIRONMENT !== 'production');
        $debug = $allowDebug && (bool) ($this->request->getGet('debug_sql') ?? false);

        $data = [
            'draw'            => (int) ($params['draw'] ?? 0),
            'recordsTotal'    => $dt['total'],
            'recordsFiltered' => $dt['filtered'],
            'data'            => array_map(static function (array $row) {
                // Adjust mapping to your columns order
                return [
                    $row['id'] ?? '',
                    $row['col_a'] ?? '',
                    $row['col_b'] ?? '',
                    $row['created_at'] ?? '',
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
}
```


View skeleton (DataTables init):

```html
<!-- HTML -->
<table id="entitiesTable" class="table table-striped w-100">
  <thead>
    <tr>
      <th>ID</th>
      <th>Column A</th>
      <th>Column B</th>
      <th>Created</th>
      <th>Actions</th>
    </tr>
  </thead>
</table>
```


```javascript
// JavaScript
$(function () {
  const apiBase = '/api/v1/your-entities';

  function appendParam(params, key, value) {
    if (value === null || value === undefined) return;
    if (Array.isArray(value)) {
      value.forEach((v, i) => appendParam(params, `${key}[${i}]`, v));
    } else if (typeof value === 'object') {
      Object.keys(value).forEach(k => appendParam(params, `${key}[${k}]`, value[k]));
    } else {
      params.append(key, String(value));
    }
  }

  function toQuery(dtParams) {
    const p = new URLSearchParams();
    appendParam(p, 'draw', dtParams.draw);
    appendParam(p, 'start', dtParams.start);
    appendParam(p, 'length', dtParams.length);
    if (dtParams.search) {
      appendParam(p, 'search[value]', dtParams.search.value);
      appendParam(p, 'search[regex]', dtParams.search.regex);
    }
    if (Array.isArray(dtParams.order)) {
      dtParams.order.forEach((o, i) => {
        appendParam(p, `order[${i}][column]`, o.column);
        appendParam(p, `order[${i}][dir]`, o.dir);
      });
    }
    if (Array.isArray(dtParams.columns)) {
      dtParams.columns.forEach((c, i) => {
        appendParam(p, `columns[${i}][data]`, c.data);
        appendParam(p, `columns[${i}][searchable]`, c.searchable);
        appendParam(p, `columns[${i}][orderable]`, c.orderable);
        if (c.search) {
          appendParam(p, `columns[${i}][search][value]`, c.search.value);
          appendParam(p, `columns[${i}][search][regex]`, c.search.regex);
        }
      });
    }
    return p.toString();
  }

  $('#entitiesTable').DataTable({
    processing: true,
    serverSide: true,
    order: [[0, 'desc']],
    columns: [
      { title: 'ID' },
      { title: 'Column A' },
      { title: 'Column B' },
      { title: 'Created' },
      { title: 'Actions', orderable: false, searchable: false }
    ],
    ajax: (dtParams, callback) => {
      const url = apiBase + '?' + toQuery(dtParams);
      fetch(url, { headers: { 'X-Requested-With': 'XMLHttpRequest' } })
        .then(r => { if (!r.ok) throw new Error('HTTP ' + r.status); return r.json(); })
        .then(json => callback(json))
        .catch(err => {
          console.error('DataTables AJAX error:', err);
          callback({ draw: dtParams.draw || 0, recordsTotal: 0, recordsFiltered: 0, data: [] });
        });
    }
  });
});
```


---

## Final checklist

- Model
    - ORDERABLE/SEARCHABLE arrays reflect actual DB columns.
    - datatablesQuery implements search, filtered count, order, paging.
    - Total uses a fresh builder.
    - Optional SQL logging controlled by app.logDTSQL (in .env).

- Controller
    - Normalizes search and order.
    - Maps database rows to the view’s column order.
    - Meta SQL is returned only when ENVIRONMENT !== 'production' and debug_sql=1 is present.

- View
    - columns array matches the API’s returned data order.
    - ajax builds the request with bracketed keys.

- DB
    - Add indexes on SEARCHABLE columns for large datasets.

With this pattern, you can spin up a new table listing with server-side search/sort/paging quickly and predictably. If you need a hand applying it to a specific table, tell me the target columns and I’ll draft the exact Model/Controller/View snippets.