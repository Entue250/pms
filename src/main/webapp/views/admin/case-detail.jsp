<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pms.model.User, com.pms.dao.DiagnosisDAO, com.pms.model.Diagnosis" %>
<%
    // Check if user is logged in and is admin
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getUserType().equals("Admin")) {
        response.sendRedirect("../../index.jsp");
        return;
    }
    
    // Get diagnosis ID from request
    String diagnosisIdStr = request.getParameter("id");
    int diagnosisId = 0;
    
    try {
        diagnosisId = Integer.parseInt(diagnosisIdStr);
    } catch (NumberFormatException e) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
    
    // Get diagnosis details
    DiagnosisDAO diagnosisDAO = new DiagnosisDAO();
    Diagnosis diagnosis = diagnosisDAO.getDiagnosisById(diagnosisId);
    
    if (diagnosis == null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Case Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <link href="../../css/style.css" rel="stylesheet">
</head>
<body>
    <!-- Include navigation bar -->
    <jsp:include page="../common/adminNav.jsp" />
    
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Case Details</h2>
            <div>
                <a href="javascript:history.back()" class="btn btn-outline-secondary me-2">
                    <i class="bi bi-arrow-left"></i> Back
                </a>
                <a href="dashboard.jsp" class="btn btn-outline-primary">
                    Dashboard <i class="bi bi-house"></i>
                </a>
            </div>
        </div>
        
        <div class="row">
            <div class="col-md-6">
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Patient Information</h5>
                    </div>
                    <div class="card-body">
                        <table class="table">
                            <tr>
                                <th style="width: 40%">Name:</th>
                                <td><%= diagnosis.getPatientName() %></td>
                            </tr>
                            <tr>
                                <th>Patient ID:</th>
                                <td><%= diagnosis.getPatientId() %></td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
            
            <div class="col-md-6">
                <div class="card mb-4">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0">Healthcare Provider</h5>
                    </div>
                    <div class="card-body">
                        <table class="table">
                            <tr>
                                <th style="width: 40%">Nurse:</th>
                                <td><%= diagnosis.getNurseName() %></td>
                            </tr>
                            <tr>
                                <th>Doctor:</th>
                                <td><%= diagnosis.getDoctorName() != null ? diagnosis.getDoctorName() : "Not assigned" %></td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0">Diagnosis Details</h5>
                    </div>
                    <div class="card-body">
                        <table class="table">
                            <tr>
                                <th style="width: 20%">Date:</th>
                                <td><%= diagnosis.getDiagnosisDate() %></td>
                            </tr>
                            <tr>
                                <th>Status:</th>
                                <td>
                                    <% if (diagnosis.getDiagnoStatus().equals("Referrable")) { %>
                                        <span class="badge bg-warning">Referrable</span>
                                    <% } else { %>
                                        <span class="badge bg-info">Not Referrable</span>
                                    <% } %>
                                </td>
                            </tr>
                            <tr>
                                <th>Result:</th>
                                <td>
                                    <% 
                                    String result = diagnosis.getResult();
                                    if (result != null && !result.isEmpty() && !result.equals("pending")) {
                                        out.print(result);
                                    } else {
                                        %>
                                        <span class="badge bg-secondary">Pending</span>
                                        <%
                                    }
                                    %>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="../../js/script.js"></script>
</body>
</html>