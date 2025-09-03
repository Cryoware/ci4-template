<?php
// app/Cells/TopActionsCell.php
namespace App\Cells;

use CodeIgniter\View\Cells\Cell;

class TopActionsCell extends Cell
{
    public function render(): string
    {
        $roleId = (int) (session('role_id') ?? 0);
        return view('cells/top_actions', compact('roleId'));
    }
}
