<?php
// app/Cells/SidebarMenuCell.php
namespace App\Cells;

use CodeIgniter\View\Cells\Cell;

class SidebarMenuCell extends Cell
{
    public array $items = [];

    public function mount(): void
    {
        // Cast role to int to match roles array types
        $roleId = (int) (session('role_id') ?? 0);

        // Use the dedicated menu service
        $this->items = service('menu')->forRole($roleId);

        // Small guard: ensure parents use a non-navigating URL
        $this->items = $this->normalizeParentUrls($this->items);

        // Mark active/open based on current request path
        $currentPath = service('uri')->getPath(); // e.g., "admin/users/create"
        $this->items = $this->markActiveAndOpen($this->items, $currentPath);
    }

    // inside SidebarMenuCell (optional explicit render)
    public function render(): string
    {
        return view('cells/sidebar_menu', ['items' => $this->items]);
    }

    /**
     * Recursively set 'active' on the item whose URL matches current path,
     * and 'open' on parents that contain an active descendant.
     * Also track 'exact' for the link that exactly matches the current URL.
     */
    private function markActiveAndOpen(array $items, string $currentPath): array
    {
        $normalizedCurrent = '/' . ltrim($currentPath, '/');

        $walker = function (array $entries) use (&$walker, $normalizedCurrent): array {
            foreach ($entries as &$entry) {
                $entry['active'] = false;
                $entry['open']   = false;
                $entry['exact']  = false;

                $children = $entry['children'] ?? [];
                if (!empty($children)) {
                    $children = $walker($children);

                    // If any child is active/open, mark this parent open and active (for highlighting)
                    $hasActiveChild = array_reduce($children, static function ($carry, $c) {
                        return $carry || !empty($c['active']) || !empty($c['open']);
                    }, false);

                    if ($hasActiveChild) {
                        $entry['open']   = true;
                        $entry['active'] = true; // highlight the parent label too
                    }
                    $entry['children'] = $children;
                }

                // Leaf or parent can also be directly active by URL match
                if ($this->urlMatchesCurrent($entry['url'] ?? null, $normalizedCurrent)) {
                    $entry['active'] = true;
                    $entry['exact']  = true; // only the exact matching item
                }
            }
            return $entries;
        };

        return $walker($items);
    }

    /**
     * Compare the menu item URL to the current path.
     * - Ignores domain and query string
     * - Treats '#' or empty URL as non-match
     * - Exact path match; extend to wildcard logic if needed
     */
    private function urlMatchesCurrent(?string $url, string $normalizedCurrent): bool
    {
        if (!$url || $url === '#') {
            return false;
        }
        $path = parse_url($url, PHP_URL_PATH) ?? '';
        if ($path === '') {
            return false;
        }
        // Normalize: ensure leading slash
        $normalizedPath = '/' . ltrim($path, '/');
        return rtrim($normalizedPath, '/') === rtrim($normalizedCurrent, '/');
    }

    /**
     * Ensure that any item with children has a safe, non-navigating URL.
     * Keeps existing '#' or empty values; otherwise forces '#'.
     */
    private function normalizeParentUrls(array $items): array
    {
        foreach ($items as &$entry) {
            $children = $entry['children'] ?? [];
            if (!empty($children)) {
                // Force parent URL to '#' so clicking only toggles
                if (empty($entry['url']) || $entry['url'] !== '#') {
                    $entry['url'] = '#';
                }
                $entry['children'] = $this->normalizeParentUrls($children);
            }
        }
        return $items;
    }
}
