# Weengz Database Setup Guide

## Overview
This guide provides instructions for setting up and managing the PostgreSQL database for the Weengz airline seat reservation system.

## Prerequisites

- PostgreSQL 14 or higher
- `psql` command-line tool
- Appropriate database permissions

## Database Setup

### 1. Create Database

```bash
# Connect to PostgreSQL as superuser
psql -U postgres

# Create the database
CREATE DATABASE weengz;

# Create application user (optional but recommended)
CREATE USER weengz_app WITH PASSWORD 'your_secure_password';

# Grant privileges
GRANT ALL PRIVILEGES ON DATABASE weengz TO weengz_app;

# Connect to the database
\c weengz

# Grant schema privileges
GRANT ALL ON SCHEMA public TO weengz_app;
```

### 2. Run Migrations

```bash
# Navigate to the project directory
cd /path/to/Weengz

# Apply the initial schema
psql -U weengz_app -d weengz -f database/migrations/001_initial_schema.sql
```

### 3. Load Sample Data (Development/Testing)

```bash
# Load seed data
psql -U weengz_app -d weengz -f database/seeds/001_sample_data.sql
```

## Database Structure

### Tables

1. **airlines** - Airline company information
2. **users** - Registered system users
3. **travel_classes** - Travel class definitions (Economy, Business, First, etc.)
4. **flights** - Flight schedules and routes
5. **seats** - Individual seats for each flight
6. **bookings** - Flight reservations
7. **payments** - Payment transactions
8. **audit_logs** - System audit trail

### Custom Types

- `booking_status_enum`: pending, confirmed, cancelled, completed
- `payment_status_enum`: pending, completed, failed, refunded
- `flight_status_enum`: scheduled, delayed, cancelled, departed, arrived
- `payment_method_enum`: credit_card, debit_card, paypal, bank_transfer

### Views

1. **booking_summary** - Comprehensive booking information with joins
2. **available_seats** - Currently available seats across all flights

## Common Operations

### Check Database Status

```sql
-- List all tables
\dt

-- Describe a table structure
\d+ users

-- Check record counts
SELECT 
    'users' as table_name, COUNT(*) as count FROM users
UNION ALL
SELECT 'flights', COUNT(*) FROM flights
UNION ALL
SELECT 'bookings', COUNT(*) FROM bookings;
```

### Query Examples

```sql
-- Get all available flights
SELECT 
    f.flight_number,
    a.airline_name,
    f.departure_airport,
    f.arrival_airport,
    f.departure_time,
    f.arrival_time,
    f.status
FROM flights f
JOIN airlines a ON f.airline_id = a.airline_id
WHERE f.status = 'scheduled'
ORDER BY f.departure_time;

-- Get available seats for a specific flight
SELECT * FROM available_seats 
WHERE flight_number = 'AA1234'
ORDER BY class_name, seat_number;

-- Get user booking history
SELECT * FROM booking_summary
WHERE user_email = 'john.doe@example.com'
ORDER BY booking_date DESC;

-- Get flight occupancy statistics
SELECT 
    f.flight_number,
    COUNT(s.seat_id) as total_seats,
    COUNT(CASE WHEN s.is_available = FALSE THEN 1 END) as booked_seats,
    COUNT(CASE WHEN s.is_available = TRUE THEN 1 END) as available_seats,
    ROUND(100.0 * COUNT(CASE WHEN s.is_available = FALSE THEN 1 END) / COUNT(s.seat_id), 2) as occupancy_rate
FROM flights f
LEFT JOIN seats s ON f.flight_id = s.flight_id
WHERE f.flight_id = 1
GROUP BY f.flight_number;
```

## Backup and Restore

### Create Backup

```bash
# Full database backup
pg_dump -U weengz_app weengz > weengz_backup_$(date +%Y%m%d).sql

# Backup with compression
pg_dump -U weengz_app weengz | gzip > weengz_backup_$(date +%Y%m%d).sql.gz

# Backup specific tables
pg_dump -U weengz_app -t bookings -t payments weengz > bookings_backup.sql
```

### Restore from Backup

```bash
# Restore from SQL file
psql -U weengz_app weengz < weengz_backup_20251022.sql

# Restore from compressed backup
gunzip -c weengz_backup_20251022.sql.gz | psql -U weengz_app weengz
```

## Maintenance

### Update Statistics

```sql
-- Analyze all tables
ANALYZE;

-- Vacuum and analyze
VACUUM ANALYZE;

-- Reindex a table
REINDEX TABLE bookings;
```

### Monitor Performance

```sql
-- Check table sizes
SELECT 
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;

-- Check index usage
SELECT 
    schemaname,
    tablename,
    indexname,
    idx_scan,
    idx_tup_read,
    idx_tup_fetch
FROM pg_stat_user_indexes
ORDER BY idx_scan DESC;
```

## Security Considerations

1. **Password Management**
   - Use strong passwords for database users
   - Store passwords in environment variables, not in code
   - Rotate passwords regularly

2. **Access Control**
   - Grant minimum necessary privileges
   - Use separate users for different application components
   - Regularly audit user permissions

3. **Data Protection**
   - Enable SSL/TLS for database connections
   - Encrypt sensitive data at rest
   - Implement row-level security where appropriate

4. **Audit Logging**
   - The `audit_logs` table tracks all data changes
   - Review audit logs regularly
   - Set up alerts for suspicious activities

## Troubleshooting

### Connection Issues

```bash
# Test connection
psql -U weengz_app -d weengz -h localhost

# Check PostgreSQL is running
sudo systemctl status postgresql

# View PostgreSQL logs
sudo tail -f /var/log/postgresql/postgresql-14-main.log
```

### Common Errors

1. **"relation does not exist"**
   - Ensure migrations have been run
   - Check schema search path

2. **"permission denied"**
   - Verify user privileges
   - Check object ownership

3. **"duplicate key value"**
   - Check for unique constraint violations
   - Verify data integrity

## Environment Configuration

Create a `.env` file with database credentials:

```env
DB_HOST=localhost
DB_PORT=5432
DB_NAME=weengz
DB_USER=weengz_app
DB_PASSWORD=your_secure_password
DB_SSL=false
```

**Note:** Never commit `.env` files to version control!

## Next Steps

1. Set up database connection pooling
2. Implement automated backups
3. Configure monitoring and alerting
4. Set up replication for high availability
5. Optimize queries based on usage patterns

## Resources

- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [PostgreSQL Performance Tuning](https://wiki.postgresql.org/wiki/Performance_Optimization)
- [Database Security Best Practices](https://www.postgresql.org/docs/current/security.html)
