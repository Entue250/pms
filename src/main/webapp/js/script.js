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

    // ---- Landing page only (guarded so dashboard pages are unaffected) ----
    if (document.body.classList.contains('pms-landing')) {
        initLandingNavbar();
        initScrollReveal();
        initStatCounters();
        initBackToTop();
        initPasswordToggles();
        initPlaceholderForms();
        initScrollSpyHashSync();
    }
});

// Keeps the URL hash in sync with whichever section Bootstrap's ScrollSpy
// currently considers active, without triggering a scroll jump of its own
// (history.replaceState does not scroll, unlike setting location.hash).
function initScrollSpyHashSync() {
    document.body.addEventListener('activate.bs.scrollspy', function (event) {
        const link = event.relatedTarget;
        const href = link && link.getAttribute('href');
        if (href && href.startsWith('#')) {
            history.replaceState(null, '', href);
        }
    });
}

// Sticky navbar gains a shadow once the page scrolls past the hero
function initLandingNavbar() {
    const navbar = document.querySelector('.landing-navbar');
    if (!navbar) return;
    const onScroll = function () {
        navbar.classList.toggle('navbar-scrolled', window.scrollY > 40);
    };
    window.addEventListener('scroll', onScroll);
    onScroll();
}

// Lightweight fade/slide/zoom-in-on-scroll for elements with [data-animate]
function initScrollReveal() {
    const targets = document.querySelectorAll('[data-animate]');
    if (!targets.length) return;
    if (!('IntersectionObserver' in window)) {
        targets.forEach(el => el.classList.add('in-view'));
        return;
    }
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('in-view');
                observer.unobserve(entry.target);
            }
        });
    }, { threshold: 0.15 });
    targets.forEach(el => observer.observe(el));
}

// Animates the "15+ Doctors / 20,000+ Patients" style counters once visible
function initStatCounters() {
    const counters = document.querySelectorAll('[data-count]');
    if (!counters.length) return;

    const animateCounter = function (el) {
        const target = parseInt(el.dataset.count, 10) || 0;
        const suffix = el.dataset.suffix || '';
        const duration = 1500;
        const start = performance.now();

        function tick(now) {
            const progress = Math.min((now - start) / duration, 1);
            const value = Math.floor(progress * target);
            el.textContent = value.toLocaleString() + suffix;
            if (progress < 1) {
                requestAnimationFrame(tick);
            } else {
                el.textContent = target.toLocaleString() + suffix;
            }
        }
        requestAnimationFrame(tick);
    };

    if (!('IntersectionObserver' in window)) {
        counters.forEach(animateCounter);
        return;
    }
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                animateCounter(entry.target);
                observer.unobserve(entry.target);
            }
        });
    }, { threshold: 0.4 });
    counters.forEach(el => observer.observe(el));
}

// Back-to-top button: shows after scrolling, scrolls smoothly to top on click
function initBackToTop() {
    const btn = document.querySelector('.back-to-top');
    if (!btn) return;
    window.addEventListener('scroll', function () {
        btn.classList.toggle('show', window.scrollY > 400);
    });
    btn.addEventListener('click', function () {
        window.scrollTo({ top: 0, behavior: 'smooth' });
    });
}

// Show/hide password toggle for any input wired with a matching
// [data-toggle-password="<input id>"] button
function initPasswordToggles() {
    document.querySelectorAll('[data-toggle-password]').forEach(function (btn) {
        const input = document.getElementById(btn.dataset.togglePassword);
        if (!input) return;
        btn.addEventListener('click', function () {
            const showing = input.type === 'text';
            input.type = showing ? 'password' : 'text';
            const icon = btn.querySelector('i');
            if (icon) {
                icon.classList.toggle('bi-eye', showing);
                icon.classList.toggle('bi-eye-slash', !showing);
            }
        });
    });
}

// Contact + newsletter forms have no backend yet - acknowledge the submit
// visually instead of navigating away, per the "visually complete, backend
// integration not required yet" requirement.
function initPlaceholderForms() {
    document.querySelectorAll('.js-placeholder-form').forEach(function (form) {
        form.addEventListener('submit', function (event) {
            event.preventDefault();
            const feedback = form.querySelector('.form-submit-feedback');
            if (feedback) {
                feedback.classList.remove('d-none');
                setTimeout(() => feedback.classList.add('d-none'), 4000);
            }
            form.reset();
        });
    });
}

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