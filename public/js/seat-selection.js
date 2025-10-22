// Seat Selection JavaScript

document.addEventListener('DOMContentLoaded', function() {
    initializeSeatSelection();
});

let selectedSeat = null;

/**
 * Initialize seat selection functionality
 */
function initializeSeatSelection() {
    const seats = document.querySelectorAll('.seat:not(.occupied)');
    const selectedSeatInfo = document.getElementById('selectedSeatInfo');
    const selectedSeatNumber = document.getElementById('selectedSeatNumber');
    const seatPriceElement = document.getElementById('seatPrice');
    const totalPriceElement = document.getElementById('totalPrice');
    
    seats.forEach(seat => {
        seat.addEventListener('click', function() {
            handleSeatSelection(this, selectedSeatInfo, selectedSeatNumber, seatPriceElement, totalPriceElement);
        });
        
        // Keyboard accessibility
        seat.addEventListener('keypress', function(e) {
            if (e.key === 'Enter' || e.key === ' ') {
                e.preventDefault();
                handleSeatSelection(this, selectedSeatInfo, selectedSeatNumber, seatPriceElement, totalPriceElement);
            }
        });
    });
    
    // Travel class change handler
    const travelClassInputs = document.querySelectorAll('input[name="travelClass"]');
    travelClassInputs.forEach(input => {
        input.addEventListener('change', function() {
            handleTravelClassChange(this.id);
        });
    });
}

/**
 * Handle seat selection
 */
function handleSeatSelection(seatElement, infoElement, numberElement, priceElement, totalElement) {
    // Remove previous selection
    const previouslySelected = document.querySelector('.seat.selected');
    if (previouslySelected) {
        previouslySelected.classList.remove('selected');
        if (previouslySelected.classList.contains('exit-row')) {
            previouslySelected.classList.add('exit-row');
        } else {
            previouslySelected.classList.add('available');
        }
    }
    
    // Add new selection
    seatElement.classList.remove('available', 'exit-row');
    seatElement.classList.add('selected');
    
    // Get seat number
    const seatNumber = seatElement.getAttribute('data-seat');
    selectedSeat = seatNumber;
    
    // Update UI
    if (infoElement && numberElement) {
        infoElement.classList.remove('d-none');
        numberElement.textContent = seatNumber;
    }
    
    // Calculate price
    const seatPrice = calculateSeatPrice(seatElement);
    if (priceElement) {
        priceElement.textContent = window.WeengzApp.formatCurrency(seatPrice);
    }
    
    // Update total
    if (totalElement) {
        const baseFare = 350;
        const taxesAndFees = 45;
        const total = baseFare + taxesAndFees + seatPrice;
        totalElement.textContent = window.WeengzApp.formatCurrency(total);
    }
    
    // Announce to screen readers
    announceToScreenReader(`Seat ${seatNumber} selected`);
}

/**
 * Calculate seat price based on type
 */
function calculateSeatPrice(seatElement) {
    if (seatElement.classList.contains('exit-row') || seatElement.getAttribute('data-seat').startsWith('10')) {
        return 25; // Exit row premium
    }
    
    const travelClass = document.querySelector('input[name="travelClass"]:checked')?.id;
    if (travelClass === 'business' || travelClass === 'first') {
        return 50; // Premium seat selection
    }
    
    return 15; // Standard seat selection fee
}

/**
 * Handle travel class change
 */
function handleTravelClassChange(classId) {
    const businessSection = document.getElementById('businessSection');
    const economySection = document.getElementById('economySection');
    
    if (!businessSection || !economySection) return;
    
    // Show/hide sections based on class
    if (classId === 'economy') {
        businessSection.style.display = 'none';
        economySection.style.display = 'block';
    } else if (classId === 'business' || classId === 'first') {
        businessSection.style.display = 'block';
        economySection.style.display = 'none';
    }
    
    // Clear seat selection
    const previouslySelected = document.querySelector('.seat.selected');
    if (previouslySelected) {
        previouslySelected.classList.remove('selected');
        previouslySelected.classList.add('available');
        selectedSeat = null;
        
        const selectedSeatInfo = document.getElementById('selectedSeatInfo');
        if (selectedSeatInfo) {
            selectedSeatInfo.classList.add('d-none');
        }
    }
    
    announceToScreenReader(`Travel class changed to ${classId}`);
}

/**
 * Announce message to screen readers
 */
function announceToScreenReader(message) {
    const announcement = document.createElement('div');
    announcement.setAttribute('role', 'status');
    announcement.setAttribute('aria-live', 'polite');
    announcement.className = 'sr-only';
    announcement.textContent = message;
    
    document.body.appendChild(announcement);
    
    setTimeout(() => {
        announcement.remove();
    }, 1000);
}

/**
 * Get seat map data (for future API integration)
 */
function getSeatMapData(flightId) {
    // This would be replaced with an actual API call
    return {
        flightId: flightId,
        totalSeats: 180,
        availableSeats: 45,
        seatMap: {
            business: {
                rows: 3,
                seatsPerRow: 4,
                price: 50
            },
            economy: {
                rows: 25,
                seatsPerRow: 6,
                price: 15
            }
        }
    };
}

/**
 * Validate seat selection before proceeding
 */
function validateSeatSelection() {
    if (!selectedSeat) {
        window.WeengzApp.showAlert('Please select a seat before continuing', 'warning');
        return false;
    }
    
    // Validate passenger information
    const passengerForm = document.getElementById('passengerForm');
    if (passengerForm) {
        const firstName = document.getElementById('firstName')?.value;
        const lastName = document.getElementById('lastName')?.value;
        const email = document.getElementById('passengerEmail')?.value;
        const phone = document.getElementById('phone')?.value;
        
        if (!firstName || !lastName || !email || !phone) {
            window.WeengzApp.showAlert('Please fill in all passenger information', 'warning');
            return false;
        }
    }
    
    return true;
}

// Export functions
window.SeatSelection = {
    validateSeatSelection,
    selectedSeat: () => selectedSeat
};
