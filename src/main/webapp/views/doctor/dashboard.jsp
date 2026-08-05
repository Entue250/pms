<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pms.model.User, com.pms.model.Doctor, com.pms.dao.DoctorDAO, com.pms.dao.NurseDAO, com.pms.dao.DiagnosisDAO, com.pms.model.Nurse, java.util.List" %>
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
    
    // Get data for dashboard
    NurseDAO nurseDAO = new NurseDAO();
    DiagnosisDAO diagnosisDAO = new DiagnosisDAO();
    
    List<Nurse> nurses = nurseDAO.getNursesByHealthCenter(doctor.getHospitalName());
    int totalCases = diagnosisDAO.getCasesByHospital(doctor.getHospitalName());
    int pendingCases = diagnosisDAO.getPendingCasesByHospital(doctor.getHospitalName());
    int confirmedCases = diagnosisDAO.getConfirmedCasesByHospital(doctor.getHospitalName());
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Doctor Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
</head>
<body>
    <!-- Include navigation bar -->
    <jsp:include page="../common/doctorNav.jsp" />
    
    <div class="container-fluid mt-4">
        <h2 class="mb-4">Welcome, Dr. <%= doctor.getFirstName() + " " + doctor.getLastName() %></h2>
        
        <div class="row row-cols-1 row-cols-md-3 g-4 mb-4">
            <div class="col">
                <div class="card text-white bg-primary h-100">
                    <div class="card-body">
                        <h5 class="card-title">Total Nurses</h5>
                        <p class="card-text display-4"><%= nurses.size() %></p>
                    </div>
                    <div class="card-footer d-flex justify-content-between align-items-center">
                        <small>Registered Nurses</small>
                        <a href="nurses.jsp" class="text-white">View <i class="bi bi-arrow-right"></i></a>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card text-white bg-warning h-100">
                    <div class="card-body">
                        <h5 class="card-title">Pending Cases</h5>
                        <p class="card-text display-4"><%= pendingCases %></p>
                    </div>
                    <div class="card-footer d-flex justify-content-between align-items-center">
                        <small>Waiting for Diagnosis</small>
                        <a href="pending-cases.jsp" class="text-white">View <i class="bi bi-arrow-right"></i></a>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card text-white bg-success h-100">
                    <div class="card-body">
                        <h5 class="card-title">Completed Cases</h5>
                        <p class="card-text display-4"><%= confirmedCases %></p>
                    </div>
                    <div class="card-footer d-flex justify-content-between align-items-center">
                        <small>Confirmed Results</small>
                        <a href="confirmed-cases.jsp" class="text-white">View <i class="bi bi-arrow-right"></i></a>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row mb-4">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Recent Nurses</h5>
                        <a href="addNurse.jsp" class="btn btn-sm btn-light">Add Nurse</a>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Name</th>
                                        <th>Health Center</th>
                                        <th>Email</th>
                                        <th>Telephone</th>
                                        <th>Registered Cases</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% 
                                    int nurseLimit = Math.min(5, nurses.size());
                                    for(int i = 0; i < nurseLimit; i++) { 
                                        Nurse nurse = nurses.get(i);
                                        int nurseCases = diagnosisDAO.getCasesByNurse(nurse.getNurseId());
                                    %>
                                        <tr>
                                            <td><%= nurse.getFirstName() + " " + nurse.getLastName() %></td>
                                            <td><%= nurse.getHealthCenter() %></td>
                                            <td><%= nurse.getEmail() %></td>
                                            <td><%= nurse.getTelephone() %></td>
                                            <td><%= nurseCases %></td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                        <% if (nurses.size() > 5) { %>
                            <div class="text-end">
                                <a href="nurses.jsp" class="btn btn-sm btn-outline-primary">View All</a>
                            </div>
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
                        <% if (pendingCases > 0) { %>
                            <p>You have <%= pendingCases %> pending cases that require your attention.</p>
                            <div class="d-grid">
                                <a href="pending-cases.jsp" class="btn btn-warning">Review Cases</a>
                            </div>
                        <% } else { %>
                            <p class="text-center">No pending cases at the moment.</p>
                        <% } %>
                    </div>
                </div>
            </div>
            
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0">Hospital Information</h5>
                    </div>
                    <div class="card-body">
                        <p><strong>Hospital Name:</strong> <%= doctor.getHospitalName() %></p>
                        <p><strong>Address:</strong> <%= doctor.getAddress() %></p>
                        <p><strong>Contact:</strong> <%= doctor.getTelephone() %></p>
                        <p><strong>Email:</strong> <%= doctor.getEmail() %></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>