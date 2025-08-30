<!DOCTYPE html>
<html>
<head>
    <title>Settings</title>
</head>
<body>
<h1>Application Settings</h1>

<?php if (session()->getFlashdata('message')): ?>
    <p style="color:green;"><?= esc(session()->getFlashdata('message')) ?></p>
<?php endif; ?>

<form method="post" action="<?= site_url('/admin/settings/save') ?>">
    <?= csrf_field() ?>

    <label>Site Name:</label><br>
    <input type="text" name="site_name" value="<?= esc($settings['site_name'] ?? '') ?>"><br><br>

    <label>Max Login Attempts:</label><br>
    <input type="number" name="max_login_attempts" value="<?= esc($settings['max_login_attempts'] ?? 5) ?>"><br><br>

    <label>Maintenance Mode:</label><br>
    <select name="maintenance_mode">
        <option value="0" <?= (isset($settings['maintenance_mode']) && !$settings['maintenance_mode']) ? 'selected' : '' ?>>Disabled</option>
        <option value="1" <?= (!empty($settings['maintenance_mode'])) ? 'selected' : '' ?>>Enabled</option>
    </select><br><br>

    <label>Allowed IPs (comma separated):</label><br>
    <input type="text" name="allowed_ips"
           value="<?= esc(implode(',', $settings['allowed_ips'] ?? [])) ?>"><br><br>

    <button type="submit">Save Settings</button>
</form>
</body>
</html>
