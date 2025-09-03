<?php
namespace App\Enums;

enum RoleId: int
{
    case ADMIN = 1;
    case MANAGER = 2;
    case TECH = 3;
    case INSTALLER = 4;
}
