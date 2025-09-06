-- Shift Templates
INSERT INTO shift_templates (shift_name, start_time, end_time, is_overnight) VALUES
                                                                                 ('Morning Shift', '08:00:00', '16:00:00', FALSE),
                                                                                 ('Evening Shift', '16:00:00', '00:00:00', TRUE),
                                                                                 ('Night Shift', '00:00:00', '08:00:00', TRUE),
                                                                                 ('Weekend Shift', '09:00:00', '17:00:00', FALSE);

-- User Schedules
INSERT INTO user_schedules (user_id, shift_template_id, valid_from, valid_until, created_by) VALUES
                                                                                                 (3, 1, '2024-01-01', '2024-12-31', 2),  -- tsmith on morning shift
                                                                                                 (4, 2, '2024-01-01', '2024-06-30', 2),  -- mjones on evening shift (until June)
                                                                                                 (4, 1, '2024-07-01', NULL, 2),          -- mjones switches to morning shift in July
                                                                                                 (5, 3, '2024-01-01', NULL, 1);          -- installer on night shift

-- Schedule Exceptions (Vacations, etc.)
INSERT INTO schedule_exceptions (user_id, exception_type, start_date, end_date, description, is_approved, approved_by, created_by) VALUES
                                                                                                                                       (3, 'vacation', '2024-07-15', '2024-07-22', 'Summer vacation', TRUE, 2, 3),
                                                                                                                                       (4, 'training', '2024-03-10', '2024-03-12', 'Product training seminar', TRUE, 2, 4),
                                                                                                                                       (3, 'sick_leave', '2024-05-01', '2024-05-03', 'Medical leave', FALSE, NULL, 3); -- Not yet approved