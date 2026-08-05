<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.pms.model.User, com.pms.model.Nurse, com.pms.dao.NurseDAO" %>

<%
	User user = (User) session.getAttribute("user");
	if (user == null || !user.getUserType().equals("Nurse")){
		response.sendRedirect("../../index.jsp");
		return;
	}
	
	NurseDAO nurseDAO = new NurseDAO();
	Nurse nurse = nurseDAO.getNurseByUserId(user.getUserID());
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Add New Patient</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
	<jsp:include page="../common/nurseNav.jsp"/>
	<div class="container mt-4">
		<h2 class="mb-4">Register New Patient</h2>
		<% if(request.getParameter("success") != null) { %>
			<div class="alert alert-success"> Patient registered successfully!</div>
			<%} else if(request.getParameter("error") != null) {%>
				<div class="alert alert-danger">Error registered patient. Please try again.</div>
			<% } %>
		<div class="card">
			<div class="card-body">
				<form action="../../registerPatient" method="post" enctype="multipart/form-data">
					<input type="hidden" name="nurseId" value="<%= nurse.getNurseId()%>">
					
					<div class="row mb-3">
						<div class="col-md-6">
							<label for="firstName" class="form-label">First Name</label>
							<input type="text" class="form-control" id="firstName" name="firstName" required>
						</div>
						
						<div class="col-md-6">
							<label for="lastName" class="form-label">Last Name</label>
							<input type="text" class="form-control" id="lastName" name="lastName" required>
						</div>
					</div>
					
					<div class="row mb-3">
						<div class="col-md-6">
							<label for="telephone" class="form-label">Telephone</label>
							<input type="tel" class="form-control" id="telephone" name="telephone" required>
						</div>
						
						<div class="col-md-6">
							<label for="email" class="form-label">Email</label>
							<input type="email" class="form-control" id="email" name="email" required>
						</div>
					</div>
					
					<div class="mb-3">
						<label for="address" class="form-label">Address</label>
						<textarea class="form-label" id="address" name="address" rows="3" required></textarea>
					</div>
					
					<div class="mb-3">
						<label for="patientImage" class="form-label">Patient Image</label>
						<input type="file" class="form-label" id="patientImage" name="patinetImage" accept="image/*">
					</div>
					
					<div class="mb-3">
						<label for="username" class="form-label">Username</label>
						<input type="text" class="form-control" id="username" name="username" required>
					</div>
					
					<div class="mb-3">
						<label for="password" class="form-label">Password</label>
						<input type="password" class="form-control" id="password" name="password" required>
					</div>
					
					<div class="mb-3">
						<label for="diagnosisStatus" class="form-control">Diagnosis Status</label>
						<select class="form-control" id="diagnosisStatus" name="diagnosisStatus" required>
							<option value=""></option>
							<option value="Referrable">Referrable</option>
							<option value="Not Referrable">Not Referrable</option>
						</select>
					</div>
					
					<div class="mb-3">
						<label class="result" class="form-control">Initial Result</label>
						<textarea class="form-control" id="result" name="result" rows="3"></textarea>
						<small class="text-muted">Leave blank if diagnosis status is "Referrable"</small>
					</div>
					
					<div class="text-end">
						<button type="submit" class="btn btn-primary">Register Patient</button>
					</div>
				</form>
			</div>
		</div>
				
	</div>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

