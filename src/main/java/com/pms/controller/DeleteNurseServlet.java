package com.pms.controller;

import java.io.IOException;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.pms.dao.NurseDAO;

@WebServlet("/DeleteNurseServlet")
public class DeleteNurseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get parameters from request
        String nurseIdStr = request.getParameter("nurseId");
        
        try {
            int nurseId = Integer.parseInt(nurseIdStr);
            
            // Delete nurse
            NurseDAO nurseDAO = new NurseDAO();
            boolean result = nurseDAO.deleteNurse(nurseId);
            
            if (result) {
                // Success
                response.sendRedirect(request.getContextPath() + "/views/admin/nurses.jsp?deleted=true");
            } else {
                // Failed
                response.sendRedirect(request.getContextPath() + "/views/admin/nurse-detail.jsp?id=" + nurseId + "&error=deleteFailed");
            }
        } catch (NumberFormatException e) {
            // Invalid ID
            response.sendRedirect(request.getContextPath() + "/views/admin/nurses.jsp?error=invalid");
        } catch (SQLException e) {
            // Database error
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/views/admin/nurses.jsp?error=database");
        }
    }
}