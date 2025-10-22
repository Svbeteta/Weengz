-- Weengz Database Seed Data
-- This file contains sample data for testing and development

-- Insert Airlines
INSERT INTO airlines (airline_name, airline_code, contact_email, contact_phone) VALUES
('American Airlines', 'AA', 'support@aa.com', '+1-800-433-7300'),
('United Airlines', 'UA', 'support@united.com', '+1-800-864-8331'),
('Delta Air Lines', 'DL', 'support@delta.com', '+1-800-221-1212'),
('Southwest Airlines', 'WN', 'support@southwest.com', '+1-800-435-9792');

-- Insert Travel Classes
INSERT INTO travel_classes (class_name, class_code, description, base_price, baggage_allowance, has_meal_service, has_priority_boarding) VALUES
('Economy', 'ECO', 'Standard seating with basic amenities', 350.00, 1, FALSE, FALSE),
('Premium Economy', 'PEC', 'Extra legroom and enhanced comfort', 550.00, 2, TRUE, FALSE),
('Business', 'BUS', 'Lie-flat seats with premium service', 1200.00, 2, TRUE, TRUE),
('First Class', 'FST', 'Luxury travel with exclusive amenities', 2500.00, 3, TRUE, TRUE);

-- Insert Users (passwords are hashed versions of 'password123')
INSERT INTO users (email, password_hash, first_name, last_name, phone_number, frequent_flyer_number, is_active) VALUES
('john.doe@example.com', '$2b$10$rXfYvqKq3Z5Y5Y5Y5Y5Y5e5Y5Y5Y5Y5Y5Y5Y5Y5Y5Y5Y5Y5Y5Y', 'John', 'Doe', '+1-555-0101', 'FF123456789', TRUE),
('jane.smith@example.com', '$2b$10$rXfYvqKq3Z5Y5Y5Y5Y5Y5e5Y5Y5Y5Y5Y5Y5Y5Y5Y5Y5Y5Y5Y5Y', 'Jane', 'Smith', '+1-555-0102', 'FF987654321', TRUE),
('bob.wilson@example.com', '$2b$10$rXfYvqKq3Z5Y5Y5Y5Y5Y5e5Y5Y5Y5Y5Y5Y5Y5Y5Y5Y5Y5Y5Y5Y', 'Bob', 'Wilson', '+1-555-0103', NULL, TRUE),
('alice.johnson@example.com', '$2b$10$rXfYvqKq3Z5Y5Y5Y5Y5Y5e5Y5Y5Y5Y5Y5Y5Y5Y5Y5Y5Y5Y5Y5Y', 'Alice', 'Johnson', '+1-555-0104', 'FF456789123', TRUE),
('charlie.brown@example.com', '$2b$10$rXfYvqKq3Z5Y5Y5Y5Y5Y5e5Y5Y5Y5Y5Y5Y5Y5Y5Y5Y5Y5Y5Y5Y', 'Charlie', 'Brown', '+1-555-0105', NULL, TRUE);

-- Insert Flights
INSERT INTO flights (flight_number, airline_id, departure_airport, arrival_airport, departure_time, arrival_time, status) VALUES
('AA1234', 1, 'JFK', 'LAX', '2025-12-25 10:00:00-05', '2025-12-25 13:30:00-08', 'scheduled'),
('UA5678', 2, 'SFO', 'SEA', '2026-01-15 08:30:00-08', '2026-01-15 10:45:00-08', 'scheduled'),
('DL9012', 3, 'ATL', 'MIA', '2025-12-20 15:00:00-05', '2025-12-20 17:15:00-05', 'scheduled'),
('WN3456', 4, 'LAX', 'LAS', '2025-12-30 12:00:00-08', '2025-12-30 13:15:00-08', 'scheduled'),
('AA7890', 1, 'BOS', 'ORD', '2026-01-10 09:00:00-05', '2026-01-10 10:30:00-06', 'scheduled');

-- Insert Seats for Flight AA1234 (JFK to LAX)
-- Business Class (Rows 1-3, 4 seats per row: A, B, C, D)
INSERT INTO seats (flight_id, seat_number, travel_class_id, is_available, is_exit_row, is_window, is_aisle, price_modifier) VALUES
-- Row 1
(1, '1A', 3, TRUE, FALSE, TRUE, FALSE, 50.00),
(1, '1B', 3, TRUE, FALSE, FALSE, TRUE, 50.00),
(1, '1C', 3, FALSE, FALSE, FALSE, TRUE, 50.00),
(1, '1D', 3, TRUE, FALSE, TRUE, FALSE, 50.00),
-- Row 2
(1, '2A', 3, TRUE, FALSE, TRUE, FALSE, 50.00),
(1, '2B', 3, FALSE, FALSE, FALSE, TRUE, 50.00),
(1, '2C', 3, TRUE, FALSE, FALSE, TRUE, 50.00),
(1, '2D', 3, TRUE, FALSE, TRUE, FALSE, 50.00),
-- Row 3
(1, '3A', 3, TRUE, FALSE, TRUE, FALSE, 50.00),
(1, '3B', 3, TRUE, FALSE, FALSE, TRUE, 50.00),
(1, '3C', 3, TRUE, FALSE, FALSE, TRUE, 50.00),
(1, '3D', 3, FALSE, FALSE, TRUE, FALSE, 50.00);

-- Economy Class (Rows 10-15, 6 seats per row: A, B, C, D, E, F)
INSERT INTO seats (flight_id, seat_number, travel_class_id, is_available, is_exit_row, is_window, is_aisle, price_modifier) VALUES
-- Row 10 (Exit Row)
(1, '10A', 1, TRUE, TRUE, TRUE, FALSE, 25.00),
(1, '10B', 1, TRUE, TRUE, FALSE, FALSE, 25.00),
(1, '10C', 1, TRUE, TRUE, FALSE, TRUE, 25.00),
(1, '10D', 1, TRUE, TRUE, FALSE, TRUE, 25.00),
(1, '10E', 1, TRUE, TRUE, FALSE, FALSE, 25.00),
(1, '10F', 1, TRUE, TRUE, TRUE, FALSE, 25.00),
-- Row 11
(1, '11A', 1, TRUE, FALSE, TRUE, FALSE, 15.00),
(1, '11B', 1, TRUE, FALSE, FALSE, FALSE, 15.00),
(1, '11C', 1, FALSE, FALSE, FALSE, TRUE, 15.00),
(1, '11D', 1, TRUE, FALSE, FALSE, TRUE, 15.00),
(1, '11E', 1, FALSE, FALSE, FALSE, FALSE, 15.00),
(1, '11F', 1, TRUE, FALSE, TRUE, FALSE, 15.00),
-- Row 12
(1, '12A', 1, FALSE, FALSE, TRUE, FALSE, 15.00),
(1, '12B', 1, TRUE, FALSE, FALSE, FALSE, 15.00),
(1, '12C', 1, TRUE, FALSE, FALSE, TRUE, 15.00),
(1, '12D', 1, TRUE, FALSE, FALSE, TRUE, 15.00),
(1, '12E', 1, TRUE, FALSE, FALSE, FALSE, 15.00),
(1, '12F', 1, FALSE, FALSE, TRUE, FALSE, 15.00);

-- Insert Seats for Flight UA5678 (SFO to SEA) - simplified
INSERT INTO seats (flight_id, seat_number, travel_class_id, is_available, is_exit_row, is_window, is_aisle, price_modifier) VALUES
(2, '1A', 3, TRUE, FALSE, TRUE, FALSE, 50.00),
(2, '1B', 3, TRUE, FALSE, FALSE, TRUE, 50.00),
(2, '10A', 1, TRUE, FALSE, TRUE, FALSE, 15.00),
(2, '10B', 1, TRUE, FALSE, FALSE, FALSE, 15.00),
(2, '10C', 1, TRUE, FALSE, FALSE, TRUE, 15.00),
(2, '23B', 1, FALSE, FALSE, FALSE, FALSE, 15.00);

-- Insert sample bookings
INSERT INTO bookings (user_id, flight_id, seat_id, travel_class_id, total_amount, booking_status, booking_date) VALUES
(1, 1, 3, 3, 420.00, 'confirmed', '2025-10-15 14:30:00'),
(2, 2, 36, 1, 395.00, 'confirmed', '2025-10-18 09:15:00');

-- Update seats to reflect bookings
UPDATE seats SET is_available = FALSE WHERE seat_id IN (3, 36);

-- Insert payments for bookings
INSERT INTO payments (booking_id, user_id, amount, payment_method, transaction_id, payment_status, payment_date) VALUES
(1, 1, 420.00, 'credit_card', 'TXN-' || uuid_generate_v4(), 'completed', '2025-10-15 14:32:00'),
(2, 2, 395.00, 'credit_card', 'TXN-' || uuid_generate_v4(), 'completed', '2025-10-18 09:17:00');

-- Insert some audit log entries (would normally be done via triggers)
INSERT INTO audit_logs (user_id, action, table_name, record_id, new_values) VALUES
(1, 'INSERT', 'bookings', '1', '{"booking_reference": "WNG-000001", "user_id": 1, "total_amount": 420.00}'::jsonb),
(2, 'INSERT', 'bookings', '2', '{"booking_reference": "WNG-000002", "user_id": 2, "total_amount": 395.00}'::jsonb);

-- Verification queries (commented out - use for testing)
/*
SELECT * FROM airlines;
SELECT * FROM travel_classes;
SELECT * FROM users;
SELECT * FROM flights;
SELECT COUNT(*) as total_seats FROM seats WHERE flight_id = 1;
SELECT * FROM bookings;
SELECT * FROM booking_summary;
SELECT * FROM available_seats WHERE flight_number = 'AA1234';
*/
