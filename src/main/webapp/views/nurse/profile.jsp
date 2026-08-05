<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pms.model.User, com.pms.model.Nurse, com.pms.dao.UserDAO, com.pms.dao.NurseDAO, com.pms.dao.DiagnosisDAO, java.util.List" %>
<%
    // Check if user is logged in and is nurse
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getUserType().equals("Nurse")) {
        response.sendRedirect("../../index.jsp");
        return;
    }
    
    // Get fresh user data
    UserDAO userDAO = new UserDAO();
    NurseDAO nurseDAO = new NurseDAO();
    DiagnosisDAO diagnosisDAO = new DiagnosisDAO();
    
    User currentUser = userDAO.getUserById(user.getUserID());
    Nurse nurse = nurseDAO.getNurseByUserId(user.getUserID());
    
    int totalPatients = diagnosisDAO.getCasesByNurse(nurse.getNurseId());
    int pendingCases = diagnosisDAO.getPendingCasesByNurse(nurse.getNurseId());
    int confirmedCases = diagnosisDAO.getConfirmedCasesByNurse(nurse.getNurseId());
    
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
    <title>Nurse Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <link href="../../css/style.css" rel="stylesheet">
</head>
<body>
    <!-- Include navigation bar -->
    <jsp:include page="../common/nurseNav.jsp" />
    
    <div class="container mt-4">
        <div class="row">
            <div class="col-md-4">
                <div class="card mb-4">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0">Nurse Profile</h5>
                    </div>
                    <div class="card-body text-center">
                        <div class="display-1 text-success mb-3">
                            <i class="bi bi-person-circle"></i>
                        </div>
                        <h3><%= nurse.getFirstName() + " " + nurse.getLastName() %></h3>
                        <p class="text-muted"><%= nurse.getHealthCenter() %></p>
                        
                        <hr>
                        
                        <div class="text-start">
                            <p><strong>Email:</strong> <%= nurse.getEmail() %></p>
                            <p><strong>Telephone:</strong> <%= nurse.getTelephone() %></p>
                            <p><strong>Address:</strong> <%= nurse.getAddress() %></p>
                        </div>
                        
                        <hr>
                        
                        <div class="row text-center">
                            <div class="col-4">
                                <div class="h4"><%= totalPatients %></div>
                                <div class="small text-muted">Patients</div>
                            </div>
                            <div class="col-4">
                                <div class="h4"><%= pendingCases %></div>
                                <div class="small text-muted">Pending</div>
                            </div>
                            <div class="col-4">
                                <div class="h4"><%= confirmedCases %></div>
                                <div class="small text-muted">Confirmed</div>
                            </div>
                        </div>
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
                
                <!-- Profile Information Card (Read-only) -->
                <div class="card mb-4">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0">Profile Information</h5>
                    </div>
                    <div class="card-body">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label"><strong>First Name</strong></label>
                                <p class="form-control-plaintext"><%= nurse.getFirstName() %></p>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label"><strong>Last Name</strong></label>
                                <p class="form-control-plaintext"><%= nurse.getLastName() %></p>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label"><strong>Email</strong></label>
                                <p class="form-control-plaintext"><%= nurse.getEmail() %></p>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label"><strong>Telephone</strong></label>
                                <p class="form-control-plaintext"><%= nurse.getTelephone() %></p>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label"><strong>Address</strong></label>
                            <p class="form-control-plaintext"><%= nurse.getAddress() %></p>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label"><strong>Health Center</strong></label>
                            <p class="form-control-plaintext"><%= nurse.getHealthCenter() %></p>
                        </div>
                        
                        <div class="alert alert-info">
                            <i class="bi bi-info-circle"></i> Please contact your doctor to update your profile information.
                        </div>
                    </div>
                </div>
                
                <div class="card">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0">Change Password</h5>
                    </div>
                    <div class="card-body">
                        <form action="../../updatePassword" method="post" class="needs-validation" novalidate>
                            <input type="hidden" name="userId" value="<%= currentUser.getUserID() %>">
                            
                            <div class="mb-3">
                                <label for="currentPassword" class="form-label">Current Password</label>
                                <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="newPassword" class="form-label">New Password</label>
                                    <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="confirmPassword" class="form-label">Confirm New Password</label>
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                                </div>
                            </div>
                            
                            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                <button type="submit" class="btn btn-success">Update Password</button>
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