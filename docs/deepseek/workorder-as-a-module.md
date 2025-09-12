Absolutely. This is a crucial addition. Designing the work order system as a modular "add-on" means creating self-contained tables with clear foreign key relationships *to* the core fluid management system, but not necessarily requiring the core system to have dependencies *on* the work order module. This allows the work order module to be installed or uninstalled without breaking the core fluid tracking functionality.

Here is the modified database structure:

### New & Modified Tables for the Work Order Module

#### 1. Core Work Order Tables (The heart of the module)

```sql
-- Statuses like 'Pending', 'In Progress', 'Completed', 'Cancelled'
CREATE TABLE work_order_statuses (
    status_id TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(20) NOT NULL UNIQUE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE -- To filter active vs. historical statuses
);

-- The main work order header table
CREATE TABLE work_orders (
    work_order_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    external_id VARCHAR(100) NULL UNIQUE, -- ID from an external system (e.g., 'WO-12345')
    description TEXT NOT NULL, -- Summary of the work to be done
    status_id TINYINT UNSIGNED NOT NULL DEFAULT 1, -- Default to first status (e.g., 'Pending')
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    completed_at TIMESTAMP NULL, -- Will be set when status moves to 'Completed'
    FOREIGN KEY (status_id) REFERENCES work_order_statuses(status_id) ON DELETE RESTRICT
);
```

#### 2. Work Order Details (Linking Work to Fluids & Assets)

This is the most important table as it connects the work order module to the fluid management system.

```sql
-- This table records every fluid consumed for a work order.
CREATE TABLE work_order_consumables (
    consumable_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    work_order_id INT UNSIGNED NOT NULL,
    product_id INT UNSIGNED NOT NULL,
    tank_id INT UNSIGNED NULL, -- NULL if dispensed from bulk storage, not a tank
    reel_id INT UNSIGNED NULL,  -- NULL if dispensed manually
    quantity_used DECIMAL(10, 2) UNSIGNED NOT NULL, -- Qty used in the product's unit_of_measure
    -- Optional: Snapshots of product details at the time of use for historical accuracy
    -- This denormalization is good practice in case product names or costs change later.
    snapshot_product_name VARCHAR(255) NOT NULL,
    snapshot_product_cost DECIMAL(10, 2) UNSIGNED NOT NULL,
    usage_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    FOREIGN KEY (work_order_id) REFERENCES work_orders(work_order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE RESTRICT,
    FOREIGN KEY (tank_id) REFERENCES tanks(tank_id) ON DELETE SET NULL,
    FOREIGN KEY (reel_id) REFERENCES reels(reel_id) ON DELETE SET NULL
);
```

#### 3. Modification to the Core `fluid_transactions` table

We need to link dispense transactions back to the work order that caused them. This is a classic example of the work order module *adding a relationship* to the core system.

```sql
-- First, drop the old table if it exists, then recreate it with the new column.
-- (In a real migration, you would use ALTER TABLE)
DROP TABLE IF EXISTS fluid_transactions;

CREATE TABLE fluid_transactions (
    transaction_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    transaction_type TINYINT UNSIGNED NOT NULL,
    product_id INT UNSIGNED NOT NULL,
    tank_id INT UNSIGNED NULL,
    reel_id INT UNSIGNED NULL,
    work_order_id INT UNSIGNED NULL, -- NEW: Link to the work order module
    quantity DECIMAL(10, 2) NOT NULL,
    volume_before DECIMAL(10, 2) UNSIGNED,
    volume_after DECIMAL(10, 2) UNSIGNED,
    source_or_destination VARCHAR(255),
    notes TEXT,
    user_id INT UNSIGNED,
    transaction_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (transaction_type) REFERENCES transaction_types(type_id) ON DELETE RESTRICT,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE RESTRICT,
    FOREIGN KEY (tank_id) REFERENCES tanks(tank_id) ON DELETE SET NULL,
    FOREIGN KEY (reel_id) REFERENCES reels(reel_id) ON DELETE SET NULL,
    FOREIGN KEY (work_order_id) REFERENCES work_orders(work_order_id) ON DELETE SET NULL -- New foreign key
);
```

---

### How the Module Works Together: A Practical Flow

**Scenario:** A technician needs to perform an oil change (Work Order #101) and use 5 quarts of 5W-30 oil from a tank with a reel.

1.  **Create Work Order:** The user creates a new record in the `work_orders` table. `external_id` might be left NULL if created internally, or populated with an ID from an external shop management system.
2.  **Dispense Fluid:**
    *   The technician uses the reel. The system records this action.
    *   A new record is inserted into the **`fluid_transactions`** table:
        *   `transaction_type`: `DISPENSE`
        *   `product_id`: `[ID of 5W-30 Oil]`
        *   `tank_id`: `[ID of the Oil Tank]`
        *   `reel_id`: `[ID of the Reel used]`
        *   `work_order_id`: `101` **<- This is the crucial link**
        *   `quantity`: `5.00`
        *   (`volume_before` and `volume_after` are calculated and stored)
3.  **Log Consumption for the Work Order:** *Alternatively, or in addition*, a record can be added to the **`work_order_consumables`** table. This acts as a direct bill of materials for the work order and is great for reporting.
    *   `work_order_id`: `101`
    *   `product_id`: `[ID of 5W-30 Oil]`
    *   `quantity_used`: `5.00`
    *   `snapshot_product_name`: `"5W-30 Full Synthetic Motor Oil"`
    *   `snapshot_product_cost`: `5.50`

### Benefits of This Design:

*   **Modular:** The core `products`, `tanks`, and `transactions` tables can exist and function perfectly without any work orders. The work order tables add meaning to the transactions.
*   **Flexible Data Entry:** Work orders can be created internally (`external_id` is NULL) or imported from an external system (populate `external_id`).
*   **Robust Tracking:** Fluid usage is tracked in two ways:
    1.  **Asset-Centric (`fluid_transactions`):** "How much fluid left this tank?"
    2.  **Job-Centric (`work_order_consumables`):** "How much fluid was used for this specific job?"
*   **Historical Accuracy:** The `snapshot_*` columns in `work_order_consumables` ensure that even if the product name or cost changes in the future, the historical record of what was used and what it cost *at that time* remains accurate for profitability analysis.
*   **Cascading Deletes:** Using `ON DELETE CASCADE` for `work_order_consumables` means if a work order is deleted, all its consumption records are automatically cleaned up. The `fluid_transactions` remain for audit purposes but their `work_order_id` is set to NULL (`ON DELETE SET NULL`).

This structure provides a powerful and flexible foundation for integrating work order management into your fluid tracking system.