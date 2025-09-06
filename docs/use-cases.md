# OilCop Fluid Management System - Comprehensive Use Cases

## Authentication & User Management

### 1. User Authentication
- **UC-001**: User login with username/password
- **UC-002**: User logout (manual and automatic timeout)
- **UC-003**: PIN-based quick login at dispensing stations
- **UC-004**: Failed login attempt tracking and account lockout
- **UC-005**: Password reset and recovery process

### 2. User Account Management
- **UC-006**: Create new user accounts with assigned roles
- **UC-007**: Modify user information and permissions
- **UC-008**: Deactivate/reactivate user accounts
- **UC-009**: Set account expiration dates
- **UC-010**: View user login history and activity

### 3. Role and Permission Management
- **UC-011**: Create and modify system roles
- **UC-012**: Assign capabilities to roles
- **UC-013**: Assign roles to users
- **UC-014**: View permission hierarchy and assignments

## Physical Infrastructure Management

### 4. Station Management
- **UC-015**: Create and configure dispensing stations
- **UC-016**: Assign stations to physical locations
- **UC-017**: Enable/disable stations for maintenance
- **UC-018**: Set station priorities and display order

### 5. Tank Management
- **UC-019**: Add new fluid storage tanks to system
- **UC-020**: Configure tank physical properties (shape, dimensions)
- **UC-021**: Set tank capacity and calibration data
- **UC-022**: Configure alert levels (high, low, reorder, shutoff)
- **UC-023**: Assign products to tanks
- **UC-024**: Map tanks to serving stations

### 6. Product Management
- **UC-025**: Add new fluid products to inventory
- **UC-026**: Set product properties (specific gravity, viscosity)
- **UC-027**: Configure dispensing limits per product
- **UC-028**: Mark products as collection-only

### 7. Reel and Hardware Management
- **UC-029**: Configure dispensing reels with calibration data
- **UC-030**: Assign reels to stations and tanks
- **UC-031**: Manage hardware devices (CDM, PSM, TMM units)
- **UC-032**: Track device status and connectivity
- **UC-033**: Configure RF frequencies and communication settings

### 8. Sensor Management
- **UC-034**: Configure tank level sensors
- **UC-035**: Set sensor types and calibration data
- **UC-036**: Monitor sensor health and status

## Dispensing Operations

### 9. Work Order Management
- **UC-037**: Create new service work orders
- **UC-038**: Assign products and amounts to work orders
- **UC-039**: Track work order status (open, in progress, completed, closed)
- **UC-040**: Link dispensing transactions to work orders

### 10. Preset Dispensing
- **UC-041**: Select preset amount for dispensing
- **UC-042**: Initiate preset dispense operation
- **UC-043**: Monitor dispense progress in real-time
- **UC-044**: Complete dispense and record transaction
- **UC-045**: Handle preset dispense interruptions and errors

### 11. Open/Free Dispensing
- **UC-046**: Initiate open dispense without preset amount
- **UC-047**: Monitor and control dispense in real-time
- **UC-048**: Stop dispense manually or by limit
- **UC-049**: Record open dispense transactions

### 12. Top-off Dispensing
- **UC-050**: Automatic top-off to complete partial amounts
- **UC-051**: Manual top-off operations
- **UC-052**: Track top-off transactions

### 13. Emergency Operations
- **UC-053**: Emergency stop during dispensing
- **UC-054**: System-wide emergency shutdown
- **UC-055**: Post-emergency recovery and reporting

## Inventory Management

### 14. Inventory Tracking
- **UC-056**: Real-time tank level monitoring
- **UC-057**: Automatic inventory deduction during dispensing
- **UC-058**: Manual inventory adjustments
- **UC-059**: Delivery receipt and inventory addition

### 15. Alert Management
- **UC-060**: High level alerts and warnings
- **UC-061**: Low inventory/reorder alerts
- **UC-062**: Critical/shutoff level alerts
- **UC-063**: Device offline/communication alerts
- **UC-064**: Alert acknowledgment and resolution

### 16. Inventory Reporting
- **UC-065**: Current inventory status dashboard
- **UC-066**: Inventory usage reports by period
- **UC-067**: Product usage analysis
- **UC-068**: Reorder recommendations and planning

## Access Control & Permissions

### 17. Station Access Control
- **UC-069**: Grant/revoke station access to users
- **UC-070**: Check station access permissions
- **UC-071**: View station access logs

### 18. Tank Access Control
- **UC-072**: Grant dispensing permissions for specific tanks
- **UC-073**: Grant override permissions for tank limits
- **UC-074**: Restrict tank access by user/role

### 19. Reel Access Control
- **UC-075**: Assign reel usage permissions
- **UC-076**: Control access to specific dispensing hardware

## Scheduling & Shift Management

### 20. Shift Configuration
- **UC-077**: Define shift templates (morning, evening, night)
- **UC-078**: Set shift times and overnight configurations

### 21. User Scheduling
- **UC-079**: Assign shifts to users
- **UC-080**: Set schedule validity periods
- **UC-081**: View user schedules and coverage

### 22. Exception Management
- **UC-082**: Request time off/vacation
- **UC-083**: Approve/deny schedule exceptions
- **UC-084**: Manage training and leave periods

### 23. Access Based on Schedule
- **UC-085**: Restrict login based on assigned shifts
- **UC-086**: Handle schedule exceptions and overrides
- **UC-087**: View schedule compliance reports

## Reporting & Analytics

### 24. Operational Reports
- **UC-088**: Dispensing transaction reports
- **UC-089**: User activity reports
- **UC-090**: Work order completion reports
- **UC-091**: Station utilization reports

### 25. Inventory Reports
- **UC-092**: Tank level history reports
- **UC-093**: Product usage reports
- **UC-094**: Inventory adjustment reports
- **UC-095**: Delivery and receipt reports

### 26. Maintenance Reports
- **UC-096**: Device status and uptime reports
- **UC-097**: Sensor calibration history
- **UC-098**: Maintenance scheduling reports

### 27. Audit & Compliance
- **UC-099**: System event and audit logs
- **UC-100**: User action tracking reports
- **UC-101**: Compliance and regulatory reports
- **UC-102**: Data export for external systems

## System Administration

### 28. Configuration Management
- **UC-103**: System-wide configuration settings
- **UC-104**: Network configuration for devices
- **UC-105**: Email and notification settings
- **UC-106**: Unit system configuration (imperial/metric)

### 29. Device Management
- **UC-107**: Add new hardware devices to system
- **UC-108**: Configure device communication settings
- **UC-109**: Monitor device status and health
- **UC-110**: Update device firmware and configurations

### 30. Backup and Maintenance
- **UC-111**: System data backup procedures
- **UC-112**: Database maintenance and optimization
- **UC-113**: System log management and rotation
- **UC-114**: System update and patch management

## Integration & External Systems

### 31. API Integration
- **UC-115**: REST API for external system integration
- **UC-116**: Real-time data feeds for monitoring systems
- **UC-117**: Automated data export processes

### 32. Email and Notification
- **UC-118**: Automated email alerts for system events
- **UC-119**: Scheduled report distribution
- **UC-120**: Notification acknowledgment tracking

### 33. External Hardware Integration
- **UC-121**: Integration with barcode scanners
- **UC-122**: Printer integration for labels and receipts
- **UC-123**: Integration with external monitoring systems

## Mobile & Remote Access

### 34. Mobile Application
- **UC-124**: Mobile dashboard for system monitoring
- **UC-125**: Remote dispensing authorization
- **UC-126**: Mobile alert notifications
- **UC-127**: Remote inventory checking

### 35. Remote Management
- **UC-128**: Web-based remote administration
- **UC-129**: Remote troubleshooting and support
- **UC-130**: Off-site monitoring and reporting

## Emergency & Disaster Recovery

### 36. System Recovery
- **UC-131**: System failure recovery procedures
- **UC-132**: Data restoration from backups
- **UC-133**: Emergency operation modes

### 37. Business Continuity
- **UC-134**: Manual operation procedures
- **UC-135**: Offline data collection
- **UC-136**: System redundancy and failover

## Compliance & Regulatory

### 38. Regulatory Compliance
- **UC-137**: Environmental compliance reporting
- **UC-138**: Safety regulation compliance
- **UC-139**: Audit trail maintenance
- **UC-140**: Data retention policy enforcement

### 39. Quality Assurance
- **UC-141**: Dispensing accuracy validation
- **UC-142**: Calibration certification tracking
- **UC-143**: Quality control reporting

This comprehensive list of use cases demonstrates the extensive capabilities of the OilCop Fluid Management System, covering everything from basic dispensing operations to advanced reporting, compliance, and system integration features.