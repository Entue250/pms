package com.pms.controller;

import java.io.IOException;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.pms.dao.NurseDAO;
import com.pms.model.Nurse;

@WebServlet("/UpdateNurseServlet")
public class UpdateNurseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get parameters from request
        String nurseIdStr = request.getParameter("nurseId");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String telephone = request.getParameter("telephone");
        String address = request.getParameter("address");
        String healthCenter = request.getParameter("healthCenter");
        String redirectTo = request.getParameter("redirectTo"); // New parameter to determine where to redirect
        
        try {
            int nurseId = Integer.parseInt(nurseIdStr);
            
            // Get existing nurse
            NurseDAO nurseDAO = new NurseDAO();
            Nurse nurse = nurseDAO.getNurseById(nurseId);
            
            if (nurse != null) {
                // Update nurse properties with values from the form
                nurse.setFirstName(firstName);
                nurse.setLastName(lastName);
                nurse.setEmail(email);
                nurse.setTelephone(telephone);
                nurse.setAddress(address);
                nurse.setHealthCenter(healthCenter);
                
                // Update nurse in database
                boolean result = nurseDAO.updateNurse(nurse);
                
                if (result) {
                    // Success - redirect based on redirectTo parameter
                    if ("doctor".equals(redirectTo)) {
                        response.sendRedirect(request.getContextPath() + "/views/doctor/nurse-detail.jsp?id=" + nurseId + "&updated=true");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/views/admin/nurse-detail.jsp?id=" + nurseId + "&updated=true");
                    }
                } else {
                    // Failed - redirect based on redirectTo parameter
                    if ("doctor".equals(redirectTo)) {
                        response.sendRedirect(request.getContextPath() + "/views/doctor/nurse-detail.jsp?id=" + nurseId + "&error=true");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/views/admin/nurse-detail.jsp?id=" + nurseId + "&error=true");
                    }
                }
            } else {
                // Nurse not found - redirect based on redirectTo parameter
                if ("doctor".equals(redirectTo)) {
                    response.sendRedirect(request.getContextPath() + "/views/doctor/nurses.jsp?error=notfound");
                } else {
                    response.sendRedirect(request.getContextPath() + "/views/admin/nurses.jsp?error=notfound");
                }
            }
        } catch (NumberFormatException e) {
            // Invalid ID - redirect based on redirectTo parameter
            if ("doctor".equals(redirectTo)) {
                response.sendRedirect(request.getContextPath() + "/views/doctor/nurses.jsp?error=invalid");
            } else {
                response.sendRedirect(request.getContextPath() + "/views/admin/nurses.jsp?error=invalid");
            }
        } catch (SQLException e) {
            // Database error - redirect based on redirectTo parameter
            e.printStackTrace();
            if ("doctor".equals(redirectTo)) {
                response.sendRedirect(request.getContextPath() + "/views/doctor/nurses.jsp?error=database");
            } else {
                response.sendRedirect(request.getContextPath() + "/views/admin/nurses.jsp?error=database");
            }
        }
    }
}