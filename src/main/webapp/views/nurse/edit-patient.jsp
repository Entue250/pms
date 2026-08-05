<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pms.model.User, com.pms.model.Nurse, com.pms.dao.NurseDAO, com.pms.dao.PatientDAO, com.pms.model.Patient" %>
<%
    // Check if user is logged in and is nurse
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getUserType().equals("Nurse")) {
        response.sendRedirect("../../index.jsp");
        return;
    }
    
    // Get nurse information
    NurseDAO nurseDAO = new NurseDAO();
    Nurse nurse = nurseDAO.getNurseByUserId(user.getUserID());
    
    // Get patient ID from request parameter
    int patientId = 0;
    try {
        patientId = Integer.parseInt(request.getParameter("id"));
    } catch (NumberFormatException e) {
        response.sendRedirect("patients.jsp");
        return;
    }
    
    // Get patient information
    PatientDAO patientDAO = new PatientDAO();
    Patient patient = patientDAO.getPatientById(patientId);
    
    if (patient == null) {
        response.sendRedirect("patients.jsp");
        return;
    }
    
    // Check for messages
    String message = (String) session.getAttribute("message");
    String error = (String) session.getAttribute("error");
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
    <title>Edit Patient - Nurse Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
</head>
<body>
    <!-- Include navigation bar -->
    <jsp:include page="../common/nurseNav.jsp" />
    
    <div class="container-fluid mt-4">
        <div class="row mb-4">
            <div class="col-md-12">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="dashboard.jsp">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="patients.jsp">Patients</a></li>
                        <li class="breadcrumb-item"><a href="patient-detail.jsp?id=<%= patient.getPatientId() %>">Patient Details</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Edit Patient</li>
                    </ol>
                </nav>
            </div>
        </div>
        
        <% if (message != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <%= message %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>
        
        <% if (error != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <%= error %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>
        
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Edit Patient Information</h5>
                    </div>
                    <div class="card-body">
                        <form action="../../updatePatientProfile" method="post" enctype="multipart/form-data">
                            <input type="hidden" name="patientId" value="<%= patient.getPatientId() %>">
                            
                            <div class="row mb-3">
                                <div class="col-md-6 mb-3 mb-md-0">
                                    <label for="firstName" class="form-label">First Name</label>
                                    <input type="text" class="form-control" id="firstName" name="firstName" value="<%= patient.getFirstName() %>" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="lastName" class="form-label">Last Name</label>
                                    <input type="text" class="form-control" id="lastName" name="lastName" value="<%= patient.getLastName() %>" required>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" class="form-control" id="email" name="email" value="<%= patient.getEmail() %>" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="telephone" class="form-label">Telephone</label>
                                <input type="tel" class="form-control" id="telephone" name="telephone" value="<%= patient.getTelephone() %>" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="address" class="form-label">Address</label>
                                <textarea class="form-control" id="address" name="address" rows="3" required><%= patient.getAddress() %></textarea>
                            </div>
                            
                            <div class="mb-4">
                                <label for="patientImage" class="form-label">Patient Image</label>
                                <input type="file" class="form-control" id="patientImage" name="patientImage" accept="image/*">
                                <% if (patient.getImageLink() != null && !patient.getImageLink().isEmpty()) { %>
                                    <div class="mt-2">
                                        <p>Current Image:</p>
                                        <img src="../../<%= patient.getImageLink() %>" alt="Current Patient Image" class="img-thumbnail" style="max-height: 150px;">
                                    </div>
                                <% } %>
                                <div class="form-text">Leave empty if you don't want to change the current image.</div>
                            </div>
                            
                            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                <a href="patient-detail.jsp?id=<%= patient.getPatientId() %>" class="btn btn-secondary me-md-2">Cancel</a>
                                <button type="submit" class="btn btn-primary">Save Changes</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>