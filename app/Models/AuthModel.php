<?php
declare(strict_types=1);

namespace App\Models;

use CodeIgniter\Model;

final class AuthModel extends Model
{
    protected $table      = 't_users_details';
    protected $primaryKey = 'f_user_id';

    protected $allowedFields = ['f_user_pin', 'f_user_email', 'f_password'];

    // Legacy PIN login (safe)
    public function loginByPin(string $pin)
    {
        return $this->db->table('t_users_details')
            ->select('t_users_details.*, t_user_role_map.*')
            ->join('t_user_role_map', 't_user_role_map.f_user_id = t_users_details.f_user_id')
            ->where('t_users_details.f_user_pin', $pin)
            ->limit(1)
            ->get()
            ->getRow();
    }

    // Email lookup with role
    public function findByEmail(string $email)
    {
        return $this->db->table('t_users_details')
            ->select('t_users_details.*, t_user_role_map.*')
            ->join('t_user_role_map', 't_user_role_map.f_user_id = t_users_details.f_user_id', 'left')
            ->where('t_users_details.f_user_email', $email)
            ->limit(1)
            ->get()
            ->getRow();
    }

    // Verify email + password
    public function verifyPassword(string $email, string $password)
    {
        $user = $this->findByEmail($email);
        if (!$user || empty($user->f_password)) {
            return null;
        }
        if (password_verify($password, $user->f_password)) {
            if (password_needs_rehash($user->f_password, PASSWORD_DEFAULT)) {
                try {
                    $this->db->table('t_users_details')
                        ->where('f_user_id', $user->f_user_id)
                        ->update(['f_password' => password_hash($password, PASSWORD_DEFAULT)]);
                } catch (\Throwable $e) {
                    // best-effort rehash
                }
            }
            return $user;
        }
        return null;
    }

    // Set or update password
    public function setUserPassword(int $userId, string $plainPassword): bool
    {
        $hash = password_hash($plainPassword, PASSWORD_DEFAULT);
        return (bool) $this->db->table('t_users_details')
            ->where('f_user_id', $userId)
            ->update(['f_password' => $hash]);
    }

    // Language used by session bootstrap
    public function get_language(): ?string
    {
        $row = $this->db->query('SELECT tl.f_language_name FROM t_initial_setup AS ti JOIN t_languages AS tl ON tl.f_language_id = ti.f_user_language_id')->getRow();
        return $row->f_language_name ?? null;
    }

    // Timezone bundle used by session bootstrap
    public function get_user_timezone()
    {
        return $this->db->query('SELECT tz.*, ins.f_date_format, ins.f_user_time_hours, ins.f_day_light_mode FROM t_time_zone AS tz JOIN t_initial_setup AS ins ON ins.f_user_time_zone = tz.f_zone_id ORDER BY ins.f_initial_id DESC')->getRow();
    }

    // Shift logic for techs (copied for parity)
    public function check_shift(int $uid, int $timezone): int
    {
        $status = 0;
        $shift_name = $this->db->query('SELECT f_shift_type FROM t_adminstrative_options')->getRow()->f_shift_type ?? null;
        if (!$uid || !$shift_name) return 1;

        $hours_to_str = static function (string $shift_time): int {
            $str_time = 0;
            $time = explode(':', $shift_time);
            if (isset($time[0])) $str_time += (int)$time[0] * 3600;
            if (isset($time[1])) $str_time += (int)$time[1] * 60;
            return $str_time;
        };

        if ($shift_name === 'Day') {
            $res = $this->db->query('SELECT compulsory,f_shift_start,f_shift_stop FROM t_shifts WHERE f_shift_name = "Day"')->getRow();
            $current_time = $hours_to_str(date('H:i', strtotime('now') + $timezone));
            if ($res) {
                if ($res->compulsory === '1') {
                    $shift_stop  = $hours_to_str((string)$res->f_shift_stop);
                    $shift_start = $hours_to_str((string)$res->f_shift_start);
                    $status = ($shift_stop >= $current_time && $current_time >= $shift_start) ? 1 : 0;
                } else {
                    $status = 1;
                }
            } else {
                $status = 1;
            }
        } elseif ($shift_name === 'fst') {
            $res = $this->db->query('SELECT s.f_shift_id,s.f_user_id,ts.f_shift_start,ts.f_shift_stop,ts.compulsory FROM t_user_shift_map AS s JOIN t_shifts ts ON ts.f_shift_id=s.f_shift_id WHERE s.f_user_id=' . (int)$uid)->getRow();
            $current_time = $hours_to_str(date('H:i', strtotime('now') + $timezone));
            if ($res) {
                if ($res->compulsory === '1') {
                    $shift_stop  = $hours_to_str((string)$res->f_shift_stop);
                    $shift_start = $hours_to_str((string)$res->f_shift_start);
                    $status = ($shift_stop >= $current_time && $current_time >= $shift_start) ? 1 : 0;
                } else {
                    $status = 1;
                }
            } else {
                $status = 1;
            }
        }

        return $status;
    }

    // Tank monitor gate
    public function tank_monitor_sol(): int
    {
        $row = $this->db->query('SELECT f_tank_monitor FROM t_adminstrative_options')->getRow();
        return (int)($row->f_tank_monitor ?? 0);
    }

    // Installer period
    public function check_installer_period(int $user_id, int $time_zone): int
    {
        $res = $this->db->table('installer_time_map')->select('days,hours,created')->where('f_user_id', $user_id)->get()->getRow();
        if (!$res) return 1;

        $alloted_days = (int)$res->days;
        $alloted_hours = (int)$res->hours;
        $acc_created = (int)$res->created + $time_zone;
        if ($alloted_days === 0 && $alloted_hours === 0) return 1;

        $date = strtotime('+' . $alloted_days . ' day', $acc_created);
        $exact_alloted_time = strtotime('+' . $alloted_hours . ' hours', $date);
        $present_time = time() + $time_zone;
        if (!$exact_alloted_time) return 1;

        return ($exact_alloted_time >= $present_time) ? 1 : 0;
    }
}
