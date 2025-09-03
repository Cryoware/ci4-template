-- MySQL dump 10.13  Distrib 8.4.6, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: oilcop_g2
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
                              `config_key` varchar(100) NOT NULL,
                              `config_value` text NOT NULL,
                              `config_type` varchar(50) DEFAULT 'string' COMMENT 'Hint of the value, string, array, int, json',
                              `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                              PRIMARY KEY (`config_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Holds application level configuration so it can be cached without database calls';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `app_config`
--

LOCK TABLES `app_config` WRITE;
/*!40000 ALTER TABLE `app_config` DISABLE KEYS */;
INSERT INTO `app_config` VALUES ('allowed_ips','[\"192.168.1.1\",\"192.168.1.2\"]','array','2025-08-31 22:12:47'),('maintenance_mode','true','boolean','2025-08-31 22:40:40'),('max_login_attempts','4','integer','2025-09-01 14:34:18'),('site_name','Cryoware','string','2025-08-31 22:12:47');
/*!40000 ALTER TABLE `app_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `installer_time_map`
--

DROP TABLE IF EXISTS `installer_time_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `installer_time_map` (
                                      `id` int NOT NULL AUTO_INCREMENT,
                                      `f_user_id` int unsigned DEFAULT NULL,
                                      `days` int NOT NULL,
                                      `hours` int NOT NULL,
                                      `created` bigint NOT NULL,
                                      `created_by` int unsigned DEFAULT NULL,
                                      PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `installer_time_map`
--

LOCK TABLES `installer_time_map` WRITE;
/*!40000 ALTER TABLE `installer_time_map` DISABLE KEYS */;
/*!40000 ALTER TABLE `installer_time_map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_actions`
--

DROP TABLE IF EXISTS `t_actions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_actions` (
                             `t_action_id` int NOT NULL AUTO_INCREMENT,
                             `t_action_name` varchar(200) NOT NULL,
                             `t_action_data` varchar(300) NOT NULL,
                             `t_log_data` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
                             `f_adjustment_ported` int NOT NULL DEFAULT '0',
                             `is_sync` int NOT NULL DEFAULT '0',
                             PRIMARY KEY (`t_action_id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_actions`
--

LOCK TABLES `t_actions` WRITE;
/*!40000 ALTER TABLE `t_actions` DISABLE KEYS */;
INSERT INTO `t_actions` VALUES (1,'New Hardware configured - {fr} ({se})','','CDM-1,CDM0823041',0,0),(2,'New Hardware configured - {fr} ({se})','','PSM-1,PSM0823066',0,0),(3,'New Hardware configured - {fr} ({se})','','CDM-2,CDM0823041',0,0),(4,'New Hardware configured - {fr} ({se})','','CDM-3,CDM0823041',0,0),(5,'New Hardware configured - {fr} ({se})','','CDM-4,CDM0823041',0,0),(6,'New Hardware configured - {fr} ({se})','','CDM-5,CDM0823041',0,0),(7,'New Hardware configured - {fr} ({se})','','CDM-6,CDM0823041',0,0),(8,'New Hardware configured - {fr} ({se})','','CDM-7,CDM0823041',0,0),(9,'Hardware details are updated - {fr} ({se})','','PSM-1,',0,0),(10,'Hardware details are updated - {fr} ({se})','','PSM-1,',0,0),(11,'Hardware details are updated - {fr} ({se})','','PSM-1,',0,0),(12,'Hardware details are updated - {fr} ({se})','','PSM-1,',0,0),(13,'Hardware details are updated - {fr} ({se})','','PSM-1,',0,0),(14,'Hardware details are updated - {fr} ({se})','','PSM-1,',0,0),(15,'Hardware details are updated - {fr} ({se})','','PSM-1,',0,0),(16,'Hardware details are updated - {fr} ({se})','','PSM-1,',0,0),(17,'Hardware details are updated - {fr} ({se})','','PSM-1,',0,0),(18,'Hardware details are updated - {fr} ({se})','','PSM-1,',0,0),(19,'New Hardware configured - {fr} ({se})','','CDM-1,CDM0823041',0,0),(20,'New Hardware configured - {fr} ({se})','','PSM-1,PSM0823066',0,0),(21,'New Hardware configured - {fr} ({se})','','CDM-1,CDM0823041',0,0),(22,'New Hardware configured - {fr} ({se})','','PSM-1,PSM0823066',0,0),(23,'Hardware details are updated - {fr} ({se})','','PSM-1,',0,0),(24,'New Station added - {fr}','','Test',0,0),(25,'New Hardware configured - {fr} ({se})','','CDM-1,CDM0823041',0,0),(26,'New Hardware configured - {fr} ({se})','','PSM-1,PSM0823066',0,0),(27,'Hardware details are updated - {fr} ({se})','','PSM-1,',0,0),(28,'New Hardware configured - {fr} ({se})','','TMM-1,TMM0823010',0,0),(29,'Hardware details are updated - {fr} ({se})','','TMM-1,',0,0),(30,'Hardware details are updated - {fr} ({se})','','TMM-1,',0,0),(31,'New Hardware configured - {fr} ({se})','','CDM-2,CDM0823055',0,0),(32,'New Hardware configured - {fr} ({se})','','PSM-2,PSM0823065',0,0),(33,'New Hardware configured - {fr} ({se})','','TMM-2,TMM0823012',0,0),(34,'New Hardware configured - {fr} ({se})','','CDM-1,CDM0823041',0,0),(35,'New Hardware configured - {fr} ({se})','','CDM-2,CDM0823055',0,0),(36,'New Hardware configured - {fr} ({se})','','CDM-3,CDM0823041',0,0),(37,'New Hardware configured - {fr} ({se})','','PSM-1,PSM0823066',0,0),(38,'New Hardware configured - {fr} ({se})','','TMM-1,TMM0823010',0,0),(39,'New Hardware configured - {fr} ({se})','','PSM-2,PSM0823065',0,0),(40,'Hardware details are updated - {fr} ({se})','','PSM-2,',0,0),(41,'Hardware details are updated - {fr} ({se})','','PSM-2,',0,0),(42,'New Hardware configured - {fr} ({se})','','PSM-2,PSM0823065',0,0),(43,'Hardware details are updated - {fr} ({se})','','PSM-2,',0,0),(44,'New Hardware configured - {fr} ({se})','','TMM-2,TMM0823012',0,0),(45,'Hardware details are updated - {fr} ({se})','','TMM-2,',0,0),(46,'Hardware details are updated - {fr} ({se})','','TMM-2,',0,0),(47,'Hardware details are updated - {fr} ({se})','','TMM-2,',0,0),(48,'New Hardware configured - {fr} ({se})','','CDM-1,CDM0823041',0,0),(49,'New Hardware configured - {fr} ({se})','','CDM-2,CDM0823055',0,0),(50,'New Hardware configured - {fr} ({se})','','PSM-1,PSM0823066',0,0),(51,'New Hardware configured - {fr} ({se})','','TMM-1,TMM0823010',0,0),(52,'New Hardware configured - {fr} ({se})','','TMM-1,TMM0823010',0,0),(53,'New Hardware configured - {fr} ({se})','','TMM-2,TMM0823012',0,0),(54,'New Hardware configured - {fr} ({se})','','PSM-2,PSM0823065',0,0),(55,'New product added ( {fr} )','','0W/20',0,0),(56,'New product added ( {fr} )','','H2O',0,0),(57,'New product added ( {fr} )','','ATF',0,0),(58,'New product added ( {fr} )','','Washer Fluid',0,0),(59,'New tank configured - {fr} with product {se}','','0W/20,0W/20',0,0),(60,'New tank configured - {fr} with product {se}','','H2O,H2O',0,0),(61,'New tank configured - {fr} with product {se}','','H2O[2],H2O',0,0),(62,'New Sensor added','','',0,0),(63,'Tank details are updated','','',0,0),(64,'New Sensor added','','',0,0),(65,'Sensor details updated','','',0,0),(66,'New Sensor added','','',0,0),(67,'Sensor details updated','','',0,0),(68,'Sensor details updated','','',0,0),(69,'New Sensor added','','',0,0),(70,'New Sensor added','','',0,0),(71,'Sensor details updated','','',0,0),(72,'New Hardware configured - {fr} ({se})','','CDM-3,CDM-11111',0,0),(73,'New Hardware configured - {fr} ({se})','','PSM-16,psm-11111',0,0),(74,'New Hardware configured - {fr} ({se})','','TMM-28,tmm-1111',0,0),(75,'New Hardware configured - {fr} ({se})','','PSM-17,psm-2222',0,0),(76,'New Sensor added','','',0,0),(77,'New Sensor added','','',0,0),(78,'New Sensor added','','',0,0),(79,'New Sensor added','','',0,0),(80,'New Sensor added','','',0,0),(81,'New Sensor added','','',0,0),(82,'New Hardware configured - {fr} ({se})','','CDM-4,CDM0823F10',0,0),(83,'New Hardware configured - {fr} ({se})','','PSM-18,PSM082318',0,0),(84,'Hardware details are updated - {fr} ({se})','','PSM-16,',0,0),(85,'Reel {fr} added to the station {se}','','Reel 1 psm 11[psm-11111],Test',0,0),(86,'Reel {fr} added to the station {se}','','Reel 2 psm 65[PSM0823065],Test',0,0),(87,'Reel {fr} added to the station {se}','','Reel 3 PSM F2[PSM08230F2],Test',0,0),(88,'New Station added - {fr}','','Station 2',0,0),(89,'Reel {fr} added to the station {se}','','5th reel added to system[psm-2222],Station 2',0,0),(90,'Reel {fr} added to the station {se}','','6th reel added to system[PSM0823066],Station 2',0,0),(91,'Reel {fr} added to the station {se}','','7th reel added to system[PSM08230F1],Station 2',0,0),(92,'Reel {fr} added to the station {se}','','8th reel added to system[PSM08230F3],Station 2',0,0),(93,'New Relay added','','',0,0),(94,'New Relay added','','',0,0),(95,'New Relay added','','',0,0),(96,'New user added ({fr} - {se})','','Admin,LQD Engineering',0,0),(97,'New Hardware configured - {fr}','','CDM0823053',0,0),(98,'New Hardware configured - {fr}','','TMM1023005',0,0),(99,'New product added ( {fr} )','','CWPRODUCT',0,0),(100,'Product details are updated ( {fr} )','','SYN ALL WEATHER THF',0,0);
/*!40000 ALTER TABLE `t_actions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_adjust_workorder`
--

DROP TABLE IF EXISTS `t_adjust_workorder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_adjust_workorder` (
                                      `f_adjustwo_id` int NOT NULL AUTO_INCREMENT,
                                      `f_adjustwo_time` time NOT NULL,
                                      `f_adjustwo_date` varchar(44) NOT NULL,
                                      `f_workorder_id` varchar(20) NOT NULL,
                                      `f_workorder_type` varchar(20) NOT NULL,
                                      `f_user_id` int NOT NULL,
                                      `f_station_id` int NOT NULL,
                                      `f_job_id` int NOT NULL,
                                      `f_product_id` int NOT NULL,
                                      `f_units_id` int NOT NULL,
                                      `f_configured_units_id` int NOT NULL,
                                      `f_reel_id` int NOT NULL,
                                      `f_configured_preset_amount` float(12,1) NOT NULL,
  `f_preset_amount` float(12,1) NOT NULL,
  `f_lock_dispamt` int NOT NULL,
  `f_workorder_completed` int NOT NULL,
  `f_emergency_stop` int NOT NULL DEFAULT '0',
  `f_created` int NOT NULL,
  `f_closed` int NOT NULL,
  `is_sync` int NOT NULL,
  PRIMARY KEY (`f_adjustwo_id`),
  KEY `f_adjustwo_id` (`f_adjustwo_id`),
  KEY `f_workorder_id` (`f_workorder_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_adjust_workorder`
--

LOCK TABLES `t_adjust_workorder` WRITE;
/*!40000 ALTER TABLE `t_adjust_workorder` DISABLE KEYS */;
INSERT INTO `t_adjust_workorder` VALUES (1,'14:20:12','11/01/2024','1','',0,0,0,0,0,0,0,0.0,0.0,0,0,0,1704977393,0,0);
/*!40000 ALTER TABLE `t_adjust_workorder` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_adminstrative_options`
--

DROP TABLE IF EXISTS `t_adminstrative_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_adminstrative_options` (
                                           `f_admin_option_id` int NOT NULL AUTO_INCREMENT,
                                           `f_volume_type` varchar(22) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'Work Order Top Off Limit',
                                           `f_amount` varchar(22) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'Work Order Top Off Limit Value',
                                           `f_auto_close_workorder` int NOT NULL COMMENT ' Auto Close Work Order',
                                           `f_pre_dispense_amt` varchar(22) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'Total volume per workorder',
                                           `f_top_off` int NOT NULL COMMENT ' Work Order Top Off',
                                           `f_jtop_off` int NOT NULL COMMENT 'Job Recipe Top Off',
                                           `f_jvolume_type` varchar(22) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'Job Recipe Top Off Limit',
                                           `f_jamount` varchar(22) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT ' Job Recipe Top Off Limit Value',
                                           `f_emergency_stop` int NOT NULL COMMENT 'Default Value 1',
                                           `f_work_order_id` varchar(20) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT ' Enable Work Order Config',
                                           `created_id` int NOT NULL COMMENT 'Logged In User ID',
                                           `f_calibration` int NOT NULL COMMENT 'System Calibration',
                                           `f_multi_products` int NOT NULL COMMENT 'Multiple Products per Work Order',
                                           `f_multi_dispense` int NOT NULL COMMENT 'Multiple Dispense',
                                           `f_workorder_validation` int NOT NULL COMMENT ' Enable Work Order Config',
                                           `f_odometer` int NOT NULL COMMENT 'Odometer Number',
                                           `f_shift_type` varchar(10) NOT NULL,
                                           `f_inventory` int NOT NULL COMMENT 'Product Inventory System',
                                           `f_installer_access` int NOT NULL COMMENT 'Installer Profile Enabled',
                                           `f_report_units` int NOT NULL COMMENT 'Units for Reports',
                                           `f_system_type` int NOT NULL COMMENT 'System Type',
                                           `f_syncronize` int NOT NULL COMMENT 'Sync with oilcopsupport.com',
                                           `f_location` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL COMMENT 'Location',
                                           `f_info_time` int NOT NULL COMMENT 'Hide Closed Dashboard Records',
                                           `f_custom_days` int NOT NULL COMMENT 'Hide Closed Dashboard Records Value If Select Hourly',
                                           `f_tank_monitor` int NOT NULL COMMENT 'Tank Monitor solution',
                                           `f_tm_disp` int NOT NULL COMMENT 'Tank Monitor Dispensing',
                                           `f_print_dispense` int NOT NULL COMMENT 'Print After Dispense',
                                           `f_tank_report` int NOT NULL COMMENT 'Tank History Report',
                                           `f_tank_stime` varchar(10) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'Tank History Report Value',
                                           `f_tank_etime` varchar(10) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'Tank History Report Value',
                                           `f_wo_invoice` int NOT NULL COMMENT 'Display Work Order Invoice',
                                           `f_del_wo` int NOT NULL COMMENT 'Reports: Hide Deleted Work Orders',
                                           `f_admiral_version` int NOT NULL COMMENT 'Admiral Version',
                                           `f_menu_expand` int NOT NULL DEFAULT '1' COMMENT 'Menu Auto-Expand',
                                           `f_tank_ref_freq` varchar(10) NOT NULL COMMENT 'To Store Dashboard Tank Refresh Frequency In Milli Seconds',
                                           `f_wo_lock_dispense_amount` int NOT NULL DEFAULT '1' COMMENT 'Lock Preset Amount',
                                           PRIMARY KEY (`f_admin_option_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_adminstrative_options`
--

LOCK TABLES `t_adminstrative_options` WRITE;
/*!40000 ALTER TABLE `t_adminstrative_options` DISABLE KEYS */;
INSERT INTO `t_adminstrative_options` VALUES (1,'amount','3',1,'12',1,0,'amount','1',1,'BBBB',1,1,0,0,0,0,'fst',1,1,1,0,0,'',4,0,0,0,0,1,'0','24',1,0,0,0,'2500',0);
/*!40000 ALTER TABLE `t_adminstrative_options` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_autoexport_reports`
--

DROP TABLE IF EXISTS `t_autoexport_reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_autoexport_reports` (
                                        `f_rid` int NOT NULL AUTO_INCREMENT,
                                        `f_report_id` int NOT NULL,
                                        `f_report_name` varchar(50) NOT NULL,
                                        `f_filename` text NOT NULL,
                                        `f_columns_info` text NOT NULL,
                                        PRIMARY KEY (`f_rid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_autoexport_reports`
--

LOCK TABLES `t_autoexport_reports` WRITE;
/*!40000 ALTER TABLE `t_autoexport_reports` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_autoexport_reports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_autoexport_settings`
--

DROP TABLE IF EXISTS `t_autoexport_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_autoexport_settings` (
                                         `f_aid` int NOT NULL AUTO_INCREMENT,
                                         `f_sever_ip` varchar(50) NOT NULL,
                                         `f_server_port` int NOT NULL DEFAULT '0',
                                         `f_time_out` int NOT NULL DEFAULT '0',
                                         `f_susername` varchar(50) NOT NULL,
                                         `f_spassword` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
                                         `f_ftpssl_cert` int NOT NULL DEFAULT '0',
                                         `f_export_location` varchar(100) NOT NULL,
                                         `f_export_frequency` tinyint(1) NOT NULL,
                                         `f_expfrq_min` int NOT NULL,
                                         `f_expfrq_sec` int NOT NULL,
                                         `f_onwo_close` tinyint(1) NOT NULL DEFAULT '0',
                                         `f_file_type` varchar(10) NOT NULL,
                                         `f_display_headers` tinyint(1) NOT NULL DEFAULT '0',
                                         `f_delimeter` varchar(20) NOT NULL,
                                         `f_byuser_id` int NOT NULL DEFAULT '0',
                                         `f_updated_on` int NOT NULL DEFAULT '0',
                                         PRIMARY KEY (`f_aid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_autoexport_settings`
--

LOCK TABLES `t_autoexport_settings` WRITE;
/*!40000 ALTER TABLE `t_autoexport_settings` DISABLE KEYS */;
INSERT INTO `t_autoexport_settings` VALUES (1,'',0,0,'','',0,'',0,0,0,0,'',0,'',0,0);
/*!40000 ALTER TABLE `t_autoexport_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_capabilities`
--

DROP TABLE IF EXISTS `t_capabilities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_capabilities` (
                                  `f_capabilities_id` int NOT NULL AUTO_INCREMENT,
                                  `f_capabilities_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
                                  PRIMARY KEY (`f_capabilities_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_capabilities`
--

LOCK TABLES `t_capabilities` WRITE;
/*!40000 ALTER TABLE `t_capabilities` DISABLE KEYS */;
INSERT INTO `t_capabilities` VALUES (1,'Preset'),(2,'Open/Free Dispense'),(3,'Select Workorder'),(4,'Load Workorder'),(5,'Manage Technician');
/*!40000 ALTER TABLE `t_capabilities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_controller_info`
--

DROP TABLE IF EXISTS `t_controller_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_controller_info` (
                                     `f_network_settings_id` int NOT NULL AUTO_INCREMENT COMMENT 'This field is required so that each record can be uniquely identified. ID 1 row contains the configuration of the physical hardware used for networking tasks for the OilCop devices. ID 2 row contains the configuration of the physical hardware used for networking tasks for the Customer controller access. Data in the table cannot be changed directly by the user. If a user wants to change the data stored in this table, they have to have app approval for access to the configurations pages. Depending on the controller hardware configuration customers may only make changes to the customers network. Access to the Oilcop network settings is prevented. All network data previously assigned to the Oilcop network port are now dynamically assigned by the app to automatically redirect them all to the customers network port.',
                                     `f_connection_name` varchar(30) NOT NULL,
                                     `f_mac_address` varchar(50) NOT NULL COMMENT 'This field will no longer be updated by middleware, moved storage to t_network_settings table.',
                                     `f_ip_address` varchar(50) NOT NULL COMMENT 'This field is just duplicate data that resides in the network settings page but gets the IP info from the OS',
                                     `f_network_mask` varchar(30) NOT NULL,
                                     `f_gateway` varchar(30) NOT NULL,
                                     `f_dns` varchar(30) NOT NULL,
                                     `f_dns_alt` varchar(40) NOT NULL COMMENT 'This is the field to store the alternate dns server address',
                                     `f_dhcp` int NOT NULL,
                                     `f_idevice_id` varchar(10) NOT NULL,
                                     PRIMARY KEY (`f_network_settings_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_controller_info`
--

LOCK TABLES `t_controller_info` WRITE;
/*!40000 ALTER TABLE `t_controller_info` DISABLE KEYS */;
INSERT INTO `t_controller_info` VALUES (1,'OilcopNetworkPort','','192.168.5.1','255.255.255.0','192.168.5.0','208.67.222.222','208.67.221.221',0,'enp1s0'),(2,'OilcopNetworkPort','','192.168.0.223','255.255.255.0','192.168.0.1','8.8.8.8','208.67.221.221',0,'enp1s0');
/*!40000 ALTER TABLE `t_controller_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_device_serialnumbers`
--

DROP TABLE IF EXISTS `t_device_serialnumbers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_device_serialnumbers` (
                                          `f_sid` int DEFAULT NULL COMMENT 'Field exists because the Hardware Configuration landing page needs it and need the page to work so work can continue on the python code until the web code can be fixed then it can be removed safely.',
                                          `f_serial_no` varchar(30) NOT NULL,
                                          `f_lastupdated_time` varchar(50) DEFAULT NULL,
                                          `f_config_status` tinyint(1) NOT NULL DEFAULT '0',
                                          PRIMARY KEY (`f_serial_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_device_serialnumbers`
--

LOCK TABLES `t_device_serialnumbers` WRITE;
/*!40000 ALTER TABLE `t_device_serialnumbers` DISABLE KEYS */;
INSERT INTO `t_device_serialnumbers` VALUES (3791,'CDM0823040','2025-03-11 19:08:24',0),(2730,'CDM0823041','2023-11-09 11:46:50',0),(3705,'CDM0823053','2025-03-11 14:30:35',0),(2751,'CDM0823055','2023-11-05 20:50:49',0),(3039,'PSM0823065','2025-07-03 13:08:00',0),(2763,'PSM0823066','2023-11-09 11:46:50',0),(2902,'TMM0823010','2023-11-05 21:00:23',0),(2925,'TMM0823012','2023-11-05 21:06:23',0),(3087,'TMM1023004','2025-03-10 16:38:10',0),(3698,'TMM1023005','2025-03-11 14:35:34',0);
/*!40000 ALTER TABLE `t_device_serialnumbers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_devices`
--

DROP TABLE IF EXISTS `t_devices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_devices` (
                             `f_device_type_id` int NOT NULL AUTO_INCREMENT,
                             `f_device_type_description` varchar(33) NOT NULL,
                             `f_device_software_type_id` int NOT NULL,
                             PRIMARY KEY (`f_device_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_devices`
--

LOCK TABLES `t_devices` WRITE;
/*!40000 ALTER TABLE `t_devices` DISABLE KEYS */;
INSERT INTO `t_devices` VALUES (1,'CDM',1),(2,'PSM',2),(3,'RPSM',3),(4,'TMM',4);
/*!40000 ALTER TABLE `t_devices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_devices_software`
--

DROP TABLE IF EXISTS `t_devices_software`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_devices_software` (
                                      `f_devices_software_id` int NOT NULL AUTO_INCREMENT,
                                      `f_device_type_id` int NOT NULL,
                                      `f_devices_status` int NOT NULL,
                                      `f_device_portnumber` varchar(33) NOT NULL,
                                      `f_serial_number` varchar(60) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
                                      `f_communication_id` int NOT NULL,
                                      `f_signal_strength` int DEFAULT NULL,
                                      `f_ip_address` varchar(30) NOT NULL,
                                      `f_frequency_address` int DEFAULT NULL COMMENT 'For a CDM this is the primary key value for the transmit freq assigned during on-boarding. No two CDMs can use the same frequency. t_rf_channel_frequency_mapping\r\n\r\nFor a PSM and TMM this value represents the unique index, 0 to 19, of the device assigned to a specific CDM device.\r\n\r\nPacket data from the CDM from/for the devices contains the CDM freq pk value in the SOP header and the devices freq/address at index 1 of the device''s 20 byte message. The middleware code passes the f_device_type To correctly query the table for a specific device',
                                      `f_cdm_id` int NOT NULL,
                                      `f_solenoid_type` enum('Latching','Induction','') CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
                                      `f_lastupdated_time` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'This is used to store the last time the device was sent a configuration/settings packet',
                                      `f_device_config_status` tinyint(1) NOT NULL DEFAULT '0',
                                      `f_tmm_count` int DEFAULT NULL COMMENT 'This is the value of how many TMM devices will be associated to a specific CDM.',
                                      `f_psm_count` int DEFAULT NULL COMMENT 'This is the value of how many PSM are going to be associated with a specific CDM.',
                                      `f_device_checkin` decimal(20,0) DEFAULT NULL COMMENT 'This field is used to store the last time the status changed on a device.',
                                      PRIMARY KEY (`f_devices_software_id`)
) ENGINE=InnoDB AUTO_INCREMENT=82 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_devices_software`
--

LOCK TABLES `t_devices_software` WRITE;
/*!40000 ALTER TABLE `t_devices_software` DISABLE KEYS */;
INSERT INTO `t_devices_software` VALUES (21,1,1,'1203','CDM08230F2',0,0,'192.168.5.13',23,0,'','1699217397',1,1,19,0),(22,1,1,'1201','CDM0823055',0,0,'192.168.5.11',21,0,'','1699217442',1,1,19,0),(23,2,1,'','PSM0823066',0,0,'',0,21,'Latching','1699217480',1,0,0,0),(25,4,1,'','TMM0823F26',0,0,'',4,57,'','1699218002',1,0,0,0),(26,4,1,'','TMM0823012',0,0,'',2,61,'','1699218063',1,0,0,0),(27,2,1,'','PSM0823065',0,0,'',0,22,'Latching','1699218474',1,0,0,0),(28,2,1,'','PSM0823F10',0,0,'',6,57,'Latching','1699218474',1,0,0,0),(29,2,1,'','PSM0823F11',0,0,'',3,58,'Latching','1699218474',1,0,0,0),(30,2,1,'','PSM0823F12',0,0,'',4,59,'Latching','1699218474',1,0,0,0),(31,2,1,'','PSM08230F8',0,0,'',2,64,'Latching','1699218474',1,0,0,0),(32,2,1,'','PSM0823F14',0,0,'',3,57,'Latching','1699218474',1,0,0,0),(33,2,1,'','PSM08230F6',0,0,'',4,62,'Latching','1699218474',1,0,0,0),(34,2,1,'','PSM08230F5',0,0,'',0,61,'Latching','1699218474',1,0,0,0),(35,2,1,'','PSM08230F3',0,0,'',5,59,'Latching','1699218474',1,0,0,0),(36,2,1,'','PSM08230F7',0,0,'',3,63,'Latching','1699218474',1,0,0,0),(37,2,1,'','PSM08230F4',0,0,'',2,60,'Latching','1699218474',1,0,0,0),(38,2,1,'','PSM08230F1',0,0,'',5,57,'Latching','1699218474',1,0,0,0),(39,2,1,'','PSM08230F2',0,0,'',5,58,'Latching','1699218474',1,0,0,0),(40,2,1,'','PSM0823F13',0,0,'',0,58,'Latching','1699218474',1,0,0,0),(41,4,1,'','TMM0823F29',0,0,'',1,60,'','1699218002',1,0,0,0),(42,4,1,'','TMM0823F28',0,0,'',2,59,'','1699218002',1,0,0,0),(43,4,1,'','TMM08230F3',0,0,'',5,62,'','1699218002',1,0,0,0),(44,4,1,'','TMM08230F1',0,0,'',3,61,'','1699218002',1,0,0,0),(45,4,1,'','TMM08230F4',0,0,'',2,63,'','1699218002',1,0,0,0),(46,4,1,'','TMM08230F5',0,0,'',1,64,'','1699218002',1,0,0,0),(47,4,1,'','TMM08230F6',0,0,'',0,57,'','1699218002',1,0,0,0),(48,4,1,'','TMM0823F13',0,0,'',3,60,'','1699218002',1,0,0,0),(49,4,1,'','TMM0823F27',0,0,'',4,58,'','1699218002',1,0,0,0),(50,4,1,'','TMM08230F8',0,0,'',2,57,'','1699218002',1,0,0,0),(51,4,1,'','TMM08230F9',0,0,'',1,57,'','1699218002',1,0,0,1741624173),(52,4,1,'','TMM0823F10',0,0,'',2,58,'','1699218002',1,0,0,0),(53,4,1,'','TMM0823F11',0,0,'',1,58,'','1699218002',1,0,0,0),(54,4,1,'','TMM0823F12',0,0,'',3,59,'','1699218002',1,0,0,0),(55,4,1,'','TMM0823010',0,0,'',1,21,'','1699218002',1,0,0,0),(56,4,1,'','TMM0823F14',0,0,'',1,61,'','1699218002',1,0,0,0),(57,1,1,'1200','CDM0823041',0,0,'192.168.5.10',20,0,'','1699217397',1,1,19,1751548082),(58,1,1,'1209','CDM08230F8',0,0,'192.168.5.19',29,0,'','1699217397',1,2,10,0),(59,1,1,'1208','CDM08230F7',0,0,'192.168.5.18',28,0,'','1699217397',1,4,3,0),(60,1,1,'1207','CDM08230F6',0,0,'192.168.5.17',27,0,'','1699217397',1,3,4,0),(61,1,1,'1206','CDM08230F5',0,0,'192.168.5.16',26,0,'','1699217397',1,6,5,0),(62,1,1,'1205','CDM08230F4',0,0,'192.168.5.15',25,0,'','1699217397',1,5,15,0),(63,1,1,'1204','CDM08230F3',0,0,'192.168.5.14',24,0,'','1699217397',1,1,19,0),(64,1,1,'1202','CDM08230F1',0,0,'192.168.5.12',22,0,'','1699217397',1,1,19,0),(65,4,1,'','TMM0823F15',0,0,'',8,62,'','1699218002',1,0,0,0),(66,4,1,'','TMM0823F16',0,0,'',0,63,'','1699218002',1,0,0,0),(67,4,1,'','TMM0823F17',0,0,'',0,64,'','1699218002',1,0,0,0),(68,4,1,'','TMM0823F18',0,0,'',1,63,'','1699218002',1,0,0,0),(69,4,1,'','TMM0823F19',0,0,'',7,62,'','1699218002',1,0,0,0),(70,4,1,'','TMM0823F20',0,0,'',1,59,'','1699218002',1,0,0,0),(71,4,1,'','TMM0823F21',0,0,'',0,60,'','1699218002',1,0,0,0),(72,4,1,'','TMM0823F23',0,0,'',6,62,'','1699218002',1,0,0,0),(73,4,1,'','TMM0823F25',0,0,'',0,59,'','1699218002',1,0,0,0),(74,1,1,'1211','CDM-11111',0,0,'192.111.3.1',0,0,'','1699616415',1,4,5,1741702228),(75,2,1,'','psm-11111',0,0,'',1,74,'Latching','1699871036',1,0,0,0),(76,4,1,'','tmm-1111',0,0,'',0,74,'','1699616458',1,0,0,0),(77,2,1,'','psm-2222',0,0,'',2,74,'Latching','1699616489',1,0,0,0),(78,1,1,'1210','CDM0823F10',0,0,'192.168.5.20',19,0,'','1699619704',1,4,5,0),(79,2,1,'','PSM082318',0,0,'',0,78,'Latching','1699619782',1,0,0,0),(80,1,1,'1201','CDM0823053',0,NULL,'192.168.5.11',1,0,'','1741703416',1,1,1,NULL),(81,4,1,'','TMM1023005',0,NULL,'',0,80,'','1741703727',1,0,0,NULL);
/*!40000 ALTER TABLE `t_devices_software` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_dispense`
--

DROP TABLE IF EXISTS `t_dispense`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_dispense` (
                              `f_dispense_id` int NOT NULL AUTO_INCREMENT,
                              `f_workorder_id` int NOT NULL,
                              `f_job_id` int DEFAULT '0',
                              `f_user_id` int NOT NULL,
                              `f_product_id` int NOT NULL,
                              `f_station_id` int NOT NULL,
                              `f_reel_id` int NOT NULL,
                              `f_dispense_amount` float(10,5) NOT NULL,
  `f_quarts_amount` float(10,5) DEFAULT '0.00000',
  `f_dstart_inventory` double(12,5) NOT NULL DEFAULT '0.00000',
  `f_dstop_inventory` double(12,5) DEFAULT '0.00000',
  `f_dispense_units` int NOT NULL,
  `f_dispense_time` int NOT NULL,
  `f_dispense_time_completed` int NOT NULL DEFAULT '0',
  `f_dispense_duration` int DEFAULT NULL,
  `f_odometer_no` varchar(20) NOT NULL,
  `f_dispense_type` varchar(20) NOT NULL,
  `f_top_off` int DEFAULT NULL,
  `is_sync` int NOT NULL DEFAULT '0',
  `f_tech_preset_amount` float(10,5) NOT NULL DEFAULT '0.00000',
  PRIMARY KEY (`f_dispense_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_dispense`
--

LOCK TABLES `t_dispense` WRITE;
/*!40000 ALTER TABLE `t_dispense` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_dispense` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_email_settings`
--

DROP TABLE IF EXISTS `t_email_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_email_settings` (
                                    `f_id` int NOT NULL AUTO_INCREMENT,
                                    `f_host_name` varchar(255) NOT NULL,
                                    `f_from_email` varchar(255) NOT NULL,
                                    `f_email_password` varchar(255) NOT NULL,
                                    `f_from_name` varchar(255) NOT NULL,
                                    `f_port` int NOT NULL,
                                    `f_ssl` int NOT NULL,
                                    `f_tls` int NOT NULL,
                                    `f_return_path` varchar(200) NOT NULL,
                                    `f_default` int NOT NULL,
                                    PRIMARY KEY (`f_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_email_settings`
--

LOCK TABLES `t_email_settings` WRITE;
/*!40000 ALTER TABLE `t_email_settings` DISABLE KEYS */;
INSERT INTO `t_email_settings` VALUES (1,'smtp.office365.com','oilcop@liquidynamics.com','+gil8g8sc8vaNu1dYrTKzXZnDjgcp6kPqcBXeg9cTmW8OQePwyP1orJ7yj0rg2LO','liquidynamics',587,0,0,'no_reply@liquidynamics.com',1),(2,'smtps.aruba.it','oilcop@gartec.it','U1vGcZKrMSlSo93duhMIvYmTkl4IccMIvRes7VidUtY=','Gartec',465,1,0,'',2),(3,'smtp.office365.com','admiral@filcar.it','Ub70fEVKacxSx5o5WqUkjmIMyBnhTuiSrB+V0gHSOGc=','Filcar',587,0,1,'',3);
/*!40000 ALTER TABLE `t_email_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_email_templates`
--

DROP TABLE IF EXISTS `t_email_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_email_templates` (
                                     `f_id` int NOT NULL AUTO_INCREMENT,
                                     `f_tpl_type` varchar(60) NOT NULL,
                                     `f_tpl_subject` varchar(200) NOT NULL,
                                     `f_tpl_content` text NOT NULL,
                                     PRIMARY KEY (`f_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_email_templates`
--

LOCK TABLES `t_email_templates` WRITE;
/*!40000 ALTER TABLE `t_email_templates` DISABLE KEYS */;
INSERT INTO `t_email_templates` VALUES (1,'add_inventory','Inventory Added','Inventory Message {tank_name} {inventory_amount} '),(2,'high_level_alarm','High Level Warning','High level alarm info:<br/>\n\nTank name: {tank_name} <br/>Current volume: {current_volume}<br/> Alert level: {alert_level_volume}'),(3,'high_level','High Level','Tank high level info:<br/>\n\nTank name: {tank_name} <br/>Current volume: {current_volume}<br/> Alert level: {alert_level_volume}'),(4,'re_order','Re Order','Re order info:<br/>\n\nTank name: {tank_name} <br/>Current volume: {current_volume}<br/> Alert level: {alert_level_volume}'),(5,'shut_off','Shut Off','Tank shut off info:<br/>\n\nTank name: {tank_name} <br/>Current volume: {current_volume}<br/> Alert level: {alert_level_volume}'),(6,'action_journal','Action Journal Report','Action Journal Information:'),(7,'daily_report','Daily Report','Daily Report Information: '),(8,'transaction_report','Transaction journal report','Transaction Report Information '),(9,'detailed_daily_report','Daily Report','Daily Report Information'),(10,'tank_adjustments','Tank Adjustment report','Tank Adjustments Information'),(11,'workorder_status','Workorder Status report','Open and Closed Workorders Information'),(12,'summary_reports','Summary Report','Summary Report');
/*!40000 ALTER TABLE `t_email_templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_events`
--

DROP TABLE IF EXISTS `t_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_events` (
                            `f_event_id` int NOT NULL AUTO_INCREMENT,
                            `f_event_name` varchar(30) NOT NULL,
                            PRIMARY KEY (`f_event_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_events`
--

LOCK TABLES `t_events` WRITE;
/*!40000 ALTER TABLE `t_events` DISABLE KEYS */;
INSERT INTO `t_events` VALUES (1,'Daily Report'),(2,'Inventory'),(3,'High Level Alarm'),(4,'High Level'),(5,'Re-Order'),(6,'Shutoff'),(7,'System Information'),(8,'Summary Reports'),(9,'Workorder Status'),(10,'Transaction Journal'),(11,'Action Journal');
/*!40000 ALTER TABLE `t_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_failed_login_attempts`
--

DROP TABLE IF EXISTS `t_failed_login_attempts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_failed_login_attempts` (
                                           `f_attempt_id` int unsigned NOT NULL AUTO_INCREMENT,
                                           `f_user_id` int unsigned NOT NULL,
                                           `f_ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
                                           `f_user_agent` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
                                           `f_attempt_time` datetime NOT NULL,
                                           PRIMARY KEY (`f_attempt_id`),
                                           KEY `f_user_id` (`f_user_id`),
                                           KEY `f_ip_address` (`f_ip_address`),
                                           CONSTRAINT `fk_failed_login_user` FOREIGN KEY (`f_user_id`) REFERENCES `t_users_details` (`f_user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_failed_login_attempts`
--

LOCK TABLES `t_failed_login_attempts` WRITE;
/*!40000 ALTER TABLE `t_failed_login_attempts` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_failed_login_attempts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_initial_setup`
--

DROP TABLE IF EXISTS `t_initial_setup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_initial_setup` (
                                   `f_initial_id` int NOT NULL AUTO_INCREMENT,
                                   `f_user_logo` varchar(30) NOT NULL,
                                   `f_system_logo` varchar(200) NOT NULL,
                                   `f_user_company_name` varchar(200) NOT NULL,
                                   `f_image_type` tinyint(1) NOT NULL DEFAULT '1',
                                   `f_user_language_id` int NOT NULL,
                                   `f_user_location_id` int NOT NULL,
                                   `f_day_light_mode` varchar(50) DEFAULT NULL,
                                   `f_user_time_hours` int NOT NULL,
                                   `f_user_time_zone` varchar(30) NOT NULL,
                                   `f_user_system_time` time NOT NULL,
                                   `f_date_format` varchar(50) DEFAULT NULL,
                                   `f_user_DST` int NOT NULL,
                                   `f_user_id` varchar(50) DEFAULT NULL,
                                   `f_sync_time` int NOT NULL,
                                   PRIMARY KEY (`f_initial_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_initial_setup`
--

LOCK TABLES `t_initial_setup` WRITE;
/*!40000 ALTER TABLE `t_initial_setup` DISABLE KEYS */;
INSERT INTO `t_initial_setup` VALUES (1,'','','Oilcop',0,1,1,'1',12,'14','00:00:05','m/d/Y',0,'50',0);
/*!40000 ALTER TABLE `t_initial_setup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_job_product`
--

DROP TABLE IF EXISTS `t_job_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_job_product` (
                                 `f_id` int NOT NULL AUTO_INCREMENT,
                                 `f_job_id` int NOT NULL,
                                 `f_product_id` int NOT NULL,
                                 `f_units_id` int NOT NULL,
                                 `f_job_preset_amount` double(10,2) NOT NULL,
                                 `f_dispenser_id` int NOT NULL,
                                 `is_sync` int NOT NULL DEFAULT '0',
                                 PRIMARY KEY (`f_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_job_product`
--

LOCK TABLES `t_job_product` WRITE;
/*!40000 ALTER TABLE `t_job_product` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_job_product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_job_recipes`
--

DROP TABLE IF EXISTS `t_job_recipes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_job_recipes` (
                                 `f_job_id` int NOT NULL AUTO_INCREMENT,
                                 `f_job_name` varchar(44) NOT NULL,
                                 `f_product_id` int NOT NULL,
                                 `f_units_id` int NOT NULL,
                                 `f_job_preset_amount` int NOT NULL,
                                 `f_dispenser_id` int NOT NULL,
                                 `is_sync` int NOT NULL DEFAULT '0',
                                 PRIMARY KEY (`f_job_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_job_recipes`
--

LOCK TABLES `t_job_recipes` WRITE;
/*!40000 ALTER TABLE `t_job_recipes` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_job_recipes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_languages`
--

DROP TABLE IF EXISTS `t_languages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_languages` (
                               `f_language_id` int NOT NULL AUTO_INCREMENT,
                               `f_language_name` varchar(30) NOT NULL,
                               PRIMARY KEY (`f_language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_languages`
--

LOCK TABLES `t_languages` WRITE;
/*!40000 ALTER TABLE `t_languages` DISABLE KEYS */;
INSERT INTO `t_languages` VALUES (1,'English'),(2,'French'),(3,'Italian'),(4,'Spanish'),(5,'German'),(6,'Finnish'),(7,'Chinese'),(8,'Cyrillic');
/*!40000 ALTER TABLE `t_languages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_level_trigger_types`
--

DROP TABLE IF EXISTS `t_level_trigger_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_level_trigger_types` (
                                         `f_level_trigger_id` int NOT NULL COMMENT 'Value that uniquely identifies each record in the table',
                                         `f_level_trigger_description` varchar(50) NOT NULL COMMENT 'User friendly value describing the level trigger',
                                         `f_notes` text NOT NULL,
                                         `f_active` tinyint(1) NOT NULL DEFAULT '1',
                                         `f_date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                         PRIMARY KEY (`f_level_trigger_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_level_trigger_types`
--

LOCK TABLES `t_level_trigger_types` WRITE;
/*!40000 ALTER TABLE `t_level_trigger_types` DISABLE KEYS */;
INSERT INTO `t_level_trigger_types` VALUES (1,'High Level Shutoff','',1,'2023-12-03 19:59:23'),(2,'High Level Warning','',1,'2023-12-03 19:59:48'),(3,'Reorder Level','',1,'2023-12-03 20:00:17'),(4,'Low Level Shutoff','',1,'2023-12-03 20:00:34');
/*!40000 ALTER TABLE `t_level_trigger_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_login_attempts`
--

DROP TABLE IF EXISTS `t_login_attempts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_login_attempts` (
                                    `f_login_attempt_id` int unsigned NOT NULL AUTO_INCREMENT,
                                    `f_username` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
                                    `f_ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
                                    `f_attempted_at` datetime NOT NULL,
                                    `f_success` tinyint(1) NOT NULL DEFAULT '0',
                                    PRIMARY KEY (`f_login_attempt_id`),
                                    KEY `f_ip_address` (`f_ip_address`),
                                    KEY `f_attempted_at` (`f_attempted_at`),
                                    KEY `f_ip_address_f_attempted_at` (`f_ip_address`,`f_attempted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_login_attempts`
--

LOCK TABLES `t_login_attempts` WRITE;
/*!40000 ALTER TABLE `t_login_attempts` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_login_attempts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_network_settings`
--

DROP TABLE IF EXISTS `t_network_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_network_settings` (
                                      `f_network_settings_id` int NOT NULL AUTO_INCREMENT COMMENT 'This field is required so that each record can be uniquely identified. ID 1 represents the Oilcop Network info and ID 2 represents the customers network info. It can be changed by the user. Depending on the controller configuration user may only make changes to the customers network. Access to the Oilcop network settings is prevented. All network data previously assigned to the Oilcop network port the system a automatically redirects them all to the customers network port.',
                                      `f_connection_name` varchar(60) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'This field is used to store the name given to the interface by Ubuntus Network Manager.',
                                      `f_mac_address` varchar(30) NOT NULL COMMENT 'This is the mac address of the network interface',
                                      `f_ip_address` varchar(30) NOT NULL,
                                      `f_network_mask` varchar(30) NOT NULL,
                                      `f_gateway` varchar(30) NOT NULL,
                                      `f_dns` varchar(30) NOT NULL,
                                      `f_dns_alt` varchar(40) NOT NULL COMMENT 'This is the field to store the alternate dns server address',
                                      `f_dhcp` int NOT NULL,
                                      `f_idevice_id` varchar(60) NOT NULL COMMENT 'This field is used to store the device name given to it by Ubuntu Network Manager, increased length to accommodate possible need for more complex names ',
                                      PRIMARY KEY (`f_network_settings_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_network_settings`
--

LOCK TABLES `t_network_settings` WRITE;
/*!40000 ALTER TABLE `t_network_settings` DISABLE KEYS */;
INSERT INTO `t_network_settings` VALUES (1,'OilcopNetworkPort','','192.168.5.1','255.255.255.0','192.168.5.1','208.67.222.222','208.67.221.221',0,'enp1s0'),(2,'CustomerNetworkPort','','192.168.0.223','255.255.255.0','192.168.0.1','8.8.8.8','208.67.221.221',0,'enp2s0');
/*!40000 ALTER TABLE `t_network_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_ports`
--

DROP TABLE IF EXISTS `t_ports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_ports` (
                           `id` int NOT NULL AUTO_INCREMENT,
                           `f_port_no` int DEFAULT NULL COMMENT 'This field represents the ports on the devices.  TMM has 6 sensor and relay ports',
                           PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_ports`
--

LOCK TABLES `t_ports` WRITE;
/*!40000 ALTER TABLE `t_ports` DISABLE KEYS */;
INSERT INTO `t_ports` VALUES (1,1),(2,2),(3,3),(4,4),(5,5),(6,6);
/*!40000 ALTER TABLE `t_ports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_products`
--

DROP TABLE IF EXISTS `t_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_products` (
                              `f_product_id` int NOT NULL AUTO_INCREMENT,
                              `f_customer_product_id` char(25) NOT NULL,
                              `f_product_name` varchar(30) NOT NULL,
                              `D_f_units_id` int NOT NULL,
                              `f_barcode_oil_grade` int NOT NULL,
                              `f_barcode_viscosity` int NOT NULL,
                              `f_gravity` float(15,4) NOT NULL,
  `f_max_preset` float(11,2) NOT NULL,
  `f_max_open_dispense` float(11,2) NOT NULL,
  `f_pro_dispense_wo` float(11,2) NOT NULL,
  `f_collection` tinyint(1) NOT NULL COMMENT 'To Store Designate Product As Collection Only Or Not',
  PRIMARY KEY (`f_product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_products`
--

LOCK TABLES `t_products` WRITE;
/*!40000 ALTER TABLE `t_products` DISABLE KEYS */;
INSERT INTO `t_products` VALUES (1,'226606','1000 THF',0,0,0,0.8740,100.00,100.00,100.00,0),(2,'273270','URSA HYD 10 WT',0,0,0,0.8100,100.00,100.00,100.00,0),(3,'221880','TRACTOR FLUID',0,0,0,0.8710,100.00,100.00,100.00,0),(4,'225157','RED CHAIN BAR 220',0,0,0,0.8676,100.00,100.00,100.00,0),(5,'255637','HYD OIL AW 68',0,0,0,0.8691,100.00,100.00,100.00,0),(6,'254645','HAV HM S/B 5W30',0,0,0,0.8600,100.00,100.00,100.00,0),(7,'224118','SUPREME 10W30',0,0,0,0.8600,100.00,100.00,100.00,0),(8,'273262','RANDO HDZ 68',0,0,0,0.8620,100.00,100.00,100.00,0),(9,'226502','ATF MD3',0,0,0,0.8350,100.00,100.00,100.00,0),(10,'257005','URSA 15W40',0,0,0,0.8550,100.00,100.00,100.00,0),(11,'224116','SUPREME 5W20',0,0,0,0.8610,100.00,100.00,100.00,0),(12,'273264','RANDO HDZ 22',0,0,0,0.8300,100.00,100.00,100.00,0),(13,'293105','TORQFORCE 10',0,0,0,0.8850,100.00,100.00,100.00,0),(14,'273279','RANDO HD 68',0,0,0,0.8300,100.00,100.00,100.00,0),(15,'293110','TORQFORCE MP',0,0,0,0.8718,100.00,100.00,100.00,0),(16,'231709','HEAT TRANSFER OIL 46',0,0,0,0.8500,100.00,100.00,100.00,0),(17,'224503','DELO GEAR ESI 80W90',0,0,0,1.6600,100.00,100.00,100.00,0),(18,'255237','SYN ALL WEATHER THF',0,0,0,0.8596,12.00,12.00,12.00,0),(19,'273260','RANDO HDZ 32',0,0,0,0.8800,100.00,100.00,100.00,0),(20,'223022','DELO GEAR EP-5 80W90',0,0,0,0.8805,100.00,100.00,100.00,0),(21,'262326','HDAX 6500 LFG 40',0,0,0,0.8695,100.00,100.00,100.00,0),(22,'293106','TORQFORCE 30',0,0,0,0.8000,100.00,100.00,100.00,0),(23,'222290','DELO SDE 15W40',0,0,0,0.8470,100.00,100.00,100.00,0),(24,'227811','DELO ELC 50/50',0,0,0,1.0700,100.00,100.00,100.00,0),(25,'222221','DELO SNG 15W40',0,0,0,0.8570,100.00,100.00,100.00,0),(26,'257000','DELO XLE 10W30',0,0,0,0.8689,100.00,100.00,100.00,0),(27,'222220','DELO LE 15W40',0,0,0,0.8756,100.00,100.00,100.00,0),(28,'224117','SUPREME 5W30',0,0,0,0.8612,100.00,100.00,100.00,0),(29,'277314','RANDO HD MV',0,0,0,0.8650,100.00,100.00,100.00,0),(30,'273278','RANDO HD 46',0,0,0,0.8638,100.00,100.00,100.00,0),(31,'273261','RANDO HDZ 46',0,0,0,0.8641,100.00,100.00,100.00,0),(32,'225156','RED CHAIN BAR 68',0,0,0,0.8900,100.00,100.00,100.00,0),(33,'271203','URSA 30 WT',0,0,0,0.8758,100.00,100.00,100.00,0),(43,'3','Kendall GT-1 5W20',0,0,0,0.8610,3300.00,3300.00,3300.00,0),(45,'1077882','Kendall Super DXA 15W40',0,0,0,1.4500,4500.00,4500.00,4500.00,0),(46,'DSHP15','DURON SHP 15W40',0,0,0,0.8653,1.00,1.00,1.00,0),(47,'DHP15','DURON HP 15W40',0,0,0,0.8658,100.00,100.00,100.00,0),(48,'HDXAS','HYDREX XV ALL SEASON',0,0,0,0.8512,100.00,100.00,100.00,0),(49,'HDXMV32','HYDREX MV 32',0,0,0,0.8443,100.00,100.00,100.00,0),(50,'0W/20','CWPRODUCT',0,0,0,0.8800,0.00,0.00,0.00,0);
/*!40000 ALTER TABLE `t_products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_reel_data`
--

DROP TABLE IF EXISTS `t_reel_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_reel_data` (
                               `f_reel_id` int NOT NULL AUTO_INCREMENT,
                               `f_reel_no` int NOT NULL DEFAULT '1' COMMENT 'Removed in Gen2',
                               `f_reel_name` varchar(60) NOT NULL,
                               `f_reel_name_exe` int NOT NULL,
                               `f_reel_status` int NOT NULL,
                               `f_station_id` int NOT NULL,
                               `f_tank_id` int NOT NULL,
                               `D_f_product_id` int NOT NULL,
                               `f_reel_units_id` int NOT NULL,
                               `f_reel_dispenser_no` int NOT NULL,
                               `D_f_reel_shutspeed` int NOT NULL,
                               `f_fcm_id` int NOT NULL,
                               `f_remote_display_id` int NOT NULL COMMENT 'Removed in Gen2',
                               `f_printer_id` int NOT NULL COMMENT 'Removed in Gen2',
                               `f_mini_remote_display_id` int NOT NULL COMMENT 'Removed in Gen2',
                               `f_pulses` int NOT NULL,
                               `f_k_factor` double(20,12) NOT NULL DEFAULT '1.000000000000',
                               `f_last_calibration_date` int NOT NULL,
                               PRIMARY KEY (`f_reel_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_reel_data`
--

LOCK TABLES `t_reel_data` WRITE;
/*!40000 ALTER TABLE `t_reel_data` DISABLE KEYS */;
INSERT INTO `t_reel_data` VALUES (1,1,'Reel 1 psm 11',0,1,1,43,0,4,0,0,75,0,0,0,0,1.000000000000,0),(2,1,'Reel 2 psm 65',0,1,1,11,0,4,0,0,27,0,0,0,0,1.000000000000,0),(3,1,'Reel 3 PSM F2',0,1,1,25,0,4,0,0,39,0,0,0,0,1.000000000000,0),(4,1,'5th reel added to system',0,1,2,43,0,4,0,0,77,0,0,0,0,1.000000000000,0),(5,1,'6th reel added to system',0,1,2,11,0,2,0,0,23,0,0,0,0,1.000000000000,0),(6,1,'7th reel added to system',0,1,2,26,0,3,0,0,38,0,0,0,0,1.000000000000,0),(7,1,'8th reel added to system',0,1,2,19,0,1,0,0,35,0,0,0,0,1.000000000000,0);
/*!40000 ALTER TABLE `t_reel_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_relay_data`
--

DROP TABLE IF EXISTS `t_relay_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_relay_data` (
                                `f_relay_id` int NOT NULL AUTO_INCREMENT,
                                `f_device_id` int NOT NULL COMMENT 'TMM pk who is controlling the relay',
                                `f_relay_name` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'User defined name for relay',
                                `f_relay_name_exe` int NOT NULL COMMENT 'Fields is not used and should be removed from table',
                                `f_relay_port` int NOT NULL COMMENT 'Not used in Gen2 devices but keep for backward compatibility with V1 devices.',
                                `f_default_type` int NOT NULL COMMENT 'This is not really the type but the default state of the relay',
                                `f_trigger_type` int NOT NULL COMMENT 'Trigger types are: 1=product/reel, 2=tank levels, 3=shifts, 4=tank relays',
                                `f_relay_status` int NOT NULL COMMENT 'This field indicates whether or not the relay is enabled or disabled',
                                `f_relay_current_state` int NOT NULL COMMENT 'This is the state of the relay last reported by the tmm ',
                                `f_relay_state_start_time` int NOT NULL COMMENT 'This is the time the relay started it state change from default',
                                `f_relay_state_update_time` int NOT NULL COMMENT 'This field will maintain the information from the last relay get status command 54 0x36',
                                PRIMARY KEY (`f_relay_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_relay_data`
--

LOCK TABLES `t_relay_data` WRITE;
/*!40000 ALTER TABLE `t_relay_data` DISABLE KEYS */;
INSERT INTO `t_relay_data` VALUES (1,76,'Prod/Reel ',0,1,0,1,1,0,0,0),(2,76,'Prod/Reel-1',1,2,0,1,1,0,0,0),(3,76,'Prod/Reel-2',2,3,1,1,1,0,0,0),(9,36,'relay-1',1,1,1,1,1,0,0,0);
/*!40000 ALTER TABLE `t_relay_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_relay_triggers`
--

DROP TABLE IF EXISTS `t_relay_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_relay_triggers` (
                                    `f_trigger_id` int NOT NULL AUTO_INCREMENT,
                                    `f_relay_id` int NOT NULL COMMENT 'this field joins to t_relay_data.f_relay_id to t_relay_triggers.f_relay_id child records. t_relay_data has a one to many relationship',
                                    `f_type_id` int NOT NULL COMMENT 'According to a comment for this field in another db this is the tank pk',
                                    `f_trigger_no` int NOT NULL,
                                    PRIMARY KEY (`f_trigger_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_relay_triggers`
--

LOCK TABLES `t_relay_triggers` WRITE;
/*!40000 ALTER TABLE `t_relay_triggers` DISABLE KEYS */;
INSERT INTO `t_relay_triggers` VALUES (1,1,1,0),(2,2,24,0),(3,3,1,0);
/*!40000 ALTER TABLE `t_relay_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_rf_channel_frequency_mapping`
--

DROP TABLE IF EXISTS `t_rf_channel_frequency_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_rf_channel_frequency_mapping` (
                                                  `f_id` int NOT NULL AUTO_INCREMENT,
                                                  `f_frequency_id` int DEFAULT NULL,
                                                  `f_frequency_value` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
                                                  `f_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
                                                  PRIMARY KEY (`f_id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_rf_channel_frequency_mapping`
--

LOCK TABLES `t_rf_channel_frequency_mapping` WRITE;
/*!40000 ALTER TABLE `t_rf_channel_frequency_mapping` DISABLE KEYS */;
INSERT INTO `t_rf_channel_frequency_mapping` VALUES (1,0,'919.5 MHz','US'),(2,1,'919 MHz','US'),(3,2,'918.5 MHz','US'),(4,3,'918 MHz','US'),(5,4,'917.5 MHz','US'),(6,5,'917 MHz','US'),(7,6,'916.5 MHz','US'),(8,7,'916 MHz','US'),(9,8,'915.5 MHz','US'),(10,9,'915 MHz','US'),(11,10,'914.5 MHz','US'),(12,11,'914 MHz','US'),(13,12,'913.5 MHz','US'),(14,13,'913 MHz','US'),(15,14,'912.5 MHz','US'),(16,15,'912 MHz','US'),(17,16,'911.5 MHz','US'),(18,17,'911 MHz','US'),(19,18,'910.5 MHz','US'),(20,19,'910 MHz','US'),(21,20,'872.5 MHz','Europe'),(22,21,'872 MHz','Europe'),(23,22,'871.5 MHz','Europe'),(24,23,'871 MHz','Europe'),(25,24,'870.5 MHz','Europe'),(26,25,'870 MHz','Europe'),(27,26,'869.5 MHz','Europe'),(28,27,'869 MHz','Europe'),(29,28,'868.5 MHz','Europe'),(30,29,'868 MHz','Europe'),(31,30,'867.5 MHz','Europe'),(32,31,'867 MHz','Europe'),(33,32,'866.5 MHz','Europe'),(34,33,'866 MHz','Europe'),(35,34,'865.5 MHz','Europe'),(36,35,'865 MHz','Europe'),(37,36,'864.5 MHz','Europe'),(38,37,'864 MHz','Europe'),(39,38,'863.5 MHz','Europe'),(40,39,'863 MHz','Europe');
/*!40000 ALTER TABLE `t_rf_channel_frequency_mapping` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_roles`
--

DROP TABLE IF EXISTS `t_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_roles` (
                           `f_role_id` int unsigned NOT NULL AUTO_INCREMENT,
                           `f_role_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
                           PRIMARY KEY (`f_role_name`),
                           UNIQUE KEY `f_role_id` (`f_role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_roles`
--

LOCK TABLES `t_roles` WRITE;
/*!40000 ALTER TABLE `t_roles` DISABLE KEYS */;
INSERT INTO `t_roles` VALUES (1,'Administrator'),(2,'Manager'),(3,'Technician'),(4,'Installer');
/*!40000 ALTER TABLE `t_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_sensor`
--

DROP TABLE IF EXISTS `t_sensor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_sensor` (
                            `f_sensor_id` int NOT NULL AUTO_INCREMENT,
                            `f_sensor_hardware` int NOT NULL,
                            `f_sensor_name` varchar(60) NOT NULL,
                            `f_sensor_name_exe` int NOT NULL,
                            `f_sensor_port` int NOT NULL,
                            `f_tank_id` int NOT NULL,
                            `f_sensor_status` int NOT NULL,
                            `D_f_first_shift` int NOT NULL,
                            `D_f_second_shift` int NOT NULL,
                            `D_f_third_shift` int NOT NULL,
                            `D_f_day_shift` int NOT NULL,
                            `f_legacy_software` int NOT NULL COMMENT 'This is the type of probe connected.SIX_FOOT_PROBE = 1, TEN_FOOT_PROBE = 2,TWENTY_FOOT_PROBE = 3,THIRTY_FOOT_PROBE = 4,TEN_FOOT_TRANSDUCER = 5,TWENTY_FOOT_TRANSDUCER = 6, THIRTY_FOOT_TRANSDUCER = 7,FIFTY_FOUR_INCH_TRANSDUCER = 8',
                            `f_cable_length` float(12,2) NOT NULL,
  `f_cable_units` int NOT NULL,
  PRIMARY KEY (`f_sensor_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_sensor`
--

LOCK TABLES `t_sensor` WRITE;
/*!40000 ALTER TABLE `t_sensor` DISABLE KEYS */;
INSERT INTO `t_sensor` VALUES (1,55,'',0,1,1,1,0,0,0,0,1,0.00,0),(2,26,'',0,6,2,1,0,0,0,0,1,0.00,0),(3,55,'',0,4,3,1,0,0,0,0,1,0.00,0),(4,55,'',0,2,10,1,0,0,0,0,1,0.00,0),(5,55,'',0,3,11,1,0,0,0,0,1,0.00,0),(6,76,'',0,1,12,1,0,0,0,0,1,0.00,0),(7,76,'',0,2,13,1,0,0,0,0,1,0.00,0),(8,76,'',0,3,14,1,0,0,0,0,1,0.00,0),(9,76,'',0,4,15,1,0,0,0,0,1,0.00,0),(10,76,'',0,5,16,1,0,0,0,0,1,0.00,0),(11,76,'',0,6,17,1,0,0,0,0,1,0.00,0);
/*!40000 ALTER TABLE `t_sensor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_sensor_types`
--

DROP TABLE IF EXISTS `t_sensor_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_sensor_types` (
                                  `f_sensor_type_id` int NOT NULL AUTO_INCREMENT,
                                  `f_sensor_type_name` varchar(50) NOT NULL,
                                  PRIMARY KEY (`f_sensor_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_sensor_types`
--

LOCK TABLES `t_sensor_types` WRITE;
/*!40000 ALTER TABLE `t_sensor_types` DISABLE KEYS */;
INSERT INTO `t_sensor_types` VALUES (1,'6 foot probe'),(2,'10 foot probe'),(3,'20 foot probe'),(4,'30 foot probe'),(5,'10 foot transducer'),(6,'20 foot transducer'),(7,'30 foot transducer'),(8,'54 inch transducer');
/*!40000 ALTER TABLE `t_sensor_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_server_transceiver`
--

DROP TABLE IF EXISTS `t_server_transceiver`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_server_transceiver` (
                                        `f_id` int NOT NULL AUTO_INCREMENT,
                                        `f_fcm_id` varchar(12) NOT NULL,
                                        `f_hw_addr` int NOT NULL,
                                        `f_cmd_id` varchar(12) NOT NULL,
                                        `f_st_top` varchar(12) NOT NULL,
                                        `f_reel_channel` varchar(12) NOT NULL,
                                        `f_preset` varchar(12) NOT NULL,
                                        `f_units` varchar(12) NOT NULL,
                                        `f_bit7` varchar(12) NOT NULL,
                                        `f_bit8` varchar(12) NOT NULL,
                                        `f_bit9` varchar(12) NOT NULL,
                                        `f_bit10` varchar(12) NOT NULL,
                                        `f_bit11` varchar(12) NOT NULL,
                                        `f_bit12` varchar(12) NOT NULL,
                                        `f_bit13` varchar(12) NOT NULL,
                                        `f_seg_addr` varchar(12) NOT NULL,
                                        `f_bit15` varchar(12) NOT NULL,
                                        `f_crc` varchar(12) NOT NULL,
                                        PRIMARY KEY (`f_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_server_transceiver`
--

LOCK TABLES `t_server_transceiver` WRITE;
/*!40000 ALTER TABLE `t_server_transceiver` DISABLE KEYS */;
INSERT INTO `t_server_transceiver` VALUES (12,'74',75,'204','0','0','1','0','1','0','0','0','0','0','1','','1','0'),(13,'74',76,'50','6','0','0','1','0','0','31','31','31','31','31','31','31','31');
/*!40000 ALTER TABLE `t_server_transceiver` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_server_transceiver_past_cmd`
--

DROP TABLE IF EXISTS `t_server_transceiver_past_cmd`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_server_transceiver_past_cmd` (
                                                 `f_id` int NOT NULL AUTO_INCREMENT,
                                                 `f_fcm_id` varchar(12) NOT NULL,
                                                 `f_hw_addr` varchar(12) NOT NULL,
                                                 `f_cmd_id` varchar(12) NOT NULL,
                                                 `f_st_top` varchar(12) NOT NULL,
                                                 `f_reel_channel` varchar(12) NOT NULL,
                                                 `f_preset` varchar(12) NOT NULL,
                                                 `f_units` varchar(12) NOT NULL,
                                                 `f_bit7` varchar(12) NOT NULL,
                                                 `f_bit8` varchar(12) NOT NULL,
                                                 `f_bit9` varchar(12) NOT NULL,
                                                 `f_bit10` varchar(12) NOT NULL,
                                                 `f_bit11` varchar(12) NOT NULL,
                                                 `f_bit12` varchar(12) NOT NULL,
                                                 `f_bit13` varchar(12) NOT NULL,
                                                 `f_seg_addr` varchar(12) NOT NULL,
                                                 `f_bit15` varchar(12) NOT NULL,
                                                 `f_crc` varchar(12) NOT NULL,
                                                 `insert_date_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                                 PRIMARY KEY (`f_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_server_transceiver_past_cmd`
--

LOCK TABLES `t_server_transceiver_past_cmd` WRITE;
/*!40000 ALTER TABLE `t_server_transceiver_past_cmd` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_server_transceiver_past_cmd` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_shifts`
--

DROP TABLE IF EXISTS `t_shifts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_shifts` (
                            `f_shift_id` int NOT NULL AUTO_INCREMENT,
                            `f_shift_name` varchar(30) NOT NULL,
                            `f_shift_start` varchar(50) NOT NULL,
                            `f_shift_stop` varchar(50) NOT NULL,
                            `D_f_shift_device_id` varchar(50) NOT NULL,
                            `compulsory` varchar(50) NOT NULL,
                            PRIMARY KEY (`f_shift_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_shifts`
--

LOCK TABLES `t_shifts` WRITE;
/*!40000 ALTER TABLE `t_shifts` DISABLE KEYS */;
INSERT INTO `t_shifts` VALUES (1,'First','8:00','12:00','','0'),(2,'Second','12:01','16:00','','0'),(3,'Third','16:01','20:00','','0'),(4,'Day','8:00','20:00','','0');
/*!40000 ALTER TABLE `t_shifts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_stations`
--

DROP TABLE IF EXISTS `t_stations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_stations` (
                              `f_station_id` int NOT NULL AUTO_INCREMENT,
                              `f_station_name` varchar(30) NOT NULL,
                              `f_station_priority` int NOT NULL DEFAULT '0',
                              PRIMARY KEY (`f_station_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_stations`
--

LOCK TABLES `t_stations` WRITE;
/*!40000 ALTER TABLE `t_stations` DISABLE KEYS */;
INSERT INTO `t_stations` VALUES (1,'Station 1',1),(2,'Station 2',0);
/*!40000 ALTER TABLE `t_stations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_status_messages`
--

DROP TABLE IF EXISTS `t_status_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_status_messages` (
                                     `f_id` int NOT NULL AUTO_INCREMENT,
                                     `f_status_no` int NOT NULL,
                                     `f_message` varchar(200) NOT NULL,
                                     PRIMARY KEY (`f_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_status_messages`
--

LOCK TABLES `t_status_messages` WRITE;
/*!40000 ALTER TABLE `t_status_messages` DISABLE KEYS */;
INSERT INTO `t_status_messages` VALUES (1,255,'communication error'),(2,254,'invalid');
/*!40000 ALTER TABLE `t_status_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_system`
--

DROP TABLE IF EXISTS `t_system`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_system` (
                            `f_id` int NOT NULL AUTO_INCREMENT,
                            `f_system_key` varchar(20) NOT NULL,
                            `f_version_id` int NOT NULL,
                            `f_system_key_value` varchar(20) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
                            `f_version_type` varchar(20) NOT NULL,
                            PRIMARY KEY (`f_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_system`
--

LOCK TABLES `t_system` WRITE;
/*!40000 ALTER TABLE `t_system` DISABLE KEYS */;
INSERT INTO `t_system` VALUES (1,'Version',285,'LQD_EG2_2_9','LQD_EG2');
/*!40000 ALTER TABLE `t_system` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_systemlog`
--

DROP TABLE IF EXISTS `t_systemlog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_systemlog` (
                               `f_systemlog_id` int NOT NULL AUTO_INCREMENT,
                               `f_time` time NOT NULL,
                               `f_date` varchar(12) NOT NULL,
                               `f_role_id` int NOT NULL,
                               `f_user_id` int NOT NULL,
                               `f_action_id` int NOT NULL,
                               `f_adj_id` int DEFAULT NULL,
                               `f_created` int NOT NULL,
                               `is_sync` int NOT NULL DEFAULT '0',
                               PRIMARY KEY (`f_systemlog_id`)
) ENGINE=InnoDB AUTO_INCREMENT=149 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_systemlog`
--

LOCK TABLES `t_systemlog` WRITE;
/*!40000 ALTER TABLE `t_systemlog` DISABLE KEYS */;
INSERT INTO `t_systemlog` VALUES (1,'838:59:59','2023-10-05',1,1,0,0,1696540841,0),(2,'838:59:59','2023-10-07',1,1,0,0,1696685942,0),(3,'838:59:59','2023-10-30',1,1,0,0,1698682328,0),(4,'838:59:59','2023-11-02',1,1,0,0,1698926840,0),(5,'00:00:00','',1,1,1,0,1698932325,0),(6,'00:00:00','',1,1,2,0,1698933820,0),(7,'00:00:00','',1,1,3,0,1698947497,0),(8,'00:00:00','',1,1,4,0,1698947629,0),(9,'00:00:00','',1,1,5,0,1698954048,0),(10,'00:00:00','',1,1,6,0,1698954652,0),(11,'00:00:00','',1,1,7,0,1698954768,0),(12,'00:00:00','',1,1,8,0,1698955076,0),(13,'00:00:00','',1,1,9,0,1698955235,0),(14,'00:00:00','',1,1,10,0,1698955350,0),(15,'00:00:00','',1,1,11,0,1698955435,0),(16,'00:00:00','',1,1,12,0,1698955608,0),(17,'00:00:00','',1,1,13,0,1698955748,0),(18,'00:00:00','',1,1,14,0,1698955795,0),(19,'00:00:00','',1,1,15,0,1698955951,0),(20,'00:00:00','',1,1,16,0,1698955982,0),(21,'00:00:00','',1,1,17,0,1698956027,0),(22,'00:00:00','',1,1,18,0,1698956102,0),(23,'00:00:00','',1,1,19,0,1698956261,0),(24,'00:00:00','',1,1,20,0,1698956334,0),(25,'00:00:00','',1,1,21,0,1698968996,0),(26,'00:00:00','',1,1,22,0,1698969067,0),(27,'00:00:00','',1,1,23,0,1698969138,0),(28,'00:00:00','',1,1,24,0,1699029337,0),(29,'00:00:00','',1,1,25,0,1699041528,0),(30,'00:00:00','',1,1,26,0,1699041847,0),(31,'00:00:00','',1,1,27,0,1699045246,0),(32,'00:00:00','',1,1,28,0,1699045481,0),(33,'00:00:00','',1,1,29,0,1699045506,0),(34,'00:00:00','',1,1,30,0,1699045625,0),(35,'00:00:00','',1,1,31,0,1699062849,0),(36,'00:00:00','',1,1,32,0,1699062920,0),(37,'00:00:00','',1,1,33,0,1699062960,0),(38,'838:59:59','2023-11-04',1,1,0,0,1699071338,0),(39,'838:59:59','2023-11-05',1,1,0,0,1699198705,0),(40,'00:00:00','',1,1,34,0,1699198971,0),(41,'00:00:00','',1,1,35,0,1699201465,0),(42,'00:00:00','',1,1,36,0,1699201573,0),(43,'00:00:00','',1,1,37,0,1699201710,0),(44,'00:00:00','',1,1,38,0,1699201779,0),(45,'00:00:00','',1,1,39,0,1699201860,0),(46,'00:00:00','',1,1,40,0,1699201939,0),(47,'00:00:00','',1,1,41,0,1699201967,0),(48,'00:00:00','',1,1,42,0,1699202178,0),(49,'00:00:00','',1,1,43,0,1699202257,0),(50,'00:00:00','',1,1,44,0,1699202386,0),(51,'00:00:00','',1,1,45,0,1699202629,0),(52,'00:00:00','',1,1,46,0,1699202737,0),(53,'00:00:00','',1,1,47,0,1699203350,0),(54,'00:00:00','',1,1,48,0,1699217397,0),(55,'00:00:00','',1,1,49,0,1699217442,0),(56,'00:00:00','',1,1,50,0,1699217480,0),(57,'00:00:00','',1,1,51,0,1699217631,0),(58,'00:00:00','',1,1,52,0,1699218002,0),(59,'00:00:00','',1,1,53,0,1699218063,0),(60,'00:00:00','',1,1,54,0,1699218474,0),(61,'838:59:59','2023-11-07',1,1,0,0,1699369679,0),(62,'00:00:00','',1,1,55,0,1699459356,0),(63,'00:00:00','',1,1,56,0,1699459375,0),(64,'00:00:00','',1,1,57,0,1699459386,0),(65,'00:00:00','',1,1,58,0,1699459415,0),(66,'00:00:00','',1,1,59,0,1699459455,0),(67,'00:00:00','',1,1,60,0,1699459487,0),(68,'00:00:00','',1,1,61,0,1699459515,0),(69,'00:00:00','',1,1,62,0,1699459558,0),(70,'00:00:00','',1,1,63,0,1699459586,0),(71,'00:00:00','',1,1,64,0,1699459757,0),(72,'838:59:59','2023-11-09',1,1,0,0,1699539829,0),(73,'00:00:00','',1,1,65,0,1699542407,0),(74,'00:00:00','',1,1,66,0,1699542509,0),(75,'838:59:59','2023-11-09',1,1,0,0,1699543854,0),(76,'00:00:00','',1,1,67,0,1699545806,0),(77,'00:00:00','',1,1,68,0,1699545814,0),(78,'838:59:59','2023-11-09',1,1,0,0,1699558971,0),(79,'00:00:00','',1,1,69,0,1699615816,0),(80,'00:00:00','',1,1,70,0,1699615848,0),(81,'00:00:00','',1,1,71,0,1699616010,0),(82,'00:00:00','',1,1,72,0,1699616415,0),(83,'00:00:00','',1,1,73,0,1699616439,0),(84,'00:00:00','',1,1,74,0,1699616458,0),(85,'00:00:00','',1,1,75,0,1699616489,0),(86,'00:00:00','',1,1,76,0,1699616549,0),(87,'00:00:00','',1,1,77,0,1699616573,0),(88,'00:00:00','',1,1,78,0,1699616595,0),(89,'00:00:00','',1,1,79,0,1699616621,0),(90,'00:00:00','',1,1,80,0,1699618091,0),(91,'00:00:00','',1,1,81,0,1699618110,0),(92,'00:00:00','',1,1,82,0,1699619704,0),(93,'00:00:00','',1,1,83,0,1699619782,0),(94,'00:00:00','',1,1,84,0,1699871036,0),(95,'838:59:59','2023-11-13',1,1,0,0,1699895409,0),(96,'00:00:00','',1,1,85,0,1700056806,0),(97,'00:00:00','',1,1,86,0,1700056941,0),(98,'00:00:00','',1,1,87,0,1700056982,0),(99,'00:00:00','',1,1,88,0,1701625147,0),(100,'00:00:00','',1,1,89,0,1701625207,0),(101,'00:00:00','',1,1,90,0,1701625229,0),(102,'00:00:00','',1,1,91,0,1701625244,0),(103,'00:00:00','',1,1,92,0,1701625266,0),(104,'00:00:00','',1,1,93,0,1701625323,0),(105,'00:00:00','',1,1,94,0,1701625359,0),(106,'00:00:00','',1,1,95,0,1701625409,0),(107,'838:59:59','2023-12-04',1,1,0,0,1701728791,0),(108,'00:00:00','',1,1,96,NULL,1704977367,0),(109,'838:59:59','2024-01-11',1,31,0,NULL,1704982826,0),(110,'838:59:59','2024-01-17',1,1,0,NULL,1705489887,0),(111,'838:59:59','2024-12-05',1,1,0,NULL,1733421321,0),(112,'838:59:59','2025-02-27',1,1,0,NULL,1740673875,0),(113,'838:59:59','2025-03-10',1,31,0,NULL,1741622861,0),(114,'838:59:59','2025-03-11',1,31,0,NULL,1741701832,0),(115,'00:00:00','',1,31,97,NULL,1741703416,0),(116,'00:00:00','',1,31,98,NULL,1741703727,0),(117,'838:59:59','2025-05-23',1,31,0,NULL,1748003269,0),(118,'838:59:59','2025-07-03',1,31,0,NULL,1751511155,0),(119,'838:59:59','2025-07-03',1,31,0,NULL,1751547748,0),(120,'838:59:59','2025-07-03',1,31,0,NULL,1751547940,0),(121,'838:59:59','2025-07-14',1,31,0,NULL,1752533536,0),(122,'838:59:59','2025-07-19',1,31,0,NULL,1752949599,0),(123,'00:00:00','',1,31,99,NULL,1752949802,0),(124,'00:00:00','',1,31,100,NULL,1752951757,0),(125,'838:59:59','2025-07-20',1,31,0,NULL,1753026330,0),(126,'838:59:59','2025-07-26',1,31,0,NULL,1753497418,0),(127,'838:59:59','2025-07-26',1,31,0,NULL,1753498374,0),(128,'838:59:59','2025-07-26',1,31,0,NULL,1753510723,0),(129,'838:59:59','2025-07-27',1,31,0,NULL,1753623245,0),(130,'838:59:59','2025-07-27',1,31,0,NULL,1753624072,0),(131,'838:59:59','2025-07-27',1,31,0,NULL,1753624550,0),(132,'838:59:59','2025-07-27',1,31,0,NULL,1753625208,0),(133,'838:59:59','2025-07-27',1,31,0,NULL,1753638637,0),(134,'838:59:59','2025-07-27',1,31,0,NULL,1753654217,0),(135,'838:59:59','2025-07-27',1,31,0,NULL,1753654265,0),(136,'838:59:59','2025-07-28',1,31,0,NULL,1753661139,0),(137,'838:59:59','2025-07-28',1,31,0,NULL,1753661400,0),(138,'838:59:59','2025-07-28',1,31,0,NULL,1753661416,0),(139,'838:59:59','2025-07-31',1,31,0,NULL,1754002474,0),(140,'838:59:59','2025-08-02',1,31,0,NULL,1754146149,0),(141,'838:59:59','2025-08-02',1,31,0,NULL,1754154913,0),(142,'838:59:59','2025-08-02',1,31,0,NULL,1754155006,0),(143,'838:59:59','2025-08-02',1,31,0,NULL,1754167911,0),(144,'838:59:59','2025-08-03',1,31,0,NULL,1754255397,0),(145,'838:59:59','2025-08-03',1,31,0,NULL,1754255838,0),(146,'838:59:59','2025-08-05',1,31,0,NULL,1754420829,0),(147,'838:59:59','2025-08-06',1,31,0,NULL,1754440562,0),(148,'838:59:59','2025-08-06',1,31,0,NULL,1754440846,0);
/*!40000 ALTER TABLE `t_systemlog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_tank_adjustments`
--

DROP TABLE IF EXISTS `t_tank_adjustments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_tank_adjustments` (
                                      `f_adj_id` int NOT NULL AUTO_INCREMENT,
                                      `f_user_id` int NOT NULL,
                                      `f_tank_id` int NOT NULL,
                                      `f_product_id` int NOT NULL,
                                      `f_manu_aut` varchar(50) NOT NULL,
                                      `f_inventory_type` varchar(50) NOT NULL,
                                      `f_amount` double(12,5) NOT NULL,
                                      `f_new_inventory` double(12,5) NOT NULL,
                                      `f_units_id` int NOT NULL,
                                      `delivery` int NOT NULL,
                                      `comment` text NOT NULL,
                                      `f_created_time` int NOT NULL,
                                      `is_sync` int NOT NULL DEFAULT '0',
                                      PRIMARY KEY (`f_adj_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_tank_adjustments`
--

LOCK TABLES `t_tank_adjustments` WRITE;
/*!40000 ALTER TABLE `t_tank_adjustments` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_tank_adjustments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_tank_configuration`
--

DROP TABLE IF EXISTS `t_tank_configuration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_tank_configuration` (
                                        `f_id` int NOT NULL AUTO_INCREMENT,
                                        `f_tank_id` int NOT NULL,
                                        `f_tank_type` varchar(10) NOT NULL,
                                        `f_tank_shape` varchar(50) NOT NULL,
                                        `f_tank_height` float(10,2) NOT NULL,
  `f_tank_width` float(10,2) NOT NULL,
  `f_tank_length` float(10,2) NOT NULL,
  `f_tank_radius` float(10,2) NOT NULL,
  `f_tank_side` float(10,2) NOT NULL,
  `D_f_tank_filled_volume` float(10,2) NOT NULL,
  `f_tank_volume_type` varchar(15) NOT NULL,
  `f_tank_monitor_installed` varchar(5) NOT NULL,
  PRIMARY KEY (`f_id`)
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_tank_configuration`
--

LOCK TABLES `t_tank_configuration` WRITE;
/*!40000 ALTER TABLE `t_tank_configuration` DISABLE KEYS */;
INSERT INTO `t_tank_configuration` VALUES (1,1,'default','round_vertical',72.00,0.00,0.00,32.00,0.00,0.00,'inches','yes'),(2,2,'default','round_vertical',72.00,0.00,0.00,32.00,0.00,0.00,'inches','yes'),(3,3,'default','round_vertical',72.00,0.00,0.00,32.00,0.00,0.00,'inches','yes'),(4,4,'default','round_vertical',72.00,0.00,0.00,32.00,0.00,0.00,'inches','yes'),(5,5,'default','round_vertical',72.00,0.00,0.00,32.00,0.00,0.00,'inches','yes'),(6,6,'default','round_vertical',72.00,0.00,0.00,32.00,0.00,0.00,'inches','yes'),(7,7,'default','round_vertical',72.00,0.00,0.00,32.00,0.00,0.00,'inches','yes'),(8,8,'default','round_vertical',94.00,0.00,0.00,39.12,0.00,0.00,'inches','yes'),(9,9,'default','round_vertical',94.00,0.00,0.00,39.00,0.00,0.00,'inches','yes'),(10,10,'default','round_vertical',96.00,0.00,0.00,39.00,0.00,0.00,'inches','yes'),(11,11,'default','round_vertical',96.00,0.00,0.00,39.00,0.00,0.00,'inches','yes'),(12,12,'default','round_vertical',96.00,0.00,0.00,39.00,0.00,0.00,'inches','yes'),(13,13,'default','round_vertical',96.00,0.00,0.00,39.00,0.00,0.00,'inches','yes'),(14,14,'default','round_horizontal',143.00,0.00,0.00,32.50,0.00,0.00,'inches','yes'),(15,15,'default','round_horizontal',110.00,0.00,0.00,42.00,0.00,0.00,'inches','yes'),(16,16,'default','round_horizontal',110.00,0.00,0.00,42.00,0.00,0.00,'inches','yes'),(17,17,'default','round_horizontal',182.00,0.00,0.00,32.00,0.00,0.00,'inches','yes'),(18,18,'default','round_horizontal',182.00,0.00,0.00,32.00,0.00,0.00,'inches','yes'),(19,19,'default','round_horizontal',182.00,0.00,0.00,32.00,0.00,0.00,'inches','yes'),(20,20,'default','round_horizontal',182.00,0.00,0.00,32.00,0.00,0.00,'inches','yes'),(21,21,'default','round_horizontal',182.00,0.00,0.00,32.00,0.00,0.00,'inches','yes'),(22,22,'default','round_horizontal',182.00,0.00,0.00,32.00,0.00,0.00,'inches','yes'),(23,23,'default','round_horizontal',182.00,0.00,0.00,32.00,0.00,0.00,'inches','yes'),(24,24,'default','round_horizontal',182.00,0.00,0.00,32.00,0.00,0.00,'inches','yes'),(25,25,'default','round_horizontal',94.00,0.00,0.00,63.00,0.00,0.00,'inches','yes'),(26,26,'default','round_horizontal',94.00,0.00,0.00,63.00,0.00,0.00,'inches','yes'),(27,27,'default','round_horizontal',94.00,0.00,0.00,63.00,0.00,0.00,'inches','yes'),(28,28,'default','round_horizontal',94.00,0.00,0.00,63.00,0.00,0.00,'inches','yes'),(29,29,'default','round_horizontal',94.00,0.00,0.00,63.00,0.00,0.00,'inches','yes'),(30,30,'default','round_horizontal',94.00,0.00,0.00,63.00,0.00,0.00,'inches','yes'),(31,31,'default','round_horizontal',94.00,0.00,0.00,63.00,0.00,0.00,'inches','yes'),(32,32,'default','round_horizontal',94.00,0.00,0.00,63.00,0.00,0.00,'inches','yes'),(33,33,'default','round_horizontal',94.00,0.00,0.00,63.00,0.00,0.00,'inches','yes'),(34,34,'default','round_horizontal',94.00,0.00,0.00,63.00,0.00,0.00,'inches','yes'),(35,35,'default','round_horizontal',94.00,0.00,0.00,63.00,0.00,0.00,'inches','yes'),(36,36,'default','round_horizontal',94.00,0.00,0.00,63.00,0.00,0.00,'inches','yes'),(37,37,'default','round_horizontal',94.00,0.00,0.00,63.00,0.00,0.00,'inches','yes'),(38,38,'default','round_horizontal',94.00,0.00,0.00,63.00,0.00,0.00,'inches','yes'),(39,39,'default','round_horizontal',94.00,0.00,0.00,63.00,0.00,0.00,'inches','yes'),(40,40,'default','round_horizontal',94.00,0.00,0.00,63.00,0.00,0.00,'inches','yes'),(41,41,'default','round_horizontal',94.00,0.00,0.00,63.00,0.00,0.00,'inches','yes'),(42,42,'default','round_horizontal',94.00,0.00,0.00,63.00,0.00,0.00,'inches','yes'),(43,43,'default','round_horizontal',94.00,0.00,0.00,63.00,0.00,0.00,'inches','yes'),(44,44,'default','round_horizontal',94.00,0.00,0.00,63.00,0.00,0.00,'inches','yes'),(45,45,'','',0.00,0.00,0.00,0.00,0.00,0.00,'',''),(46,46,'default','round_vertical',90.00,0.00,0.00,48.00,0.00,0.00,'inches','yes'),(47,47,'default','round_vertical',90.00,0.00,0.00,48.00,0.00,0.00,'inches','yes'),(48,48,'default','round_vertical',90.00,0.00,0.00,48.00,0.00,0.00,'inches','yes'),(49,49,'','',0.00,0.00,0.00,0.00,0.00,0.00,'',''),(50,50,'','',0.00,0.00,0.00,0.00,0.00,0.00,'',''),(51,51,'default','round_vertical',90.00,0.00,0.00,48.00,0.00,0.00,'inches','yes'),(52,52,'default','round_vertical',90.00,0.00,0.00,48.00,0.00,0.00,'inches','yes'),(54,54,'default','round_horizontal',138.00,0.00,0.00,42.00,0.00,0.00,'inches','yes'),(55,55,'','',0.00,0.00,0.00,0.00,0.00,0.00,'','');
/*!40000 ALTER TABLE `t_tank_configuration` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_tank_details`
--

DROP TABLE IF EXISTS `t_tank_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_tank_details` (
                                  `f_tank_id` int NOT NULL AUTO_INCREMENT,
                                  `f_tank_name` varchar(30) NOT NULL,
                                  `f_tank_product_id` int NOT NULL,
                                  `f_tank_product_exe` int NOT NULL,
                                  `f_tank_product_units_id` int NOT NULL,
                                  `f_sensor_id` int NOT NULL,
                                  `f_tank_display_priority` int NOT NULL DEFAULT '1000',
                                  PRIMARY KEY (`f_tank_id`)
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_tank_details`
--

LOCK TABLES `t_tank_details` WRITE;
/*!40000 ALTER TABLE `t_tank_details` DISABLE KEYS */;
INSERT INTO `t_tank_details` VALUES (1,'1',26,5,4,0,1),(2,'2',26,6,4,0,2),(3,'3',32,2,4,0,3),(4,'4',32,3,4,0,4),(5,'5',12,2,4,0,5),(6,'6',26,4,4,0,6),(7,'7',26,7,4,0,7),(8,'8',7,3,4,0,8),(9,'9',2,8,4,0,9),(10,'10',8,0,4,0,10),(11,'11',9,0,4,0,11),(12,'12',47,0,4,0,12),(13,'13',11,0,4,0,13),(14,'14',16,2,4,0,14),(15,'15',13,0,4,0,15),(16,'16',14,0,4,0,16),(17,'17',18,2,4,0,17),(18,'18',30,2,4,0,18),(19,'19',17,0,4,0,19),(20,'20',18,0,4,0,20),(21,'21',19,0,4,0,21),(22,'22',20,0,4,0,22),(23,'23',46,2,4,0,23),(24,'24',22,0,4,0,24),(25,'25',23,0,4,0,25),(26,'26',24,0,4,0,26),(27,'27',25,0,4,0,27),(28,'28',26,0,4,0,28),(29,'29',23,4,4,0,29),(30,'30',28,0,4,0,30),(31,'31',23,5,4,0,31),(32,'32',29,0,4,0,32),(33,'33',48,0,4,0,33),(43,'43',1,3,4,0,43),(45,'45',34,0,4,0,45),(46,'46',36,0,4,0,46),(47,'47',37,0,4,0,47),(48,'48',38,0,4,0,48),(49,'49',35,0,4,0,49),(50,'50',39,0,4,0,50),(51,'51',40,0,4,0,51),(52,'52',41,0,4,0,52),(54,'54',43,0,4,0,54),(55,'55',44,0,4,0,55);
/*!40000 ALTER TABLE `t_tank_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_tank_dispense`
--

DROP TABLE IF EXISTS `t_tank_dispense`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_tank_dispense` (
                                   `f_tdisp_id` int NOT NULL AUTO_INCREMENT,
                                   `f_tank_id` int NOT NULL,
                                   `f_relay_id` int NOT NULL,
                                   `f_start_amount` double(12,5) NOT NULL,
                                   `f_end_amount` double(12,5) NOT NULL,
                                   `f_start_time` int NOT NULL,
                                   `f_end_time` int NOT NULL,
                                   `f_start_user` int NOT NULL,
                                   `f_end_user` int NOT NULL,
                                   `f_timeout_type` varchar(50) NOT NULL,
                                   `is_sync` int NOT NULL DEFAULT '0',
                                   PRIMARY KEY (`f_tdisp_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_tank_dispense`
--

LOCK TABLES `t_tank_dispense` WRITE;
/*!40000 ALTER TABLE `t_tank_dispense` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_tank_dispense` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_tank_inventory`
--

DROP TABLE IF EXISTS `t_tank_inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_tank_inventory` (
                                    `f_id` int NOT NULL AUTO_INCREMENT,
                                    `f_tank_id` int NOT NULL,
                                    `f_product_id` int NOT NULL,
                                    `f_units_id` int NOT NULL,
                                    `f_tank_volume` double(12,1) NOT NULL,
                                    `f_tank_high_alarm` int NOT NULL,
                                    `f_tank_high_level` int NOT NULL,
                                    `f_tank_reorder_level` int NOT NULL,
                                    `f_tank_shutoff_level` int NOT NULL,
                                    `f_tank_capacity` double(12,1) NOT NULL,
                                    `f_tank_lock_out` varchar(20) NOT NULL,
                                    `f_tank_notification` int NOT NULL,
                                    `f_alert_conditions` varchar(20) NOT NULL,
                                    `f_inventory_date` date NOT NULL,
                                    PRIMARY KEY (`f_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_tank_inventory`
--

LOCK TABLES `t_tank_inventory` WRITE;
/*!40000 ALTER TABLE `t_tank_inventory` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_tank_inventory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_tank_levels`
--

DROP TABLE IF EXISTS `t_tank_levels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_tank_levels` (
                                 `f_id` int NOT NULL AUTO_INCREMENT,
                                 `f_tank_id` int NOT NULL,
                                 `f_tank_level` int NOT NULL,
                                 `f_tank_volume` float(10,2) NOT NULL,
  PRIMARY KEY (`f_id`)
) ENGINE=InnoDB AUTO_INCREMENT=153 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_tank_levels`
--

LOCK TABLES `t_tank_levels` WRITE;
/*!40000 ALTER TABLE `t_tank_levels` DISABLE KEYS */;
INSERT INTO `t_tank_levels` VALUES (11,10,1,1984.80),(12,11,1,1984.80),(14,13,1,1984.80),(21,15,1,2637.60),(22,16,1,2637.60),(25,19,1,2533.31),(26,20,1,2533.31),(27,21,1,2533.31),(28,22,1,2533.31),(30,24,1,2533.31),(34,25,1,5071.38),(35,26,1,5071.38),(36,27,1,5071.38),(37,28,1,5071.38),(39,30,1,5071.38),(41,32,1,5071.38),(43,34,1,5071.38),(44,35,1,5071.38),(45,36,1,5071.38),(46,37,1,5071.38),(47,38,1,5071.38),(49,39,1,5071.38),(52,42,1,5071.38),(54,44,1,5071.38),(74,43,1,5071.38),(75,17,1,2533.31),(77,6,1,1002.19),(78,29,1,5071.38),(91,46,1,2818.66),(92,52,1,2818.66),(93,51,1,2818.66),(95,47,1,2818.66),(96,48,1,2818.66),(105,54,1,3308.99),(117,53,1,2531.03),(132,8,1,1955.43),(134,3,1,1002.19),(135,4,1,1002.19),(136,5,1,1002.19),(137,14,1,2053.15),(138,41,1,5071.38),(140,12,1,1984.80),(141,18,1,2533.31),(142,33,1,5071.38),(144,40,1,5071.38),(145,23,1,2533.31),(146,1,1,1002.19),(147,2,1,1002.19),(149,7,1,1002.19),(151,9,1,1943.45),(152,31,1,5071.38);
/*!40000 ALTER TABLE `t_tank_levels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_tank_mails`
--

DROP TABLE IF EXISTS `t_tank_mails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_tank_mails` (
                                `id` int NOT NULL AUTO_INCREMENT,
                                `tank_id` int NOT NULL,
                                `tank_level` int NOT NULL,
                                `send_time` int NOT NULL,
                                PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_tank_mails`
--

LOCK TABLES `t_tank_mails` WRITE;
/*!40000 ALTER TABLE `t_tank_mails` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_tank_mails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_tank_reports`
--

DROP TABLE IF EXISTS `t_tank_reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_tank_reports` (
                                  `f_id` int NOT NULL AUTO_INCREMENT,
                                  `f_created` int NOT NULL,
                                  `f_tank_id` int NOT NULL,
                                  `f_tank_inv` double(12,5) NOT NULL,
                                  `is_sync` int NOT NULL DEFAULT '0',
                                  PRIMARY KEY (`f_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_tank_reports`
--

LOCK TABLES `t_tank_reports` WRITE;
/*!40000 ALTER TABLE `t_tank_reports` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_tank_reports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_tank_software`
--

DROP TABLE IF EXISTS `t_tank_software`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_tank_software` (
                                   `f_tank_id` int NOT NULL AUTO_INCREMENT,
                                   `f_product_id` int NOT NULL,
                                   `f_units_id` int NOT NULL,
                                   `f_tank_volume` double(12,5) NOT NULL,
                                   `f_tank_high_alarm` double(12,5) NOT NULL,
                                   `f_tank_high_level` double(12,5) NOT NULL,
                                   `f_tank_reorder_level` double(12,5) NOT NULL,
                                   `f_tank_shutoff_level` double(12,5) NOT NULL,
                                   `f_tank_capacity` double(12,1) NOT NULL,
                                   `f_tank_lock_out` varchar(20) NOT NULL,
                                   `f_tank_notification` int NOT NULL,
                                   `f_alert_conditions` varchar(20) NOT NULL,
                                   `f_tank_timeout` int NOT NULL,
                                   `f_tank_mode` int NOT NULL,
                                   `f_current_height` double(12,5) NOT NULL,
                                   `CustomAlerts` tinyint(1) NOT NULL DEFAULT '0',
                                   PRIMARY KEY (`f_tank_id`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_tank_software`
--

LOCK TABLES `t_tank_software` WRITE;
/*!40000 ALTER TABLE `t_tank_software` DISABLE KEYS */;
INSERT INTO `t_tank_software` VALUES (1,26,4,0.00000,902.00000,952.00000,200.00000,50.00000,1002.2,'0',0,'volume',0,0,0.00000,0),(2,26,4,51.95948,902.00000,952.00000,200.00000,50.00000,1002.2,'0',0,'volume',0,0,3.73102,0),(3,32,4,224.82485,902.00000,952.00000,200.00000,50.00000,1002.2,'0',0,'volume',0,0,16.14384,0),(4,32,4,48.69852,902.00000,952.00000,200.00000,50.00000,1002.2,'0',0,'volume',0,0,3.49686,0),(5,12,4,767.18267,902.00000,952.00000,200.00000,50.00000,1002.2,'0',0,'volume',0,0,55.08855,0),(6,26,4,43.64596,902.00000,952.00000,200.00000,50.00000,1002.2,'0',0,'volume',0,0,3.13406,0),(7,26,4,57.77894,902.00000,952.00000,200.00000,50.00000,1002.2,'0',0,'volume',0,0,4.14889,0),(8,7,4,1309.29693,1786.00000,1886.00000,397.00000,99.00000,1955.4,'0',0,'volume',0,0,62.90758,0),(9,2,4,0.00000,1786.00000,1886.00000,397.00000,99.00000,1943.5,'0',0,'volume',0,0,0.00000,0),(10,8,0,1016.32530,1786.00000,1886.00000,397.00000,99.00000,1984.8,'',0,'volume',0,0,49.13218,0),(11,9,0,1865.79513,1786.00000,1886.00000,397.00000,99.00000,1984.8,'',0,'volume',0,0,90.19808,0),(12,47,4,1329.73762,1786.00000,1886.00000,397.00000,99.00000,1984.8,'0',0,'volume',0,0,64.28347,0),(13,11,0,357.65357,1786.00000,1886.00000,397.00000,99.00000,1984.8,'',0,'volume',0,0,17.29004,0),(14,16,4,1569.15880,1848.00000,1950.00000,411.00000,103.00000,2053.1,'0',0,'volume',0,0,46.40849,0),(15,13,4,1079.76087,2374.00000,2506.00000,528.00000,132.00000,2637.6,'0',0,'volume',0,0,35.98672,0),(16,14,0,2418.78869,2374.00000,2506.00000,528.00000,132.00000,2637.6,'',0,'volume',0,0,72.39942,0),(17,18,4,1972.30848,2280.00000,2407.00000,507.00000,127.00000,2533.3,'0',0,'volume',0,0,46.49362,0),(18,30,4,478.67138,2280.00000,2407.00000,507.00000,127.00000,2533.3,'0',0,'volume',0,0,15.61267,0),(19,17,0,2050.69012,2280.00000,2407.00000,507.00000,127.00000,2533.3,'',0,'volume',0,0,48.26662,0),(20,18,0,2196.66390,2280.00000,2407.00000,507.00000,127.00000,2533.3,'',0,'volume',0,0,51.77356,0),(21,19,0,686.88934,2280.00000,2407.00000,507.00000,127.00000,2533.3,'',0,'volume',0,0,20.21755,0),(22,20,0,2024.09493,2280.00000,2407.00000,507.00000,127.00000,2533.3,'',0,'volume',0,0,47.65805,0),(23,46,4,1863.46173,2280.00000,2407.00000,507.00000,127.00000,2533.3,'0',0,'volume',0,0,44.11926,0),(24,22,0,1151.20299,2280.00000,2407.00000,507.00000,127.00000,2533.3,'',0,'volume',0,0,29.69564,0),(25,23,4,4304.25060,4079.00000,4305.00000,906.00000,227.00000,5071.4,'0',0,'volume',0,0,99.65690,0),(26,24,0,4006.48119,4564.00000,4818.00000,1014.00000,254.00000,5071.4,'',0,'volume',0,0,92.81418,0),(27,25,0,4632.24194,4564.00000,4818.00000,1014.00000,254.00000,5071.4,'',0,'volume',0,0,108.08143,0),(28,26,0,3504.39470,4564.00000,4818.00000,1014.00000,254.00000,5071.4,'',0,'volume',0,0,82.16809,0),(29,23,4,4726.51286,4564.00000,4818.00000,1014.00000,254.00000,5071.4,'0',0,'volume',0,0,110.80353,0),(30,28,0,2933.57670,4564.00000,4818.00000,1014.00000,254.00000,5071.4,'',0,'volume',0,0,70.75475,0),(31,23,4,4734.53391,4564.00000,4818.00000,1014.00000,254.00000,5071.4,'0',0,'volume',0,0,111.04454,0),(32,29,0,3542.57920,4564.00000,4818.00000,1014.00000,254.00000,5071.4,'',0,'volume',0,0,82.95155,0),(33,48,4,3824.32158,4564.00000,4818.00000,1014.00000,254.00000,5071.4,'0',0,'volume',0,0,88.85296,0),(34,10,0,4473.97148,4564.00000,4818.00000,1014.00000,254.00000,5071.4,'',0,'volume',0,0,103.85763,0),(35,23,0,3911.86362,4564.00000,4818.00000,1014.00000,254.00000,5071.4,'',0,'volume',0,0,90.73960,0),(36,26,0,4617.01692,4564.00000,4818.00000,1014.00000,254.00000,5071.4,'',0,'volume',0,0,107.65841,0),(37,23,0,4446.24217,4564.00000,4818.00000,1014.00000,254.00000,5071.4,'',0,'volume',0,0,103.15152,0),(38,31,0,895.17223,4564.00000,4818.00000,1014.00000,254.00000,5071.4,'',0,'volume',0,0,29.29361,0),(39,21,4,0.00000,4564.00000,4818.00000,1014.00000,254.00000,5071.4,'0',0,'volume',0,0,0.00000,0),(40,49,4,0.00000,4564.00000,4818.00000,1014.00000,254.00000,5071.4,'0',0,'volume',0,0,0.00000,0),(41,4,4,209.49011,4564.00000,4818.00000,1014.00000,254.00000,5071.4,'0',0,'volume',0,0,10.76433,0),(42,31,0,4610.86642,4564.00000,4818.00000,1014.00000,254.00000,5071.4,'',0,'volume',0,0,107.48867,0),(43,1,4,2151.87475,4564.00000,4818.00000,1014.00000,254.00000,5071.4,'0',0,'volume',0,0,55.47119,0),(44,26,0,4861.06845,4564.00000,4818.00000,1014.00000,254.00000,5071.4,'',0,'volume',0,0,115.11756,0);
/*!40000 ALTER TABLE `t_tank_software` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_tank_station_map`
--

DROP TABLE IF EXISTS `t_tank_station_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_tank_station_map` (
                                      `f_station_map_id` int NOT NULL AUTO_INCREMENT,
                                      `f_tank_id` int NOT NULL,
                                      `f_station_id` int NOT NULL,
                                      PRIMARY KEY (`f_station_map_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_tank_station_map`
--

LOCK TABLES `t_tank_station_map` WRITE;
/*!40000 ALTER TABLE `t_tank_station_map` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_tank_station_map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_time_zone`
--

DROP TABLE IF EXISTS `t_time_zone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_time_zone` (
                               `f_zone_id` int NOT NULL AUTO_INCREMENT,
                               `f_utc_zone` varchar(11) NOT NULL,
                               `f_time_zone` varchar(200) NOT NULL,
                               `t_timezone_val` varchar(10) NOT NULL,
                               `f_time` varchar(20) NOT NULL,
                               `f_date_format` varchar(10) NOT NULL,
                               `f_region` varchar(60) NOT NULL,
                               PRIMARY KEY (`f_zone_id`)
) ENGINE=InnoDB AUTO_INCREMENT=113 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_time_zone`
--

LOCK TABLES `t_time_zone` WRITE;
/*!40000 ALTER TABLE `t_time_zone` DISABLE KEYS */;
INSERT INTO `t_time_zone` VALUES (1,'UM11','(GMT-11:00) Midway Island','-11.0','11:00','d/m/Y','Pacific/Midway'),(2,'UM11','(GMT-11:00) Samoa','-11.0','11:00','m/d/Y','Pacific/Pago_Pago'),(3,'UM10','(GMT-10:00) Hawaii','-10.0','10:00','m/d/Y','Pacific/Honolulu'),(4,'UM9','(GMT-09:00) Alaska','-9.0','09:00','m/d/Y','America/Anchorage'),(5,'UM8','(GMT-08:00) Pacific Time (US &amp; Canada)','-8.0','08:00','m/d/Y','America/Los_Angeles'),(6,'UM8','(GMT-08:00) Tijuana','-8.0','08:00','m/d/Y','America/Tijuana'),(7,'UM7','(GMT-07:00) Arizona','-7.0','07:00','m/d/Y','America/Phoenix'),(8,'UM7','(GMT-07:00) Mountain Time (US &amp; Canada)','-7.0','07:00','m/d/Y','America/Denver'),(9,'UM7','(GMT-07:00) Chihuahua','-7.0','07:00','m/d/Y','America/Chihuahua'),(10,'UM7','(GMT-07:00) Mazatlan','-7.0','07:00','m/d/Y','America/Mazatlan'),(11,'UM6','(GMT-06:00) Mexico City','-6.0','06:00','m/d/Y','America/Mexico_City'),(12,'UM6','(GMT-06:00) Monterrey','-6.0','06:00','m/d/Y','America/Monterrey'),(13,'UM6','(GMT-06:00) Saskatchewan','-6.0','06:00','d/m/Y','America/Regina'),(14,'UM6','(GMT-06:00) Central Time (US &amp; Canada)','-6.0','06:00','m/d/Y','America/Chicago'),(15,'UM5','(GMT-05:00) Eastern Time (US &amp; Canada)','-5.0','05:00','m/d/Y','America/New_York'),(16,'UM5','(GMT-05:00) Indiana (East)','-5.0','05:00','m/d/Y','America/Indiana/Indianapolis'),(17,'UM5','(GMT-05:00) Bogota','-5.0','05:00','m/d/Y','America/Bogota'),(18,'UM5','(GMT-05:00) Lima','-5.0','05:00','m/d/Y','America/Lima'),(19,'UM45','(GMT-04:30) Caracas','-4.5','04:30','m/d/Y','America/Caracas'),(20,'UM4','(GMT-04:00) Atlantic Time (Canada)','-4.0','04:00','d/m/Y','America/Halifax'),(21,'UM4','(GMT-04:00) La Paz','-4.0','04:00','m/d/Y','America/La_Paz'),(22,'UM4','(GMT-04:00) Santiago','-4.0','04:00','m/d/Y','America/Santiago'),(23,'UM35','(GMT-03:30) Newfoundland','-3.5','03:30','d/m/Y','America/St_Johns'),(24,'UM3','(GMT-03:00) Buenos Aires','-3.0','03:00','m/d/Y','America/Buenos_Aires'),(25,'UM3','(GMT-03:00) Greenland','-3.0','03:00','d/m/Y','America/Godthab'),(26,'UM2','(GMT-02:00) Stanley','-2.0','02:00','d/m/Y','Atlantic/Stanley'),(27,'UM1','(GMT-01:00) Azores','-1.0','01:00','d/m/Y','Atlantic/Azores'),(28,'UM1','(GMT-01:00) Cape Verde Is.','-1.0','01:00','d/m/Y','Atlantic/Cape_Verde'),(29,'UTC','(GMT) Casablanca','+0.0','','d/m/Y','Africa/Casablanca'),(30,'UTC','(GMT) Dublin','+0.0','','d/m/Y','Europe/Dublin'),(31,'UTC','(GMT) Lisbon','+0.0','','d/m/Y','Europe/Lisbon'),(32,'UTC','(GMT) London','+0.0','','d/m/Y','Europe/London'),(33,'UTC','(GMT) Monrovia','+0.0','','d/m/Y','Africa/Monrovia'),(34,'UP1','(GMT+01:00) Amsterdam','+1.0','01:00','d/m/Y','Europe/Amsterdam'),(35,'UP1','(GMT+01:00) Belgrade','+1.0','01:00','d/m/Y','Europe/Belgrade'),(36,'UP1','(GMT+01:00) Berlin','+1.0','01:00','d/m/Y','Europe/Berlin'),(37,'UP1','(GMT+01:00) Bratislava','+1.0','01:00','d/m/Y','Europe/Bratislava'),(38,'UP1','(GMT+01:00) Brussels','+1.0','01:00','d/m/Y','Europe/Brussels'),(39,'UP1','(GMT+01:00) Budapest','+1.0','01:00','d/m/Y','Europe/Budapest'),(40,'UP1','(GMT+01:00) Copenhagen','+1.0','01:00','d/m/Y','Europe/Copenhagen'),(41,'UP1','(GMT+01:00) Ljubljana','+1.0','01:00','d/m/Y','Europe/Ljubljana'),(42,'UP1','(GMT+01:00) Madrid','+1.0','01:00','d/m/Y','Europe/Madrid'),(43,'UP1','(GMT+01:00) Paris','+1.0','01:00','d/m/Y','Europe/Paris'),(44,'UP1','(GMT+01:00) Prague','+1.0','01:00','d/m/Y','Europe/Prague'),(45,'UP1','(GMT+01:00) Rome','+1.0','01:00','d/m/Y','Europe/Rome'),(46,'UP1','(GMT+01:00) Sarajevo','+1.0','01:00','d/m/Y','Europe/Sarajevo'),(47,'UP1','(GMT+01:00) Skopje','+1.0','01:00','d/m/Y','Europe/Skopje'),(48,'UP1','(GMT+01:00) Stockholm','+1.0','01:00','d/m/Y','Europe/Stockholm'),(49,'UP1','(GMT+01:00) Vienna','+1.0','01:00','d/m/Y','Europe/Vienna'),(50,'UP1','(GMT+01:00) Warsaw','+1.0','01:00','d/m/Y','Europe/Warsaw'),(51,'UP1','(GMT+01:00) Zagreb','+1.0','01:00','d/m/Y','Europe/Zagreb'),(52,'UP2','(GMT+02:00) Athens','+2.0','02:00','d/m/Y','Europe/Athens'),(53,'UP2','(GMT+02:00) Bucharest','+2.0','02:00','d/m/Y','Europe/Bucharest'),(54,'UP2','(GMT+02:00) Cairo','+2.0','02:00','d/m/Y','Africa/Cairo'),(55,'UP2','(GMT+02:00) Harare','+2.0','02:00','d/m/Y','Africa/Harare'),(56,'UP2','(GMT+02:00) Helsinki','+2.0','02:00','d/m/Y','Europe/Helsinki'),(57,'UP2','(GMT+02:00) Istanbul','+2.0','02:00','d/m/Y','Europe/Istanbul'),(58,'UP2','(GMT+02:00) Jerusalem','+2.0','02:00','d/m/Y','Asia/Jerusalem'),(59,'UP2','(GMT+02:00) Kyiv','+2.0','02:00','d/m/Y','Europe/Kiev'),(60,'UP2','(GMT+02:00) Minsk','+2.0','02:00','d/m/Y','Europe/Minsk'),(61,'UP2','(GMT+02:00) Riga','+2.0','02:00','d/m/Y','Europe/Riga'),(62,'UP2','(GMT+02:00) Sofia','+2.0','02:00','d/m/Y','Europe/Sofia'),(63,'UP2','(GMT+02:00) Tallinn','+2.0','02:00','d/m/Y','Europe/Tallinn'),(64,'UP2','(GMT+02:00) Vilnius','+2.0','02:00','d/m/Y','Europe/Vilnius'),(65,'UP3','(GMT+03:00) Baghdad','+3.0','03:00','d/m/Y','Asia/Baghdad'),(66,'UP3','(GMT+03:00) Kuwait','+3.0','03:00','d/m/Y','Asia/Kuwait'),(67,'UP3','(GMT+03:00) Nairobi','+3.0','03:00','d/m/Y','Africa/Nairobi'),(68,'UP3','(GMT+03:00) Riyadh','+3.0','03:00','d/m/Y','Asia/Riyadh'),(69,'UP35','(GMT+03:30) Tehran','+3.5','03:30','d/m/Y','Asia/Tehran'),(70,'UP4','(GMT+04:00) Moscow','+4.0','04:00','d/m/Y','Europe/Moscow'),(71,'UP4','(GMT+04:00) Baku','+4.0','04:00','d/m/Y','Asia/Baku'),(72,'UP4','(GMT+04:00) Volgograd','+4.0','04:00','d/m/Y','Europe/Volgograd'),(73,'UP4','(GMT+04:00) Muscat','+4.0','04:00','d/m/Y','Asia/Muscat'),(74,'UP4','(GMT+04:00) Tbilisi','+4.0','04:00','d/m/Y','Asia/Tbilisi'),(75,'UP4','(GMT+04:00) Yerevan','+4.0','04:00','d/m/Y','Asia/Yerevan'),(76,'UP45','(GMT+04:30) Kabul','+4.5','04:30','d/m/Y','Asia/Kabul'),(77,'UP5','(GMT+05:00) Karachi','+5.0','05:00','d/m/Y','Asia/Karachi'),(78,'UP5','(GMT+05:00) Tashkent','+5.0','05:00','d/m/Y','Asia/Tashkent'),(79,'UP55','(GMT+05:30) Kolkata','+5.5','05:30','d/m/Y','Asia/Kolkata'),(80,'UP575','(GMT+05:45) Kathmandu','+5.75','05:45','d/m/Y','Asia/Kathmandu'),(81,'UP6','(GMT+06:00) Ekaterinburg','+6.0','06:00','d/m/Y','Asia/Yekaterinburg'),(82,'UP6','(GMT+06:00) Almaty','+6.0','06:00','d/m/Y','Asia/Almaty'),(83,'UP6','(GMT+06:00) Dhaka','+6.0','06:00','d/m/Y','Asia/Dhaka'),(84,'UP7','(GMT+07:00) Novosibirsk','+7.0','07:00','d/m/Y','Asia/Novosibirsk'),(85,'UP7','(GMT+07:00) Bangkok','+7.0','07:00','d/m/Y','Asia/Bangkok'),(86,'UP7','(GMT+07:00) Jakarta','+7.0','07:00','d/m/Y','Asia/Jakarta'),(87,'UP8','(GMT+08:00) Krasnoyarsk','+8.0','08:00','d/m/Y','Asia/Krasnoyarsk'),(88,'UP8','(GMT+08:00) Chongqing','+8.0','08:00','d/m/Y','Asia/Shanghai'),(89,'UP8','(GMT+08:00) Hong Kong','+8.0','08:00','d/m/Y','Asia/Hong_Kong'),(90,'UP8','(GMT+08:00) Kuala Lumpur','+8.0','08:00','d/m/Y','Asia/Kuala_Lumpur'),(91,'UP8','(GMT+08:00) Perth','+8.0','08:00','d/m/Y','Australia/Perth'),(92,'UP8','(GMT+08:00) Singapore','+8.0','08:00','d/m/Y','Asia/Singapore'),(93,'UP8','(GMT+08:00) Taipei','+8.0','08:00','d/m/Y','Asia/Taipei'),(94,'UP8','(GMT+08:00) Ulaan Bataar','+8.0','08:00','d/m/Y','Asia/Ulaanbaatar'),(95,'UP8','(GMT+08:00) Urumqi','+8.0','08:00','d/m/Y','Asia/Urumqi'),(96,'UP9','(GMT+09:00) Irkutsk','+9.0','09:00','d/m/Y','Asia/Irkutsk'),(97,'UP9','(GMT+09:00) Seoul','+9.0','09:00','d/m/Y','Asia/Seoul'),(98,'UP9','(GMT+09:00) Tokyo','+9.0','09:00','d/m/Y','Asia/Tokyo'),(99,'UP95','(GMT+09:30) Adelaide','+9.5','09:30','d/m/Y','Australia/Adelaide'),(100,'UP95','(GMT+09:30) Darwin','+9.5','09:30','d/m/Y','Australia/Darwin'),(101,'UP10','(GMT+10:00) Yakutsk','+10.0','10:00','d/m/Y','Asia/Yakutsk'),(102,'UP10','(GMT+10:00) Brisbane','+10.0','10:00','d/m/Y','Australia/Brisbane'),(103,'UP10','(GMT+10:00) Canberra','+10.0','10:00','d/m/Y','Australia/Sydney'),(104,'UP10','(GMT+10:00) Guam','+10.0','10:00','d/m/Y','Pacific/Guam'),(105,'UP10','(GMT+10:00) Hobart','+10.0','10:00','d/m/Y','Australia/Hobart'),(106,'UP10','(GMT+10:00) Melbourne','+10.0','10:00','d/m/Y','Australia/Melbourne'),(107,'UP10','(GMT+10:00) Port Moresby','+10.0','10:00','d/m/Y','Pacific/Port_Moresby'),(108,'UP10','(GMT+10:00) Sydney','+10.0','10:00','d/m/Y','Australia/Sydney'),(109,'UP11','(GMT+11:00) Vladivostok','+11.0','11:00','d/m/Y','Asia/Vladivostok'),(110,'UP12','(GMT+12:00) Magadan','+12.0','12:00','d/m/Y','Asia/Magadan'),(111,'UP12','(GMT+12:00) Auckland','+12.0','12:00','d/m/Y','Pacific/Auckland'),(112,'UP12','(GMT+12:00) Fiji','+12.0','12:00','d/m/Y','Pacific/Fiji');
/*!40000 ALTER TABLE `t_time_zone` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_timeout_configuration`
--

DROP TABLE IF EXISTS `t_timeout_configuration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_timeout_configuration` (
                                           `f_timeout_configuration_id` int NOT NULL AUTO_INCREMENT,
                                           `f_timeout_condition` varchar(30) NOT NULL,
                                           `f_timeout_minutes` int NOT NULL,
                                           `f_timeout_specific_seconds` int NOT NULL,
                                           `f_timeout_seconds` varchar(111) NOT NULL,
                                           `f_timeout_compulsory` varchar(11) NOT NULL,
                                           PRIMARY KEY (`f_timeout_configuration_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_timeout_configuration`
--

LOCK TABLES `t_timeout_configuration` WRITE;
/*!40000 ALTER TABLE `t_timeout_configuration` DISABLE KEYS */;
INSERT INTO `t_timeout_configuration` VALUES (1,'Dispense Page',5,0,'300','0'),(2,'Pre Dispense',5,0,'300','0'),(3,'Dispense Complete',5,0,'300','0'),(4,'Top-Off',5,0,'300','0'),(5,'Session',5,0,'300','0'),(6,'Tank Monitor',5,0,'300','0'),(7,'Delivery Acknowledgment',5,0,'300','0');
/*!40000 ALTER TABLE `t_timeout_configuration` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_transceiver_server`
--

DROP TABLE IF EXISTS `t_transceiver_server`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_transceiver_server` (
                                        `f_id` int NOT NULL AUTO_INCREMENT,
                                        `f_bit0` varchar(12) NOT NULL,
                                        `f_bit1` varchar(12) NOT NULL,
                                        `f_bit2` varchar(12) NOT NULL,
                                        `f_bit3` varchar(12) NOT NULL,
                                        `f_bit4` varchar(12) NOT NULL,
                                        `f_bit5` float(12,1) NOT NULL,
  `f_bit6` varchar(12) NOT NULL,
  `f_bit7` varchar(12) NOT NULL,
  `f_bit8` varchar(12) NOT NULL,
  `f_bit9` varchar(12) NOT NULL,
  `f_bit10` varchar(12) NOT NULL,
  `f_bit11` varchar(12) NOT NULL,
  `f_bit12` varchar(12) NOT NULL,
  `f_bit13` varchar(12) NOT NULL,
  `f_bit14` varchar(12) NOT NULL,
  `f_bit15` varchar(12) NOT NULL,
  `f_bit16` varchar(12) NOT NULL,
  PRIMARY KEY (`f_id`),
  KEY `f_bit2` (`f_bit2`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_transceiver_server`
--

LOCK TABLES `t_transceiver_server` WRITE;
/*!40000 ALTER TABLE `t_transceiver_server` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_transceiver_server` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_transceiver_server_past_cmd`
--

DROP TABLE IF EXISTS `t_transceiver_server_past_cmd`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_transceiver_server_past_cmd` (
                                                 `f_id` int NOT NULL AUTO_INCREMENT,
                                                 `f_bit0` varchar(12) NOT NULL,
                                                 `f_bit1` varchar(12) NOT NULL,
                                                 `f_bit2` varchar(12) NOT NULL,
                                                 `f_bit3` varchar(12) NOT NULL,
                                                 `f_bit4` varchar(12) NOT NULL,
                                                 `f_bit5` float(12,1) NOT NULL,
  `f_bit6` varchar(12) NOT NULL,
  `f_bit7` varchar(12) NOT NULL,
  `f_bit8` varchar(12) NOT NULL,
  `f_bit9` varchar(12) NOT NULL,
  `f_bit10` varchar(12) NOT NULL,
  `f_bit11` varchar(12) NOT NULL,
  `f_bit12` varchar(12) NOT NULL,
  `f_bit13` varchar(12) NOT NULL,
  `f_bit14` varchar(12) NOT NULL,
  `f_bit15` varchar(12) NOT NULL,
  `f_bit16` varchar(12) NOT NULL,
  `insert_date_time` datetime NOT NULL,
  PRIMARY KEY (`f_id`),
  KEY `f_bit2` (`f_bit2`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_transceiver_server_past_cmd`
--

LOCK TABLES `t_transceiver_server_past_cmd` WRITE;
/*!40000 ALTER TABLE `t_transceiver_server_past_cmd` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_transceiver_server_past_cmd` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_trigger_details`
--

DROP TABLE IF EXISTS `t_trigger_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_trigger_details` (
                                     `f_subtrigger_id` int NOT NULL AUTO_INCREMENT COMMENT 'Auto incrementing number identifying uniquely identifying each record',
                                     `f_trigger_id` int NOT NULL COMMENT 'This is the pk for the record in t_relay_triggers.f_trigger_id identifying the parent record in the relationship with this child record',
                                     `f_subtype_id` int NOT NULL,
                                     PRIMARY KEY (`f_subtrigger_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_trigger_details`
--

LOCK TABLES `t_trigger_details` WRITE;
/*!40000 ALTER TABLE `t_trigger_details` DISABLE KEYS */;
INSERT INTO `t_trigger_details` VALUES (1,1,1),(2,1,4),(3,2,6),(4,3,1),(5,3,4);
/*!40000 ALTER TABLE `t_trigger_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_trigger_types`
--

DROP TABLE IF EXISTS `t_trigger_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_trigger_types` (
                                   `f_trigger_id` int NOT NULL COMMENT 'This field holds the records unique identifiable value.',
                                   `f_trigger_name` varchar(50) NOT NULL COMMENT 'This field holds the user friendly text description',
                                   `f_date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'This field holds the date the record was created',
                                   PRIMARY KEY (`f_trigger_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_trigger_types`
--

LOCK TABLES `t_trigger_types` WRITE;
/*!40000 ALTER TABLE `t_trigger_types` DISABLE KEYS */;
INSERT INTO `t_trigger_types` VALUES (1,'Product/Reel','2023-12-03 19:11:32'),(2,'Tank Levels','2023-12-03 19:11:54'),(3,'Shifts','2023-12-03 19:12:11'),(4,'Tank Relays','2023-12-03 19:12:33');
/*!40000 ALTER TABLE `t_trigger_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_units`
--

DROP TABLE IF EXISTS `t_units`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_units` (
                           `f_units_id` int NOT NULL AUTO_INCREMENT,
                           `f_units_name` varchar(30) NOT NULL,
                           PRIMARY KEY (`f_units_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_units`
--

LOCK TABLES `t_units` WRITE;
/*!40000 ALTER TABLE `t_units` DISABLE KEYS */;
INSERT INTO `t_units` VALUES (1,'Quarts'),(2,'Liters'),(3,'Pints'),(4,'Gallons');
/*!40000 ALTER TABLE `t_units` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_user_capabilities_map`
--

DROP TABLE IF EXISTS `t_user_capabilities_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_user_capabilities_map` (
                                           `id` int NOT NULL AUTO_INCREMENT,
                                           `f_user_id` int NOT NULL,
                                           `f_capabilities_id` varchar(64) NOT NULL,
                                           PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_user_capabilities_map`
--

LOCK TABLES `t_user_capabilities_map` WRITE;
/*!40000 ALTER TABLE `t_user_capabilities_map` DISABLE KEYS */;
INSERT INTO `t_user_capabilities_map` VALUES (1,1,'1,2,3,4,5,6,7'),(2,2,'1,2,3,4,5,6,7'),(3,3,'1,2,3,4,5,6,7'),(30,31,'4,6,5,2,1,3');
/*!40000 ALTER TABLE `t_user_capabilities_map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_user_email_map`
--

DROP TABLE IF EXISTS `t_user_email_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_user_email_map` (
                                    `f_user_email_map_id` int NOT NULL AUTO_INCREMENT,
                                    `f_user_email` int NOT NULL,
                                    `e1` varchar(20) NOT NULL,
                                    `e2` varchar(20) NOT NULL,
                                    `e3` varchar(20) NOT NULL,
                                    `e4` varchar(20) NOT NULL,
                                    `e5` varchar(20) NOT NULL,
                                    `e6` varchar(20) NOT NULL,
                                    `e7` varchar(20) NOT NULL,
                                    `e8` varchar(20) NOT NULL,
                                    `e9` varchar(20) NOT NULL,
                                    `e10` varchar(20) NOT NULL,
                                    `e11` varchar(20) NOT NULL,
                                    `status` int NOT NULL,
                                    `f_created_by` int NOT NULL,
                                    PRIMARY KEY (`f_user_email_map_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_user_email_map`
--

LOCK TABLES `t_user_email_map` WRITE;
/*!40000 ALTER TABLE `t_user_email_map` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_user_email_map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_user_email_schedule`
--

DROP TABLE IF EXISTS `t_user_email_schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_user_email_schedule` (
                                         `f_schedule_id` int NOT NULL AUTO_INCREMENT,
                                         `f_event_id` int NOT NULL,
                                         `f_user_id` int NOT NULL,
                                         `f_day` varchar(44) NOT NULL,
                                         `f_hours` int NOT NULL,
                                         `f_minutes` int NOT NULL,
                                         PRIMARY KEY (`f_schedule_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_user_email_schedule`
--

LOCK TABLES `t_user_email_schedule` WRITE;
/*!40000 ALTER TABLE `t_user_email_schedule` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_user_email_schedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_user_job_map`
--

DROP TABLE IF EXISTS `t_user_job_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_user_job_map` (
                                  `f_id` int NOT NULL AUTO_INCREMENT,
                                  `f_user_id` int NOT NULL,
                                  `f_job_id` int NOT NULL,
                                  `f_emergency_stop` int NOT NULL,
                                  PRIMARY KEY (`f_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_user_job_map`
--

LOCK TABLES `t_user_job_map` WRITE;
/*!40000 ALTER TABLE `t_user_job_map` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_user_job_map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_user_role_map`
--

DROP TABLE IF EXISTS `t_user_role_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_user_role_map` (
                                   `id` int NOT NULL AUTO_INCREMENT,
                                   `f_user_id` int NOT NULL,
                                   `f_role_id` int NOT NULL,
                                   PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_user_role_map`
--

LOCK TABLES `t_user_role_map` WRITE;
/*!40000 ALTER TABLE `t_user_role_map` DISABLE KEYS */;
INSERT INTO `t_user_role_map` VALUES (1,1,1),(2,2,1),(3,3,1),(4,4,4),(31,31,1);
/*!40000 ALTER TABLE `t_user_role_map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_user_shift_map`
--

DROP TABLE IF EXISTS `t_user_shift_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_user_shift_map` (
                                    `f_id` int NOT NULL AUTO_INCREMENT,
                                    `f_user_id` int NOT NULL,
                                    `D_f_user_compulsory` int NOT NULL,
                                    `f_shift_id` int NOT NULL,
                                    PRIMARY KEY (`f_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_user_shift_map`
--

LOCK TABLES `t_user_shift_map` WRITE;
/*!40000 ALTER TABLE `t_user_shift_map` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_user_shift_map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_user_station_map`
--

DROP TABLE IF EXISTS `t_user_station_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_user_station_map` (
                                      `id` int NOT NULL AUTO_INCREMENT,
                                      `f_user_id` int NOT NULL,
                                      `f_station_id` varchar(11) NOT NULL,
                                      PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_user_station_map`
--

LOCK TABLES `t_user_station_map` WRITE;
/*!40000 ALTER TABLE `t_user_station_map` DISABLE KEYS */;
INSERT INTO `t_user_station_map` VALUES (1,31,'2'),(2,31,'1');
/*!40000 ALTER TABLE `t_user_station_map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_users_details`
--

DROP TABLE IF EXISTS `t_users_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_users_details` (
                                   `f_user_id` int unsigned NOT NULL AUTO_INCREMENT,
                                   `f_first_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
                                   `f_last_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
                                   `f_user_email` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
                                   `f_user_pin` int NOT NULL,
                                   `f_password` varchar(255) DEFAULT NULL,
                                   `f_user_enabled` tinyint(1) NOT NULL,
                                   `f_company_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
                                   `f_department_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
                                   `f_last_login` datetime DEFAULT NULL,
                                   `f_lockout_until` datetime DEFAULT NULL,
                                   `f_status` int NOT NULL,
                                   `f_emergency_stop` tinyint(1) NOT NULL COMMENT 'DEPRECATE',
                                   `f_calibrate` tinyint(1) NOT NULL COMMENT 'DEPRECATE',
                                   `f_kfactor` tinyint(1) NOT NULL COMMENT 'DEPRECATE',
                                   `f_default` int NOT NULL DEFAULT '0' COMMENT 'DEPRECATE',
                                   `f_agrmt_accept` tinyint(1) NOT NULL DEFAULT '0',
                                   `f_agrmt_email_copy` varchar(100) DEFAULT NULL COMMENT 'DEPRECATE',
                                   `f_agrmt_downloaded` tinyint(1) DEFAULT '0' COMMENT 'DEPRECATE',
                                   `f_last_logout` datetime DEFAULT NULL COMMENT 'DEPRECATE',
                                   `f_locked_until` datetime DEFAULT NULL COMMENT 'DEPRECATE',
                                   `f_failed_login_count` int unsigned DEFAULT '0' COMMENT 'DEPRECATE',
                                   `f_failed_login_attempts` int DEFAULT NULL COMMENT 'DEPRECATE',
                                   `f_last_failed_login` datetime DEFAULT NULL COMMENT 'DEPRECATE',
                                   `f_created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                   `f_updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                   `f_updated_by` int NOT NULL DEFAULT '0',
                                   `f_last_updated` datetime NOT NULL,
                                   `f_created_by` int NOT NULL DEFAULT '0',
                                   `f_create_by` int NOT NULL,
                                   PRIMARY KEY (`f_user_id`),
                                   UNIQUE KEY `t_users_details_pk` (`f_user_email`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_users_details`
--

LOCK TABLES `t_users_details` WRITE;
/*!40000 ALTER TABLE `t_users_details` DISABLE KEYS */;
INSERT INTO `t_users_details` VALUES (1,'LQD','Admin','oilcop@liquidynamics.com',670022014,NULL,1,'LiquiDymanics, Inc','Engineering',NULL,NULL,1,1,0,0,1,1,'',0,NULL,NULL,0,NULL,NULL,'2025-09-01 17:08:18','2025-09-01 17:10:54',0,'0000-00-00 00:00:00',0,0),(2,'Admiral','Admin','admiral@liquidynamics.com',773841992,NULL,1,'Admiral','Support',NULL,NULL,1,1,0,0,1,1,'',0,NULL,NULL,0,NULL,NULL,'2025-09-01 17:08:18','2025-09-01 17:10:54',0,'0000-00-00 00:00:00',0,0),(3,'Gartec','Admin','gartec@liquidynamics.com',902101995,NULL,1,'Gartec, Srl','Support',NULL,NULL,1,1,0,0,1,1,'',0,NULL,NULL,0,NULL,NULL,'2025-09-01 17:08:18','2025-09-01 17:10:54',0,'0000-00-00 00:00:00',0,0),(4,'Installer','','oilcop1@liquidynamics.com',111222333,NULL,1,'LiquiDynamics Inc','Support',NULL,NULL,1,1,1,1,1,1,'',0,NULL,NULL,0,NULL,NULL,'2025-09-01 17:08:18','2025-09-01 17:10:54',0,'0000-00-00 00:00:00',0,0),(31,'Jim','Strong','xersist@gmail.com',123456,'$2y$12$MK0uxed3TuxbMI9PUwHTXuMOk3qJNlyGQjFgWyadVL4mrF/0Ch.fK',1,'','','2025-08-08 00:58:53',NULL,1,0,0,0,0,1,NULL,0,'2025-08-08 00:57:47',NULL,0,0,NULL,'2025-09-01 17:08:18','2025-09-01 17:10:54',0,'0000-00-00 00:00:00',0,1);
/*!40000 ALTER TABLE `t_users_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_workorder_details`
--

DROP TABLE IF EXISTS `t_workorder_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_workorder_details` (
                                       `f_wo_id` int NOT NULL AUTO_INCREMENT,
                                       `f_workorder_id` int NOT NULL,
                                       `f_user_id` int NOT NULL,
                                       `f_station_id` int NOT NULL,
                                       `f_job_id` int NOT NULL,
                                       `f_product_id` int NOT NULL,
                                       `f_configured_units_id` int NOT NULL COMMENT 'This field stores the unit that are selected on the Work Order maintenance screen',
                                       `f_units_id` int NOT NULL COMMENT 'This field stores the unit that the psm is set for.',
                                       `f_reel_id` int NOT NULL,
                                       `f_configured_preset_amount` float(12,1) NOT NULL COMMENT 'This field stores the preset set by on the work order maintenance screen',
  `f_preset_amount` float(12,1) NOT NULL COMMENT 'This is the preset value set by the tech on the tech dispense screen',
  `f_dispense_topoff` int NOT NULL,
  `is_sync` int NOT NULL,
  `f_dis_woinv` int NOT NULL,
  PRIMARY KEY (`f_wo_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_workorder_details`
--

LOCK TABLES `t_workorder_details` WRITE;
/*!40000 ALTER TABLE `t_workorder_details` DISABLE KEYS */;
INSERT INTO `t_workorder_details` VALUES (1,1,0,0,0,0,1,4,1,0.0,0.0,0,0,0);
/*!40000 ALTER TABLE `t_workorder_details` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-09-03 21:36:58
