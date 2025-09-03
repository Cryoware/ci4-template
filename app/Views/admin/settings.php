<?= $this->extend('layouts/adminlte') ?>

<?= $this->section('content') ?>
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header"><h3 class="card-title">Application Settings</h3></div>
                <div class="card-body">
                    <?php if (session()->getFlashdata('message')): ?>
                        <p class="text-success"><?= esc(session()->getFlashdata('message')) ?></p>
                    <?php endif; ?>

                    <form id="settingsForm" method="post" action="<?= site_url('/admin/settings/save') ?>">
                        <?= csrf_field() ?>

                        <div class="mb-3">
                            <label class="form-label">Site Name</label>
                            <input type="text" class="form-control" name="site_name" value="<?= esc($settings['site_name'] ?? '') ?>">
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Max Login Attempts</label>
                            <input type="number" class="form-control" name="max_login_attempts" value="<?= esc($settings['max_login_attempts'] ?? 5) ?>">
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Maintenance Mode</label>
                            <select class="form-select" name="maintenance_mode">
                                <option value="0" <?= (isset($settings['maintenance_mode']) && !$settings['maintenance_mode']) ? 'selected' : '' ?>>Disabled</option>
                                <option value="1" <?= (!empty($settings['maintenance_mode'])) ? 'selected' : '' ?>>Enabled</option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Allowed IPs (comma separated)</label>
                            <input type="text" class="form-control" name="allowed_ips" value="<?= esc(implode(',', $settings['allowed_ips'] ?? [])) ?>">
                        </div>

                        <button type="submit" class="btn btn-primary">Save Settings</button>
                    </form>
                </div>
                <div class="card-footer">Footer</div>
            </div>
        </div>
    </div>
<?= $this->endSection() ?>
