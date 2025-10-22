# Testing Guide - Weengz

This document provides comprehensive testing procedures for both Module 1A (Web Layout) and Module 1B (Database).

## Table of Contents
1. [Module 1A Testing](#module-1a-testing)
2. [Module 1B Testing](#module-1b-testing)
3. [Integration Testing](#integration-testing)
4. [Acceptance Testing](#acceptance-testing)

---

## Module 1A Testing

### Prerequisites
- Modern web browser (Chrome, Firefox, Safari, Edge)
- Local web server (optional)
- Screen reader software (for accessibility testing)

### 1. Functional Testing

#### Landing Page (index.html)
- [ ] Page loads without errors
- [ ] Navigation links work
- [ ] Logo links to home
- [ ] Hero section displays correctly
- [ ] Flight search form appears
- [ ] All form fields are accessible
- [ ] Search button responds to clicks
- [ ] Feature cards display properly
- [ ] About section renders correctly
- [ ] Footer links are clickable
- [ ] Social media icons appear

**Test Flight Search Form:**
```
Test Case 1: Valid Search
1. Enter "New York" in From field
2. Enter "Los Angeles" in To field
3. Select future departure date
4. Select "Business" class
5. Enter "2" passengers
6. Click "Search Flights"
Expected: Alert shows "Searching for flights..."

Test Case 2: Invalid Search
1. Leave From field empty
2. Click "Search Flights"
Expected: Alert shows "Please fill in all required fields"
```

#### Login Page (login.html)
- [ ] Page loads correctly
- [ ] Login form displays
- [ ] Email field accepts input
- [ ] Password field masks characters
- [ ] Remember me checkbox works
- [ ] Login button is clickable
- [ ] Forgot password link exists
- [ ] Social login buttons display
- [ ] Sign up link works

**Test Login Form:**
```
Test Case 1: Valid Login
1. Enter "test@example.com"
2. Enter any password
3. Click "Login"
Expected: Success message, redirect to dashboard

Test Case 2: Empty Fields
1. Leave fields empty
2. Click "Login"
Expected: Alert shows error message
```

#### Dashboard (dashboard.html)
- [ ] Page loads with data
- [ ] Statistics cards display
- [ ] Numbers are formatted correctly
- [ ] Upcoming bookings table shows
- [ ] Table data is readable
- [ ] Sidebar navigation works
- [ ] Quick action cards appear
- [ ] User dropdown functions
- [ ] Logout link exists

**Test Dashboard:**
```
Test Case 1: View Statistics
1. Load dashboard
2. Verify 4 stat cards appear
3. Check numbers are visible
Expected: Active Bookings: 3, Completed Trips: 12, etc.

Test Case 2: Navigation
1. Click "My Bookings" in sidebar
2. Click "Profile"
3. Click user dropdown
4. Select "Settings"
Expected: All links respond (even if they don't navigate)
```

#### Seat Selection (seat-selection.html)
- [ ] Flight information displays
- [ ] Travel class selector works
- [ ] Seat map renders correctly
- [ ] Legend shows seat types
- [ ] Seats are clickable
- [ ] Selected seat highlights
- [ ] Price updates dynamically
- [ ] Passenger form appears
- [ ] Confirm button is visible

**Test Seat Selection:**
```
Test Case 1: Select Available Seat
1. Load seat selection page
2. Click on seat "1A" (green)
3. Observe seat color change to blue
4. Check "Selected Seat" shows "1A"
5. Verify price updates
Expected: Seat changes color, info updates

Test Case 2: Try Occupied Seat
1. Click on seat "1C" (red)
Expected: Seat cannot be selected (disabled)

Test Case 3: Change Travel Class
1. Select "Economy" radio button
2. Observe seat map changes
3. Business class section hides
4. Economy class section shows
Expected: Seat map updates correctly

Test Case 4: Keyboard Navigation
1. Tab to first seat
2. Press Enter to select
Expected: Seat selected via keyboard
```

#### Booking Confirmation (booking-confirmation.html)
- [ ] Success icon displays
- [ ] Booking reference shows
- [ ] Flight details appear
- [ ] Passenger info displays
- [ ] Payment summary shows
- [ ] Action buttons work
- [ ] Important info section exists
- [ ] Print button functions

**Test Confirmation:**
```
Test Case 1: Print Ticket
1. Load confirmation page
2. Click "Print Ticket"
Expected: Print dialog opens

Test Case 2: Navigate to Dashboard
1. Click "Go to Dashboard"
Expected: Redirects to dashboard.html
```

### 2. Responsive Design Testing

#### Mobile Testing (< 576px)
- [ ] Navigation collapses to hamburger menu
- [ ] All content is readable
- [ ] Forms are usable
- [ ] Buttons are touch-friendly (min 44x44px)
- [ ] Seat map adapts (smaller seats)
- [ ] Tables scroll horizontally if needed
- [ ] Images scale properly
- [ ] No horizontal scroll (except tables)

**Test on Devices:**
- iPhone SE (375px)
- iPhone 12 (390px)
- Samsung Galaxy S21 (360px)

#### Tablet Testing (576px - 768px)
- [ ] Two-column layouts work
- [ ] Sidebar appears/collapses
- [ ] Seat map is appropriately sized
- [ ] Cards stack correctly
- [ ] Forms are well-spaced

**Test on Devices:**
- iPad Mini (768px)
- iPad (810px)
- Samsung Galaxy Tab (800px)

#### Desktop Testing (> 768px)
- [ ] Full navigation visible
- [ ] Multi-column layouts work
- [ ] Seat map is large and clear
- [ ] Sidebar is fixed (where applicable)
- [ ] Hover effects work
- [ ] Maximum width is reasonable

**Test on Resolutions:**
- 1366x768 (common laptop)
- 1920x1080 (Full HD)
- 2560x1440 (2K)

### 3. Accessibility Testing

#### Keyboard Navigation
```
Test Procedure:
1. Open page in browser
2. Press Tab repeatedly
3. Verify focus order is logical
4. Ensure all interactive elements can be focused
5. Test Enter/Space to activate buttons
6. Test arrow keys in seat selection
Expected: Complete keyboard accessibility
```

**Checklist:**
- [ ] Tab order is logical
- [ ] Focus indicators are visible
- [ ] All buttons accessible via keyboard
- [ ] Forms can be completed without mouse
- [ ] Dropdowns work with keyboard
- [ ] Modals can be closed with Escape

#### Screen Reader Testing
```
Test with NVDA (Windows) or VoiceOver (Mac):
1. Enable screen reader
2. Navigate through page
3. Verify all content is announced
4. Check form labels are read
5. Verify button purposes are clear
6. Test dynamic content announcements
```

**Checklist:**
- [ ] Page title is announced
- [ ] Headings are read correctly
- [ ] Links describe their purpose
- [ ] Form fields have labels
- [ ] Error messages are announced
- [ ] Button actions are clear
- [ ] Images have alt text (or aria-hidden)

#### Color Contrast
```
Test Tool: Use browser extension or online tool
1. Check text on backgrounds
2. Verify minimum 4.5:1 ratio for normal text
3. Verify minimum 3:1 ratio for large text
4. Check button states
5. Test disabled elements
```

**Checklist:**
- [ ] Primary text meets contrast ratio
- [ ] Link text is distinguishable
- [ ] Button text is readable
- [ ] Error messages are clear
- [ ] Success messages are visible

### 4. Browser Compatibility Testing

#### Chrome
- [ ] Latest version
- [ ] All features work
- [ ] No console errors
- [ ] Performance is good

#### Firefox
- [ ] Latest version
- [ ] CSS renders correctly
- [ ] JavaScript functions properly
- [ ] Forms work as expected

#### Safari
- [ ] Latest version (desktop)
- [ ] Latest version (iOS)
- [ ] Webkit-specific features work
- [ ] Touch events work (mobile)

#### Edge
- [ ] Latest version
- [ ] Chromium-based features work
- [ ] No compatibility warnings

### 5. Performance Testing

**Metrics to Check:**
- [ ] Page load time < 3 seconds
- [ ] First contentful paint < 1.5 seconds
- [ ] No JavaScript errors in console
- [ ] No CSS warnings
- [ ] Smooth animations (60fps)
- [ ] No layout shifts

**Tools:**
- Chrome DevTools (Performance tab)
- Lighthouse
- PageSpeed Insights

---

## Module 1B Testing

### Prerequisites
- PostgreSQL 14+ installed
- psql command-line tool
- Database permissions
- Sample data loaded

### 1. Schema Testing

#### Database Creation
```sql
-- Test 1: Verify database exists
SELECT datname FROM pg_database WHERE datname = 'weengz';
Expected: 1 row returned

-- Test 2: Check all tables exist
SELECT tablename FROM pg_tables WHERE schemaname = 'public'
ORDER BY tablename;
Expected: 8 tables (airlines, audit_logs, bookings, flights, 
          payments, seats, travel_classes, users)

-- Test 3: Verify custom types
SELECT typname FROM pg_type WHERE typname LIKE '%_enum';
Expected: 4 types (booking_status_enum, payment_status_enum, 
          flight_status_enum, payment_method_enum)
```

#### Table Structure
```sql
-- Test 4: Check users table structure
\d+ users
Expected: Proper columns, constraints, indexes

-- Test 5: Verify foreign keys
SELECT
    tc.table_name, 
    kcu.column_name, 
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name 
FROM information_schema.table_constraints AS tc 
JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
  ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
ORDER BY tc.table_name;
Expected: All FK relationships listed
```

### 2. Constraint Testing

#### Primary Keys
```sql
-- Test 6: Duplicate PK
INSERT INTO users (user_id, email, password_hash, first_name, last_name)
VALUES (1, 'test2@example.com', 'hash', 'Test', 'User');
Expected: ERROR - duplicate key value violates unique constraint
```

#### Unique Constraints
```sql
-- Test 7: Duplicate email
INSERT INTO users (email, password_hash, first_name, last_name)
VALUES ('john.doe@example.com', 'hash', 'John', 'Smith');
Expected: ERROR - duplicate key value violates unique constraint "users_email_key"
```

#### Check Constraints
```sql
-- Test 8: Invalid airports (same departure and arrival)
INSERT INTO flights (flight_number, airline_id, departure_airport, 
                     arrival_airport, departure_time, arrival_time)
VALUES ('TEST123', 1, 'JFK', 'JFK', NOW(), NOW() + INTERVAL '2 hours');
Expected: ERROR - violates check constraint "valid_airports"

-- Test 9: Invalid times (arrival before departure)
INSERT INTO flights (flight_number, airline_id, departure_airport, 
                     arrival_airport, departure_time, arrival_time)
VALUES ('TEST124', 1, 'JFK', 'LAX', NOW() + INTERVAL '2 hours', NOW());
Expected: ERROR - violates check constraint "valid_times"

-- Test 10: Negative amount
INSERT INTO bookings (user_id, flight_id, seat_id, travel_class_id, total_amount)
VALUES (1, 1, 1, 1, -100.00);
Expected: ERROR - violates check constraint "positive_amount"
```

#### Foreign Keys
```sql
-- Test 11: Invalid user reference
INSERT INTO bookings (user_id, flight_id, seat_id, travel_class_id, total_amount)
VALUES (99999, 1, 1, 1, 100.00);
Expected: ERROR - violates foreign key constraint

-- Test 12: Cascade delete (seats should delete with flight)
BEGIN;
DELETE FROM flights WHERE flight_id = 1;
SELECT COUNT(*) FROM seats WHERE flight_id = 1;
ROLLBACK;
Expected: 0 (seats deleted)
```

### 3. Index Testing

```sql
-- Test 13: Verify indexes exist
SELECT indexname, indexdef FROM pg_indexes 
WHERE tablename = 'bookings'
ORDER BY indexname;
Expected: Multiple indexes listed

-- Test 14: Index usage (run with EXPLAIN)
EXPLAIN ANALYZE 
SELECT * FROM bookings WHERE booking_reference = 'WNG-000001';
Expected: Index scan on idx_bookings_reference
```

### 4. Trigger Testing

```sql
-- Test 15: Updated_at trigger
BEGIN;
UPDATE users SET first_name = 'Updated' WHERE user_id = 1;
SELECT updated_at > created_at FROM users WHERE user_id = 1;
ROLLBACK;
Expected: true
```

### 5. View Testing

```sql
-- Test 16: booking_summary view
SELECT * FROM booking_summary WHERE booking_reference = 'WNG-000001';
Expected: Complete booking information with joins

-- Test 17: available_seats view
SELECT * FROM available_seats WHERE flight_number = 'AA1234';
Expected: Only available seats listed
```

### 6. Data Integrity Testing

```sql
-- Test 18: Booking without payment
BEGIN;
INSERT INTO bookings (user_id, flight_id, seat_id, travel_class_id, 
                      total_amount, booking_status)
VALUES (1, 1, 10, 1, 400.00, 'pending');
-- Verify booking can exist without payment initially
SELECT * FROM bookings WHERE booking_id = currval('bookings_booking_id_seq');
ROLLBACK;
Expected: Success (payments are created separately)

-- Test 19: Seat availability
BEGIN;
-- Book a seat
UPDATE seats SET is_available = FALSE WHERE seat_id = 10;
-- Try to book same seat again (application logic should prevent)
SELECT is_available FROM seats WHERE seat_id = 10;
ROLLBACK;
Expected: false (seat no longer available)
```

### 7. Performance Testing

```sql
-- Test 20: Query performance
EXPLAIN ANALYZE
SELECT * FROM booking_summary
WHERE user_email = 'john.doe@example.com'
ORDER BY booking_date DESC;
Expected: Execution time < 100ms for sample data

-- Test 21: Index effectiveness
SELECT schemaname, tablename, indexname, idx_scan
FROM pg_stat_user_indexes
WHERE schemaname = 'public'
ORDER BY idx_scan DESC;
Expected: Frequently used indexes show high idx_scan values
```

### 8. Sample Data Verification

```sql
-- Test 22: Airlines loaded
SELECT COUNT(*) FROM airlines;
Expected: 4

-- Test 23: Travel classes loaded
SELECT COUNT(*) FROM travel_classes;
Expected: 4

-- Test 24: Users loaded
SELECT COUNT(*) FROM users;
Expected: 5

-- Test 25: Flights loaded
SELECT COUNT(*) FROM flights;
Expected: 5

-- Test 26: Seats loaded
SELECT COUNT(*) FROM seats;
Expected: >= 30
```

---

## Integration Testing

### Database + Frontend Integration (Future)

When backend API is implemented:

1. **User Registration Flow**
   - Fill registration form
   - Submit data
   - Verify user created in database
   - Check password is hashed

2. **Booking Flow**
   - Select flight
   - Choose seat
   - Enter passenger info
   - Complete payment
   - Verify booking in database
   - Check seat marked as unavailable

3. **Data Retrieval**
   - Load dashboard
   - Verify data matches database
   - Check booking history
   - Confirm statistics are accurate

---

## Acceptance Testing

### Module 1A Acceptance Criteria

✅ **Frontend is complete when:**
1. All 5 HTML pages are created and functional
2. Responsive design works on all screen sizes
3. Bootstrap and Tailwind are properly integrated
4. Interactive features work (seat selection, forms)
5. JavaScript provides expected functionality
6. Accessibility standards are met (WCAG 2.1 AA)
7. All browsers render correctly
8. No console errors
9. Performance is acceptable
10. Code is clean and documented

### Module 1B Acceptance Criteria

✅ **Database is complete when:**
1. ER diagram accurately represents system
2. All tables created with proper structure
3. Relationships correctly implemented
4. Constraints enforce business rules
5. Indexes optimize queries
6. Sample data loads successfully
7. Views provide useful abstractions
8. Triggers maintain data integrity
9. Documentation is comprehensive
10. Database passes all validation tests

---

## Automated Testing (Future)

### Frontend Testing Tools
- **Jest**: JavaScript unit tests
- **Playwright**: End-to-end tests
- **Lighthouse CI**: Performance testing
- **axe**: Accessibility testing

### Database Testing Tools
- **pgTAP**: PostgreSQL unit testing
- **DbUnit**: Database integration testing
- **SQL Test**: Automated SQL testing

---

## Bug Reporting

When reporting bugs, include:
1. **Component**: Which module/page
2. **Steps to reproduce**: Detailed steps
3. **Expected behavior**: What should happen
4. **Actual behavior**: What actually happens
5. **Environment**: Browser/OS/Database version
6. **Screenshots**: If applicable
7. **Console errors**: JavaScript errors
8. **SQL errors**: Database errors

---

**Testing Status:**  
Module 1A: ✅ Manual testing complete  
Module 1B: ✅ Schema testing complete  
Integration: ⏳ Pending (requires backend API)  
Automated: ⏳ Future enhancement
