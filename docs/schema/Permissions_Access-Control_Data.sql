-- User-Station Permissions
INSERT INTO user_station_permissions (user_id, station_id, granted_by) VALUES
                                                                           (2, 1, 1), (2, 2, 1), (2, 3, 1), (2, 4, 1), -- Manager has all station access
                                                                           (3, 1, 2), (3, 2, 2), -- Technician can access service bays
                                                                           (4, 4, 2), -- Parts manager only in parts department
                                                                           (5, 1, 1), (5, 2, 1), (5, 3, 1), (5, 4, 1); -- Installer has all access

-- User-Tank Permissions
INSERT INTO user_tank_permissions (user_id, tank_id, can_dispense, can_override, granted_by) VALUES
                                                                                                 (2, 1, TRUE, TRUE, 1), (2, 2, TRUE, TRUE, 1), (2, 3, TRUE, TRUE, 1), (2, 4, TRUE, TRUE, 1), (2, 5, TRUE, TRUE, 1), (2, 6, TRUE, TRUE, 1),
                                                                                                 (3, 1, TRUE, FALSE, 2), (3, 2, TRUE, FALSE, 2), (3, 3, TRUE, FALSE, 2), (3, 4, TRUE, FALSE, 2),
                                                                                                 (4, 6, TRUE, TRUE, 2), -- Parts manager can dispense and override only their tank
                                                                                                 (5, 1, TRUE, TRUE, 1), (5, 2, TRUE, TRUE, 1), (5, 3, TRUE, TRUE, 1), (5, 4, TRUE, TRUE, 1), (5, 5, TRUE, TRUE, 1), (5, 6, TRUE, TRUE, 1);

-- User-Reel Permissions
INSERT INTO user_reel_permissions (user_id, reel_id, granted_by) VALUES
                                                                     (2, 1, 1), (2, 2, 1), (2, 3, 1), (2, 4, 1), (2, 5, 1), (2, 6, 1),
                                                                     (3, 1, 2), (3, 2, 2), (3, 3, 2), (3, 4, 2),
                                                                     (4, 6, 2),
                                                                     (5, 1, 1), (5, 2, 1), (5, 3, 1), (5, 4, 1), (5, 5, 1), (5, 6, 1);