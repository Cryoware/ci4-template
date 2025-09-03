<?php
// Maintenance top bar: fixed at very top, full-width
try {
    $maintenanceEnabled = \App\Libraries\ConfigService::get('maintenance_mode', false);
} catch (\Throwable $e) {
    $maintenanceEnabled = false;
}
if ($maintenanceEnabled): ?>
    <style>
        .maintenance-topbar {
            /*top: 0; left: 0; right: 0;*/
            z-index: 2000;

            width: 100%;
            height: 25px;
            background-color: #ff8c00;
            /* Center text horizontally and vertically */
            display: flex;
            justify-content: center;
            align-items: center;
            /* Make text bold and add letter spacing */
            font-weight: bold;
            letter-spacing: 3px;
            /* Improve overall appearance */
            font-family: Arial, sans-serif;
            color: #fff;
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.3);
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
            /* Make it part of normal document flow */
            position: static;
            /*margin-bottom: 20px;*/
        }
    </style>
    <div class="maintenance-topbar" aria-hidden="true">MAINTENANCE MODE</div>
<?php endif; ?>
