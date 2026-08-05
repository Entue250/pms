<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pms.model.User, com.pms.model.Doctor, com.pms.dao.DoctorDAO, com.pms.dao.DiagnosisDAO, com.pms.dao.PatientDAO, com.pms.model.Diagnosis, java.util.List" %>
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
    
    // Get confirmed cases for this doctor
    DiagnosisDAO diagnosisDAO = new DiagnosisDAO();
    
    // SQL query would be something like:
    // SELECT d.* FROM Diagnosis d
    // JOIN Nurses n ON d.NurseID = n.NurseID
    // WHERE n.HealthCenter = ? AND d.DiagnoStatus = 'Referrable' AND d.Result IS NOT NULL AND d.Result != 'pending'
    
    // For now, we'll assume this method exists:
    List<Diagnosis> confirmedCases = diagnosisDAO.getConfirmedCasesByDoctor(doctor.getDoctorId());
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Confirmed Cases</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <link href="../../css/style.css" rel="stylesheet">
</head>
<body>
    <!-- Include navigation bar -->
    <jsp:include page="../common/doctorNav.jsp" />
    
    <div class="container mt-4">
        <h2 class="mb-4">Confirmed Cases</h2>
        
        <div class="card">
            <div class="card-header bg-success text-white">
                <h5 class="mb-0">Completed Diagnoses</h5>
            </div>
            <div class="card-body">
                <% if(confirmedCases.isEmpty()) { %>
                    <p class="text-center">No confirmed cases found.</p>
                <% } else { %>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Patient Name</th>
                                    <th>Referred By</th>
                                    <th>Date</th>
                                    <th>Result</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for(Diagnosis diagnosis : confirmedCases) { %>
                                    <tr>
                                        <td><%= diagnosis.getDiagnosisId() %></td>
                                        <td><%= diagnosis.getPatientName() %></td>
                                        <td><%= diagnosis.getNurseName() %></td>
                                        <td><%= diagnosis.getDiagnosisDate() %></td>
                                        <td>
                                            <% 
                                            String result = diagnosis.getResult();
                                            if (result.length() > 30) {
                                                result = result.substring(0, 30) + "...";
                                            }
                                            %>
                                            <%= result %>
                                        </td>
                                        <td>
                                            <button class="btn btn-sm btn-info" 
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#caseModal<%= diagnosis.getDiagnosisId() %>">
                                                View Details
                                            </button>
                                        </td>
                                    </tr>
                                    
                                    <!-- Modal for case details -->
                                    <div class="modal fade" id="caseModal<%= diagnosis.getDiagnosisId() %>" tabindex="-1">
                                        <div class="modal-dialog modal-lg">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <h5 class="modal-title">Diagnosis Details</h5>
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
                                                            <div class="card">
                                                                <div class="card-header bg-success text-white">
                                                                    <h6 class="mb-0">Diagnosis Result</h6>
                                                                </div>
                                                                <div class="card-body">
                                                                    <p><%= diagnosis.getResult() %></p>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    
                                                    <div class="text-end">
                                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                                    </div>
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