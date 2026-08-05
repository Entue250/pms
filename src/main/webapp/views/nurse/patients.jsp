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
    
    // Get all patients registered by this nurse
    PatientDAO patientDAO = new PatientDAO();
    DiagnosisDAO diagnosisDAO = new DiagnosisDAO();
    List<Patient> patients = patientDAO.getPatientsByNurse(nurse.getNurseId());
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Patients</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <link href="../../css/style.css" rel="stylesheet">
</head>
<body>
    <!-- Include navigation bar -->
    <jsp:include page="../common/nurseNav.jsp" />
    
    <div class="container-fluid mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>My Patients</h2>
            <a href="addPatient.jsp" class="btn btn-success">
                <i class="bi bi-plus-circle"></i> Register New Patient
            </a>
        </div>
        
        <% if(request.getParameter("success") != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                Operation completed successfully!
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } else if(request.getParameter("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                Error processing operation. Please try again.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>
        
        <div class="card">
            <div class="card-header bg-success text-white d-flex justify-content-between align-items-center">
                <h5 class="mb-0">All Registered Patients</h5>
                <div>
                    <input type="text" id="searchInput" class="form-control" placeholder="Search patients...">
                </div>
            </div>
            <div class="card-body">
                <% if(patients.isEmpty()) { %>
                    <p class="text-center">No patients registered yet.</p>
                <% } else { %>
                    <div class="table-responsive">
                        <table class="table table-hover" id="patientsTable">
                            <thead>
                                <tr>
                                    <th>Image</th>
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
                                            <a href="patient-detail.jsp?id=<%= patient.getPatientId() %>" class="btn btn-sm btn-info" data-bs-toggle="tooltip" title="View Details">
                                                <i class="bi bi-eye"></i>
                                            </a>
                                            <a href="edit-patient.jsp?id=<%= patient.getPatientId() %>" class="btn btn-sm btn-warning" data-bs-toggle="tooltip" title="Edit">
                                                <i class="bi bi-pencil"></i>
                                            </a>
                                            <button class="btn btn-sm btn-success" data-bs-toggle="modal" data-bs-target="#uploadModal<%= patient.getPatientId() %>" title="Upload Image">
                                                <i class="bi bi-upload"></i>
                                            </button>
                                        </td>
                                    </tr>
                                    
                                    <!-- Modal for image upload -->
                                    <div class="modal fade" id="uploadModal<%= patient.getPatientId() %>" tabindex="-1">
                                        <div class="modal-dialog">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <h5 class="modal-title">Upload Patient Image</h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                </div>
                                                <div class="modal-body">
                                                    <form action="../../PatientImageUploadServlet" method="post" enctype="multipart/form-data">
                                                        <input type="hidden" name="patientId" value="<%= patient.getPatientId() %>">
                                                        
                                                        <div class="mb-3">
                                                            <label for="patientImage<%= patient.getPatientId() %>" class="form-label">Select Image</label>
                                                            <input type="file" class="form-control" id="patientImage<%= patient.getPatientId() %>" name="patientImage" accept="image/*" onchange="previewImage(this, 'imagePreview<%= patient.getPatientId() %>')" required>
                                                            <div class="mt-2">
                                                                <img id="imagePreview<%= patient.getPatientId() %>" src="#" alt="Image Preview" style="display:none;max-width:100%;max-height:200px;">
                                                            </div>
                                                        </div>
                                                        
                                                        <div class="text-end">
                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                                            <button type="submit" class="btn btn-primary">Upload</button>
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