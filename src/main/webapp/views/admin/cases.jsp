<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pms.model.User, com.pms.model.Diagnosis, com.pms.dao.DiagnosisDAO, java.util.List" %>
<%
    // Check if user is logged in and is admin
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getUserType().equals("Admin")) {
        response.sendRedirect("../../index.jsp");
        return;
    }
    
    // Get all diagnoses
    DiagnosisDAO diagnosisDAO = new DiagnosisDAO();
    List<Diagnosis> diagnoses = diagnosisDAO.getAllDiagnoses();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>All Diagnosis Cases</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <link href="../../css/style.css" rel="stylesheet">
</head>
<body>
    <!-- Include navigation bar -->
    <jsp:include page="../common/adminNav.jsp" />
    
    <div class="container-fluid mt-4">
        <h2 class="mb-4">All Diagnosis Cases</h2>
        
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card text-white bg-primary h-100">
                    <div class="card-body">
                        <h5 class="card-title">Total Cases</h5>
                        <p class="card-text display-4"><%= diagnosisDAO.getTotalCasesCount() %></p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card text-white bg-warning h-100">
                    <div class="card-body">
                        <h5 class="card-title">Pending</h5>
                        <p class="card-text display-4"><%= diagnosisDAO.getPendingCasesCount() %></p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card text-white bg-success h-100">
                    <div class="card-body">
                        <h5 class="card-title">Confirmed</h5>
                        <p class="card-text display-4"><%= diagnosisDAO.getConfirmedCasesCount() %></p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card text-white bg-info h-100">
                    <div class="card-body">
                        <h5 class="card-title">Not Referrable</h5>
                        <p class="card-text display-4"><%= diagnosisDAO.getNotReferrableCasesCount() %></p>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="card">
            <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                <h5 class="mb-0">Diagnosis Records</h5>
                <div>
                    <button class="btn btn-light btn-sm" id="filterBtn">
                        <i class="bi bi-funnel"></i> Filter
                    </button>
                </div>
            </div>
            <div class="card-body">
                <div id="filterOptions" class="mb-3 p-3 border rounded" style="display: none;">
                    <div class="row">
                        <div class="col-md-3">
                            <select class="form-select" id="statusFilter">
                                <option value="">All Statuses</option>
                                <option value="Referrable-pending">Pending</option>
                                <option value="Referrable-confirmed">Confirmed</option>
                                <option value="Not Referrable">Not Referrable</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <input type="text" class="form-control" id="patientFilter" placeholder="Patient Name">
                        </div>
                        <div class="col-md-3">
                            <input type="text" class="form-control" id="nurseFilter" placeholder="Nurse Name">
                        </div>
                        <div class="col-md-3">
                            <button class="btn btn-primary" id="applyFilterBtn">Apply</button>
                            <button class="btn btn-secondary" id="resetFilterBtn">Reset</button>
                        </div>
                    </div>
                </div>
                
                <% if(diagnoses.isEmpty()) { %>
                    <p class="text-center">No diagnosis records found.</p>
                <% } else { %>
                    <div class="table-responsive">
                        <table class="table table-hover" id="diagnosisTable">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Patient</th>
                                    <th>Nurse</th>
                                    <th>Doctor</th>
                                    <th>Status</th>
                                    <th>Date</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for(Diagnosis diagnosis : diagnoses) { %>
                                    <tr>
                                        <td><%= diagnosis.getDiagnosisId() %></td>
                                        <td><%= diagnosis.getPatientName() %></td>
                                        <td><%= diagnosis.getNurseName() %></td>
                                        <td><%= diagnosis.getDoctorName() != null ? diagnosis.getDoctorName() : "N/A" %></td>
                                        <td class="status-cell">
                                            <% if(diagnosis.getDiagnoStatus().equals("Referrable") && 
                                                  (diagnosis.getResult() == null || diagnosis.getResult().equals("pending"))) { %>
                                                <span class="badge bg-warning">Pending</span>
                                                <span class="d-none">Referrable-pending</span>
                                            <% } else if(diagnosis.getDiagnoStatus().equals("Referrable") && 
                                                        diagnosis.getResult() != null && !diagnosis.getResult().equals("pending")) { %>
                                                <span class="badge bg-success">Confirmed</span>
                                                <span class="d-none">Referrable-confirmed</span>
                                            <% } else { %>
                                                <span class="badge bg-info">Not Referrable</span>
                                                <span class="d-none">Not Referrable</span>
                                            <% } %>
                                        </td>
                                        <td><%= diagnosis.getDiagnosisDate() %></td>
                                        <td>
                                            <a href="case-detail.jsp?id=<%= diagnosis.getDiagnosisId() %>" class="btn btn-sm btn-info" data-bs-toggle="tooltip" title="View Details">
                                                <i class="bi bi-eye"></i>
                                            </a>
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
        // Filter functionality
        document.getElementById('filterBtn').addEventListener('click', function() {
            const filterOptions = document.getElementById('filterOptions');
            if (filterOptions.style.display === 'none') {
                filterOptions.style.display = 'block';
            } else {
                filterOptions.style.display = 'none';
            }
        });
        
        document.getElementById('applyFilterBtn').addEventListener('click', function() {
            const statusFilter = document.getElementById('statusFilter').value.toLowerCase();
            const patientFilter = document.getElementById('patientFilter').value.toLowerCase();
            const nurseFilter = document.getElementById('nurseFilter').value.toLowerCase();
            
            const rows = document.querySelectorAll('#diagnosisTable tbody tr');
            
            rows.forEach(row => {
                const patientName = row.cells[1].textContent.toLowerCase();
                const nurseName = row.cells[2].textContent.toLowerCase();
                const statusCell = row.querySelector('.status-cell');
                const status = statusCell.querySelector('.d-none').textContent.toLowerCase();
                
                let showRow = true;
                
                if (statusFilter && !status.includes(statusFilter)) {
                    showRow = false;
                }
                
                if (patientFilter && !patientName.includes(patientFilter)) {
                    showRow = false;
                }
                
                if (nurseFilter && !nurseName.includes(nurseFilter)) {
                    showRow = false;
                }
                
                row.style.display = showRow ? '' : 'none';
            });
        });
        
        document.getElementById('resetFilterBtn').addEventListener('click', function() {
            document.getElementById('statusFilter').value = '';
            document.getElementById('patientFilter').value = '';
            document.getElementById('nurseFilter').value = '';
            
            const rows = document.querySelectorAll('#diagnosisTable tbody tr');
            rows.forEach(row => {
                row.style.display = '';
            });
        });
    </script>
</body>
</html>