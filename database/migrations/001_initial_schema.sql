-- Weengz Database Schema
-- PostgreSQL 14+
-- Migration: 001_initial_schema.sql

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create custom types
CREATE TYPE booking_status_enum AS ENUM ('pending', 'confirmed', 'cancelled', 'completed');
CREATE TYPE payment_status_enum AS ENUM ('pending', 'completed', 'failed', 'refunded');
CREATE TYPE flight_status_enum AS ENUM ('scheduled', 'delayed', 'cancelled', 'departed', 'arrived');
CREATE TYPE payment_method_enum AS ENUM ('credit_card', 'debit_card', 'paypal', 'bank_transfer');

-- AIRLINES Table
CREATE TABLE airlines (
    airline_id SERIAL PRIMARY KEY,
    airline_name VARCHAR(100) NOT NULL,
    airline_code VARCHAR(10) UNIQUE NOT NULL,
    contact_email VARCHAR(255),
    contact_phone VARCHAR(20),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_airlines_code ON airlines(airline_code);

-- USERS Table
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20),
    frequent_flyer_number VARCHAR(50) UNIQUE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT email_format CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_frequent_flyer ON users(frequent_flyer_number) WHERE frequent_flyer_number IS NOT NULL;
CREATE INDEX idx_users_active ON users(is_active);

-- TRAVEL_CLASSES Table
CREATE TABLE travel_classes (
    travel_class_id SERIAL PRIMARY KEY,
    class_name VARCHAR(50) UNIQUE NOT NULL,
    class_code VARCHAR(10) NOT NULL,
    description TEXT,
    base_price DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    baggage_allowance INTEGER DEFAULT 1,
    has_meal_service BOOLEAN DEFAULT FALSE,
    has_priority_boarding BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT positive_base_price CHECK (base_price >= 0),
    CONSTRAINT positive_baggage CHECK (baggage_allowance >= 0)
);

CREATE INDEX idx_travel_classes_code ON travel_classes(class_code);

-- FLIGHTS Table
CREATE TABLE flights (
    flight_id SERIAL PRIMARY KEY,
    flight_number VARCHAR(20) UNIQUE NOT NULL,
    airline_id INTEGER NOT NULL,
    departure_airport VARCHAR(3) NOT NULL,
    arrival_airport VARCHAR(3) NOT NULL,
    departure_time TIMESTAMP WITH TIME ZONE NOT NULL,
    arrival_time TIMESTAMP WITH TIME ZONE NOT NULL,
    status flight_status_enum DEFAULT 'scheduled',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (airline_id) REFERENCES airlines(airline_id) ON DELETE RESTRICT,
    CONSTRAINT valid_airports CHECK (departure_airport != arrival_airport),
    CONSTRAINT valid_times CHECK (arrival_time > departure_time)
);

CREATE INDEX idx_flights_number ON flights(flight_number);
CREATE INDEX idx_flights_airline ON flights(airline_id);
CREATE INDEX idx_flights_departure ON flights(departure_airport, departure_time);
CREATE INDEX idx_flights_arrival ON flights(arrival_airport, arrival_time);
CREATE INDEX idx_flights_status ON flights(status);

-- SEATS Table
CREATE TABLE seats (
    seat_id SERIAL PRIMARY KEY,
    flight_id INTEGER NOT NULL,
    seat_number VARCHAR(10) NOT NULL,
    travel_class_id INTEGER NOT NULL,
    is_available BOOLEAN DEFAULT TRUE,
    is_exit_row BOOLEAN DEFAULT FALSE,
    is_window BOOLEAN DEFAULT FALSE,
    is_aisle BOOLEAN DEFAULT FALSE,
    price_modifier DECIMAL(10, 2) DEFAULT 0.00,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (flight_id) REFERENCES flights(flight_id) ON DELETE CASCADE,
    FOREIGN KEY (travel_class_id) REFERENCES travel_classes(travel_class_id) ON DELETE RESTRICT,
    CONSTRAINT unique_seat_per_flight UNIQUE (flight_id, seat_number)
);

CREATE INDEX idx_seats_flight ON seats(flight_id);
CREATE INDEX idx_seats_class ON seats(travel_class_id);
CREATE INDEX idx_seats_availability ON seats(is_available) WHERE is_available = TRUE;

-- BOOKINGS Table
CREATE TABLE bookings (
    booking_id SERIAL PRIMARY KEY,
    booking_reference VARCHAR(20) UNIQUE NOT NULL DEFAULT ('WNG-' || LPAD(nextval('bookings_booking_id_seq')::TEXT, 6, '0')),
    user_id INTEGER NOT NULL,
    flight_id INTEGER NOT NULL,
    seat_id INTEGER NOT NULL,
    travel_class_id INTEGER NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    booking_status booking_status_enum DEFAULT 'pending',
    booking_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE RESTRICT,
    FOREIGN KEY (flight_id) REFERENCES flights(flight_id) ON DELETE RESTRICT,
    FOREIGN KEY (seat_id) REFERENCES seats(seat_id) ON DELETE RESTRICT,
    FOREIGN KEY (travel_class_id) REFERENCES travel_classes(travel_class_id) ON DELETE RESTRICT,
    CONSTRAINT positive_amount CHECK (total_amount >= 0)
);

CREATE INDEX idx_bookings_reference ON bookings(booking_reference);
CREATE INDEX idx_bookings_user ON bookings(user_id);
CREATE INDEX idx_bookings_flight ON bookings(flight_id);
CREATE INDEX idx_bookings_status ON bookings(booking_status);
CREATE INDEX idx_bookings_date ON bookings(booking_date);

-- PAYMENTS Table
CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    booking_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_method payment_method_enum NOT NULL,
    transaction_id VARCHAR(100) UNIQUE NOT NULL,
    payment_status payment_status_enum DEFAULT 'pending',
    payment_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE RESTRICT,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE RESTRICT,
    CONSTRAINT positive_payment CHECK (amount > 0)
);

CREATE INDEX idx_payments_booking ON payments(booking_id);
CREATE INDEX idx_payments_user ON payments(user_id);
CREATE INDEX idx_payments_transaction ON payments(transaction_id);
CREATE INDEX idx_payments_status ON payments(payment_status);

-- AUDIT_LOGS Table
CREATE TABLE audit_logs (
    log_id SERIAL PRIMARY KEY,
    user_id INTEGER,
    action VARCHAR(50) NOT NULL,
    table_name VARCHAR(100) NOT NULL,
    record_id VARCHAR(50) NOT NULL,
    old_values JSONB,
    new_values JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL
);

CREATE INDEX idx_audit_logs_user ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_table ON audit_logs(table_name);
CREATE INDEX idx_audit_logs_action ON audit_logs(action);
CREATE INDEX idx_audit_logs_created ON audit_logs(created_at);

-- Create trigger function for updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply updated_at trigger to tables
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_airlines_updated_at BEFORE UPDATE ON airlines
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_flights_updated_at BEFORE UPDATE ON flights
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_seats_updated_at BEFORE UPDATE ON seats
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_bookings_updated_at BEFORE UPDATE ON bookings
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Create audit trigger function
CREATE OR REPLACE FUNCTION audit_trigger_function()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO audit_logs (user_id, action, table_name, record_id, new_values)
        VALUES (
            CASE WHEN NEW.user_id IS NOT NULL THEN NEW.user_id ELSE NULL END,
            'INSERT',
            TG_TABLE_NAME,
            NEW.id::TEXT,
            row_to_json(NEW)
        );
        RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO audit_logs (user_id, action, table_name, record_id, old_values, new_values)
        VALUES (
            CASE WHEN NEW.user_id IS NOT NULL THEN NEW.user_id ELSE NULL END,
            'UPDATE',
            TG_TABLE_NAME,
            NEW.id::TEXT,
            row_to_json(OLD),
            row_to_json(NEW)
        );
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO audit_logs (user_id, action, table_name, record_id, old_values)
        VALUES (
            CASE WHEN OLD.user_id IS NOT NULL THEN OLD.user_id ELSE NULL END,
            'DELETE',
            TG_TABLE_NAME,
            OLD.id::TEXT,
            row_to_json(OLD)
        );
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Create views for reporting
CREATE VIEW booking_summary AS
SELECT 
    b.booking_id,
    b.booking_reference,
    u.email AS user_email,
    u.first_name || ' ' || u.last_name AS passenger_name,
    f.flight_number,
    f.departure_airport,
    f.arrival_airport,
    f.departure_time,
    s.seat_number,
    tc.class_name,
    b.total_amount,
    b.booking_status,
    p.payment_status,
    b.booking_date
FROM bookings b
JOIN users u ON b.user_id = u.user_id
JOIN flights f ON b.flight_id = f.flight_id
JOIN seats s ON b.seat_id = s.seat_id
JOIN travel_classes tc ON b.travel_class_id = tc.travel_class_id
LEFT JOIN payments p ON b.booking_id = p.booking_id;

-- Create view for available seats
CREATE VIEW available_seats AS
SELECT 
    s.seat_id,
    s.seat_number,
    f.flight_number,
    f.departure_airport,
    f.arrival_airport,
    f.departure_time,
    tc.class_name,
    s.is_exit_row,
    s.is_window,
    s.is_aisle
FROM seats s
JOIN flights f ON s.flight_id = f.flight_id
JOIN travel_classes tc ON s.travel_class_id = tc.travel_class_id
WHERE s.is_available = TRUE
  AND f.status = 'scheduled';

-- Grant permissions (adjust as needed for your environment)
-- GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO weengz_app;
-- GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO weengz_app;

-- Comments for documentation
COMMENT ON TABLE users IS 'Stores registered user information';
COMMENT ON TABLE airlines IS 'Contains airline company details';
COMMENT ON TABLE flights IS 'Flight schedule and route information';
COMMENT ON TABLE travel_classes IS 'Travel class definitions (Economy, Business, First, etc.)';
COMMENT ON TABLE seats IS 'Individual seat information for each flight';
COMMENT ON TABLE bookings IS 'Flight reservation records';
COMMENT ON TABLE payments IS 'Payment transaction records';
COMMENT ON TABLE audit_logs IS 'Audit trail for database changes';
