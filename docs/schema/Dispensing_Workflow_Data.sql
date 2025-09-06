-- Work Orders
INSERT INTO work_orders (work_order_number, status, created_by) VALUES
                                                                    ('WO-2024-001', 'completed', 3),
                                                                    ('WO-2024-002', 'in_progress', 3),
                                                                    ('WO-2024-003', 'open', 4),
                                                                    ('WO-2024-004', 'closed', 3),
                                                                    ('WO-2024-005', 'open', 4);

-- Dispense Transactions
INSERT INTO dispense_transactions (transaction_type, user_id, station_id, reel_id, tank_id, product_id, work_order_id, preset_amount, actual_amount, unit_id, start_volume, end_volume, start_time, end_time, duration_ms, was_successful) VALUES
                                                                                                                                                                                                                                               ('preset', 3, 1, 1, 1, 5, 1, 5.5, 5.5, 1, 772.68, 767.18, NOW() - INTERVAL 2 HOUR, NOW() - INTERVAL 2 HOUR + INTERVAL 45 SECOND, 45000, TRUE),
                                                                                                                                                                                                                                               ('open', 3, 1, 2, 2, 1, 2, NULL, 2.3, 1, 227.12, 224.82, NOW() - INTERVAL 1 HOUR, NOW() - INTERVAL 1 HOUR + INTERVAL 30 SECOND, 30000, TRUE),
                                                                                                                                                                                                                                               ('preset', 4, 4, 6, 6, 3, 3, 10.0, 10.0, 1, 53.65, 43.65, NOW() - INTERVAL 30 MINUTE, NOW() - INTERVAL 30 MINUTE + INTERVAL 60 SECOND, 60000, TRUE),
                                                                                                                                                                                                                                               ('topoff', 3, 2, 3, 3, 7, 2, 1.0, 1.2, 1, 49.90, 48.70, NOW() - INTERVAL 15 MINUTE, NOW() - INTERVAL 15 MINUTE + INTERVAL 20 SECOND, 20000, TRUE);