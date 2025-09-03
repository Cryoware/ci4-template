<?php
/**
 * Tank Details View (CI4)
 *
 * Renders a list of tank gauges and quick stats with localized labels.
 * The negotiated locale is exposed to frontend libraries (Moment.js, jsGrid).
 *
 * @var array<int, array<string, mixed>> $tanks      Array of tank rows (associative arrays).
 * @var string                           $role       Current role (e.g., 'tech'); influences UI rendering.
 * @var string                           $page       Base URL for tank detail links.
 * @var int|null                         $limit      Optional limit applied by controller/model; controls "Show More" link.
 * @var int                              $totalCount Total number of tanks; used for pagination hint.
 * @var string                           $locale     Negotiated locale, from request->getLocale().
 * @var string|null                      $PageTitle  Optional page title.
 *
 * Notes:
 * - Use lang('Lang.key') for UI strings (CI4 loads app/Language/{locale}/Lang.php).
 * - Always escape dynamic output using esc().
 * - window.APP_LOCALE is set for frontend libraries to read.
 */
?>
<!DOCTYPE html>
<html lang="<?= esc($locale) ?>">
<head>
    <meta charset="utf-8">
    <title><?= esc($PageTitle ?? 'OilCop') ?></title>

    <script>
        /**
         * Globally expose the negotiated locale so frontend libraries (Moment.js, jsGrid)
         * can initialize themselves accordingly.
         * Example (elsewhere):
         *   moment.locale(window.APP_LOCALE);
         */
        window.APP_LOCALE = "<?= esc($locale) ?>";
    </script>

    <!-- Include your CSS/JS as needed (e.g., JustGage, dependencies, and base styles) -->
</head>
<body>

<!-- Container for tank list and gauges -->
<div id="tank_box">
    <?php if (! empty($tanks)): ?>
        <?php
        /**
         * $i is used to create unique IDs for each gauge element.
         * This avoids collisions in the DOM and allows per-gauge scripts.
         */
        $i = 1;
        ?>

        <?php foreach ($tanks as $tank): ?>
            <?php
                // Source fields (defensively cast/initialize)
                $unitsName   = $tank['f_units_name']            ?? '';
                $unitsFirst  = substr($unitsName, 0, 1);

                $volume      = (float) ($tank['f_tank_volume']  ?? 0);
                $capacity    = (float) ($tank['f_tank_capacity']?? 0);
                $highLevel   = (float) ($tank['f_tank_high_level']  ?? 0);
                $highAlarm   = (float) ($tank['f_tank_high_alarm']  ?? 0);
                $reorder     = (float) ($tank['f_tank_reorder_level'] ?? 0);
                $shutoff     = (float) ($tank['f_tank_shutoff_level'] ?? 0);
                $collection  = (int)   ($tank['f_collection'] ?? 0);
                $sensorStat  = $tank['SensorStatus'] ?? null;

                $monitorYes  = (($tank['f_tank_monitor_installed'] ?? '') === 'yes');
                $volType     = $tank['f_tank_volume_type'] ?? '';
                $currentH    = (float) ($tank['f_current_height'] ?? 0.0);

                // Ullage is the delta from High Level to current volume; clamp to 0 when above high level
                $ullage = $volume < $highLevel ? ($highLevel - $volume) : 0.0;

                // Alert thresholds can be interpreted in 'volume' units or 'percentage' of capacity
                $alertMode = $tank['f_alert_conditions'] ?? 'volume';
                $uSymbol   = '';
                $hiWarn    = 0.0;
                $hiShut    = 0.0;
                $reordLvl  = 0.0;
                $lowShut   = 0.0;

                if ($alertMode === 'volume') {
                    // When using volume, display the first letter of units (e.g., G / L / Q / P)
                    $uSymbol  = substr($unitsName, 0, 1);
                    $hiWarn   = $highLevel ?: 0.0;
                    $hiShut   = $highAlarm ?: 0.0;
                    $reordLvl = $reorder ?: 0.0;
                    $lowShut  = $shutoff ?: 0.0;
                } else {
                    // Percentage mode; compute thresholds relative to capacity
                    $uSymbol = '%';
                    if ($capacity > 0) {
                        $hiWarn   = $highLevel   ? ($highLevel   / $capacity) * 100 : 0.0;
                        $hiShut   = $highAlarm   ? ($highAlarm   / $capacity) * 100 : 0.0;
                        $reordLvl = $reorder     ? ($reorder     / $capacity) * 100 : 0.0;
                        $lowShut  = $shutoff     ? ($shutoff     / $capacity) * 100 : 0.0;
                    }
                }

                // Current height (if monitor installed), in inches or centimeters
                $currentHeightStr = '';
                if ($monitorYes) {
                    $mea = $volType === 'centi' ? 'cm' : ($volType === 'inches' ? 'in' : '');
                    $currentHeightStr = $mea ? ' "' . round($currentH, 2) . ' ' . $mea . '"': '';
                }

                // Title logic: prefer product name, optionally suffix with [exe] or line-break with tank name
                $tankName    = $tank['f_tank_name'] ?? '';
                $productName = $tank['f_product_name'] ?? '';
                $productExe  = (int) ($tank['f_tank_product_exe'] ?? 1);
                if ($tankName === $productName) {
                    $titleName = $productExe > 1 ? ($productName . '[' . $productExe . ']') : $productName;
                } else {
                    $titleName = $productName . "\n" . $tankName;
                }

                // Determine gauge state label/color by comparing volume against thresholds
                $stateText  = '';
                $stateColor = '#333';
                if ($collection === 1) {
                    $stateText  = lang('Lang.normal');
                    $stateColor = '#67c749';
                } elseif ($volume <= $shutoff) {
                    $stateText  = lang('Lang.lowlevel_shutoff');
                    $stateColor = '#cc0000';
                } elseif ($shutoff < $volume && $volume <= $reorder) {
                    $stateText  = lang('Lang.reorder_level');
                    $stateColor = '#ffaa00';
                } elseif ($reorder < $volume && $volume < $highAlarm) {
                    $stateText  = lang('Lang.normal');
                    $stateColor = '#67c749';
                } elseif ($highAlarm <= $volume && $volume < $highLevel) {
                    $stateText  = lang('Lang.highlevel_warning');
                    $stateColor = '#6E0093';
                } elseif ($highLevel != 0.0 && $highLevel <= $volume) {
                    $stateText  = lang('Lang.highlevel_shutoff');
                    $stateColor = '#ff0000';
                }

                // Units label: attempt localization, fallback to raw unit name
                $unitsLabel = lang('Lang.' . $unitsName);
                if ($unitsLabel === 'Lang.' . $unitsName) {
                    $unitsLabel = $unitsName;
                }

                // Gauge numeric values
                $gaugeValue = ($capacity > 0.0) ? round($volume, 1) : 0.0;
                $gaugeMax   = $capacity ?: 0.0;

                // Destination URL when not in 'tech' role
                $href = ($page ?? '') . ($tank['f_tank_id'] ?? '');
            ?>

            <?php if (($role ?? '') !== 'tech'): ?>
                <!-- Clickable card: tank summary + gauge -->
                <a target="_blank" href="<?= esc($href) ?>" id="tooltip">
                    <div class="tank_img" id="g<?= $i ?>"></div>
                    <span>
                        <strong><?= lang('Lang.product') ?>- </strong>
                        <?php if (($tank['f_tank_product_exe'] ?? 1) > 1): ?>
                            <?= esc($productName) ?>[<?= (int) $productExe ?>]
                        <?php else: ?>
                            <?= esc($productName) ?>
                        <?php endif; ?>
                        <br>

                        <strong><?= lang('Lang.capacity') ?>- </strong>
                        <?= esc((float) $capacity) . esc($unitsFirst) ?><br>

                        <strong><?= lang('Lang.contents') ?>- </strong>
                        <?= esc(round($volume, 1)) . esc($unitsFirst) . esc($currentHeightStr) ?><br>

                        <strong><?= lang('Lang.ullage') ?>- </strong>
                        <?= esc(round($ullage, 1)) ?><br>

                        <!-- Note: Labels intentionally follow original naming mapping -->
                        <strong><?= lang('Lang.highlevel_shutoff') ?>- </strong>
                        <?= esc(number_format($hiWarn, 1)) . esc($uSymbol) ?><br>

                        <strong><?= lang('Lang.highlevel_warning') ?>- </strong>
                        <?= esc(number_format($hiShut, 1)) . esc($uSymbol) ?><br>

                        <strong><?= lang('Lang.reorder_level') ?>- </strong>
                        <?= esc(number_format($reordLvl, 1)) . esc($uSymbol) ?><br>

                        <strong><?= lang('Lang.lowlevel_shutoff') ?>- </strong>
                        <?= esc(number_format($lowShut, 1)) . esc($uSymbol) ?><br>
                    </span>
                </a>
            <?php else: ?>
                <!-- Read-only gauge panel for tech role -->
                <div class="gauge_panel" style="position:relative;" id="g<?= $i ?>"></div>
            <?php endif; ?>

            <!-- Per-gauge initialization script.
                 Scope in IIFE to avoid leaking local PHP values into global JS across iterations. -->
            <script>
                (function() {
                    var id = "g<?= $i ?>";

                    // Initialize JustGage for this tank
                    var gauge = new JustGage({
                        id: id,
                        value: <?= json_encode($gaugeValue) ?>,
                        valueFontColor: 'rgb(0, 123, 255)',
                        min: 0,
                        max: <?= json_encode($gaugeMax) ?>,
                        symbol: "%",
                        startAnimationTime: 1,
                        titleFontColor: 'rgb(0, 123, 255)',
                        title: <?= json_encode($titleName) ?>,
                        label: <?= json_encode($unitsLabel) ?>,
                        levelColors: [<?= json_encode($stateColor) ?>]
                    });

                    // Append state text unless sensor is explicitly invalid (0)
                    <?php if (!($sensorStat !== null && (int)$sensorStat === 0)): ?>
                        document.getElementById(id).insertAdjacentHTML(
                            'beforeend',
                            '<div class="blink<?= $i ?> Normal"><?= esc($stateText) ?></div>'
                        );
                    <?php else: ?>
                        document.getElementById(id).insertAdjacentHTML(
                            'beforeend',
                            '<div class="blink<?= $i ?> Invalid append_volume">Invalid</div>'
                        );
                        // Simple blink/fade hint for invalid state
                        setTimeout(function() {
                            var el = document.querySelector('#' + id + ' div.Invalid');
                            if (el) {
                                el.style.opacity = 0.2;
                                setTimeout(function(){ el.style.opacity = 1; }, 300);
                            }
                        }, 300);
                    <?php endif; ?>

                    // Blink attention when outside normal range and not invalid/collection mode
                    <?php if (!($reorder < $volume && $volume < $highAlarm) && $collection !== 1 && !($sensorStat !== null && (int)$sensorStat === 0)): ?>
                        setInterval(function() {
                            var el = document.querySelector('.blink<?= $i ?>');
                            if (!el) return;
                            el.style.visibility = (el.style.visibility === 'hidden') ? 'visible' : 'hidden';
                        }, 500);
                    <?php endif; ?>
                })();
            </script>

            <!-- One-time color assignment matching server-side state logic.
                 Keeps CSS decoupled from server-side conditions. -->
            <script>
                (function() {
                    var el = document.querySelector(".blink<?= $i ?>");
                    if (!el) return;
                    <?php if ($collection === 1): ?>
                        el.style.color = '#67c749';
                    <?php elseif ($volume <= $shutoff): ?>
                        el.style.color = '#cc0000';
                    <?php elseif ($shutoff < $volume && $volume <= $reorder): ?>
                        el.style.color = '#ffaa00';
                    <?php elseif ($reorder < $volume && $volume < $highAlarm): ?>
                        el.style.color = '#67c749';
                    <?php elseif ($highAlarm <= $volume && $volume < $highLevel): ?>
                        el.style.color = '#6E0093';
                    <?php elseif ($highLevel != 0.0 && $highLevel <= $volume): ?>
                        el.style.color = '#ff0000';
                    <?php else: ?>
                        el.style.color = '#333';
                    <?php endif; ?>
                })();
            </script>

            <?php $i++; ?>
        <?php endforeach; ?>

        <!-- Lightweight pagination affordance: show a link when more tanks exist than were rendered -->
        <?php if ($limit !== null && $totalCount > $limit): ?>
            <div style="text-align: center; margin-top: 13px; font-weight: 600">
                <a href="<?= site_url('tank') ?>" style="color:#000 !important">
                    <?= esc('Show More Tanks') ?>
                </a>
            </div>
        <?php endif; ?>

    <?php else: ?>
        <!-- Empty-state message -->
        <p><?= esc('No tanks found.') ?></p>
    <?php endif; ?>
</div>

<!-- Optional: progressive enhancement for refreshing the tank list without full page reload -->
<script>
    document.addEventListener('DOMContentLoaded', function () {
        var btn = document.getElementById('tank_refresh');
        if (!btn) return;

        btn.addEventListener('click', function () {
            // GET request to the same route; controller will re-render the list.
            fetch("<?= site_url('tank') ?>", { method: 'GET' })
                .then(function (r) { return r.text(); })
                .then(function (html) {
                    var box = document.getElementById('tank_box');
                    if (!box) return;
                    box.innerHTML = 'Please Wait...';
                    box.innerHTML = html;
                    box.style.display = 'block';
                })
                .catch(function () {
                    // Optional: show a notification
                });
        });
    });
</script>

</body>
</html>
