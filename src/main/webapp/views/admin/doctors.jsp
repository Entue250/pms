<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pms.model.User, com.pms.model.Doctor, com.pms.dao.DoctorDAO, com.pms.dao.DiagnosisDAO, java.util.List" %>
<%
    // Check if user is logged in and is admin
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getUserType().equals("Admin")) {
        response.sendRedirect("../../index.jsp");
        return;
    }
    
    // Get all doctors
    DoctorDAO doctorDAO = new DoctorDAO();
    DiagnosisDAO diagnosisDAO = new DiagnosisDAO();
    List<Doctor> doctors = doctorDAO.getAllDoctors();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Doctors</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <link href="../../css/style.css" rel="stylesheet">
</head>
<body>
    <!-- Include navigation bar -->
    <jsp:include page="../common/adminNav.jsp" />
    
    <div class="container-fluid mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Doctors Management</h2>
            <a href="addDoctor.jsp" class="btn btn-primary">
                <i class="bi bi-plus-circle"></i> Add New Doctor
            </a>
        </div>
        
        <% if(request.getParameter("success") != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                Doctor operation completed successfully!
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } else if(request.getParameter("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                Error processing doctor operation. Please try again.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>
        
        <div class="card">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0">All Doctors</h5>
            </div>
            <div class="card-body">
                <% if(doctors.isEmpty()) { %>
                    <p class="text-center">No doctors registered yet.</p>
                <% } else { %>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Hospital</th>
                                    <th>Email</th>
                                    <th>Telephone</th>
                                    <th>Registered Cases</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for(Doctor doctor : doctors) { 
                                    // Get count of cases assigned to this doctor
                                    int doctorCases = 0;
                                    try {
                                        doctorCases = diagnosisDAO.getCasesByHospital(doctor.getHospitalName());
                                    } catch (Exception e) {
                                        // Handle exception
                                    }
                                %>
                                    <tr>
                                        <td><%= doctor.getDoctorId() %></td>
                                        <td><%= doctor.getFirstName() + " " + doctor.getLastName() %></td>
                                        <td><%= doctor.getHospitalName() %></td>
                                        <td><%= doctor.getEmail() %></td>
                                        <td><%= doctor.getTelephone() %></td>
                                        <td><%= doctorCases %></td>
                                        <td>
                                            <a href="doctor-detail.jsp?id=<%= doctor.getDoctorId() %>" class="btn btn-sm btn-info" data-bs-toggle="tooltip" title="View Details">
                                                <i class="bi bi-eye"></i>
                                            </a>
                                            <!-- Changed from edit-doctor.jsp to doctor-detail.jsp with edit=true parameter -->
                                            <a href="doctor-detail.jsp?id=<%= doctor.getDoctorId() %>&edit=true" class="btn btn-sm btn-warning" data-bs-toggle="tooltip" title="Edit">
                                                <i class="bi bi-pencil"></i>
                                            </a>
                                            <a href="#" onclick="return confirmDelete('Are you sure you want to delete this doctor?', 'deleteForm<%= doctor.getDoctorId() %>')" class="btn btn-sm btn-danger" data-bs-toggle="tooltip" title="Delete">
                                                <i class="bi bi-trash"></i>
                                            </a>
                                            <form id="deleteForm<%= doctor.getDoctorId() %>" action="../../DeleteDoctorServlet" method="post" style="display:none;">
                                                <input type="hidden" name="doctorId" value="<%= doctor.getDoctorId() %>">
                                            </form>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } %>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="../../js/script.js"></script>
    <script>
        function confirmDelete(message, formId) {
            if (confirm(message)) {
                document.getElementById(formId).submit();
                return true;
            }
            return false;
        }
    </script>
</body>
</html>