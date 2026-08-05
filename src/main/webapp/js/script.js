// script.js
document.addEventListener('DOMContentLoaded', function() {
    // Initialize tooltips
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });

    // Initialize popovers
    var popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'));
    var popoverList = popoverTriggerList.map(function (popoverTriggerEl) {
        return new bootstrap.Popover(popoverTriggerEl);
    });

    // Auto-hide alerts after 5 seconds
    setTimeout(function() {
        var alerts = document.querySelectorAll('.alert-success, .alert-info');
        alerts.forEach(function(alert) {
            var bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        });
    }, 5000);

    // Form validation
    var forms = document.querySelectorAll('.needs-validation');
    Array.prototype.slice.call(forms).forEach(function (form) {
        form.addEventListener('submit', function (event) {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }
            form.classList.add('was-validated');
        }, false);
    });
    
    // Make tables sortable if sortable-table class is present
    const tables = document.querySelectorAll('.sortable-table');
    
    tables.forEach(table => {
        const headers = table.querySelectorAll('th[data-sort]');
        
        headers.forEach(header => {
            header.addEventListener('click', function() {
                const column = this.dataset.sort;
                const rows = Array.from(table.querySelectorAll('tbody tr'));
                
                // Toggle sort direction
                const direction = this.dataset.direction === 'asc' ? 'desc' : 'asc';
                
                // Update direction attribute
                headers.forEach(h => h.dataset.direction = '');
                this.dataset.direction = direction;
                
                // Sort rows
                rows.sort((a, b) => {
                    const aValue = a.querySelector(`td[data-column="${column}"]`).textContent.trim();
                    const bValue = b.querySelector(`td[data-column="${column}"]`).textContent.trim();
                    
                    // Try to parse as numbers if possible
                    const aNum = parseFloat(aValue);
                    const bNum = parseFloat(bValue);
                    
                    if (!isNaN(aNum) && !isNaN(bNum)) {
                        return direction === 'asc' ? aNum - bNum : bNum - aNum;
                    }
                    
                    // Otherwise sort as strings
                    return direction === 'asc' 
                        ? aValue.localeCompare(bValue) 
                        : bValue.localeCompare(aValue);
                });
                
                // Reorder table
                const tbody = table.querySelector('tbody');
                rows.forEach(row => tbody.appendChild(row));
            });
        });
    });
});

// Function to preview image before upload
function previewImage(input, previewId) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();
        reader.onload = function(e) {
            document.getElementById(previewId).src = e.target.result;
            document.getElementById(previewId).style.display = 'block';
        }
        reader.readAsDataURL(input.files[0]);
    }
}

// Function to confirm deletion
function confirmDelete(message, formId) {
    if (confirm(message)) {
        document.getElementById(formId).submit();
    }
    return false;
}