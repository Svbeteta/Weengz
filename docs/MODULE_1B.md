# Module 1B - Database Design Documentation

## Overview

Module 1B implements the complete database design for the Weengz airline seat reservation system. This includes an Entity-Relationship (ER) diagram and a comprehensive PostgreSQL database schema with migrations, seed data, and documentation.

## Deliverables

1. ✅ ER Diagram (Mermaid format)
2. ✅ PostgreSQL Database Schema
3. ✅ Migration Scripts
4. ✅ Sample Data Seeds
5. ✅ Database Documentation
6. ✅ Setup Instructions

## Database Management System

**PostgreSQL 14+**
- Chosen for: ACID compliance, JSON support, advanced indexing, robust constraint system
- Features used: Triggers, Views, Custom Types, JSONB, Sequences

## Entity-Relationship Model

### Entities

#### 1. USERS
**Purpose:** Store registered user accounts

**Attributes:**
- `user_id` (PK, Serial)
- `email` (Unique, NOT NULL)
- `password_hash` (NOT NULL)
- `first_name` (NOT NULL)
- `last_name` (NOT NULL)
- `phone_number`
- `frequent_flyer_number` (Unique)
- `is_active` (Boolean, Default: TRUE)
- `created_at` (Timestamp)
- `updated_at` (Timestamp)

**Business Rules:**
- Email must be unique and valid format
- Passwords are hashed using bcrypt
- Frequent flyer numbers are optional but unique
- Inactive users cannot make new bookings

#### 2. AIRLINES
**Purpose:** Store airline company information

**Attributes:**
- `airline_id` (PK, Serial)
- `airline_name` (NOT NULL)
- `airline_code` (Unique, NOT NULL)
- `contact_email`
- `contact_phone`
- `created_at` (Timestamp)
- `updated_at` (Timestamp)

**Business Rules:**
- Airline codes must be unique (e.g., 'AA', 'UA')
- Each airline operates multiple flights

#### 3. FLIGHTS
**Purpose:** Store flight schedules and routes

**Attributes:**
- `flight_id` (PK, Serial)
- `flight_number` (Unique, NOT NULL)
- `airline_id` (FK → airlines)
- `departure_airport` (3-letter code)
- `arrival_airport` (3-letter code)
- `departure_time` (Timestamp with TZ)
- `arrival_time` (Timestamp with TZ)
- `status` (Enum: scheduled, delayed, cancelled, departed, arrived)
- `created_at` (Timestamp)
- `updated_at` (Timestamp)

**Business Rules:**
- Departure and arrival airports must be different
- Arrival time must be after departure time
- Flight numbers are unique across the system

#### 4. TRAVEL_CLASSES
**Purpose:** Define service tiers (Economy, Business, First)

**Attributes:**
- `travel_class_id` (PK, Serial)
- `class_name` (Unique, NOT NULL)
- `class_code` (NOT NULL)
- `description` (Text)
- `base_price` (Decimal, >= 0)
- `baggage_allowance` (Integer, >= 0)
- `has_meal_service` (Boolean)
- `has_priority_boarding` (Boolean)
- `created_at` (Timestamp)

**Business Rules:**
- Class names are unique
- Base prices must be non-negative
- Baggage allowance defaults to 1

#### 5. SEATS
**Purpose:** Individual seat inventory per flight

**Attributes:**
- `seat_id` (PK, Serial)
- `flight_id` (FK → flights)
- `seat_number` (NOT NULL)
- `travel_class_id` (FK → travel_classes)
- `is_available` (Boolean, Default: TRUE)
- `is_exit_row` (Boolean, Default: FALSE)
- `is_window` (Boolean, Default: FALSE)
- `is_aisle` (Boolean, Default: FALSE)
- `price_modifier` (Decimal, Default: 0.00)
- `created_at` (Timestamp)
- `updated_at` (Timestamp)

**Business Rules:**
- Seat numbers must be unique per flight
- Exit row seats have premium pricing
- Seats cascade delete with flights

#### 6. BOOKINGS
**Purpose:** Store reservation records

**Attributes:**
- `booking_id` (PK, Serial)
- `booking_reference` (Unique, Auto-generated)
- `user_id` (FK → users)
- `flight_id` (FK → flights)
- `seat_id` (FK → seats)
- `travel_class_id` (FK → travel_classes)
- `total_amount` (Decimal, > 0)
- `booking_status` (Enum: pending, confirmed, cancelled, completed)
- `booking_date` (Timestamp)
- `created_at` (Timestamp)
- `updated_at` (Timestamp)

**Business Rules:**
- Booking references are auto-generated (WNG-XXXXXX)
- Total amount must be positive
- Each booking reserves exactly one seat
- Bookings cannot be deleted (only cancelled)

#### 7. PAYMENTS
**Purpose:** Track payment transactions

**Attributes:**
- `payment_id` (PK, Serial)
- `booking_id` (FK → bookings)
- `user_id` (FK → users)
- `amount` (Decimal, > 0)
- `payment_method` (Enum: credit_card, debit_card, paypal, bank_transfer)
- `transaction_id` (Unique, NOT NULL)
- `payment_status` (Enum: pending, completed, failed, refunded)
- `payment_date` (Timestamp)
- `created_at` (Timestamp)

**Business Rules:**
- Transaction IDs are unique
- Payment amount must be positive
- One payment per booking
- Failed payments can be retried

#### 8. AUDIT_LOGS
**Purpose:** Maintain audit trail

**Attributes:**
- `log_id` (PK, Serial)
- `user_id` (FK → users, nullable)
- `action` (NOT NULL: INSERT, UPDATE, DELETE)
- `table_name` (NOT NULL)
- `record_id` (NOT NULL)
- `old_values` (JSONB)
- `new_values` (JSONB)
- `created_at` (Timestamp)

**Business Rules:**
- Append-only (no updates or deletes)
- Stores complete record state in JSON
- Used for compliance and debugging

### Relationships

1. **Users → Bookings** (1:N)
   - One user can make multiple bookings
   - Cascade: RESTRICT (preserve user data)

2. **Users → Payments** (1:N)
   - One user can make multiple payments
   - Cascade: RESTRICT

3. **Airlines → Flights** (1:N)
   - One airline operates multiple flights
   - Cascade: RESTRICT

4. **Flights → Bookings** (1:N)
   - One flight can have multiple bookings
   - Cascade: RESTRICT

5. **Flights → Seats** (1:N)
   - One flight has multiple seats
   - Cascade: CASCADE (seats deleted with flight)

6. **Travel Classes → Seats** (1:N)
   - One class includes multiple seats
   - Cascade: RESTRICT

7. **Travel Classes → Bookings** (1:N)
   - One class categorizes multiple bookings
   - Cascade: RESTRICT

8. **Bookings → Seats** (N:1)
   - Many bookings reference seats
   - Cascade: RESTRICT

9. **Bookings → Payments** (1:1)
   - Each booking has one payment
   - Cascade: RESTRICT

## Schema Features

### Custom Types (Enums)

```sql
CREATE TYPE booking_status_enum AS ENUM (
    'pending', 'confirmed', 'cancelled', 'completed'
);

CREATE TYPE payment_status_enum AS ENUM (
    'pending', 'completed', 'failed', 'refunded'
);

CREATE TYPE flight_status_enum AS ENUM (
    'scheduled', 'delayed', 'cancelled', 'departed', 'arrived'
);

CREATE TYPE payment_method_enum AS ENUM (
    'credit_card', 'debit_card', 'paypal', 'bank_transfer'
);
```

### Indexes

**Purpose:** Optimize query performance

**Implemented Indexes:**
1. Primary key indexes (automatic)
2. Foreign key indexes
3. Unique constraint indexes
4. Email and frequent flyer lookups
5. Flight number and date searches
6. Booking reference lookups
7. Partial indexes for available seats

### Constraints

1. **Primary Keys:** All tables have auto-incrementing PKs
2. **Foreign Keys:** Referential integrity enforced
3. **Unique Constraints:** Email, booking references, etc.
4. **Check Constraints:**
   - Email format validation
   - Positive amounts
   - Valid date ranges
   - Airport codes differ
5. **Not Null:** Required fields enforced

### Triggers

#### 1. Updated At Trigger
**Purpose:** Automatically update `updated_at` timestamps

**Applied to:**
- users
- airlines
- flights
- seats
- bookings

**Implementation:**
```sql
CREATE TRIGGER update_users_updated_at 
BEFORE UPDATE ON users
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
```

#### 2. Audit Trigger (Future)
**Purpose:** Automatically log data changes

**Note:** Framework provided, not fully implemented to avoid overhead

### Views

#### 1. booking_summary
**Purpose:** Comprehensive booking information

**Columns:**
- All booking details
- User information
- Flight details
- Seat information
- Payment status

**Usage:**
```sql
SELECT * FROM booking_summary 
WHERE user_email = 'john.doe@example.com'
ORDER BY booking_date DESC;
```

#### 2. available_seats
**Purpose:** Show available seats across all flights

**Columns:**
- Seat details
- Flight information
- Travel class
- Seat characteristics

**Usage:**
```sql
SELECT * FROM available_seats 
WHERE flight_number = 'AA1234'
ORDER BY class_name, seat_number;
```

## Database Files

### 1. Migration: 001_initial_schema.sql
**Size:** ~11 KB  
**Purpose:** Create all tables, types, constraints, indexes, triggers, and views

**Sections:**
1. Extensions and types
2. Table creation
3. Index creation
4. Trigger functions
5. Trigger application
6. View creation
7. Comments

### 2. Seed: 001_sample_data.sql
**Size:** ~6 KB  
**Purpose:** Populate database with test data

**Data Included:**
- 4 Airlines
- 4 Travel Classes
- 5 Users
- 5 Flights
- 36 Seats (Flight AA1234)
- 6 Seats (Flight UA5678)
- 2 Sample Bookings
- 2 Payments
- 2 Audit Log entries

### 3. Documentation: er-diagram.md
**Format:** Mermaid ER Diagram  
**Purpose:** Visual representation of database structure

**Includes:**
- Entity definitions
- Relationship descriptions
- Business rules
- Cardinality specifications

### 4. Setup Guide: database/README.md
**Purpose:** Complete database setup and maintenance guide

**Sections:**
- Prerequisites
- Installation
- Migration steps
- Common operations
- Backup/restore
- Performance monitoring
- Security considerations

## Normalization

### Third Normal Form (3NF)

**1NF (First Normal Form):**
- ✅ All attributes contain atomic values
- ✅ No repeating groups
- ✅ Each row is unique (PKs defined)

**2NF (Second Normal Form):**
- ✅ In 1NF
- ✅ No partial dependencies
- ✅ All non-key attributes depend on entire PK

**3NF (Third Normal Form):**
- ✅ In 2NF
- ✅ No transitive dependencies
- ✅ Non-key attributes depend only on PK

**Example:**
- ❌ Bad: Store airline_name in flights table
- ✅ Good: Store airline_id (FK) and join to airlines table

## Data Integrity

### Referential Integrity
- Foreign keys enforce valid relationships
- Cascade rules prevent orphaned records
- RESTRICT on critical data (users, bookings)
- CASCADE on dependent data (seats with flights)

### Domain Integrity
- Check constraints validate data ranges
- Enums restrict values to valid options
- Not null ensures required data
- Default values provide sensible fallbacks

### Entity Integrity
- Primary keys guarantee uniqueness
- Auto-increment prevents conflicts
- Unique constraints on business keys

## Performance Considerations

### Index Strategy
- Index foreign keys for joins
- Index frequently searched columns
- Partial indexes for common filters
- Avoid over-indexing (write performance)

### Query Optimization
- Views pre-join common queries
- Indexes support WHERE clauses
- Timestamps for time-based queries
- Proper data types (no TEXT for codes)

### Scalability
- Partitioning (future): By date/airline
- Archiving: Move old bookings
- Connection pooling: For applications
- Read replicas: For reporting

## Security

### Access Control
```sql
-- Create application user
CREATE USER weengz_app WITH PASSWORD 'secure_password';

-- Grant minimal privileges
GRANT SELECT, INSERT, UPDATE ON ALL TABLES TO weengz_app;
GRANT USAGE ON ALL SEQUENCES TO weengz_app;

-- Revoke DELETE on critical tables
REVOKE DELETE ON bookings, payments FROM weengz_app;
```

### Data Protection
- Passwords stored as hashes (bcrypt)
- PII in dedicated fields
- Audit logging for compliance
- SSL/TLS for connections

### Compliance
- GDPR: User data can be exported/deleted
- PCI DSS: Payment data properly isolated
- Audit trail: Complete change history
- Data retention: Configurable policies

## Testing

### Schema Validation
```sql
-- Check all tables exist
SELECT tablename FROM pg_tables WHERE schemaname = 'public';

-- Verify constraints
SELECT conname, contype FROM pg_constraint 
WHERE conrelid = 'bookings'::regclass;

-- Test foreign keys
INSERT INTO bookings (user_id, ...) VALUES (99999, ...);
-- Should fail with FK violation
```

### Data Validation
```sql
-- Test check constraints
INSERT INTO flights (departure_airport, arrival_airport, ...)
VALUES ('JFK', 'JFK', ...);
-- Should fail: airports must differ

-- Test unique constraints
INSERT INTO users (email, ...) VALUES ('existing@email.com', ...);
-- Should fail: email already exists
```

### Performance Testing
```sql
-- Explain query plans
EXPLAIN ANALYZE SELECT * FROM booking_summary 
WHERE user_email = 'test@example.com';

-- Check index usage
SELECT schemaname, tablename, indexname, idx_scan
FROM pg_stat_user_indexes
ORDER BY idx_scan DESC;
```

## Acceptance Criteria

### Module 1B is complete when:

1. ✅ ER diagram created and documented
2. ✅ All 8 tables defined with proper structure
3. ✅ Relationships properly established with FKs
4. ✅ Constraints enforce business rules
5. ✅ Indexes optimize common queries
6. ✅ Custom types define valid values
7. ✅ Triggers maintain data integrity
8. ✅ Views simplify common queries
9. ✅ Migration scripts execute successfully
10. ✅ Sample data loads correctly
11. ✅ Documentation is comprehensive
12. ✅ Database can be set up from scratch

## Maintenance

### Regular Tasks
- Update statistics: `ANALYZE;`
- Vacuum tables: `VACUUM ANALYZE;`
- Reindex: `REINDEX TABLE table_name;`
- Monitor size: Check `pg_total_relation_size()`
- Archive old data: Move completed bookings

### Monitoring
- Query performance: pg_stat_statements
- Index usage: pg_stat_user_indexes
- Table sizes: pg_total_relation_size()
- Lock conflicts: pg_locks
- Connection count: pg_stat_activity

## Future Enhancements

1. **Partitioning**
   - Partition bookings by date
   - Partition audit_logs by month

2. **Additional Tables**
   - seat_map_templates (reusable layouts)
   - flight_schedule (recurring flights)
   - user_preferences
   - notifications

3. **Advanced Features**
   - Full-text search for flights
   - Spatial data for airports
   - Time-series data for analytics
   - Graph data for route optimization

4. **Performance**
   - Materialized views
   - Query caching
   - Read replicas
   - Sharding strategy

## Troubleshooting

### Common Issues

1. **Migration Fails**
   - Check PostgreSQL version (14+)
   - Verify user permissions
   - Review error messages
   - Check for existing objects

2. **Constraint Violations**
   - Review business rules
   - Check foreign key references
   - Validate data formats
   - Ensure required fields

3. **Performance Issues**
   - Run ANALYZE
   - Check index usage
   - Review query plans
   - Monitor resources

## Resources

- Database Schema: `database/migrations/001_initial_schema.sql`
- Sample Data: `database/seeds/001_sample_data.sql`
- ER Diagram: `database/diagrams/er-diagram.md`
- Setup Guide: `database/README.md`

---

**Module Status:** ✅ Complete  
**Version:** 1.0.0  
**Last Updated:** October 2025  
**Schema Version:** 001
