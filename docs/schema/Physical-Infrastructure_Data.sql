-- Device Types
INSERT INTO device_types (type_code, type_name, description) VALUES
                                                                 ('CDM', 'Controller/Dispenser Module', 'Main controller for dispensing units'),
                                                                 ('PSM', 'Pump/Solenoid Module', 'Pump and solenoid control module'),
                                                                 ('TMM', 'Tank Monitor Module', 'Tank level monitoring module'),
                                                                 ('RPSM', 'Remote Pump/Solenoid Module', 'Remote pump/solenoid module');

-- Stations
INSERT INTO stations (station_name, location_description, display_priority) VALUES
                                                                                ('Service Bay 1', 'Main service area, north side', 1),
                                                                                ('Service Bay 2', 'Main service area, south side', 2),
                                                                                ('Quick Lube Bay', 'Express service area', 3),
                                                                                ('Parts Department', 'Parts counter dispensing station', 4);

-- Products
INSERT INTO products (customer_product_id, product_name, description, specific_gravity, default_unit_id, max_preset_amount, max_open_amount) VALUES
                                                                                                                                                 ('226606', '1000 THF', 'Transmission Fluid', 0.8740, 1, 100.00, 100.00),
                                                                                                                                                 ('273270', 'URSA HYD 10 WT', 'Hydraulic Oil', 0.8100, 1, 100.00, 100.00),
                                                                                                                                                 ('221880', 'TRACTOR FLUID', 'Tractor Hydraulic Fluid', 0.8710, 1, 100.00, 100.00),
                                                                                                                                                 ('255637', 'HYD OIL AW 68', 'Hydraulic Oil AW 68', 0.8691, 1, 100.00, 100.00),
                                                                                                                                                 ('254645', 'HAV HM S/B 5W30', 'Engine Oil 5W-30', 0.8600, 1, 100.00, 100.00),
                                                                                                                                                 ('224118', 'SUPREME 10W30', 'Engine Oil 10W-30', 0.8600, 1, 100.00, 100.00),
                                                                                                                                                 ('CWPRODUCT', '0W/20', 'Synthetic Engine Oil 0W-20', 0.8800, 1, 100.00, 100.00),
                                                                                                                                                 ('H2O', 'Water', 'Deionized Water', 1.0000, 1, 100.00, 100.00);

-- Tanks
INSERT INTO tanks (tank_name, product_id, station_id, tank_shape, height, diameter, capacity, current_volume, high_level_alarm, high_level_warning, reorder_level, shutoff_level) VALUES
                                                                                                                                                                                      ('Engine Oil 5W-30', 5, 1, 'round_vertical', 72.00, 64.00, 1002.19, 767.18, 902.00, 952.00, 200.00, 50.00),
                                                                                                                                                                                      ('Transmission Fluid', 1, 1, 'round_vertical', 72.00, 64.00, 1002.19, 224.82, 902.00, 952.00, 200.00, 50.00),
                                                                                                                                                                                      ('Engine Oil 0W-20', 7, 2, 'round_vertical', 72.00, 64.00, 1002.19, 48.70, 902.00, 952.00, 200.00, 50.00),
                                                                                                                                                                                      ('Hydraulic Oil', 2, 2, 'round_vertical', 72.00, 64.00, 1002.19, 57.78, 902.00, 952.00, 200.00, 50.00),
                                                                                                                                                                                      ('Water', 8, 3, 'round_vertical', 72.00, 64.00, 1002.19, 51.96, 902.00, 952.00, 200.00, 50.00),
                                                                                                                                                                                      ('Tractor Fluid', 3, 4, 'round_vertical', 72.00, 64.00, 1002.19, 43.65, 902.00, 952.00, 200.00, 50.00);

-- Tank-Station Mapping (Some tanks serve multiple stations)
INSERT INTO tank_station_map (tank_id, station_id) VALUES
                                                       (1, 1), (1, 2), -- Engine Oil 5W-30 in both service bays
                                                       (2, 1),
                                                       (3, 2),
                                                       (4, 2),
                                                       (5, 3),
                                                       (6, 4);

-- Reels
INSERT INTO reels (reel_name, station_id, tank_id, k_factor) VALUES
                                                                 ('Bay 1 - Primary', 1, 1, 1.000000000000),
                                                                 ('Bay 1 - Secondary', 1, 2, 1.000000000000),
                                                                 ('Bay 2 - Primary', 2, 3, 1.000000000000),
                                                                 ('Bay 2 - Secondary', 2, 4, 1.000000000000),
                                                                 ('Quick Lube - Water', 3, 5, 1.000000000000),
                                                                 ('Parts - Tractor Fluid', 4, 6, 1.000000000000);

-- Devices
INSERT INTO devices (device_type_id, serial_number, name, ip_address, port_number, is_configured, is_online) VALUES
                                                                                                                 (1, 'CDM0823041', 'Bay 1 Controller', '192.168.5.10', '1200', TRUE, TRUE),
                                                                                                                 (1, 'CDM0823055', 'Bay 2 Controller', '192.168.5.11', '1201', TRUE, TRUE),
                                                                                                                 (2, 'PSM0823066', 'Bay 1 Pump', NULL, NULL, TRUE, TRUE),
                                                                                                                 (2, 'PSM0823065', 'Bay 2 Pump', NULL, NULL, TRUE, TRUE),
                                                                                                                 (3, 'TMM0823010', 'Bay 1 Tank Monitor', NULL, NULL, TRUE, TRUE),
                                                                                                                 (3, 'TMM0823012', 'Bay 2 Tank Monitor', NULL, NULL, TRUE, TRUE);

-- Set parent relationships (PSM and TMM devices belong to CDMs)
UPDATE devices SET parent_device_id = 1 WHERE device_id IN (3, 5);
UPDATE devices SET parent_device_id = 2 WHERE device_id IN (4, 6);

-- Sensors
INSERT INTO sensors (tank_id, device_id, port_number, sensor_type, cable_length) VALUES
                                                                                     (1, 5, 1, 'probe_6ft', 6.00),
                                                                                     (2, 5, 2, 'probe_6ft', 6.00),
                                                                                     (3, 6, 1, 'probe_6ft', 6.00),
                                                                                     (4, 6, 2, 'probe_6ft', 6.00),
                                                                                     (5, 6, 3, 'probe_6ft', 6.00),
                                                                                     (6, 6, 4, 'probe_6ft', 6.00);