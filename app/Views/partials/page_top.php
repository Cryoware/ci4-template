<?php // Default Blank Page Top Partial ?>
<?php
// Example renderer snippet you can include in your header/top partial
$actions = $page['actions'] ?? [];
?>
<?php if (!empty($actions)): ?>
    <div class="d-flex gap-2 justify-content-end">
        <?php foreach ($actions as $action): ?>
            <?php
            $type  = $action['type']  ?? 'button';
            $label = $action['label'] ?? '';
            $class = $action['class'] ?? 'btn btn-sm btn-secondary';
            $attrs = $action['attrs'] ?? [];
            $href  = $action['href']  ?? null;
            $id    = $action['id']    ?? null;
            $idAttr = $id ? ' id="' . esc($id) . '"' : '';

            // helper to render HTML attributes
            $attrStr = '';
            foreach ($attrs as $k => $v) {
                $attrStr .= ' ' . esc($k) . '="' . esc($v) . '"';
            }
            ?>

            <?php if ($type === 'link' && $href): ?>
                <a<?= $idAttr ?> href="<?= esc($href) ?>" class="<?= esc($class) ?>"<?= $attrStr ?>><?= esc($label) ?></a>
            <?php elseif ($type === 'submit'): ?>
                <button<?= $idAttr ?> type="submit" class="<?= esc($class) ?>"<?= $attrStr ?>><?= esc($label) ?></button>
            <?php else: ?>
                <button<?= $idAttr ?> type="button" class="<?= esc($class) ?>"<?= $attrStr ?>><?= esc($label) ?></button>
            <?php endif; ?>
        <?php endforeach; ?>
    </div>
<?php endif; ?>