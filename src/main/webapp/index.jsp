<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>PMS - Login</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&family=Poppins:wght@500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
    <link href="css/theme.css" rel="stylesheet">
</head>
<body>
    <header class="pms-hero">
        <div class="container">
            <div class="text-center text-white">
                <div class="pms-hero-icon">&#10010;</div>
                <h1 class="pms-brand">Patient Management System</h1>
                <p class="pms-tagline">Coordinated care for admins, doctors, nurses, and patients &mdash; secure, role-based access in one place.</p>
            </div>
        </div>
    </header>

    <main class="pms-main">
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
                                    <input type="text" class="form-control" id="username" name="username" required>
                                </div>
                                <div class="mb-3">
                                    <label for="password" class="form-label">Password</label>
                                    <input type="password" class="form-control" id="password" name="password" required>
                                </div>
                                <div class="d-grid">
                                    <button type="submit" class="btn btn-primary">Login</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <footer class="pms-footer text-center">
        <div class="container">
            <p class="mb-0">&copy; 2026 Patient Management System &middot; Musanze Group 5</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/script.js"></script>
</body>
</html>
