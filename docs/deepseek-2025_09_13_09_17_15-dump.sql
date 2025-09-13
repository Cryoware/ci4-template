-- MySQL dump 10.13  Distrib 8.4.6, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: deepseek
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
-- Temporary view structure for view `cost_analysis_by_type`
--

DROP TABLE IF EXISTS `cost_analysis_by_type`;
/*!50001 DROP VIEW IF EXISTS `cost_analysis_by_type`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `cost_analysis_by_type` AS SELECT 
 1 AS `fluid_type_id`,
 1 AS `fluid_type`,
 1 AS `number_of_products`,
 1 AS `total_inventory`,
 1 AS `total_inventory_value`,
 1 AS `usage_last_30_days`,
 1 AS `cost_last_30_days`,
 1 AS `avg_daily_usage`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `daily_usage_summary`
--

DROP TABLE IF EXISTS `daily_usage_summary`;
/*!50001 DROP VIEW IF EXISTS `daily_usage_summary`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `daily_usage_summary` AS SELECT 
 1 AS `usage_date`,
 1 AS `product_id`,
 1 AS `product_name`,
 1 AS `fluid_type`,
 1 AS `transaction_type`,
 1 AS `total_quantity`,
 1 AS `unit`,
 1 AS `total_cost`,
 1 AS `transaction_count`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `dashboard_overview`
--

DROP TABLE IF EXISTS `dashboard_overview`;
/*!50001 DROP VIEW IF EXISTS `dashboard_overview`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `dashboard_overview` AS SELECT 
 1 AS `total_products`,
 1 AS `active_tanks`,
 1 AS `active_work_orders`,
 1 AS `low_stock_items`,
 1 AS `today_transactions`,
 1 AS `total_fluid_volume`,
 1 AS `inventory_value`,
 1 AS `recent_sensor_readings`,
 1 AS `work_orders_today`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `fluid_transactions`
--

DROP TABLE IF EXISTS `fluid_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fluid_transactions` (
  `transaction_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `transaction_type` tinyint unsigned NOT NULL,
  `product_id` int unsigned NOT NULL,
  `tank_id` int unsigned DEFAULT NULL COMMENT 'NULL if transaction doesn''t involve a specific tank (e.g., new purchase ',
  `reel_id` int unsigned DEFAULT NULL COMMENT 'NULL if dispensed manually or not from a reel',
  `work_order_id` int unsigned DEFAULT NULL COMMENT 'Link to the work order module',
  `quantity` decimal(10,2) NOT NULL COMMENT 'How much was added/removed (in the product''s unit_of_measurHow much was added/removed (in the product''s unit_of_measur',
  `volume_before` decimal(10,2) unsigned DEFAULT NULL COMMENT 'Tank volume before transaction (in gallons)',
  `volume_after` decimal(10,2) unsigned DEFAULT NULL COMMENT 'Tank volume after transaction (in gallons)',
  `source_or_destination` varchar(255) DEFAULT NULL COMMENT 'e.g., "Purchase Order #45012", "Work Order #78921 for VIN XYZ"',
  `notes` text,
  `user_id` int unsigned DEFAULT NULL COMMENT 'ID of the user who performed the action',
  `transaction_timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`transaction_id`),
  KEY `transaction_type` (`transaction_type`),
  KEY `product_id` (`product_id`),
  KEY `tank_id` (`tank_id`),
  KEY `reel_id` (`reel_id`),
  KEY `work_order_id` (`work_order_id`),
  CONSTRAINT `fluid_transactions_ibfk_1` FOREIGN KEY (`transaction_type`) REFERENCES `transaction_types` (`type_id`) ON DELETE RESTRICT,
  CONSTRAINT `fluid_transactions_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE RESTRICT,
  CONSTRAINT `fluid_transactions_ibfk_3` FOREIGN KEY (`tank_id`) REFERENCES `tanks` (`tank_id`) ON DELETE SET NULL,
  CONSTRAINT `fluid_transactions_ibfk_4` FOREIGN KEY (`reel_id`) REFERENCES `reels` (`reel_id`) ON DELETE SET NULL,
  CONSTRAINT `fluid_transactions_ibfk_5` FOREIGN KEY (`work_order_id`) REFERENCES `work_orders` (`work_order_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fluid_transactions`
--

LOCK TABLES `fluid_transactions` WRITE;
/*!40000 ALTER TABLE `fluid_transactions` DISABLE KEYS */;
INSERT INTO `fluid_transactions` VALUES (1,3,1,1,1,1,5.00,80.50,75.50,'Work Order EXT-WO-1001','Oil change - 2023 Camry',101,'2025-09-12 22:38:24'),(2,3,4,4,4,2,12.00,140.00,128.00,'Work Order EXT-WO-1002','Transmission flush - F-150',102,'2025-09-12 22:38:24'),(3,3,6,3,3,3,2.00,16.00,14.00,'Work Order INT-003','Grease service - Civic',103,'2025-09-12 22:38:24'),(4,2,1,1,NULL,NULL,50.00,75.50,125.50,'Bulk Delivery #4501','Weekly oil delivery',100,'2025-09-12 22:38:24'),(5,2,4,4,NULL,NULL,40.00,128.00,168.00,'Bulk Delivery #4502','ATF bulk delivery',100,'2025-09-12 22:38:24'),(6,5,1,1,NULL,NULL,-2.00,125.50,123.50,'Inventory Adjustment','Spill cleanup',100,'2025-09-12 22:38:24');
/*!40000 ALTER TABLE `fluid_transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fluid_types`
--

DROP TABLE IF EXISTS `fluid_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fluid_types` (
  `fluid_type_id` smallint unsigned NOT NULL AUTO_INCREMENT,
  `type_name` varchar(50) NOT NULL COMMENT 'e.g., ''Motor Oil'', ''Transmission Fluid'', ''Grease''',
  `description` text,
  PRIMARY KEY (`fluid_type_id`),
  UNIQUE KEY `type_name` (`type_name`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fluid_types`
--

LOCK TABLES `fluid_types` WRITE;
/*!40000 ALTER TABLE `fluid_types` DISABLE KEYS */;
INSERT INTO `fluid_types` VALUES (1,'Motor Oil','Engine lubricants for gasoline and diesel engines'),(2,'Transmission Fluid','Fluids for automatic and manual transmissions'),(3,'Grease','Lubricating grease for bearings, joints, and components'),(4,'Brake Fluid','Hydraulic fluid for brake systems'),(5,'Antifreeze/Coolant','Engine cooling and antifreeze solutions'),(6,'Windshield Washer Fluid','Fluid for cleaning windshields');
/*!40000 ALTER TABLE `fluid_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `fluid_usage_analytics`
--

DROP TABLE IF EXISTS `fluid_usage_analytics`;
/*!50001 DROP VIEW IF EXISTS `fluid_usage_analytics`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `fluid_usage_analytics` AS SELECT 
 1 AS `transaction_date`,
 1 AS `year`,
 1 AS `month`,
 1 AS `week`,
 1 AS `product_id`,
 1 AS `product_name`,
 1 AS `fluid_type_id`,
 1 AS `fluid_type`,
 1 AS `transaction_type`,
 1 AS `transaction_count`,
 1 AS `total_quantity`,
 1 AS `unit`,
 1 AS `total_cost`,
 1 AS `tank_id`,
 1 AS `tank_name`,
 1 AS `work_orders_affected`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `fluid_usage_analytics_simplified`
--

DROP TABLE IF EXISTS `fluid_usage_analytics_simplified`;
/*!50001 DROP VIEW IF EXISTS `fluid_usage_analytics_simplified`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `fluid_usage_analytics_simplified` AS SELECT 
 1 AS `transaction_date`,
 1 AS `year`,
 1 AS `month`,
 1 AS `quarter`,
 1 AS `product_id`,
 1 AS `product_name`,
 1 AS `fluid_type_id`,
 1 AS `fluid_type`,
 1 AS `manufacturer`,
 1 AS `transaction_type`,
 1 AS `transaction_count`,
 1 AS `total_quantity`,
 1 AS `unit`,
 1 AS `total_cost`,
 1 AS `avg_quantity_per_transaction`,
 1 AS `distinct_work_orders`,
 1 AS `distinct_users`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `manufacturers`
--

DROP TABLE IF EXISTS `manufacturers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `manufacturers` (
  `manufacturer_id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `contact_info` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`manufacturer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `manufacturers`
--

LOCK TABLES `manufacturers` WRITE;
/*!40000 ALTER TABLE `manufacturers` DISABLE KEYS */;
INSERT INTO `manufacturers` VALUES (1,'Mobil','1-800-ASK-MOBIL','2025-09-12 22:05:53'),(2,'Valvoline','1-800-TEAM-VAL','2025-09-12 22:05:53'),(3,'Castrol','1-888-CASTROL','2025-09-12 22:05:53'),(4,'Lucas Oil','1-800-342-2512','2025-09-12 22:05:53'),(5,'Shell','1-888-GO-SHELL','2025-09-12 22:05:53'),(6,'Chevron','1-800-582-3835','2025-09-12 22:05:53');
/*!40000 ALTER TABLE `manufacturers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `monthly_product_usage`
--

DROP TABLE IF EXISTS `monthly_product_usage`;
/*!50001 DROP VIEW IF EXISTS `monthly_product_usage`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `monthly_product_usage` AS SELECT 
 1 AS `year`,
 1 AS `month`,
 1 AS `product_id`,
 1 AS `product_name`,
 1 AS `fluid_type`,
 1 AS `manufacturer`,
 1 AS `total_quantity_used`,
 1 AS `unit`,
 1 AS `total_cost`,
 1 AS `work_orders_served`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `product_inventory`
--

DROP TABLE IF EXISTS `product_inventory`;
/*!50001 DROP VIEW IF EXISTS `product_inventory`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `product_inventory` AS SELECT 
 1 AS `product_id`,
 1 AS `product_name`,
 1 AS `manufacturer_part_number`,
 1 AS `manufacturer`,
 1 AS `fluid_type`,
 1 AS `viscosity_grade`,
 1 AS `current_quantity`,
 1 AS `unit`,
 1 AS `min_stock_level`,
 1 AS `stock_status`,
 1 AS `cost_per_unit`,
 1 AS `value_on_hand`,
 1 AS `is_hazmat`,
 1 AS `created_at`,
 1 AS `updated_at`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `product_id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL COMMENT 'e.g., "5W-30 Full Synthetic Motor Oil"',
  `description` text,
  `manufacturer_id` int unsigned NOT NULL,
  `manufacturer_part_number` varchar(100) DEFAULT NULL,
  `fluid_type_id` smallint unsigned NOT NULL,
  `viscosity_grade` varchar(50) DEFAULT NULL COMMENT 'e.g., ''5W-30'', ''75W-90'', ''ATF+4''',
  `specifications` text COMMENT 'e.g., ''API SP, GM dexos1 Gen 3''',
  `unit_id` smallint unsigned NOT NULL,
  `is_hazmat` tinyint(1) NOT NULL DEFAULT '0',
  `cost_per_unit` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `min_stock_level` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT 'Can be a decimal for partial units',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`product_id`),
  KEY `manufacturer_id` (`manufacturer_id`),
  KEY `fluid_type_id` (`fluid_type_id`),
  KEY `unit_id` (`unit_id`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`manufacturer_id`) REFERENCES `manufacturers` (`manufacturer_id`) ON DELETE RESTRICT,
  CONSTRAINT `products_ibfk_2` FOREIGN KEY (`fluid_type_id`) REFERENCES `fluid_types` (`fluid_type_id`) ON DELETE RESTRICT,
  CONSTRAINT `products_ibfk_3` FOREIGN KEY (`unit_id`) REFERENCES `units` (`unit_id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'Mobil 1 5W-30 Full Synthetic','Advanced full synthetic motor oil',1,'M1-110',1,'5W-30','API SP, GM dexos1 Gen 3',318,0,8.99,24.00,'2025-09-12 22:23:28','2025-09-12 22:23:47'),(2,'Valvoline 10W-40 Conventional','High-quality conventional motor oil',2,'VV-1040',1,'10W-40','API SN',317,0,22.50,4.00,'2025-09-12 22:23:28','2025-09-12 22:23:47'),(3,'Castrol EDGE 0W-20','Advanced synthetic motor oil',3,'CST-0W20',1,'0W-20','API SP, Ford WSS-M2C947-A',318,0,9.25,18.00,'2025-09-12 22:23:28','2025-09-12 22:23:47'),(4,'Mobil ATF 3309','Automatic transmission fluid',1,'M-3309',2,'ATF','Toyota T-IV, JWS3309',318,1,12.75,12.00,'2025-09-12 22:23:28','2025-09-12 22:23:47'),(5,'Valvoline MaxLife ATF','Full synthetic ATF',2,'VV-ATF',2,'ATF+4','Multi-vehicle formula',317,1,38.99,2.00,'2025-09-12 22:23:28','2025-09-12 22:23:47'),(6,'Lucas Red N Tacky Grease','Premium lithium grease',4,'LUC-10304',3,'NLGI #2','Water resistant, high temp',322,0,3.50,36.00,'2025-09-12 22:23:28','2025-09-12 22:23:47'),(7,'Mobilgrease XHP 222','High performance grease',1,'MG-222',3,'NLGI #2','Lithium complex, extreme pressure',322,0,4.25,24.00,'2025-09-12 22:23:28','2025-09-12 22:23:47'),(8,'Shell Zone Coolant','Extended life coolant',5,'SH-ZC1G',5,'50/50','OAT technology',317,1,18.99,4.00,'2025-09-12 22:23:28','2025-09-12 22:23:47'),(9,'Chevron DOT 4 Brake Fluid','High performance brake fluid',6,'CH-DOT4',4,'DOT 4','FMVSS 116, ISO 4925',318,1,15.50,6.00,'2025-09-12 22:23:28','2025-09-12 22:23:47');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reel_types`
--

DROP TABLE IF EXISTS `reel_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reel_types` (
  `reel_type_id` smallint unsigned NOT NULL AUTO_INCREMENT,
  `type_name` varchar(50) NOT NULL COMMENT 'e.g., ''Manual Grease'', ''Air-Powered Oil'', ''Electric Coolant''',
  `hose_length` decimal(5,2) unsigned DEFAULT NULL COMMENT 'Length in feet',
  `max_flow_rate` decimal(6,2) unsigned DEFAULT NULL COMMENT 'gallons per minute',
  PRIMARY KEY (`reel_type_id`),
  UNIQUE KEY `type_name` (`type_name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reel_types`
--

LOCK TABLES `reel_types` WRITE;
/*!40000 ALTER TABLE `reel_types` DISABLE KEYS */;
INSERT INTO `reel_types` VALUES (1,'Manual Oil Reel',15.00,1.50),(2,'Air-Powered Oil Reel',20.00,2.50),(3,'Manual Grease Reel',12.00,0.80),(4,'Electric Coolant Reel',18.00,1.20);
/*!40000 ALTER TABLE `reel_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `reel_utilization`
--

DROP TABLE IF EXISTS `reel_utilization`;
/*!50001 DROP VIEW IF EXISTS `reel_utilization`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `reel_utilization` AS SELECT 
 1 AS `reel_id`,
 1 AS `reel_name`,
 1 AS `reel_type`,
 1 AS `hose_length`,
 1 AS `max_flow_rate`,
 1 AS `tank_id`,
 1 AS `tank_name`,
 1 AS `product_name`,
 1 AS `asset_tag`,
 1 AS `reel_status`,
 1 AS `total_dispenses`,
 1 AS `total_fluid_dispensed`,
 1 AS `unit`,
 1 AS `first_use`,
 1 AS `last_use`,
 1 AS `last_7_days_uses`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `reels`
--

DROP TABLE IF EXISTS `reels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reels` (
  `reel_id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT 'e.g., "Lube Bay Grease Reel #1"',
  `reel_type_id` smallint unsigned NOT NULL,
  `tank_id` int unsigned NOT NULL COMMENT 'Which tank is this reel attached to?',
  `asset_tag` varchar(50) DEFAULT NULL COMMENT 'Physical barcode/RFID tag number',
  `status_id` tinyint unsigned NOT NULL DEFAULT '1' COMMENT 'Re-use the tank_statuses table',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`reel_id`),
  UNIQUE KEY `asset_tag` (`asset_tag`),
  KEY `reel_type_id` (`reel_type_id`),
  KEY `tank_id` (`tank_id`),
  KEY `status_id` (`status_id`),
  CONSTRAINT `reels_ibfk_1` FOREIGN KEY (`reel_type_id`) REFERENCES `reel_types` (`reel_type_id`) ON DELETE RESTRICT,
  CONSTRAINT `reels_ibfk_2` FOREIGN KEY (`tank_id`) REFERENCES `tanks` (`tank_id`) ON DELETE CASCADE,
  CONSTRAINT `reels_ibfk_3` FOREIGN KEY (`status_id`) REFERENCES `tank_statuses` (`status_id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reels`
--

LOCK TABLES `reels` WRITE;
/*!40000 ALTER TABLE `reels` DISABLE KEYS */;
INSERT INTO `reels` VALUES (1,'Quick Lube Oil Reel #1',1,1,'REEL-001',1,'2025-09-12 22:30:40','2025-09-12 22:33:59'),(2,'Synthetic Oil Reel #2',2,2,'REEL-002',1,'2025-09-12 22:30:40','2025-09-12 22:33:59'),(3,'Main Grease Reel - Central',3,3,'REEL-003',1,'2025-09-12 22:30:40','2025-09-12 22:33:59'),(4,'ATF Dispensing Reel',1,4,'REEL-004',1,'2025-09-12 22:30:40','2025-09-12 22:33:59');
/*!40000 ALTER TABLE `reels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `sensor_data_history`
--

DROP TABLE IF EXISTS `sensor_data_history`;
/*!50001 DROP VIEW IF EXISTS `sensor_data_history`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `sensor_data_history` AS SELECT 
 1 AS `reading_id`,
 1 AS `sensor_id`,
 1 AS `sensor_name`,
 1 AS `sensor_type`,
 1 AS `tank_id`,
 1 AS `tank_name`,
 1 AS `product_name`,
 1 AS `raw_value`,
 1 AS `raw_unit`,
 1 AS `calculated_volume`,
 1 AS `volume_unit`,
 1 AS `reading_timestamp`,
 1 AS `volume_change`,
 1 AS `minutes_since_last_reading`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `sensor_readings`
--

DROP TABLE IF EXISTS `sensor_readings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sensor_readings` (
  `reading_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `sensor_id` int unsigned NOT NULL,
  `raw_value` decimal(12,6) NOT NULL COMMENT 'The raw value read from the sensor',
  `calculated_volume` decimal(10,2) unsigned NOT NULL COMMENT 'The calculated volume in gallons after calibration',
  `reading_timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`reading_id`),
  KEY `sensor_id` (`sensor_id`),
  CONSTRAINT `sensor_readings_ibfk_1` FOREIGN KEY (`sensor_id`) REFERENCES `tank_sensors` (`sensor_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sensor_readings`
--

LOCK TABLES `sensor_readings` WRITE;
/*!40000 ALTER TABLE `sensor_readings` DISABLE KEYS */;
INSERT INTO `sensor_readings` VALUES (1,1,21.500000,78.50,'2025-09-12 20:38:57'),(2,1,21.300000,79.20,'2025-09-12 21:38:57'),(3,1,20.800000,81.00,'2025-09-12 22:38:57'),(4,2,72.500000,72.50,'2025-09-12 20:38:57'),(5,2,73.100000,73.10,'2025-09-12 21:38:57'),(6,2,74.200000,74.20,'2025-09-12 22:38:57'),(7,4,8.200000,15.20,'2025-09-12 19:38:57'),(8,4,8.100000,15.40,'2025-09-12 20:38:57'),(9,4,7.900000,15.80,'2025-09-12 21:38:57');
/*!40000 ALTER TABLE `sensor_readings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sensor_types`
--

DROP TABLE IF EXISTS `sensor_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sensor_types` (
  `sensor_type_id` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `type_name` varchar(50) NOT NULL COMMENT 'e.g., ''Ultrasonic Level'', ''Pressure Transducer'', ''RTD Temperature''',
  `measurement_unit_id` smallint unsigned NOT NULL,
  `description` text,
  PRIMARY KEY (`sensor_type_id`),
  UNIQUE KEY `type_name` (`type_name`),
  KEY `sensor_types_ibfk_1` (`measurement_unit_id`),
  CONSTRAINT `sensor_types_ibfk_1` FOREIGN KEY (`measurement_unit_id`) REFERENCES `units` (`unit_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sensor_types`
--

LOCK TABLES `sensor_types` WRITE;
/*!40000 ALTER TABLE `sensor_types` DISABLE KEYS */;
INSERT INTO `sensor_types` VALUES (1,'Ultrasonic Level Sensor',325,'Measures distance to liquid surface'),(2,'Pressure Transducer',344,'Measures hydrostatic pressure at tank bottom'),(3,'Temperature Sensor',346,'Fluid temperature monitoring'),(4,'Load Cell',334,'Measures weight of tank and contents'),(5,'Float Switch',369,'Digital switch for high/low level');
/*!40000 ALTER TABLE `sensor_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `system_settings`
--

DROP TABLE IF EXISTS `system_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `system_settings` (
  `setting_id` int unsigned NOT NULL AUTO_INCREMENT,
  `setting_name` varchar(50) NOT NULL,
  `setting_value` varchar(255) NOT NULL,
  `description` text,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`setting_id`),
  UNIQUE KEY `setting_name` (`setting_name`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `system_settings`
--

LOCK TABLES `system_settings` WRITE;
/*!40000 ALTER TABLE `system_settings` DISABLE KEYS */;
INSERT INTO `system_settings` VALUES (1,'default_unit_system','imperial','Default measurement system for display','2025-09-12 22:08:08'),(2,'low_stock_alert_threshold','0.10','Percentage of min stock level to trigger alert','2025-09-12 22:08:08'),(3,'sensor_polling_interval','300','Seconds between sensor readings','2025-09-12 22:08:08'),(4,'auto_tank_volume_update','true','Automatically update tank volume from primary sensor','2025-09-12 22:08:08');
/*!40000 ALTER TABLE `system_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tank_sensors`
--

DROP TABLE IF EXISTS `tank_sensors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tank_sensors` (
  `sensor_id` int unsigned NOT NULL AUTO_INCREMENT,
  `tank_id` int unsigned NOT NULL,
  `sensor_type_id` tinyint unsigned NOT NULL,
  `name` varchar(100) NOT NULL COMMENT 'e.g., "Main Level Sensor"',
  `calibration_value` decimal(10,4) NOT NULL DEFAULT '0.0000' COMMENT 'Value to add/subtract from raw read',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `is_primary` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`sensor_id`),
  KEY `tank_id` (`tank_id`),
  KEY `sensor_type_id` (`sensor_type_id`),
  CONSTRAINT `tank_sensors_ibfk_1` FOREIGN KEY (`tank_id`) REFERENCES `tanks` (`tank_id`) ON DELETE CASCADE,
  CONSTRAINT `tank_sensors_ibfk_2` FOREIGN KEY (`sensor_type_id`) REFERENCES `sensor_types` (`sensor_type_id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tank_sensors`
--

LOCK TABLES `tank_sensors` WRITE;
/*!40000 ALTER TABLE `tank_sensors` DISABLE KEYS */;
INSERT INTO `tank_sensors` VALUES (1,1,1,'Main Oil Tank - Ultrasonic',0.5000,'2025-09-12 22:37:29',1),(2,1,3,'Main Oil Tank - Temperature',0.0000,'2025-09-12 22:37:29',0),(3,2,1,'Synthetic Tank - Ultrasonic',-0.3000,'2025-09-12 22:37:29',1),(4,3,2,'Grease Tank - Pressure',1.2000,'2025-09-12 22:37:29',1),(5,4,1,'ATF Tank - Ultrasonic',0.8000,'2025-09-12 22:37:29',1);
/*!40000 ALTER TABLE `tank_sensors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `tank_status_detailed`
--

DROP TABLE IF EXISTS `tank_status_detailed`;
/*!50001 DROP VIEW IF EXISTS `tank_status_detailed`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `tank_status_detailed` AS SELECT 
 1 AS `tank_id`,
 1 AS `tank_name`,
 1 AS `description`,
 1 AS `product_name`,
 1 AS `product_id`,
 1 AS `fluid_type`,
 1 AS `manufacturer`,
 1 AS `capacity`,
 1 AS `capacity_unit`,
 1 AS `current_volume`,
 1 AS `volume_unit`,
 1 AS `fill_percentage`,
 1 AS `status_level`,
 1 AS `tank_status`,
 1 AS `calibration_factor`,
 1 AS `created_at`,
 1 AS `updated_at`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `tank_status_view`
--

DROP TABLE IF EXISTS `tank_status_view`;
/*!50001 DROP VIEW IF EXISTS `tank_status_view`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `tank_status_view` AS SELECT 
 1 AS `tank_id`,
 1 AS `tank_name`,
 1 AS `product_name`,
 1 AS `capacity`,
 1 AS `capacity_unit`,
 1 AS `current_volume`,
 1 AS `volume_unit`,
 1 AS `fill_percentage`,
 1 AS `primary_sensor_name`,
 1 AS `last_sensor_volume`,
 1 AS `last_reading`,
 1 AS `status_id`,
 1 AS `status_name`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tank_statuses`
--

DROP TABLE IF EXISTS `tank_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tank_statuses` (
  `status_id` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `status_name` varchar(20) NOT NULL COMMENT 'e.g., ''Active'', ''Maintenance'', ''Decommissioned''',
  PRIMARY KEY (`status_id`),
  UNIQUE KEY `status_name` (`status_name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tank_statuses`
--

LOCK TABLES `tank_statuses` WRITE;
/*!40000 ALTER TABLE `tank_statuses` DISABLE KEYS */;
INSERT INTO `tank_statuses` VALUES (1,'Active'),(3,'Decommissioned'),(2,'Maintenance');
/*!40000 ALTER TABLE `tank_statuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `tank_usage_analytics`
--

DROP TABLE IF EXISTS `tank_usage_analytics`;
/*!50001 DROP VIEW IF EXISTS `tank_usage_analytics`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `tank_usage_analytics` AS SELECT 
 1 AS `tank_id`,
 1 AS `tank_name`,
 1 AS `product_name`,
 1 AS `transaction_date`,
 1 AS `transaction_type`,
 1 AS `total_quantity`,
 1 AS `unit`,
 1 AS `transaction_count`,
 1 AS `work_orders_affected`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tanks`
--

DROP TABLE IF EXISTS `tanks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tanks` (
  `tank_id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT 'e.g., "Bay 1 Oil Tank", "Main Grease Reservoir"',
  `description` text,
  `product_id` int unsigned NOT NULL COMMENT 'What product is currently in the tank?',
  `capacity` decimal(10,2) unsigned NOT NULL,
  `capacity_unit_id` smallint unsigned NOT NULL,
  `current_volume` decimal(12,6) unsigned NOT NULL DEFAULT '0.000000',
  `volume_display_unit_id` smallint unsigned NOT NULL,
  `status_id` tinyint unsigned NOT NULL DEFAULT '1' COMMENT 'Default to ''Active''',
  `calibration_factor` decimal(5,2) NOT NULL DEFAULT '1.00' COMMENT 'Multiplier to adjust sensor reading if inaccurate',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`tank_id`),
  KEY `product_id` (`product_id`),
  KEY `status_id` (`status_id`),
  KEY `capacity_unit_id` (`capacity_unit_id`),
  KEY `volume_display_unit_id` (`volume_display_unit_id`),
  CONSTRAINT `tanks_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE RESTRICT,
  CONSTRAINT `tanks_ibfk_2` FOREIGN KEY (`status_id`) REFERENCES `tank_statuses` (`status_id`) ON DELETE RESTRICT,
  CONSTRAINT `tanks_ibfk_3` FOREIGN KEY (`capacity_unit_id`) REFERENCES `units` (`unit_id`) ON DELETE RESTRICT,
  CONSTRAINT `tanks_ibfk_4` FOREIGN KEY (`volume_display_unit_id`) REFERENCES `units` (`unit_id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tanks`
--

LOCK TABLES `tanks` WRITE;
/*!40000 ALTER TABLE `tanks` DISABLE KEYS */;
INSERT INTO `tanks` VALUES (1,'Main Oil Tank - Bay 1','Primary 5W-30 storage for quick lube bay',1,100.00,317,78.500000,317,1,1.02,'2025-09-12 22:28:33','2025-09-12 22:30:17'),(2,'Synthetic Oil Tank - Bay 2','0W-20 synthetic for import vehicles',3,50.00,317,42.300000,317,1,0.98,'2025-09-12 22:28:33','2025-09-12 22:30:17'),(3,'Grease Reservoir - Lube Bay','Central grease system for all bays',6,20.00,317,15.200000,317,1,1.01,'2025-09-12 22:28:33','2025-09-12 22:30:17'),(4,'ATF Bulk Tank','Bulk transmission fluid storage',4,150.00,317,132.800000,317,1,0.99,'2025-09-12 22:28:33','2025-09-12 22:30:17');
/*!40000 ALTER TABLE `tanks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transaction_types`
--

DROP TABLE IF EXISTS `transaction_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transaction_types` (
  `type_id` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `type_name` varchar(20) NOT NULL COMMENT 'e.g., ''FILL'', ''MANUAL_ADD'', ''DISPENSE'', ''ADJUST''',
  PRIMARY KEY (`type_id`),
  UNIQUE KEY `type_name` (`type_name`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transaction_types`
--

LOCK TABLES `transaction_types` WRITE;
/*!40000 ALTER TABLE `transaction_types` DISABLE KEYS */;
INSERT INTO `transaction_types` VALUES (5,'ADJUST'),(3,'DISPENSE'),(2,'FILL'),(4,'MANUAL_ADD'),(1,'PURCHASE'),(6,'TRANSFER');
/*!40000 ALTER TABLE `transaction_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `unit_types`
--

DROP TABLE IF EXISTS `unit_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `unit_types` (
  `unit_type_id` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `type_name` varchar(50) NOT NULL,
  `base_unit_name` varchar(20) NOT NULL COMMENT 'The name of the unit we will use for internal storage',
  `description` text,
  PRIMARY KEY (`unit_type_id`),
  UNIQUE KEY `type_name` (`type_name`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `unit_types`
--

LOCK TABLES `unit_types` WRITE;
/*!40000 ALTER TABLE `unit_types` DISABLE KEYS */;
INSERT INTO `unit_types` VALUES (1,'Volume','liter','Measure of capacity for fluids'),(2,'Length','meter','Measure of distance'),(3,'Weight','gram','Measure of mass'),(4,'Pressure','pascal','Measure of force per unit area'),(5,'Temperature','celsius','Measure of thermal energy'),(6,'Time','second','Measure of duration'),(7,'Volume Flow Rate','liter_per_second','Measure of volumetric flow'),(8,'Mass Flow Rate','gram_per_second','Measure of mass flow'),(9,'Electrical Current','ampere','Measure of electric current'),(10,'Electrical Voltage','volt','Measure of electric potential'),(11,'Percentage','percent','Ratio expressed as a fraction of 100'),(12,'Count','each','Dimensionless quantity or count of items'),(13,'Digital','state','Digital on/off or true/false state');
/*!40000 ALTER TABLE `unit_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `units`
--

DROP TABLE IF EXISTS `units`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `units` (
  `unit_id` smallint unsigned NOT NULL AUTO_INCREMENT,
  `unit_name` varchar(20) NOT NULL,
  `unit_abbreviation` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `unit_type_id` tinyint unsigned NOT NULL,
  `system` enum('metric','imperial','other') NOT NULL DEFAULT 'other',
  `conversion_to_base` decimal(12,6) NOT NULL,
  PRIMARY KEY (`unit_id`),
  UNIQUE KEY `unit_name` (`unit_name`),
  UNIQUE KEY `unit_abbreviation` (`unit_abbreviation`),
  KEY `unit_type_id` (`unit_type_id`),
  CONSTRAINT `units_ibfk_1` FOREIGN KEY (`unit_type_id`) REFERENCES `unit_types` (`unit_type_id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=372 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `units`
--

LOCK TABLES `units` WRITE;
/*!40000 ALTER TABLE `units` DISABLE KEYS */;
INSERT INTO `units` VALUES (312,'cubic meter','m³',1,'metric',1000.000000),(313,'liter','L',1,'metric',1.000000),(314,'milliliter','mL',1,'metric',0.001000),(315,'centiliter','cL',1,'metric',0.010000),(316,'hectoliter','hL',1,'metric',100.000000),(317,'gallon','gal',1,'imperial',3.785412),(318,'quart','qt',1,'imperial',0.946353),(319,'pint','pt',1,'imperial',0.473176),(320,'fluid ounce','fl oz',1,'imperial',0.029574),(321,'barrel (oil)','bbl',1,'imperial',158.987295),(322,'cartridge','ctg',1,'other',0.400000),(323,'tube','tube',1,'other',0.100000),(324,'drum','drum',1,'other',208.198000),(325,'meter','m',2,'metric',1.000000),(326,'kilometer','km',2,'metric',1000.000000),(327,'centimeter','cm',2,'metric',0.010000),(328,'millimeter','mm',2,'metric',0.001000),(329,'inch','in',2,'imperial',0.025400),(330,'foot','ft',2,'imperial',0.304800),(331,'yard','yd',2,'imperial',0.914400),(332,'mile','mi',2,'imperial',1609.344000),(333,'gram','g',3,'metric',1.000000),(334,'kilogram','kg',3,'metric',1000.000000),(335,'milligram','mg',3,'metric',0.001000),(336,'metric ton','t',3,'metric',999999.990000),(337,'ounce','oz',3,'imperial',28.349523),(338,'pound','lb',3,'imperial',453.592370),(339,'us ton','ton (US)',3,'imperial',907184.740000),(340,'pascal','Pa',4,'metric',1.000000),(341,'kilopascal','kPa',4,'metric',1000.000000),(342,'bar','bar',4,'metric',100000.000000),(343,'millibar','mbar',4,'metric',100.000000),(344,'pounds per sq inch','psi',4,'imperial',6894.757293),(345,'inches of mercury','inHg',4,'imperial',3386.389000),(346,'celsius','°C',5,'metric',1.000000),(347,'fahrenheit','°F',5,'imperial',1.000000),(348,'kelvin','K',5,'metric',1.000000),(349,'second','s',6,'other',1.000000),(350,'millisecond','ms',6,'other',0.001000),(351,'minute','min',6,'other',60.000000),(352,'hour','hr',6,'other',3600.000000),(353,'day','day',6,'other',86400.000000),(354,'liter per second','L/s',7,'metric',1.000000),(355,'liter per minute','L/min',7,'metric',0.016667),(356,'gallon per minute','GPM',7,'imperial',0.063090),(357,'cubic meter per hour','m³/h',7,'metric',0.277778),(358,'gram per second','g/s',8,'metric',1.000000),(359,'kilogram per hour','kg/h',8,'metric',0.277778),(360,'pound per hour','lb/h',8,'imperial',0.125998),(361,'ampere','A',9,'metric',1.000000),(362,'milliampere','mA',9,'metric',0.001000),(363,'volt','V',10,'metric',1.000000),(364,'millivolt','mV',10,'metric',0.001000),(365,'percent','%',11,'other',1.000000),(366,'ratio','ratio',11,'other',100.000000),(367,'each','ea',12,'other',1.000000),(368,'dozen','doz',12,'other',12.000000),(369,'state','state',13,'other',1.000000),(370,'on/off','on/off',13,'other',1.000000),(371,'open/closed','open/closed',13,'other',1.000000);
/*!40000 ALTER TABLE `units` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `work_order_consumables`
--

DROP TABLE IF EXISTS `work_order_consumables`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `work_order_consumables` (
  `consumable_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `work_order_id` int unsigned NOT NULL,
  `product_id` int unsigned NOT NULL,
  `tank_id` int unsigned DEFAULT NULL COMMENT 'NULL if dispensed from bulk storage, not a tank',
  `reel_id` int unsigned DEFAULT NULL COMMENT 'NULL if dispensed manually',
  `quantity_used` decimal(10,2) unsigned NOT NULL COMMENT 'Qty used in the product''s unit_of_measure -- Optional: Snapshots of product details at the time of use for historical accuracy -- This denormalization is good practice in case product names or costs change later.',
  `snapshot_product_name` varchar(255) NOT NULL,
  `snapshot_product_cost` decimal(10,2) unsigned NOT NULL,
  `usage_timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `notes` text,
  PRIMARY KEY (`consumable_id`),
  KEY `work_order_id` (`work_order_id`),
  KEY `product_id` (`product_id`),
  KEY `tank_id` (`tank_id`),
  KEY `reel_id` (`reel_id`),
  CONSTRAINT `work_order_consumables_ibfk_1` FOREIGN KEY (`work_order_id`) REFERENCES `work_orders` (`work_order_id`) ON DELETE CASCADE,
  CONSTRAINT `work_order_consumables_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE RESTRICT,
  CONSTRAINT `work_order_consumables_ibfk_3` FOREIGN KEY (`tank_id`) REFERENCES `tanks` (`tank_id`) ON DELETE SET NULL,
  CONSTRAINT `work_order_consumables_ibfk_4` FOREIGN KEY (`reel_id`) REFERENCES `reels` (`reel_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `work_order_consumables`
--

LOCK TABLES `work_order_consumables` WRITE;
/*!40000 ALTER TABLE `work_order_consumables` DISABLE KEYS */;
INSERT INTO `work_order_consumables` VALUES (1,1,1,1,1,5.00,'Mobil 1 5W-30 Full Synthetic',8.99,'2025-09-12 22:38:31',NULL),(2,2,4,4,4,12.00,'Mobil ATF 3309',12.75,'2025-09-12 22:38:31',NULL),(3,3,6,3,3,2.00,'Lucas Red N Tacky Grease',3.50,'2025-09-12 22:38:31',NULL);
/*!40000 ALTER TABLE `work_order_consumables` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `work_order_fluid_usage`
--

DROP TABLE IF EXISTS `work_order_fluid_usage`;
/*!50001 DROP VIEW IF EXISTS `work_order_fluid_usage`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `work_order_fluid_usage` AS SELECT 
 1 AS `work_order_id`,
 1 AS `external_id`,
 1 AS `description`,
 1 AS `work_order_status`,
 1 AS `created_at`,
 1 AS `completed_at`,
 1 AS `product_id`,
 1 AS `product_name`,
 1 AS `quantity_used`,
 1 AS `unit`,
 1 AS `total_cost`,
 1 AS `products_used`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `work_order_progress`
--

DROP TABLE IF EXISTS `work_order_progress`;
/*!50001 DROP VIEW IF EXISTS `work_order_progress`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `work_order_progress` AS SELECT 
 1 AS `work_order_id`,
 1 AS `external_id`,
 1 AS `description`,
 1 AS `status`,
 1 AS `created_at`,
 1 AS `updated_at`,
 1 AS `completed_at`,
 1 AS `days_open`,
 1 AS `products_used`,
 1 AS `total_quantity_used`,
 1 AS `total_cost`,
 1 AS `involved_technicians`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `work_order_statuses`
--

DROP TABLE IF EXISTS `work_order_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `work_order_statuses` (
  `status_id` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `status_name` varchar(20) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'To filter active vs. historical statuses',
  PRIMARY KEY (`status_id`),
  UNIQUE KEY `status_name` (`status_name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `work_order_statuses`
--

LOCK TABLES `work_order_statuses` WRITE;
/*!40000 ALTER TABLE `work_order_statuses` DISABLE KEYS */;
INSERT INTO `work_order_statuses` VALUES (1,'Pending',1),(2,'In Progress',1),(3,'Completed',1),(4,'On Hold',1),(5,'Cancelled',0);
/*!40000 ALTER TABLE `work_order_statuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `work_orders`
--

DROP TABLE IF EXISTS `work_orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `work_orders` (
  `work_order_id` int unsigned NOT NULL AUTO_INCREMENT,
  `external_id` varchar(100) DEFAULT NULL COMMENT 'ID from an external system (e.g., ''WO-12345'')',
  `description` text NOT NULL COMMENT 'Summary of the work to be done',
  `status_id` tinyint unsigned NOT NULL DEFAULT '1' COMMENT 'Default to first status (e.g., ''Pending'')',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `completed_at` timestamp NULL DEFAULT NULL COMMENT 'Will be set when status moves to ''Completed''',
  PRIMARY KEY (`work_order_id`),
  UNIQUE KEY `external_id` (`external_id`),
  KEY `status_id` (`status_id`),
  CONSTRAINT `work_orders_ibfk_1` FOREIGN KEY (`status_id`) REFERENCES `work_order_statuses` (`status_id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `work_orders`
--

LOCK TABLES `work_orders` WRITE;
/*!40000 ALTER TABLE `work_orders` DISABLE KEYS */;
INSERT INTO `work_orders` VALUES (1,'EXT-WO-1001','2023 Toyota Camry - Oil Change & Rotation',3,'2024-01-15 08:30:00','2025-09-12 22:38:19','2024-01-15 10:15:00'),(2,'EXT-WO-1002','2018 Ford F-150 - Transmission Flush',3,'2024-01-15 09:45:00','2025-09-12 22:38:19','2024-01-15 12:30:00'),(3,NULL,'Honda Civic - Grease Fittings Service',2,'2024-01-16 10:00:00','2025-09-12 22:38:19',NULL),(4,'EXT-WO-1004','Chevrolet Silverado - Coolant Flush',1,'2024-01-16 11:30:00','2025-09-12 22:38:19',NULL);
/*!40000 ALTER TABLE `work_orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `cost_analysis_by_type`
--

/*!50001 DROP VIEW IF EXISTS `cost_analysis_by_type`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `cost_analysis_by_type` AS select `flt`.`fluid_type_id` AS `fluid_type_id`,`flt`.`type_name` AS `fluid_type`,count(distinct `p`.`product_id`) AS `number_of_products`,sum(`pi`.`current_quantity`) AS `total_inventory`,sum(`pi`.`value_on_hand`) AS `total_inventory_value`,sum((case when (`ft`.`transaction_timestamp` >= (curdate() - interval 30 day)) then `ft`.`quantity` else 0 end)) AS `usage_last_30_days`,sum((case when (`ft`.`transaction_timestamp` >= (curdate() - interval 30 day)) then (`ft`.`quantity` * `p`.`cost_per_unit`) else 0 end)) AS `cost_last_30_days`,avg((case when (`ft`.`transaction_timestamp` >= (curdate() - interval 90 day)) then `ft`.`quantity` else NULL end)) AS `avg_daily_usage` from (((`fluid_types` `flt` left join `products` `p` on((`flt`.`fluid_type_id` = `p`.`fluid_type_id`))) left join `product_inventory` `pi` on((`p`.`product_id` = `pi`.`product_id`))) left join `fluid_transactions` `ft` on(((`p`.`product_id` = `ft`.`product_id`) and `ft`.`transaction_type` in (select `transaction_types`.`type_id` from `transaction_types` where (`transaction_types`.`type_name` in ('DISPENSE','USAGE')))))) group by `flt`.`fluid_type_id`,`flt`.`type_name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `daily_usage_summary`
--

/*!50001 DROP VIEW IF EXISTS `daily_usage_summary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `daily_usage_summary` AS select cast(`ft`.`transaction_timestamp` as date) AS `usage_date`,`p`.`product_id` AS `product_id`,`p`.`name` AS `product_name`,`flt`.`type_name` AS `fluid_type`,`tt`.`type_name` AS `transaction_type`,sum(`ft`.`quantity`) AS `total_quantity`,`u`.`unit_abbreviation` AS `unit`,sum((`ft`.`quantity` * `p`.`cost_per_unit`)) AS `total_cost`,count(0) AS `transaction_count` from ((((`fluid_transactions` `ft` join `products` `p` on((`ft`.`product_id` = `p`.`product_id`))) join `fluid_types` `flt` on((`p`.`fluid_type_id` = `flt`.`fluid_type_id`))) join `transaction_types` `tt` on((`ft`.`transaction_type` = `tt`.`type_id`))) join `units` `u` on((`p`.`unit_id` = `u`.`unit_id`))) where (`tt`.`type_name` in ('DISPENSE','USAGE')) group by cast(`ft`.`transaction_timestamp` as date),`p`.`product_id`,`tt`.`type_name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `dashboard_overview`
--

/*!50001 DROP VIEW IF EXISTS `dashboard_overview`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `dashboard_overview` AS select (select count(0) from `products`) AS `total_products`,(select count(0) from `tanks` where (`tanks`.`status_id` = 1)) AS `active_tanks`,(select count(0) from `work_orders` where (`work_orders`.`status_id` in (1,2))) AS `active_work_orders`,(select count(0) from `product_inventory` where (`product_inventory`.`stock_status` <> 'IN_STOCK')) AS `low_stock_items`,(select count(0) from `fluid_transactions` where (`fluid_transactions`.`transaction_timestamp` >= curdate())) AS `today_transactions`,(select sum(`tanks`.`current_volume`) from `tanks`) AS `total_fluid_volume`,(select sum(`product_inventory`.`value_on_hand`) from `product_inventory`) AS `inventory_value`,(select count(0) from `sensor_readings` where (`sensor_readings`.`reading_timestamp` >= (now() - interval 1 hour))) AS `recent_sensor_readings`,(select count(distinct `fluid_transactions`.`work_order_id`) from `fluid_transactions` where (`fluid_transactions`.`transaction_timestamp` >= curdate())) AS `work_orders_today` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `fluid_usage_analytics`
--

/*!50001 DROP VIEW IF EXISTS `fluid_usage_analytics`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `fluid_usage_analytics` AS select cast(`ft`.`transaction_timestamp` as date) AS `transaction_date`,year(`ft`.`transaction_timestamp`) AS `year`,month(`ft`.`transaction_timestamp`) AS `month`,week(`ft`.`transaction_timestamp`,0) AS `week`,`p`.`product_id` AS `product_id`,`p`.`name` AS `product_name`,`p`.`fluid_type_id` AS `fluid_type_id`,`flt`.`type_name` AS `fluid_type`,`tt`.`type_name` AS `transaction_type`,count(0) AS `transaction_count`,sum(`ft`.`quantity`) AS `total_quantity`,`u`.`unit_abbreviation` AS `unit`,sum((`ft`.`quantity` * `p`.`cost_per_unit`)) AS `total_cost`,`ft`.`tank_id` AS `tank_id`,`t`.`name` AS `tank_name`,count(distinct `ft`.`work_order_id`) AS `work_orders_affected` from (((((`fluid_transactions` `ft` join `transaction_types` `tt` on((`ft`.`transaction_type` = `tt`.`type_id`))) join `products` `p` on((`ft`.`product_id` = `p`.`product_id`))) join `units` `u` on((`p`.`unit_id` = `u`.`unit_id`))) join `fluid_types` `flt` on((`p`.`fluid_type_id` = `flt`.`fluid_type_id`))) left join `tanks` `t` on((`ft`.`tank_id` = `t`.`tank_id`))) group by cast(`ft`.`transaction_timestamp` as date),year(`ft`.`transaction_timestamp`),month(`ft`.`transaction_timestamp`),week(`ft`.`transaction_timestamp`,0),`p`.`product_id`,`p`.`name`,`p`.`fluid_type_id`,`flt`.`type_name`,`tt`.`type_name`,`u`.`unit_abbreviation`,`ft`.`tank_id`,`t`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `fluid_usage_analytics_simplified`
--

/*!50001 DROP VIEW IF EXISTS `fluid_usage_analytics_simplified`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `fluid_usage_analytics_simplified` AS select cast(`ft`.`transaction_timestamp` as date) AS `transaction_date`,year(`ft`.`transaction_timestamp`) AS `year`,month(`ft`.`transaction_timestamp`) AS `month`,quarter(`ft`.`transaction_timestamp`) AS `quarter`,`p`.`product_id` AS `product_id`,`p`.`name` AS `product_name`,`flt`.`fluid_type_id` AS `fluid_type_id`,`flt`.`type_name` AS `fluid_type`,`m`.`name` AS `manufacturer`,`tt`.`type_name` AS `transaction_type`,count(0) AS `transaction_count`,sum(`ft`.`quantity`) AS `total_quantity`,`u`.`unit_abbreviation` AS `unit`,sum((`ft`.`quantity` * `p`.`cost_per_unit`)) AS `total_cost`,avg(`ft`.`quantity`) AS `avg_quantity_per_transaction`,count(distinct `ft`.`work_order_id`) AS `distinct_work_orders`,count(distinct `ft`.`user_id`) AS `distinct_users` from (((((`fluid_transactions` `ft` join `transaction_types` `tt` on((`ft`.`transaction_type` = `tt`.`type_id`))) join `products` `p` on((`ft`.`product_id` = `p`.`product_id`))) join `manufacturers` `m` on((`p`.`manufacturer_id` = `m`.`manufacturer_id`))) join `fluid_types` `flt` on((`p`.`fluid_type_id` = `flt`.`fluid_type_id`))) join `units` `u` on((`p`.`unit_id` = `u`.`unit_id`))) group by cast(`ft`.`transaction_timestamp` as date),year(`ft`.`transaction_timestamp`),month(`ft`.`transaction_timestamp`),quarter(`ft`.`transaction_timestamp`),`p`.`product_id`,`flt`.`fluid_type_id`,`tt`.`type_name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `monthly_product_usage`
--

/*!50001 DROP VIEW IF EXISTS `monthly_product_usage`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `monthly_product_usage` AS select year(`ft`.`transaction_timestamp`) AS `year`,month(`ft`.`transaction_timestamp`) AS `month`,`p`.`product_id` AS `product_id`,`p`.`name` AS `product_name`,`flt`.`type_name` AS `fluid_type`,`m`.`name` AS `manufacturer`,sum(`ft`.`quantity`) AS `total_quantity_used`,`u`.`unit_abbreviation` AS `unit`,sum((`ft`.`quantity` * `p`.`cost_per_unit`)) AS `total_cost`,count(distinct `ft`.`work_order_id`) AS `work_orders_served` from (((((`fluid_transactions` `ft` join `products` `p` on((`ft`.`product_id` = `p`.`product_id`))) join `fluid_types` `flt` on((`p`.`fluid_type_id` = `flt`.`fluid_type_id`))) join `manufacturers` `m` on((`p`.`manufacturer_id` = `m`.`manufacturer_id`))) join `transaction_types` `tt` on((`ft`.`transaction_type` = `tt`.`type_id`))) join `units` `u` on((`p`.`unit_id` = `u`.`unit_id`))) where (`tt`.`type_name` in ('DISPENSE','USAGE')) group by year(`ft`.`transaction_timestamp`),month(`ft`.`transaction_timestamp`),`p`.`product_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `product_inventory`
--

/*!50001 DROP VIEW IF EXISTS `product_inventory`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `product_inventory` AS select `p`.`product_id` AS `product_id`,`p`.`name` AS `product_name`,`p`.`manufacturer_part_number` AS `manufacturer_part_number`,`m`.`name` AS `manufacturer`,`ft`.`type_name` AS `fluid_type`,`p`.`viscosity_grade` AS `viscosity_grade`,coalesce((select sum((case when (`tt`.`type_name` in ('PURCHASE','FILL','MANUAL_ADD')) then `ft`.`quantity` when (`tt`.`type_name` in ('DISPENSE','ADJUST','USAGE')) then -(`ft`.`quantity`) else 0 end)) from (`fluid_transactions` `ft` join `transaction_types` `tt` on((`ft`.`transaction_type` = `tt`.`type_id`))) where (`ft`.`product_id` = `p`.`product_id`)),0) AS `current_quantity`,`u`.`unit_abbreviation` AS `unit`,`p`.`min_stock_level` AS `min_stock_level`,(case when (coalesce((select sum((case when (`tt`.`type_name` in ('PURCHASE','FILL','MANUAL_ADD')) then `ft`.`quantity` when (`tt`.`type_name` in ('DISPENSE','ADJUST','USAGE')) then -(`ft`.`quantity`) else 0 end)) from (`fluid_transactions` `ft` join `transaction_types` `tt` on((`ft`.`transaction_type` = `tt`.`type_id`))) where (`ft`.`product_id` = `p`.`product_id`)),0) <= 0) then 'OUT_OF_STOCK' when (coalesce((select sum((case when (`tt`.`type_name` in ('PURCHASE','FILL','MANUAL_ADD')) then `ft`.`quantity` when (`tt`.`type_name` in ('DISPENSE','ADJUST','USAGE')) then -(`ft`.`quantity`) else 0 end)) from (`fluid_transactions` `ft` join `transaction_types` `tt` on((`ft`.`transaction_type` = `tt`.`type_id`))) where (`ft`.`product_id` = `p`.`product_id`)),0) <= `p`.`min_stock_level`) then 'LOW_STOCK' else 'IN_STOCK' end) AS `stock_status`,`p`.`cost_per_unit` AS `cost_per_unit`,round((coalesce((select sum((case when (`tt`.`type_name` in ('PURCHASE','FILL','MANUAL_ADD')) then `ft`.`quantity` when (`tt`.`type_name` in ('DISPENSE','ADJUST','USAGE')) then -(`ft`.`quantity`) else 0 end)) from (`fluid_transactions` `ft` join `transaction_types` `tt` on((`ft`.`transaction_type` = `tt`.`type_id`))) where (`ft`.`product_id` = `p`.`product_id`)),0) * `p`.`cost_per_unit`),2) AS `value_on_hand`,`p`.`is_hazmat` AS `is_hazmat`,`p`.`created_at` AS `created_at`,`p`.`updated_at` AS `updated_at` from (((`products` `p` join `manufacturers` `m` on((`p`.`manufacturer_id` = `m`.`manufacturer_id`))) join `fluid_types` `ft` on((`p`.`fluid_type_id` = `ft`.`fluid_type_id`))) join `units` `u` on((`p`.`unit_id` = `u`.`unit_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `reel_utilization`
--

/*!50001 DROP VIEW IF EXISTS `reel_utilization`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `reel_utilization` AS select `r`.`reel_id` AS `reel_id`,`r`.`name` AS `reel_name`,`rt`.`type_name` AS `reel_type`,`rt`.`hose_length` AS `hose_length`,`rt`.`max_flow_rate` AS `max_flow_rate`,`t`.`tank_id` AS `tank_id`,`t`.`name` AS `tank_name`,`p`.`name` AS `product_name`,`r`.`asset_tag` AS `asset_tag`,`rs`.`status_name` AS `reel_status`,count(`ft`.`transaction_id`) AS `total_dispenses`,sum(`ft`.`quantity`) AS `total_fluid_dispensed`,`u`.`unit_abbreviation` AS `unit`,min(`ft`.`transaction_timestamp`) AS `first_use`,max(`ft`.`transaction_timestamp`) AS `last_use`,count((case when (`ft`.`transaction_timestamp` >= (curdate() - interval 7 day)) then `ft`.`transaction_id` end)) AS `last_7_days_uses` from ((((((`reels` `r` join `reel_types` `rt` on((`r`.`reel_type_id` = `rt`.`reel_type_id`))) join `tanks` `t` on((`r`.`tank_id` = `t`.`tank_id`))) join `products` `p` on((`t`.`product_id` = `p`.`product_id`))) join `tank_statuses` `rs` on((`r`.`status_id` = `rs`.`status_id`))) join `units` `u` on((`p`.`unit_id` = `u`.`unit_id`))) left join `fluid_transactions` `ft` on(((`r`.`reel_id` = `ft`.`reel_id`) and (`ft`.`transaction_type` = (select `transaction_types`.`type_id` from `transaction_types` where (`transaction_types`.`type_name` = 'DISPENSE')))))) group by `r`.`reel_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `sensor_data_history`
--

/*!50001 DROP VIEW IF EXISTS `sensor_data_history`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `sensor_data_history` AS select `sr`.`reading_id` AS `reading_id`,`sr`.`sensor_id` AS `sensor_id`,`ts`.`name` AS `sensor_name`,`st`.`type_name` AS `sensor_type`,`t`.`tank_id` AS `tank_id`,`t`.`name` AS `tank_name`,`p`.`name` AS `product_name`,`sr`.`raw_value` AS `raw_value`,`u`.`unit_abbreviation` AS `raw_unit`,`sr`.`calculated_volume` AS `calculated_volume`,`uv`.`unit_abbreviation` AS `volume_unit`,`sr`.`reading_timestamp` AS `reading_timestamp`,(`sr`.`calculated_volume` - lag(`sr`.`calculated_volume`) OVER (PARTITION BY `sr`.`sensor_id` ORDER BY `sr`.`reading_timestamp` ) ) AS `volume_change`,timestampdiff(MINUTE,lag(`sr`.`reading_timestamp`) OVER (PARTITION BY `sr`.`sensor_id` ORDER BY `sr`.`reading_timestamp` ) ,`sr`.`reading_timestamp`) AS `minutes_since_last_reading` from ((((((`sensor_readings` `sr` join `tank_sensors` `ts` on((`sr`.`sensor_id` = `ts`.`sensor_id`))) join `sensor_types` `st` on((`ts`.`sensor_type_id` = `st`.`sensor_type_id`))) join `tanks` `t` on((`ts`.`tank_id` = `t`.`tank_id`))) join `products` `p` on((`t`.`product_id` = `p`.`product_id`))) join `units` `u` on((`st`.`measurement_unit_id` = `u`.`unit_id`))) join `units` `uv` on((`t`.`volume_display_unit_id` = `uv`.`unit_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `tank_status_detailed`
--

/*!50001 DROP VIEW IF EXISTS `tank_status_detailed`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `tank_status_detailed` AS select `t`.`tank_id` AS `tank_id`,`t`.`name` AS `tank_name`,`t`.`description` AS `description`,`p`.`name` AS `product_name`,`p`.`product_id` AS `product_id`,`ft`.`type_name` AS `fluid_type`,`m`.`name` AS `manufacturer`,`t`.`capacity` AS `capacity`,`u_cap`.`unit_abbreviation` AS `capacity_unit`,`t`.`current_volume` AS `current_volume`,`u_vol`.`unit_abbreviation` AS `volume_unit`,round(((`t`.`current_volume` / `t`.`capacity`) * 100),1) AS `fill_percentage`,(case when (((`t`.`current_volume` / `t`.`capacity`) * 100) < 10) then 'CRITICAL' when (((`t`.`current_volume` / `t`.`capacity`) * 100) < 25) then 'LOW' else 'OK' end) AS `status_level`,`ts`.`status_name` AS `tank_status`,`t`.`calibration_factor` AS `calibration_factor`,`t`.`created_at` AS `created_at`,`t`.`updated_at` AS `updated_at` from ((((((`tanks` `t` join `products` `p` on((`t`.`product_id` = `p`.`product_id`))) join `fluid_types` `ft` on((`p`.`fluid_type_id` = `ft`.`fluid_type_id`))) join `manufacturers` `m` on((`p`.`manufacturer_id` = `m`.`manufacturer_id`))) join `units` `u_cap` on((`t`.`capacity_unit_id` = `u_cap`.`unit_id`))) join `units` `u_vol` on((`t`.`volume_display_unit_id` = `u_vol`.`unit_id`))) join `tank_statuses` `ts` on((`t`.`status_id` = `ts`.`status_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `tank_status_view`
--

/*!50001 DROP VIEW IF EXISTS `tank_status_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `tank_status_view` AS select `t`.`tank_id` AS `tank_id`,`t`.`name` AS `tank_name`,`p`.`name` AS `product_name`,`t`.`capacity` AS `capacity`,`u1`.`unit_abbreviation` AS `capacity_unit`,`t`.`current_volume` AS `current_volume`,`u2`.`unit_abbreviation` AS `volume_unit`,round(((`t`.`current_volume` / `t`.`capacity`) * 100),1) AS `fill_percentage`,`ts`.`name` AS `primary_sensor_name`,`sr`.`calculated_volume` AS `last_sensor_volume`,`sr`.`reading_timestamp` AS `last_reading`,`t`.`status_id` AS `status_id`,`ts2`.`status_name` AS `status_name` from ((((((`tanks` `t` join `products` `p` on((`t`.`product_id` = `p`.`product_id`))) join `units` `u1` on((`t`.`capacity_unit_id` = `u1`.`unit_id`))) join `units` `u2` on((`t`.`volume_display_unit_id` = `u2`.`unit_id`))) join `tank_statuses` `ts2` on((`t`.`status_id` = `ts2`.`status_id`))) left join `tank_sensors` `ts` on(((`t`.`tank_id` = `ts`.`tank_id`) and (`ts`.`is_primary` = true)))) left join `sensor_readings` `sr` on(((`ts`.`sensor_id` = `sr`.`sensor_id`) and (`sr`.`reading_timestamp` = (select max(`sensor_readings`.`reading_timestamp`) from `sensor_readings` where (`sensor_readings`.`sensor_id` = `ts`.`sensor_id`)))))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `tank_usage_analytics`
--

/*!50001 DROP VIEW IF EXISTS `tank_usage_analytics`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `tank_usage_analytics` AS select `t`.`tank_id` AS `tank_id`,`t`.`name` AS `tank_name`,`p`.`name` AS `product_name`,cast(`ft`.`transaction_timestamp` as date) AS `transaction_date`,`tt`.`type_name` AS `transaction_type`,sum(`ft`.`quantity`) AS `total_quantity`,`u`.`unit_abbreviation` AS `unit`,count(0) AS `transaction_count`,group_concat(distinct `wo`.`external_id` separator ',') AS `work_orders_affected` from (((((`fluid_transactions` `ft` join `tanks` `t` on((`ft`.`tank_id` = `t`.`tank_id`))) join `products` `p` on((`t`.`product_id` = `p`.`product_id`))) join `transaction_types` `tt` on((`ft`.`transaction_type` = `tt`.`type_id`))) join `units` `u` on((`p`.`unit_id` = `u`.`unit_id`))) left join `work_orders` `wo` on((`ft`.`work_order_id` = `wo`.`work_order_id`))) where (`ft`.`tank_id` is not null) group by `t`.`tank_id`,cast(`ft`.`transaction_timestamp` as date),`tt`.`type_name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `work_order_fluid_usage`
--

/*!50001 DROP VIEW IF EXISTS `work_order_fluid_usage`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `work_order_fluid_usage` AS select `wo`.`work_order_id` AS `work_order_id`,`wo`.`external_id` AS `external_id`,`wo`.`description` AS `description`,`ws`.`status_name` AS `work_order_status`,`wo`.`created_at` AS `created_at`,`wo`.`completed_at` AS `completed_at`,`p`.`product_id` AS `product_id`,`p`.`name` AS `product_name`,sum(`woc`.`quantity_used`) AS `quantity_used`,`u`.`unit_abbreviation` AS `unit`,sum((`woc`.`quantity_used` * `woc`.`snapshot_product_cost`)) AS `total_cost`,count(0) AS `products_used` from ((((`work_orders` `wo` join `work_order_statuses` `ws` on((`wo`.`status_id` = `ws`.`status_id`))) join `work_order_consumables` `woc` on((`wo`.`work_order_id` = `woc`.`work_order_id`))) join `products` `p` on((`woc`.`product_id` = `p`.`product_id`))) join `units` `u` on((`p`.`unit_id` = `u`.`unit_id`))) group by `wo`.`work_order_id`,`p`.`product_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `work_order_progress`
--

/*!50001 DROP VIEW IF EXISTS `work_order_progress`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `work_order_progress` AS select `wo`.`work_order_id` AS `work_order_id`,`wo`.`external_id` AS `external_id`,`wo`.`description` AS `description`,`ws`.`status_name` AS `status`,`wo`.`created_at` AS `created_at`,`wo`.`updated_at` AS `updated_at`,`wo`.`completed_at` AS `completed_at`,(to_days(now()) - to_days(`wo`.`created_at`)) AS `days_open`,(select count(0) from `work_order_consumables` `woc` where (`woc`.`work_order_id` = `wo`.`work_order_id`)) AS `products_used`,(select sum(`woc`.`quantity_used`) from `work_order_consumables` `woc` where (`woc`.`work_order_id` = `wo`.`work_order_id`)) AS `total_quantity_used`,(select sum((`woc`.`quantity_used` * `woc`.`snapshot_product_cost`)) from `work_order_consumables` `woc` where (`woc`.`work_order_id` = `wo`.`work_order_id`)) AS `total_cost`,(select group_concat(distinct `ft`.`user_id` separator ',') from `fluid_transactions` `ft` where (`ft`.`work_order_id` = `wo`.`work_order_id`)) AS `involved_technicians` from (`work_orders` `wo` join `work_order_statuses` `ws` on((`wo`.`status_id` = `ws`.`status_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-09-13 14:17:17
