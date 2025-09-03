<?php

namespace App\Controllers;

use App\Controllers\BaseController;
use App\Models\ReelModel;
use App\Models\StationModel;
use App\Models\CapabilityModel;
use App\Models\DispenseModel;

class ReelsController extends BaseController
{
    public function index()
    {
        $request   = $this->request;

        $userId    = (int) $request->getVar('user_id') ?: 0;
        $roleId    = (int) $request->getVar('role_id') ?: 0;
        $dashboard = (string) $request->getVar('dashboard') ?: '';
        $stationId = (int) $request->getVar('station_id') ?: 0;

        // Locale now comes from the URL segment (e.g. /en/reels)
        $locale = $request->getLocale();

        // Station fallback if not provided
        if ($stationId <= 0) {
            $stationModel = new StationModel();
            $stationId    = (int) ($stationModel->getDefaultStationId() ?? 0);
        }

        // Data queries
        $reelModel      = new ReelModel();
        $reels          = $reelModel->getReelsByStation($stationId);

        $capModel       = new CapabilityModel();
        $capabilities   = $capModel->getCapabilityIdsByUser($userId);

        $dispenseModel  = new DispenseModel();
        $activeReelIds  = $dispenseModel->getActiveReelIds();

        return view('reels/index', [
            'locale'        => $locale,
            'dashboard'     => $dashboard,
            'roleId'        => $roleId,
            'capabilities'  => $capabilities,
            'stationId'     => $stationId,
            'reels'         => $reels,
            'activeReelIds' => $activeReelIds,
        ]);
    }
}
