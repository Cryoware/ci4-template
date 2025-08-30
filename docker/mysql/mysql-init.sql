-- MySQL 8.4 uses caching_sha2_password by default for new users
-- No need to explicitly set it, but we can verify

-- Create application user (will use caching_sha2_password by default)
CREATE USER IF NOT EXISTS 'codeigniter_user'@'%' IDENTIFIED BY 'userpassword';
GRANT ALL PRIVILEGES ON codeigniter_db.* TO 'codeigniter_user'@'%';
FLUSH PRIVILEGES;

-- Verify authentication plugin usage
SELECT user, host, plugin FROM mysql.user WHERE user IN ('root', 'codeigniter_user');