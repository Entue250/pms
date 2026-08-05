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
    
    // Get non-referrable cases by this nurse
    DiagnosisDAO diagnosisDAO = new DiagnosisDAO();
    
    // Get all diagnoses by this nurse where diagnosis status is "Not Referrable"
    List<Diagnosis> nonReferrableCases = diagnosisDAO.getNonReferrableDiagnosesByNurse(nurse.getNurseId());
    
    // Check for messages
    String message = (String) session.getAttribute("message");
    String error = (String) session.getAttribute("error");
    if (message != null) {
        session.removeAttribute("message");
    }
    if (error != null) {
        session.removeAttribute("error");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Non-Referrable Cases</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <link href="../../css/style.css" rel="stylesheet">
    <!-- Error logging script -->
    <script>
        window.onerror = function(message, source, lineno, colno, error) {
            console.log("Error: " + message + " at line " + lineno);
            return true;
        };
    </script>
</head>
<body>
    <!-- Include navigation bar -->
    <jsp:include page="../common/nurseNav.jsp" />
    
    <div class="container mt-4">
        <h2 class="mb-4">Non-Referrable Cases</h2>
        
        <% if (message != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <%= message %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>
        
        <% if (error != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <%= error %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>
        
        <div class="card dashboard-card">
            <div class="card-header bg-info text-white">
                <h5 class="mb-0">Direct Results</h5>
            </div>
            <div class="card-body">
                <% if(nonReferrableCases.isEmpty()) { %>
                    <p class="text-center">No non-referrable cases found.</p>
                <% } else { %>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Patient Name</th>
                                    <th>Date</th>
                                    <th>Result</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for(Diagnosis diagnosis : nonReferrableCases) { %>
                                    <tr>
                                        <td><%= diagnosis.getPatientName() %></td>
                                        <td><%= diagnosis.getDiagnosisDate() %></td>
                                        <td>
                                            <% 
                                            String result = diagnosis.getResult();
                                            if (result != null) {
                                                if (result.length() > 30) {
                                                    result = result.substring(0, 30) + "...";
                                                }
                                            } else {
                                                result = "Negative";
                                            }
                                            %>
                                            <%= result %>
                                        </td>
                                        <td>
                                            <a href="case-detail.jsp?id=<%= diagnosis.getDiagnosisId() %>" class="btn btn-sm btn-info" data-bs-toggle="tooltip" title="View Details">
                                                <i class="bi bi-eye"></i>
                                            </a>
                                            <button type="button" class="btn btn-sm btn-warning edit-result-btn" 
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#editResultModal<%= diagnosis.getDiagnosisId() %>"
                                                    title="Edit Result"
                                                    onclick="event.stopPropagation();">
                                                <i class="bi bi-pencil"></i>
                                            </button>
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
    
    <!-- Modals (outside the table to avoid issues) -->
    <% for(Diagnosis diagnosis : nonReferrableCases) { %>
    <div class="modal fade" id="editResultModal<%= diagnosis.getDiagnosisId() %>" tabindex="-1" aria-labelledby="editResultModalLabel<%= diagnosis.getDiagnosisId() %>" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editResultModalLabel<%= diagnosis.getDiagnosisId() %>">Edit Diagnosis Result</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="../../updateDiagnosis" method="post" id="editResultForm<%= diagnosis.getDiagnosisId() %>">
                        <input type="hidden" name="diagnosisId" value="<%= diagnosis.getDiagnosisId() %>">
                        <input type="hidden" name="nurseId" value="<%= nurse.getNurseId() %>">
                        <input type="hidden" name="isNonReferrable" value="true">
                        
                        <div class="mb-3">
                            <label for="result<%= diagnosis.getDiagnosisId() %>" class="form-label">Result</label>
                            <textarea class="form-control" id="result<%= diagnosis.getDiagnosisId() %>" name="result" rows="5" required><%= diagnosis.getResult() != null ? diagnosis.getResult() : "" %></textarea>
                        </div>
                        
                        <div class="text-end">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                            <button type="submit" class="btn btn-primary">Update Result</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <% } %>
    
    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Initialize Bootstrap components and handle modal events
        document.addEventListener('DOMContentLoaded', function() {
            try {
                // Initialize tooltips
                var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
                var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                    return new bootstrap.Tooltip(tooltipTriggerEl);
                });
                
                // Manually initialize modals
                var modalTriggers = document.querySelectorAll('.edit-result-btn');
                modalTriggers.forEach(function(button) {
                    button.addEventListener('click', function(event) {
                        event.preventDefault();
                        event.stopPropagation();
                        var targetId = this.getAttribute('data-bs-target');
                        var modalElement = document.querySelector(targetId);
                        var modal = new bootstrap.Modal(modalElement);
                        modal.show();
                    });
                });
                
                // Prevent modal content clicks from closing the modal
                var modals = document.querySelectorAll('.modal');
                modals.forEach(function(modal) {
                    modal.addEventListener('click', function(event) {
                        if (event.target.closest('.modal-content')) {
                            event.stopPropagation();
                        }
                    });
                });
                
                // Handle form submissions
                document.querySelectorAll('form[id^="editResultForm"]').forEach(function(form) {
                    form.addEventListener('submit', function(event) {
                        // This ensures form submission works correctly
                        console.log("Form is being submitted");
                    });
                });
                
            } catch (e) {
                console.error("Error initializing components:", e);
            }
        });
    </script>
</body>
</html>