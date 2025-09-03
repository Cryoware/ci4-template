<?php
// app/Views/admin/dashboard.php
?>
<?= $this->extend('layouts/adminlte') ?>

<?= $this->section('contentTop') ?>
    <div class="row">
        <div class="col-md-6">App Content Top Area</div>
        <div class="col-md-6 text-end">
            <button class="btn btn-primary btn-sm">Create</button>
        </div>
    </div>
<?= $this->endSection() ?>

<?= $this->section('contentHeader') ?>
    <div class="row">
        <div class="col-sm-8"><h3 class="mb-0">Dashboard</h3></div>
        <div class="col-sm-4">
            <ol class="breadcrumb float-sm-end">
                <li class="breadcrumb-item"><a href="<?= site_url('/') ?>">Home</a></li>
                <li class="breadcrumb-item active" aria-current="page">Dashboard</li>
            </ol>
        </div>
    </div>
<?= $this->endSection() ?>

<?= $this->section('content') ?>
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header"><h3 class="card-title">Title</h3></div>
                <div class="card-body">Start creating your amazing application!</div>
                <div class="card-footer">Footer</div>
            </div>
        </div>
    </div>
<?= $this->endSection() ?>

<?= $this->section('contentBottom') ?>
    <div class="row">
        <div class="col-md-6">App Content Bottom Area</div>
        <div class="col-md-6 text-end">
            <button class="btn btn-secondary btn-sm">Refresh</button>
        </div>
    </div>
<?= $this->endSection() ?>