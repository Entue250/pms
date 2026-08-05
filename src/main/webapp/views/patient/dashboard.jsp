<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pms.model.User, com.pms.model.Patient, com.pms.dao.PatientDAO, com.pms.dao.DiagnosisDAO, com.pms.model.Diagnosis, java.util.List" %>
<%
    // Check if user is logged in and is patient
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getUserType().equals("Patient")) {
        response.sendRedirect("../../index.jsp");
        return;
    }
    
    // Get patient information
    PatientDAO patientDAO = new PatientDAO();
    Patient patient = patientDAO.getPatientByUserId(user.getUserID());
    
    // Get diagnoses for this patient
    DiagnosisDAO diagnosisDAO = new DiagnosisDAO();
    List<Diagnosis> diagnoses = diagnosisDAO.getDiagnosesByPatientId(patient.getPatientId());
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Patient Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
</head>
<body>
    <!-- Include navigation bar -->
    <jsp:include page="../common/patientNav.jsp" />
    
    <div class="container mt-4">
        <h2 class="mb-4">My Health Records</h2>
        
        <div class="row mb-4">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Personal Information</h5>
                    </div>
                    <div class="card-body">
                        <p><strong>Name:</strong> <%= patient.getFirstName() + " " + patient.getLastName() %></p>
                        <p><strong>Email:</strong> <%= patient.getEmail() %></p>
                        <p><strong>Telephone:</strong> <%= patient.getTelephone() %></p>
                        <p><strong>Address:</strong> <%= patient.getAddress() %></p>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0">My Photo</h5>
                    </div>
                    <div class="card-body text-center">
                        <% if(patient.getImageLink() != null && !patient.getImageLink().isEmpty()) { %>
                            <img src="../../<%= patient.getImageLink() %>" class="img-fluid" alt="Patient Image" style="max-height: 200px;">
                        <% } else { %>
                            <p>No image available</p>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="card">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0">My Diagnoses</h5>
            </div>
            <div class="card-body">
                <% if(diagnoses.isEmpty()) { %>
                    <p class="text-center">No diagnosis records found.</p>
                <% } else { %>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Nurse</th>
                                    <th>Doctor</th>
                                    <th>Status</th>
                                    <th>Result</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for(Diagnosis diagnosis : diagnoses) { %>
                                    <tr>
                                        <td><%= diagnosis.getDiagnosisDate() %></td>
                                        <td><%= diagnosis.getNurseName() %></td>
                                        <td>
                                            <% if(diagnosis.getDoctorName() != null && !diagnosis.getDoctorName().isEmpty()) { %>
                                                <%= diagnosis.getDoctorName() %>
                                            <% } else { %>
                                                <span class="text-muted">N/A</span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <% if(diagnosis.getDiagnoStatus().equals("Referrable") && 
                                                  (diagnosis.getResult() == null || diagnosis.getResult().equals("pending"))) { %>
                                                <span class="badge bg-warning">Pending</span>
                                            <% } else if(diagnosis.getDiagnoStatus().equals("Referrable") && 
                                                        diagnosis.getResult() != null && !diagnosis.getResult().equals("pending")) { %>
                                                <span class="badge bg-success">Confirmed</span>
                                            <% } else { %>
                                                <span class="badge bg-info">Not Referrable</span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <% if(diagnosis.getDiagnoStatus().equals("Referrable") && 
                                                  (diagnosis.getResult() == null || diagnosis.getResult().equals("pending"))) { %>
                                                <span class="text-muted">Pending</span>
                                            <% } else if(diagnosis.getDiagnoStatus().equals("Not Referrable")) { %>
                                                <span class="text-danger">Negative</span>
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
        
        <% 
        // Check for latest diagnosis
        Diagnosis latestDiagnosis = null;
        if (!diagnoses.isEmpty()) {
            latestDiagnosis = diagnoses.get(0); // Assuming list is sorted by date descending
        }
        
        if (latestDiagnosis != null && 
            latestDiagnosis.getDiagnoStatus().equals("Referrable") && 
            (latestDiagnosis.getResult() == null || latestDiagnosis.getResult().equals("pending"))) {
        %>
        <div class="row mt-4">
            <div class="col-md-12">
                <div class="alert alert-warning">
                    <h4 class="alert-heading">Pending Diagnosis</h4>
                    <p>Your latest diagnosis has been referred to a doctor and is currently pending. You will be notified when results are available.</p>
                    <hr>
                    <p class="mb-0">Date of referral: <%= latestDiagnosis.getDiagnosisDate() %></p>
                </div>
            </div>
        </div>
        <% } else if (latestDiagnosis != null && 
                     latestDiagnosis.getDiagnoStatus().equals("Referrable") && 
                     latestDiagnosis.getResult() != null && !latestDiagnosis.getResult().equals("pending")) { %>
        <div class="row mt-4">
            <div class="col-md-12">
                <div class="alert alert-success">
                    <h4 class="alert-heading">Diagnosis Results Available</h4>
                    <p>Your latest diagnosis results are available. Please review the details above.</p>
                    <hr>
                    <p class="mb-0">Date of results: <%= latestDiagnosis.getDiagnosisDate() %></p>
                </div>
            </div>
        </div>
        <% } %>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>