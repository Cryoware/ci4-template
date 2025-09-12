You are making perfect sense, and this is **not an overcomplication**. This is a critical design consideration for any system that will be used internationally or in environments that use different measurement systems. Your foresight here is excellent.

The current design using a simple `ENUM` is rigid. It hardcodes the units and makes global reporting and configuration difficult.

Here is a much more flexible and powerful approach:

---

### The Solution: A Unit of Measure Conversion System

We will create a reference table for all possible units and their relationships. This allows:
1.  Defining a global default system (Metric/Imperial) for the entire dealership.
2.  Storing data in a single, consistent "base unit" internally (e.g., Liters for volume).
3.  Converting and displaying values in any unit desired for reports or the UI.

#### Step 1: Create Unit and Unit Type Tables

This replaces the `ENUM` and provides a library of all available units.

```sql
-- Define categories of measurement (Volume, Length, Pressure, etc.)
CREATE TABLE unit_types (
    unit_type_id TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL UNIQUE -- e.g., 'Volume', 'Length', 'Weight'
);

-- The main table of all available units and their conversion factors to a base unit.
CREATE TABLE units (
    unit_id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    unit_name VARCHAR(20) NOT NULL UNIQUE, -- e.g., 'gallon', 'liter', 'quart'
    unit_abbreviation VARCHAR(10) NOT NULL UNIQUE, -- e.g., 'gal', 'L', 'qt'
    unit_type_id TINYINT UNSIGNED NOT NULL,
    system ENUM('metric', 'imperial', 'other') NOT NULL DEFAULT 'other',
    -- Conversion factor to convert THIS unit to the base unit for its type.
    -- e.g., For type 'Volume', base unit is 'liter'. So:
    -- 1 gallon = 3.78541 liters -> conversion_factor = 3.78541
    -- 1 quart = 0.946353 liters -> conversion_factor = 0.946353
    -- 1 liter = 1 liter -> conversion_factor = 1.0
    conversion_to_base DECIMAL(12, 6) UNSIGNED NOT NULL,
    FOREIGN KEY (unit_type_id) REFERENCES unit_types(unit_type_id) ON DELETE RESTRICT
);
```

#### Step 2: Create a System Settings Table

This stores the global default preference.

```sql
CREATE TABLE system_settings (
    setting_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    setting_name VARCHAR(50) NOT NULL UNIQUE,
    setting_value VARCHAR(255) NOT NULL,
    description TEXT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insert the default unit system preference
INSERT INTO system_settings (setting_name, setting_value, description)
VALUES
('default_unit_system', 'imperial', 'The default measurement system for displaying values. Valid options: "metric", "imperial".');
```

#### Step 3: Modify Existing Tables to Use the New `units` table

We change foreign keys to reference the new `units` table.

```sql
-- Modify the products table
ALTER TABLE products
CHANGE COLUMN unit_of_measure unit_id SMALLINT UNSIGNED NOT NULL,
ADD FOREIGN KEY (unit_id) REFERENCES units(unit_id) ON DELETE RESTRICT;

-- Modify the tanks table
-- We decide that all tank volumes will be stored internally in Liters.
-- We add columns to define what unit the tank's capacity is *defined* in (for user familiarity).
ALTER TABLE tanks
ADD COLUMN capacity_unit_id SMALLINT UNSIGNED NOT NULL AFTER capacity,
ADD COLUMN volume_display_unit_id SMALLINT UNSIGNED NOT NULL AFTER current_volume,
MODIFY COLUMN capacity DECIMAL(10, 2) UNSIGNED NOT NULL,
MODIFY COLUMN current_volume DECIMAL(12, 6) UNSIGNED NOT NULL DEFAULT 0.000000, -- Stored in Base Unit (Liters)
ADD FOREIGN KEY (capacity_unit_id) REFERENCES units(unit_id) ON DELETE RESTRICT,
ADD FOREIGN KEY (volume_display_unit_id) REFERENCES units(unit_id) ON DELETE RESTRICT;

-- Modify the sensor_types table
ALTER TABLE sensor_types
CHANGE COLUMN measurement_unit measurement_unit_id SMALLINT UNSIGNED NOT NULL,
ADD FOREIGN KEY (measurement_unit_id) REFERENCES units(unit_id) ON DELETE RESTRICT;
```

#### Step 4: Populate the `units` table with essential data

```sql
-- First, populate unit_types
INSERT INTO unit_types (type_name) VALUES
('Volume'),
('Length'),
('Weight');

-- Then, populate units for Volume. Let's use Liter (L) as the base unit.
INSERT INTO units (unit_name, unit_abbreviation, unit_type_id, system, conversion_to_base) VALUES
-- Metric Volume Units
('liter', 'L', (SELECT unit_type_id FROM unit_types WHERE type_name = 'Volume'), 'metric', 1.000000),
('milliliter', 'mL', (SELECT unit_type_id FROM unit_types WHERE type_name = 'Volume'), 'metric', 0.001000),
-- Imperial/US Volume Units
('gallon', 'gal', (SELECT unit_type_id FROM unit_types WHERE type_name = 'Volume'), 'imperial', 3.785410),
('quart', 'qt', (SELECT unit_type_id FROM unit_types WHERE type_name = 'Volume'), 'imperial', 0.946353),
('ounce', 'fl oz', (SELECT unit_type_id FROM unit_types WHERE type_name = 'Volume'), 'imperial', 0.0295735),
('cartridge', 'ctg', (SELECT unit_type_id FROM unit_types WHERE type_name = 'Volume'), 'other', 0.400000), -- Example: 400mL grease cartridge
('tube', 'tube', (SELECT unit_type_id FROM unit_types WHERE type_name = 'Volume'), 'other', 0.100000); -- Example: 100mL tube

-- Add some Length units (base unit = meter)
INSERT INTO units (unit_name, unit_abbreviation, unit_type_id, system, conversion_to_base) VALUES
('meter', 'm', (SELECT unit_type_id FROM unit_types WHERE type_name = 'Length'), 'metric', 1.000000),
('centimeter', 'cm', (SELECT unit_type_id FROM unit_types WHERE type_name = 'Length'), 'metric', 0.010000),
('inch', 'in', (SELECT unit_type_id FROM unit_types WHERE type_name = 'Length'), 'imperial', 0.025400),
('foot', 'ft', (SELECT unit_type_id FROM unit_types WHERE type_name = 'Length'), 'imperial', 0.304800);
```

---

### How It Works in Practice: A Report Example

**Goal:** Generate a report showing tank levels, displaying them in the user's preferred system.

1.  **Data Storage:** All volumes in the `tanks` table are stored in the base unit, **Liters**.
2.  **User Preference:** The application checks the `system_settings` table for `default_unit_system = 'imperial'`.
3.  **Report Query:** The query converts the stored base value (Liters) to the desired display unit (Gallons) on the fly using the conversion factors.

```sql
SELECT
    t.name AS Tank_Name,
    t.current_volume AS Volume_In_Liters,
    -- Convert to the user's preferred unit for display
    (t.current_Volume / u.conversion_to_base) AS Display_Volume, -- e.g., / 3.78541 to get gallons
    u.unit_abbreviation AS Display_Unit -- e.g., 'gal'
FROM tanks t
-- Get the preferred display unit for volume in imperial system
JOIN units u ON u.unit_name = 'gallon' -- Based on the system_settings value
WHERE u.unit_type_id = (SELECT unit_type_id FROM unit_types WHERE type_name = 'Volume')
AND u.system = 'imperial';
```

**Result:** A user with the imperial setting sees volume in gallons, while a metric user would see liters, all from the same underlying data.

### Summary of Benefits:

*   **Single Source of Truth:** All data is stored in a consistent base unit.
*   **Ultimate Flexibility:** You can add any unit (e.g., `pint`, `barrel`, `cubic meter`) without changing the database schema.
*   **Global Readiness:** The UI and reports can display values in any unit based on a user, dealership, or global setting.
*   **Accuracy:** Conversions are handled mathematically based on defined factors, reducing human error.
*   **Scalability:** This system can easily be extended to other types of measurements (e.g., pressure from sensors, hose length of reels).

You were right to identify this need. This design is a professional and robust solution to the very real problem of unit management.