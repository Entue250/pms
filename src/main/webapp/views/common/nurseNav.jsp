<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pms.model.User, com.pms.model.Nurse, com.pms.dao.NurseDAO" %>
<%
User currentUser = (User) session.getAttribute("user");
NurseDAO nurseDAO = new NurseDAO();
Nurse nurse = nurseDAO.getNurseByUserId(currentUser.getUserID());
%>
<nav class="navbar navbar-expand-lg navbar-dark bg-success">
<div class="container-fluid">
<a class="navbar-brand" href="#">Nurse Portal</a>
<button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
<span class="navbar-toggler-icon"></span>
</button>
<div class="collapse navbar-collapse" id="navbarNav">
<ul class="navbar-nav">
<li class="nav-item">
<a class="nav-link" href="dashboard.jsp">Dashboard</a>
</li>
<li class="nav-item">
<a class="nav-link" href="patients.jsp">My Patients</a>
</li>
<li class="nav-item">
<a class="nav-link" href="addPatient.jsp">Register Patient</a>
</li>
<li class="nav-item">
<a class="nav-link" href="referrable-cases.jsp">Referrable Cases</a>
</li>
<li class="nav-item">
<a class="nav-link" href="nonreferrable-cases.jsp">Non-Referrable Cases</a>
</li>
</ul>
<ul class="navbar-nav ms-auto">
<li class="nav-item dropdown">
<a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
<%= nurse.getFirstName() + " " + nurse.getLastName() %>
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