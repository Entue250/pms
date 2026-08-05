<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pms.model.User, com.pms.dao.PatientDAO, com.pms.dao.DiagnosisDAO, com.pms.model.Patient, com.pms.model.Diagnosis, java.util.List" %>
<%
    // Check if user is logged in and is doctor
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getUserType().equals("Doctor")) {
        response.sendRedirect("../../index.jsp");
        return;
    }
    
    // Get patient ID from request
    String patientIdStr = request.getParameter("id");
    int patientId = 0;
    
    try {
        patientId = Integer.parseInt(patientIdStr);
    } catch (NumberFormatException e) {
        response.sendRedirect("all-patients.jsp");
        return;
    }
    
    // Get patient details
    PatientDAO patientDAO = new PatientDAO();
    Patient patient = null;
    try {
        patient = patientDAO.getPatientById(patientId);
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("all-patients.jsp");
        return;
    }
    
    if (patient == null) {
        response.sendRedirect("all-patients.jsp");
        return;
    }
    
    // Get diagnosis history for this patient
    DiagnosisDAO diagnosisDAO = new DiagnosisDAO();
    List<Diagnosis> diagnosisList = null;
    String latestStatus = "Unknown";
    
    try {
        diagnosisList = diagnosisDAO.getDiagnosesByPatientId(patientId);
        latestStatus = diagnosisDAO.getLatestStatusForPatient(patientId);
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Patient Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <link href="../../css/style.css" rel="stylesheet">
</head>
<body>
    <!-- Include navigation bar -->
    <jsp:include page="../common/doctorNav.jsp" />
    
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Patient Details</h2>
            <div>
                <a href="javascript:history.back()" class="btn btn-outline-secondary me-2">
                    <i class="bi bi-arrow-left"></i> Back
                </a>
                <a href="all-patients.jsp" class="btn btn-outline-primary">
                    All Patients <i class="bi bi-people"></i>
                </a>
            </div>
        </div>
        
        <div class="row">
            <div class="col-md-4">
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Patient Information</h5>
                    </div>
                    <div class="card-body">
                        <% if(patient.getImageLink() != null && !patient.getImageLink().isEmpty()) { %>
                            <div class="text-center mb-4">
                                <img src="../../<%= patient.getImageLink() %>" alt="Patient Photo" class="img-fluid rounded" style="max-height: 200px;">
                            </div>
                        <% } else { %>
                            <div class="text-center mb-4">
                                <i class="bi bi-person-circle" style="font-size: 5rem;"></i>
                            </div>
                        <% } %>
                        
                        <table class="table">
                            <tr>
                                <th width="40%">Name:</th>
                                <td><%= patient.getFirstName() + " " + patient.getLastName() %></td>
                            </tr>
                            <tr>
                                <th>Email:</th>
                                <td><%= patient.getEmail() %></td>
                            </tr>
                            <tr>
                                <th>Telephone:</th>
                                <td>
                                    <%= patient.getTelephone() != null && !patient.getTelephone().isEmpty() ? patient.getTelephone() : "Not available" %>
                                </td>
                            </tr>
                            <tr>
                                <th>Address:</th>
                                <td>
                                    <%= patient.getAddress() != null && !patient.getAddress().isEmpty() ? patient.getAddress() : "Not available" %>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
            
            <div class="col-md-8">
                <div class="card mb-4">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0">Diagnosis Status</h5>
                    </div>
                    <div class="card-body">
                        <div class="row text-center mb-4">
                            <div class="col">
                                <div class="p-3 border rounded">
                                    <h5>Current Status</h5>
                                    <% if(latestStatus.equals("Referrable-pending")) { %>
                                        <span class="badge bg-warning fs-5">Pending</span>
                                    <% } else if(latestStatus.equals("Referrable-confirmed")) { %>
                                        <span class="badge bg-success fs-5">Confirmed</span>
                                    <% } else if(latestStatus.equals("Not Referrable")) { %>
                                        <span class="badge bg-info fs-5">Not Referrable</span>
                                    <% } else { %>
                                        <span class="badge bg-secondary fs-5">Unknown</span>
                                    <% } %>
                                </div>
                            </div>
                            <div class="col">
                                <div class="p-3 border rounded">
                                    <h5>Total Diagnoses</h5>
                                    <h3><%= diagnosisList != null ? diagnosisList.size() : 0 %></h3>
                                </div>
                            </div>
                        </div>
                        
                        <% if(latestStatus.equals("Referrable-pending")) { %>
                            <div class="d-grid gap-2">
                                <a href="pending-cases.jsp" class="btn btn-warning">
                                    <i class="bi bi-clipboard-pulse me-2"></i> View Pending Diagnosis
                                </a>
                            </div>
                        <% } %>
                    </div>
                </div>
                
                <div class="card mb-4">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0">Diagnosis History</h5>
                    </div>
                    <div class="card-body">
                        <% if(diagnosisList == null || diagnosisList.isEmpty()) { %>
                            <p class="text-center">No diagnosis records found for this patient.</p>
                        <% } else { %>
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Date</th>
                                            <th>Status</th>
                                            <th>Nurse</th>
                                            <th>Doctor</th>
                                            <th>Result</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for(Diagnosis diagnosis : diagnosisList) { %>
                                            <tr>
                                                <td><%= diagnosis.getDiagnosisDate() %></td>
                                                <td>
                                                    <% if(diagnosis.getDiagnoStatus().equals("Referrable")) { %>
                                                        <% if(diagnosis.getResult() == null || diagnosis.getResult().equals("pending")) { %>
                                                            <span class="badge bg-warning">Pending</span>
                                                        <% } else { %>
                                                            <span class="badge bg-success">Confirmed</span>
                                                        <% } %>
                                                    <% } else { %>
                                                        <span class="badge bg-info">Not Referrable</span>
                                                    <% } %>
                                                </td>
                                                <td><%= diagnosis.getNurseName() %></td>
                                                <td><%= diagnosis.getDoctorName() != null ? diagnosis.getDoctorName() : "Not assigned" %></td>
                                                <td>
                                                    <% if(diagnosis.getResult() == null || diagnosis.getResult().equals("pending")) { %>
                                                        <span class="text-muted">Pending</span>
                                                    <% } else { %>
                                                        <%= diagnosis.getResult() %>
                                                    <% } %>
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
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="../../js/script.js"></script>
</body>
</html>