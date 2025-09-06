-- System Events
INSERT INTO system_events (event_code, event_name, event_description, severity) VALUES
                                                                                    ('user.login', 'User Login', 'User successfully logged into the system', 'info'),
                                                                                    ('user.login_failed', 'Failed Login', 'User failed to login', 'warning'),
                                                                                    ('user.logout', 'User Logout', 'User logged out of the system', 'info'),
                                                                                    ('user.password_change', 'Password Changed', 'User changed their password', 'info'),
                                                                                    ('user.account_locked', 'Account Locked', 'User account was locked due to failed attempts', 'warning'),
                                                                                    ('user.account_unlocked', 'Account Unlocked', 'User account was unlocked', 'info'),

                                                                                    ('dispense.start', 'Dispense Started', 'Dispensing operation started', 'info'),
                                                                                    ('dispense.complete', 'Dispense Completed', 'Dispensing operation completed successfully', 'info'),
                                                                                    ('dispense.failed', 'Dispense Failed', 'Dispensing operation failed', 'error'),
                                                                                    ('dispense.emergency_stop', 'Emergency Stop', 'Dispensing stopped via emergency stop', 'critical'),

                                                                                    ('tank.level_low', 'Tank Level Low', 'Tank level below reorder point', 'warning'),
                                                                                    ('tank.level_critical', 'Tank Level Critical', 'Tank level below shutoff point', 'critical'),
                                                                                    ('tank.level_high', 'Tank Level High', 'Tank level above warning level', 'warning'),
                                                                                    ('tank.adjustment', 'Tank Adjustment', 'Tank inventory was manually adjusted', 'info'),

                                                                                    ('device.online', 'Device Online', 'Device came online', 'info'),
                                                                                    ('device.offline', 'Device Offline', 'Device went offline', 'warning'),
                                                                                    ('device.config_updated', 'Device Configured', 'Device configuration was updated', 'info'),

                                                                                    ('system.config_updated', 'System Configuration Updated', 'System configuration was changed', 'info');

-- Audit Log Entries (demonstrating various scenarios)
INSERT INTO audit_log (user_id, station_id, reel_id, tank_id, device_id, event_id, ip_address, description, metadata) VALUES
                                                                                                                          (2, NULL, NULL, NULL, NULL, 1, '192.168.1.10', 'Jim Strong logged into the system', '{"browser": "Chrome", "os": "Windows 10"}'),
                                                                                                                          (3, 1, 1, 1, NULL, 7, '192.168.1.15', 'Tom Smith started dispensing 5W-30 oil', '{"amount": 5.5, "unit": "gallons", "preset": true}'),
                                                                                                                          (3, 1, 1, 1, NULL, 8, '192.168.1.15', 'Tom Smith completed dispensing 5W-30 oil', '{"amount": 5.5, "unit": "gallons", "duration_seconds": 45}'),
                                                                                                                          (NULL, NULL, NULL, 1, 5, 11, NULL, 'Tank Engine Oil 5W-30 level is low', '{"current_volume": 767.18, "reorder_level": 200.00}'),
                                                                                                                          (5, 2, NULL, 3, 6, 19, '192.168.1.20', 'Service Installer calibrated Bay 2 tank sensor', '{"sensor_type": "probe_6ft", "old_kfactor": 0.95, "new_kfactor": 1.00}'),
                                                                                                                          (NULL, NULL, NULL, NULL, 4, 16, NULL, 'Bay 2 Pump module went offline', '{"serial": "PSM0823065", "downtime_minutes": 15}'),
                                                                                                                          (1, NULL, NULL, NULL, NULL, 21, '192.168.1.5', 'System Administrator updated system configuration', '{"changed_keys": ["session_timeout_minutes", "tank_refresh_frequency_ms"]}');