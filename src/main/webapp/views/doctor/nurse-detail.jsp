<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pms.model.User, com.pms.dao.NurseDAO, com.pms.dao.DiagnosisDAO, com.pms.model.Nurse, java.util.List" %>
<%
    // Check if user is logged in and is doctor
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getUserType().equals("Doctor")) {
        response.sendRedirect("../../index.jsp");
        return;
    }
    
    // Get nurse ID from request
    String nurseIdStr = request.getParameter("id");
    int nurseId = 0;
    
    try {
        nurseId = Integer.parseInt(nurseIdStr);
    } catch (NumberFormatException e) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
    
    // Get nurse details
    NurseDAO nurseDAO = new NurseDAO();
    Nurse nurse = null;
    try {
        nurse = nurseDAO.getNurseById(nurseId);
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("dashboard.jsp");
        return;
    }
    
    if (nurse == null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
    
    // Get diagnosis statistics
    DiagnosisDAO diagnosisDAO = new DiagnosisDAO();
    int totalCases = 0;
    try {
        totalCases = diagnosisDAO.getDiagnosesByNurseId(nurseId).size();
    } catch (Exception e) {
        e.printStackTrace();
    }
    
    // Check for status messages
    String updated = request.getParameter("updated");
    String error = request.getParameter("error");
    
    // Check if edit modal should be shown
    boolean showEditModal = "true".equals(request.getParameter("edit"));
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Nurse Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <link href="../../css/style.css" rel="stylesheet">
</head>
<body>
    <!-- Include navigation bar -->
    <jsp:include page="../common/doctorNav.jsp" />
    
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Nurse Details</h2>
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
                Nurse information has been updated successfully.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } else if ("true".equals(error)) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                Failed to update nurse information. Please try again.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>
        
        <div class="row">
            <div class="col-md-4">
                <div class="card mb-4">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0">Nurse Information</h5>
                    </div>
                    <div class="card-body">
                        <div class="text-center mb-4">
                            <i class="bi bi-person-badge" style="font-size: 5rem;"></i>
                        </div>
                        <table class="table">
                            <tr>
                                <th width="40%">Name:</th>
                                <td><%= nurse.getFirstName() + " " + nurse.getLastName() %></td>
                            </tr>
                            <tr>
                                <th>Email:</th>
                                <td><%= nurse.getEmail() %></td>
                            </tr>
                            <tr>
                                <th>Telephone:</th>
                                <td>
                                    <%= nurse.getTelephone() != null && !nurse.getTelephone().isEmpty() ? nurse.getTelephone() : "Not available" %>
                                </td>
                            </tr>
                            <tr>
                                <th>Address:</th>
                                <td>
                                    <%= nurse.getAddress() != null && !nurse.getAddress().isEmpty() ? nurse.getAddress() : "Not available" %>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
            
            <div class="col-md-8">
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Health Center Information</h5>
                    </div>
                    <div class="card-body">
                        <table class="table">
                            <tr>
                                <th width="40%">Health Center:</th>
                                <td><%= nurse.getHealthCenter() != null && !nurse.getHealthCenter().isEmpty() ? nurse.getHealthCenter() : "Not specified" %></td>
                            </tr>
                            <tr>
                                <th>Total Cases Handled:</th>
                                <td><%= totalCases %></td>
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
                                <th>Nurse ID:</th>
                                <td><%= nurse.getNurseId() %></td>
                            </tr>
                        </table>
                    </div>
                </div>
                
                <div class="d-flex justify-content-end">
                    <a href="nurses.jsp" class="btn btn-primary me-2">
                        All Nurses <i class="bi bi-people"></i>
                    </a>
                    <a href="#" class="btn btn-warning me-2" data-bs-toggle="modal" data-bs-target="#editNurseModal">
                        Edit <i class="bi bi-pencil"></i>
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Edit Nurse Modal -->
    <div class="modal fade" id="editNurseModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Edit Nurse Information</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="../../UpdateNurseServlet" method="post">
                        <input type="hidden" name="nurseId" value="<%= nurse.getNurseId() %>">
                        <input type="hidden" name="redirectTo" value="doctor"> <!-- This helps the servlet redirect back to doctor views -->
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="firstName" class="form-label">First Name</label>
                                <input type="text" class="form-control" id="firstName" name="firstName" value="<%= nurse.getFirstName() %>" required>
                            </div>
                            <div class="col-md-6">
                                <label for="lastName" class="form-label">Last Name</label>
                                <input type="text" class="form-control" id="lastName" name="lastName" value="<%= nurse.getLastName() %>" required>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" class="form-control" id="email" name="email" value="<%= nurse.getEmail() %>" required>
                            </div>
                            <div class="col-md-6">
                                <label for="telephone" class="form-label">Telephone</label>
                                <input type="text" class="form-control" id="telephone" name="telephone" 
                                    value="<%= nurse.getTelephone() != null ? nurse.getTelephone() : "" %>">
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="address" class="form-label">Address</label>
                                <textarea class="form-control" id="address" name="address" rows="3"><%= nurse.getAddress() != null ? nurse.getAddress() : "" %></textarea>
                            </div>
                            <div class="col-md-6">
                                <label for="healthCenter" class="form-label">Health Center</label>
                                <input type="text" class="form-control" id="healthCenter" name="healthCenter" 
                                    value="<%= nurse.getHealthCenter() != null ? nurse.getHealthCenter() : "" %>" required>
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
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="../../js/script.js"></script>
    <script>
        // Auto-open the edit modal if the edit parameter is set to true
        document.addEventListener('DOMContentLoaded', function() {
            <% if (showEditModal) { %>
                var editModal = new bootstrap.Modal(document.getElementById('editNurseModal'));
                editModal.show();
            <% } %>
        });
    </script>
</body>
</html>