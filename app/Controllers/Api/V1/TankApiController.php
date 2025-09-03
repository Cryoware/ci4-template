<?php

declare(strict_types=1);

namespace App\Controllers\Api\V1;

use App\Controllers\BaseController;
use App\Models\TankModel;
use CodeIgniter\HTTP\ResponseInterface;

final class TankApiController extends BaseController
{
    public function index(): ResponseInterface
    {
        $limit = $this->request->getGet('limit');
        $limit = is_numeric($limit) ? max(1, (int)$limit) : null;

        $model = new TankModel();
        $tanks = $model->getTanks($limit);

        // Compute a cheap version/etag (change this to your real “last updated” source)
        $versionSeed = implode('|', array_map(
            static fn(array $t) => ($t['f_tank_id'] ?? 0) . ':' . ($t['SensorStatus'] ?? '') . ':' . ($t['f_tank_present'] ?? ''),
            $tanks
        ));
        $etag = '"' . sha1($versionSeed) . '"';

        // If-None-Match support to avoid sending the body if nothing changed
        $ifNoneMatch = $this->request->getHeaderLine('If-None-Match');
        if ($ifNoneMatch && trim($ifNoneMatch) === $etag) {
            return $this->response
                ->setStatusCode(304)
                ->setHeader('ETag', $etag);
        }

        return $this->response
            ->setHeader('Cache-Control', 'no-cache, must-revalidate')
            ->setHeader('ETag', $etag)
            ->setJSON([
                'data' => $tanks,
                'meta' => [
                    'count' => count($tanks),
                    'etag'  => $etag,
                ],
            ]);
    }

    public function show(int $id): ResponseInterface
    {
        $model = new TankModel();
        $all = $model->getTanks();
        $tank = null;
        foreach ($all as $t) {
            if ((int)($t['f_tank_id'] ?? 0) === $id) { $tank = $t; break; }
        }
        if (!$tank) {
            return $this->response->setStatusCode(404)->setJSON(['error' => 'Not found']);
        }
        $etag = '"' . sha1(json_encode([$tank['f_tank_id'] ?? 0, $tank['SensorStatus'] ?? '', $tank['f_tank_present'] ?? ''])) . '"';
        if ($this->request->getHeaderLine('If-None-Match') === $etag) {
            return $this->response->setStatusCode(304)->setHeader('ETag', $etag);
        }
        return $this->response->setHeader('ETag', $etag)->setJSON(['data' => $tank]);
    }

    // Optional: SSE stream for near real-time updates (see notes below)
    public function stream(): void
    {
        // IMPORTANT: run behind a worker that allows long-running PHP (CLI server, RoadRunner, Swoole, or tuned FPM).
        // Keep connection ~60s and let the client reconnect.
        $this->response
            ->setHeader('Content-Type', 'text/event-stream')
            ->setHeader('Cache-Control', 'no-cache')
            ->setHeader('Connection', 'keep-alive');

        $model = new TankModel();
        $lastEtag = '';
        $started = time();
        while (time() - $started < 60) { // 60-second window
            $tanks = $model->getTanks();
            $seed = implode('|', array_map(
                static fn(array $t) => ($t['f_tank_id'] ?? 0) . ':' . ($t['SensorStatus'] ?? '') . ':' . ($t['f_tank_present'] ?? ''),
                $tanks
            ));
            $etag = sha1($seed);
            if ($etag !== $lastEtag) {
                $lastEtag = $etag;
                echo "event: tanks\n";
                echo 'data: ' . json_encode(['data' => $tanks, 'etag' => $etag]) . "\n\n";
                @ob_flush(); @flush();
            }
            usleep(750000); // 0.75s tick
        }
        // Let the script end; the browser will reconnect.
    }
}