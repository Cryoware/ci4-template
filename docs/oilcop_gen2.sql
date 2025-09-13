-- MySQL dump 10.13  Distrib 8.4.6, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: oilcop_gen2
-- ------------------------------------------------------
-- Server version	8.4.6

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `app_config`
--

DROP TABLE IF EXISTS `app_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `app_config` (
  `config_id` int unsigned NOT NULL AUTO_INCREMENT,
  `config_key` varchar(100) NOT NULL,
  `config_value` text NOT NULL,
  `config_data_type` enum('string','integer','boolean','array','json') NOT NULL DEFAULT 'string',
  `description` text,
  `is_public` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`config_id`),
  UNIQUE KEY `config_key` (`config_key`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `app_config`
--

LOCK TABLES `app_config` WRITE;
/*!40000 ALTER TABLE `app_config` DISABLE KEYS */;
INSERT INTO `app_config` VALUES (1,'site_name','Cryoware','string','Name displayed throughout the application',1,'2025-09-06 01:38:33','2025-09-06 01:38:33'),(2,'maintenance_mode','false','boolean','Whether the system is in maintenance mode',1,'2025-09-06 01:38:33','2025-09-06 01:38:33'),(3,'max_login_attempts','5','integer','Maximum failed login attempts before lockout',0,'2025-09-06 01:38:33','2025-09-06 01:38:33'),(4,'session_timeout_minutes','30','integer','User session timeout in minutes',0,'2025-09-06 01:38:33','2025-09-06 01:38:33'),(5,'allowed_ips','[\"192.168.1.1\", \"192.168.1.2\", \"10.0.0.0/24\"]','json','IP addresses allowed to access the system',0,'2025-09-06 01:38:33','2025-09-06 01:38:33'),(6,'tank_refresh_frequency_ms','2500','integer','Dashboard tank refresh rate in milliseconds',0,'2025-09-06 01:38:33','2025-09-06 01:38:33');
/*!40000 ALTER TABLE `app_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `audit_log`
--

DROP TABLE IF EXISTS `audit_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `audit_log` (
  `log_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `event_timestamp` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `user_id` int unsigned DEFAULT NULL,
  `station_id` smallint unsigned DEFAULT NULL,
  `reel_id` int unsigned DEFAULT NULL,
  `tank_id` int unsigned DEFAULT NULL,
  `device_id` int unsigned DEFAULT NULL,
  `event_id` int unsigned NOT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text,
  `target_user_id` int unsigned DEFAULT NULL,
  `target_tank_id` int unsigned DEFAULT NULL,
  `description` text NOT NULL,
  `old_values` json DEFAULT NULL,
  `new_values` json DEFAULT NULL,
  `metadata` json DEFAULT NULL,
  PRIMARY KEY (`log_id`),
  KEY `idx_audit_timestamp` (`event_timestamp`),
  KEY `idx_audit_user` (`user_id`,`event_timestamp`),
  KEY `idx_audit_event` (`event_id`,`event_timestamp`),
  KEY `idx_audit_station` (`station_id`,`event_timestamp`),
  KEY `idx_audit_tank` (`tank_id`,`event_timestamp`),
  KEY `reel_id` (`reel_id`),
  KEY `device_id` (`device_id`),
  KEY `target_user_id` (`target_user_id`),
  CONSTRAINT `audit_log_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  CONSTRAINT `audit_log_ibfk_2` FOREIGN KEY (`station_id`) REFERENCES `stations` (`station_id`) ON DELETE SET NULL,
  CONSTRAINT `audit_log_ibfk_3` FOREIGN KEY (`reel_id`) REFERENCES `reels` (`reel_id`) ON DELETE SET NULL,
  CONSTRAINT `audit_log_ibfk_4` FOREIGN KEY (`tank_id`) REFERENCES `tanks` (`tank_id`) ON DELETE SET NULL,
  CONSTRAINT `audit_log_ibfk_5` FOREIGN KEY (`device_id`) REFERENCES `devices` (`device_id`) ON DELETE SET NULL,
  CONSTRAINT `audit_log_ibfk_6` FOREIGN KEY (`event_id`) REFERENCES `system_events` (`event_id`),
  CONSTRAINT `audit_log_ibfk_7` FOREIGN KEY (`target_user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_log`
--

LOCK TABLES `audit_log` WRITE;
/*!40000 ALTER TABLE `audit_log` DISABLE KEYS */;
INSERT INTO `audit_log` VALUES (1,'2025-09-06 01:53:39.204430',2,NULL,NULL,NULL,NULL,1,'192.168.1.10',NULL,NULL,NULL,'Jim Strong logged into the system',NULL,NULL,'{\"os\": \"Windows 10\", \"browser\": \"Chrome\"}'),(2,'2025-09-06 01:53:39.204430',3,1,1,1,NULL,7,'192.168.1.15',NULL,NULL,NULL,'Tom Smith started dispensing 5W-30 oil',NULL,NULL,'{\"unit\": \"gallons\", \"amount\": 5.5, \"preset\": true}'),(3,'2025-09-06 01:53:39.204430',3,1,1,1,NULL,8,'192.168.1.15',NULL,NULL,NULL,'Tom Smith completed dispensing 5W-30 oil',NULL,NULL,'{\"unit\": \"gallons\", \"amount\": 5.5, \"duration_seconds\": 45}'),(4,'2025-09-06 01:53:39.204430',NULL,NULL,NULL,1,5,11,NULL,NULL,NULL,NULL,'Tank Engine Oil 5W-30 level is low',NULL,NULL,'{\"reorder_level\": 200.0, \"current_volume\": 767.18}'),(5,'2025-09-06 01:53:39.204430',5,2,NULL,3,6,17,'192.168.1.20',NULL,NULL,NULL,'Service Installer calibrated Bay 2 tank sensor',NULL,NULL,'{\"new_kfactor\": 1.0, \"old_kfactor\": 0.95, \"sensor_type\": \"probe_6ft\"}'),(6,'2025-09-06 01:53:39.204430',NULL,NULL,NULL,NULL,4,16,NULL,NULL,NULL,NULL,'Bay 2 Pump module went offline',NULL,NULL,'{\"serial\": \"PSM0823065\", \"downtime_minutes\": 15}'),(7,'2025-09-06 01:53:39.204430',1,NULL,NULL,NULL,NULL,18,'192.168.1.5',NULL,NULL,NULL,'System Administrator updated system configuration',NULL,NULL,'{\"changed_keys\": [\"session_timeout_minutes\", \"tank_refresh_frequency_ms\"]}');
/*!40000 ALTER TABLE `audit_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `capabilities`
--

DROP TABLE IF EXISTS `capabilities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `capabilities` (
  `capability_id` smallint unsigned NOT NULL AUTO_INCREMENT,
  `capability_key` varchar(100) NOT NULL,
  `capability_name` varchar(100) NOT NULL,
  `capability_description` text,
  `module` varchar(50) NOT NULL DEFAULT 'system',
  PRIMARY KEY (`capability_id`),
  UNIQUE KEY `capability_key` (`capability_key`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `capabilities`
--

LOCK TABLES `capabilities` WRITE;
/*!40000 ALTER TABLE `capabilities` DISABLE KEYS */;
INSERT INTO `capabilities` VALUES (1,'system.configure','Configure System','Change system-wide settings','system'),(2,'user.manage','Manage Users','Create, edit, and delete users','system'),(3,'role.manage','Manage Roles','Create and assign roles','system'),(4,'report.view','View Reports','Access all reporting features','system'),(5,'station.manage','Manage Stations','Configure dispensing stations','station'),(6,'station.access','Access Station','Login and use a station','station'),(7,'tank.manage','Manage Tanks','Configure tanks and sensors','tank'),(8,'tank.dispense','Dispense from Tank','Dispense fluid from any tank','tank'),(9,'tank.override','Override Tank Limits','Override safety limits on tanks','tank'),(10,'tank.view','View Tank Status','View tank levels and status','tank'),(11,'dispense.preset','Preset Dispense','Perform preset amount dispensing','dispense'),(12,'dispense.open','Open Dispense','Perform open/free dispensing','dispense'),(13,'dispense.workorder','Workorder Dispense','Dispense against work orders','dispense'),(14,'workorder.create','Create Workorders','Create new work orders','workorder'),(15,'workorder.manage','Manage Workorders','Edit and close work orders','workorder'),(16,'device.configure','Configure Devices','Set up and configure hardware devices','installation'),(17,'calibration.perform','Perform Calibration','Calibrate sensors and dispensers','installation');
/*!40000 ALTER TABLE `capabilities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `companies`
--

DROP TABLE IF EXISTS `companies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `companies` (
  `company_id` int unsigned NOT NULL AUTO_INCREMENT,
  `company_name` varchar(255) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`company_id`),
  UNIQUE KEY `company_name` (`company_name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `companies`
--

LOCK TABLES `companies` WRITE;
/*!40000 ALTER TABLE `companies` DISABLE KEYS */;
INSERT INTO `companies` VALUES (1,'LiquiDynamics, Inc',1,'2025-09-06 01:38:33','2025-09-06 01:38:33'),(2,'Admiral',1,'2025-09-06 01:38:33','2025-09-06 01:38:33'),(3,'Gartec, Srl',1,'2025-09-06 01:38:33','2025-09-06 01:38:33'),(4,'Test Dealership',1,'2025-09-06 01:38:33','2025-09-06 01:38:33');
/*!40000 ALTER TABLE `companies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `departments`
--

DROP TABLE IF EXISTS `departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `departments` (
  `department_id` int unsigned NOT NULL AUTO_INCREMENT,
  `company_id` int unsigned NOT NULL,
  `department_name` varchar(255) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`department_id`),
  UNIQUE KEY `unique_department` (`company_id`,`department_name`),
  CONSTRAINT `departments_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `companies` (`company_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departments`
--

LOCK TABLES `departments` WRITE;
/*!40000 ALTER TABLE `departments` DISABLE KEYS */;
INSERT INTO `departments` VALUES (1,1,'Engineering',1,'2025-09-06 01:38:33','2025-09-06 01:38:33'),(2,1,'Support',1,'2025-09-06 01:38:33','2025-09-06 01:38:33'),(3,1,'Installation',1,'2025-09-06 01:38:33','2025-09-06 01:38:33'),(4,2,'Support',1,'2025-09-06 01:38:33','2025-09-06 01:38:33'),(5,3,'Support',1,'2025-09-06 01:38:33','2025-09-06 01:38:33'),(6,4,'Service',1,'2025-09-06 01:38:33','2025-09-06 01:38:33'),(7,4,'Parts',1,'2025-09-06 01:38:33','2025-09-06 01:38:33'),(8,4,'Quick Lube',1,'2025-09-06 01:38:33','2025-09-06 01:38:33');
/*!40000 ALTER TABLE `departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_types`
--

DROP TABLE IF EXISTS `device_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `device_types` (
  `device_type_id` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `type_code` varchar(10) NOT NULL,
  `type_name` varchar(50) NOT NULL,
  `description` text,
  PRIMARY KEY (`device_type_id`),
  UNIQUE KEY `type_code` (`type_code`),
  UNIQUE KEY `type_name` (`type_name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_types`
--

LOCK TABLES `device_types` WRITE;
/*!40000 ALTER TABLE `device_types` DISABLE KEYS */;
INSERT INTO `device_types` VALUES (1,'CDM','Controller/Dispenser Module','Main controller for dispensing units'),(2,'PSM','Pump/Solenoid Module','Pump and solenoid control module'),(3,'TMM','Tank Monitor Module','Tank level monitoring module'),(4,'RPSM','Remote Pump/Solenoid Module','Remote pump/solenoid module');
/*!40000 ALTER TABLE `device_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `devices`
--

DROP TABLE IF EXISTS `devices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `devices` (
  `device_id` int unsigned NOT NULL AUTO_INCREMENT,
  `device_type_id` tinyint unsigned NOT NULL,
  `serial_number` varchar(60) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `port_number` varchar(10) DEFAULT NULL,
  `mac_address` varchar(30) DEFAULT NULL,
  `signal_strength` smallint unsigned DEFAULT NULL,
  `rf_frequency_channel` smallint unsigned DEFAULT NULL,
  `rf_frequency_value` varchar(25) DEFAULT NULL,
  `parent_device_id` int unsigned DEFAULT NULL,
  `is_configured` tinyint(1) NOT NULL DEFAULT '0',
  `is_online` tinyint(1) NOT NULL DEFAULT '0',
  `last_communication` datetime DEFAULT NULL,
  `last_config_update` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`device_id`),
  UNIQUE KEY `serial_number` (`serial_number`),
  KEY `idx_devices_serial` (`serial_number`),
  KEY `idx_devices_type` (`device_type_id`),
  KEY `idx_devices_parent` (`parent_device_id`),
  CONSTRAINT `devices_ibfk_1` FOREIGN KEY (`device_type_id`) REFERENCES `device_types` (`device_type_id`),
  CONSTRAINT `devices_ibfk_2` FOREIGN KEY (`parent_device_id`) REFERENCES `devices` (`device_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `devices`
--

LOCK TABLES `devices` WRITE;
/*!40000 ALTER TABLE `devices` DISABLE KEYS */;
INSERT INTO `devices` VALUES (1,1,'CDM0823041','Bay 1 Controller','192.168.5.10','1200',NULL,NULL,NULL,NULL,NULL,1,1,NULL,NULL,'2025-09-06 01:41:45','2025-09-06 01:41:45'),(2,1,'CDM0823055','Bay 2 Controller','192.168.5.11','1201',NULL,NULL,NULL,NULL,NULL,1,1,NULL,NULL,'2025-09-06 01:41:45','2025-09-06 01:41:45'),(3,2,'PSM0823066','Bay 1 Pump',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,'2025-09-06 01:41:45','2025-09-06 01:41:45'),(4,2,'PSM0823065','Bay 2 Pump',NULL,NULL,NULL,NULL,NULL,NULL,2,1,1,NULL,NULL,'2025-09-06 01:41:45','2025-09-06 01:41:45'),(5,3,'TMM0823010','Bay 1 Tank Monitor',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,'2025-09-06 01:41:45','2025-09-06 01:41:45'),(6,3,'TMM0823012','Bay 2 Tank Monitor',NULL,NULL,NULL,NULL,NULL,NULL,2,1,1,NULL,NULL,'2025-09-06 01:41:45','2025-09-06 01:41:45');
/*!40000 ALTER TABLE `devices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dispense_transactions`
--

DROP TABLE IF EXISTS `dispense_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dispense_transactions` (
  `transaction_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `transaction_type` enum('preset','open','topoff','adjustment','delivery') NOT NULL,
  `user_id` int unsigned NOT NULL,
  `station_id` smallint unsigned NOT NULL,
  `reel_id` int unsigned NOT NULL,
  `tank_id` int unsigned NOT NULL,
  `product_id` int unsigned NOT NULL,
  `work_order_id` int unsigned DEFAULT NULL,
  `preset_amount` decimal(12,5) DEFAULT NULL,
  `actual_amount` decimal(12,5) NOT NULL,
  `unit_id` smallint unsigned NOT NULL,
  `start_volume` decimal(12,5) NOT NULL,
  `end_volume` decimal(12,5) NOT NULL,
  `start_time` datetime(6) NOT NULL,
  `end_time` datetime(6) NOT NULL,
  `duration_ms` int unsigned DEFAULT NULL,
  `was_successful` tinyint(1) NOT NULL DEFAULT '1',
  `was_emergency_stop` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`transaction_id`),
  KEY `station_id` (`station_id`),
  KEY `reel_id` (`reel_id`),
  KEY `product_id` (`product_id`),
  KEY `unit_id` (`unit_id`),
  KEY `idx_dispense_user_time` (`user_id`,`start_time`),
  KEY `idx_dispense_tank_time` (`tank_id`,`start_time`),
  KEY `idx_dispense_workorder` (`work_order_id`),
  CONSTRAINT `dispense_transactions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `dispense_transactions_ibfk_2` FOREIGN KEY (`station_id`) REFERENCES `stations` (`station_id`),
  CONSTRAINT `dispense_transactions_ibfk_3` FOREIGN KEY (`reel_id`) REFERENCES `reels` (`reel_id`),
  CONSTRAINT `dispense_transactions_ibfk_4` FOREIGN KEY (`tank_id`) REFERENCES `tanks` (`tank_id`),
  CONSTRAINT `dispense_transactions_ibfk_5` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`),
  CONSTRAINT `dispense_transactions_ibfk_6` FOREIGN KEY (`work_order_id`) REFERENCES `work_orders` (`work_order_id`),
  CONSTRAINT `dispense_transactions_ibfk_7` FOREIGN KEY (`unit_id`) REFERENCES `units` (`unit_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dispense_transactions`
--

LOCK TABLES `dispense_transactions` WRITE;
/*!40000 ALTER TABLE `dispense_transactions` DISABLE KEYS */;
INSERT INTO `dispense_transactions` VALUES (1,'preset',3,1,1,1,5,1,5.50000,5.50000,1,772.68000,767.18000,'2025-09-05 23:44:53.000000','2025-09-05 23:45:38.000000',45000,1,0,'2025-09-06 01:44:53'),(2,'open',3,1,2,2,1,2,NULL,2.30000,1,227.12000,224.82000,'2025-09-06 00:44:53.000000','2025-09-06 00:45:23.000000',30000,1,0,'2025-09-06 01:44:53'),(3,'preset',4,4,6,6,3,3,10.00000,10.00000,1,53.65000,43.65000,'2025-09-06 01:14:53.000000','2025-09-06 01:15:53.000000',60000,1,0,'2025-09-06 01:44:53'),(4,'topoff',3,2,3,3,7,2,1.00000,1.20000,1,49.90000,48.70000,'2025-09-06 01:29:53.000000','2025-09-06 01:30:13.000000',20000,1,0,'2025-09-06 01:44:53');
/*!40000 ALTER TABLE `dispense_transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failed_login_attempts`
--

DROP TABLE IF EXISTS `failed_login_attempts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `failed_login_attempts` (
  `attempt_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `user_id` int unsigned DEFAULT NULL,
  `ip_address` varchar(45) NOT NULL,
  `user_agent` text,
  `attempted_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`attempt_id`),
  KEY `idx_failed_attempts_ip` (`ip_address`,`attempted_at`),
  KEY `idx_failed_attempts_user` (`user_id`,`attempted_at`),
  KEY `idx_failed_attempts_username` (`username`,`attempted_at`),
  CONSTRAINT `failed_login_attempts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_login_attempts`
--

LOCK TABLES `failed_login_attempts` WRITE;
/*!40000 ALTER TABLE `failed_login_attempts` DISABLE KEYS */;
INSERT INTO `failed_login_attempts` VALUES (1,'jstrong',2,'192.168.1.15','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36','2025-09-06 00:40:05'),(2,'unknown_user',NULL,'192.168.1.20','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36','2025-09-06 01:10:05');
/*!40000 ALTER TABLE `failed_login_attempts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `languages`
--

DROP TABLE IF EXISTS `languages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `languages` (
  `language_id` smallint unsigned NOT NULL AUTO_INCREMENT,
  `language_code` char(5) NOT NULL,
  `language_name` varchar(50) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`language_id`),
  UNIQUE KEY `language_code` (`language_code`),
  UNIQUE KEY `language_name` (`language_name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `languages`
--

LOCK TABLES `languages` WRITE;
/*!40000 ALTER TABLE `languages` DISABLE KEYS */;
INSERT INTO `languages` VALUES (1,'en','English',1),(2,'fr','French',1),(3,'it','Italian',1),(4,'es','Spanish',1),(5,'de','German',1);
/*!40000 ALTER TABLE `languages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `product_id` int unsigned NOT NULL AUTO_INCREMENT,
  `customer_product_id` varchar(50) DEFAULT NULL,
  `product_name` varchar(100) NOT NULL,
  `description` text,
  `specific_gravity` decimal(10,4) NOT NULL DEFAULT '1.0000',
  `default_unit_id` smallint unsigned NOT NULL,
  `max_preset_amount` decimal(12,5) DEFAULT NULL,
  `max_open_amount` decimal(12,5) DEFAULT NULL,
  `is_collection_only` tinyint(1) NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`product_id`),
  UNIQUE KEY `product_name` (`product_name`),
  KEY `default_unit_id` (`default_unit_id`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`default_unit_id`) REFERENCES `units` (`unit_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'226606','1000 THF','Transmission Fluid',0.8740,1,100.00000,100.00000,0,1,'2025-09-06 01:41:45','2025-09-06 01:41:45'),(2,'273270','URSA HYD 10 WT','Hydraulic Oil',0.8100,1,100.00000,100.00000,0,1,'2025-09-06 01:41:45','2025-09-06 01:41:45'),(3,'221880','TRACTOR FLUID','Tractor Hydraulic Fluid',0.8710,1,100.00000,100.00000,0,1,'2025-09-06 01:41:45','2025-09-06 01:41:45'),(4,'255637','HYD OIL AW 68','Hydraulic Oil AW 68',0.8691,1,100.00000,100.00000,0,1,'2025-09-06 01:41:45','2025-09-06 01:41:45'),(5,'254645','HAV HM S/B 5W30','Engine Oil 5W-30',0.8600,1,100.00000,100.00000,0,1,'2025-09-06 01:41:45','2025-09-06 01:41:45'),(6,'224118','SUPREME 10W30','Engine Oil 10W-30',0.8600,1,100.00000,100.00000,0,1,'2025-09-06 01:41:45','2025-09-06 01:41:45'),(7,'CWPRODUCT','0W/20','Synthetic Engine Oil 0W-20',0.8800,1,100.00000,100.00000,0,1,'2025-09-06 01:41:45','2025-09-06 01:41:45'),(8,'H2O','Water','Deionized Water',1.0000,1,100.00000,100.00000,0,1,'2025-09-06 01:41:45','2025-09-06 01:41:45');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reels`
--

DROP TABLE IF EXISTS `reels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reels` (
  `reel_id` int unsigned NOT NULL AUTO_INCREMENT,
  `reel_name` varchar(100) NOT NULL,
  `station_id` smallint unsigned NOT NULL,
  `tank_id` int unsigned NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `k_factor` decimal(20,12) NOT NULL DEFAULT '1.000000000000',
  `pulse_count` int NOT NULL DEFAULT '0',
  `last_calibration_date` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`reel_id`),
  UNIQUE KEY `unique_reel_station` (`reel_name`,`station_id`),
  KEY `tank_id` (`tank_id`),
  KEY `idx_reels_station` (`station_id`),
  CONSTRAINT `reels_ibfk_1` FOREIGN KEY (`station_id`) REFERENCES `stations` (`station_id`),
  CONSTRAINT `reels_ibfk_2` FOREIGN KEY (`tank_id`) REFERENCES `tanks` (`tank_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reels`
--

LOCK TABLES `reels` WRITE;
/*!40000 ALTER TABLE `reels` DISABLE KEYS */;
INSERT INTO `reels` VALUES (1,'Bay 1 - Primary',1,1,1,1.000000000000,0,NULL,'2025-09-06 01:41:45','2025-09-06 01:41:45'),(2,'Bay 1 - Secondary',1,2,1,1.000000000000,0,NULL,'2025-09-06 01:41:45','2025-09-06 01:41:45'),(3,'Bay 2 - Primary',2,3,1,1.000000000000,0,NULL,'2025-09-06 01:41:45','2025-09-06 01:41:45'),(4,'Bay 2 - Secondary',2,4,1,1.000000000000,0,NULL,'2025-09-06 01:41:45','2025-09-06 01:41:45'),(5,'Quick Lube - Water',3,5,1,1.000000000000,0,NULL,'2025-09-06 01:41:45','2025-09-06 01:41:45'),(6,'Parts - Tractor Fluid',4,6,1,1.000000000000,0,NULL,'2025-09-06 01:41:45','2025-09-06 01:41:45');
/*!40000 ALTER TABLE `reels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_capabilities`
--

DROP TABLE IF EXISTS `role_capabilities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_capabilities` (
  `role_id` smallint unsigned NOT NULL,
  `capability_id` smallint unsigned NOT NULL,
  PRIMARY KEY (`role_id`,`capability_id`),
  KEY `capability_id` (`capability_id`),
  CONSTRAINT `role_capabilities_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON DELETE CASCADE,
  CONSTRAINT `role_capabilities_ibfk_2` FOREIGN KEY (`capability_id`) REFERENCES `capabilities` (`capability_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_capabilities`
--

LOCK TABLES `role_capabilities` WRITE;
/*!40000 ALTER TABLE `role_capabilities` DISABLE KEYS */;
INSERT INTO `role_capabilities` VALUES (1,1),(1,2),(1,3),(1,4),(2,4),(4,4),(6,4),(1,5),(1,6),(2,6),(3,6),(5,6),(1,7),(1,8),(2,8),(3,8),(4,8),(5,8),(1,9),(2,9),(1,10),(2,10),(3,10),(4,10),(5,10),(6,10),(1,11),(2,11),(3,11),(1,12),(2,12),(3,12),(1,13),(2,13),(3,13),(1,14),(2,14),(4,14),(1,15),(2,15),(3,15),(4,15),(1,16),(5,16),(1,17),(5,17);
/*!40000 ALTER TABLE `role_capabilities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `role_id` smallint unsigned NOT NULL AUTO_INCREMENT,
  `role_name` varchar(50) NOT NULL,
  `role_description` text,
  `is_system_role` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `role_name` (`role_name`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'System Administrator','Full system access and configuration',1,'2025-09-06 01:40:05'),(2,'Dealership Manager','Manager with reporting and user management capabilities',0,'2025-09-06 01:40:05'),(3,'Service Technician','Technician with dispensing capabilities',0,'2025-09-06 01:40:05'),(4,'Parts Manager','Manages inventory and parts',0,'2025-09-06 01:40:05'),(5,'Installer','System installation and maintenance role',0,'2025-09-06 01:40:05'),(6,'Read Only','View-only access for auditing',0,'2025-09-06 01:40:05');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schedule_exceptions`
--

DROP TABLE IF EXISTS `schedule_exceptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `schedule_exceptions` (
  `exception_id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `exception_type` enum('vacation','sick_leave','holiday','training','other') NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `description` text,
  `is_approved` tinyint(1) NOT NULL DEFAULT '0',
  `approved_by` int unsigned DEFAULT NULL,
  `approved_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` int unsigned NOT NULL,
  PRIMARY KEY (`exception_id`),
  KEY `approved_by` (`approved_by`),
  KEY `created_by` (`created_by`),
  KEY `idx_schedule_exceptions_user` (`user_id`,`start_date`,`end_date`),
  CONSTRAINT `schedule_exceptions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `schedule_exceptions_ibfk_2` FOREIGN KEY (`approved_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `schedule_exceptions_ibfk_3` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedule_exceptions`
--

LOCK TABLES `schedule_exceptions` WRITE;
/*!40000 ALTER TABLE `schedule_exceptions` DISABLE KEYS */;
INSERT INTO `schedule_exceptions` VALUES (1,3,'vacation','2024-07-15','2024-07-22','Summer vacation',1,2,NULL,'2025-09-06 01:41:00',3),(2,4,'training','2024-03-10','2024-03-12','Product training seminar',1,2,NULL,'2025-09-06 01:41:00',4),(3,3,'sick_leave','2024-05-01','2024-05-03','Medical leave',0,NULL,NULL,'2025-09-06 01:41:00',3);
/*!40000 ALTER TABLE `schedule_exceptions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sensors`
--

DROP TABLE IF EXISTS `sensors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sensors` (
  `sensor_id` int unsigned NOT NULL AUTO_INCREMENT,
  `tank_id` int unsigned NOT NULL,
  `device_id` int unsigned DEFAULT NULL,
  `port_number` tinyint unsigned DEFAULT NULL,
  `sensor_type` enum('probe_6ft','probe_10ft','probe_20ft','probe_30ft','transducer_10ft','transducer_20ft','transducer_30ft','transducer_54in') NOT NULL,
  `cable_length` decimal(8,2) DEFAULT NULL,
  `cable_unit` varchar(20) DEFAULT 'feet',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `installed_date` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`sensor_id`),
  UNIQUE KEY `unique_sensor_device_port` (`device_id`,`port_number`),
  KEY `idx_sensors_tank` (`tank_id`),
  CONSTRAINT `sensors_ibfk_1` FOREIGN KEY (`tank_id`) REFERENCES `tanks` (`tank_id`) ON DELETE CASCADE,
  CONSTRAINT `sensors_ibfk_2` FOREIGN KEY (`device_id`) REFERENCES `devices` (`device_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sensors`
--

LOCK TABLES `sensors` WRITE;
/*!40000 ALTER TABLE `sensors` DISABLE KEYS */;
INSERT INTO `sensors` VALUES (1,1,5,1,'probe_6ft',6.00,'feet',1,NULL,'2025-09-06 01:41:45','2025-09-06 01:41:45'),(2,2,5,2,'probe_6ft',6.00,'feet',1,NULL,'2025-09-06 01:41:45','2025-09-06 01:41:45'),(3,3,6,1,'probe_6ft',6.00,'feet',1,NULL,'2025-09-06 01:41:45','2025-09-06 01:41:45'),(4,4,6,2,'probe_6ft',6.00,'feet',1,NULL,'2025-09-06 01:41:45','2025-09-06 01:41:45'),(5,5,6,3,'probe_6ft',6.00,'feet',1,NULL,'2025-09-06 01:41:45','2025-09-06 01:41:45'),(6,6,6,4,'probe_6ft',6.00,'feet',1,NULL,'2025-09-06 01:41:45','2025-09-06 01:41:45');
/*!40000 ALTER TABLE `sensors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shift_templates`
--

DROP TABLE IF EXISTS `shift_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shift_templates` (
  `shift_template_id` smallint unsigned NOT NULL AUTO_INCREMENT,
  `shift_name` varchar(50) NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `is_overnight` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`shift_template_id`),
  UNIQUE KEY `shift_name` (`shift_name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shift_templates`
--

LOCK TABLES `shift_templates` WRITE;
/*!40000 ALTER TABLE `shift_templates` DISABLE KEYS */;
INSERT INTO `shift_templates` VALUES (1,'Morning Shift','08:00:00','16:00:00',0,'2025-09-06 01:41:00'),(2,'Evening Shift','16:00:00','00:00:00',1,'2025-09-06 01:41:00'),(3,'Night Shift','00:00:00','08:00:00',1,'2025-09-06 01:41:00'),(4,'Weekend Shift','09:00:00','17:00:00',0,'2025-09-06 01:41:00');
/*!40000 ALTER TABLE `shift_templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stations`
--

DROP TABLE IF EXISTS `stations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stations` (
  `station_id` smallint unsigned NOT NULL AUTO_INCREMENT,
  `station_name` varchar(100) NOT NULL,
  `location_description` text,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `display_priority` smallint NOT NULL DEFAULT '1000',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`station_id`),
  UNIQUE KEY `station_name` (`station_name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stations`
--

LOCK TABLES `stations` WRITE;
/*!40000 ALTER TABLE `stations` DISABLE KEYS */;
INSERT INTO `stations` VALUES (1,'Service Bay 1','Main service area, north side',1,1,'2025-09-06 01:41:45','2025-09-06 01:41:45'),(2,'Service Bay 2','Main service area, south side',1,2,'2025-09-06 01:41:45','2025-09-06 01:41:45'),(3,'Quick Lube Bay','Express service area',1,3,'2025-09-06 01:41:45','2025-09-06 01:41:45'),(4,'Parts Department','Parts counter dispensing station',1,4,'2025-09-06 01:41:45','2025-09-06 01:41:45');
/*!40000 ALTER TABLE `stations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `system_events`
--

DROP TABLE IF EXISTS `system_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `system_events` (
  `event_id` int unsigned NOT NULL AUTO_INCREMENT,
  `event_code` varchar(50) NOT NULL,
  `event_name` varchar(200) NOT NULL,
  `event_description` text,
  `severity` enum('info','warning','error','critical') NOT NULL DEFAULT 'info',
  PRIMARY KEY (`event_id`),
  UNIQUE KEY `event_code` (`event_code`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `system_events`
--

LOCK TABLES `system_events` WRITE;
/*!40000 ALTER TABLE `system_events` DISABLE KEYS */;
INSERT INTO `system_events` VALUES (1,'user.login','User Login','User successfully logged into the system','info'),(2,'user.login_failed','Failed Login','User failed to login','warning'),(3,'user.logout','User Logout','User logged out of the system','info'),(4,'user.password_change','Password Changed','User changed their password','info'),(5,'user.account_locked','Account Locked','User account was locked due to failed attempts','warning'),(6,'user.account_unlocked','Account Unlocked','User account was unlocked','info'),(7,'dispense.start','Dispense Started','Dispensing operation started','info'),(8,'dispense.complete','Dispense Completed','Dispensing operation completed successfully','info'),(9,'dispense.failed','Dispense Failed','Dispensing operation failed','error'),(10,'dispense.emergency_stop','Emergency Stop','Dispensing stopped via emergency stop','critical'),(11,'tank.level_low','Tank Level Low','Tank level below reorder point','warning'),(12,'tank.level_critical','Tank Level Critical','Tank level below shutoff point','critical'),(13,'tank.level_high','Tank Level High','Tank level above warning level','warning'),(14,'tank.adjustment','Tank Adjustment','Tank inventory was manually adjusted','info'),(15,'device.online','Device Online','Device came online','info'),(16,'device.offline','Device Offline','Device went offline','warning'),(17,'device.config_updated','Device Configured','Device configuration was updated','info'),(18,'system.config_updated','System Configuration Updated','System configuration was changed','info');
/*!40000 ALTER TABLE `system_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tank_station_map`
--

DROP TABLE IF EXISTS `tank_station_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tank_station_map` (
  `tank_id` int unsigned NOT NULL,
  `station_id` smallint unsigned NOT NULL,
  PRIMARY KEY (`tank_id`,`station_id`),
  KEY `station_id` (`station_id`),
  CONSTRAINT `tank_station_map_ibfk_1` FOREIGN KEY (`tank_id`) REFERENCES `tanks` (`tank_id`) ON DELETE CASCADE,
  CONSTRAINT `tank_station_map_ibfk_2` FOREIGN KEY (`station_id`) REFERENCES `stations` (`station_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tank_station_map`
--

LOCK TABLES `tank_station_map` WRITE;
/*!40000 ALTER TABLE `tank_station_map` DISABLE KEYS */;
INSERT INTO `tank_station_map` VALUES (1,1),(2,1),(1,2),(3,2),(4,2),(5,3),(6,4);
/*!40000 ALTER TABLE `tank_station_map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tanks`
--

DROP TABLE IF EXISTS `tanks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tanks` (
  `tank_id` int unsigned NOT NULL AUTO_INCREMENT,
  `tank_name` varchar(100) NOT NULL,
  `product_id` int unsigned NOT NULL,
  `station_id` smallint unsigned DEFAULT NULL,
  `tank_shape` enum('round_vertical','round_horizontal','rectangular') NOT NULL DEFAULT 'round_vertical',
  `height` decimal(10,3) DEFAULT NULL,
  `diameter` decimal(10,3) DEFAULT NULL,
  `width` decimal(10,3) DEFAULT NULL,
  `length` decimal(10,3) DEFAULT NULL,
  `capacity` decimal(12,5) NOT NULL,
  `current_volume` decimal(12,5) NOT NULL DEFAULT '0.00000',
  `current_height` decimal(10,3) DEFAULT NULL,
  `high_level_alarm` decimal(12,5) DEFAULT NULL,
  `high_level_warning` decimal(12,5) DEFAULT NULL,
  `reorder_level` decimal(12,5) DEFAULT NULL,
  `shutoff_level` decimal(12,5) DEFAULT NULL,
  `is_locked` tinyint(1) NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`tank_id`),
  UNIQUE KEY `tank_name` (`tank_name`),
  KEY `product_id` (`product_id`),
  KEY `idx_tanks_station` (`station_id`),
  CONSTRAINT `tanks_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`),
  CONSTRAINT `tanks_ibfk_2` FOREIGN KEY (`station_id`) REFERENCES `stations` (`station_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tanks`
--

LOCK TABLES `tanks` WRITE;
/*!40000 ALTER TABLE `tanks` DISABLE KEYS */;
INSERT INTO `tanks` VALUES (1,'Engine Oil 5W-30',5,1,'round_vertical',72.000,64.000,NULL,NULL,1002.19000,767.18000,NULL,902.00000,952.00000,200.00000,50.00000,0,1,'2025-09-06 01:41:45','2025-09-06 01:41:45'),(2,'Transmission Fluid',1,1,'round_vertical',72.000,64.000,NULL,NULL,1002.19000,224.82000,NULL,902.00000,952.00000,200.00000,50.00000,0,1,'2025-09-06 01:41:45','2025-09-06 01:41:45'),(3,'Engine Oil 0W-20',7,2,'round_vertical',72.000,64.000,NULL,NULL,1002.19000,48.70000,NULL,902.00000,952.00000,200.00000,50.00000,0,1,'2025-09-06 01:41:45','2025-09-06 01:41:45'),(4,'Hydraulic Oil',2,2,'round_vertical',72.000,64.000,NULL,NULL,1002.19000,57.78000,NULL,902.00000,952.00000,200.00000,50.00000,0,1,'2025-09-06 01:41:45','2025-09-06 01:41:45'),(5,'Water',8,3,'round_vertical',72.000,64.000,NULL,NULL,1002.19000,51.96000,NULL,902.00000,952.00000,200.00000,50.00000,0,1,'2025-09-06 01:41:45','2025-09-06 01:41:45'),(6,'Tractor Fluid',3,4,'round_vertical',72.000,64.000,NULL,NULL,1002.19000,43.65000,NULL,902.00000,952.00000,200.00000,50.00000,0,1,'2025-09-06 01:41:45','2025-09-06 01:41:45');
/*!40000 ALTER TABLE `tanks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `time_zones`
--

DROP TABLE IF EXISTS `time_zones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `time_zones` (
  `time_zone_id` smallint unsigned NOT NULL AUTO_INCREMENT,
  `time_zone_name` varchar(100) NOT NULL,
  `utc_offset` varchar(10) NOT NULL,
  `is_dst` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`time_zone_id`),
  UNIQUE KEY `time_zone_name` (`time_zone_name`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `time_zones`
--

LOCK TABLES `time_zones` WRITE;
/*!40000 ALTER TABLE `time_zones` DISABLE KEYS */;
INSERT INTO `time_zones` VALUES (1,'America/New_York','-05:00',1),(2,'America/Chicago','-06:00',1),(3,'America/Denver','-07:00',1),(4,'America/Los_Angeles','-08:00',1),(5,'UTC','+00:00',0),(6,'Europe/Rome','+01:00',1);
/*!40000 ALTER TABLE `time_zones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `units`
--

DROP TABLE IF EXISTS `units`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `units` (
  `unit_id` smallint unsigned NOT NULL AUTO_INCREMENT,
  `unit_name` varchar(30) NOT NULL,
  `unit_abbreviation` varchar(10) NOT NULL,
  `is_volume` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`unit_id`),
  UNIQUE KEY `unit_name` (`unit_name`),
  UNIQUE KEY `unit_abbreviation` (`unit_abbreviation`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `units`
--

LOCK TABLES `units` WRITE;
/*!40000 ALTER TABLE `units` DISABLE KEYS */;
INSERT INTO `units` VALUES (1,'Gallons','gal',1),(2,'Liters','L',1),(3,'Quarts','qt',1),(4,'Pints','pt',1),(5,'Ounces','oz',1);
/*!40000 ALTER TABLE `units` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_reel_permissions`
--

DROP TABLE IF EXISTS `user_reel_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_reel_permissions` (
  `user_id` int unsigned NOT NULL,
  `reel_id` int unsigned NOT NULL,
  `can_dispense` tinyint(1) NOT NULL DEFAULT '0',
  `granted_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `granted_by` int unsigned NOT NULL,
  PRIMARY KEY (`user_id`,`reel_id`),
  KEY `reel_id` (`reel_id`),
  KEY `granted_by` (`granted_by`),
  CONSTRAINT `user_reel_permissions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `user_reel_permissions_ibfk_2` FOREIGN KEY (`reel_id`) REFERENCES `reels` (`reel_id`) ON DELETE CASCADE,
  CONSTRAINT `user_reel_permissions_ibfk_3` FOREIGN KEY (`granted_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_reel_permissions`
--

LOCK TABLES `user_reel_permissions` WRITE;
/*!40000 ALTER TABLE `user_reel_permissions` DISABLE KEYS */;
INSERT INTO `user_reel_permissions` VALUES (2,1,0,'2025-09-06 01:42:45',1),(2,2,0,'2025-09-06 01:42:45',1),(2,3,0,'2025-09-06 01:42:45',1),(2,4,0,'2025-09-06 01:42:45',1),(2,5,0,'2025-09-06 01:42:45',1),(2,6,0,'2025-09-06 01:42:45',1),(3,1,0,'2025-09-06 01:42:45',2),(3,2,0,'2025-09-06 01:42:45',2),(3,3,0,'2025-09-06 01:42:45',2),(3,4,0,'2025-09-06 01:42:45',2),(4,6,0,'2025-09-06 01:42:45',2),(5,1,0,'2025-09-06 01:42:45',1),(5,2,0,'2025-09-06 01:42:45',1),(5,3,0,'2025-09-06 01:42:45',1),(5,4,0,'2025-09-06 01:42:45',1),(5,5,0,'2025-09-06 01:42:45',1),(5,6,0,'2025-09-06 01:42:45',1);
/*!40000 ALTER TABLE `user_reel_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_roles`
--

DROP TABLE IF EXISTS `user_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_roles` (
  `user_id` int unsigned NOT NULL,
  `role_id` smallint unsigned NOT NULL,
  `assigned_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `assigned_by` int unsigned NOT NULL,
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `role_id` (`role_id`),
  KEY `assigned_by` (`assigned_by`),
  CONSTRAINT `user_roles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `user_roles_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON DELETE CASCADE,
  CONSTRAINT `user_roles_ibfk_3` FOREIGN KEY (`assigned_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_roles`
--

LOCK TABLES `user_roles` WRITE;
/*!40000 ALTER TABLE `user_roles` DISABLE KEYS */;
INSERT INTO `user_roles` VALUES (1,1,'2025-09-06 01:40:05',1),(2,2,'2025-09-06 01:40:05',1),(3,3,'2025-09-06 01:40:05',2),(4,4,'2025-09-06 01:40:05',2),(5,5,'2025-09-06 01:40:05',1);
/*!40000 ALTER TABLE `user_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_schedules`
--

DROP TABLE IF EXISTS `user_schedules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_schedules` (
  `user_schedule_id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `shift_template_id` smallint unsigned NOT NULL,
  `valid_from` date NOT NULL,
  `valid_until` date DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int unsigned NOT NULL,
  PRIMARY KEY (`user_schedule_id`),
  KEY `shift_template_id` (`shift_template_id`),
  KEY `created_by` (`created_by`),
  KEY `idx_user_schedules_user` (`user_id`,`valid_from`,`valid_until`,`is_active`),
  CONSTRAINT `user_schedules_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `user_schedules_ibfk_2` FOREIGN KEY (`shift_template_id`) REFERENCES `shift_templates` (`shift_template_id`),
  CONSTRAINT `user_schedules_ibfk_3` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_schedules`
--

LOCK TABLES `user_schedules` WRITE;
/*!40000 ALTER TABLE `user_schedules` DISABLE KEYS */;
INSERT INTO `user_schedules` VALUES (1,3,1,'2024-01-01','2024-12-31',1,'2025-09-06 01:41:00','2025-09-06 01:41:00',2),(2,4,2,'2024-01-01','2024-06-30',1,'2025-09-06 01:41:00','2025-09-06 01:41:00',2),(3,4,1,'2024-07-01',NULL,1,'2025-09-06 01:41:00','2025-09-06 01:41:00',2),(4,5,3,'2024-01-01',NULL,1,'2025-09-06 01:41:00','2025-09-06 01:41:00',1);
/*!40000 ALTER TABLE `user_schedules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_sessions`
--

DROP TABLE IF EXISTS `user_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_sessions` (
  `session_id` char(40) NOT NULL,
  `user_id` int unsigned NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `user_agent` text,
  `payload` text NOT NULL,
  `last_activity` datetime NOT NULL,
  `expires_at` datetime NOT NULL,
  PRIMARY KEY (`session_id`),
  KEY `idx_sessions_user_id` (`user_id`),
  KEY `idx_sessions_last_activity` (`last_activity`),
  CONSTRAINT `user_sessions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_sessions`
--

LOCK TABLES `user_sessions` WRITE;
/*!40000 ALTER TABLE `user_sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_station_permissions`
--

DROP TABLE IF EXISTS `user_station_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_station_permissions` (
  `user_id` int unsigned NOT NULL,
  `station_id` smallint unsigned NOT NULL,
  `can_access` tinyint(1) NOT NULL DEFAULT '1',
  `granted_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `granted_by` int unsigned NOT NULL,
  PRIMARY KEY (`user_id`,`station_id`),
  KEY `station_id` (`station_id`),
  KEY `granted_by` (`granted_by`),
  CONSTRAINT `user_station_permissions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `user_station_permissions_ibfk_2` FOREIGN KEY (`station_id`) REFERENCES `stations` (`station_id`) ON DELETE CASCADE,
  CONSTRAINT `user_station_permissions_ibfk_3` FOREIGN KEY (`granted_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_station_permissions`
--

LOCK TABLES `user_station_permissions` WRITE;
/*!40000 ALTER TABLE `user_station_permissions` DISABLE KEYS */;
INSERT INTO `user_station_permissions` VALUES (2,1,1,'2025-09-06 01:42:45',1),(2,2,1,'2025-09-06 01:42:45',1),(2,3,1,'2025-09-06 01:42:45',1),(2,4,1,'2025-09-06 01:42:45',1),(3,1,1,'2025-09-06 01:42:45',2),(3,2,1,'2025-09-06 01:42:45',2),(4,4,1,'2025-09-06 01:42:45',2),(5,1,1,'2025-09-06 01:42:45',1),(5,2,1,'2025-09-06 01:42:45',1),(5,3,1,'2025-09-06 01:42:45',1),(5,4,1,'2025-09-06 01:42:45',1);
/*!40000 ALTER TABLE `user_station_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_tank_permissions`
--

DROP TABLE IF EXISTS `user_tank_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_tank_permissions` (
  `user_id` int unsigned NOT NULL,
  `tank_id` int unsigned NOT NULL,
  `can_dispense` tinyint(1) NOT NULL DEFAULT '0',
  `can_override` tinyint(1) NOT NULL DEFAULT '0',
  `granted_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `granted_by` int unsigned NOT NULL,
  PRIMARY KEY (`user_id`,`tank_id`),
  KEY `tank_id` (`tank_id`),
  KEY `granted_by` (`granted_by`),
  CONSTRAINT `user_tank_permissions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `user_tank_permissions_ibfk_2` FOREIGN KEY (`tank_id`) REFERENCES `tanks` (`tank_id`) ON DELETE CASCADE,
  CONSTRAINT `user_tank_permissions_ibfk_3` FOREIGN KEY (`granted_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_tank_permissions`
--

LOCK TABLES `user_tank_permissions` WRITE;
/*!40000 ALTER TABLE `user_tank_permissions` DISABLE KEYS */;
INSERT INTO `user_tank_permissions` VALUES (2,1,1,1,'2025-09-06 01:42:45',1),(2,2,1,1,'2025-09-06 01:42:45',1),(2,3,1,1,'2025-09-06 01:42:45',1),(2,4,1,1,'2025-09-06 01:42:45',1),(2,5,1,1,'2025-09-06 01:42:45',1),(2,6,1,1,'2025-09-06 01:42:45',1),(3,1,1,0,'2025-09-06 01:42:45',2),(3,2,1,0,'2025-09-06 01:42:45',2),(3,3,1,0,'2025-09-06 01:42:45',2),(3,4,1,0,'2025-09-06 01:42:45',2),(4,6,1,1,'2025-09-06 01:42:45',2),(5,1,1,1,'2025-09-06 01:42:45',1),(5,2,1,1,'2025-09-06 01:42:45',1),(5,3,1,1,'2025-09-06 01:42:45',1),(5,4,1,1,'2025-09-06 01:42:45',1),(5,5,1,1,'2025-09-06 01:42:45',1),(5,6,1,1,'2025-09-06 01:42:45',1);
/*!40000 ALTER TABLE `user_tank_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int unsigned NOT NULL AUTO_INCREMENT,
  `external_uuid` char(36) NOT NULL DEFAULT (uuid()),
  `username` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `pin_hash` varchar(255) DEFAULT NULL,
  `company_id` int unsigned NOT NULL,
  `department_id` int unsigned DEFAULT NULL,
  `language_id` smallint unsigned DEFAULT '1',
  `time_zone_id` smallint unsigned DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `is_locked` tinyint(1) NOT NULL DEFAULT '0',
  `lockout_reason` enum('failed_attempts','manual','vacation','other') DEFAULT NULL,
  `lockout_until` datetime DEFAULT NULL,
  `must_change_password` tinyint(1) NOT NULL DEFAULT '0',
  `agreed_to_terms` tinyint(1) NOT NULL DEFAULT '0',
  `agreed_to_terms_at` datetime DEFAULT NULL,
  `last_login_at` datetime DEFAULT NULL,
  `last_login_ip` varchar(45) DEFAULT NULL,
  `last_login_user_agent` text,
  `last_logout_at` datetime DEFAULT NULL,
  `last_logout_type` enum('user','timeout','system') DEFAULT NULL,
  `account_expires_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int unsigned DEFAULT NULL,
  `updated_by` int unsigned DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `external_uuid` (`external_uuid`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  KEY `department_id` (`department_id`),
  KEY `language_id` (`language_id`),
  KEY `time_zone_id` (`time_zone_id`),
  KEY `created_by` (`created_by`),
  KEY `updated_by` (`updated_by`),
  KEY `idx_users_company` (`company_id`),
  KEY `idx_users_status` (`is_active`,`is_locked`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `companies` (`company_id`),
  CONSTRAINT `users_ibfk_2` FOREIGN KEY (`department_id`) REFERENCES `departments` (`department_id`),
  CONSTRAINT `users_ibfk_3` FOREIGN KEY (`language_id`) REFERENCES `languages` (`language_id`),
  CONSTRAINT `users_ibfk_4` FOREIGN KEY (`time_zone_id`) REFERENCES `time_zones` (`time_zone_id`),
  CONSTRAINT `users_ibfk_5` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `users_ibfk_6` FOREIGN KEY (`updated_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'69fa98d8-8ac2-11f0-b650-7abd935312df','admin','oilcop@liquidynamics.com','LQD','Admin','$2y$12$MK0uxed3TuxbMI9PUwHTXuMOk3qJNlyGQjFgWyadVL4mrF/0Ch.fK','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',1,1,1,1,1,0,NULL,NULL,0,1,'2025-09-06 01:40:05',NULL,NULL,NULL,NULL,NULL,NULL,'2025-09-06 01:40:05','2025-09-06 01:40:05',NULL,NULL),(2,'69faa741-8ac2-11f0-b650-7abd935312df','jstrong','jim.strong@testdealership.com','Jim','Strong','$2y$12$MK0uxed3TuxbMI9PUwHTXuMOk3qJNlyGQjFgWyadVL4mrF/0Ch.fK','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',4,6,1,1,1,0,NULL,NULL,0,1,'2025-09-06 01:40:05',NULL,NULL,NULL,NULL,NULL,NULL,'2025-09-06 01:40:05','2025-09-06 01:40:05',1,NULL),(3,'69faaafb-8ac2-11f0-b650-7abd935312df','tsmith','tom.smith@testdealership.com','Tom','Smith','$2y$12$MK0uxed3TuxbMI9PUwHTXuMOk3qJNlyGQjFgWyadVL4mrF/0Ch.fK','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',4,6,1,1,1,0,NULL,NULL,0,1,'2025-09-06 01:40:05',NULL,NULL,NULL,NULL,NULL,NULL,'2025-09-06 01:40:05','2025-09-06 01:40:05',1,NULL),(4,'69faad05-8ac2-11f0-b650-7abd935312df','mjones','mike.jones@testdealership.com','Mike','Jones','$2y$12$MK0uxed3TuxbMI9PUwHTXuMOk3qJNlyGQjFgWyadVL4mrF/0Ch.fK','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',4,7,1,1,1,0,NULL,NULL,0,1,'2025-09-06 01:40:05',NULL,NULL,NULL,NULL,NULL,NULL,'2025-09-06 01:40:05','2025-09-06 01:40:05',1,NULL),(5,'69faaf52-8ac2-11f0-b650-7abd935312df','sinstaller','service.installer@testdealership.com','Service','Installer','$2y$12$MK0uxed3TuxbMI9PUwHTXuMOk3qJNlyGQjFgWyadVL4mrF/0Ch.fK','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',4,8,1,1,1,0,NULL,NULL,0,1,'2025-09-06 01:40:05',NULL,NULL,NULL,NULL,NULL,NULL,'2025-09-06 01:40:05','2025-09-06 01:40:05',1,NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `work_orders`
--

DROP TABLE IF EXISTS `work_orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `work_orders` (
  `work_order_id` int unsigned NOT NULL AUTO_INCREMENT,
  `work_order_number` varchar(50) NOT NULL,
  `status` enum('open','in_progress','completed','closed','cancelled') NOT NULL DEFAULT 'open',
  `created_by` int unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`work_order_id`),
  UNIQUE KEY `work_order_number` (`work_order_number`),
  KEY `created_by` (`created_by`),
  CONSTRAINT `work_orders_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `work_orders`
--

LOCK TABLES `work_orders` WRITE;
/*!40000 ALTER TABLE `work_orders` DISABLE KEYS */;
INSERT INTO `work_orders` VALUES (1,'WO-2024-001','completed',3,'2025-09-06 01:44:53','2025-09-06 01:44:53'),(2,'WO-2024-002','in_progress',3,'2025-09-06 01:44:53','2025-09-06 01:44:53'),(3,'WO-2024-003','open',4,'2025-09-06 01:44:53','2025-09-06 01:44:53'),(4,'WO-2024-004','closed',3,'2025-09-06 01:44:53','2025-09-06 01:44:53'),(5,'WO-2024-005','open',4,'2025-09-06 01:44:53','2025-09-06 01:44:53');
/*!40000 ALTER TABLE `work_orders` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-09-06 22:18:12
