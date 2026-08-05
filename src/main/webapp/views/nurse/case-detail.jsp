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
    
    // Get diagnosis ID from request parameter
    int diagnosisId = 0;
    try {
        diagnosisId = Integer.parseInt(request.getParameter("id"));
    } catch (NumberFormatException e) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
    
    // Get diagnosis information
    DiagnosisDAO diagnosisDAO = new DiagnosisDAO();
    Diagnosis diagnosis = diagnosisDAO.getDiagnosisById(diagnosisId);
    
    if (diagnosis == null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
    
    // Get patient and doctor information
    PatientDAO patientDAO = new PatientDAO();
    DoctorDAO doctorDAO = new DoctorDAO();
    
    Patient patient = patientDAO.getPatientById(diagnosis.getPatientId());
    Doctor doctor = null;
    if (diagnosis.getDoctorId() != null && diagnosis.getDoctorId() > 0) {
        doctor = doctorDAO.getDoctorById(diagnosis.getDoctorId());
    }
    
    // Determine case status
    String status = "";
    String statusClass = "";
    
    if ("Referrable".equals(diagnosis.getDiagnoStatus())) {
        if (diagnosis.getDoctorId() != null && diagnosis.getDoctorId() > 0) {
            status = "Confirmed by Doctor";
            statusClass = "bg-success";
        } else {
            status = "Pending Doctor Confirmation";
            statusClass = "bg-warning";
        }
    } else {
        status = "Not Referrable - Direct";
        statusClass = "bg-info";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Case Details - Nurse Dashboard</title>
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
                        <% if ("Referrable".equals(diagnosis.getDiagnoStatus()) && diagnosis.getDoctorId() != null && diagnosis.getDoctorId() > 0) { %>
                            <li class="breadcrumb-item"><a href="referrable-cases.jsp">Confirmed Cases</a></li>
                        <% } else if ("Referrable".equals(diagnosis.getDiagnoStatus())) { %>
                            <li class="breadcrumb-item"><a href="referrable-cases.jsp">Pending Cases</a></li>
                        <% } else { %>
                            <li class="breadcrumb-item"><a href="nonreferrable-cases.jsp">Non-Referrable Cases</a></li>
                        <% } %>
                        <li class="breadcrumb-item active" aria-current="page">Case Details</li>
                    </ol>
                </nav>
            </div>
        </div>
        
        <div class="row">
            <div class="col-md-12 mb-4">
                <div class="card">
                    <div class="card-header <%= statusClass %> text-white">
                        <h5 class="mb-0">Case #<%= diagnosis.getDiagnosisId() %> - <%= status %></h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <h6 class="text-muted">Patient Information</h6>
                                    <div class="d-flex align-items-center mb-2">
                                        <% if (patient.getImageLink() != null && !patient.getImageLink().isEmpty()) { %>
                                            <img src="../../<%= patient.getImageLink() %>" class="rounded-circle me-2" style="width: 50px; height: 50px;" alt="Patient Image">
                                        <% } else { %>
                                            <div class="bg-light rounded-circle me-2 d-flex align-items-center justify-content-center" style="width: 50px; height: 50px;">
                                                <i class="bi bi-person"></i>
                                            </div>
                                        <% } %>
                                        <div>
                                            <h5 class="mb-0"><%= patient.getFirstName() + " " + patient.getLastName() %></h5>
                                            <small><a href="patient-detail.jsp?id=<%= patient.getPatientId() %>">View Patient Profile</a></small>
                                        </div>
                                    </div>
                                    <p><strong>Contact:</strong> <%= patient.getTelephone() %></p>
                                    <p><strong>Email:</strong> <%= patient.getEmail() %></p>
                                    <p><strong>Address:</strong> <%= patient.getAddress() %></p>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <h6 class="text-muted">Diagnosis Information</h6>
                                    <p><strong>Date:</strong> <%= diagnosis.getDiagnosisDate() %></p>
                                    <p>
                                        <strong>Referral Status:</strong>
                                        <% if ("Referrable".equals(diagnosis.getDiagnoStatus())) { %>
                                            <span class="badge bg-warning">Referred to Doctor</span>
                                        <% } else { %>
                                            <span class="badge bg-info">Not Referred</span>
                                        <% } %>
                                    </p>
                                    <% if (doctor != null) { %>
                                        <h6 class="text-muted mt-4">Assigned Doctor</h6>
                                        <p><strong>Name:</strong> Dr. <%= doctor.getFirstName() + " " + doctor.getLastName() %></p>
                                        <p><strong>Hospital:</strong> <%= doctor.getHospitalName() %></p>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                        
                        <hr>
                        
                        <div class="row">
                            <div class="col-md-12">
                                <div class="mb-3">
                                    <h6 class="text-muted">Diagnosis Result</h6>
                                    <div class="card bg-light">
                                        <div class="card-body">
                                            <p><%= diagnosis.getResult() != null ? diagnosis.getResult() : "No result provided yet" %></p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="card-footer">
                        <div class="d-flex justify-content-between">
                            <a href="patient-detail.jsp?id=<%= patient.getPatientId() %>" class="btn btn-outline-primary">
                                <i class="bi bi-person"></i> Patient Profile
                            </a>
                            <a href="javascript:history.back()" class="btn btn-secondary">
                                <i class="bi bi-arrow-left"></i> Back
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>