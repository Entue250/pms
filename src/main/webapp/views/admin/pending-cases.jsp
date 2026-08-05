<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pms.model.User, com.pms.dao.DiagnosisDAO, com.pms.model.Diagnosis, java.util.List" %>
<%
    // Check if user is logged in and is admin
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getUserType().equals("Admin")) {
        response.sendRedirect("../../index.jsp");
        return;
    }
    
    // Get all pending cases (referrable cases with pending or null results)
    DiagnosisDAO diagnosisDAO = new DiagnosisDAO();
    
    // Using a new method to get all pending cases
    List<Diagnosis> pendingCases = diagnosisDAO.getAllPendingCases();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Pending Cases</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <link href="../../css/style.css" rel="stylesheet">
</head>
<body>
    <!-- Include navigation bar -->
    <jsp:include page="../common/adminNav.jsp" />
    
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Pending Cases</h2>
            <a href="dashboard.jsp" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left"></i> Back to Dashboard
            </a>
        </div>
        
        <div class="card dashboard-card">
            <div class="card-header bg-warning text-white">
                <h5 class="mb-0">Cases Waiting for Results</h5>
            </div>
            <div class="card-body">
                <% if(pendingCases.isEmpty()) { %>
                    <p class="text-center">No pending cases found.</p>
                <% } else { %>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Patient</th>
                                    <th>Nurse</th>
                                    <th>Health Center</th>
                                    <th>Date</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for(Diagnosis diagnosis : pendingCases) { %>
                                    <tr>
                                        <td><%= diagnosis.getPatientName() %></td>
                                        <td><%= diagnosis.getNurseName() %></td>
                                        <td>
                                            <% 
                                            // This would require additional data but we can add placeholder for now
                                            // In a real implementation, you'd want to fetch the nurse's health center
                                            %>
                                            <span class="badge bg-info">Health Center</span>
                                        </td>
                                        <td><%= diagnosis.getDiagnosisDate() %></td>
                                        <td>
                                            <span class="badge bg-warning">Pending</span>
                                        </td>
                                        <td>
                                            <a href="case-detail.jsp?id=<%= diagnosis.getDiagnosisId() %>" class="btn btn-sm btn-info" data-bs-toggle="tooltip" title="View Details">
                                                <i class="bi bi-eye"></i>
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