<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pms.model.User, com.pms.model.Doctor, com.pms.dao.DoctorDAO" %>
<%
User currentUser = (User) session.getAttribute("user");
DoctorDAO doctorDAO = new DoctorDAO();
Doctor doctor = doctorDAO.getDoctorByUserId(currentUser.getUserID());
%>
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
<div class="container-fluid">
<a class="navbar-brand" href="#">Doctor Portal</a>
<button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
<span class="navbar-toggler-icon"></span>
</button>
<div class="collapse navbar-collapse" id="navbarNav">
<ul class="navbar-nav">
<li class="nav-item">
<a class="nav-link" href="dashboard.jsp">Dashboard</a>
</li>
<li class="nav-item">
<a class="nav-link" href="nurses.jsp">Nurses</a>
</li>
<li class="nav-item">
<a class="nav-link" href="addNurse.jsp">Register Nurse</a>
</li>
<li class="nav-item">
<a class="nav-link" href="pending-cases.jsp">Pending Cases</a>
</li>
<li class="nav-item">
<a class="nav-link" href="confirmed-cases.jsp">Confirmed Cases</a>
</li>
<li class="nav-item">
<a class="nav-link" href="all-patients.jsp">All Patients</a>
</li>
</ul>
<ul class="navbar-nav ms-auto">
<li class="nav-item dropdown">
<a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
Dr. <%= doctor.getFirstName() + " " + doctor.getLastName() %>
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