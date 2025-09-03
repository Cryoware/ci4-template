<?php
// Adjust layout and section names if your project differs
echo $this->extend('layouts/adminlte');

echo $this->section('head'); ?>
    <script defer src="/vendor/jquery/jquery.min.js"></script>
    <script defer src="/vendor/datatables.net/js/dataTables.min.js"></script>
<?php echo $this->endSection();

echo $this->section('content'); ?>
<div class="card">
  <div class="card-body">
    <table id="usersTable" class="table table-striped table-bordered w-100">
      <thead>
        <tr>
          <th>ID</th>
          <th>Name</th>
          <th>Email</th>
          <th>Role</th>
          <th>Status</th>
          <th>Created</th>
          <th>Actions</th>
        </tr>
      </thead>
    </table>
  </div>
</div>

<!-- Modal for Create/Edit -->
<div class="modal fade" id="userModal" tabindex="-1" aria-labelledby="userModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <form id="userForm" class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="userModalLabel">Create User</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <input type="hidden" id="userId" name="id" />
        <div class="mb-3">
          <label class="form-label">Name</label>
          <input type="text" class="form-control" id="name" name="name" required />
        </div>
        <div class="mb-3">
          <label class="form-label">Email</label>
          <input type="email" class="form-control" id="email" name="email" required />
        </div>
        <div class="mb-3">
          <label class="form-label">Role</label>
          <input type="text" class="form-control" id="role" name="role" />
        </div>
        <div class="mb-3">
          <label class="form-label">Status</label>
          <select class="form-select" id="status" name="status">
            <option value="active">Active</option>
            <option value="inactive">Inactive</option>
            <option value="banned">Banned</option>
          </select>
        </div>
        <div id="formErrors" class="alert alert-danger d-none"></div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
        <button type="submit" class="btn btn-primary">Save</button>
      </div>
    </form>
  </div>
</div>
<?php echo $this->endSection();

echo $this->section('js'); ?>
<script>
  // Run after deferred scripts are executed
  document.addEventListener('DOMContentLoaded', function () {
    const apiBase = '/api/v1/users';
    const tableEl = document.getElementById('usersTable');

    function renderActions(id) {
      return `
        <div class="btn-group btn-group-sm" role="group">
          <button class="btn btn-outline-primary btn-edit" data-id="${id}"><i class="fas fa-edit"></i></button>
          <button class="btn btn-outline-danger btn-delete" data-id="${id}"><i class="fas fa-trash"></i></button>
        </div>
      `;
    }

    // Serialize nested DataTables params to PHP-style bracket notation
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
      const params = new URLSearchParams();
      // Map DataTables core v2 -> expected PHP keys
      appendParam(params, 'draw', dtParams.draw);
      appendParam(params, 'start', dtParams.start);
      appendParam(params, 'length', dtParams.length);
      if (dtParams.search) {
        appendParam(params, 'search[value]', dtParams.search.value);
        appendParam(params, 'search[regex]', dtParams.search.regex);
      }
      if (Array.isArray(dtParams.order)) {
        dtParams.order.forEach((o, i) => {
          appendParam(params, `order[${i}][column]`, o.column);
          appendParam(params, `order[${i}][dir]`, o.dir);
        });
      }
      if (Array.isArray(dtParams.columns)) {
        dtParams.columns.forEach((c, i) => {
          appendParam(params, `columns[${i}][data]`, c.data);
          appendParam(params, `columns[${i}][name]`, c.name);
          appendParam(params, `columns[${i}][searchable]`, c.searchable);
          appendParam(params, `columns[${i}][orderable]`, c.orderable);
          if (c.search) {
            appendParam(params, `columns[${i}][search][value]`, c.search.value);
            appendParam(params, `columns[${i}][search][regex]`, c.search.regex);
          }
        });
      }
      return params.toString();
    }

    // Initialize DataTables (jQuery build)
    const table = $('#usersTable').DataTable({
      processing: true,
      serverSide: true,
      order: [[0, 'desc']],
      columns: [
        { title: 'ID' },
        { title: 'Name' },
        { title: 'Email' },
        { title: 'Role' },
        { title: 'Status' },
        { title: 'Created' },
        {
          title: 'Actions',
          orderable: false,
          searchable: false,
          render: (data, type, row) => {
            const id = row?.[0];
            return id ? renderActions(id) : '';
          }
        },
      ],
      ajax: (dtParams, callback) => {
        const url = apiBase + '?' + toQuery(dtParams);
        fetch(url, {
          method: 'GET',
          headers: {
            'X-Requested-With': 'XMLHttpRequest'
          }
        })
        .then(res => {
          if (!res.ok) throw new Error('HTTP ' + res.status);
          return res.json();
        })
        .then(json => callback(json))
        .catch(err => {
          console.error('DataTables AJAX error:', err);
          alert('Users table error: ' + err.message);
          // Provide empty fallback so table doesn’t hang
          callback({ draw: dtParams.draw || 0, recordsTotal: 0, recordsFiltered: 0, data: [] });
        });
      },
      lengthMenu: [10, 25, 50, 100],
    });

    // New
    document.getElementById('btnCreate').addEventListener('click', () => {
      document.getElementById('userModalLabel').textContent = 'Create User';
      document.getElementById('userId').value = '';
      document.getElementById('userForm').reset();
      const errBox = document.getElementById('formErrors');
      errBox.classList.add('d-none');
      errBox.innerHTML = '';
      new bootstrap.Modal(document.getElementById('userModal')).show();
    });

    // Delegated actions (Edit/Delete)
    tableEl.addEventListener('click', (e) => {
      const editBtn = e.target.closest('.btn-edit');
      const delBtn  = e.target.closest('.btn-delete');

      if (editBtn) {
        const id = editBtn.getAttribute('data-id');
        fetch(`${apiBase}/${id}`, { headers: { 'X-Requested-With': 'XMLHttpRequest' } })
          .then(res => {
            if (!res.ok) throw new Error('HTTP ' + res.status);
            return res.json();
          })
          .then(user => {
            document.getElementById('userModalLabel').textContent = 'Edit User';
            document.getElementById('userId').value = user.id ?? '';
            document.getElementById('name').value = user.name ?? '';
            document.getElementById('email').value = user.email ?? '';
            document.getElementById('role').value = user.role ?? '';
            document.getElementById('status').value = user.status ?? 'active';
            const errBox = document.getElementById('formErrors');
            errBox.classList.add('d-none');
            errBox.innerHTML = '';
            new bootstrap.Modal(document.getElementById('userModal')).show();
          })
          .catch(err => alert('Failed to fetch user: ' + err.message));
      }

      if (delBtn) {
        const id = delBtn.getAttribute('data-id');
        if (!confirm('Delete this user?')) return;
        fetch(`${apiBase}/${id}`, {
          method: 'DELETE',
          headers: { 'X-Requested-With': 'XMLHttpRequest' }
        })
        .then(res => {
          if (!res.ok) throw new Error('HTTP ' + res.status);
        })
        .then(() => table.ajax.reload())
        .catch(err => alert('Failed to delete: ' + err.message));
      }
    });

    // Submit Create/Update
    document.getElementById('userForm').addEventListener('submit', function (e) {
      e.preventDefault();
      const id = document.getElementById('userId').value;
      const payload = {
        name: document.getElementById('name').value,
        email: document.getElementById('email').value,
        role: document.getElementById('role').value,
        status: document.getElementById('status').value,
      };
      const method = id ? 'PUT' : 'POST';
      const url = id ? `${apiBase}/${id}` : apiBase;

      fetch(url, {
        method,
        headers: {
          'Content-Type': 'application/json',
          'X-Requested-With': 'XMLHttpRequest'
        },
        body: JSON.stringify(payload)
      })
      .then(async res => {
        if (!res.ok) {
          const json = await res.json().catch(() => ({}));
          const errBox = document.getElementById('formErrors');
          const errors = json.errors || { error: json.error || `HTTP ${res.status}` };
          errBox.classList.remove('d-none');
          errBox.innerHTML = Object.keys(errors).map(k => `<div>${k}: ${errors[k]}</div>`).join('');
          throw new Error('Validation or server error');
        }
      })
      .then(() => {
        bootstrap.Modal.getInstance(document.getElementById('userModal')).hide();
        table.ajax.reload();
      })
      .catch(() => {});
    });
  });
</script>
<?php echo $this->endSection();
