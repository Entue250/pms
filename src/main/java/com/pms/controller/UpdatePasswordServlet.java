package com.pms.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.pms.dao.UserDAO;
import com.pms.model.User;

@WebServlet("/updatePassword")
public class UpdatePasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect("index.jsp");
            return;
        }
        
        try {
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");
            
            // Validate passwords
            if (!newPassword.equals(confirmPassword)) {
                session.setAttribute("error", "New passwords do not match");
                response.sendRedirect("views/doctor/profile.jsp");
                return;
            }
            
            UserDAO userDAO = new UserDAO();
            
            // Verify current password (you'll need to implement this method in UserDAO)
            if (!userDAO.verifyPassword(currentUser.getUserID(), currentPassword)) {
                session.setAttribute("error", "Current password is incorrect");
                response.sendRedirect("views/doctor/profile.jsp");
                return;
            }
            
            // Update password
            boolean updated = userDAO.updatePassword(currentUser.getUserID(), newPassword);
            
            if (updated) {
                session.setAttribute("message", "Password updated successfully");
            } else {
                session.setAttribute("error", "Failed to update password");
            }
            
            response.sendRedirect("views/doctor/profile.jsp");
            
        } catch (Exception e) {
            session.setAttribute("error", "Error: " + e.getMessage());
            response.sendRedirect("views/doctor/profile.jsp");
        }
    }
}