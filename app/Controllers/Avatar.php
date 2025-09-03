<?php
namespace App\Controllers;

use CodeIgniter\HTTP\ResponseInterface;

/**
 * Class Avatar
 * Example: /avatar?name=Jane%20Doe&size=64&bg=0D8ABC&color=FFFFFF
 */
class Avatar extends BaseController
{
    public function index(): ResponseInterface
    {
        $request = $this->request;

        $name  = trim((string)($request->getGet('name') ?? 'User'));
        $size  = (int)($request->getGet('size') ?? 64);
        $size  = max(24, min(512, $size)); // clamp
        $bg    = $request->getGet('bg');        // hex without '#', e.g., 0D8ABC
        $color = $request->getGet('color') ?? 'FFFFFF';

        // Derive initials (first + last)
        $parts     = preg_split('/\s+/', $name, -1, PREG_SPLIT_NO_EMPTY);
        $initials  = strtoupper(substr($parts[0] ?? '', 0, 1) . substr($parts[1] ?? '', 0, 1));
        if ($initials === '') {
            $initials = '?';
        }

        // Deterministic background if not provided
        if (!$bg) {
            $hash = 0;
            foreach (str_split($name) as $c) {
                $hash = ($hash + ord($c)) % 360;
            }
            $palette = ['0D8ABC','7C4DFF','FF7043','26A69A','AB47BC','5C6BC0','EF6C00','00897B'];
            $bg = $palette[$hash % count($palette)];
        }

        $hexToRgb = static function (string $hex): array {
            $hex = ltrim($hex, '#');
            if (strlen($hex) === 3) {
                $hex = $hex[0].$hex[0].$hex[1].$hex[1].$hex[2].$hex[2];
            }
            $int = hexdec($hex);
            return [($int >> 16) & 255, ($int >> 8) & 255, $int & 255];
        };

        // Create square canvas with alpha (transparent background)
        $img = imagecreatetruecolor($size, $size);
        imagesavealpha($img, true);
        imagealphablending($img, true);

        // Transparent background (outside the circle will stay transparent)
        $transparent = imagecolorallocatealpha($img, 0, 0, 0, 127);
        imagefill($img, 0, 0, $transparent);

        // Draw filled circle with background color
        [$r, $g, $b] = $hexToRgb($bg);
        $bgCol = imagecolorallocate($img, $r, $g, $b);
        $cx = intdiv($size, 2); // ensure integers for odd sizes
        $cy = $cx;
        imagefilledellipse($img, $cx, $cy, $size, $size, $bgCol);

        // Text color
        [$tr, $tg, $tb] = $hexToRgb($color);
        $textCol = imagecolorallocate($img, $tr, $tg, $tb);

        // Choose a TTF font if available, else fallback
        // Adjust the path to any .ttf available in your project
        $fontPath = FCPATH . 'assets/fonts/Roboto-Black.ttf';
        $useTtf   = is_file($fontPath) && function_exists('imagettftext');

        if ($useTtf) {
            $fontSize = max(8, (int)round($size * 0.45));
            $bbox = imagettfbbox($fontSize, 0, $fontPath, $initials);
            $textWidth  = $bbox[2] - $bbox[0];
            $textHeight = $bbox[1] - $bbox[7];
            $x = (int)(($size - $textWidth) / 2 - $bbox[0]);
            $y = (int)(($size + $textHeight) / 2 - $bbox[1]);
            imagettftext($img, $fontSize, 0, $x, $y, $textCol, $fontPath, $initials);
        } else {
            $font = 5; // built-in GD font
            $textWidth  = imagefontwidth($font) * strlen($initials);
            $textHeight = imagefontheight($font);
            $x = (int)(($size - $textWidth) / 2);
            $y = (int)(($size - $textHeight) / 2);
            imagestring($img, $font, $x, $y, $initials, $textCol);
        }

        // Prepare response with caching
        $etag = '"' . md5($name . '|' . $size . '|' . $bg . '|' . $color) . '"';
        $ifNoneMatch = trim((string)$request->getHeaderLine('If-None-Match'));

        $response = service('response');
        $response->setHeader('Content-Type', 'image/png');
        $response->setHeader('Cache-Control', 'public, max-age=86400, immutable');
        $response->setHeader('ETag', $etag);

        if ($ifNoneMatch === $etag) {
            imagedestroy($img);
            return $response->setStatusCode(304);
        }

        ob_start();
        imagepng($img);
        $png = ob_get_clean();
        imagedestroy($img);

        return $response->setBody($png);
    }
}
