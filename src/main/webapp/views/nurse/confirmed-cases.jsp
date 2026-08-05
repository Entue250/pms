<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pms.model.User, com.pms.model.Nurse, com.pms.dao.NurseDAO, com.pms.dao.PatientDAO, com.pms.dao.DiagnosisDAO, com.pms.dao.DoctorDAO, com.pms.model.Patient, com.pms.model.Diagnosis, com.pms.model.Doctor, java.util.List" %>
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
    
    // Get confirmed cases by this nurse
    DiagnosisDAO diagnosisDAO = new DiagnosisDAO();
    // Modified to use existing method instead of getConfirmedDiagnosesByNurse
    List<Diagnosis> diagnosisList = diagnosisDAO.getDiagnosesByNurseId(nurse.getNurseId());
    // Filter for confirmed cases (with doctor assigned and result not null/pending)
    List<Diagnosis> confirmedCases = new java.util.ArrayList<>();
    for (Diagnosis d : diagnosisList) {
        if ("Referrable".equals(d.getDiagnoStatus()) && 
            d.getDoctorId() != null && 
            d.getResult() != null && 
            !d.getResult().equals("pending")) {
            confirmedCases.add(d);
        }
    }
    
    // Get DAOs for related data
    PatientDAO patientDAO = new PatientDAO();
    DoctorDAO doctorDAO = new DoctorDAO();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Confirmed Cases - Nurse Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
</head>
<body>
    <!-- Include navigation bar -->
    <jsp:include page="../common/nurseNav.jsp" />
    
    <div class="container-fluid mt-4">
        <h2 class="mb-4">Confirmed Cases</h2>
        
        <div class="card">
            <div class="card-header bg-success text-white d-flex justify-content-between align-items-center">
                <h5 class="mb-0">Cases Confirmed by Doctors</h5>
            </div>
            <div class="card-body">
                <% if (confirmedCases.isEmpty()) { %>
                    <p class="text-center">No confirmed cases available.</p>
                <% } else { %>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Patient</th>
                                    <th>Date</th>
                                    <th>Doctor</th>
                                    <th>Result</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for(Diagnosis diagnosis : confirmedCases) { 
                                    Patient patient = patientDAO.getPatientById(diagnosis.getPatientId());
                                    Doctor doctor = null;
                                    if (diagnosis.getDoctorId() != null && diagnosis.getDoctorId() > 0) {
                                        doctor = doctorDAO.getDoctorById(diagnosis.getDoctorId());
                                    }
                                %>
                                    <tr>
                                        <td><%= diagnosis.getDiagnosisId() %></td>
                                        <td><%= patient.getFirstName() + " " + patient.getLastName() %></td>
                                        <td><%= diagnosis.getDiagnosisDate() %></td>
                                        <td>
                                            <% if (doctor != null) { %>
                                                Dr. <%= doctor.getFirstName() + " " + doctor.getLastName() %>
                                            <% } else { %>
                                                <span class="text-muted">N/A</span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <% if (diagnosis.getResult() != null && !diagnosis.getResult().equals("pending")) { %>
                                                <%= diagnosis.getResult().length() > 50 ? diagnosis.getResult().substring(0, 50) + "..." : diagnosis.getResult() %>
                                            <% } else { %>
                                                <span class="text-muted">No result provided</span>
                                            <% } %>
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