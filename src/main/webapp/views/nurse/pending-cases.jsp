<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pms.model.User, com.pms.model.Nurse, com.pms.dao.NurseDAO, com.pms.dao.PatientDAO, com.pms.dao.DiagnosisDAO, com.pms.model.Patient, com.pms.model.Diagnosis, java.util.List" %>
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
    
    // Get pending cases for this nurse
    DiagnosisDAO diagnosisDAO = new DiagnosisDAO();
    // Modified to use existing method instead of getPendingDiagnosesByNurse
    List<Diagnosis> diagnosisList = diagnosisDAO.getDiagnosesByNurseId(nurse.getNurseId());
    // Filter for pending cases (Referrable but no doctor or pending result)
    List<Diagnosis> pendingCases = new java.util.ArrayList<>();
    for (Diagnosis d : diagnosisList) {
        if ("Referrable".equals(d.getDiagnoStatus()) && 
            (d.getDoctorId() == null || 
             d.getResult() == null || 
             d.getResult().equals("pending"))) {
            pendingCases.add(d);
        }
    }
    
    // Get patient DAO for patient details
    PatientDAO patientDAO = new PatientDAO();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Pending Cases - Nurse Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
</head>
<body>
    <!-- Include navigation bar -->
    <jsp:include page="../common/nurseNav.jsp" />
    
    <div class="container-fluid mt-4">
        <h2 class="mb-4">Pending Cases</h2>
        
        <div class="card">
            <div class="card-header bg-warning text-white d-flex justify-content-between align-items-center">
                <h5 class="mb-0">Cases Pending Doctor's Confirmation</h5>
            </div>
            <div class="card-body">
                <% if (pendingCases.isEmpty()) { %>
                    <p class="text-center">No pending cases available.</p>
                <% } else { %>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Patient</th>
                                    <th>Date</th>
                                    <th>Result</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for(Diagnosis diagnosis : pendingCases) { 
                                    Patient patient = patientDAO.getPatientById(diagnosis.getPatientId());
                                %>
                                    <tr>
                                        <td><%= diagnosis.getDiagnosisId() %></td>
                                        <td><%= patient.getFirstName() + " " + patient.getLastName() %></td>
                                        <td><%= diagnosis.getDiagnosisDate() %></td>
                                        <td><%= diagnosis.getResult() != null ? diagnosis.getResult() : "No result yet" %></td>
                                        <td>
                                            <span class="badge bg-warning">Pending</span>
                                        </td>
                                        <td>
                                            <a href="case-detail.jsp?id=<%= diagnosis.getDiagnosisId() %>" class="btn btn-sm btn-primary">
                                                <i class="bi bi-eye"></i> View
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
</body>
</html>