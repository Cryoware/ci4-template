<?php
// app/Views/cells/sidebar_menu.php
?>
<nav class="mt-2">
    <ul class="nav sidebar-menu flex-column"
        data-lte-toggle="treeview"
        role="navigation"
        aria-label="Main navigation"
        data-accordion="false"
        id="navigation">
        <?php foreach ($items as $item): ?>
            <?php $hasChildren = !empty($item['children']); ?>
            <li class="nav-item<?= !empty($item['open']) ? ' menu-open' : '' ?>">
                <a href="<?= esc($item['url'] ?? '#') ?>"
                   class="nav-link<?= !empty($item['active']) ? ' active' : '' ?><?= (!empty($item['exact']) && !$hasChildren) ? ' disabled' : '' ?>"
                   <?= $hasChildren ? 'role="button" aria-expanded="' . (!empty($item['open']) ? 'true' : 'false') . '"' : '' ?>
                   <?= (!empty($item['exact']) && !$hasChildren) ? 'aria-current="page" aria-disabled="true" tabindex="-1"' : '' ?>>
                    <i class="nav-icon <?= esc($item['icon'] ?? 'bi bi-circle') ?>"></i>
                    <p>
                        <?= esc($item['label']) ?>
                        <?php if (!empty($item['badge'])): ?>
                            <span class="nav-badge badge <?= esc($item['badge_class'] ?? 'text-bg-secondary') ?> me-3">
                                <?= esc($item['badge']) ?>
                            </span>
                        <?php endif; ?>
                        <?php if ($hasChildren): ?>
                            <i class="nav-arrow bi bi-chevron-right"></i>
                        <?php endif; ?>
                    </p>
                </a>

                <?php if ($hasChildren): ?>
                    <ul class="nav nav-treeview">
                        <?php foreach ($item['children'] as $child): ?>
                            <?php $childHasChildren = !empty($child['children']); ?>
                            <li class="nav-item<?= !empty($child['open']) ? ' menu-open' : '' ?>">
                                <a href="<?= esc($child['url'] ?? '#') ?>"
                                   class="nav-link<?= !empty($child['active']) ? ' active' : '' ?><?= (!empty($child['exact']) && !$childHasChildren) ? ' disabled' : '' ?>"
                                   <?= $childHasChildren ? 'role="button" aria-expanded="' . (!empty($child['open']) ? 'true' : 'false') . '"' : '' ?>
                                   <?= (!empty($child['exact']) && !$childHasChildren) ? 'aria-current="page" aria-disabled="true" tabindex="-1"' : '' ?>>
                                    <i class="nav-icon <?= esc($child['icon'] ?? 'bi bi-circle') ?>"></i>
                                    <p>
                                        <?= esc($child['label']) ?>
                                        <?php if (!empty($child['badge'])): ?>
                                            <span class="nav-badge badge <?= esc($child['badge_class'] ?? 'text-bg-secondary') ?> me-3">
                                                <?= esc($child['badge']) ?>
                                            </span>
                                        <?php endif; ?>
                                        <?php if ($childHasChildren): ?>
                                            <i class="nav-arrow bi bi-chevron-right"></i>
                                        <?php endif; ?>
                                    </p>
                                </a>

                                <?php if ($childHasChildren): ?>
                                    <ul class="nav nav-treeview">
                                        <?php foreach ($child['children'] as $grand): ?>
                                            <li class="nav-item">
                                                <a href="<?= esc($grand['url'] ?? '#') ?>"
                                                   class="nav-link<?= !empty($grand['active']) ? ' active' : '' ?><?= (!empty($grand['exact'])) ? ' disabled' : '' ?>"
                                                   <?= !empty($grand['exact']) ? 'aria-current="page" aria-disabled="true" tabindex="-1"' : '' ?>>
                                                    <i class="nav-icon <?= esc($grand['icon'] ?? 'bi bi-record-circle-fill') ?>"></i>
                                                    <p><?= esc($grand['label']) ?></p>
                                                </a>
                                            </li>
                                        <?php endforeach; ?>
                                    </ul>
                                <?php endif; ?>
                            </li>
                        <?php endforeach; ?>
                    </ul>
                <?php endif; ?>
            </li>
        <?php endforeach; ?>

        <?php if (!empty($headers ?? [])): ?>
            <?php foreach ($headers as $header): ?>
                <li class="nav-header"><?= esc($header) ?></li>
            <?php endforeach; ?>
        <?php endif; ?>
    </ul>
</nav>
<script>
// Extend the existing guard: also block clicks on disabled (current page) links.
(function () {
  const nav = document.getElementById('navigation');
  if (!nav) return;

  const LOCK_MS = 350;

  function isLocked(li) {
    const until = parseInt(li.dataset.lockUntil || '0', 10);
    return Date.now() < until;
  }
  function setLock(li) {
    li.dataset.lockUntil = String(Date.now() + LOCK_MS);
  }

  const observer = new MutationObserver((mutations) => {
    for (const m of mutations) {
      if (m.type === 'attributes' && m.attributeName === 'class') {
        const li = m.target;
        if (!(li instanceof HTMLElement) || !li.matches('li.nav-item')) continue;
        const link = li.querySelector(':scope > a.nav-link');
        if (!link) continue;
        const hasChildren = !!li.querySelector(':scope > ul.nav-treeview');
        if (hasChildren) {
          const expanded = li.classList.contains('menu-open');
          link.setAttribute('aria-expanded', expanded ? 'true' : 'false');
        }
      }
    }
  });
  observer.observe(nav, { attributes: true, subtree: true, attributeFilter: ['class'] });

  nav.addEventListener('click', function (e) {
    const link = e.target instanceof Element ? e.target.closest('a.nav-link') : null;
    if (!link || !nav.contains(link)) return;

    // Block clicks on disabled links (exact current page)
    if (link.classList.contains('disabled') || link.getAttribute('aria-disabled') === 'true') {
      e.preventDefault();
      e.stopPropagation();
      return;
    }

    const li = link.parentElement;
    if (!li || !li.matches('li.nav-item')) return;

    const hasChildren = !!li.querySelector(':scope > ul.nav-treeview');

    if (hasChildren && link.getAttribute('href') === '#') {
      e.preventDefault();
    }

    if (hasChildren) {
      if (isLocked(li)) {
        e.stopPropagation();
        return;
      }
      setLock(li);
    }
  }, true);
})();
</script>
