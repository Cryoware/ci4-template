-- Companies & Departments
INSERT INTO companies (company_name) VALUES
                                         ('LiquiDynamics, Inc'),
                                         ('Admiral'),
                                         ('Gartec, Srl'),
                                         ('Test Dealership');

INSERT INTO departments (company_id, department_name) VALUES
                                                          (1, 'Engineering'),
                                                          (1, 'Support'),
                                                          (1, 'Installation'),
                                                          (2, 'Support'),
                                                          (3, 'Support'),
                                                          (4, 'Service'),
                                                          (4, 'Parts'),
                                                          (4, 'Quick Lube');

-- Application Configuration
INSERT INTO app_config (config_key, config_value, config_data_type, description, is_public) VALUES
                                                                                                ('site_name', 'Cryoware', 'string', 'Name displayed throughout the application', TRUE),
                                                                                                ('maintenance_mode', 'false', 'boolean', 'Whether the system is in maintenance mode', TRUE),
                                                                                                ('max_login_attempts', '5', 'integer', 'Maximum failed login attempts before lockout', FALSE),
                                                                                                ('session_timeout_minutes', '30', 'integer', 'User session timeout in minutes', FALSE),
                                                                                                ('allowed_ips', '["192.168.1.1", "192.168.1.2", "10.0.0.0/24"]', 'json', 'IP addresses allowed to access the system', FALSE),
                                                                                                ('tank_refresh_frequency_ms', '2500', 'integer', 'Dashboard tank refresh rate in milliseconds', FALSE);

-- Languages
INSERT INTO languages (language_code, language_name) VALUES
                                                         ('en', 'English'),
                                                         ('fr', 'French'),
                                                         ('it', 'Italian'),
                                                         ('es', 'Spanish'),
                                                         ('de', 'German');

-- Units
INSERT INTO units (unit_name, unit_abbreviation, is_volume) VALUES
                                                                ('Gallons', 'gal', TRUE),
                                                                ('Liters', 'L', TRUE),
                                                                ('Quarts', 'qt', TRUE),
                                                                ('Pints', 'pt', TRUE),
                                                                ('Ounces', 'oz', TRUE);

-- Time Zones
INSERT INTO time_zones (time_zone_name, utc_offset, is_dst) VALUES
                                                                ('America/New_York', '-05:00', TRUE),
                                                                ('America/Chicago', '-06:00', TRUE),
                                                                ('America/Denver', '-07:00', TRUE),
                                                                ('America/Los_Angeles', '-08:00', TRUE),
                                                                ('UTC', '+00:00', FALSE),
                                                                ('Europe/Rome', '+01:00', TRUE);