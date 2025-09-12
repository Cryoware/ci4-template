# Fluid Management System Documentation

## Overview

A comprehensive MySQL-based fluid management system designed for automotive dealerships and service centers. The system tracks fluid inventory, manages physical tanks and reels, monitors sensor data, and integrates with work orders for complete fluid usage tracking.

## Database Schema

### Core Tables

#### 1. Manufacturers
```sql
CREATE TABLE manufacturers (
    manufacturer_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    contact_info TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### 2. Fluid Types
```sql
CREATE TABLE fluid_types (
    fluid_type_id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);
```

#### 3. Products
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

### Unit Management System

#### Units Table
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

### Asset Management Tables

#### Tanks
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

#### Reels
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

### Sensor Management

#### Sensor Types
```sql
CREATE TABLE sensor_types (
    sensor_type_id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL UNIQUE,
    measurement_unit_id SMALLINT UNSIGNED NOT NULL,
    description TEXT,
    FOREIGN KEY (measurement_unit_id) REFERENCES units(unit_id)
);
```

#### Tank Sensors
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

### Transaction System

#### Fluid Transactions
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

### Work Order System

#### Work Orders
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

## Workflows

### Adding a New Product

1. **Check if manufacturer exists** in `manufacturers` table
2. **Verify fluid type** exists in `fluid_types` table
3. **Create product record**:
   ```sql
   INSERT INTO products (name, description, manufacturer_id, manufacturer_part_number, 
                        fluid_type_id, viscosity_grade, specifications, unit_id, 
                        is_hazmat, cost_per_unit, min_stock_level)
   VALUES ('Product Name', 'Description', 1, 'PART-123', 1, '5W-30', 
           'API SP', 1, FALSE, 8.99, 24.00);
   ```

### Setting Up a New Tank

1. **Ensure product exists** for the tank
2. **Create tank record**:
   ```sql
   INSERT INTO tanks (name, description, product_id, capacity, capacity_unit_id,
                     current_volume, volume_display_unit_id, status_id, calibration_factor)
   VALUES ('Tank Name', 'Description', 1, 100.0, 1, 0.0, 1, 1, 1.00);
   ```
3. **Add sensors** to the tank
4. **Configure reels** connected to the tank

### Processing a Work Order

1. **Create work order** record
2. **Record fluid usage** through transactions:
   ```sql
   INSERT INTO fluid_transactions (transaction_type, product_id, tank_id, reel_id,
                                  work_order_id, quantity, user_id)
   VALUES (3, 1, 1, 1, 1, 5.0, 101);
   ```
3. **Update work order status** when completed

### Adding Sensor Data

1. **Insert sensor reading**:
   ```sql
   INSERT INTO sensor_readings (sensor_id, raw_value, calculated_volume)
   VALUES (1, 25.5, 78.3);
   ```
2. **Triggers automatically** update tank volumes
3. **System maintains** historical data for reporting

## Views for Reporting

### 1. `dashboard_overview`
- Key metrics and KPIs
- System health monitoring
- Quick status overview

### 2. `product_inventory`
- Current stock levels
- Inventory value calculations
- Stock status indicators

### 3. `tank_status_detailed`
- Tank fill levels and percentages
- Product information
- Status indicators

### 4. `daily_usage_summary`
- Daily fluid consumption
- Cost analysis
- Transaction counts

### 5. `work_order_fluid_usage`
- Fluid consumption by work order
- Cost tracking
- Service analysis

## Automation Triggers

### 1. Sensor Reading Processing
```sql
CREATE TRIGGER before_sensor_reading_insert
BEFORE INSERT ON sensor_readings
FOR EACH ROW
BEGIN
    -- Automatic volume calculation
    -- Primary sensor updates tank volume
END;
```

### 2. Transaction Processing
```sql
CREATE TRIGGER after_fluid_transaction_insert
AFTER INSERT ON fluid_transactions
FOR EACH RANGE
BEGIN
    -- Inventory updates
    -- Tank volume adjustments
END;
```

### 3. Data Validation
```sql
CREATE TRIGGER before_tank_update
BEFORE UPDATE ON tanks
FOR EACH ROW
BEGIN
    -- Prevent negative volumes
    -- Ensure capacity limits
END;
```

## Installation and Setup

### 1. Database Initialization
```bash
mysql -u username -p < database_schema.sql
mysql -u username -p < sample_data.sql
```

### 2. Configuration
- Set default unit system in `system_settings`
- Configure sensor calibration values
- Set up user permissions

### 3. Integration
- API endpoints for sensor data
- Web UI integration points
- External system connections

## API Endpoints (Conceptual)

### Products
- `GET /api/products` - List all products
- `POST /api/products` - Create new product
- `GET /api/products/{id}/inventory` - Get inventory status

### Tanks
- `GET /api/tanks` - List all tanks
- `GET /api/tanks/{id}/status` - Get tank status
- `POST /api/tanks/{id}/sensor-data` - Submit sensor readings

### Work Orders
- `GET /api/work-orders` - List work orders
- `POST /api/work-orders` - Create work order
- `POST /api/work-orders/{id}/fluid-usage` - Record fluid usage

## Security Considerations

### 1. Data Access
- Role-based access control
- Audit logging for all transactions
- Sensitive data encryption

### 2. API Security
- Authentication tokens
- Rate limiting
- Input validation

### 3. Database Security
- Prepared statements
- SQL injection prevention
- Regular security updates

## Monitoring and Maintenance

### 1. Performance Monitoring
- Query optimization
- Index management
- Connection pooling

### 2. Data Maintenance
- Regular backups
- Archive old sensor data
- Purge completed work orders

### 3. System Health
- Sensor status monitoring
- Tank level alerts
- Low inventory notifications

## Future Enhancements

### 1. Advanced Analytics
- Predictive inventory management
- Usage pattern analysis
- Cost optimization suggestions

### 2. Mobile Integration
- Mobile app for technicians
- Barcode/RFID scanning
- Offline capability

### 3. IoT Expansion
- Additional sensor types
- Automated dispensing systems
- Remote monitoring

### 4. Integration Features
- ERP system integration
- Accounting software connectivity
- Supplier ordering automation

### 5. Advanced Reporting
- Custom report builder
- Export to multiple formats
- Scheduled report generation

## Troubleshooting

### Common Issues

1. **Sensor Data Not Updating**
    - Check sensor calibration values
    - Verify primary sensor designation
    - Review trigger functionality

2. **Inventory Discrepancies**
    - Audit transaction history
    - Check unit conversions
    - Verify product definitions

3. **Performance Issues**
    - Review database indexes
    - Optimize complex views
    - Consider data archiving

## Support and Maintenance

### Regular Tasks
- Monitor system alerts
- Review error logs
- Update unit definitions as needed
- Calibrate sensors periodically

### Backup Strategy
- Daily transaction log backups
- Weekly full database backups
- Monthly archive of historical data

This documentation provides a comprehensive guide to the fluid management system. For specific implementation details or custom modifications, refer to the actual database schema and application code.