-- Stations (From t_stations)
CREATE TABLE stations (
                          station_id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                          station_name VARCHAR(100) NOT NULL UNIQUE,
                          location_description TEXT,
                          is_active BOOLEAN NOT NULL DEFAULT TRUE,
                          display_priority SMALLINT NOT NULL DEFAULT 1000,
                          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Products (From t_products, normalized)
CREATE TABLE products (
                          product_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                          customer_product_id VARCHAR(50), -- Their internal ID
                          product_name VARCHAR(100) NOT NULL UNIQUE,
                          description TEXT,
                          specific_gravity DECIMAL(10, 4) NOT NULL DEFAULT 1.0000, -- Density relative to water
                          default_unit_id SMALLINT UNSIGNED NOT NULL, -- Default unit for this product (e.g., Gallons)
                          max_preset_amount DECIMAL(12, 5), -- Max allowed for a preset dispense
                          max_open_amount DECIMAL(12, 5),   -- Max allowed for an open dispense
                          is_collection_only BOOLEAN NOT NULL DEFAULT FALSE, -- Can only be collected, not dispensed?
                          is_active BOOLEAN NOT NULL DEFAULT TRUE,
                          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                          FOREIGN KEY (default_unit_id) REFERENCES units(unit_id)
) ENGINE=InnoDB;

-- Tanks (Consolidated from t_tank_details, t_tank_software, t_tank_configuration)
CREATE TABLE tanks (
                       tank_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                       tank_name VARCHAR(100) NOT NULL UNIQUE,
                       product_id INT UNSIGNED NOT NULL, -- Current product in tank
                       station_id SMALLINT UNSIGNED, -- Primary station for this tank

    -- Physical Configuration
                       tank_shape ENUM('round_vertical', 'round_horizontal', 'rectangular') NOT NULL DEFAULT 'round_vertical',
                       height DECIMAL(10, 3), -- in inches
                       diameter DECIMAL(10, 3), -- for round tanks
                       width DECIMAL(10, 3), -- for rectangular tanks
                       length DECIMAL(10, 3), -- for rectangular tanks
                       capacity DECIMAL(12, 5) NOT NULL, -- Total capacity in default product unit

    -- Current Inventory & Settings
                       current_volume DECIMAL(12, 5) NOT NULL DEFAULT 0,
                       current_height DECIMAL(10, 3), -- Current product height

    -- Alert Levels (in volume)
                       high_level_alarm DECIMAL(12, 5),
                       high_level_warning DECIMAL(12, 5),
                       reorder_level DECIMAL(12, 5),
                       shutoff_level DECIMAL(12, 5),

    -- Status
                       is_locked BOOLEAN NOT NULL DEFAULT FALSE, -- Manual lockout
                       is_active BOOLEAN NOT NULL DEFAULT TRUE,

                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

                       FOREIGN KEY (product_id) REFERENCES products(product_id),
                       FOREIGN KEY (station_id) REFERENCES stations(station_id),
                       INDEX idx_tanks_station (station_id)
) ENGINE=InnoDB;

-- Tank-Station Mapping (Many-to-Many, if a tank serves multiple stations)
CREATE TABLE tank_station_map (
                                  tank_id INT UNSIGNED NOT NULL,
                                  station_id SMALLINT UNSIGNED NOT NULL,
                                  PRIMARY KEY (tank_id, station_id),
                                  FOREIGN KEY (tank_id) REFERENCES tanks(tank_id) ON DELETE CASCADE,
                                  FOREIGN KEY (station_id) REFERENCES stations(station_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Reels (From t_reel_data, modernized)
CREATE TABLE reels (
                       reel_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                       reel_name VARCHAR(100) NOT NULL,
                       station_id SMALLINT UNSIGNED NOT NULL,
                       tank_id INT UNSIGNED NOT NULL, -- Which tank this reel draws from
                       is_active BOOLEAN NOT NULL DEFAULT TRUE,

    -- Calibration Data
                       k_factor DECIMAL(20, 12) NOT NULL DEFAULT 1.0, -- Pulses per unit volume
                       pulse_count INT NOT NULL DEFAULT 0, -- Total lifetime pulses
                       last_calibration_date DATE,

                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

                       FOREIGN KEY (station_id) REFERENCES stations(station_id),
                       FOREIGN KEY (tank_id) REFERENCES tanks(tank_id),
                       UNIQUE KEY unique_reel_station (reel_name, station_id), -- Reel name unique per station
                       INDEX idx_reels_station (station_id)
) ENGINE=InnoDB;

-- Hardware Devices (Consolidated from t_devices, t_devices_software)
CREATE TABLE device_types (
                              device_type_id TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                              type_code VARCHAR(10) NOT NULL UNIQUE, -- 'CDM', 'PSM', 'TMM'
                              type_name VARCHAR(50) NOT NULL UNIQUE, -- 'Controller/Dispenser Module'
                              description TEXT
) ENGINE=InnoDB;

CREATE TABLE devices (
                         device_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                         device_type_id TINYINT UNSIGNED NOT NULL,
                         serial_number VARCHAR(60) NOT NULL UNIQUE,
                         name VARCHAR(100), -- User-friendly name (e.g., "Bay 1 CDM")

    -- Network/Communication Info (From t_network_settings, t_controller_info)
                         ip_address VARCHAR(45),
                         port_number VARCHAR(10),
                         mac_address VARCHAR(30),
                         signal_strength SMALLINT UNSIGNED, -- 0-100%

    -- RF Specific (From t_rf_channel_frequency_mapping)
                         rf_frequency_channel SMALLINT UNSIGNED, -- Channel index
                         rf_frequency_value VARCHAR(25), -- Actual frequency '919.5 MHz'

    -- Relationships
                         parent_device_id INT UNSIGNED DEFAULT NULL, -- For PSM/TMM -> CDM hierarchy

    -- Status
                         is_configured BOOLEAN NOT NULL DEFAULT FALSE,
                         is_online BOOLEAN NOT NULL DEFAULT FALSE,
                         last_communication DATETIME DEFAULT NULL, -- Last successful check-in
                         last_config_update DATETIME DEFAULT NULL,

                         created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                         updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

                         FOREIGN KEY (device_type_id) REFERENCES device_types(device_type_id),
                         FOREIGN KEY (parent_device_id) REFERENCES devices(device_id),
                         INDEX idx_devices_serial (serial_number),
                         INDEX idx_devices_type (device_type_id),
                         INDEX idx_devices_parent (parent_device_id)
) ENGINE=InnoDB;

-- Sensors (From t_sensor, improved)
CREATE TABLE sensors (
                         sensor_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                         tank_id INT UNSIGNED NOT NULL,
                         device_id INT UNSIGNED, -- Link to TMM device
                         port_number TINYINT UNSIGNED, -- Port on the TMM

    -- Sensor Properties
                         sensor_type ENUM('probe_6ft', 'probe_10ft', 'probe_20ft', 'probe_30ft', 'transducer_10ft', 'transducer_20ft', 'transducer_30ft', 'transducer_54in') NOT NULL,
                         cable_length DECIMAL(8, 2),
                         cable_unit VARCHAR(20) DEFAULT 'feet',

                         is_active BOOLEAN NOT NULL DEFAULT TRUE,
                         installed_date DATE,

                         created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                         updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

                         FOREIGN KEY (tank_id) REFERENCES tanks(tank_id) ON DELETE CASCADE,
                         FOREIGN KEY (device_id) REFERENCES devices(device_id) ON DELETE SET NULL,
                         UNIQUE KEY unique_sensor_device_port (device_id, port_number), -- Prevent port conflict on a device
                         INDEX idx_sensors_tank (tank_id)
) ENGINE=InnoDB;