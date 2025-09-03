<?php if ($tanks): ?>
    <?php $i = 1; ?>
    <?php foreach ($tanks as $tank): ?>
        <?php if (!$limit || ($limit && $i <= $limit)): ?>
            <?php
            // Calculate ullage and alert levels
            $ullage = 0;
            if ($tank['f_tank_volume'] >= $tank['f_tank_high_level']) {
                $ullage = 0;
            } else {
                $ullage = $tank['f_tank_high_level'] - $tank['f_tank_volume'];
            }

            // Process alert conditions
            $u = '';
            $high_lev_war = $tank['f_tank_high_level'] ?? 0;
            $high_lev_shut = $tank['f_tank_high_alarm'] ?? 0;
            $reorder_lev = $tank['f_tank_reorder_level'] ?? 0;
            $low_lev_shut = $tank['f_tank_shutoff_level'] ?? 0;

            if ($tank['f_alert_conditions'] == 'volume') {
                $u = substr($tank['f_units_name'], 0, 1);
            } elseif ($tank['f_alert_conditions'] == 'percentage') {
                $u = '%';
                if ($tank['f_tank_capacity'] != 0) {
                    $high_lev_war = ($tank['f_tank_high_level'] / $tank['f_tank_capacity']) * 100;
                    $high_lev_shut = ($tank['f_tank_high_alarm'] / $tank['f_tank_capacity']) * 100;
                    $reorder_lev = ($tank['f_tank_reorder_level'] / $tank['f_tank_capacity']) * 100;
                    $low_lev_shut = ($tank['f_tank_shutoff_level'] / $tank['f_tank_capacity']) * 100;
                }
            }

            // Calculate current height
            $current_height = '';
            if ($tank['f_tank_monitor_installed'] == "yes") {
                $measures = $tank['f_tank_volume_type'];
                $mea = ($measures == "inches") ? "in" : (($measures == "centi") ? "cm" : "");
                $current_height = ' "' . round($tank['f_current_height'], 2) . ' ' . $mea . '"';
            }

            $units = $tank['f_units_name'];
            $units_first = substr($units, 0, 1);
            ?>

            <?php if ($role != "tech"): ?>
                <a target="_blank" href="<?= $page . $tank['f_tank_id'] ?>" class="" id="tooltip">
                    <div class="tank_img" id="g<?= $i ?>"></div>
                    <span>
                        <strong><?= $lang['product'] ?>- </strong>
                        <?php if ($tank['f_tank_product_exe'] > 1): ?>
                            <?= $tank['f_product_name'] . '[' . $tank['f_tank_product_exe'] . ']' ?>
                        <?php else: ?>
                            <?= $tank['f_product_name'] ?>
                        <?php endif; ?><br>

                        <strong><?= $lang['capacity'] ?>- </strong>
                        <?= $tank['f_tank_capacity'] . $units_first ?><br>

                        <strong><?= $lang['contents'] ?>- </strong>
                        <?= round($tank['f_tank_volume'], 1) . $units_first . $current_height ?><br>

                        <strong><?= $lang['ullage'] ?>- </strong>
                        <?= round($ullage, 1) ?><br>

                        <strong><?= $lang['highlevel_shutoff'] ?>- </strong>
                        <?= number_format($high_lev_war, 1) . $u ?><br>

                        <strong><?= $lang['highlevel_warning'] ?>- </strong>
                        <?= number_format($high_lev_shut, 1) . $u ?><br>

                        <strong><?= $lang['reorder_level'] ?>- </strong>
                        <?= number_format($reorder_lev, 1) . $u ?><br>

                        <strong><?= $lang['lowlevel_shutoff'] ?>- </strong>
                        <?= number_format($low_lev_shut, 1) . $u ?><br>
                    </span>
                </a>
            <?php else: ?>
                <div class="gauge_panel" style="position:relative;" id="g<?= $i ?>"></div>
            <?php endif; ?>

            <?php $i++; ?>
        <?php endif; ?>
    <?php endforeach; ?>

    <?php if ($limit && count($tanks) > $limit): ?>
        <div style="text-align: center; margin-top: 13px; font-weight: 600">
            <a href="tank/view_tank_details" style="color:#000 !important">Show More Tanks</a>
        </div>
    <?php endif; ?>
<?php endif; ?>

<script>
    <?php if ($tanks): ?>
    <?php $i = 1; ?>
    <?php foreach ($tanks as $tank): ?>
    <?php
    $tank_fill_level = 0;
    $normal = 0;
    $color = '#333';
    $capacity = $tank['f_tank_capacity'] ?: 0.0;

    if ($capacity && $capacity != 0) {
        $tank_fill_level = round($tank['f_tank_volume'], 1);
        $volume = round(($tank['f_tank_volume'] / $capacity) * 100, 2);
    }

    // Determine tank title
    $title_name = '';
    if ($tank['f_tank_name'] == $tank['f_product_name']) {
        $title_name = ($tank['f_tank_product_exe'] > 1)
            ? $tank['f_product_name'] . '[' . $tank['f_tank_product_exe'] . ']'
            : $tank['f_product_name'];
    } else {
        $title_name = $tank['f_product_name'] . '\\n' . $tank['f_tank_name'];
    }

    // Determine tank status and color
    if ($tank['f_collection'] == 1) {
        $normal = $lang['normal'];
        $color = '#67c749';
    } elseif ($tank['f_tank_volume'] <= $tank['f_tank_shutoff_level']) {
        $normal = $lang['lowlevel_shutoff'];
        $color = '#cc0000';
    } elseif (($tank['f_tank_shutoff_level'] < $tank['f_tank_volume']) && ($tank['f_tank_volume'] <= $tank['f_tank_reorder_level'])) {
        $normal = $lang['reorder_level'];
        $color = '#ffaa00';
    } elseif (($tank['f_tank_reorder_level'] < $tank['f_tank_volume']) && ($tank['f_tank_volume'] < $tank['f_tank_high_alarm'])) {
        $normal = $lang['normal'];
        $color = '#67c749';
    } elseif (($tank['f_tank_high_alarm'] <= $tank['f_tank_volume']) && ($tank['f_tank_volume'] < $tank['f_tank_high_level'])) {
        $normal = $lang['highlevel_warning'];
        $color = '#6E0093';
    } elseif (($tank['f_tank_high_level'] != 0) && ($tank['f_tank_high_level'] <= $tank['f_tank_volume'])) {
        $normal = $lang['highlevel_shutoff'];
        $color = '#ff0000';
    } else {
        $normal = '&nbsp;';
        $color = '#333';
    }

    $units = $lang[$tank['f_units_name']] ?? $tank['f_units_name'];
    ?>

    var g<?= $i ?> = new JustGage({
        id: "g<?= $i ?>",
        value: <?= $tank_fill_level ?>,
        valueFontColor: 'rgb(0, 123, 255)',
        min: 0,
        max: <?= $capacity ?>,
        symbol: "%",
        startAnimationTime: 1,
        titleFontColor: 'rgb(0, 123, 255)',
        title: '<?= $title_name ?>',
        label: "<?= $units ?>",
        levelColors: ["<?= $color ?>"]
    });

    <?php if (!($tank['SensorStatus'] != '' && $tank['SensorStatus'] == 0)): ?>
    $("#g<?= $i ?>").append('<div class="blink<?= $i ?> Normal"><?= $normal ?></div>');
    <?php endif; ?>

    <?php if ($tank['SensorStatus'] != '' && $tank['SensorStatus'] == 0): ?>
    $('#g<?= $i ?> div.Normal').hide();
    $("#g<?= $i ?>").append('<div class="blink<?= $i ?> Invalid append_volume">Invalid</div>');
    $('#g<?= $i ?> div.Invalid').fadeOut('slow');
    $('#g<?= $i ?> div.Invalid').fadeIn('slow');
    <?php else: ?>
    <?php if (!(($tank['f_tank_reorder_level'] < $tank['f_tank_volume']) && ($tank['f_tank_volume'] < $tank['f_tank_high_alarm']))): ?>
    <?php if ($tank['f_collection'] != 1): ?>
    setInterval(function(){
        $('.blink<?= $i ?>').fadeOut('slow').fadeIn('slow');
    }, 500);
    <?php endif; ?>
    <?php endif; ?>
    <?php endif; ?>

    <?php $i++; ?>
    <?php endforeach; ?>
    <?php endif; ?>

    // Toggle function for tank status colors
    toggle();
    function toggle() {
        <?php if ($tanks): ?>
        <?php $m = 1; ?>
        <?php foreach ($tanks as $tank): ?>
        <?php
        $volume = $tank['f_tank_volume'];
        $shutoff = $tank['f_tank_shutoff_level'];
        $reorder = $tank['f_tank_reorder_level'];
        $highlevelalarm = $tank['f_tank_high_alarm'];
        $highlevel = $tank['f_tank_high_level'];
        ?>

        <?php if ($tank['f_collection'] == 1): ?>
        $(".blink<?= $m ?>").css({'color': '#67c749'});
        <?php elseif ($volume <= $shutoff): ?>
        $(".blink<?= $m ?>").css({'color': '#cc0000'});
        <?php elseif (($shutoff < $volume) && ($volume <= $reorder)): ?>
        $(".blink<?= $m ?>").css({'color': '#ffaa00'});
        <?php elseif (($reorder < $volume) && ($volume < $highlevelalarm)): ?>
        $(".blink<?= $m ?>").css({'color': '#67c749'});
        <?php elseif (($highlevelalarm <= $volume) && ($volume < $highlevel)): ?>
        $(".blink<?= $m ?>").css({'color': '#6E0093'});
        <?php elseif (($highlevel != 0) && ($highlevel <= $volume)): ?>
        $(".blink<?= $m ?>").css({'color': '#ff0000'});
        <?php else: ?>
        $(".blink<?= $m ?>").css({'color': '#333'});
        <?php endif; ?>

        <?php $m++; ?>
        <?php endforeach; ?>
        <?php endif; ?>
    }

    $(document).ready(function(){
        $('#tank_refresh').click(function(){
            $.ajax({
                type: 'POST',
                url: 'get_tanks/<?= $role ?>',
                success: function(data){
                    $('#tank_box').html('Please Wait...');
                    $('#tank_box').html(data);
                    $('#tank_box').show();
                }
            });
        });
    });

    $(".tank_level_title").click(function(){
        $("#tank_level_title").toggle();
    });
</script>