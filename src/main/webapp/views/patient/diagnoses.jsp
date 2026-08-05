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
    
    // Get diagnoses for this patient
    DiagnosisDAO diagnosisDAO = new DiagnosisDAO();
    List<Diagnosis> diagnoses = diagnosisDAO.getDiagnosesByPatientId(patient.getPatientId());
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Diagnoses</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <link href="../../css/style.css" rel="stylesheet">
</head>
<body>
    <!-- Include navigation bar -->
    <jsp:include page="../common/patientNav.jsp" />
    
    <div class="container mt-4">
        <h2 class="mb-4">My Diagnosis History</h2>
        
        <div class="card">
            <div class="card-header bg-info text-white d-flex justify-content-between align-items-center">
                <h5 class="mb-0">All Diagnoses</h5>
                <div>
                    <input type="text" id="searchInput" class="form-control" placeholder="Search...">
                </div>
            </div>
            <div class="card-body">
                <% if(diagnoses.isEmpty()) { %>
                    <p class="text-center">No diagnosis records found.</p>
                <% } else { %>
                    <ul class="nav nav-tabs mb-3" id="diagnosisTabs" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="all-tab" data-bs-toggle="tab" data-bs-target="#all" type="button" role="tab" aria-controls="all" aria-selected="true">All</button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="pending-tab" data-bs-toggle="tab" data-bs-target="#pending" type="button" role="tab" aria-controls="pending" aria-selected="false">Pending</button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="confirmed-tab" data-bs-toggle="tab" data-bs-target="#confirmed" type="button" role="tab" aria-controls="confirmed" aria-selected="false">Confirmed</button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="nonreferrable-tab" data-bs-toggle="tab" data-bs-target="#nonreferrable" type="button" role="tab" aria-controls="nonreferrable" aria-selected="false">Not Referrable</button>
                        </li>
                    </ul>
                    
                    <div class="tab-content" id="diagnosisTabsContent">
                        <div class="tab-pane fade show active" id="all" role="tabpanel" aria-labelledby="all-tab">
                            <div class="table-responsive">
                                <table class="table table-hover" id="diagnosisTable">
                                    <thead>
                                        <tr>
                                            <th>Date</th>
                                            <th>Nurse</th>
                                            <th>Doctor</th>
                                            <th>Status</th>
                                            <th>Result</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for(Diagnosis diagnosis : diagnoses) { %>
                                            <tr>
                                                <td><%= diagnosis.getDiagnosisDate() %></td>
                                                <td><%= diagnosis.getNurseName() %></td>
                                                <td>
                                                    <% if(diagnosis.getDoctorName() != null && !diagnosis.getDoctorName().isEmpty()) { %>
                                                        <%= diagnosis.getDoctorName() %>
                                                    <% } else { %>
                                                        <span class="text-muted">N/A</span>
                                                    <% } %>
                                                </td>
                                                <td class="status-cell">
                                                    <% if(diagnosis.getDiagnoStatus().equals("Referrable") && 
                                                        (diagnosis.getResult() == null || diagnosis.getResult().equals("pending"))) { %>
                                                        <span class="badge bg-warning">Pending</span>
                                                        <span class="d-none">pending</span>
                                                    <% } else if(diagnosis.getDiagnoStatus().equals("Referrable") && 
                                                                diagnosis.getResult() != null && !diagnosis.getResult().equals("pending")) { %>
                                                        <span class="badge bg-success">Confirmed</span>
                                                        <span class="d-none">confirmed</span>
                                                    <% } else { %>
                                                        <span class="badge bg-info">Not Referrable</span>
                                                        <span class="d-none">nonreferrable</span>
                                                    <% } %>
                                                </td>
                                                <td>
                                                    <% 
                                                    String result = "";
                                                    if(diagnosis.getDiagnoStatus().equals("Referrable") && 
                                                      (diagnosis.getResult() == null || diagnosis.getResult().equals("pending"))) {
                                                        result = "Pending";
                                                    } else if(diagnosis.getDiagnoStatus().equals("Not Referrable")) {
                                                        result = "Negative";
                                                        if(diagnosis.getResult() != null && !diagnosis.getResult().isEmpty()) {
                                                            result = diagnosis.getResult();
                                                        }
                                                    } else {
                                                        result = diagnosis.getResult();
                                                    }
                                                    
                                                    // Truncate long results
                                                    if (result.length() > 30) {
                                                        result = result.substring(0, 30) + "...";
                                                    }
                                                    %>
                                                    <%= result %>
                                                </td>
                                                <td>
                                                    <button class="btn btn-sm btn-info" 
                                                            data-bs-toggle="modal" 
                                                            data-bs-target="#diagnosisModal<%= diagnosis.getDiagnosisId() %>">
                                                        <i class="bi bi-eye"></i> View
                                                    </button>
                                                </td>
                                            </tr>
                                            
                                            <!-- Modal for diagnosis details -->
                                            <div class="modal fade" id="diagnosisModal<%= diagnosis.getDiagnosisId() %>" tabindex="-1">
                                                <div class="modal-dialog modal-lg">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title">Diagnosis Details</h5>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <div class="row mb-3">
                                                                <div class="col-md-6">
                                                                    <p><strong>Date:</strong> <%= diagnosis.getDiagnosisDate() %></p>
                                                                    <p><strong>Nurse:</strong> <%= diagnosis.getNurseName() %></p>
                                                                    <p><strong>Doctor:</strong> 
                                                                        <% if(diagnosis.getDoctorName() != null && !diagnosis.getDoctorName().isEmpty()) { %>
                                                                            <%= diagnosis.getDoctorName() %>
                                                                        <% } else { %>
                                                                            <span class="text-muted">N/A</span>
                                                                        <% } %>
                                                                    </p>
                                                                    <p><strong>Status:</strong> 
                                                                        <% if(diagnosis.getDiagnoStatus().equals("Referrable") && 
                                                                            (diagnosis.getResult() == null || diagnosis.getResult().equals("pending"))) { %>
                                                                            <span class="badge bg-warning">Pending</span>
                                                                        <% } else if(diagnosis.getDiagnoStatus().equals("Referrable") && 
                                                                                    diagnosis.getResult() != null && !diagnosis.getResult().equals("pending")) { %>
                                                                            <span class="badge bg-success">Confirmed</span>
                                                                        <% } else { %>
                                                                            <span class="badge bg-info">Not Referrable</span>
                                                                        <% } %>
                                                                    </p>
                                                                </div>
                                                                <div class="col-md-6">
                                                                    <% if(patient.getImageLink() != null && !patient.getImageLink().isEmpty()) { %>
                                                                        <img src="../../<%= patient.getImageLink() %>" class="img-fluid" alt="Patient Image">
                                                                    <% } else { %>
                                                                        <div class="alert alert-secondary text-center">No image available</div>
                                                                    <% } %>
                                                                </div>
                                                            </div>
                                                            
                                                            <div class="card">
                                                                <div class="card-header">
                                                                    <h6 class="mb-0">Diagnosis Result</h6>
                                                                </div>
                                                                <div class="card-body">
                                                                    <% if(diagnosis.getDiagnoStatus().equals("Referrable") && 
                                                                        (diagnosis.getResult() == null || diagnosis.getResult().equals("pending"))) { %>
                                                                        <div class="alert alert-warning">
                                                                            Your diagnosis has been referred to a doctor and is currently pending. 
                                                                            You will be notified when results are available.
                                                                        </div>
                                                                    <% } else if(diagnosis.getDiagnoStatus().equals("Not Referrable")) { %>
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
                                                            
                                                            <div class="text-end mt-3">
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
                        </div>
                        
                        <div class="tab-pane fade" id="pending" role="tabpanel" aria-labelledby="pending-tab">
                            <!-- Content for pending diagnoses (filtered from the main table) -->
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Date</th>
                                            <th>Nurse</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% 
                                        boolean hasPending = false;
                                        for(Diagnosis diagnosis : diagnoses) {
                                            if(diagnosis.getDiagnoStatus().equals("Referrable") && 
                                               (diagnosis.getResult() == null || diagnosis.getResult().equals("pending"))) {
                                                hasPending = true;
                                        %>
                                            <tr>
                                                <td><%= diagnosis.getDiagnosisDate() %></td>
                                                <td><%= diagnosis.getNurseName() %></td>
                                                <td>
                                                    <button class="btn btn-sm btn-info" 
                                                            data-bs-toggle="modal" 
                                                            data-bs-target="#diagnosisModal<%= diagnosis.getDiagnosisId() %>">
                                                        <i class="bi bi-eye"></i> View
                                                    </button>
                                                </td>
                                            </tr>
                                        <% 
                                            }
                                        }
                                        if (!hasPending) {
                                        %>
                                            <tr>
                                                <td colspan="3" class="text-center">No pending diagnoses found.</td>
                                            </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        
                        <div class="tab-pane fade" id="confirmed" role="tabpanel" aria-labelledby="confirmed-tab">
                            <!-- Content for confirmed diagnoses (filtered from the main table) -->
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Date</th>
                                            <th>Nurse</th>
                                            <th>Doctor</th>
                                            <th>Result</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% 
                                        boolean hasConfirmed = false;
                                        for(Diagnosis diagnosis : diagnoses) {
                                            if(diagnosis.getDiagnoStatus().equals("Referrable") && 
                                               diagnosis.getResult() != null && !diagnosis.getResult().equals("pending")) {
                                                hasConfirmed = true;
                                        %>
                                            <tr>
                                                <td><%= diagnosis.getDiagnosisDate() %></td>
                                                <td><%= diagnosis.getNurseName() %></td>
                                                <td><%= diagnosis.getDoctorName() %></td>
                                                <td>
                                                    <% 
                                                    String result = diagnosis.getResult();
                                                    // Truncate long results
                                                    if (result.length() > 30) {
                                                        result = result.substring(0, 30) + "...";
                                                    }
                                                    %>
                                                    <%= result %>
                                                </td>
                                                <td>
                                                    <button class="btn btn-sm btn-info" 
                                                            data-bs-toggle="modal" 
                                                            data-bs-target="#diagnosisModal<%= diagnosis.getDiagnosisId() %>">
                                                        <i class="bi bi-eye"></i> View
                                                    </button>
                                                </td>
                                            </tr>
                                        <% 
                                            }
                                        }
                                        if (!hasConfirmed) {
                                        %>
                                            <tr>
                                                <td colspan="5" class="text-center">No confirmed diagnoses found.</td>
                                            </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        
                        <div class="tab-pane fade" id="nonreferrable" role="tabpanel" aria-labelledby="nonreferrable-tab">
                            <!-- Content for non-referrable diagnoses (filtered from the main table) -->
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Date</th>
                                            <th>Nurse</th>
                                            <th>Result</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% 
                                        boolean hasNonReferrable = false;
                                        for(Diagnosis diagnosis : diagnoses) {
                                            if(diagnosis.getDiagnoStatus().equals("Not Referrable")) {
                                                hasNonReferrable = true;
                                        %>
                                            <tr>
                                                <td><%= diagnosis.getDiagnosisDate() %></td>
                                                <td><%= diagnosis.getNurseName() %></td>
                                                <td>
                                                    <% 
                                                    String result = "Negative";
                                                    if(diagnosis.getResult() != null && !diagnosis.getResult().isEmpty()) {
                                                        result = diagnosis.getResult();
                                                    }
                                                    // Truncate long results
                                                    if (result.length() > 30) {
                                                        result = result.substring(0, 30) + "...";
                                                    }
                                                    %>
                                                    <%= result %>
                                                </td>
                                                <td>
                                                    <button class="btn btn-sm btn-info" 
                                                            data-bs-toggle="modal" 
                                                            data-bs-target="#diagnosisModal<%= diagnosis.getDiagnosisId() %>">
                                                        <i class="bi bi-eye"></i> View
                                                    </button>
                                                </td>
                                            </tr>
                                        <% 
                                            }
                                        }
                                        if (!hasNonReferrable) {
                                        %>
                                            <tr>
                                                <td colspan="4" class="text-center">No non-referrable diagnoses found.</td>
                                            </tr>
                                        <% } %>
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
    <script>
        // Search functionality
        document.getElementById('searchInput').addEventListener('keyup', function() {
            var input, filter, table, tr, td, i, txtValue;
            input = document.getElementById('searchInput');
            filter = input.value.toUpperCase();
            table = document.getElementById('diagnosisTable');
            tr = table.getElementsByTagName('tr');

            for (i = 1; i < tr.length; i++) {
                var found = false;
                // Check all columns
                for (var j = 0; j < tr[i].cells.length - 1; j++) {
                    td = tr[i].cells[j];
                    if (td) {
                        txtValue = td.textContent || td.innerText;
                        if (txtValue.toUpperCase().indexOf(filter) > -1) {
                            found = true;
                            break;
                        }
                    }
                }
                
                if (found) {
                    tr[i].style.display = '';
                } else {
                    tr[i].style.display = 'none';
                }
            }
        });
    </script>
</body>
</html>