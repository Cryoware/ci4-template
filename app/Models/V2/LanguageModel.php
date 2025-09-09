<?php

namespace App\Models\V2;

use CodeIgniter\Model;

class LanguageModel extends Model
{
    protected $table            = 'languages';
    protected $primaryKey       = 'language_id';
    protected $useAutoIncrement = true;
    protected $returnType       = 'array';
    protected $allowedFields    = ['language_code', 'language_name'];

    public function codeById(?int $languageId): string
    {
        if (empty($languageId) || $languageId <= 0) {
            return 'en';
        }
        $row = $this->asArray()
            ->select('language_code')
            ->where('language_id', $languageId)
            ->first();
        $code = is_array($row) ? ($row['language_code'] ?? '') : '';
        return $code !== '' ? $code : 'en';
    }
}
