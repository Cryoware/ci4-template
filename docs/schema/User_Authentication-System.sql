-- Core User Table (Replaces t_users_details)
CREATE TABLE users (
                       user_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                       external_uuid CHAR(36) NOT NULL UNIQUE DEFAULT (UUID()), -- For external systems
                       username VARCHAR(100) NOT NULL UNIQUE,
                       email VARCHAR(255) NOT NULL UNIQUE,
                       first_name VARCHAR(100) NOT NULL,
                       last_name VARCHAR(100) NOT NULL,
                       password_hash VARCHAR(255) NOT NULL, -- Will store BCrypt hash
                       pin_hash VARCHAR(255), -- Hashed PIN for quick station login
                       company_id INT UNSIGNED NOT NULL,
                       department_id INT UNSIGNED,
                       language_id SMALLINT UNSIGNED DEFAULT 1, -- Default English
                       time_zone_id SMALLINT UNSIGNED,

    -- Status Flags
                       is_active BOOLEAN NOT NULL DEFAULT TRUE,
                       is_locked BOOLEAN NOT NULL DEFAULT FALSE,
                       lockout_reason ENUM('failed_attempts', 'manual', 'vacation', 'other') DEFAULT NULL,
                       lockout_until DATETIME DEFAULT NULL,
                       must_change_password BOOLEAN NOT NULL DEFAULT FALSE,
                       agreed_to_terms BOOLEAN NOT NULL DEFAULT FALSE,
                       agreed_to_terms_at DATETIME DEFAULT NULL,

    -- Timestamps
                       last_login_at DATETIME DEFAULT NULL,
                       last_login_ip VARCHAR(45) DEFAULT NULL,
                       last_login_user_agent TEXT,
                       last_logout_at DATETIME DEFAULT NULL,
                       last_logout_type ENUM('user', 'timeout', 'system') DEFAULT NULL, -- How they logged out
                       account_expires_at DATETIME DEFAULT NULL,

                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                       created_by INT UNSIGNED DEFAULT NULL, -- User who created this account
                       updated_by INT UNSIGNED DEFAULT NULL, -- User who last updated this account

                       FOREIGN KEY (company_id) REFERENCES companies(company_id),
                       FOREIGN KEY (department_id) REFERENCES departments(department_id),
                       FOREIGN KEY (language_id) REFERENCES languages(language_id),
                       FOREIGN KEY (time_zone_id) REFERENCES time_zones(time_zone_id),
                       FOREIGN KEY (created_by) REFERENCES users(user_id),
                       FOREIGN KEY (updated_by) REFERENCES users(user_id),
                       INDEX idx_users_company (company_id),
                       INDEX idx_users_status (is_active, is_locked)
) ENGINE=InnoDB;

-- Roles (From t_roles)
CREATE TABLE roles (
                       role_id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                       role_name VARCHAR(50) NOT NULL UNIQUE, -- 'Administrator', 'Technician'
                       role_description TEXT,
                       is_system_role BOOLEAN NOT NULL DEFAULT FALSE, -- Prevents deletion of crucial roles
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Capabilities/Permissions (Consolidated from capabilities/t_capabilities)
CREATE TABLE capabilities (
                              capability_id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                              capability_key VARCHAR(100) NOT NULL UNIQUE, -- e.g., 'preset.dispense', 'workorder.manage'
                              capability_name VARCHAR(100) NOT NULL,
                              capability_description TEXT,
                              module VARCHAR(50) NOT NULL DEFAULT 'system' -- 'dispense', 'workorder', 'report', 'system'
) ENGINE=InnoDB;

-- Links Roles to Capabilities
CREATE TABLE role_capabilities (
                                   role_id SMALLINT UNSIGNED NOT NULL,
                                   capability_id SMALLINT UNSIGNED NOT NULL,
                                   PRIMARY KEY (role_id, capability_id),
                                   FOREIGN KEY (role_id) REFERENCES roles(role_id) ON DELETE CASCADE,
                                   FOREIGN KEY (capability_id) REFERENCES capabilities(capability_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Assigns Roles to Users (Replaces t_user_role_map)
CREATE TABLE user_roles (
                            user_id INT UNSIGNED NOT NULL,
                            role_id SMALLINT UNSIGNED NOT NULL,
                            assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                            assigned_by INT UNSIGNED NOT NULL, -- User who granted this role
                            PRIMARY KEY (user_id, role_id),
                            FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
                            FOREIGN KEY (role_id) REFERENCES roles(role_id) ON DELETE CASCADE,
                            FOREIGN KEY (assigned_by) REFERENCES users(user_id)
) ENGINE=InnoDB;

-- Failed Login Attempts (Improved from t_failed_login_attempts)
CREATE TABLE failed_login_attempts (
                                       attempt_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                                       username VARCHAR(100) NOT NULL, -- Stores attempted username
                                       user_id INT UNSIGNED DEFAULT NULL, -- Populated if username is valid
                                       ip_address VARCHAR(45) NOT NULL,
                                       user_agent TEXT,
                                       attempted_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                       INDEX idx_failed_attempts_ip (ip_address, attempted_at),
                                       INDEX idx_failed_attempts_user (user_id, attempted_at),
                                       INDEX idx_failed_attempts_username (username, attempted_at),
                                       FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- User Sessions (For tracking active sessions)
CREATE TABLE user_sessions (
                               session_id CHAR(40) PRIMARY KEY, -- Session identifier
                               user_id INT UNSIGNED NOT NULL,
                               ip_address VARCHAR(45) NOT NULL,
                               user_agent TEXT,
                               payload TEXT NOT NULL, -- Serialized session data
                               last_activity DATETIME NOT NULL,
                               expires_at DATETIME NOT NULL, -- Explicit expiration time
                               FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
                               INDEX idx_sessions_user_id (user_id),
                               INDEX idx_sessions_last_activity (last_activity)
) ENGINE=InnoDB;