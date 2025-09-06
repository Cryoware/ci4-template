-- Companies & Departments (Normalized from user table)
CREATE TABLE companies (
                           company_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                           company_name VARCHAR(255) NOT NULL UNIQUE,
                           is_active BOOLEAN NOT NULL DEFAULT TRUE,
                           created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                           updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE departments (
                             department_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                             company_id INT UNSIGNED NOT NULL,
                             department_name VARCHAR(255) NOT NULL,
                             is_active BOOLEAN NOT NULL DEFAULT TRUE,
                             created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                             updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                             UNIQUE KEY unique_department (company_id, department_name),
                             FOREIGN KEY (company_id) REFERENCES companies(company_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Application Configuration (Improved from app_config)
CREATE TABLE app_config (
                            config_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                            config_key VARCHAR(100) NOT NULL UNIQUE,
                            config_value TEXT NOT NULL,
                            config_data_type ENUM('string', 'integer', 'boolean', 'array', 'json') NOT NULL DEFAULT 'string',
                            description TEXT,
                            is_public BOOLEAN NOT NULL DEFAULT FALSE, -- Whether it can be read without auth
                            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Languages (From t_languages)
CREATE TABLE languages (
                           language_id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                           language_code CHAR(5) NOT NULL UNIQUE, -- e.g., 'en', 'fr-CA'
                           language_name VARCHAR(50) NOT NULL UNIQUE,
                           is_active BOOLEAN NOT NULL DEFAULT TRUE
) ENGINE=InnoDB;

-- Units (From t_units)
CREATE TABLE units (
                       unit_id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                       unit_name VARCHAR(30) NOT NULL UNIQUE, -- 'Gallons', 'Liters'
                       unit_abbreviation VARCHAR(10) NOT NULL UNIQUE, -- 'gal', 'L'
                       is_volume BOOLEAN NOT NULL DEFAULT TRUE -- Distinguish volume from other units if needed
) ENGINE=InnoDB;

-- Time Zones (From t_time_zone, simplified)
CREATE TABLE time_zones (
                            time_zone_id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                            time_zone_name VARCHAR(100) NOT NULL UNIQUE, -- 'America/New_York'
                            utc_offset VARCHAR(10) NOT NULL, -- '-05:00', '+10:00'
                            is_dst BOOLEAN NOT NULL DEFAULT FALSE
) ENGINE=InnoDB;