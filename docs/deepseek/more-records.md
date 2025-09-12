Absolutely! Having robust example data is crucial for frontend development and testing. Let's populate all the tables with realistic data for a fictional dealership service center.

### 1. Populate Core Tables

```sql
-- Insert Manufacturers
INSERT INTO manufacturers (name, contact_info) VALUES
('Mobil', '1-800-ASK-MOBIL'),
('Valvoline', '1-800-TEAM-VAL'),
('Castrol', '1-888-CASTROL'),
('Lucas Oil', '1-800-342-2512'),
('Shell', '1-888-GO-SHELL'),
('Chevron', '1-800-582-3835');

-- Insert Fluid Types
INSERT INTO fluid_types (type_name, description) VALUES
('Motor Oil', 'Engine lubricants for gasoline and diesel engines'),
('Transmission Fluid', 'Fluids for automatic and manual transmissions'),
('Grease', 'Lubricating grease for bearings, joints, and components'),
('Brake Fluid', 'Hydraulic fluid for brake systems'),
('Antifreeze/Coolant', 'Engine cooling and antifreeze solutions'),
('Windshield Washer Fluid', 'Fluid for cleaning windshields');

-- Insert Work Order Statuses
INSERT INTO work_order_statuses (status_name, is_active) VALUES
('Pending', TRUE),
('In Progress', TRUE),
('Completed', TRUE),
('On Hold', TRUE),
('Cancelled', FALSE);

-- Insert Transaction Types
INSERT INTO transaction_types (type_name) VALUES
('PURCHASE'),    -- Adding new inventory
('FILL'),        -- Filling a tank from bulk
('DISPENSE'),    -- Dispensing from tank/reel
('MANUAL_ADD'),  -- Manual addition to inventory
('ADJUST'),      -- Manual adjustment (correction)
('TRANSFER');    -- Transfer between tanks
```

### 2. Populate Products with Realistic Data

```sql
-- Insert Products (using the unit_id for 'quart', 'gallon', 'cartridge', etc.)
INSERT INTO products (name, description, manufacturer_id, manufacturer_part_number, fluid_type_id, viscosity_grade, specifications, unit_id, is_hazmat, cost_per_unit, min_stock_level) VALUES
-- Motor Oils
('Mobil 1 5W-30 Full Synthetic', 'Advanced full synthetic motor oil', 1, 'M1-110', 1, '5W-30', 'API SP, GM dexos1 Gen 3', (SELECT unit_id FROM units WHERE unit_abbreviation = 'qt'), FALSE, 8.99, 24.00),
('Valvoline 10W-40 Conventional', 'High-quality conventional motor oil', 2, 'VV-1040', 1, '10W-40', 'API SN', (SELECT unit_id FROM units WHERE unit_abbreviation = 'gal'), FALSE, 22.50, 4.00),
('Castrol EDGE 0W-20', 'Advanced synthetic motor oil', 3, 'CST-0W20', 1, '0W-20', 'API SP, Ford WSS-M2C947-A', (SELECT unit_id FROM units WHERE unit_abbreviation = 'qt'), FALSE, 9.25, 18.00),

-- Transmission Fluids
('Mobil ATF 3309', 'Automatic transmission fluid', 1, 'M-3309', 2, 'ATF', 'Toyota T-IV, JWS3309', (SELECT unit_id FROM units WHERE unit_abbreviation = 'qt'), TRUE, 12.75, 12.00),
('Valvoline MaxLife ATF', 'Full synthetic ATF', 2, 'VV-ATF', 2, 'ATF+4', 'Multi-vehicle formula', (SELECT unit_id FROM units WHERE unit_abbreviation = 'gal'), TRUE, 38.99, 2.00),

-- Greases
('Lucas Red N Tacky Grease', 'Premium lithium grease', 4, 'LUC-10304', 3, 'NLGI #2', 'Water resistant, high temp', (SELECT unit_id FROM units WHERE unit_abbreviation = 'cartridge'), FALSE, 3.50, 36.00),
('Mobilgrease XHP 222', 'High performance grease', 1, 'MG-222', 3, 'NLGI #2', 'Lithium complex, extreme pressure', (SELECT unit_id FROM units WHERE unit_abbreviation = 'cartridge'), FALSE, 4.25, 24.00),

-- Other Fluids
('Shell Zone Coolant', 'Extended life coolant', 5, 'SH-ZC1G', 5, '50/50', 'OAT technology', (SELECT unit_id FROM units WHERE unit_abbreviation = 'gal'), TRUE, 18.99, 4.00),
('Chevron DOT 4 Brake Fluid', 'High performance brake fluid', 6, 'CH-DOT4', 4, 'DOT 4', 'FMVSS 116, ISO 4925', (SELECT unit_id FROM units WHERE unit_abbreviation = 'qt'), TRUE, 15.50, 6.00);
```

### 3. Populate Asset Tables

```sql
-- Insert Tanks
INSERT INTO tanks (name, description, product_id, capacity, capacity_unit_id, current_volume, volume_display_unit_id, status_id, calibration_factor) VALUES
('Main Oil Tank - Bay 1', 'Primary 5W-30 storage for quick lube bay', 1, 100.0, (SELECT unit_id FROM units WHERE unit_abbreviation = 'gal'), 78.5, (SELECT unit_id FROM units WHERE unit_abbreviation = 'gal'), 1, 1.02),
('Synthetic Oil Tank - Bay 2', '0W-20 synthetic for import vehicles', 3, 50.0, (SELECT unit_id FROM units WHERE unit_abbreviation = 'gal'), 42.3, (SELECT unit_id FROM units WHERE unit_abbreviation = 'gal'), 1, 0.98),
('Grease Reservoir - Lube Bay', 'Central grease system for all bays', 6, 20.0, (SELECT unit_id FROM units WHERE unit_abbreviation = 'gal'), 15.2, (SELECT unit_id FROM units WHERE unit_abbreviation = 'gal'), 1, 1.01),
('ATF Bulk Tank', 'Bulk transmission fluid storage', 4, 150.0, (SELECT unit_id FROM units WHERE unit_abbreviation = 'gal'), 132.8, (SELECT unit_id FROM units WHERE unit_abbreviation = 'gal'), 1, 0.99);

-- Insert Reel Types
INSERT INTO reel_types (type_name, hose_length, max_flow_rate) VALUES
('Manual Oil Reel', 15.0, 1.5),
('Air-Powered Oil Reel', 20.0, 2.5),
('Manual Grease Reel', 12.0, 0.8),
('Electric Coolant Reel', 18.0, 1.2);

-- Insert Reels
INSERT INTO reels (name, reel_type_id, tank_id, asset_tag, status_id) VALUES
('Quick Lube Oil Reel #1', 1, 1, 'REEL-001', 1),
('Synthetic Oil Reel #2', 2, 2, 'REEL-002', 1),
('Main Grease Reel - Central', 3, 3, 'REEL-003', 1),
('ATF Dispensing Reel', 1, 4, 'REEL-004', 1);

-- Insert Sensor Types
INSERT INTO sensor_types (type_name, measurement_unit_id, description) VALUES
('Ultrasonic Level Sensor', (SELECT unit_id FROM units WHERE unit_abbreviation = 'in'), 'Non-contact level measurement'),
('Pressure Transducer', (SELECT unit_id FROM units WHERE unit_abbreviation = 'psi'), 'Hydrostatic pressure measurement'),
('Temperature Sensor', (SELECT unit_id FROM units WHERE unit_abbreviation = '°F'), 'Fluid temperature monitoring'),
('Load Cell', (SELECT unit_id FROM units WHERE unit_abbreviation = 'lb'), 'Weight-based measurement');

-- Insert Tank Sensors
INSERT INTO tank_sensors (tank_id, sensor_type_id, name, calibration_value) VALUES
(1, 1, 'Main Oil Tank - Ultrasonic', 0.5),
(1, 3, 'Main Oil Tank - Temperature', 0.0),
(2, 1, 'Synthetic Tank - Ultrasonic', -0.3),
(3, 2, 'Grease Tank - Pressure', 1.2),
(4, 1, 'ATF Tank - Ultrasonic', 0.8);
```

### 4. Populate Work Orders and Transactions

```sql
-- Insert Work Orders
INSERT INTO work_orders (external_id, description, status_id, created_at, completed_at) VALUES
('EXT-WO-1001', '2023 Toyota Camry - Oil Change & Rotation', 3, '2024-01-15 08:30:00', '2024-01-15 10:15:00'),
('EXT-WO-1002', '2018 Ford F-150 - Transmission Flush', 3, '2024-01-15 09:45:00', '2024-01-15 12:30:00'),
(NULL, 'Honda Civic - Grease Fittings Service', 2, '2024-01-16 10:00:00', NULL),
('EXT-WO-1004', 'Chevrolet Silverado - Coolant Flush', 1, '2024-01-16 11:30:00', NULL);

-- Insert Fluid Transactions
INSERT INTO fluid_transactions (transaction_type, product_id, tank_id, reel_id, work_order_id, quantity, volume_before, volume_after, source_or_destination, notes, user_id) VALUES
-- Dispenses for completed work orders
(3, 1, 1, 1, 1, 5.0, 80.5, 75.5, 'Work Order EXT-WO-1001', 'Oil change - 2023 Camry', 101),
(3, 4, 4, 4, 2, 12.0, 140.0, 128.0, 'Work Order EXT-WO-1002', 'Transmission flush - F-150', 102),
(3, 6, 3, 3, 3, 2.0, 16.0, 14.0, 'Work Order INT-003', 'Grease service - Civic', 103),

-- Tank fill operations
(2, 1, 1, NULL, NULL, 50.0, 75.5, 125.5, 'Bulk Delivery #4501', 'Weekly oil delivery', 100),
(2, 4, 4, NULL, NULL, 40.0, 128.0, 168.0, 'Bulk Delivery #4502', 'ATF bulk delivery', 100),

-- Manual adjustments
(5, 1, 1, NULL, NULL, -2.0, 125.5, 123.5, 'Inventory Adjustment', 'Spill cleanup', 100);

-- Insert Work Order Consumables (Bill of Materials)
INSERT INTO work_order_consumables (work_order_id, product_id, tank_id, reel_id, quantity_used, snapshot_product_name, snapshot_product_cost) VALUES
(1, 1, 1, 1, 5.0, 'Mobil 1 5W-30 Full Synthetic', 8.99),
(2, 4, 4, 4, 12.0, 'Mobil ATF 3309', 12.75),
(3, 6, 3, 3, 2.0, 'Lucas Red N Tacky Grease', 3.50);
```

### 5. Insert Sensor Readings (Example Data)

```sql
-- Insert sample sensor readings for the last 24 hours
INSERT INTO sensor_readings (sensor_id, raw_value, calculated_volume, reading_timestamp) VALUES
-- Main Oil Tank readings
(1, 21.5, 78.5, NOW() - INTERVAL 2 HOUR),
(1, 21.3, 79.2, NOW() - INTERVAL 1 HOUR),
(1, 20.8, 81.0, NOW()),

-- Temperature readings
(2, 72.5, 72.5, NOW() - INTERVAL 2 HOUR),
(2, 73.1, 73.1, NOW() - INTERVAL 1 HOUR),
(2, 74.2, 74.2, NOW()),

-- Grease Tank pressure readings
(4, 8.2, 15.2, NOW() - INTERVAL 3 HOUR),
(4, 8.1, 15.4, NOW() - INTERVAL 2 HOUR),
(4, 7.9, 15.8, NOW() - INTERVAL 1 HOUR);
```

### 6. System Settings

```sql
-- Insert system configuration
INSERT INTO system_settings (setting_name, setting_value, description) VALUES
('default_unit_system', 'imperial', 'Default measurement system for display'),
('low_stock_alert_threshold', '0.10', 'Percentage of min stock level to trigger alert'),
('sensor_polling_interval', '300', 'Seconds between sensor readings'),
('auto_tank_volume_update', 'true', 'Automatically update tank volume from primary sensor');
```

This dataset creates a complete scenario for frontend development:

- **4 active work orders** in various states
- **Multiple tanks** with different products and fill levels
- **Reels connected to tanks** for dispensing
- **Sensor data** showing historical trends
- **Transaction history** showing inventory movements
- **Complete product catalog** with realistic pricing and specs

You can now build frontend components that:
- Display tank levels with real-time data
- Show work order status and consumables used
- Generate reports on fluid usage and costs
- Monitor sensor data and trigger alerts
- Manage inventory and reordering