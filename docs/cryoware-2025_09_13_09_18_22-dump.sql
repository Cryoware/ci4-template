-- MySQL dump 10.13  Distrib 8.4.6, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: cryoware
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
-- Table structure for table `companies`
--

DROP TABLE IF EXISTS `companies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `companies` (
  `id` int unsigned DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
  `id` int unsigned DEFAULT NULL,
  `company_id` int unsigned DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
-- Table structure for table `languages`
--

DROP TABLE IF EXISTS `languages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `languages` (
  `id` smallint unsigned NOT NULL AUTO_INCREMENT,
  `code` char(5) NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
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
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `product_id` varchar(50) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `description` text,
  `specific_gravity` decimal(10,4) DEFAULT NULL,
  `unit_id` tinyint unsigned DEFAULT NULL,
  `max_preset_amount` decimal(12,5) DEFAULT NULL,
  `max_open_amount` decimal(12,5) DEFAULT NULL,
  `is_collection_only` tinyint(1) NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `products_units_id_fk` (`unit_id`),
  CONSTRAINT `products_units_id_fk` FOREIGN KEY (`unit_id`) REFERENCES `units` (`id`)
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
-- Table structure for table `t_users_details`
--

DROP TABLE IF EXISTS `t_users_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_users_details` (
  `f_user_id` int unsigned DEFAULT NULL,
  `f_first_name` varchar(30) DEFAULT NULL,
  `f_last_name` varchar(30) DEFAULT NULL,
  `f_user_email` varchar(100) DEFAULT NULL,
  `f_user_pin` int DEFAULT NULL,
  `f_password` varchar(255) DEFAULT NULL,
  `f_user_enabled` tinyint DEFAULT NULL,
  `f_company_name` varchar(30) DEFAULT NULL,
  `f_department_name` varchar(30) DEFAULT NULL,
  `f_last_login` datetime DEFAULT NULL,
  `f_lockout_until` datetime DEFAULT NULL,
  `f_status` int DEFAULT NULL,
  `f_emergency_stop` tinyint DEFAULT NULL,
  `f_calibrate` tinyint DEFAULT NULL,
  `f_kfactor` tinyint DEFAULT NULL,
  `f_default` int DEFAULT NULL,
  `f_agrmt_accept` tinyint DEFAULT NULL,
  `f_agrmt_email_copy` varchar(100) DEFAULT NULL,
  `f_agrmt_downloaded` tinyint DEFAULT NULL,
  `f_last_logout` datetime DEFAULT NULL,
  `f_locked_until` datetime DEFAULT NULL,
  `f_failed_login_count` int unsigned DEFAULT NULL,
  `f_failed_login_attempts` int DEFAULT NULL,
  `f_last_failed_login` datetime DEFAULT NULL,
  `f_created_at` timestamp NULL DEFAULT NULL,
  `f_updated_at` timestamp NULL DEFAULT NULL,
  `f_updated_by` int DEFAULT NULL,
  `f_last_updated` timestamp NULL DEFAULT NULL,
  `f_created_by` int DEFAULT NULL,
  `f_create_by` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_users_details`
--

LOCK TABLES `t_users_details` WRITE;
/*!40000 ALTER TABLE `t_users_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_users_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tank_configurations`
--

DROP TABLE IF EXISTS `tank_configurations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tank_configurations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `model` varchar(50) DEFAULT NULL,
  `shape` enum('round_vertical','round_horizontal','rectangular') NOT NULL,
  `height` decimal(10,2) DEFAULT NULL,
  `width` decimal(10,2) DEFAULT NULL,
  `length` decimal(10,2) DEFAULT NULL,
  `radius` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tank_configurations`
--

LOCK TABLES `tank_configurations` WRITE;
/*!40000 ALTER TABLE `tank_configurations` DISABLE KEYS */;
INSERT INTO `tank_configurations` VALUES (1,NULL,NULL,'round_vertical',72.00,NULL,NULL,32.00),(2,NULL,NULL,'round_vertical',72.00,NULL,NULL,32.00),(3,NULL,NULL,'round_vertical',72.00,NULL,NULL,32.00),(4,NULL,NULL,'round_vertical',72.00,NULL,NULL,32.00),(5,NULL,NULL,'round_vertical',72.00,NULL,NULL,32.00),(6,NULL,NULL,'round_vertical',72.00,NULL,NULL,32.00);
/*!40000 ALTER TABLE `tank_configurations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tanks`
--

DROP TABLE IF EXISTS `tanks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tanks` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `product_id` int unsigned NOT NULL,
  `units_id` tinyint unsigned NOT NULL,
  `capacity` decimal(12,5) NOT NULL,
  `config_id` int unsigned NOT NULL,
  `current_volume` decimal(12,5) NOT NULL DEFAULT '0.00000',
  `current_height` decimal(12,5) NOT NULL DEFAULT '0.00000',
  `high_level_alarm` decimal(12,5) NOT NULL,
  `reorder_level` decimal(12,5) NOT NULL,
  `shutoff_level` decimal(12,5) NOT NULL,
  `is_locked` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `tanks_units_id_fk` (`units_id`),
  KEY `tanks_products_id_fk` (`product_id`),
  KEY `tanks_tank_configurations_id_fk` (`config_id`),
  CONSTRAINT `tanks_products_id_fk` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  CONSTRAINT `tanks_tank_configurations_id_fk` FOREIGN KEY (`config_id`) REFERENCES `tank_configurations` (`id`),
  CONSTRAINT `tanks_units_id_fk` FOREIGN KEY (`units_id`) REFERENCES `units` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tanks`
--

LOCK TABLES `tanks` WRITE;
/*!40000 ALTER TABLE `tanks` DISABLE KEYS */;
/*!40000 ALTER TABLE `tanks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `time_zones`
--

DROP TABLE IF EXISTS `time_zones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `time_zones` (
  `id` smallint unsigned DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `utc_offset` varchar(10) DEFAULT NULL,
  `is_dst` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
  `id` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `abbreviation` varchar(10) NOT NULL,
  `is_volume` tinyint DEFAULT NULL,
  PRIMARY KEY (`id`)
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
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int unsigned DEFAULT NULL,
  `external_uuid` char(36) DEFAULT NULL,
  `username` varchar(100) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `password_hash` varchar(255) DEFAULT NULL,
  `pin_hash` varchar(255) DEFAULT NULL,
  `company_id` int unsigned DEFAULT NULL,
  `department_id` int unsigned DEFAULT NULL,
  `language_id` smallint unsigned DEFAULT NULL,
  `time_zone_id` smallint unsigned DEFAULT NULL,
  `is_active` tinyint DEFAULT NULL,
  `is_locked` tinyint DEFAULT NULL,
  `lockout_reason` enum('failed_attempts','manual','vacation','other') DEFAULT NULL,
  `lockout_until` datetime DEFAULT NULL,
  `must_change_password` tinyint DEFAULT NULL,
  `agreed_to_terms` tinyint DEFAULT NULL,
  `agreed_to_terms_at` datetime DEFAULT NULL,
  `last_login_at` datetime DEFAULT NULL,
  `last_login_ip` varchar(45) DEFAULT NULL,
  `last_login_user_agent` text,
  `last_logout_at` datetime DEFAULT NULL,
  `last_logout_type` enum('user','timeout','system') DEFAULT NULL,
  `account_expires_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `created_by` int unsigned DEFAULT NULL,
  `updated_by` int unsigned DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'69fa98d8-8ac2-11f0-b650-7abd935312df','admin','oilcop@liquidynamics.com','LQD','Admin','$2y$12$MK0uxed3TuxbMI9PUwHTXuMOk3qJNlyGQjFgWyadVL4mrF/0Ch.fK','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',1,1,1,1,1,0,NULL,NULL,0,1,'2025-09-06 01:40:05',NULL,NULL,NULL,NULL,NULL,NULL,'2025-09-06 01:40:05','2025-09-06 01:40:05',NULL,NULL),(2,'69faa741-8ac2-11f0-b650-7abd935312df','xersist','xersist@gmail.com','Jim','Strong','$2y$12$MK0uxed3TuxbMI9PUwHTXuMOk3qJNlyGQjFgWyadVL4mrF/0Ch.fK','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',4,6,1,1,1,0,NULL,NULL,0,1,'2025-09-06 01:40:05','2025-09-11 23:05:48','172.19.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36',NULL,'user',NULL,'2025-09-06 01:40:05','2025-09-12 15:52:12',1,NULL),(3,'69faaafb-8ac2-11f0-b650-7abd935312df','tsmith','tom.smith@testdealership.com','Tom','Smith','$2y$12$MK0uxed3TuxbMI9PUwHTXuMOk3qJNlyGQjFgWyadVL4mrF/0Ch.fK','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',4,6,1,1,1,0,NULL,NULL,0,1,'2025-09-06 01:40:05',NULL,NULL,NULL,NULL,NULL,NULL,'2025-09-06 01:40:05','2025-09-06 01:40:05',1,NULL),(4,'69faad05-8ac2-11f0-b650-7abd935312df','mjones','mike.jones@testdealership.com','Mike','Jones','$2y$12$MK0uxed3TuxbMI9PUwHTXuMOk3qJNlyGQjFgWyadVL4mrF/0Ch.fK','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',4,7,1,1,1,0,NULL,NULL,0,1,'2025-09-06 01:40:05',NULL,NULL,NULL,NULL,NULL,NULL,'2025-09-06 01:40:05','2025-09-06 01:40:05',1,NULL),(5,'69faaf52-8ac2-11f0-b650-7abd935312df','sinstaller','service.installer@testdealership.com','Service','Installer','$2y$12$MK0uxed3TuxbMI9PUwHTXuMOk3qJNlyGQjFgWyadVL4mrF/0Ch.fK','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',4,8,1,1,1,0,NULL,NULL,0,1,'2025-09-06 01:40:05',NULL,NULL,NULL,NULL,NULL,NULL,'2025-09-06 01:40:05','2025-09-06 01:40:05',1,NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-09-13 14:18:23
