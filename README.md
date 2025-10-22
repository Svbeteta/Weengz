# Weengz - Airline Seat Reservation System

An Angular-based airline seat reservation system, focusing on user management, travel classes, and comprehensive reporting capabilities.

## Project Overview

Weengz is a modern, responsive web application designed to streamline the airline seat reservation process. The system provides an intuitive interface for users to search flights, select seats, and manage bookings with real-time availability updates.

## Features

### Module 1A - Web Layout (HTML, CSS, Bootstrap, Tailwind)
- ✅ Responsive landing page with flight search
- ✅ User authentication (login/signup)
- ✅ Interactive dashboard with booking statistics
- ✅ Advanced seat selection with real-time visualization
- ✅ Booking confirmation with detailed information
- ✅ Accessible design with ARIA labels and keyboard navigation
- ✅ Mobile-first responsive design
- ✅ Modern UI using Bootstrap 5 and Tailwind CSS

### Module 1B - Database Design (ER Diagram + PostgreSQL Schema)
- ✅ Comprehensive ER diagram with all entities and relationships
- ✅ Normalized database schema (3NF)
- ✅ PostgreSQL migration scripts
- ✅ Sample data seeds for testing
- ✅ Audit logging for compliance
- ✅ Database views for reporting
- ✅ Proper indexing for performance

## Technology Stack

### Frontend
- **HTML5** - Semantic markup
- **CSS3** - Custom styles with animations
- **Bootstrap 5** - Responsive grid and components
- **Tailwind CSS** - Utility-first styling
- **JavaScript (ES6+)** - Interactive functionality
- **Font Awesome** - Icons

### Backend/Database
- **PostgreSQL 14+** - Relational database
- **SQL** - Database migrations and queries

## Project Structure

```
Weengz/
├── public/                      # Frontend files
│   ├── index.html              # Landing page
│   ├── login.html              # Authentication page
│   ├── dashboard.html          # User dashboard
│   ├── seat-selection.html     # Seat selection interface
│   ├── booking-confirmation.html # Booking confirmation
│   ├── css/
│   │   └── styles.css          # Custom styles
│   └── js/
│       ├── main.js             # Main JavaScript
│       └── seat-selection.js   # Seat selection logic
├── database/                    # Database files
│   ├── migrations/
│   │   └── 001_initial_schema.sql  # Initial schema
│   ├── seeds/
│   │   └── 001_sample_data.sql     # Sample data
│   ├── diagrams/
│   │   └── er-diagram.md           # ER diagram
│   └── README.md               # Database documentation
├── docs/                        # Documentation
│   ├── MODULE_1A.md            # Module 1A documentation
│   ├── MODULE_1B.md            # Module 1B documentation
│   └── TESTING.md              # Testing guide
├── .gitignore                  # Git ignore file
└── README.md                   # This file
```

## Getting Started

### Prerequisites
- Modern web browser (Chrome, Firefox, Safari, Edge)
- PostgreSQL 14 or higher (for database)
- Web server (optional, for local development)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Svbeteta/Weengz.git
   cd Weengz
   ```

2. **Set up the database** (optional)
   ```bash
   # Create database
   createdb weengz
   
   # Run migrations
   psql -d weengz -f database/migrations/001_initial_schema.sql
   
   # Load sample data
   psql -d weengz -f database/seeds/001_sample_data.sql
   ```

3. **Run the application**
   
   **Option 1: Using Python's built-in server**
   ```bash
   cd public
   python3 -m http.server 8000
   ```
   
   **Option 2: Using Node.js http-server**
   ```bash
   npx http-server public -p 8000
   ```
   
   **Option 3: Open directly**
   Simply open `public/index.html` in your web browser

4. **Access the application**
   - Open your browser and navigate to `http://localhost:8000`
   - Or open `public/index.html` directly

## Usage

### For Users

1. **Search Flights**
   - Enter departure and arrival cities
   - Select travel dates and class
   - Click "Search Flights"

2. **Select Seat**
   - View the interactive seat map
   - Click on available seats (green)
   - See real-time price updates

3. **Complete Booking**
   - Enter passenger information
   - Review booking summary
   - Confirm booking

4. **Manage Bookings**
   - View upcoming flights
   - Access booking history
   - Download/print tickets

### For Developers

See detailed documentation in:
- `docs/MODULE_1A.md` - Frontend development guide
- `docs/MODULE_1B.md` - Database development guide
- `database/README.md` - Database setup and maintenance

## Key Features

### Accessibility
- ARIA labels for screen readers
- Keyboard navigation support
- High contrast design
- Semantic HTML structure
- Focus indicators

### Responsive Design
- Mobile-first approach
- Tablet optimization
- Desktop enhancement
- Flexible layouts
- Touch-friendly controls

### Security
- Password hashing (bcrypt)
- SQL injection prevention
- XSS protection
- CSRF tokens (future implementation)
- Audit logging

## Database Schema

The system uses a normalized PostgreSQL database with the following main entities:

- **Users** - Customer accounts
- **Airlines** - Airline companies
- **Flights** - Flight schedules
- **Seats** - Seat inventory
- **Travel Classes** - Service tiers
- **Bookings** - Reservations
- **Payments** - Transactions
- **Audit Logs** - Change tracking

See `database/diagrams/er-diagram.md` for the complete ER diagram.

## Testing

### Manual Testing
1. Open `public/index.html` in a browser
2. Navigate through all pages
3. Test responsive design (resize browser)
4. Test seat selection functionality
5. Verify form validations

### Database Testing
```sql
-- Verify data integrity
SELECT * FROM booking_summary;

-- Check available seats
SELECT * FROM available_seats WHERE flight_number = 'AA1234';

-- Test constraints
-- (Try inserting invalid data to verify constraints work)
```

## Roadmap

### Completed (Module 1A & 1B)
- [x] Landing page with flight search
- [x] User authentication pages
- [x] Dashboard with statistics
- [x] Seat selection interface
- [x] Booking confirmation
- [x] ER diagram
- [x] Database schema
- [x] Sample data

### Planned (Future Modules)
- [ ] Backend API (Node.js/Express or similar)
- [ ] Real-time seat availability
- [ ] Payment gateway integration
- [ ] Email notifications
- [ ] Admin panel
- [ ] Reporting and analytics
- [ ] Flight status tracking
- [ ] Multi-language support

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues, questions, or contributions, please:
- Open an issue on GitHub
- Contact the development team
- Refer to the documentation in the `docs/` directory

## Acknowledgments

- Bootstrap team for the excellent CSS framework
- Tailwind CSS for utility-first design
- Font Awesome for icons
- PostgreSQL community for the robust database

---

**Version:** 1.0.0 (Module 1A & 1B Complete)  
**Last Updated:** October 2025  
**Status:** Active Development
