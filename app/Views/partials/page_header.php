<?php // app/Views/partials/page_header.php ?>
<div class="row">
    <div class="col-sm-8">
        <h3 class="mb-0"><?= esc($page['title'] ?? 'Dashboard') ?></h3>
        <?php if (!empty($page['subtitle'])): ?>
            <small class="text-muted"><?= esc($page['subtitle']) ?></small>
        <?php endif; ?>
    </div>
    <div class="col-sm-4">
        <ol class="breadcrumb float-sm-end">
            <?php foreach (($page['breadcrumbs'] ?? []) as $crumb): ?>
                <?php if (!empty($crumb['active'])): ?>
                    <li class="breadcrumb-item active" aria-current="page"><?= esc($crumb['label']) ?></li>
                <?php else: ?>
                    <li class="breadcrumb-item"><a href="<?= esc($crumb['url'] ?? '#') ?>"><?= esc($crumb['label']) ?></a></li>
                <?php endif; ?>
            <?php endforeach; ?>
        </ol>
    </div>
</div>