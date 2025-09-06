-- Core Users (Passwords are hashed versions of 'password123')
INSERT INTO users (username, email, first_name, last_name, password_hash, pin_hash, company_id, department_id, language_id, time_zone_id, is_active, agreed_to_terms, agreed_to_terms_at) VALUES
                                                                                                                                                                                              ('admin', 'oilcop@liquidynamics.com', 'LQD', 'Admin', '$2y$12$MK0uxed3TuxbMI9PUwHTXuMOk3qJNlyGQjFgWyadVL4mrF/0Ch.fK', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1, 1, 1, 1, TRUE, TRUE, NOW()),
                                                                                                                                                                                              ('jstrong', 'jim.strong@testdealership.com', 'Jim', 'Strong', '$2y$12$MK0uxed3TuxbMI9PUwHTXuMOk3qJNlyGQjFgWyadVL4mrF/0Ch.fK', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 4, 6, 1, 1, TRUE, TRUE, NOW()),
                                                                                                                                                                                              ('tsmith', 'tom.smith@testdealership.com', 'Tom', 'Smith', '$2y$12$MK0uxed3TuxbMI9PUwHTXuMOk3qJNlyGQjFgWyadVL4mrF/0Ch.fK', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 4, 6, 1, 1, TRUE, TRUE, NOW()),
                                                                                                                                                                                              ('mjones', 'mike.jones@testdealership.com', 'Mike', 'Jones', '$2y$12$MK0uxed3TuxbMI9PUwHTXuMOk3qJNlyGQjFgWyadVL4mrF/0Ch.fK', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 4, 7, 1, 1, TRUE, TRUE, NOW()),
                                                                                                                                                                                              ('sinstaller', 'service.installer@testdealership.com', 'Service', 'Installer', '$2y$12$MK0uxed3TuxbMI9PUwHTXuMOk3qJNlyGQjFgWyadVL4mrF/0Ch.fK', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 4, 8, 1, 1, TRUE, TRUE, NOW());

-- Update created_by to point to admin
UPDATE users SET created_by = 1 WHERE user_id > 1;

-- Roles
INSERT INTO roles (role_name, role_description, is_system_role) VALUES
                                                                    ('System Administrator', 'Full system access and configuration', TRUE),
                                                                    ('Dealership Manager', 'Manager with reporting and user management capabilities', FALSE),
                                                                    ('Service Technician', 'Technician with dispensing capabilities', FALSE),
                                                                    ('Parts Manager', 'Manages inventory and parts', FALSE),
                                                                    ('Installer', 'System installation and maintenance role', FALSE),
                                                                    ('Read Only', 'View-only access for auditing', FALSE);

-- Capabilities
INSERT INTO capabilities (capability_key, capability_name, capability_description, module) VALUES
-- System capabilities
('system.configure', 'Configure System', 'Change system-wide settings', 'system'),
('user.manage', 'Manage Users', 'Create, edit, and delete users', 'system'),
('role.manage', 'Manage Roles', 'Create and assign roles', 'system'),
('report.view', 'View Reports', 'Access all reporting features', 'system'),

-- Station capabilities
('station.manage', 'Manage Stations', 'Configure dispensing stations', 'station'),
('station.access', 'Access Station', 'Login and use a station', 'station'),

-- Tank capabilities
('tank.manage', 'Manage Tanks', 'Configure tanks and sensors', 'tank'),
('tank.dispense', 'Dispense from Tank', 'Dispense fluid from any tank', 'tank'),
('tank.override', 'Override Tank Limits', 'Override safety limits on tanks', 'tank'),
('tank.view', 'View Tank Status', 'View tank levels and status', 'tank'),

-- Dispensing capabilities
('dispense.preset', 'Preset Dispense', 'Perform preset amount dispensing', 'dispense'),
('dispense.open', 'Open Dispense', 'Perform open/free dispensing', 'dispense'),
('dispense.workorder', 'Workorder Dispense', 'Dispense against work orders', 'dispense'),

-- Workorder capabilities
('workorder.create', 'Create Workorders', 'Create new work orders', 'workorder'),
('workorder.manage', 'Manage Workorders', 'Edit and close work orders', 'workorder'),

-- Installation capabilities
('device.configure', 'Configure Devices', 'Set up and configure hardware devices', 'installation'),
('calibration.perform', 'Perform Calibration', 'Calibrate sensors and dispensers', 'installation');

-- Role Capabilities
-- System Administrator gets everything
INSERT INTO role_capabilities (role_id, capability_id)
SELECT 1, capability_id FROM capabilities;

-- Dealership Manager
INSERT INTO role_capabilities (role_id, capability_id) VALUES
                                                           (2, 4), (2, 6), (2, 8), (2, 9), (2, 10), (2, 11), (2, 12), (2, 13), (2, 14), (2, 15);

-- Service Technician
INSERT INTO role_capabilities (role_id, capability_id) VALUES
                                                           (3, 6), (3, 8), (3, 10), (3, 11), (3, 12), (3, 13), (3, 15);

-- Parts Manager
INSERT INTO role_capabilities (role_id, capability_id) VALUES
                                                           (4, 4), (4, 8), (4, 10), (4, 14), (4, 15);

-- Installer
INSERT INTO role_capabilities (role_id, capability_id) VALUES
                                                           (5, 6), (5, 8), (5, 10), (5, 16), (5, 17);

-- Read Only
INSERT INTO role_capabilities (role_id, capability_id) VALUES
                                                           (6, 4), (6, 10);

-- User Roles
INSERT INTO user_roles (user_id, role_id, assigned_by) VALUES
                                                           (1, 1, 1),  -- admin -> System Administrator
                                                           (2, 2, 1),  -- jstrong -> Dealership Manager
                                                           (3, 3, 2),  -- tsmith -> Service Technician (assigned by manager)
                                                           (4, 4, 2),  -- mjones -> Parts Manager
                                                           (5, 5, 1);  -- sinstaller -> Installer

-- Failed Login Attempts (sample data)
INSERT INTO failed_login_attempts (username, user_id, ip_address, user_agent, attempted_at) VALUES
                                                                                                ('jstrong', 2, '192.168.1.15', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36', NOW() - INTERVAL 1 HOUR),
                                                                                                ('unknown_user', NULL, '192.168.1.20', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36', NOW() - INTERVAL 30 MINUTE);