<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pms.model.User, com.pms.model.Patient, com.pms.dao.PatientDAO" %>
<%
User currentUser = (User) session.getAttribute("user");
PatientDAO patientDAO = new PatientDAO();
Patient patient = patientDAO.getPatientByUserId(currentUser.getUserID());
%>
<nav class="navbar navbar-expand-lg navbar-dark bg-info">
<div class="container-fluid">
<a class="navbar-brand" href="#">Patient Portal</a>
<button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
<span class="navbar-toggler-icon"></span>
</button>
<div class="collapse navbar-collapse" id="navbarNav">
<ul class="navbar-nav">
<li class="nav-item">
<a class="nav-link" href="dashboard.jsp">Dashboard</a>
</li>
<li class="nav-item">
<a class="nav-link" href="diagnoses.jsp">My Diagnoses</a>
</li>
<li class="nav-item">
<a class="nav-link" href="results.jsp">Test Results</a>
</li>
</ul>
<ul class="navbar-nav ms-auto">
<li class="nav-item dropdown">
<a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
<%= patient.getFirstName() + " " + patient.getLastName() %>
</a>
<ul class="dropdown-menu dropdown-menu-end">
<li><a class="dropdown-item" href="profile.jsp">My Profile</a></li>
<li><hr class="dropdown-divider"></li>
<li><a class="dropdown-item" href="../../logout">Logout</a></li>
</ul>
</li>
</ul>
</div>
</div>
</nav>