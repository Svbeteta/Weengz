// Main JavaScript for Weengz Application

document.addEventListener('DOMContentLoaded', function() {
    // Initialize tooltips
    initializeTooltips();
    
    // Handle form submissions
    handleFormSubmissions();
    
    // Add animation to elements
    addScrollAnimations();
    
    // Mobile menu handling
    handleMobileMenu();
});

/**
 * Initialize Bootstrap tooltips
 */
function initializeTooltips() {
    const tooltipTriggerList = [].slice.call(
        document.querySelectorAll('[data-bs-toggle="tooltip"]')
    );
    tooltipTriggerList.map(function(tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
}

/**
 * Handle form submissions
 */
function handleFormSubmissions() {
    // Login form
    const loginForm = document.getElementById('loginForm');
    if (loginForm) {
        loginForm.addEventListener('submit', function(e) {
            e.preventDefault();
            handleLogin();
        });
    }
    
    // Flight search form
    const searchForm = document.querySelector('form[role="search"]');
    if (searchForm) {
        searchForm.addEventListener('submit', function(e) {
            e.preventDefault();
            handleFlightSearch();
        });
    }
    
    // Passenger form
    const passengerForm = document.getElementById('passengerForm');
    if (passengerForm) {
        passengerForm.addEventListener('submit', function(e) {
            e.preventDefault();
            validatePassengerForm();
        });
    }
}

/**
 * Handle login process
 */
function handleLogin() {
    const email = document.getElementById('email').value;
    const password = document.getElementById('password').value;
    const rememberMe = document.getElementById('rememberMe').checked;
    
    // Basic validation
    if (!email || !password) {
        showAlert('Please fill in all required fields', 'danger');
        return;
    }
    
    // Simulate login (in production, this would make an API call)
    console.log('Login attempt:', { email, rememberMe });
    
    // Store user session (simple demo)
    sessionStorage.setItem('userEmail', email);
    sessionStorage.setItem('isLoggedIn', 'true');
    
    // Show success message
    showAlert('Login successful! Redirecting...', 'success');
    
    // Redirect to dashboard
    setTimeout(() => {
        window.location.href = 'dashboard.html';
    }, 1500);
}

/**
 * Handle flight search
 */
function handleFlightSearch() {
    const from = document.getElementById('from')?.value;
    const to = document.getElementById('to')?.value;
    const departureDate = document.getElementById('departure-date')?.value;
    const travelClass = document.getElementById('travel-class')?.value;
    const passengers = document.getElementById('passengers')?.value;
    
    // Validation
    if (!from || !to || !departureDate || !travelClass) {
        showAlert('Please fill in all required fields', 'warning');
        return;
    }
    
    console.log('Searching flights:', {
        from,
        to,
        departureDate,
        travelClass,
        passengers
    });
    
    // Show loading state
    showAlert('Searching for flights...', 'info');
    
    // Simulate search (in production, this would make an API call)
    setTimeout(() => {
        showAlert('Flights found! Redirecting to results...', 'success');
        // In production: window.location.href = 'flight-results.html';
    }, 2000);
}

/**
 * Validate passenger form
 */
function validatePassengerForm() {
    const firstName = document.getElementById('firstName')?.value;
    const lastName = document.getElementById('lastName')?.value;
    const email = document.getElementById('passengerEmail')?.value;
    const phone = document.getElementById('phone')?.value;
    
    if (!firstName || !lastName || !email || !phone) {
        showAlert('Please fill in all passenger information', 'warning');
        return false;
    }
    
    // Email validation
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
        showAlert('Please enter a valid email address', 'warning');
        return false;
    }
    
    return true;
}

/**
 * Show alert message
 */
function showAlert(message, type = 'info') {
    // Create alert element
    const alertDiv = document.createElement('div');
    alertDiv.className = `alert alert-${type} alert-dismissible fade show position-fixed top-0 start-50 translate-middle-x mt-3`;
    alertDiv.style.zIndex = '9999';
    alertDiv.setAttribute('role', 'alert');
    alertDiv.innerHTML = `
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    `;
    
    // Add to body
    document.body.appendChild(alertDiv);
    
    // Auto-dismiss after 5 seconds
    setTimeout(() => {
        alertDiv.remove();
    }, 5000);
}

/**
 * Add scroll animations
 */
function addScrollAnimations() {
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -100px 0px'
    };
    
    const observer = new IntersectionObserver(function(entries) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('fade-in');
                observer.unobserve(entry.target);
            }
        });
    }, observerOptions);
    
    // Observe cards and sections
    document.querySelectorAll('.card, section').forEach(el => {
        observer.observe(el);
    });
}

/**
 * Handle mobile menu
 */
function handleMobileMenu() {
    const navbarToggler = document.querySelector('.navbar-toggler');
    const navbarCollapse = document.querySelector('.navbar-collapse');
    
    if (navbarToggler && navbarCollapse) {
        // Close menu when clicking outside
        document.addEventListener('click', function(e) {
            if (!navbarToggler.contains(e.target) && !navbarCollapse.contains(e.target)) {
                if (navbarCollapse.classList.contains('show')) {
                    navbarToggler.click();
                }
            }
        });
    }
}

/**
 * Format currency
 */
function formatCurrency(amount) {
    return new Intl.NumberFormat('en-US', {
        style: 'currency',
        currency: 'USD'
    }).format(amount);
}

/**
 * Format date
 */
function formatDate(dateString) {
    const options = { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
    };
    return new Date(dateString).toLocaleDateString('en-US', options);
}

/**
 * Check if user is logged in
 */
function checkAuth() {
    const isLoggedIn = sessionStorage.getItem('isLoggedIn');
    if (!isLoggedIn) {
        window.location.href = 'login.html';
    }
}

// Export functions for use in other scripts
window.WeengzApp = {
    showAlert,
    formatCurrency,
    formatDate,
    checkAuth
};
