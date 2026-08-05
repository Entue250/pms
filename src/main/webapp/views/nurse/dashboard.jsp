<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pms.model.User, com.pms.model.Nurse, com.pms.dao.NurseDAO, com.pms.dao.PatientDAO, com.pms.dao.DiagnosisDAO, com.pms.model.Patient, java.util.List" %>
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
    
    // Get data for dashboard
    PatientDAO patientDAO = new PatientDAO();
    DiagnosisDAO diagnosisDAO = new DiagnosisDAO();
    
    List<Patient> patients = patientDAO.getPatientsByNurse(nurse.getNurseId());
    int totalPatients = patients.size();
    int referrableCases = diagnosisDAO.getReferrableCasesByNurse(nurse.getNurseId());
    int notReferrableCases = diagnosisDAO.getNotReferrableCasesByNurse(nurse.getNurseId());
    int pendingCases = diagnosisDAO.getPendingCasesByNurse(nurse.getNurseId());
    int confirmedCases = diagnosisDAO.getConfirmedCasesByNurse(nurse.getNurseId());
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Nurse Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
</head>
<body>
    <!-- Include navigation bar -->
    <jsp:include page="../common/nurseNav.jsp" />
    
    <div class="container-fluid mt-4">
        <h2 class="mb-4">Welcome, <%= nurse.getFirstName() + " " + nurse.getLastName() %></h2>
        
        <div class="row row-cols-1 row-cols-md-4 g-4 mb-4">
            <div class="col">
                <div class="card text-white bg-primary h-100">
                    <div class="card-body">
                        <h5 class="card-title">Total Patients</h5>
                        <p class="card-text display-4"><%= totalPatients %></p>
                    </div>
                    <div class="card-footer d-flex justify-content-between align-items-center">
                        <small>Registered Patients</small>
                        <a href="patients.jsp" class="text-white">View <i class="bi bi-arrow-right"></i></a>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card text-white bg-warning h-100">
                    <div class="card-body">
                        <h5 class="card-title">Referrable Cases</h5>
                        <p class="card-text display-4"><%= referrableCases %></p>
                    </div>
                    <div class="card-footer d-flex justify-content-between align-items-center">
                        <small>Referred to Doctors</small>
                        <a href="referrable-cases.jsp" class="text-white">View <i class="bi bi-arrow-right"></i></a>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card text-white bg-info h-100">
                    <div class="card-body">
                        <h5 class="card-title">Non-Referrable</h5>
                        <p class="card-text display-4"><%= notReferrableCases %></p>
                    </div>
                    <div class="card-footer d-flex justify-content-between align-items-center">
                        <small>Direct Results</small>
                        <a href="nonreferrable-cases.jsp" class="text-white">View <i class="bi bi-arrow-right"></i></a>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card text-white bg-success h-100">
                    <div class="card-body">
                        <h5 class="card-title">Confirmed Cases</h5>
                        <p class="card-text display-4"><%= confirmedCases %></p>
                    </div>
                    <div class="card-footer d-flex justify-content-between align-items-center">
                        <small>Processed by Doctors</small>
                        <a href="confirmed-cases.jsp" class="text-white">View <i class="bi bi-arrow-right"></i></a>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row mb-4">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Recent Patients</h5>
                        <a href="addPatient.jsp" class="btn btn-sm btn-light">Register New Patient</a>
                    </div>
                    <div class="card-body">
                        <% if (patients.isEmpty()) { %>
                            <p class="text-center">No patients registered yet.</p>
                        <% } else { %>
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Image</th>
                                            <th>Name</th>
                                            <th>Email</th>
                                            <th>Telephone</th>
                                            <th>Status</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% 
                                        int patientLimit = Math.min(5, patients.size());
                                        for(int i = 0; i < patientLimit; i++) { 
                                            Patient patient = patients.get(i);
                                            String status = diagnosisDAO.getLatestStatusForPatient(patient.getPatientId());
                                        %>
                                            <tr>
                                                <td>
                                                    <% if(patient.getImageLink() != null && !patient.getImageLink().isEmpty()) { %>
                                                        <img src="../../<%= patient.getImageLink() %>" class="img-thumbnail" width="50" alt="Patient Image">
                                                    <% } else { %>
                                                        <span class="badge bg-secondary">No Image</span>
                                                    <% } %>
                                                </td>
                                                <td><%= patient.getFirstName() + " " + patient.getLastName() %></td>
                                                <td><%= patient.getEmail() %></td>
                                                <td><%= patient.getTelephone() %></td>
                                                <td>
                                                    <% if (status.equals("Referrable-pending")) { %>
                                                        <span class="badge bg-warning">Pending</span>
                                                    <% } else if (status.equals("Referrable-confirmed")) { %>
                                                        <span class="badge bg-success">Confirmed</span>
                                                    <% } else if (status.equals("Not Referrable")) { %>
                                                        <span class="badge bg-info">Not Referrable</span>
                                                    <% } %>
                                                </td>
                                                <td>
                                                    <a href="patient-detail.jsp?id=<%= patient.getPatientId() %>" class="btn btn-sm btn-primary">
                                                        <i class="bi bi-eye"></i>
                                                    </a>
                                                </td>
                                            </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                            <% if (patients.size() > 5) { %>
                                <div class="text-end">
                                    <a href="patients.jsp" class="btn btn-sm btn-outline-primary">View All</a>
                                </div>
                            <% } %>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header bg-warning text-white">
                        <h5 class="mb-0">Pending Referrals</h5>
                    </div>
                    <div class="card-body">
                        <p>You have <%= pendingCases %> pending referrals waiting for doctor's confirmation.</p>
                        <div class="progress mb-3">
                            <div class="progress-bar bg-warning" role="progressbar" style="width: <%= (double)pendingCases / (pendingCases + confirmedCases) * 100 %>%" 
                                 aria-valuenow="<%= pendingCases %>" aria-valuemin="0" aria-valuemax="<%= pendingCases + confirmedCases %>">
                                <%= pendingCases %>
                            </div>
                        </div>
                        <div class="d-grid">
                            <a href="pending-cases.jsp" class="btn btn-warning">View Pending Cases</a>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0">Health Center Information</h5>
                    </div>
                    <div class="card-body">
                        <p><strong>Health Center:</strong> <%= nurse.getHealthCenter() %></p>
                        <p><strong>Address:</strong> <%= nurse.getAddress() %></p>
                        <p><strong>Contact:</strong> <%= nurse.getTelephone() %></p>
                        <p><strong>Email:</strong> <%= nurse.getEmail() %></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>