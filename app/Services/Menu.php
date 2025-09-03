<?php
// app/Services/Menu.php

namespace App\Services;

class Menu
{
    /**
     * Get menu items available for a given role.
     */
    public function forRole(int $roleId): array
    {
        $items = $this->definitions();

        // Recursively filter by role (parent and children)
        $filterByRole = function (array $entries) use (&$filterByRole, $roleId): array {
            $result = [];
            foreach ($entries as $entry) {
                $allowed = in_array($roleId, $entry['roles'] ?? [], true);

                $children = $entry['children'] ?? [];
                if (!empty($children)) {
                    $children = $filterByRole($children);
                }

                // Keep the item if it's allowed or has any allowed children
                if ($allowed || !empty($children)) {
                    $entry['children'] = $children;
                    $result[] = $entry;
                }
            }
            return array_values($result);
        };

        return $filterByRole($items);
    }

    /**
     * Central menu definitions reflecting the AdminLTE template structure.
     * Adjust roles as needed.
     */
    protected function definitions(): array
    {
        return [
            [
                'label'    => 'Dashboard',
                'icon'     => 'bi bi-speedometer',
                'url'      => '/dashboard',
                'roles'    => [1, 2, 3, 4],
                'children' => [],
            ],
            [
                'label'    => 'Configuration',
                'icon'     => 'bi bi-box-seam-fill',
                'url'      => '#',
                'roles'    => [1, 2, 3, 4],
                'children' => [
                    [
                        'label' => 'Settings',
                        'icon'  => 'bi bi-pencil',
                        'url'   => site_url('admin/settings'),
                        'roles' => [1],
                        'children' => [],
                    ],
                    [
                        'label' => 'Add/Modify Users',
                        'icon'  => 'bi bi-people-fill',
                        'url'   => site_url('admin/users'),
                        'roles' => [1],
                        'children' => [],
                    ],
                    [
                        'label' => 'Cards',
                        'icon'  => 'bi bi-circle',
                        'url'   => site_url('widgets/cards'),
                        'roles' => [1, 2, 3, 4],
                        'children' => [],
                    ],
                ],
            ],
            [
                'label'       => 'Layout Options',
                'icon'        => 'bi bi-clipboard-fill',
                'url'         => '#',
                'roles'       => [1, 2, 3, 4],
                'badge'       => '6',
                'badge_class' => 'text-bg-secondary',
                'children'    => [
                    [
                        'label' => 'Default Sidebar',
                        'icon'  => 'bi bi-circle',
                        'url'   => site_url('layout/unfixed-sidebar'),
                        'roles' => [1, 2, 3, 4],
                        'children' => [],
                    ],
                    [
                        'label' => 'Fixed Sidebar',
                        'icon'  => 'bi bi-circle',
                        'url'   => site_url('layout/fixed-sidebar'),
                        'roles' => [1, 2, 3, 4],
                        'children' => [],
                    ],
                    [
                        'label' => 'Fixed Header',
                        'icon'  => 'bi bi-circle',
                        'url'   => site_url('layout/fixed-header'),
                        'roles' => [1, 2, 3, 4],
                        'children' => [],
                    ],
                    [
                        'label' => 'Fixed Footer',
                        'icon'  => 'bi bi-circle',
                        'url'   => site_url('layout/fixed-footer'),
                        'roles' => [1, 2, 3, 4],
                        'children' => [],
                    ],
                    [
                        'label' => 'Fixed Complete',
                        'icon'  => 'bi bi-circle',
                        'url'   => site_url('layout/fixed-complete'),
                        'roles' => [1, 2, 3, 4],
                        'children' => [],
                    ],
                    [
                        'label' => 'Layout + Custom Area',
                        'icon'  => 'bi bi-circle',
                        'url'   => site_url('layout/layout-custom-area'),
                        'roles' => [1, 2, 3, 4],
                        'children' => [],
                    ],
                ],
            ],
            [
                'label'    => 'UI Elements',
                'icon'     => 'bi bi-tree-fill',
                'url'      => '#',
                'roles'    => [1, 2, 3, 4],
                'children' => [
                    [
                        'label' => 'General',
                        'icon'  => 'bi bi-circle',
                        'url'   => site_url('ui/general'),
                        'roles' => [1, 2, 3, 4],
                        'children' => [],
                    ],
                    [
                        'label' => 'Icons',
                        'icon'  => 'bi bi-circle',
                        'url'   => site_url('ui/icons'),
                        'roles' => [1, 2, 3, 4],
                        'children' => [],
                    ],
                    [
                        'label' => 'Timeline',
                        'icon'  => 'bi bi-circle',
                        'url'   => site_url('ui/timeline'),
                        'roles' => [1, 2, 3, 4],
                        'children' => [],
                    ],
                ],
            ],
            [
                'label'    => 'Forms',
                'icon'     => 'bi bi-pencil-square',
                'url'      => '#',
                'roles'    => [1, 2, 3, 4],
                'children' => [
                    [
                        'label' => 'General Elements',
                        'icon'  => 'bi bi-circle',
                        'url'   => site_url('forms/general'),
                        'roles' => [1, 2, 3, 4],
                        'children' => [],
                    ],
                ],
            ],
            [
                'label'    => 'Tables',
                'icon'     => 'bi bi-table',
                'url'      => '#',
                'roles'    => [1, 2, 3, 4],
                'children' => [
                    [
                        'label' => 'Simple Tables',
                        'icon'  => 'bi bi-circle',
                        'url'   => site_url('admin-lte/tables/simple.html'),
                        'roles' => [1, 2, 3, 4],
                        'children' => [],
                    ],
                ],
            ],
            // Example section headers or labels can be added directly in the view if preferred.
            [
                'label'    => 'Auth',
                'icon'     => 'bi bi-box-arrow-in-right',
                'url'      => '#',
                'roles'    => [1, 2, 3, 4],
                'children' => [
                    [
                        'label' => 'Version 1',
                        'icon'  => 'bi bi-box-arrow-in-right',
                        'url'   => '#',
                        'roles' => [1, 2, 3, 4],
                        'children' => [
                            [
                                'label' => 'Login',
                                'icon'  => 'bi bi-circle',
                                'url'   => site_url('examples/login'),
                                'roles' => [1, 2, 3, 4],
                                'children' => [],
                            ],
                            [
                                'label' => 'Register',
                                'icon'  => 'bi bi-circle',
                                'url'   => site_url('examples/register'),
                                'roles' => [1, 2, 3, 4],
                                'children' => [],
                            ],
                        ],
                    ],
                ],
            ],
        ];
    }
}
