# OilCop Fluid Management System Database Documentation

## Overview

The OilCop database is a comprehensive fluid management system designed for automotive dealerships and service centers. It manages users, physical infrastructure (stations, tanks, reels), dispensing operations, and provides robust audit logging and permission systems.

## Database Schema Capabilities

### 1. User Management & Authentication

#### Core Features:
- **Multi-tier user roles** (Administrator, Manager, Technician, Installer, etc.)
- **Granular capabilities** system with module-based permissions
- **Secure authentication** with password hashing and PIN-based station login
- **Account status management** (active, locked, expired)
- **Shift scheduling** and vacation/exception tracking

#### Key Tables:
- `users` - Core user information and credentials
- `roles` - Defined roles with descriptions
- `capabilities` - Individual permissions (e.g., 'tank.dispense', 'user.manage')
- `role_capabilities` - Links roles to specific capabilities
- `user_roles` - Assigns roles to users

#### Example API Usage (CodeIgniter4):
```php
// Check if user has specific capability
public function canUserDispense($userId, $tankId) {
    $userModel = new UserModel();
    return $userModel->userHasCapability($userId, 'tank.dispense');
}

// Get user's assigned stations
public function getUserStations($userId) {
    $db = Database::connect();
    return $db->table('user_station_permissions')
        ->join('stations', 'stations.station_id = user_station_permissions.station_id')
        ->where('user_id', $userId)
        ->where('can_access', true)
        ->get()
        ->getResult();
}
```

### 2. Physical Infrastructure Management

#### Core Features:
- **Station management** - Physical dispensing locations
- **Tank configuration** - Storage tanks with capacity and alert levels
- **Reel management** - Dispensing hardware with calibration data
- **Device tracking** - Hardware devices (CDM, PSM, TMM) with status monitoring
- **Sensor integration** - Tank level sensors with type and configuration

#### Key Tables:
- `stations` - Physical dispensing locations
- `tanks` - Fluid storage tanks with inventory levels
- `reels` - Dispensing hardware with calibration data
- `devices` - Hardware devices and their status
- `sensors` - Tank monitoring sensors

### 3. Permission System

#### Hierarchical Access Control:
1. **Global Role Capabilities** - System-wide permissions
2. **Station Access** - Which stations a user can access
3. **Tank Permissions** - Specific tanks a user can dispense from/override
4. **Reel Permissions** - Specific reels a user can operate

#### Example API Usage:
```php
// Check station access
public function canAccessStation($userId, $stationId) {
    return $this->db->table('user_station_permissions')
        ->where('user_id', $userId)
        ->where('station_id', $stationId)
        ->where('can_access', true)
        ->countAllResults() > 0;
}

// Get user's dispensable tanks
public function getUserTanks($userId) {
    return $this->db->table('user_tank_permissions')
        ->join('tanks', 'tanks.tank_id = user_tank_permissions.tank_id')
        ->join('products', 'products.product_id = tanks.product_id')
        ->where('user_tank_permissions.user_id', $userId)
        ->where('can_dispense', true)
        ->select('tanks.*, products.product_name')
        ->get()
        ->getResult();
}
```

### 4. Audit Logging & System Events

#### Core Features:
- **Comprehensive activity tracking** - All user actions and system events
- **Event categorization** - Info, warning, error, critical severity levels
- **Rich metadata storage** - JSON data for detailed event information
- **Foreign key relationships** - Links events to users, stations, tanks, devices

#### System Events Table (`system_events`):
The `event_code` field is used throughout the application to consistently identify types of events. This allows for:

1. ** Consistent Event Handling** - All parts of the application use the same event codes
2. **Easy Filtering** - Query events by type across the entire system
3. **Internationalization** - Event descriptions can be translated while keeping codes consistent
4. **API Integration** - External systems can reference events by their standardized codes

#### Event Code Structure:
- `module.action` - e.g., `user.login`, `tank.adjustment`, `device.online`
- **Modules**: `user`, `dispense`, `tank`, `device`, `system`
- **Actions**: `login`, `create`, `update`, `delete`, `start`, `complete`, `online`, `offline`

#### Example API Usage:
```php
// Log a system event
public function logEvent($eventCode, $userId = null, $data = []) {
    $event = $this->db->table('system_events')
        ->where('event_code', $eventCode)
        ->get()
        ->getRow();
    
    if ($event) {
        $logData = [
            'event_id' => $event->event_id,
            'user_id' => $userId,
            'description' => $event->event_name,
            'metadata' => json_encode($data),
            'ip_address' => $this->request->getIPAddress(),
            'user_agent' => $this->request->getUserAgent()
        ];
        
        // Add context-specific IDs if available
        if (isset($data['station_id'])) $logData['station_id'] = $data['station_id'];
        if (isset($data['tank_id'])) $logData['tank_id'] = $data['tank_id'];
        if (isset($data['reel_id'])) $logData['reel_id'] = $data['reel_id'];
        if (isset($data['device_id'])) $logData['device_id'] = $data['device_id'];
        
        $this->db->table('audit_log')->insert($logData);
    }
}

// Query events by type
public function getEventsByType($eventCode, $limit = 100) {
    return $this->db->table('audit_log')
        ->join('system_events', 'system_events.event_id = audit_log.event_id')
        ->join('users', 'users.user_id = audit_log.user_id', 'left')
        ->where('system_events.event_code', $eventCode)
        ->select('audit_log.*, system_events.event_name, users.username')
        ->orderBy('audit_log.event_timestamp', 'DESC')
        ->limit($limit)
        ->get()
        ->getResult();
}

// Get tank-related events
public function getTankHistory($tankId, $days = 30) {
    return $this->db->table('audit_log')
        ->join('system_events', 'system_events.event_id = audit_log.event_id')
        ->join('users', 'users.user_id = audit_log.user_id', 'left')
        ->where('audit_log.tank_id', $tankId)
        ->where('audit_log.event_timestamp >=', date('Y-m-d', strtotime("-$days days")))
        ->select('audit_log.*, system_events.event_name, users.username, users.first_name, users.last_name')
        ->orderBy('audit_log.event_timestamp', 'DESC')
        ->get()
        ->getResult();
}
```

### 5. Dispensing Operations

#### Core Features:
- **Work order integration** - Link dispensing to service work orders
- **Multiple dispense types** - Preset, open, topoff, adjustment, delivery
- **Inventory tracking** - Real-time volume updates with start/end levels
- **Transaction history** - Complete record of all fluid movements

#### Key Tables:
- `work_orders` - Service work orders
- `dispense_transactions` - Core dispensing records

### 6. Shift & Schedule Management

#### Core Features:
- **Flexible shift templates** - Define shift patterns and times
- **User scheduling** - Assign shifts to users with date ranges
- **Exception handling** - Vacations, sick leave, training periods
- **Access control** - Restrict login based on assigned shifts

## API Design Guidelines

### 1. Authentication Middleware
```php
// Example CodeIgniter4 Filter
class AuthFilter implements FilterInterface {
    public function before(RequestInterface $request, $arguments = null) {
        $userId = $this->validateToken($request->getHeader('Authorization'));
        if (!$userId) {
            return $this->failUnauthorized('Invalid or expired token');
        }
        
        // Check if user account is active and not locked
        $user = $this->userModel->find($userId);
        if (!$user->is_active || $user->is_locked) {
            return $this->failForbidden('Account disabled or locked');
        }
        
        $request->user = $user;
    }
}
```

### 2. Permission Checking
```php
// Base Controller with permission checking
class BaseApiController extends BaseController {
    protected function requireCapability($capabilityCode, $resourceId = null) {
        $userId = $this->request->user->user_id;
        
        if (!$this->permissionModel->hasCapability($userId, $capabilityCode)) {
            return $this->failForbidden('Insufficient permissions');
        }
        
        // Additional resource-specific checks if needed
        if ($resourceId && $capabilityCode === 'tank.dispense') {
            if (!$this->permissionModel->canDispenseFromTank($userId, $resourceId)) {
                return $this->failForbidden('Cannot dispense from this tank');
            }
        }
    }
}
```

### 3. Event Logging Pattern
```php
class DispenseController extends BaseApiController {
    public function startDispense() {
        $this->requireCapability('dispense.start');
        
        try {
            // Start dispense logic...
            
            // Log the event
            $this->auditLogger->logEvent('dispense.start', $this->request->user->user_id, [
                'station_id' => $stationId,
                'reel_id' => $reelId,
                'tank_id' => $tankId,
                'amount' => $amount,
                'work_order_id' => $workOrderId
            ]);
            
            return $this->respondCreated(['message' => 'Dispense started']);
            
        } catch (Exception $e) {
            $this->auditLogger->logEvent('dispense.failed', $this->request->user->user_id, [
                'error' => $e->getMessage(),
                'station_id' => $stationId
            ]);
            
            return $this->failServerError('Dispense failed: ' . $e->getMessage());
        }
    }
}
```

## Common API Endpoints Examples

### Authentication
```php
$routes->post('auth/login', 'Auth::login');
$routes->post('auth/logout', 'Auth::logout');
$routes->post('auth/refresh', 'Auth::refresh');
```

### User Management
```php
$routes->get('users', 'Users::index', ['filter' => 'auth:admin']);
$routes->get('users/(:num)', 'Users::show/$1', ['filter' => 'auth']);
$routes->post('users', 'Users::create', ['filter' => 'auth:admin']);
$routes->put('users/(:num)', 'Users::update/$1', ['filter' => 'auth:admin']);
```

### Dispensing Operations
```php
$routes->post('dispense/start', 'Dispense::start', ['filter' => 'auth:technician']);
$routes->post('dispense/stop', 'Dispense::stop', ['filter' => 'auth:technician']);
$routes->get('dispense/history', 'Dispense::history', ['filter' => 'auth']);
```

### Monitoring & Reports
```php
$routes->get('tanks/status', 'Tanks::status', ['filter' => 'auth']);
$routes->get('reports/usage', 'Reports::usage', ['filter' => 'auth:manager']);
$routes->get('audit/events', 'Audit::events', ['filter' => 'auth:admin']);
```

## Security Considerations

1. **Always validate permissions** at both role level and resource level
2. **Use parameterized queries** to prevent SQL injection
3. **Validate all input** especially for dispense amounts and configurations
4. **Log security-critical events** (logins, permission changes, configuration updates)
5. **Implement rate limiting** on authentication endpoints

This documentation provides a comprehensive overview of the database capabilities and how to build a CodeIgniter4 API that leverages the full power of the OilCop fluid management system.