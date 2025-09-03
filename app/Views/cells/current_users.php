<?php
// app/Views/cells/top_actions.php
?>
<li class="nav-item dropdown user-menu">
    <a href="#" class="nav-link dropdown-toggle" data-bs-toggle="dropdown">
        <img src="/avatar?name=Jane%20Doe&size=64" alt="User" class="rounded-circle shadow" width="33" height="33">
        <span class="d-none d-md-inline"><?= esc(session('username') ?? 'User') ?></span>
    </a>
    <ul class="dropdown-menu dropdown-menu-lg dropdown-menu-end">
        <li class="user-header text-bg-primary">
            <img src="/avatar?name=Jane%20Doe&size=64" alt="User" class="rounded-circle shadow">
            <p><?= esc(session('email') ?? 'User') ?></p>
        </li>
        <li class="nav-item">
            <?php if (in_array($roleId, [1,4], true)): ?>
                <button type="button" class="btn btn-primary btn-sm">Create Admin</button>
            <?php endif; ?>
        </li>
        <li class="user-footer">
            <a href="<?= site_url('profile') ?>" class="btn btn-default btn-flat">Profile</a>
            <a href="<?= site_url('logout') ?>" class="btn btn-default btn-flat float-end">Sign out</a>
        </li>
    </ul>
</li>
