<?php

namespace App\Controllers;

use App\Controllers\BaseController;
use App\Models\TankModel;
use Config\App;

class TankController extends BaseController
{
    public function index(): string
    {
        // If a query parameter (?lang=xx) is present and supported, override.
        $supported = config(App::class)->supportedLocales ?? [];
        $langParam = $this->request->getGet('lang');
        if ($langParam && in_array($langParam, $supported, true)) {
            $this->request->setLocale($langParam);
        }
        // Otherwise, CodeIgniter will auto-negotiate from Accept-Language if enabled in App.php

        $limit = $this->request->getGetPost('limit');
        $role  = $this->request->getGetPost('role') ?? '';
        $page  = $this->request->getGetPost('page') ?? '';

        $tankModel = new TankModel();

        // Get tanks (limit applied in SQL only if provided)
        $tanks = $tankModel->getTanks(
            is_numeric($limit) ? (int) $limit : null
        );

        // For “Show More Tanks” logic we need a count or a query without limit.
        $totalCount = $tankModel->getCount();

        $data = [
            'role'        => $role,
            'page'        => $page,
            'limit'       => is_numeric($limit) ? (int) $limit : null,
            'tanks'       => $tanks,
            'totalCount'  => $totalCount,
            'locale'      => $this->request->getLocale(), // expose for frontend libs
            'PageTitle'   => 'Tanks',
        ];

        return view('tank/details', $data);
    }

    public function get_tanks($role = '')
    {
        $role = $role ?: $this->request->getGet('role');
        $lang = $this->request->getGet('lang') ?: 'English';
        $limit = $this->request->getGet('limit');
        $page = $this->request->getGet('page') ?: '';

        // Get tank data
        $tanks = $this->tank_model->getTanksWithDetails($limit);

        // Process language
        $lang_file = $this->processLanguage($lang);

        // Load language file
        $language = $this->loadLanguageFile($lang_file);

        $data = [
            'tanks' => $tanks,
            'role' => $role,
            'lang' => $language,
            'page' => $page,
            'limit' => $limit
        ];

        return view('App\Views\tank\tank_details_ajax', $data);
    }

    private function processLanguage($lang)
    {
        $lang_map = [
            'English' => 'en',
            'French' => 'French',
            'Italian' => 'Italian',
            'Spanish' => 'Spanish',
            'German' => 'German',
            'Finnish' => 'Finnish',
            'Chinese' => 'Chinese',
            'Cyrillic' => 'Cyrillic'
        ];

        return $lang_map[$lang] ?? 'en';
    }

    private function loadLanguageFile($lang_file)
    {
        $lang_path = APPPATH . 'Language/' . $lang_file . '/Lang.php';

        // Initialize empty lang array
        $lang = [];

        if (file_exists($lang_path)) {
            include $lang_path;
        }

        // Provide default fallback values for common keys
        $default_lang = [
            'product' => 'Product',
            'capacity' => 'Capacity',
            'contents' => 'Contents',
            'ullage' => 'Ullage',
            'highlevel_shutoff' => 'High Level Shutoff',
            'highlevel_warning' => 'High Level Warning',
            'reorder_level' => 'Reorder Level',
            'lowlevel_shutoff' => 'Low Level Shutoff',
            'normal' => 'Normal',
            'gallons' => 'Gallons',
            'liters' => 'Liters',
            'quarts' => 'Quarts',
            'pints' => 'Pints'
        ];

        // Merge with defaults to ensure all keys exist
        return array_merge($default_lang, $lang);
    }

}
