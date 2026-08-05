<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pms.model.User, com.pms.dao.DoctorDAO, com.pms.dao.DiagnosisDAO, com.pms.model.Doctor, java.util.List" %>
<%
    // Check if user is logged in and is admin
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getUserType().equals("Admin")) {
        response.sendRedirect("../../index.jsp");
        return;
    }
    
    // Get doctor ID from request
    String doctorIdStr = request.getParameter("id");
    int doctorId = 0;
    
    try {
        doctorId = Integer.parseInt(doctorIdStr);
    } catch (NumberFormatException e) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
    
    // Get doctor details
    DoctorDAO doctorDAO = new DoctorDAO();
    Doctor doctor = null;
    try {
        doctor = doctorDAO.getDoctorById(doctorId);
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("dashboard.jsp");
        return;
    }
    
    if (doctor == null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
    
    // Get diagnosis statistics
    DiagnosisDAO diagnosisDAO = new DiagnosisDAO();
    int confirmedCases = 0;
    try {
        // Make sure we're using a method that returns int, not List<Diagnosis>
        confirmedCases = diagnosisDAO.getConfirmedCasesByDoctor(doctorId).size();
    } catch (Exception e) {
        // Handle exception if needed
        e.printStackTrace();
    }
    
    // Check for status messages
    String updated = request.getParameter("updated");
    String error = request.getParameter("error");
    
    // Check if edit modal should be shown (when edit=true parameter is present)
    boolean showEditModal = "true".equals(request.getParameter("edit"));
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Doctor Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <link href="../../css/style.css" rel="stylesheet">
</head>
<body>
    <!-- Include navigation bar -->
    <jsp:include page="../common/adminNav.jsp" />
    
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Doctor Details</h2>
            <div>
                <a href="javascript:history.back()" class="btn btn-outline-secondary me-2">
                    <i class="bi bi-arrow-left"></i> Back
                </a>
                <a href="dashboard.jsp" class="btn btn-outline-primary">
                    Dashboard <i class="bi bi-house"></i>
                </a>
            </div>
        </div>
        
        <!-- Display status messages -->
        <% if ("true".equals(updated)) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                Doctor information has been updated successfully.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } else if ("true".equals(error)) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                Failed to update doctor information. Please try again.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>
        
        <div class="row">
            <div class="col-md-4">
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Doctor Information</h5>
                    </div>
                    <div class="card-body">
                        <div class="text-center mb-4">
                            <i class="bi bi-person-circle" style="font-size: 5rem;"></i>
                        </div>
                        <table class="table">
                            <tr>
                                <th width="40%">Name:</th>
                                <td><%= doctor.getFirstName() + " " + doctor.getLastName() %></td>
                            </tr>
                            <tr>
                                <th>Email:</th>
                                <td><%= doctor.getEmail() %></td>
                            </tr>
                            <tr>
                                <th>Telephone:</th>
                                <td>
                                    <%= doctor.getTelephone() != null && !doctor.getTelephone().isEmpty() ? doctor.getTelephone() : "Not available" %>
                                </td>
                            </tr>
                            <tr>
                                <th>Address:</th>
                                <td>
                                    <%= doctor.getAddress() != null && !doctor.getAddress().isEmpty() ? doctor.getAddress() : "Not available" %>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
            
            <div class="col-md-8">
                <div class="card mb-4">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0">Hospital Information</h5>
                    </div>
                    <div class="card-body">
                        <table class="table">
                            <tr>
                                <th width="40%">Hospital:</th>
                                <td><%= doctor.getHospitalName() != null && !doctor.getHospitalName().isEmpty() ? doctor.getHospitalName() : "Not specified" %></td>
                            </tr>
                            <tr>
                                <th>Confirmed Cases:</th>
                                <td><%= confirmedCases %></td>
                            </tr>
                        </table>
                    </div>
                </div>
                
                <div class="card mb-4">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0">Account Information</h5>
                    </div>
                    <div class="card-body">
                        <table class="table">
                            <tr>
                                <th width="40%">Account Status:</th>
                                <td>
                                    <span class="badge bg-success">Active</span>
                                </td>
                            </tr>
                            <tr>
                                <th>Doctor ID:</th>
                                <td><%= doctor.getDoctorId() %></td>
                            </tr>
                            <tr>
                                <th>User ID:</th>
                                <td><%= doctor.getUserID() %></td>
                            </tr>
                        </table>
                    </div>
                </div>
                
                <div class="d-flex justify-content-end">
                    <a href="doctors.jsp" class="btn btn-primary me-2">
                        All Doctors <i class="bi bi-people"></i>
                    </a>
                    <a href="#" class="btn btn-warning me-2" data-bs-toggle="modal" data-bs-target="#editDoctorModal">
                        Edit <i class="bi bi-pencil"></i>
                    </a>
                    <button class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#deleteDoctorModal">
                        Delete <i class="bi bi-trash"></i>
                    </button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Edit Doctor Modal -->
    <div class="modal fade" id="editDoctorModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Edit Doctor Information</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="../../UpdateDoctorServlet" method="post">
                        <input type="hidden" name="doctorId" value="<%= doctor.getDoctorId() %>">
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="firstName" class="form-label">First Name</label>
                                <input type="text" class="form-control" id="firstName" name="firstName" value="<%= doctor.getFirstName() %>" required>
                            </div>
                            <div class="col-md-6">
                                <label for="lastName" class="form-label">Last Name</label>
                                <input type="text" class="form-control" id="lastName" name="lastName" value="<%= doctor.getLastName() %>" required>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" class="form-control" id="email" name="email" value="<%= doctor.getEmail() %>" required>
                            </div>
                            <div class="col-md-6">
                                <label for="telephone" class="form-label">Telephone</label>
                                <input type="text" class="form-control" id="telephone" name="telephone" 
                                    value="<%= doctor.getTelephone() != null ? doctor.getTelephone() : "" %>">
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="address" class="form-label">Address</label>
                                <textarea class="form-control" id="address" name="address" rows="3"><%= doctor.getAddress() != null ? doctor.getAddress() : "" %></textarea>
                            </div>
                            <div class="col-md-6">
                                <label for="hospitalName" class="form-label">Hospital Name</label>
                                <input type="text" class="form-control" id="hospitalName" name="hospitalName" 
                                    value="<%= doctor.getHospitalName() != null ? doctor.getHospitalName() : "" %>" required>
                            </div>
                        </div>
                        
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-primary">Save Changes</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Delete Doctor Modal -->
    <div class="modal fade" id="deleteDoctorModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Confirm Deletion</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete doctor <strong><%= doctor.getFirstName() + " " + doctor.getLastName() %></strong>?</p>
                    <p class="text-danger">This action cannot be undone. All associated diagnoses and records will be affected.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <form action="../../DeleteDoctorServlet" method="post">
                        <input type="hidden" name="doctorId" value="<%= doctor.getDoctorId() %>">
                        <button type="submit" class="btn btn-danger">Delete Doctor</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="../../js/script.js"></script>
    <script>
        // Auto-open the edit modal if the edit parameter is set to true
        document.addEventListener('DOMContentLoaded', function() {
            <% if (showEditModal) { %>
                var editModal = new bootstrap.Modal(document.getElementById('editDoctorModal'));
                editModal.show();
            <% } %>
        });
    </script>
</body>
</html>