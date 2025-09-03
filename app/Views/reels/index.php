<?php
/** @var string $locale */
/** @var string $dashboard */
/** @var int $roleId */
/** @var array $capabilities */
/** @var int $stationId */
/** @var array $reels */
?>
<table id="myTable1"
       class="myTable tablesorter scrollableFixedHeaderTable"
       data-locale="<?= esc($locale) ?>"
       style="border-color: gray;width:100% !important">
    <thead>
        <tr style="background-color:#555;">
            <th style="vertical-align: middle;text-align:left;width:16.7% !important;"><?= esc(lang('Lang.reels')) ?><span class="header"></span></th>
            <th style="vertical-align: middle;text-align:left;width:20% !important;"><?= esc(lang('Lang.product')) ?><span class="header"></span></th>
            <th style="vertical-align: middle;text-align:left;width:16.5% !important;"><?= esc(lang('Lang.units')) ?><span class="header"></span></th>
            <th style="vertical-align: middle;text-align:left;width:15% !important;"><?= esc(lang('Lang.PSM') ?? 'PSM') . '#' ?><span class="header"></span></th>
            <th style="vertical-align: middle;text-align:left;width:15% !important;"><?= esc(lang('Lang.status')) ?><span class="header"></span></th>
            <th style="vertical-align: middle;text-align:left;width:10% !important;">&nbsp;</th>
        </tr>
    </thead>
    <tbody>
    <?php if (! empty($reels)): ?>
        <?php foreach ($reels as $reel): ?>
            <tr class="reel_default" id="reel_<?= (int) $reel['f_reel_id'] ?>">
                <td style="width:16.7% !important;">
                    <?php if ($dashboard === 'manager'): ?>
                        <div onclick="window.location='<?= localized_site_url('admin/workorder/manager_load_workorder/' . urlencode((string) ($reel['f_tank_product_id'] ?? '')) . '/' . (int) $reel['f_reel_id']) ?>'" style="cursor:pointer">
                            <?= esc($reel['f_reel_name'] ?? '') ?>
                        </div>
                    <?php else: ?>
                        <?= esc($reel['f_reel_name'] ?? '') ?>
                    <?php endif; ?>
                </td>
                <td style="width:20% !important;"><?= esc($reel['f_product_name'] ?? '') ?></td>
                <td style="width:16.5% !important;">
                    <?php
                        $unitName   = (string) ($reel['f_units_name'] ?? '');
                        $translated = lang('Lang.' . $unitName);
                        echo esc($translated === 'Lang.' . $unitName ? $unitName : $translated);
                    ?>
                </td>
                <td style="width:15% !important;"><?= esc($reel['f_serial_number'] ?? '') ?></td>
                <td style="width:15% !important;">
                    <?php if (! empty($reel['f_reel_status'])): ?>
                        <div class="switch-green"><?= esc(lang('Lang.on')) ?></div>
                    <?php else: ?>
                        <div class="switch-red"><?= esc(lang('Lang.off')) ?></div>
                    <?php endif; ?>
                </td>
                <?php if ((int) $roleId !== 3): ?>
                    <td style="width:10% !important;">
                        <?php if ((int) $roleId === 1): ?>
                            <a href="<?= localized_site_url('admin/station/reel_station_configuration/' . (int) $reel['f_station_id']) ?>">
                                <button class="bttn bttn-green"><?= esc(lang('Lang.edit') ?? 'Edit') ?></button>
                            </a>
                        <?php elseif ((int) $roleId === 2 && in_array(6, $capabilities, true)): ?>
                            <a class="fancybox" href="<?= localized_site_url('admin/station/reel_manage_station/' . (int) $reel['f_station_id'] . '/' . (int) $reel['f_reel_id']) ?>">
                                <button class="bttn bttn-green"><?= esc(lang('Lang.edit') ?? 'Edit') ?></button>
                            </a>
                        <?php endif; ?>
                    </td>
                <?php endif; ?>
            </tr>
        <?php endforeach; ?>
    <?php endif; ?>
    </tbody>
</table>

<script>
(function() {
    var locale = document.getElementById('myTable1')?.getAttribute('data-locale') || 'en';

    if (window.moment && moment.locale) {
        moment.locale(locale);
    }
    if (window.jsGrid && window.jsGrid.locale && window.jsGrid.locales) {
        if (window.jsGrid.locales[locale]) {
            jsGrid.locale(locale);
        }
    }
})();
</script>
