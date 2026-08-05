<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pms.model.User, com.pms.model.Doctor, com.pms.model.Nurse, com.pms.dao.DoctorDAO, com.pms.dao.NurseDAO, com.pms.dao.DiagnosisDAO, java.util.List" %>
<%
    // Check if user is logged in and is doctor
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getUserType().equals("Doctor")) {
        response.sendRedirect("../../index.jsp");
        return;
    }
    
    // Get doctor information
    DoctorDAO doctorDAO = new DoctorDAO();
    Doctor doctor = doctorDAO.getDoctorByUserId(user.getUserID());
    
    // Get nurses for this doctor's hospital
    NurseDAO nurseDAO = new NurseDAO();
    DiagnosisDAO diagnosisDAO = new DiagnosisDAO();
    List<Nurse> nurses = nurseDAO.getNursesByHealthCenter(doctor.getHospitalName());
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Nurses</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <link href="../../css/style.css" rel="stylesheet">
</head>
<body>
    <!-- Include navigation bar -->
    <jsp:include page="../common/doctorNav.jsp" />
    
    <div class="container-fluid mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Nurses Management</h2>
            <a href="addNurse.jsp" class="btn btn-primary">
                <i class="bi bi-plus-circle"></i> Add New Nurse
            </a>
        </div>
        
        <% if(request.getParameter("success") != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                Nurse operation completed successfully!
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } else if(request.getParameter("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                Error processing nurse operation. Please try again.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>
        
        <div class="card">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0">Hospital Nurses</h5>
            </div>
            <div class="card-body">
                <% if(nurses.isEmpty()) { %>
                    <p class="text-center">No nurses registered for your hospital yet.</p>
                <% } else { %>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Health Center</th>
                                    <th>Email</th>
                                    <th>Telephone</th>
                                    <th>Registered Cases</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for(Nurse nurse : nurses) {
                                    // Get count of cases registered by this nurse
                                    int nurseCases = diagnosisDAO.getCasesByNurse(nurse.getNurseId());
                                %>
                                    <tr>
                                        <td><%= nurse.getNurseId() %></td>
                                        <td><%= nurse.getFirstName() + " " + nurse.getLastName() %></td>
                                        <td><%= nurse.getHealthCenter() %></td>
                                        <td><%= nurse.getEmail() %></td>
                                        <td><%= nurse.getTelephone() %></td>
                                        <td><%= nurseCases %></td>
                                        <td>
                                            <a href="nurse-detail.jsp?id=<%= nurse.getNurseId() %>" class="btn btn-sm btn-info" data-bs-toggle="tooltip" title="View Details">
                                                <i class="bi bi-eye"></i>
                                            </a>
                                            <!-- Changed from edit-nurse.jsp to nurse-detail.jsp with edit=true parameter -->
                                            <a href="nurse-detail.jsp?id=<%= nurse.getNurseId() %>&edit=true" class="btn btn-sm btn-warning" data-bs-toggle="tooltip" title="Edit">
                                                <i class="bi bi-pencil"></i>
                                            </a>
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
</body>
</html>