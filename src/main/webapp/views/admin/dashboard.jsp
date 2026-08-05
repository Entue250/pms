<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pms.model.User, com.pms.dao.DoctorDAO, com.pms.dao.NurseDAO, com.pms.dao.DiagnosisDAO, com.pms.model.Doctor, com.pms.model.Nurse, java.util.List" %>
<%
    // Check if user is logged in and is admin
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getUserType().equals("Admin")) {
        response.sendRedirect("../../index.jsp");
        return;
    }
    
    // Get data for dashboard
    DoctorDAO doctorDAO = new DoctorDAO();
    NurseDAO nurseDAO = new NurseDAO();
    DiagnosisDAO diagnosisDAO = new DiagnosisDAO();
    
    List<Doctor> doctors = doctorDAO.getAllDoctors();
    List<Nurse> nurses = nurseDAO.getAllNurses();
    int totalCases = diagnosisDAO.getTotalCasesCount();
    int pendingCases = diagnosisDAO.getPendingCasesCount();
    int confirmedCases = diagnosisDAO.getConfirmedCasesCount();
    int notReferrableCases = diagnosisDAO.getNotReferrableCasesCount();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <link href="../../css/style.css" rel="stylesheet">
</head>
<body>
    <!-- Include navigation bar -->
    <jsp:include page="../common/adminNav.jsp" />
    
    <div class="container-fluid mt-4">
        <h2 class="mb-4">Admin Dashboard</h2>
        
        <div class="row row-cols-1 row-cols-md-4 g-4 mb-4">
            <div class="col">
                <div class="card text-white bg-primary h-100">
                    <div class="card-body">
                        <h5 class="card-title">Total Doctors</h5>
                        <p class="card-text display-4"><%= doctors.size() %></p>
                    </div>
                    <div class="card-footer d-flex justify-content-between align-items-center">
                        <small>Registered Doctors</small>
                        <a href="doctors.jsp" class="text-white">View <i class="bi bi-arrow-right"></i></a>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card text-white bg-success h-100">
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
                <div class="card text-white bg-info h-100">
                    <div class="card-body">
                        <h5 class="card-title">Total Cases</h5>
                        <p class="card-text display-4"><%= totalCases %></p>
                    </div>
                    <div class="card-footer d-flex justify-content-between align-items-center">
                        <small>All Diagnosis Cases</small>
                        <a href="cases.jsp" class="text-white">View <i class="bi bi-arrow-right"></i></a>
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
                        <small>Waiting for Results</small>
                        <a href="pending-cases.jsp" class="text-white">View <i class="bi bi-arrow-right"></i></a>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row mb-4">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Recent Doctors</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Name</th>
                                        <th>Hospital</th>
                                        <th>Email</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% 
                                    int doctorLimit = Math.min(5, doctors.size());
                                    for(int i = 0; i < doctorLimit; i++) { 
                                        Doctor doctor = doctors.get(i);
                                    %>
                                        <tr>
                                            <td><%= doctor.getFirstName() + " " + doctor.getLastName() %></td>
                                            <td><%= doctor.getHospitalName() %></td>
                                            <td><%= doctor.getEmail() %></td>
                                            <td>
                                                <a href="doctor-detail.jsp?id=<%= doctor.getDoctorId() %>" class="btn btn-sm btn-primary">
                                                    <i class="bi bi-eye"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                        <% if (doctors.size() > 5) { %>
                            <div class="text-end">
                                <a href="doctors.jsp" class="btn btn-sm btn-outline-primary">View All</a>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
            
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0">Recent Nurses</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Name</th>
                                        <th>Health Center</th>
                                        <th>Email</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% 
                                    int nurseLimit = Math.min(5, nurses.size());
                                    for(int i = 0; i < nurseLimit; i++) { 
                                        Nurse nurse = nurses.get(i);
                                    %>
                                        <tr>
                                            <td><%= nurse.getFirstName() + " " + nurse.getLastName() %></td>
                                            <td><%= nurse.getHealthCenter() %></td>
                                            <td><%= nurse.getEmail() %></td>
                                            <td>
                                                <a href="nurse-detail.jsp?id=<%= nurse.getNurseId() %>" class="btn btn-sm btn-primary">
                                                    <i class="bi bi-eye"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                        <% if (nurses.size() > 5) { %>
                            <div class="text-end">
                                <a href="nurses.jsp" class="btn btn-sm btn-outline-success">View All</a>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0">Diagnosis Cases Summary</h5>
                    </div>
                    <div class="card-body">
                        <div class="row text-center">
                            <div class="col-md-3">
                                <div class="p-3 border rounded">
                                    <h5>Total Cases</h5>
                                    <h3><%= totalCases %></h3>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="p-3 border rounded">
                                    <h5>Pending</h5>
                                    <h3><%= pendingCases %></h3>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="p-3 border rounded">
                                    <h5>Confirmed</h5>
                                    <h3><%= confirmedCases %></h3>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="p-3 border rounded">
                                    <h5>Not Referrable</h5>
                                    <h3><%= notReferrableCases %></h3>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
     <script src="../../js/script.js"></script>
</body>
</html>