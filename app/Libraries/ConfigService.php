<?php namespace App\Libraries;

use App\Models\ConfigModel;
use InvalidArgumentException;

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
            $configs = (new ConfigModel())->findAll();
            cache()->save(self::$cacheKey, $configs, self::$cacheTTL);
        }

        foreach ($configs as $row) {
            if ($row['config_key'] === $key) {
                $value = self::decodeValue($row['config_value'], $row['config_type']);
                self::$memoryCache[$key] = $value;
                return $value;
            }
        }

        return $default;
    }

    /**
     * Set a config value (with type enforcement)
     */
    public static function set(string $key, $value, string $type)
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

        // Update caches
        self::$memoryCache[$key] = $value;
        $configs = cache(self::$cacheKey) ?? [];
        $configs[$key] = [
            'config_key'   => $key,
            'config_value' => $encodedValue,
            'config_type'  => $type,
        ];
        cache()->save(self::$cacheKey, $configs, self::$cacheTTL);
    }

    /**
     * Convert DB string into PHP type
     */
    protected static function decodeValue(string $value, string $type)
    {
        switch ($type) {
            case 'integer': return (int) $value;
            case 'boolean': return filter_var($value, FILTER_VALIDATE_BOOLEAN);
            case 'array':
            case 'dictionary':
            case 'json':    return json_decode($value, true);
            case 'string':
            default:        return $value;
        }
    }

    /**
     * Validate + convert PHP type into DB string
     */
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
                if (!is_array($value) || array_keys($value) !== range(0, count($value) - 1)) {
                    throw new InvalidArgumentException("Expected array of values");
                }
                return json_encode($value);

            case 'dictionary':
                if (!is_array($value) || array_keys($value) === range(0, count($value) - 1)) {
                    throw new InvalidArgumentException("Expected associative array (key/value pairs)");
                }
                return json_encode($value);

            case 'json':
                return json_encode($value);

            case 'string':
            default:
                if (!is_string($value)) throw new InvalidArgumentException("Expected string");
                return $value;
        }
    }

    public static function clearCache()
    {
        cache()->delete(self::$cacheKey);
        self::$memoryCache = [];
    }

    /**
     * Bulk get multiple config values.
     *
     * @param array|null $keys If null, returns ALL configs
     * @return array key => value
     */
    public static function bulkGet(array $keys = null): array
    {
        // Prefer memory cache
        if (empty(self::$memoryCache)) {
            $configs = cache(self::$cacheKey);
            if (!$configs) {
                $configs = (new ConfigModel())->findAll();
                cache()->save(self::$cacheKey, $configs, self::$cacheTTL);
            }

            foreach ($configs as $row) {
                self::$memoryCache[$row['config_key']] =
                    self::decodeValue($row['config_value'], $row['config_type']);
            }
        }

        if ($keys === null) {
            return self::$memoryCache;
        }

        // Return only requested keys
        $result = [];
        foreach ($keys as $key) {
            $result[$key] = self::$memoryCache[$key] ?? null;
        }
        return $result;
    }

    /**
     * Bulk set multiple configs.
     * Expects array of [key => ['value' => ..., 'type' => ...]]
     *
     * @param array $configs
     * @return void
     */
    public static function bulkSet(array $configs): void
    {
        $model = new ConfigModel();

        foreach ($configs as $key => $data) {
            if (!isset($data['value'], $data['type'])) {
                throw new \InvalidArgumentException("Missing value/type for config: $key");
            }

            $value = $data['value'];
            $type  = $data['type'];

            if (!in_array($type, self::$validTypes, true)) {
                throw new \InvalidArgumentException("Invalid config type: $type");
            }

            $encodedValue = self::encodeValue($value, $type);

            $model->save([
                'config_key'   => $key,
                'config_value' => $encodedValue,
                'config_type'  => $type,
            ]);

            // Update in-memory
            self::$memoryCache[$key] = $value;
        }

        // Refresh full cache
        $rows = $model->findAll();
        $allConfigs = [];
        foreach ($rows as $row) {
            $allConfigs[$row['config_key']] = $row;
        }
        cache()->save(self::$cacheKey, $allConfigs, self::$cacheTTL);
    }

}
