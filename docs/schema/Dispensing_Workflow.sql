-- Work Orders (Simplified from t_workorder_details)
-- This is a starting point. Your t_dispense, t_workorder_details, etc., are complex and would need a separate, detailed analysis based on business logic.

CREATE TABLE work_orders (
                             work_order_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                             work_order_number VARCHAR(50) NOT NULL UNIQUE, -- External ID
    -- ... other work order fields ...
                             status ENUM('open', 'in_progress', 'completed', 'closed', 'cancelled') NOT NULL DEFAULT 'open',
                             created_by INT UNSIGNED NOT NULL,
                             created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                             updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                             FOREIGN KEY (created_by) REFERENCES users(user_id)
) ENGINE=InnoDB;

-- Dispense Transactions (Core record of any fluid movement)
CREATE TABLE dispense_transactions (
                                       transaction_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                                       transaction_type ENUM('preset', 'open', 'topoff', 'adjustment', 'delivery') NOT NULL,

                                       user_id INT UNSIGNED NOT NULL,
                                       station_id SMALLINT UNSIGNED NOT NULL,
                                       reel_id INT UNSIGNED NOT NULL,
                                       tank_id INT UNSIGNED NOT NULL,
                                       product_id INT UNSIGNED NOT NULL,
                                       work_order_id INT UNSIGNED DEFAULT NULL,

    -- Amounts
                                       preset_amount DECIMAL(12, 5),
                                       actual_amount DECIMAL(12, 5) NOT NULL,
                                       unit_id SMALLINT UNSIGNED NOT NULL,

    -- Inventory State
                                       start_volume DECIMAL(12, 5) NOT NULL,
                                       end_volume DECIMAL(12, 5) NOT NULL,

    -- Timestamps
                                       start_time DATETIME(6) NOT NULL,
                                       end_time DATETIME(6) NOT NULL,
                                       duration_ms INT UNSIGNED, -- Calculated duration

    -- Status
                                       was_successful BOOLEAN NOT NULL DEFAULT TRUE,
                                       was_emergency_stop BOOLEAN NOT NULL DEFAULT FALSE,
    -- ... other flags ...

                                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

                                       FOREIGN KEY (user_id) REFERENCES users(user_id),
                                       FOREIGN KEY (station_id) REFERENCES stations(station_id),
                                       FOREIGN KEY (reel_id) REFERENCES reels(reel_id),
                                       FOREIGN KEY (tank_id) REFERENCES tanks(tank_id),
                                       FOREIGN KEY (product_id) REFERENCES products(product_id),
                                       FOREIGN KEY (work_order_id) REFERENCES work_orders(work_order_id),
                                       FOREIGN KEY (unit_id) REFERENCES units(unit_id),
                                       INDEX idx_dispense_user_time (user_id, start_time),
                                       INDEX idx_dispense_tank_time (tank_id, start_time),
                                       INDEX idx_dispense_workorder (work_order_id)
) ENGINE=InnoDB;