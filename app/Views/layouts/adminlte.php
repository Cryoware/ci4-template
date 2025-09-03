<?php
// app/Views/layouts/adminlte.php
?>
<!DOCTYPE html>
<html lang="<?= esc(session('lang') ?? 'en') ?>">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><?= esc($PageTitle ?? 'App') ?></title>

    <!-- Fonts (optional) -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@fontsource/source-sans-3@5.0.12/index.css" crossorigin="anonymous" media="print" onload="this.media='all'">

    <!-- OverlayScrollbars CSS (optional but recommended for sidebar) -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/overlayscrollbars@2.11.0/styles/overlayscrollbars.min.css" crossorigin="anonymous">

    <!-- Bootstrap Icons (required for template icons like bi bi-*) -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css" crossorigin="anonymous">

    <!-- AdminLTE 4 CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/admin-lte@4.0.0-rc4/dist/css/adminlte.min.css">

    <!-- Popper and Bootstrap JS (required by AdminLTE components) -->
    <script defer src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" crossorigin="anonymous"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/js/bootstrap.min.js" crossorigin="anonymous"></script>

    <!-- OverlayScrollbars JS -->
    <script defer src="https://cdn.jsdelivr.net/npm/overlayscrollbars@2.11.0/browser/overlayscrollbars.browser.es6.min.js" crossorigin="anonymous"></script>

    <!-- AdminLTE 4 JS -->
    <script defer src="https://cdn.jsdelivr.net/npm/admin-lte@4.0.0-rc4/dist/js/adminlte.min.js"></script>
    <?= $this->renderSection('head') ?>
</head>
<body class="layout-fixed sidebar-expand-lg sidebar-open bg-body-tertiary">
<?= $this->include('partials/maintenance_mode') ?>
<div class="app-wrapper">
    <?= $this->include('partials/navbar') ?>

    <aside class="app-sidebar bg-body-secondary shadow" data-bs-theme="dark">
        <!-- Sidebar Brand (logo) -->
        <div class="sidebar-brand">
            <a href="<?= site_url('/') ?>" class="brand-link">
                <img src="/assets/images/oilcop-g2-logo.png" alt="Oilcop GenII" class="brand-image-xs logo-xl opacity-75">
                <span class="brand-text fw-light"><?= esc($BrandText ?? 'OilCop GenII') ?></span>
            </a>
        </div>
        <div class="sidebar-wrapper">
            <!-- Dynamic menu -->
            <?= view_cell('App\\Cells\\SidebarMenuCell::render') ?>
        </div>
    </aside>

    <main class="app-main">
        <?php $sectionContentTop = trim($this->renderSection('contentTop') ?: view('partials/page_top', ['page' => $page ?? []])); ?>
        <?php if ($sectionContentTop !== ''): ?>
            <div class="app-content-top-area">
                <div class="container-fluid">
                    <?= $sectionContentTop ?>
                </div>
            </div>
        <?php endif; ?>

        <?php $sectionContentHeader = trim($this->renderSection('contentHeader') ?: view('partials/page_header', ['page' => $page ?? []])); ?>
        <?php if ($sectionContentHeader !== ''): ?>
            <div class="app-content-header">
                <div class="container-fluid">
                    <?= $sectionContentHeader ?>
                </div>
            </div>
        <?php endif; ?>

        <div class="app-content">
            <div class="container-fluid">
                <?= $this->renderSection('content') ?>
            </div>
        </div>

        <?php $sectionContentBottom = trim($this->renderSection('contentBottom') ?: view('partials/page_bottom', ['page' => $page ?? []])); ?>
        <?php if ($sectionContentBottom !== ''): ?>
            <div class="app-content-bottom-area">
                <div class="container-fluid">
                    <?= $sectionContentBottom ?>
                </div>
            </div>
        <?php endif; ?>

    </main>

    <?= $this->include('partials/footer') ?>

</div>
<?= $this->include('partials/busy_overlay') ?>

<?= $this->renderSection('js') ?>

<script>
// Initialize OverlayScrollbars for the sidebar wrapper (optional)
document.addEventListener("DOMContentLoaded", function () {
  const el = document.querySelector(".sidebar-wrapper");
  if (el && window.OverlayScrollbarsGlobal?.OverlayScrollbars) {
    OverlayScrollbarsGlobal.OverlayScrollbars(el, {
      scrollbars: { theme: "os-theme-light", autoHide: "leave", clickScroll: true }
    });
  }
});
</script>
</body>
</html>
