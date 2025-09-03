<?php
namespace App\Filters;

use CodeIgniter\Filters\FilterInterface;
use CodeIgniter\HTTP\RequestInterface;
use CodeIgniter\HTTP\ResponseInterface;

class AuthFilter implements FilterInterface
{
    public function before(RequestInterface $request, $arguments = null)
    {
        $session = session();

        // Is user logged in?
        $userId = $session->get('userid');
        if (empty($userId)) {
            // No session -> force logout and redirect to login
            $session->destroy();
            return redirect()->to(site_url('/login'))->with('error', 'Please sign in.');
        }

        // Inactivity timeout
        $now        = time();
        $lastActive = (int) ($session->get('last_activity_time') ?? 0);

        // Use Session expiration as inactivity threshold (fallback: 7200s = 2h)
        $expiration = (int) (config('Session')->expiration ?? 7200);

        if ($lastActive > 0 && ($now - $lastActive) > $expiration) {
            // Session expired by inactivity
            $session->destroy();
            return redirect()->to(site_url('/login'))->with('error', 'Your session has expired. Please sign in again.');
        }

        // Refresh last activity timestamp on every request
        $session->set('last_activity_time', $now);

        // Allow request to continue
        return null;
    }

    public function after(RequestInterface $request, ResponseInterface $response, $arguments = null)
    {
        // No-op
    }
}
