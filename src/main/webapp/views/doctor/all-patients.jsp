<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pms.model.User, com.pms.model.Doctor, com.pms.model.Patient, com.pms.dao.DoctorDAO, com.pms.dao.PatientDAO, com.pms.dao.DiagnosisDAO, java.util.List" %>
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
    
    // Get all patients for this doctor's hospital
    // This would require a custom DAO method that joins Patients, Diagnosis, and Nurses tables
    // to find patients registered by nurses from this doctor's hospital
    
    // For now, we'll assume this method exists:
    PatientDAO patientDAO = new PatientDAO();
    DiagnosisDAO diagnosisDAO = new DiagnosisDAO();
    List<Patient> patients = patientDAO.getPatientsByHospital(doctor.getHospitalName());
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>All Patients</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <link href="../../css/style.css" rel="stylesheet">
</head>
<body>
    <!-- Include navigation bar -->
    <jsp:include page="../common/doctorNav.jsp" />
    
    <div class="container-fluid mt-4">
        <h2 class="mb-4">Hospital Patients</h2>
        
        <div class="card">
            <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                <h5 class="mb-0">All Registered Patients</h5>
                <div>
                    <input type="text" id="searchInput" class="form-control" placeholder="Search patients...">
                </div>
            </div>
            <div class="card-body">
                <% if(patients.isEmpty()) { %>
                    <p class="text-center">No patients found for your hospital.</p>
                <% } else { %>
                    <div class="table-responsive">
                        <table class="table table-hover" id="patientsTable">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Telephone</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for(Patient patient : patients) { 
                                    // Get the latest status for this patient
                                    String status = diagnosisDAO.getLatestStatusForPatient(patient.getPatientId());
                                %>
                                    <tr>
                                        <td><%= patient.getPatientId() %></td>
                                        <td><%= patient.getFirstName() + " " + patient.getLastName() %></td>
                                        <td><%= patient.getEmail() %></td>
                                        <td><%= patient.getTelephone() %></td>
                                        <td>
                                            <% if(status.equals("Referrable-pending")) { %>
                                                <span class="badge bg-warning">Pending</span>
                                            <% } else if(status.equals("Referrable-confirmed")) { %>
                                                <span class="badge bg-success">Confirmed</span>
                                            <% } else if(status.equals("Not Referrable")) { %>
                                                <span class="badge bg-info">Not Referrable</span>
                                            <% } else { %>
                                                <span class="badge bg-secondary">Unknown</span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <a href="patient-detail.jsp?id=<%= patient.getPatientId() %>" class="btn btn-sm btn-info" data-bs-toggle="tooltip" title="View Details">
                                                <i class="bi bi-eye"></i>
                                            </a>
                                            <% if(status.equals("Referrable-pending")) { %>
                                                <button class="btn btn-sm btn-warning" 
                                                        data-bs-toggle="tooltip" title="Pending Diagnosis"
                                                        onclick="location.href='pending-cases.jsp'">
                                                    <i class="bi bi-clipboard-pulse"></i>
                                                </button>
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
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="../../js/script.js"></script>
    <script>
        // Search functionality
        document.getElementById('searchInput').addEventListener('keyup', function() {
            var input, filter, table, tr, td, i, txtValue;
            input = document.getElementById('searchInput');
            filter = input.value.toUpperCase();
            table = document.getElementById('patientsTable');
            tr = table.getElementsByTagName('tr');

            for (i = 1; i < tr.length; i++) {
                // Check name column (index 1)
                td = tr[i].getElementsByTagName('td')[1];
                if (td) {
                    txtValue = td.textContent || td.innerText;
                    if (txtValue.toUpperCase().indexOf(filter) > -1) {
                        tr[i].style.display = '';
                    } else {
                        // Check email column (index 2)
                        td = tr[i].getElementsByTagName('td')[2];
                        txtValue = td.textContent || td.innerText;
                        if (txtValue.toUpperCase().indexOf(filter) > -1) {
                            tr[i].style.display = '';
                        } else {
                            tr[i].style.display = 'none';
                        }
                    }
                }
            }
        });
    </script>
</body>
</html>