<?php
// Expects $tank (array) and $i (int, optional)
$id = $i ?? ($tank['f_tank_id'] ?? uniqid('tank_'));
$name = htmlspecialchars($tank['f_tank_name'] ?? 'Tank', ENT_QUOTES, 'UTF-8');
$status = $tank['status'] ?? 'normal'; // normalize to 'normal', 'reorder', 'low', etc.
$units = $tank['f_units_name'] ?? 'Gallons';
$current = (float)($tank['f_tank_present'] ?? 0);
$capacity = (float)($tank['f_tank_capacity'] ?? 0);
?>
<div class="tank-widget" data-tank-id="<?= $id ?>">
  <div class="tank-widget__dial" id="tank-dial-<?= $id ?>"></div>
  <div class="tank-widget__meta">
    <div class="tank-widget__name"><?= $name ?></div>
    <div class="tank-widget__status tank-widget__status--<?= strtolower($status) ?>">
      <?= ucfirst($status) ?>
    </div>
    <div class="tank-widget__numbers">
      <span class="tank-widget__current"><?= number_format($current, 1) ?></span>
      <span class="tank-widget__units"><?= htmlspecialchars($units, ENT_QUOTES, 'UTF-8') ?></span>
    </div>
    <div class="tank-widget__capacity">
      <?= number_format($capacity, 1) ?> <?= htmlspecialchars($units, ENT_QUOTES, 'UTF-8') ?>
    </div>
  </div>
</div>
