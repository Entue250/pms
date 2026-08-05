<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pms.model.User, com.pms.model.Doctor, com.pms.dao.DoctorDAO, com.pms.dao.DiagnosisDAO, com.pms.dao.PatientDAO, com.pms.model.Diagnosis, com.pms.model.Patient, java.util.List" %>
<%
    // Check if user is logged in and is doctor
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getUserType().equals("Doctor")) {
        response.sendRedirect("../../index.jsp");
        return;
    }
    
    // Get doctor information
    DoctorDAO doctorDAO = new DoctorDAO();
    Doctor doctor = doctorDAO.getDoctorByUserId(user.getUserID());
    
    // Get pending referrable cases for this doctor
    DiagnosisDAO diagnosisDAO = new DiagnosisDAO();
    List<Diagnosis> pendingCases = diagnosisDAO.getReferrableCasesByHospital(doctor.getHospitalName());
    
    // Initialize patientDAO to get patient images
    PatientDAO patientDAO = new PatientDAO();
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
    <jsp:include page="../common/doctorNav.jsp" />
    
    <div class="container mt-4">
        <h2 class="mb-4">Pending Cases</h2>
        
        <% if(request.getParameter("success") != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                Case updated successfully!
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } else if(request.getParameter("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                Error updating case. Please try again.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>
        
        <div class="card">
            <div class="card-header bg-warning text-white">
                <h5 class="mb-0">Cases Requiring Diagnosis</h5>
            </div>
            <div class="card-body">
                <% if(pendingCases.isEmpty()) { %>
                    <p class="text-center">No pending cases found.</p>
                <% } else { %>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Patient Name</th>
                                    <th>Referred By</th>
                                    <th>Date</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for(Diagnosis diagnosis : pendingCases) { %>
                                    <tr>
                                        <td><%= diagnosis.getDiagnosisId() %></td>
                                        <td><%= diagnosis.getPatientName() %></td>
                                        <td><%= diagnosis.getNurseName() %></td>
                                        <td><%= diagnosis.getDiagnosisDate() %></td>
                                        <td>
                                            <button class="btn btn-sm btn-primary" 
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#caseModal<%= diagnosis.getDiagnosisId() %>">
                                                Diagnose
                                            </button>
                                        </td>
                                    </tr>
                                    
                                    <!-- Modal for case details and update -->
                                    <div class="modal fade" id="caseModal<%= diagnosis.getDiagnosisId() %>" tabindex="-1">
                                        <div class="modal-dialog modal-lg">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <h5 class="modal-title">Patient Diagnosis</h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                </div>
                                                <div class="modal-body">
                                                    <div class="row mb-3">
                                                        <div class="col-md-6">
                                                            <p><strong>Patient ID:</strong> <%= diagnosis.getPatientId() %></p>
                                                            <p><strong>Patient Name:</strong> <%= diagnosis.getPatientName() %></p>
                                                            <p><strong>Referred By:</strong> <%= diagnosis.getNurseName() %></p>
                                                            <p><strong>Date:</strong> <%= diagnosis.getDiagnosisDate() %></p>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <%
                                                                // Get patient image from patient record
                                                                Patient patient = patientDAO.getPatientById(diagnosis.getPatientId());
                                                                String imageLink = (patient != null) ? patient.getImageLink() : null;
                                                            %>
                                                            <% if(imageLink != null && !imageLink.isEmpty()) { %>
                                                                <img src="../../<%= imageLink %>" class="img-fluid" alt="Patient Image">
                                                            <% } else { %>
                                                                <p class="text-center">No image available</p>
                                                            <% } %>
                                                        </div>
                                                    </div>
                                                    
                                                    <form action="../../updateDiagnosis" method="post">
                                                        <input type="hidden" name="diagnosisId" value="<%= diagnosis.getDiagnosisId() %>">
                                                        <input type="hidden" name="doctorId" value="<%= doctor.getDoctorId() %>">
                                                        
                                                        <div class="mb-3">
                                                            <label for="result<%= diagnosis.getDiagnosisId() %>" class="form-label">Diagnosis Result</label>
                                                            <textarea class="form-control" id="result<%= diagnosis.getDiagnosisId() %>" name="result" rows="5" required></textarea>
                                                        </div>
                                                        
                                                        <div class="text-end">
                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                                            <button type="submit" class="btn btn-primary">Submit Diagnosis</button>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
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