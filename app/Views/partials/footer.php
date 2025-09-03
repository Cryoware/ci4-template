<?php
// app/Views/partials/footer.php
?>
<footer class="app-footer">
    <div class="float-end d-none d-sm-inline">Anything you want</div>
    <strong>&copy; <?= date('Y') ?> Your Company.</strong> All rights reserved.
    <div class="mt-2" style="font-size: 0.9rem; color: #6c757d;">
        Session expires in <span id="session-countdown">--:--</span>
    </div>
</footer>
<script>
  // Minimal config to drive the visual countdown
  window.IdleUXConfig = {
    // For testing, use 60s; set to your real session inactivity in seconds (e.g., 7200)
    threshold: 7200, // test; switch to your real value
    countdownSelector: '#session-countdown',
    loginUrl: '/login',
    logoutUrl: '<?= site_url('/logout') ?>', // explicit logout when idle expires
    // excludeKeepAlive: [/\/health$/, /\/metrics$/]
  };
</script>
<script src="/assets/js/idle-ux.js" defer></script>
<script src="/assets/js/ui-busy.js"></script>
