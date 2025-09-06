-- Shift Templates (From t_shifts, improved)
CREATE TABLE shift_templates (
                                 shift_template_id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                                 shift_name VARCHAR(50) NOT NULL UNIQUE, -- 'Morning', 'Night'
                                 start_time TIME NOT NULL, -- Local time for shift start
                                 end_time TIME NOT NULL,   -- Local time for shift end
                                 is_overnight BOOLEAN NOT NULL DEFAULT FALSE, -- Does shift cross midnight?
                                 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- User Schedules (Links users to shifts on specific days)
CREATE TABLE user_schedules (
                                user_schedule_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                                user_id INT UNSIGNED NOT NULL,
                                shift_template_id SMALLINT UNSIGNED NOT NULL,
                                valid_from DATE NOT NULL, -- Schedule start date
                                valid_until DATE DEFAULT NULL, -- NULL means ongoing
                                is_active BOOLEAN NOT NULL DEFAULT TRUE,
                                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                created_by INT UNSIGNED NOT NULL,
                                FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
                                FOREIGN KEY (shift_template_id) REFERENCES shift_templates(shift_template_id),
                                FOREIGN KEY (created_by) REFERENCES users(user_id),
                                INDEX idx_user_schedules_user (user_id, valid_from, valid_until, is_active)
) ENGINE=InnoDB;

-- Schedule Exceptions (For vacations, holidays, etc.)
CREATE TABLE schedule_exceptions (
                                     exception_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                                     user_id INT UNSIGNED NOT NULL,
                                     exception_type ENUM('vacation', 'sick_leave', 'holiday', 'training', 'other') NOT NULL,
                                     start_date DATE NOT NULL,
                                     end_date DATE NOT NULL,
                                     description TEXT,
                                     is_approved BOOLEAN NOT NULL DEFAULT FALSE,
                                     approved_by INT UNSIGNED DEFAULT NULL,
                                     approved_at DATETIME DEFAULT NULL,
                                     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                     created_by INT UNSIGNED NOT NULL,
                                     FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
                                     FOREIGN KEY (approved_by) REFERENCES users(user_id),
                                     FOREIGN KEY (created_by) REFERENCES users(user_id),
                                     INDEX idx_schedule_exceptions_user (user_id, start_date, end_date)
) ENGINE=InnoDB;