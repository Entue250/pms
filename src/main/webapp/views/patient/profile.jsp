<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pms.model.User, com.pms.model.Patient, com.pms.dao.UserDAO, com.pms.dao.PatientDAO" %>
<%
    // Check if user is logged in and is patient
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getUserType().equals("Patient")) {
        response.sendRedirect("../../index.jsp");
        return;
    }
    
    // Get fresh user data
    UserDAO userDAO = new UserDAO();
    PatientDAO patientDAO = new PatientDAO();
    
    User currentUser = userDAO.getUserById(user.getUserID());
    Patient patient = patientDAO.getPatientByUserId(user.getUserID());
    
    // Check for message or error
    String message = (String) session.getAttribute("message");
    String error = (String) session.getAttribute("error");
    
    // Clear session attributes
    if (message != null) {
        session.removeAttribute("message");
    }
    if (error != null) {
        session.removeAttribute("error");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <link href="../../css/style.css" rel="stylesheet">
</head>
<body>
    <!-- Include navigation bar -->
    <jsp:include page="../common/patientNav.jsp" />
    
    <div class="container mt-4">
        <div class="row">
            <div class="col-md-4">
                <div class="card mb-4">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0">My Profile</h5>
                    </div>
                    <div class="card-body text-center">
                        <% if(patient.getImageLink() != null && !patient.getImageLink().isEmpty()) { %>
                            <img src="../../<%= patient.getImageLink() %>" class="img-fluid rounded-circle mb-3" alt="Patient Image" style="max-height: 200px; max-width: 200px; object-fit: cover;">
                        <% } else { %>
                            <div class="display-1 text-info mb-3">
                                <i class="bi bi-person-circle"></i>
                            </div>
                        <% } %>
                        <h3><%= patient.getFirstName() + " " + patient.getLastName() %></h3>
                        <p class="text-muted">Patient</p>
                        
                        <hr>
                        
                        <div class="text-start">
                            <p><strong>Email:</strong> <%= patient.getEmail() %></p>
                            <p><strong>Telephone:</strong> <%= patient.getTelephone() %></p>
                            <p><strong>Address:</strong> <%= patient.getAddress() %></p>
                        </div>
                    </div>
                </div>
                
                <div class="card">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0">Account Information</h5>
                    </div>
                    <div class="card-body">
                        <p><strong>Username:</strong> <%= currentUser.getUsername() %></p>
                        <p><strong>Account Type:</strong> <%= currentUser.getUserType() %></p>
                    </div>
                </div>
            </div>
            
            <div class="col-md-8">
                <% if(request.getParameter("success") != null || message != null) { %>
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <%= (message != null) ? message : "Operation completed successfully!" %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                <% } else if(request.getParameter("error") != null || error != null) { %>
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <%= (error != null) ? error : "Error occurred. Please try again." %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                <% } %>
                
                <div class="card mb-4">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0">Personal Information</h5>
                    </div>
                    <div class="card-body">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label"><strong>First Name</strong></label>
                                <p class="form-control-plaintext"><%= patient.getFirstName() %></p>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label"><strong>Last Name</strong></label>
                                <p class="form-control-plaintext"><%= patient.getLastName() %></p>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label"><strong>Email</strong></label>
                                <p class="form-control-plaintext"><%= patient.getEmail() %></p>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label"><strong>Telephone</strong></label>
                                <p class="form-control-plaintext"><%= patient.getTelephone() %></p>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label"><strong>Address</strong></label>
                            <p class="form-control-plaintext"><%= patient.getAddress() %></p>
                        </div>
                        
                        <div class="alert alert-info">
                            <i class="bi bi-info-circle"></i> Please contact your nurse to update your profile information.
                        </div>
                    </div>
                </div>
                
                <div class="card">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0">Change Password</h5>
                    </div>
                    <div class="card-body">
                        <form action="../../updatePassword" method="post" class="needs-validation" novalidate>
                            <input type="hidden" name="userId" value="<%= currentUser.getUserID() %>">
                            
                            <div class="mb-3">
                                <label for="currentPassword" class="form-label">Current Password</label>
                                <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                                <div class="invalid-feedback">
                                    Please enter your current password.
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="newPassword" class="form-label">New Password</label>
                                    <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                                    <div class="invalid-feedback">
                                        Please enter a new password.
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label for="confirmPassword" class="form-label">Confirm New Password</label>
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                                    <div class="invalid-feedback">
                                        Passwords must match.
                                    </div>
                                </div>
                            </div>
                            
                            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                <button type="submit" class="btn btn-info text-white">Update Password</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="../../js/script.js"></script>
    <script>
        // Additional password validation
        document.getElementById('confirmPassword').addEventListener('input', function() {
            if (this.value !== document.getElementById('newPassword').value) {
                this.setCustomValidity('Passwords do not match');
            } else {
                this.setCustomValidity('');
            }
        });
    </script>
</body>
</html>