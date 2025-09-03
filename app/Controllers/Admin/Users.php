<?php

namespace App\Controllers\Admin;

use App\Controllers\BaseController;

class Users extends BaseController
{
    public function index()
    {
        $data = [
            'PageTitle' => 'Add/Modify Users',
            'page' => [
                'key'   => 'admin.users',
                'title' => 'System Users',
                'subtitle' => 'Add/Modify System Users',
                'breadcrumbs' => [
                    ['label' => 'Home', 'url' => site_url('/')],
                    ['label' => 'Admin', 'url' => site_url('/admin/dashboard')],
                    ['label' => 'Add/Modify Users', 'active' => true],
                ],
                'actions' => [
                    // Top-right buttons in the header/top area:
                    [
                        'id'    => "btnCreate",
                        'type'  => 'button',                 // button or 'submit' or 'link'
                        'label' => 'New User',
                        'class' => 'btn btn-primary btn-sm bi bi-plus',
                        'attrs' => ['form' => 'userForm'] // submit the form from outside
                    ],
                ],
            ],
        ];
        // Renders the AdminLTE page with DataTable; data is fetched via API
        return view('admin/users/index', $data);
    }

    public function edit(int $id)
    {
        // This can render a dedicated edit page if desired,
        // but in this setup we edit via a modal using AJAX to the API.
        return redirect()->to('/admin/users');
    }
}
