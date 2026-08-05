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
    
    // Get patient ID from request parameter
    int patientId = 0;
    try {
        patientId = Integer.parseInt(request.getParameter("id"));
    } catch (NumberFormatException e) {
        response.sendRedirect("patients.jsp");
        return;
    }
    
    // Get patient information
    PatientDAO patientDAO = new PatientDAO();
    Patient patient = patientDAO.getPatientById(patientId);
    
    if (patient == null) {
        response.sendRedirect("patients.jsp");
        return;
    }
    
    // Get diagnosis information for this patient
    DiagnosisDAO diagnosisDAO = new DiagnosisDAO();
    // Changed to use getDiagnosesByPatientId instead of getDiagnosesByPatient
    List<Diagnosis> diagnoses = diagnosisDAO.getDiagnosesByPatientId(patientId);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Patient Details - Nurse Dashboard</title>
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
                        <li class="breadcrumb-item"><a href="patients.jsp">Patients</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Patient Details</li>
                    </ol>
                </nav>
            </div>
        </div>
        
        <div class="row">
            <div class="col-md-4">
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Patient Information</h5>
                    </div>
                    <div class="card-body">
                        <div class="text-center mb-3">
                            <% if (patient.getImageLink() != null && !patient.getImageLink().isEmpty()) { %>
                                <img src="../../<%= patient.getImageLink() %>" class="img-fluid rounded" alt="Patient Image" style="max-height: 200px;">
                            <% } else { %>
                                <div class="bg-light rounded p-5 text-center">
                                    <i class="bi bi-person-circle" style="font-size: 5rem;"></i>
                                    <p class="mt-2 text-muted">No image available</p>
                                </div>
                            <% } %>
                        </div>
                        
                        <div class="mb-3">
                            <h5><%= patient.getFirstName() + " " + patient.getLastName() %></h5>
                        </div>
                        
                        <div class="mb-2">
                            <strong><i class="bi bi-envelope"></i> Email:</strong>
                            <p><%= patient.getEmail() %></p>
                        </div>
                        
                        <div class="mb-2">
                            <strong><i class="bi bi-telephone"></i> Phone:</strong>
                            <p><%= patient.getTelephone() %></p>
                        </div>
                        
                        <div class="mb-2">
                            <strong><i class="bi bi-geo-alt"></i> Address:</strong>
                            <p><%= patient.getAddress() %></p>
                        </div>
                        
                        <div class="d-grid gap-2 mt-3">
                            <a href="edit-patient.jsp?id=<%= patient.getPatientId() %>" class="btn btn-outline-primary">
                                <i class="bi bi-pencil"></i> Edit Information
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-8">
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Diagnosis History</h5>
                        <a href="../nurse/addDiagnosis.jsp?patientId=<%= patient.getPatientId() %>" class="btn btn-sm btn-light">
                            <i class="bi bi-plus-circle"></i> New Diagnosis
                        </a>
                    </div>
                    <div class="card-body">
                        <% if (diagnoses.isEmpty()) { %>
                            <p class="text-center">No diagnosis records found for this patient.</p>
                        <% } else { %>
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Date</th>
                                            <th>Result</th>
                                            <th>Referral</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for(Diagnosis diagnosis : diagnoses) { %>
                                            <tr>
                                                <td><%= diagnosis.getDiagnosisDate() %></td>
                                                <td><%= diagnosis.getResult() != null ? diagnosis.getResult() : "No result yet" %></td>
                                                <td>
                                                    <% if ("Referrable".equals(diagnosis.getDiagnoStatus())) { %>
                                                        <span class="badge bg-warning">Referrable</span>
                                                    <% } else { %>
                                                        <span class="badge bg-info">Not Referrable</span>
                                                    <% } %>
                                                </td>
                                                <td>
                                                    <% if ("Referrable".equals(diagnosis.getDiagnoStatus()) && diagnosis.getDoctorId() != null && diagnosis.getDoctorId() > 0) { %>
                                                        <span class="badge bg-success">Confirmed</span>
                                                    <% } else if ("Referrable".equals(diagnosis.getDiagnoStatus())) { %>
                                                        <span class="badge bg-warning">Pending</span>
                                                    <% } else { %>
                                                        <span class="badge bg-info">Direct</span>
                                                    <% } %>
                                                </td>
                                                <td>
                                                    <a href="case-detail.jsp?id=<%= diagnosis.getDiagnosisId() %>" class="btn btn-sm btn-primary">
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
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>