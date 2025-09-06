-- System Events/Actions (From t_actions, standardized)
CREATE TABLE system_events (
                               event_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                               event_code VARCHAR(50) NOT NULL UNIQUE, -- e.g., 'user.login', 'tank.configured'
                               event_name VARCHAR(200) NOT NULL,
                               event_description TEXT,
                               severity ENUM('info', 'warning', 'error', 'critical') NOT NULL DEFAULT 'info'
) ENGINE=InnoDB;

-- Master Audit Log (Replaces t_systemlog, integrates other logs)
CREATE TABLE audit_log (
                           log_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                           event_timestamp DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), -- High precision
                           user_id INT UNSIGNED DEFAULT NULL, -- Who performed the action
                           station_id SMALLINT UNSIGNED DEFAULT NULL, -- Where did it happen?
                           reel_id INT UNSIGNED DEFAULT NULL,
                           tank_id INT UNSIGNED DEFAULT NULL,
                           device_id INT UNSIGNED DEFAULT NULL,

                           event_id INT UNSIGNED NOT NULL, -- What happened
                           ip_address VARCHAR(45) DEFAULT NULL,
                           user_agent TEXT,

    -- Target Entities (if different from above context)
                           target_user_id INT UNSIGNED DEFAULT NULL,
                           target_tank_id INT UNSIGNED DEFAULT NULL,

    -- Descriptive fields
                           description TEXT NOT NULL, -- Human-readable message
                           old_values JSON DEFAULT NULL, -- State before change (for updates)
                           new_values JSON DEFAULT NULL, -- State after change (for updates)
                           metadata JSON DEFAULT NULL, -- Any other relevant data (e.g., dispensed amount)

                           INDEX idx_audit_timestamp (event_timestamp),
                           INDEX idx_audit_user (user_id, event_timestamp),
                           INDEX idx_audit_event (event_id, event_timestamp),
                           INDEX idx_audit_station (station_id, event_timestamp),
                           INDEX idx_audit_tank (tank_id, event_timestamp),
                           FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,
                           FOREIGN KEY (station_id) REFERENCES stations(station_id) ON DELETE SET NULL,
                           FOREIGN KEY (reel_id) REFERENCES reels(reel_id) ON DELETE SET NULL,
                           FOREIGN KEY (tank_id) REFERENCES tanks(tank_id) ON DELETE SET NULL,
                           FOREIGN KEY (device_id) REFERENCES devices(device_id) ON DELETE SET NULL,
                           FOREIGN KEY (event_id) REFERENCES system_events(event_id),
                           FOREIGN KEY (target_user_id) REFERENCES users(user_id) ON DELETE SET NULL
) ENGINE=InnoDB;