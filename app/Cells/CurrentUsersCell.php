<?php
// app/Cells/TopActionsCell.php
namespace App\Cells;

use CodeIgniter\View\Cells\Cell;

class CurrentUsersCell extends Cell
{
    public function render(): string
    {
        $roleId = (int) (session('role_id') ?? 0);
        return view('cells/current_users', compact('roleId'));
    }
}
