<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pms.model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
%>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">PMS Admin</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" href="dashboard.jsp">Dashboard</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="doctors.jsp">Doctors</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="addDoctor.jsp">Register Doctor</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="nurses.jsp">Nurses</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="cases.jsp">All Cases</a>
                </li>
            </ul>
            <ul class="navbar-nav ms-auto">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                        Welcome, <%= currentUser.getUsername() %>
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