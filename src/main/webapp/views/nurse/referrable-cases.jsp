<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pms.model.User, com.pms.model.Nurse, com.pms.dao.NurseDAO, com.pms.dao.DiagnosisDAO, com.pms.model.Diagnosis, java.util.List" %>
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
    
    // Get referrable cases by this nurse
    DiagnosisDAO diagnosisDAO = new DiagnosisDAO();
    
    // We need to get all diagnoses by this nurse where diagnosis status is "Referrable"
    // Assuming there's a method for this in DiagnosisDAO
    List<Diagnosis> referrableCases = diagnosisDAO.getReferrableDiagnosesByNurse(nurse.getNurseId());
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Referrable Cases</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <link href="../../css/style.css" rel="stylesheet">
</head>
<body>
    <!-- Include navigation bar -->
    <jsp:include page="../common/nurseNav.jsp" />
    
    <div class="container mt-4">
        <h2 class="mb-4">Referrable Cases</h2>
        
        <div class="row mb-4">
            <div class="col-md-6">
                <div class="card text-white bg-warning h-100">
                    <div class="card-body">
                        <h5 class="card-title">Pending Cases</h5>
                        <p class="card-text display-4"><%= diagnosisDAO.getPendingCasesByNurse(nurse.getNurseId()) %></p>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card text-white bg-success h-100">
                    <div class="card-body">
                        <h5 class="card-title">Confirmed Cases</h5>
                        <p class="card-text display-4"><%= diagnosisDAO.getConfirmedCasesByNurse(nurse.getNurseId()) %></p>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="card">
            <div class="card-header bg-warning text-white">
                <h5 class="mb-0">Referred to Doctors</h5>
            </div>
            <div class="card-body">
                <% if(referrableCases.isEmpty()) { %>
                    <p class="text-center">No referrable cases found.</p>
                <% } else { %>
                    <ul class="nav nav-tabs mb-3" id="caseTabs" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="pending-tab" data-bs-toggle="tab" data-bs-target="#pending" type="button" role="tab" aria-controls="pending" aria-selected="true">Pending</button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="confirmed-tab" data-bs-toggle="tab" data-bs-target="#confirmed" type="button" role="tab" aria-controls="confirmed" aria-selected="false">Confirmed</button>
                        </li>
                    </ul>
                    
                    <div class="tab-content" id="caseTabsContent">
                        <div class="tab-pane fade show active" id="pending" role="tabpanel" aria-labelledby="pending-tab">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Patient Name</th>
                                            <th>Date</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% 
                                        for(Diagnosis diagnosis : referrableCases) {
                                            if(diagnosis.getResult() == null || diagnosis.getResult().equals("pending")) {
                                        %>
                                            <tr>
                                                <td><%= diagnosis.getPatientName() %></td>
                                                <td><%= diagnosis.getDiagnosisDate() %></td>
                                                <td><span class="badge bg-warning">Pending</span></td>
                                                <td>
                                                    <a href="case-detail.jsp?id=<%= diagnosis.getDiagnosisId() %>" class="btn btn-sm btn-info" data-bs-toggle="tooltip" title="View Details">
                                                        <i class="bi bi-eye"></i>
                                                    </a>
                                                </td>
                                            </tr>
                                        <% 
                                            }
                                        } 
                                        %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        
                        <div class="tab-pane fade" id="confirmed" role="tabpanel" aria-labelledby="confirmed-tab">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Patient Name</th>
                                            <th>Date</th>
                                            <th>Doctor</th>
                                            <th>Result</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% 
                                        for(Diagnosis diagnosis : referrableCases) {
                                            if(diagnosis.getResult() != null && !diagnosis.getResult().equals("pending")) {
                                        %>
                                            <tr>
                                                <td><%= diagnosis.getPatientName() %></td>
                                                <td><%= diagnosis.getDiagnosisDate() %></td>
                                                <td><%= diagnosis.getDoctorName() != null ? diagnosis.getDoctorName() : "N/A" %></td>
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
                                                    <a href="case-detail.jsp?id=<%= diagnosis.getDiagnosisId() %>" class="btn btn-sm btn-info" data-bs-toggle="tooltip" title="View Details">
                                                        <i class="bi bi-eye"></i>
                                                    </a>
                                                </td>
                                            </tr>
                                        <% 
                                            }
                                        } 
                                        %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="../../js/script.js"></script>
</body>
</html>