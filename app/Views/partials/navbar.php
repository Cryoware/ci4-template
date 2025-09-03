<?php
// app/Views/partials/navbar.php
?>
<nav class="app-header navbar navbar-expand bg-body">
    <div class="container-fluid">
        <!-- Left -->
        <ul class="navbar-nav">
            <li class="nav-item">
                <a class="nav-link" data-lte-toggle="sidebar" href="#" role="button"><i class="bi bi-list"></i></a>
            </li>
            <li class="nav-item d-none d-md-block"><a href="<?= site_url('/'); ?>" class="nav-link">Home</a></li>
            <?php foreach (($page['page_menu'] ?? []) as $menu_item): ?>
                <?php if (!empty($menu_item['active'])): // TODO: Add active class to active menu item?>
                    <li class="nav-item d-none d-md-block"><a href="<?= esc($menu_item['url'] ?? '#') ?>" class="nav-link"><?= esc($menu_item['label']) ?></a></li>
                <?php else: ?>
                    <li class="nav-item d-none d-md-block"><a href="<?= esc($menu_item['url'] ?? '#') ?>" class="nav-link"><?= esc($menu_item['label']) ?></a></li>
                <?php endif; ?>
            <?php endforeach; ?>
        </ul>
        <!-- Right -->
        <ul class="navbar-nav ms-auto">
            <li class="nav-item">
                <a class="nav-link" data-widget="navbar-search" href="#" role="button">
                    <i class="bi bi-search"></i>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="#" data-lte-toggle="fullscreen">
                    <i data-lte-icon="maximize" class="bi bi-arrows-fullscreen"></i>
                    <i data-lte-icon="minimize" class="bi bi-fullscreen-exit" style="display: none;"></i>
                </a>
            </li>
            <!-- Example role-aware area -->
            <?= view_cell('App\Cells\TopActionsCell::render') ?>
            <!-- Current user dropdown -->
            <?= view_cell('App\Cells\CurrentUsersCell::render') ?>
        </ul>
    </div>
</nav>
