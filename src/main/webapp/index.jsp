<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Patient Management System</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&family=Poppins:wght@500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
    <link href="css/theme.css" rel="stylesheet">
</head>
<body class="pms-landing">

    <!-- ============ Navbar ============ -->
    <nav class="navbar navbar-expand-lg landing-navbar sticky-top">
        <div class="container">
            <a class="navbar-brand d-flex align-items-center gap-2" href="#home">
                <i class="bi bi-heart-pulse-fill" style="color: var(--pms-emerald); font-size: 1.5rem;"></i>
                Patient Management System
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#landingNav" aria-controls="landingNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="landingNav">
                <ul class="navbar-nav ms-auto align-items-lg-center gap-lg-1">
                    <li class="nav-item"><a class="nav-link" href="#home">Home</a></li>
                    <li class="nav-item"><a class="nav-link" href="#about">About</a></li>
                    <li class="nav-item"><a class="nav-link" href="#services">Services</a></li>
                    <li class="nav-item"><a class="nav-link" href="#insurance">Insurance</a></li>
                    <li class="nav-item"><a class="nav-link" href="#partners">Partners</a></li>
                    <li class="nav-item"><a class="nav-link" href="#testimonials">Testimonials</a></li>
                    <li class="nav-item"><a class="nav-link" href="#contact">Contact</a></li>
                    <li class="nav-item ms-lg-2 mt-2 mt-lg-0">
                        <a class="btn btn-nav-login" href="#login">Login</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- ============ Hero carousel ============ -->
    <header id="home">
        <div id="heroCarousel" class="carousel slide carousel-fade hero-carousel" data-bs-ride="carousel">
            <div class="carousel-indicators">
                <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide 1"></button>
                <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="1" aria-label="Slide 2"></button>
                <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="2" aria-label="Slide 3"></button>
                <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="3" aria-label="Slide 4"></button>
                <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="4" aria-label="Slide 5"></button>
            </div>
            <div class="carousel-inner">
                <div class="carousel-item active" style="background-image: url('images/hero1.jpg');">
                    <div class="hero-overlay">
                        <div class="container">
                            <div class="hero-content">
                                <h1>Your Health, Our Commitment</h1>
                                <p>Coordinated, role-based care for admins, doctors, nurses, and patients &mdash; all in one secure system.</p>
                                <div class="d-flex flex-wrap gap-3 mt-4">
                                    <a href="#login" class="btn btn-hero-primary">Login</a>
                                    <a href="#about" class="btn btn-hero-secondary">Learn More</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="carousel-item" style="background-image: url('images/hero2.jpg');">
                    <div class="hero-overlay">
                        <div class="container">
                            <div class="hero-content">
                                <h1>Professional Care with Modern Technology</h1>
                                <p>Digital records, faster diagnoses, and seamless coordination between every member of your care team.</p>
                                <div class="d-flex flex-wrap gap-3 mt-4">
                                    <a href="#login" class="btn btn-hero-primary">Login</a>
                                    <a href="#about" class="btn btn-hero-secondary">Learn More</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="carousel-item" style="background-image: url('images/hero3.jpg');">
                    <div class="hero-overlay">
                        <div class="container">
                            <div class="hero-content">
                                <h1>Trusted by Thousands of Patients</h1>
                                <p>A patient management platform built for accuracy, accountability, and peace of mind.</p>
                                <div class="d-flex flex-wrap gap-3 mt-4">
                                    <a href="#login" class="btn btn-hero-primary">Login</a>
                                    <a href="#about" class="btn btn-hero-secondary">Learn More</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="carousel-item" style="background-image: url('images/hero4.jpg');">
                    <div class="hero-overlay">
                        <div class="container">
                            <div class="hero-content">
                                <h1>Compassionate Healthcare Services</h1>
                                <p>Every workflow, from admission to discharge, designed around the people it serves.</p>
                                <div class="d-flex flex-wrap gap-3 mt-4">
                                    <a href="#login" class="btn btn-hero-primary">Login</a>
                                    <a href="#about" class="btn btn-hero-secondary">Learn More</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="carousel-item" style="background-image: url('images/hero5.jpg');">
                    <div class="hero-overlay">
                        <div class="container">
                            <div class="hero-content">
                                <h1>Medical Excellence Every Day</h1>
                                <p>Certified staff, secure records, and round-the-clock support for every role in the system.</p>
                                <div class="d-flex flex-wrap gap-3 mt-4">
                                    <a href="#login" class="btn btn-hero-primary">Login</a>
                                    <a href="#about" class="btn btn-hero-secondary">Learn More</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <button class="carousel-control-prev" type="button" data-bs-target="#heroCarousel" data-bs-slide="prev">
                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Previous</span>
            </button>
            <button class="carousel-control-next" type="button" data-bs-target="#heroCarousel" data-bs-slide="next">
                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Next</span>
            </button>
        </div>
    </header>

    <!-- ============ Quick stats ============ -->
    <section class="stats-section">
        <div class="container">
            <div class="row text-center g-4">
                <div class="col-6 col-lg-3" data-animate>
                    <div class="stat-number" data-count="15" data-suffix="+">0</div>
                    <div class="stat-label">Doctors</div>
                </div>
                <div class="col-6 col-lg-3" data-animate>
                    <div class="stat-number" data-count="30" data-suffix="+">0</div>
                    <div class="stat-label">Nurses</div>
                </div>
                <div class="col-6 col-lg-3" data-animate>
                    <div class="stat-number" data-count="20000" data-suffix="+">0</div>
                    <div class="stat-label">Patients</div>
                </div>
                <div class="col-6 col-lg-3" data-animate>
                    <div class="stat-number" data-count="10" data-suffix="+">0</div>
                    <div class="stat-label">Years Experience</div>
                </div>
            </div>
        </div>
    </section>

    <!-- ============ About us ============ -->
    <section id="about" class="about-section">
        <div class="container">
            <div class="row align-items-center g-4">
                <div class="col-lg-6 about-image" data-animate="zoom">
                    <img src="images/about.jpg" class="img-fluid" alt="Patient Management System facility overview">
                </div>
                <div class="col-lg-6" data-animate>
                    <div class="badge-eyebrow mb-2">About Us</div>
                    <h2 class="section-title mb-3">Care Coordination Built Around People</h2>
                    <p>The Patient Management System brings administrators, doctors, nurses, and patients onto one
                        secure platform &mdash; replacing paper records and disconnected spreadsheets with a single
                        source of truth for every case.</p>
                    <div class="row g-3 mt-2">
                        <div class="col-md-6 d-flex gap-3">
                            <span class="about-value-icon"><i class="bi bi-bullseye"></i></span>
                            <div>
                                <h6 class="mb-1">Our Mission</h6>
                                <p class="mb-0 small">Give every care team accurate, real-time patient information.</p>
                            </div>
                        </div>
                        <div class="col-md-6 d-flex gap-3">
                            <span class="about-value-icon"><i class="bi bi-eye"></i></span>
                            <div>
                                <h6 class="mb-1">Our Vision</h6>
                                <p class="mb-0 small">A connected record for every patient, at every stage of care.</p>
                            </div>
                        </div>
                        <div class="col-md-6 d-flex gap-3">
                            <span class="about-value-icon"><i class="bi bi-shield-check"></i></span>
                            <div>
                                <h6 class="mb-1">Core Value</h6>
                                <p class="mb-0 small">Security and accuracy in every record, every time.</p>
                            </div>
                        </div>
                        <div class="col-md-6 d-flex gap-3">
                            <span class="about-value-icon"><i class="bi bi-people"></i></span>
                            <div>
                                <h6 class="mb-1">Core Value</h6>
                                <p class="mb-0 small">Designed around the people who use it every day.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ============ Why choose us ============ -->
    <section class="why-us-section">
        <div class="container text-center">
            <div class="section-eyebrow">Why Choose Us</div>
            <h2 class="section-title mb-3">Care You Can Rely On</h2>
            <p class="section-subtitle mx-auto mb-5">Every part of the system is built to support faster, safer, more
                accountable care.</p>
            <div class="row g-4 text-start">
                <div class="col-md-6 col-lg-4" data-animate>
                    <div class="why-us-card">
                        <div class="why-us-icon"><i class="bi bi-patch-check-fill"></i></div>
                        <h5>Certified Doctors</h5>
                        <p class="mb-0 small text-muted">Every doctor account is verified and credentialed before activation.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4" data-animate>
                    <div class="why-us-card">
                        <div class="why-us-icon"><i class="bi bi-cpu-fill"></i></div>
                        <h5>Modern Equipment</h5>
                        <p class="mb-0 small text-muted">Digital workflows replace manual, error-prone paperwork.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4" data-animate>
                    <div class="why-us-card">
                        <div class="why-us-icon"><i class="bi bi-headset"></i></div>
                        <h5>24/7 Support</h5>
                        <p class="mb-0 small text-muted">Nurses and staff can act on patient cases around the clock.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4" data-animate>
                    <div class="why-us-card">
                        <div class="why-us-icon"><i class="bi bi-hospital"></i></div>
                        <h5>Emergency Services</h5>
                        <p class="mb-0 small text-muted">Urgent cases are flagged and routed to the right care team fast.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4" data-animate>
                    <div class="why-us-card">
                        <div class="why-us-icon"><i class="bi bi-lock-fill"></i></div>
                        <h5>Secure Medical Records</h5>
                        <p class="mb-0 small text-muted">Role-based access and hashed credentials protect every record.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4" data-animate>
                    <div class="why-us-card">
                        <div class="why-us-icon"><i class="bi bi-piggy-bank-fill"></i></div>
                        <h5>Affordable Care</h5>
                        <p class="mb-0 small text-muted">Lower administrative overhead means more focus on patients.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ============ Services ============ -->
    <section id="services" class="services-section">
        <div class="container text-center">
            <div class="section-eyebrow">Our Services</div>
            <h2 class="section-title mb-3">What We Offer</h2>
            <p class="section-subtitle mx-auto mb-5">A full set of role-based workflows for every stage of patient care.</p>
            <div class="row g-4 text-start">
                <div class="col-sm-6 col-lg-3" data-animate>
                    <div class="service-card">
                        <div class="service-icon"><i class="bi bi-clipboard2-pulse"></i></div>
                        <h6>General Consultation</h6>
                        <p class="small text-muted mb-0">Initial assessment and diagnosis intake.</p>
                    </div>
                </div>
                <div class="col-sm-6 col-lg-3" data-animate>
                    <div class="service-card">
                        <div class="service-icon"><i class="bi bi-droplet-half"></i></div>
                        <h6>Laboratory</h6>
                        <p class="small text-muted mb-0">Test results linked directly to patient records.</p>
                    </div>
                </div>
                <div class="col-sm-6 col-lg-3" data-animate>
                    <div class="service-card">
                        <div class="service-icon"><i class="bi bi-truck"></i></div>
                        <h6>Emergency Care</h6>
                        <p class="small text-muted mb-0">Rapid case referral for urgent conditions.</p>
                    </div>
                </div>
                <div class="col-sm-6 col-lg-3" data-animate>
                    <div class="service-card">
                        <div class="service-icon"><i class="bi bi-capsule"></i></div>
                        <h6>Pharmacy</h6>
                        <p class="small text-muted mb-0">Prescription tracking tied to diagnosis history.</p>
                    </div>
                </div>
                <div class="col-sm-6 col-lg-3" data-animate>
                    <div class="service-card">
                        <div class="service-icon"><i class="bi bi-emoji-smile"></i></div>
                        <h6>Pediatrics</h6>
                        <p class="small text-muted mb-0">Dedicated records and care plans for younger patients.</p>
                    </div>
                </div>
                <div class="col-sm-6 col-lg-3" data-animate>
                    <div class="service-card">
                        <div class="service-icon"><i class="bi bi-scissors"></i></div>
                        <h6>Surgery</h6>
                        <p class="small text-muted mb-0">Scheduling and case notes for surgical patients.</p>
                    </div>
                </div>
                <div class="col-sm-6 col-lg-3" data-animate>
                    <div class="service-card">
                        <div class="service-icon"><i class="bi bi-heart-pulse"></i></div>
                        <h6>Maternity</h6>
                        <p class="small text-muted mb-0">Ongoing care tracking through every stage.</p>
                    </div>
                </div>
                <div class="col-sm-6 col-lg-3" data-animate>
                    <div class="service-card">
                        <div class="service-icon"><i class="bi bi-file-earmark-medical"></i></div>
                        <h6>Patient Records</h6>
                        <p class="small text-muted mb-0">A single, secure history for every patient.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ============ Insurance ============ -->
    <section id="insurance" class="insurance-section">
        <div class="container text-center">
            <div class="section-eyebrow">Trusted Insurance Companies</div>
            <h2 class="section-title mb-5">We Work With</h2>
            <div class="row g-4 justify-content-center">
                <div class="col-6 col-md-4 col-lg-2" data-animate><div class="logo-tile"><img src="images/insurance1.png" alt="Insurance partner logo"></div></div>
                <div class="col-6 col-md-4 col-lg-2" data-animate><div class="logo-tile"><img src="images/insurance2.png" alt="Insurance partner logo"></div></div>
                <div class="col-6 col-md-4 col-lg-2" data-animate><div class="logo-tile"><img src="images/insurance3.png" alt="Insurance partner logo"></div></div>
                <div class="col-6 col-md-4 col-lg-2" data-animate><div class="logo-tile"><img src="images/insurance4.png" alt="Insurance partner logo"></div></div>
                <div class="col-6 col-md-4 col-lg-2" data-animate><div class="logo-tile"><img src="images/insurance5.png" alt="Insurance partner logo"></div></div>
                <div class="col-6 col-md-4 col-lg-2" data-animate><div class="logo-tile"><img src="images/insurance6.png" alt="Insurance partner logo"></div></div>
            </div>
        </div>
    </section>

    <!-- ============ Verified partners ============ -->
    <section id="partners" class="partners-section">
        <div class="container text-center">
            <div class="section-eyebrow">Verified Trusted Companies</div>
            <h2 class="section-title mb-5">Our Partners</h2>
            <div class="row g-4 justify-content-center">
                <div class="col-6 col-md-4 col-lg-2" data-animate><div class="logo-tile"><img src="images/partner1.png" alt="Medical suppliers partner logo"></div></div>
                <div class="col-6 col-md-4 col-lg-2" data-animate><div class="logo-tile"><img src="images/partner2.png" alt="Diagnostic labs partner logo"></div></div>
                <div class="col-6 col-md-4 col-lg-2" data-animate><div class="logo-tile"><img src="images/partner3.png" alt="Pharmaceutical company partner logo"></div></div>
                <div class="col-6 col-md-4 col-lg-2" data-animate><div class="logo-tile"><img src="images/partner4.png" alt="Health NGO partner logo"></div></div>
                <div class="col-6 col-md-4 col-lg-2" data-animate><div class="logo-tile"><img src="images/partner5.png" alt="Government health agency partner logo"></div></div>
            </div>
        </div>
    </section>

    <!-- ============ Meet our team ============ -->
    <section class="team-section">
        <div class="container text-center">
            <div class="section-eyebrow">Meet Our Team</div>
            <h2 class="section-title mb-3">The People Behind Your Care</h2>
            <p class="section-subtitle mx-auto mb-5">A preview of the certified staff using the system every day.</p>
            <div class="row g-4">
                <div class="col-sm-6 col-lg-4" data-animate>
                    <div class="team-card">
                        <img src="images/doctor1.jpg" alt="Doctor team member">
                        <div class="team-name">Dr. A. Uwase</div>
                        <div class="team-role mb-2">Doctor</div>
                        <div class="social-icons">
                            <a href="#" aria-label="Facebook"><i class="bi bi-facebook"></i></a>
                            <a href="#" aria-label="Twitter"><i class="bi bi-twitter"></i></a>
                            <a href="#" aria-label="LinkedIn"><i class="bi bi-linkedin"></i></a>
                        </div>
                    </div>
                </div>
                <div class="col-sm-6 col-lg-4" data-animate>
                    <div class="team-card">
                        <img src="images/doctor2.jpg" alt="Doctor team member">
                        <div class="team-name">Dr. E. Habimana</div>
                        <div class="team-role mb-2">Doctor</div>
                        <div class="social-icons">
                            <a href="#" aria-label="Facebook"><i class="bi bi-facebook"></i></a>
                            <a href="#" aria-label="Twitter"><i class="bi bi-twitter"></i></a>
                            <a href="#" aria-label="LinkedIn"><i class="bi bi-linkedin"></i></a>
                        </div>
                    </div>
                </div>
                <div class="col-sm-6 col-lg-4" data-animate>
                    <div class="team-card">
                        <img src="images/doctor3.jpg" alt="Doctor team member">
                        <div class="team-name">Dr. J. Mugisha</div>
                        <div class="team-role mb-2">Doctor</div>
                        <div class="social-icons">
                            <a href="#" aria-label="Facebook"><i class="bi bi-facebook"></i></a>
                            <a href="#" aria-label="Twitter"><i class="bi bi-twitter"></i></a>
                            <a href="#" aria-label="LinkedIn"><i class="bi bi-linkedin"></i></a>
                        </div>
                    </div>
                </div>
                <div class="col-sm-6 col-lg-4" data-animate>
                    <div class="team-card">
                        <img src="images/nurse1.jpg" alt="Nurse team member">
                        <div class="team-name">R. Mukamana</div>
                        <div class="team-role mb-2">Nurse</div>
                        <div class="social-icons">
                            <a href="#" aria-label="Facebook"><i class="bi bi-facebook"></i></a>
                            <a href="#" aria-label="Twitter"><i class="bi bi-twitter"></i></a>
                            <a href="#" aria-label="LinkedIn"><i class="bi bi-linkedin"></i></a>
                        </div>
                    </div>
                </div>
                <div class="col-sm-6 col-lg-4" data-animate>
                    <div class="team-card">
                        <img src="images/nurse2.jpg" alt="Nurse team member">
                        <div class="team-name">P. Ingabire</div>
                        <div class="team-role mb-2">Nurse</div>
                        <div class="social-icons">
                            <a href="#" aria-label="Facebook"><i class="bi bi-facebook"></i></a>
                            <a href="#" aria-label="Twitter"><i class="bi bi-twitter"></i></a>
                            <a href="#" aria-label="LinkedIn"><i class="bi bi-linkedin"></i></a>
                        </div>
                    </div>
                </div>
                <div class="col-sm-6 col-lg-4" data-animate>
                    <div class="team-card">
                        <img src="images/admin1.jpg" alt="Administrator team member">
                        <div class="team-name">C. Niyonzima</div>
                        <div class="team-role mb-2">Administrator</div>
                        <div class="social-icons">
                            <a href="#" aria-label="Facebook"><i class="bi bi-facebook"></i></a>
                            <a href="#" aria-label="Twitter"><i class="bi bi-twitter"></i></a>
                            <a href="#" aria-label="LinkedIn"><i class="bi bi-linkedin"></i></a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ============ Testimonials ============ -->
    <section id="testimonials" class="testimonials-section">
        <div class="container text-center">
            <div class="section-eyebrow" style="color:#6ee7b7;">Testimonials</div>
            <h2 class="section-title mb-5" style="color:#fff;">What Patients Say</h2>
            <div id="testimonialCarousel" class="carousel slide" data-bs-ride="carousel">
                <div class="carousel-inner">
                    <div class="carousel-item active">
                        <div class="testimonial-card">
                            <img src="images/patient1.jpg" alt="Patient photo">
                            <div class="stars"><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i></div>
                            <blockquote>&ldquo;Booking and follow-up have never been this easy. I can see my results the moment they're ready.&rdquo;</blockquote>
                            <div class="testimonial-name">A. Mutoni</div>
                            <div class="testimonial-role">Patient</div>
                        </div>
                    </div>
                    <div class="carousel-item">
                        <div class="testimonial-card">
                            <img src="images/patient2.jpg" alt="Patient photo">
                            <div class="stars"><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i></div>
                            <blockquote>&ldquo;The staff always know my history the moment I walk in. It feels like real coordinated care.&rdquo;</blockquote>
                            <div class="testimonial-name">J. Kagabo</div>
                            <div class="testimonial-role">Patient</div>
                        </div>
                    </div>
                    <div class="carousel-item">
                        <div class="testimonial-card">
                            <img src="images/patient3.jpg" alt="Patient photo">
                            <div class="stars"><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i></div>
                            <blockquote>&ldquo;Transparent, fast, and secure. I trust this system with my family's records.&rdquo;</blockquote>
                            <div class="testimonial-name">S. Niyibizi</div>
                            <div class="testimonial-role">Patient</div>
                        </div>
                    </div>
                    <div class="carousel-item">
                        <div class="testimonial-card">
                            <img src="images/patient4.jpg" alt="Patient photo">
                            <div class="stars"><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i></div>
                            <blockquote>&ldquo;Every appointment has been on time and well documented. Highly recommended.&rdquo;</blockquote>
                            <div class="testimonial-name">T. Bizimana</div>
                            <div class="testimonial-role">Patient</div>
                        </div>
                    </div>
                    <div class="carousel-item">
                        <div class="testimonial-card">
                            <img src="images/patient5.jpg" alt="Patient photo">
                            <div class="stars"><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i></div>
                            <blockquote>&ldquo;Compassionate staff and a system that actually works the way it should.&rdquo;</blockquote>
                            <div class="testimonial-name">M. Uwimana</div>
                            <div class="testimonial-role">Patient</div>
                        </div>
                    </div>
                </div>
                <button class="carousel-control-prev" type="button" data-bs-target="#testimonialCarousel" data-bs-slide="prev">
                    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                    <span class="visually-hidden">Previous</span>
                </button>
                <button class="carousel-control-next" type="button" data-bs-target="#testimonialCarousel" data-bs-slide="next">
                    <span class="carousel-control-next-icon" aria-hidden="true"></span>
                    <span class="visually-hidden">Next</span>
                </button>
            </div>
        </div>
    </section>

    <!-- ============ FAQ ============ -->
    <section class="faq-section">
        <div class="container">
            <div class="text-center mb-5">
                <div class="section-eyebrow">FAQ</div>
                <h2 class="section-title">Frequently Asked Questions</h2>
            </div>
            <div class="accordion mx-auto" id="faqAccordion" style="max-width: 760px;">
                <div class="accordion-item">
                    <h2 class="accordion-header">
                        <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#faq1">
                            How do I register?
                        </button>
                    </h2>
                    <div id="faq1" class="accordion-collapse collapse show" data-bs-parent="#faqAccordion">
                        <div class="accordion-body">Patient accounts are created by clinic staff during your first visit,
                            or by an administrator. Once created, you can log in with the credentials provided to you.</div>
                    </div>
                </div>
                <div class="accordion-item">
                    <h2 class="accordion-header">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq2">
                            Can I access my diagnosis online?
                        </button>
                    </h2>
                    <div id="faq2" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                        <div class="accordion-body">Yes. Once logged in, patients can view their diagnoses and results
                            from their dashboard as soon as a doctor records them.</div>
                    </div>
                </div>
                <div class="accordion-item">
                    <h2 class="accordion-header">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq3">
                            How do appointments work?
                        </button>
                    </h2>
                    <div id="faq3" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                        <div class="accordion-body">Nurses and doctors coordinate case referrals and follow-ups directly
                            through the system, so your care team always has an up-to-date view of your case.</div>
                    </div>
                </div>
                <div class="accordion-item">
                    <h2 class="accordion-header">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq4">
                            Is my information secure?
                        </button>
                    </h2>
                    <div id="faq4" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                        <div class="accordion-body">Passwords are hashed with bcrypt and access is role-based, so each
                            user only sees the records relevant to their role.</div>
                    </div>
                </div>
                <div class="accordion-item">
                    <h2 class="accordion-header">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq5">
                            Who do I contact for help?
                        </button>
                    </h2>
                    <div id="faq5" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                        <div class="accordion-body">Use the contact form below, or reach out to your clinic's front
                            desk for account or access issues.</div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ============ CTA ============ -->
    <section class="cta-section">
        <div class="container">
            <h2 class="mb-3">Ready to Access Your Dashboard?</h2>
            <p class="mb-4" style="color: rgba(255,255,255,0.85);">Log in to continue your care, or reach out if you have questions.</p>
            <div class="d-flex flex-wrap gap-3 justify-content-center">
                <a href="#login" class="btn btn-cta-primary">Login</a>
                <a href="#contact" class="btn btn-cta-secondary">Contact Us</a>
            </div>
        </div>
    </section>

    <!-- ============ Contact ============ -->
    <section id="contact" class="contact-section">
        <div class="container">
            <div class="text-center mb-5">
                <div class="section-eyebrow">Contact</div>
                <h2 class="section-title">Get in Touch</h2>
            </div>
            <div class="row g-4">
                <div class="col-lg-5">
                    <div class="contact-info-item">
                        <span class="contact-info-icon"><i class="bi bi-geo-alt-fill"></i></span>
                        <div>
                            <h6 class="mb-1">Address</h6>
                            <p class="mb-0 text-muted">Musanze Campus, University of Rwanda, Musanze, Rwanda</p>
                        </div>
                    </div>
                    <div class="contact-info-item">
                        <span class="contact-info-icon"><i class="bi bi-telephone-fill"></i></span>
                        <div>
                            <h6 class="mb-1">Phone</h6>
                            <p class="mb-0 text-muted">+250 700 000 000</p>
                        </div>
                    </div>
                    <div class="contact-info-item">
                        <span class="contact-info-icon"><i class="bi bi-envelope-fill"></i></span>
                        <div>
                            <h6 class="mb-1">Email</h6>
                            <p class="mb-0 text-muted">support@pms-musanze.example</p>
                        </div>
                    </div>
                    <div class="map-placeholder mt-4">
                        <i class="bi bi-map fs-1 mb-2"></i>
                        <div>Map placeholder &mdash; embed a real map once an API key is available.</div>
                    </div>
                </div>
                <div class="col-lg-7">
                    <form class="contact-form js-placeholder-form">
                        <div class="alert alert-success d-none form-submit-feedback" role="alert">
                            Thanks! This form is a visual placeholder for now &mdash; no message was actually sent.
                        </div>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label for="contactName" class="form-label">Name</label>
                                <input type="text" class="form-control" id="contactName" name="name" required>
                            </div>
                            <div class="col-md-6">
                                <label for="contactEmail" class="form-label">Email</label>
                                <input type="email" class="form-control" id="contactEmail" name="email" required>
                            </div>
                            <div class="col-12">
                                <label for="contactSubject" class="form-label">Subject</label>
                                <input type="text" class="form-control" id="contactSubject" name="subject" required>
                            </div>
                            <div class="col-12">
                                <label for="contactMessage" class="form-label">Message</label>
                                <textarea class="form-control" id="contactMessage" name="message" rows="4" required></textarea>
                            </div>
                            <div class="col-12">
                                <button type="submit" class="btn btn-nav-login">Send Message</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </section>

    <!-- ============ Login ============ -->
    <section id="login" class="pms-login-section">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-11 col-sm-8 col-md-6 col-lg-5">
                    <div class="card pms-login-card">
                        <div class="card-body p-4 p-md-5">
                            <h2 class="pms-login-title text-center mb-4">Sign In</h2>

                            <% if(request.getAttribute("errorMessage") != null) { %>
                                <div class="alert alert-danger">
                                    <%= request.getAttribute("errorMessage") %>
                                </div>
                            <% } %>

                            <form action="login" method="post">
                                <div class="mb-3">
                                    <label for="username" class="form-label">Username</label>
                                    <div class="input-icon-wrap">
                                        <i class="bi bi-person-fill"></i>
                                        <input type="text" class="form-control" id="username" name="username" required>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label for="password" class="form-label">Password</label>
                                    <div class="input-icon-wrap">
                                        <i class="bi bi-lock-fill"></i>
                                        <input type="password" class="form-control" id="password" name="password" required>
                                        <button type="button" class="toggle-password" data-toggle-password="password" aria-label="Show or hide password">
                                            <i class="bi bi-eye"></i>
                                        </button>
                                    </div>
                                </div>
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="rememberMe" name="rememberMe">
                                        <label class="form-check-label" for="rememberMe">Remember me</label>
                                    </div>
                                    <a href="#" class="small">Forgot password?</a>
                                </div>
                                <div class="d-grid">
                                    <button type="submit" class="btn btn-login">Login</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ============ Footer ============ -->
    <footer class="site-footer">
        <div class="container">
            <div class="row g-4">
                <div class="col-lg-4">
                    <h5 class="text-white d-flex align-items-center gap-2">
                        <i class="bi bi-heart-pulse-fill" style="color: var(--pms-emerald);"></i>
                        Patient Management System
                    </h5>
                    <p class="small">A coordinated care platform for administrators, doctors, nurses, and patients.</p>
                    <div class="footer-social mt-3">
                        <a href="#" aria-label="Facebook"><i class="bi bi-facebook"></i></a>
                        <a href="#" aria-label="Twitter"><i class="bi bi-twitter"></i></a>
                        <a href="#" aria-label="LinkedIn"><i class="bi bi-linkedin"></i></a>
                        <a href="#" aria-label="Instagram"><i class="bi bi-instagram"></i></a>
                    </div>
                </div>
                <div class="col-6 col-lg-2">
                    <h6>Quick Links</h6>
                    <ul class="list-unstyled">
                        <li><a href="#home">Home</a></li>
                        <li><a href="#about">About</a></li>
                        <li><a href="#services">Services</a></li>
                        <li><a href="#testimonials">Testimonials</a></li>
                        <li><a href="#login">Login</a></li>
                    </ul>
                </div>
                <div class="col-6 col-lg-2">
                    <h6>Services</h6>
                    <ul class="list-unstyled">
                        <li><a href="#services">Consultation</a></li>
                        <li><a href="#services">Laboratory</a></li>
                        <li><a href="#services">Emergency Care</a></li>
                        <li><a href="#services">Pharmacy</a></li>
                    </ul>
                </div>
                <div class="col-lg-4">
                    <h6>Working Hours</h6>
                    <p class="small mb-1">Mon &ndash; Fri: 7:00 AM &ndash; 8:00 PM</p>
                    <p class="small mb-3">Sat &ndash; Sun: Emergency care only</p>
                    <h6>Newsletter</h6>
                    <form class="newsletter-form d-flex js-placeholder-form">
                        <div class="alert alert-success d-none form-submit-feedback py-1 px-2 small mb-2" role="alert">Subscribed! (placeholder)</div>
                        <input type="email" class="form-control" placeholder="Your email" aria-label="Newsletter email" required>
                        <button class="btn" type="submit"><i class="bi bi-send-fill"></i></button>
                    </form>
                </div>
            </div>
            <div class="footer-bottom d-flex flex-wrap justify-content-between gap-2">
                <span>&copy; 2026 Patient Management System &middot; Musanze Group 5</span>
                <span>
                    <a href="#" class="me-3">Privacy Policy</a>
                    <a href="#">Terms of Service</a>
                </span>
            </div>
        </div>
    </footer>

    <button type="button" class="back-to-top" aria-label="Back to top">
        <i class="bi bi-arrow-up"></i>
    </button>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/script.js"></script>
</body>
</html>
