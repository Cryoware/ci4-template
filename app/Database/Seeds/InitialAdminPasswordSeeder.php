<?php
declare(strict_types=1);

namespace App\Database\Seeds;

use CodeIgniter\Database\Seeder;

final class InitialAdminPasswordSeeder extends Seeder
{
    public function run()
    {
        $email  = getenv('INIT_ADMIN_EMAIL') ?: 'admin@example.com';
        $plain  = getenv('INIT_ADMIN_PASSWORD') ?: 'ChangeMeNow!42';

        $user = $this->db->table('t_users_details')->where('f_user_email', $email)->get()->getRowArray();
        if (!$user) {
            echo "User not found: {$email}\n";
            return;
        }

        $hash = password_hash($plain, PASSWORD_DEFAULT);
        $this->db->table('t_users_details')
            ->where('f_user_id', (int) $user['f_user_id'])
            ->update(['f_password' => $hash]);

        echo "Password set for {$email}. Rotate on first login.\n";
    }
}
