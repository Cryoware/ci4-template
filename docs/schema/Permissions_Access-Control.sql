-- User-Station Permissions (Who can use which station)
CREATE TABLE user_station_permissions (
                                          user_id INT UNSIGNED NOT NULL,
                                          station_id SMALLINT UNSIGNED NOT NULL,
    -- Capability could be generalized here if needed, but often just access
                                          can_access BOOLEAN NOT NULL DEFAULT TRUE,
                                          granted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                          granted_by INT UNSIGNED NOT NULL,
                                          PRIMARY KEY (user_id, station_id),
                                          FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
                                          FOREIGN KEY (station_id) REFERENCES stations(station_id) ON DELETE CASCADE,
                                          FOREIGN KEY (granted_by) REFERENCES users(user_id)
) ENGINE=InnoDB;

-- User-Tank Permissions (Who can dispense from which tank)
CREATE TABLE user_tank_permissions (
                                       user_id INT UNSIGNED NOT NULL,
                                       tank_id INT UNSIGNED NOT NULL,
                                       can_dispense BOOLEAN NOT NULL DEFAULT FALSE,
                                       can_override BOOLEAN NOT NULL DEFAULT FALSE, -- Override warnings for *this* tank
                                       granted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                       granted_by INT UNSIGNED NOT NULL,
                                       PRIMARY KEY (user_id, tank_id),
                                       FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
                                       FOREIGN KEY (tank_id) REFERENCES tanks(tank_id) ON DELETE CASCADE,
                                       FOREIGN KEY (granted_by) REFERENCES users(user_id)
) ENGINE=InnoDB;

-- User-Reel Permissions (Who can use which reel)
CREATE TABLE user_reel_permissions (
                                       user_id INT UNSIGNED NOT NULL,
                                       reel_id INT UNSIGNED NOT NULL,
                                       can_dispense BOOLEAN NOT NULL DEFAULT FALSE,
                                       granted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                       granted_by INT UNSIGNED NOT NULL,
                                       PRIMARY KEY (user_id, reel_id),
                                       FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
                                       FOREIGN KEY (reel_id) REFERENCES reels(reel_id) ON DELETE CASCADE,
                                       FOREIGN KEY (granted_by) REFERENCES users(user_id)
) ENGINE=InnoDB;