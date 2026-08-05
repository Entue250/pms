<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pms.model.User, com.pms.dao.UserDAO" %>
<%
    // Check if user is logged in and is admin
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getUserType().equals("Admin")) {
        response.sendRedirect("../../index.jsp");
        return;
    }
    
    // Get fresh user data
    UserDAO userDAO = new UserDAO();
    User currentUser = userDAO.getUserById(user.getUserID());
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <link href="../../css/style.css" rel="stylesheet">
</head>
<body>
    <!-- Include navigation bar -->
    <jsp:include page="../common/adminNav.jsp" />
    
    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Admin Profile</h5>
                    </div>
                    <div class="card-body">
                        <% if(request.getParameter("success") != null) { %>
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                Profile updated successfully!
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        <% } else if(request.getParameter("error") != null) { %>
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                Error updating profile. Please try again.
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        <% } %>
                        
                        <div class="row mb-4">
                            <div class="col-md-12 text-center">
                                <div class="display-1 text-primary mb-3">
                                    <i class="bi bi-person-circle"></i>
                                </div>
                                <h3><%= currentUser.getUsername() %></h3>
                                <p class="text-muted">System Administrator</p>
                            </div>
                        </div>
                        
                        <div class="mb-4">
                            <h5>Account Information</h5>
                            <hr>
                            <div class="row">
                                <div class="col-md-6">
                                    <p><strong>Username:</strong> <%= currentUser.getUsername() %></p>
                                </div>
                                <div class="col-md-6">
                                    <p><strong>User Type:</strong> <%= currentUser.getUserType() %></p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="mb-4">
                            <h5>Change Password</h5>
                            <hr>
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
                                    <button type="submit" class="btn btn-primary">Update Password</button>
                                </div>
                            </form>
                        </div>
                        
                        <div class="mb-3">
                            <h5>System Activity</h5>
                            <hr>
                            <div class="row">
                                <div class="col-md-6">
                                    <p><strong>Last Login:</strong> <%= new java.util.Date() %></p>
                                </div>
                                <div class="col-md-6">
                                    <p><strong>IP Address:</strong> <%= request.getRemoteAddr() %></p>
                                </div>
                            </div>
                        </div>
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