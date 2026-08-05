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
    
    // Get diagnoses with results for this patient
    DiagnosisDAO diagnosisDAO = new DiagnosisDAO();
    List<Diagnosis> diagnoses = diagnosisDAO.getDiagnosesByPatientId(patient.getPatientId());
    
    // Filter for diagnoses with results
    List<Diagnosis> diagnosesWithResults = new java.util.ArrayList<>();
    for (Diagnosis diagnosis : diagnoses) {
        if ((diagnosis.getDiagnoStatus().equals("Referrable") && 
             diagnosis.getResult() != null && !diagnosis.getResult().equals("pending")) ||
            diagnosis.getDiagnoStatus().equals("Not Referrable")) {
            diagnosesWithResults.add(diagnosis);
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Test Results</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <link href="../../css/style.css" rel="stylesheet">
</head>
<body>
    <!-- Include navigation bar -->
    <jsp:include page="../common/patientNav.jsp" />
    
    <div class="container mt-4">
        <h2 class="mb-4">My Test Results</h2>
        
        <div class="card">
            <div class="card-header bg-info text-white">
                <h5 class="mb-0">Available Results</h5>
            </div>
            <div class="card-body">
                <% if(diagnosesWithResults.isEmpty()) { %>
                    <div class="alert alert-info">
                        <h4 class="alert-heading">No Results Available</h4>
                        <p>You don't have any test results yet. Results will appear here once your diagnoses are processed.</p>
                    </div>
                <% } else { %>
                    <div class="accordion" id="resultsAccordion">
                        <% 
                        int index = 0;
                        for(Diagnosis diagnosis : diagnosesWithResults) {
                            index++;
                            String statusClass = diagnosis.getDiagnoStatus().equals("Referrable") ? "bg-success" : "bg-info";
                            String statusText = diagnosis.getDiagnoStatus().equals("Referrable") ? "Confirmed by Doctor" : "Direct Result";
                        %>
                            <div class="accordion-item">
                                <h2 class="accordion-header" id="heading<%= index %>">
                                    <button class="accordion-button <%= index > 1 ? "collapsed" : "" %>" type="button" data-bs-toggle="collapse" data-bs-target="#collapse<%= index %>" aria-expanded="<%= index == 1 ? "true" : "false" %>" aria-controls="collapse<%= index %>">
                                        <div class="d-flex align-items-center w-100">
                                            <div class="me-auto">
                                                <strong>Result from <%= diagnosis.getDiagnosisDate() %></strong>
                                            </div>
                                            <span class="badge <%= statusClass %> ms-2"><%= statusText %></span>
                                        </div>
                                    </button>
                                </h2>
                                <div id="collapse<%= index %>" class="accordion-collapse collapse <%= index == 1 ? "show" : "" %>" aria-labelledby="heading<%= index %>" data-bs-parent="#resultsAccordion">
                                    <div class="accordion-body">
                                        <div class="row">
                                            <div class="col-md-4">
                                                <div class="mb-3">
                                                    <h6>Details</h6>
                                                    <p><strong>Date:</strong> <%= diagnosis.getDiagnosisDate() %></p>
                                                    <p><strong>Nurse:</strong> <%= diagnosis.getNurseName() %></p>
                                                    <% if(diagnosis.getDiagnoStatus().equals("Referrable") && diagnosis.getDoctorName() != null) { %>
                                                        <p><strong>Doctor:</strong> <%= diagnosis.getDoctorName() %></p>
                                                    <% } %>
                                                    <p><strong>Status:</strong> <span class="badge <%= statusClass %>"><%= statusText %></span></p>
                                                </div>
                                            </div>
                                            <div class="col-md-8">
                                                <div class="card">
                                                    <div class="card-header">
                                                        <h6 class="mb-0">Result</h6>
                                                    </div>
                                                    <div class="card-body">
                                                        <% if(diagnosis.getDiagnoStatus().equals("Not Referrable")) { %>
                                                            <% if(diagnosis.getResult() != null && !diagnosis.getResult().isEmpty()) { %>
                                                                <p><%= diagnosis.getResult() %></p>
                                                            <% } else { %>
                                                                <p>Negative</p>
                                                            <% } %>
                                                        <% } else { %>
                                                            <p><%= diagnosis.getResult() %></p>
                                                        <% } %>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } %>
            </div>
        </div>
        
        <% if (!diagnosesWithResults.isEmpty()) { %>
            <div class="card mt-4">
                <div class="card-header bg-info text-white">
                    <h5 class="mb-0">Health Tips</h5>
                </div>
                <div class="card-body">
                    <div class="row row-cols-1 row-cols-md-3 g-4">
                        <div class="col">
                            <div class="card h-100">
                                <div class="card-body">
                                    <h5 class="card-title"><i class="bi bi-heart-fill text-danger"></i> Regular Check-ups</h5>
                                    <p class="card-text">Remember to schedule regular health check-ups even if you feel healthy. Prevention is always better than cure.</p>
                                </div>
                            </div>
                        </div>
                        <div class="col">
                            <div class="card h-100">
                                <div class="card-body">
                                    <h5 class="card-title"><i class="bi bi-droplet-fill text-primary"></i> Stay Hydrated</h5>
                                    <p class="card-text">Drink plenty of water throughout the day to maintain good health and proper body functions.</p>
                                </div>
                            </div>
                        </div>
                        <div class="col">
                            <div class="card h-100">
                                <div class="card-body">
                                    <h5 class="card-title"><i class="bi bi-activity text-success"></i> Stay Active</h5>
                                    <p class="card-text">Regular physical activity improves overall health and reduces the risk of many diseases.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        <% } %>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="../../js/script.js"></script>
</body>
</html>