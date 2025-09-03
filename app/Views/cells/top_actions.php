<?php
// app/Views/cells/top_actions.php
?>
<li class="nav-item">
    <?php if (in_array($roleId, [1,4], true)): ?>
        <button type="button" class="btn btn-primary btn-sm">Create Admin</button>
    <?php endif; ?>
</li>
