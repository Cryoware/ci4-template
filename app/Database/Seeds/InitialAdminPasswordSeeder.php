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

        $user = $this->db->table('users')->where('email', $email)->get()->getRowArray();
        if (!$user) {
            echo "User not found: {$email}\n";
            return;
        }

        $hash = password_hash($plain, PASSWORD_DEFAULT);
        $this->db->table('users')
            ->where('user_id', (int) $user['user_id'])
            ->update(['password_hash' => $hash]);

        echo "Password set for {$email}. Rotate on first login.\n";
    }
}
