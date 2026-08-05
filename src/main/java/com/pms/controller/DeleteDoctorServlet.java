package com.pms.controller;

import java.io.IOException;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.pms.dao.DoctorDAO;

@WebServlet("/DeleteDoctorServlet")
public class DeleteDoctorServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get parameters from request
        String doctorIdStr = request.getParameter("doctorId");
        
        try {
            int doctorId = Integer.parseInt(doctorIdStr);
            
            // Delete doctor
            DoctorDAO doctorDAO = new DoctorDAO();
            boolean result = doctorDAO.deleteDoctor(doctorId);
            
            if (result) {
                // Success
                response.sendRedirect(request.getContextPath() + "/views/admin/doctors.jsp?deleted=true");
            } else {
                // Failed
                response.sendRedirect(request.getContextPath() + "/views/admin/doctor-detail.jsp?id=" + doctorId + "&error=deleteFailed");
            }
        } catch (NumberFormatException e) {
            // Invalid ID
            response.sendRedirect(request.getContextPath() + "/views/admin/doctors.jsp?error=invalid");
        } catch (SQLException e) {
            // Database error
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/views/admin/doctors.jsp?error=database");
        }
    }
}