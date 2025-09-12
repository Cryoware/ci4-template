# Fluid Management System Documentation (Complete)

## Overview

A comprehensive MySQL-based fluid management system designed for automotive dealerships and service centers. The system tracks fluid inventory, manages physical tanks and reels, monitors sensor data, and integrates with work orders for complete fluid usage tracking.

## Complete Database Schema

### Core Configuration Tables

#### 1. Unit Types
```sql
CREATE TABLE unit_types (
    unit_type_id TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL UNIQUE,
    base_unit_name VARCHAR(20) NOT NULL,
    description TEXT
);
```

#### 2. Units (Complete Measurement System)
```sql
CREATE TABLE units (
    unit_id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    unit_name VARCHAR(30) NOT NULL UNIQUE,
    unit_abbreviation VARCHAR(10) NOT NULL UNIQUE,
    unit_type_id TINYINT UNSIGNED NOT NULL,
    system ENUM('metric', 'imperial', 'us_customary', 'other') NOT NULL DEFAULT 'other',
    conversion_to_base DECIMAL(20, 10) NOT NULL,
    FOREIGN KEY (unit_type_id) REFERENCES unit_types(unit_type_id)
);
```

#### 3. System Settings
```sql
CREATE TABLE system_settings (
    setting_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    setting_name VARCHAR(50) NOT NULL UNIQUE,
    setting_value VARCHAR(255) NOT NULL,
    description TEXT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### Inventory Management Tables

#### 4. Manufacturers
```sql
CREATE TABLE manufacturers (
    manufacturer_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    contact_info TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### 5. Fluid Types
```sql
CREATE TABLE fluid_types (
    fluid_type_id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);
```

#### 6. Products
```sql
CREATE TABLE products (
    product_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    manufacturer_id INT UNSIGNED NOT NULL,
    manufacturer_part_number VARCHAR(100),
    fluid_type_id SMALLINT UNSIGNED NOT NULL,
    viscosity_grade VARCHAR(50),
    specifications TEXT,
    unit_id SMALLINT UNSIGNED NOT NULL,
    is_hazmat BOOLEAN NOT NULL DEFAULT FALSE,
    cost_per_unit DECIMAL(10, 2) UNSIGNED NOT NULL DEFAULT 0.00,
    min_stock_level DECIMAL(10, 2) UNSIGNED NOT NULL DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (manufacturer_id) REFERENCES manufacturers(manufacturer_id),
    FOREIGN KEY (fluid_type_id) REFERENCES fluid_types(fluid_type_id),
    FOREIGN KEY (unit_id) REFERENCES units(unit_id)
);
```

### Asset Management Tables

#### 7. Tank Statuses
```sql
CREATE TABLE tank_statuses (
    status_id TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(20) NOT NULL UNIQUE
);
```

#### 8. Tanks
```sql
CREATE TABLE tanks (
    tank_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    product_id INT UNSIGNED NOT NULL,
    capacity DECIMAL(10, 2) UNSIGNED NOT NULL,
    capacity_unit_id SMALLINT UNSIGNED NOT NULL,
    current_volume DECIMAL(12, 6) UNSIGNED NOT NULL DEFAULT 0.000000,
    volume_display_unit_id SMALLINT UNSIGNED NOT NULL,
    status_id TINYINT UNSIGNED NOT NULL DEFAULT 1,
    calibration_factor DECIMAL(5, 2) NOT NULL DEFAULT 1.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (capacity_unit_id) REFERENCES units(unit_id),
    FOREIGN KEY (volume_display_unit_id) REFERENCES units(unit_id),
    FOREIGN KEY (status_id) REFERENCES tank_statuses(status_id)
);
```

#### 9. Reel Types
```sql
CREATE TABLE reel_types (
    reel_type_id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL UNIQUE,
    hose_length DECIMAL(5, 2) UNSIGNED,
    max_flow_rate DECIMAL(6, 2) UNSIGNED
);
```

#### 10. Reels
```sql
CREATE TABLE reels (
    reel_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    reel_type_id SMALLINT UNSIGNED NOT NULL,
    tank_id INT UNSIGNED NOT NULL,
    asset_tag VARCHAR(50) UNIQUE,
    status_id TINYINT UNSIGNED NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (reel_type_id) REFERENCES reel_types(reel_type_id),
    FOREIGN KEY (tank_id) REFERENCES tanks(tank_id),
    FOREIGN KEY (status_id) REFERENCES tank_statuses(status_id)
);
```

### Sensor Management Tables

#### 11. Sensor Types
```sql
CREATE TABLE sensor_types (
    sensor_type_id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL UNIQUE,
    measurement_unit_id SMALLINT UNSIGNED NOT NULL,
    description TEXT,
    FOREIGN KEY (measurement_unit_id) REFERENCES units(unit_id)
);
```

#### 12. Tank Sensors
```sql
CREATE TABLE tank_sensors (
    sensor_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    tank_id INT UNSIGNED NOT NULL,
    sensor_type_id TINYINT UNSIGNED NOT NULL,
    name VARCHAR(100) NOT NULL,
    calibration_value DECIMAL(10, 4) NOT NULL DEFAULT 0.0000,
    is_primary BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (tank_id) REFERENCES tanks(tank_id),
    FOREIGN KEY (sensor_type_id) REFERENCES sensor_types(sensor_type_id)
);
```

#### 13. Sensor Readings
```sql
CREATE TABLE sensor_readings (
    reading_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    sensor_id INT UNSIGNED NOT NULL,
    raw_value DECIMAL(12, 6) NOT NULL,
    calculated_volume DECIMAL(10, 2) UNSIGNED NOT NULL,
    reading_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sensor_id) REFERENCES tank_sensors(sensor_id)
);
```

### Transaction System Tables

#### 14. Transaction Types
```sql
CREATE TABLE transaction_types (
    type_id TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(20) NOT NULL UNIQUE
);
```

#### 15. Fluid Transactions
```sql
CREATE TABLE fluid_transactions (
    transaction_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    transaction_type TINYINT UNSIGNED NOT NULL,
    product_id INT UNSIGNED NOT NULL,
    tank_id INT UNSIGNED NULL,
    reel_id INT UNSIGNED NULL,
    work_order_id INT UNSIGNED NULL,
    quantity DECIMAL(10, 2) NOT NULL,
    volume_before DECIMAL(10, 2) UNSIGNED,
    volume_after DECIMAL(10, 2) UNSIGNED,
    source_or_destination VARCHAR(255),
    notes TEXT,
    user_id INT UNSIGNED,
    transaction_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (transaction_type) REFERENCES transaction_types(type_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (tank_id) REFERENCES tanks(tank_id),
    FOREIGN KEY (reel_id) REFERENCES reels(reel_id),
    FOREIGN KEY (work_order_id) REFERENCES work_orders(work_order_id)
);
```

### Work Order System Tables

#### 16. Work Order Statuses
```sql
CREATE TABLE work_order_statuses (
    status_id TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(20) NOT NULL UNIQUE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);
```

#### 17. Work Orders
```sql
CREATE TABLE work_orders (
    work_order_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    external_id VARCHAR(100) NULL UNIQUE,
    description TEXT NOT NULL,
    status_id TINYINT UNSIGNED NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    completed_at TIMESTAMP NULL,
    FOREIGN KEY (status_id) REFERENCES work_order_statuses(status_id)
);
```

#### 18. Work Order Consumables
```sql
CREATE TABLE work_order_consumables (
    consumable_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    work_order_id INT UNSIGNED NOT NULL,
    product_id INT UNSIGNED NOT NULL,
    tank_id INT UNSIGNED NULL,
    reel_id INT UNSIGNED NULL,
    quantity_used DECIMAL(10, 2) UNSIGNED NOT NULL,
    snapshot_product_name VARCHAR(255) NOT NULL,
    snapshot_product_cost DECIMAL(10, 2) UNSIGNED NOT NULL,
    usage_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    FOREIGN KEY (work_order_id) REFERENCES work_orders(work_order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (tank_id) REFERENCES tanks(tank_id),
    FOREIGN KEY (reel_id) REFERENCES reels(reel_id)
);
```

## Key Features

### 1. Comprehensive Unit Management
- Supports metric, imperial, and US customary units
- Automatic conversion between units
- Flexible unit system for future expansion

### 2. Real-time Inventory Tracking
- Transaction-based inventory system
- Automatic stock level calculations
- Low stock alerts and notifications

### 3. Asset Management
- Tank monitoring with sensor integration
- Reel management and utilization tracking
- Maintenance status tracking

### 4. Work Order Integration
- Fluid usage tracking per work order
- Cost calculation for services
- External work order system compatibility

### 5. Sensor Data Management
- Multiple sensor type support
- Real-time volume calculations
- Historical data tracking

### 6. Automated Triggers
- Real-time volume calculations
- Inventory consistency enforcement
- Data validation rules

## Complete Workflows

### Adding a New Product

1. **Check if manufacturer exists** in `manufacturers` table
2. **Verify fluid type** exists in `fluid_types` table
3. **Select appropriate unit** from `units` table
4. **Create product record**:
   ```sql
   INSERT INTO products (name, description, manufacturer_id, manufacturer_part_number, 
                        fluid_type_id, viscosity_grade, specifications, unit_id, 
                        is_hazmat, cost_per_unit, min_stock_level)
   VALUES ('Mobil 1 5W-30', 'Full synthetic motor oil', 1, 'M1-110', 
           1, '5W-30', 'API SP', 15, FALSE, 8.99, 24.00);
   ```

### Setting Up a New Tank

1. **Ensure product exists** for the tank
2. **Create tank record**:
   ```sql
   INSERT INTO tanks (name, description, product_id, capacity, capacity_unit_id,
                     current_volume, volume_display_unit_id, status_id, calibration_factor)
   VALUES ('Main Oil Tank - Bay 1', 'Primary 5W-30 storage', 1, 100.0, 15, 
           0.0, 15, 1, 1.02);
   ```
3. **Add sensors** to the tank:
   ```sql
   INSERT INTO tank_sensors (tank_id, sensor_type_id, name, calibration_value, is_primary)
   VALUES (1, 1, 'Main Level Sensor', 0.5, TRUE);
   ```
4. **Configure reels** connected to the tank

### Processing a Work Order

1. **Create work order** record:
   ```sql
   INSERT INTO work_orders (external_id, description, status_id)
   VALUES ('EXT-WO-1001', '2023 Toyota Camry - Oil Change', 1);
   ```
2. **Record fluid usage** through transactions:
   ```sql
   INSERT INTO fluid_transactions (transaction_type, product_id, tank_id, reel_id,
                                  work_order_id, quantity, user_id)
   VALUES (3, 1, 1, 1, 1, 5.0, 101);
   ```
3. **Add to work order consumables**:
   ```sql
   INSERT INTO work_order_consumables (work_order_id, product_id, tank_id, reel_id,
                                      quantity_used, snapshot_product_name, snapshot_product_cost)
   VALUES (1, 1, 1, 1, 5.0, 'Mobil 1 5W-30', 8.99);
   ```
4. **Update work order status** when completed

### Adding Sensor Data

1. **Insert sensor reading**:
   ```sql
   INSERT INTO sensor_readings (sensor_id, raw_value, calculated_volume)
   VALUES (1, 21.5, 78.5);
   ```
2. **Triggers automatically** update tank volumes
3. **System maintains** historical data for reporting

### Inventory Management

1. **Add new inventory** (purchase):
   ```sql
   INSERT INTO fluid_transactions (transaction_type, product_id, quantity, 
                                  source_or_destination, user_id)
   VALUES (1, 1, 50.0, 'Purchase Order #4501', 100);
   ```
2. **Transfer between tanks**:
   ```sql
   INSERT INTO fluid_transactions (transaction_type, product_id, tank_id, quantity,
                                  source_or_destination, user_id)
   VALUES (6, 1, 1, 25.0, 'Transfer from Bulk Storage', 100);
   ```

## Complete Views for Reporting

### 1. Dashboard Overview
```sql
CREATE VIEW dashboard_overview AS
SELECT 
    (SELECT COUNT(*) FROM products) AS total_products,
    (SELECT COUNT(*) FROM tanks WHERE status_id = 1) AS active_tanks,
    (SELECT COUNT(*) FROM work_orders WHERE status_id IN (1, 2)) AS active_work_orders,
    (SELECT COUNT(*) FROM product_inventory WHERE stock_status != 'IN_STOCK') AS low_stock_items,
    (SELECT COUNT(*) FROM fluid_transactions WHERE transaction_timestamp >= CURDATE()) AS today_transactions,
    (SELECT SUM(current_volume) FROM tanks) AS total_fluid_volume,
    (SELECT SUM(value_on_hand) FROM product_inventory) AS inventory_value;
```

### 2. Product Inventory View
```sql
CREATE VIEW product_inventory AS
SELECT 
    p.product_id,
    p.name AS product_name,
    -- Inventory calculation from transactions
    COALESCE((
        SELECT SUM(CASE 
            WHEN tt.type_name IN ('PURCHASE', 'FILL', 'MANUAL_ADD') THEN ft.quantity
            WHEN tt.type_name IN ('DISPENSE', 'ADJUST', 'USAGE') THEN -ft.quantity
            ELSE 0 END)
        FROM fluid_transactions ft
        JOIN transaction_types tt ON ft.transaction_type = tt.type_id
        WHERE ft.product_id = p.product_id
    ), 0) AS current_quantity,
    -- ... additional fields
FROM products p;
```

### 3. Tank Status Detailed View
```sql
CREATE VIEW tank_status_detailed AS
SELECT 
    t.tank_id,
    t.name AS tank_name,
    p.name AS product_name,
    t.capacity,
    u_cap.unit_abbreviation AS capacity_unit,
    t.current_volume,
    u_vol.unit_abbreviation AS volume_unit,
    ROUND((t.current_volume / t.capacity) * 100, 1) AS fill_percentage,
    CASE 
        WHEN (t.current_volume / t.capacity) * 100 < 10 THEN 'CRITICAL'
        WHEN (t.current_volume / t.capacity) * 100 < 25 THEN 'LOW'
        ELSE 'OK'
    END AS status_level
FROM tanks t
JOIN products p ON t.product_id = p.product_id
JOIN units u_cap ON t.capacity_unit_id = u_cap.unit_id
JOIN units u_vol ON t.volume_display_unit_id = u_vol.unit_id;
```

### 4. Work Order Progress View
```sql
CREATE VIEW work_order_progress AS
SELECT 
    wo.work_order_id,
    wo.external_id,
    wo.description,
    ws.status_name AS status,
    wo.created_at,
    wo.updated_at,
    wo.completed_at,
    (SELECT COUNT(*) FROM work_order_consumables woc 
     WHERE woc.work_order_id = wo.work_order_id) AS products_used,
    (SELECT SUM(woc.quantity_used * woc.snapshot_product_cost) 
     FROM work_order_consumables woc 
     WHERE woc.work_order_id = wo.work_order_id) AS total_cost
FROM work_orders wo
JOIN work_order_statuses ws ON wo.status_id = ws.status_id;
```

### 5. Sensor Data History View
```sql
CREATE VIEW sensor_data_history AS
SELECT 
    sr.reading_id,
    sr.sensor_id,
    ts.name AS sensor_name,
    st.type_name AS sensor_type,
    t.tank_id,
    t.name AS tank_name,
    sr.raw_value,
    u.unit_abbreviation AS raw_unit,
    sr.calculated_volume,
    uv.unit_abbreviation AS volume_unit,
    sr.reading_timestamp
FROM sensor_readings sr
JOIN tank_sensors ts ON sr.sensor_id = ts.sensor_id
JOIN sensor_types st ON ts.sensor_type_id = st.sensor_type_id
JOIN tanks t ON ts.tank_id = t.tank_id
JOIN units u ON st.measurement_unit_id = u.unit_id
JOIN units uv ON t.volume_display_unit_id = uv.unit_id;
```

## Automation Triggers (Complete)

### 1. Sensor Reading Processing
```sql
DELIMITER //
CREATE TRIGGER before_sensor_reading_insert
BEFORE INSERT ON sensor_readings
FOR EACH ROW
BEGIN
    DECLARE v_tank_id INT UNSIGNED;
    
    -- Get the tank_id for this sensor
    SELECT tank_id INTO v_tank_id 
    FROM tank_sensors 
    WHERE sensor_id = NEW.sensor_id;
    
    -- Calculate the volume using our function
    SET NEW.calculated_volume = calculate_tank_volume(
        v_tank_id, 
        NEW.sensor_id, 
        NEW.raw_value
    );
    
    -- If this is the primary sensor, update the tank's current_volume
    IF EXISTS (
        SELECT 1 FROM tank_sensors 
        WHERE sensor_id = NEW.sensor_id AND is_primary = TRUE
    ) THEN
        UPDATE tanks 
        SET current_volume = NEW.calculated_volume,
            updated_at = NOW()
        WHERE tank_id = v_tank_id;
    END IF;
END //
DELIMITER ;
```

### 2. Transaction Processing
```sql
DELIMITER //
CREATE TRIGGER after_fluid_transaction_insert
AFTER INSERT ON fluid_transactions
FOR EACH ROW
BEGIN
    -- Only process transactions that affect a specific tank
    IF NEW.tank_id IS NOT NULL THEN
        -- Convert transaction quantity to base units
        -- Update tank volume based on transaction type
        IF NEW.transaction_type IN (SELECT type_id FROM transaction_types 
                                   WHERE type_name IN ('FILL', 'MANUAL_ADD', 'PURCHASE')) THEN
            UPDATE tanks 
            SET current_volume = LEAST(capacity, current_volume + converted_quantity),
                updated_at = NOW()
            WHERE tank_id = NEW.tank_id;
        ELSEIF NEW.transaction_type IN (SELECT type_id FROM transaction_types 
                                      WHERE type_name IN ('DISPENSE', 'ADJUST')) THEN
            UPDATE tanks 
            SET current_volume = GREATEST(0, current_volume - converted_quantity),
                updated_at = NOW()
            WHERE tank_id = NEW.tank_id;
        END IF;
    END IF;
END //
DELIMITER ;
```

### 3. Data Validation
```sql
DELIMITER //
CREATE TRIGGER before_tank_update
BEFORE UPDATE ON tanks
FOR EACH ROW
BEGIN
    -- Ensure current_volume never exceeds capacity
    IF NEW.current_volume > NEW.capacity THEN
        SET NEW.current_volume = NEW.capacity;
    END IF;
    
    -- Ensure current_volume is never negative
    IF NEW.current_volume < 0 THEN
        SET NEW.current_volume = 0;
    END IF;
    
    -- Always update the updated_at timestamp
    SET NEW.updated_at = NOW();
END //
DELIMITER ;
```

## System Configuration

### Default Settings
```sql
INSERT INTO system_settings (setting_name, setting_value, description) VALUES
('default_unit_system', 'imperial', 'Default measurement system for display'),
('low_stock_alert_threshold', '0.10', 'Percentage of min stock level to trigger alert'),
('sensor_polling_interval', '300', 'Seconds between sensor readings'),
('auto_tank_volume_update', 'true', 'Automatically update tank volume from primary sensor'),
('inventory_alert_email', 'inventory@dealership.com', 'Email for inventory alerts');
```

### Initial Data Population

#### Transaction Types
```sql
INSERT INTO transaction_types (type_name) VALUES
('PURCHASE'), ('FILL'), ('DISPENSE'), ('MANUAL_ADD'), ('ADJUST'), ('TRANSFER');
```

#### Tank Statuses
```sql
INSERT INTO tank_statuses (status_name) VALUES
('Active'), ('Maintenance'), ('Decommissioned');
```

#### Work Order Statuses
```sql
INSERT INTO work_order_statuses (status_name, is_active) VALUES
('Pending', TRUE), ('In Progress', TRUE), ('Completed', TRUE), 
('On Hold', TRUE), ('Cancelled', FALSE);
```

## API Endpoints (Conceptual)

### Products Management
- `GET /api/products` - List all products with inventory status
- `POST /api/products` - Create new product
- `GET /api/products/{id}` - Get product details
- `PUT /api/products/{id}` - Update product information
- `GET /api/products/{id}/usage` - Get usage history

### Tank Management
- `GET /api/tanks` - List all tanks with current status
- `POST /api/tanks` - Create new tank
- `GET /api/tanks/{id}` - Get tank details and current volume
- `PUT /api/tanks/{id}` - Update tank configuration
- `POST /api/tanks/{id}/sensor-data` - Submit sensor readings

### Work Order Integration
- `GET /api/work-orders` - List work orders
- `POST /api/work-orders` - Create work order
- `GET /api/work-orders/{id}` - Get work order details
- `PUT /api/work-orders/{id}/status` - Update work order status
- `POST /api/work-orders/{id}/fluid-usage` - Record fluid usage

### Reporting Endpoints
- `GET /api/reports/inventory` - Inventory status report
- `GET /api/reports/usage` - Fluid usage analytics
- `GET /api/reports/tank-levels` - Tank level history
- `GET /api/reports/cost-analysis` - Cost analysis by period

## Security Implementation

### 1. Authentication Middleware
```javascript
// Example middleware for API authentication
const authenticateToken = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];
    
    if (token == null) return res.sendStatus(401);
    
    jwt.verify(token, process.env.ACCESS_TOKEN_SECRET, (err, user) => {
        if (err) return res.sendStatus(403);
        req.user = user;
        next();
    });
};
```

### 2. Role-Based Access Control
```sql
-- Example user roles table
CREATE TABLE user_roles (
    user_id INT UNSIGNED NOT NULL,
    role ENUM('admin', 'manager', 'technician', 'viewer') NOT NULL,
    PRIMARY KEY (user_id, role)
);
```

### 3. Audit Logging
```sql
CREATE TABLE audit_logs (
    log_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNSIGNED NOT NULL,
    action VARCHAR(50) NOT NULL,
    table_name VARCHAR(50) NOT NULL,
    record_id INT UNSIGNED NOT NULL,
    old_values JSON,
    new_values JSON,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## Monitoring and Maintenance Procedures

### Daily Tasks
1. **Check System Alerts**
    - Low inventory alerts
    - Tank level warnings
    - Sensor malfunctions

2. **Review Error Logs**
    - Database connection issues
    - Sensor communication errors
    - API authentication failures

3. **Verify Backups**
    - Transaction log integrity
    - Sensor data completeness
    - System configuration backup

### Weekly Tasks
1. **Performance Review**
    - Database query optimization
    - API response times
    - Sensor data processing efficiency

2. **Inventory Reconciliation**
    - Physical count vs system count
    - Transaction audit trail review
    - Cost analysis verification

3. **System Health Check**
    - Database storage utilization
    - API uptime monitoring
    - Sensor network status

### Monthly Tasks
1. **Data Archiving**
    - Old sensor readings archive
    - Completed work order cleanup
    - Historical report generation

2. **Security Audit**
    - User access review
    - API usage patterns
    - System vulnerability assessment

3. **System Updates**
    - Database schema updates
    - API version upgrades
    - Security patch application

## Troubleshooting Guide

### Common Issues and Solutions

#### 1. Sensor Data Not Updating
**Symptoms**: Tank volumes not changing, sensor readings not processing
**Solutions**:
- Check sensor calibration values
- Verify primary sensor designation
- Review trigger functionality
- Check sensor network connectivity

#### 2. Inventory Discrepancies
**Symptoms**: Physical count doesn't match system inventory
**Solutions**:
- Audit transaction history
- Check unit conversion factors
- Verify product definitions
- Review recent adjustment transactions

#### 3. Performance Issues
**Symptoms**: Slow API responses, delayed sensor processing
**Solutions**:
- Review database indexes
- Optimize complex views
- Implement query caching
- Consider data archiving strategy

#### 4. Integration Problems
**Symptoms**: External system data not syncing
**Solutions**:
- Check API authentication
- Verify data format compatibility
- Review network connectivity
- Check external system status

## Backup and Recovery Strategy

### Backup Procedures
1. **Daily Incremental Backups**
    - Transaction data
    - Sensor readings
    - System logs

2. **Weekly Full Backups**
    - Complete database dump
    - System configuration
    - Application code

3. **Monthly Archives**
    - Historical data export
    - Report generation
    - System snapshot

### Recovery Procedures
1. **Database Restoration**
    - Latest full backup restoration
    - Incremental backup application
    - Data consistency verification

2. **System Recovery**
    - Configuration restoration
    - User access reinstatement
    - Service restart procedures

3. **Data Validation**
    - Transaction integrity check
    - Sensor data consistency
    - Inventory reconciliation

## Future Enhancement Roadmap

### Phase 1: Advanced Analytics (Next 6 months)
- Predictive inventory management
- Machine learning for usage patterns
- Automated reordering system
- Real-time cost optimization

### Phase 2: Mobile Integration (Next 12 months)
- iOS/Android mobile apps
- Barcode/RFID scanning
- Offline capability
- Push notifications for alerts

### Phase 3: IoT Expansion (Next 18 months)
- Additional sensor types (flow meters, quality sensors)
- Automated dispensing systems
- Remote monitoring capabilities
- Predictive maintenance alerts

### Phase 4: Enterprise Integration (Next 24 months)
- ERP system connectivity
- Accounting software integration
- Supplier ordering automation
- Multi-location support

## Support and Contact Information

### Technical Support
- **Email**: support@fluidmgmt.com
- **Phone**: +1-800-FLUID-MGMT
- **Hours**: 24/7 critical support available

### Documentation Resources
- API Documentation: https://api.fluidmgmt.com/docs
- User Manual: https://docs.fluidmgmt.com
- Developer Guide: https://dev.fluidmgmt.com

### Training Resources
- Online training courses
- Video tutorials
- Certification programs
- On-site training available

This comprehensive documentation provides complete guidance for implementing, maintaining, and extending the fluid management system. The modular design allows for phased implementation and easy customization to meet specific organizational needs.