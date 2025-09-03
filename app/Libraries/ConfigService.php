<?php namespace App\Libraries;

use App\Models\ConfigModel;
use InvalidArgumentException;
use ReflectionException;

class ConfigService
{
    protected static array $memoryCache = [];
    protected static string $cacheKey = 'app_config_all';
    protected static int $cacheTTL = 3600;

    /**
     * Allowed config types
     */
    protected static array $validTypes = [
        'string', 'integer', 'boolean', 'array', 'dictionary', 'json'
    ];

    /**
     * Get a config value (typed)
     */
    public static function get(string $key, $default = null)
    {
        // Check memory cache
        if (isset(self::$memoryCache[$key])) {
            return self::$memoryCache[$key];
        }

        // Load from cache or DB
        $configs = cache(self::$cacheKey);
        if (!$configs) {
            $configs = new ConfigModel()->findAll();
            cache()->save(self::$cacheKey, $configs, self::$cacheTTL);
        }

        foreach ($configs as $row) {
            if (($row['config_key'] ?? null) === $key) {
                $value = self::decodeValue($row['config_value'], $row['config_type']);
                self::$memoryCache[$key] = $value;
                return $value;
            }
        }

        return $default;
    }

    /**
     * Set a config value (with type enforcement)
     * @throws ReflectionException
     */
    public static function set(string $key, $value, string $type): void
    {
        if (!in_array($type, self::$validTypes, true)) {
            throw new InvalidArgumentException("Invalid config type: $type");
        }

        // Validate + encode
        $encodedValue = self::encodeValue($value, $type);

        // Save to DB
        $model = new ConfigModel();
        $model->save([
            'config_key'   => $key,
            'config_value' => $encodedValue,
            'config_type'  => $type
        ]);

        // Update in-memory
        self::$memoryCache[$key] = $value;

        $rows = $model->findAll();
        cache()->save(self::$cacheKey, $rows, self::$cacheTTL);
    }

    protected static function decodeValue(string $value, string $type)
    {
        switch ($type) {
            case 'integer': return (int) $value;
            case 'boolean': return filter_var($value, FILTER_VALIDATE_BOOLEAN);
            case 'array':
            case 'dictionary':
            case 'json':
                $decoded = json_decode($value, true);
                return is_array($decoded) ? $decoded : [];
            case 'string':
            default:        return $value;
        }
    }

    protected static function encodeValue($value, string $type): string
    {
        switch ($type) {
            case 'integer':
                if (!is_int($value)) throw new InvalidArgumentException("Expected integer");
                return (string) $value;

            case 'boolean':
                if (!is_bool($value)) throw new InvalidArgumentException("Expected boolean");
                return $value ? 'true' : 'false';

            case 'array':
                // Accept any array shape or a comma-separated string; never throw.
                if (is_string($value)) {
                    $value = array_values(array_filter(array_map('trim', explode(',', $value)), static function ($v) {
                        return $v !== '' && $v !== null;
                    }));
                } elseif (!is_array($value)) {
                    $value = [];
                }
                // Normalize keys to sequential indices
                $value = array_values($value);
                return json_encode($value, JSON_UNESCAPED_UNICODE);

            case 'dictionary':
                if (!is_array($value)) {
                    throw new InvalidArgumentException("Expected associative array (key/value pairs)");
                }
                // If it's a sequential array, convert to dictionary with numeric keys
                if (array_keys($value) === range(0, count($value) - 1)) {
                    $value = (array) $value;
                }
                return json_encode($value, JSON_UNESCAPED_UNICODE);

            case 'json':
                return json_encode($value, JSON_UNESCAPED_UNICODE);

            case 'string':
            default:
                if (!is_string($value)) throw new InvalidArgumentException("Expected string");
                return $value;
        }
    }

    public static function clearCache(): void
    {
        cache()->delete(self::$cacheKey);
        self::$memoryCache = [];
    }

    public static function bulkGet(?array $keys = null): array
    {
        if (empty(self::$memoryCache)) {
            $configs = cache(self::$cacheKey);
            if (!$configs) {
                $configs = new ConfigModel()->findAll();
                cache()->save(self::$cacheKey, $configs, self::$cacheTTL);
            }

            foreach ($configs as $row) {
                if (!isset($row['config_key'])) {
                    continue;
                }
                self::$memoryCache[$row['config_key']] =
                    self::decodeValue($row['config_value'], $row['config_type']);
            }
        }

        if ($keys === null) {
            return self::$memoryCache;
        }

        $result = [];
        foreach ($keys as $key) {
            $result[$key] = self::$memoryCache[$key] ?? null;
        }
        return $result;
    }

    /**
     * @throws ReflectionException
     */
    public static function bulkSet(array $configs): void
    {
        $model = new ConfigModel();

        foreach ($configs as $key => $data) {
            if (!isset($data['value'], $data['type'])) {
                throw new InvalidArgumentException("Missing value/type for config: $key");
            }

            $value = $data['value'];
            $type  = $data['type'];

            if (!in_array($type, self::$validTypes, true)) {
                throw new InvalidArgumentException("Invalid config type: $type");
            }

            $encodedValue = self::encodeValue($value, $type);

            $model->save([
                'config_key'   => $key,
                'config_value' => $encodedValue,
                'config_type'  => $type,
            ]);

            self::$memoryCache[$key] = $value;
        }

        // Persist a consistent rows list and refresh memory on the next request
        $rows = $model->findAll();
        cache()->save(self::$cacheKey, $rows, self::$cacheTTL);
    }
}
