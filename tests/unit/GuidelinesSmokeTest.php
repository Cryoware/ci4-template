<?php

use CodeIgniter\Test\CIUnitTestCase;

/**
 * @internal
 */
final class GuidelinesSmokeTest extends CIUnitTestCase
{
    public function testPhpunitBootstrapsAndBaseUrlIsSet(): void
    {
        // CI4 test bootstrap should define APPPATH
        $this->assertTrue(defined('APPPATH'));

        // phpunit.xml.dist sets app.baseURL in $_SERVER
        $this->assertSame('http://example.com/', $_SERVER['app.baseURL'] ?? null);
    }
}
