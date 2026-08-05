package com.pms.controller;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.pms.dao.NurseDAO;
import com.pms.model.Nurse;
import com.pms.model.User;

@WebServlet("/updateNurseProfile")
public class UpdateNurseProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect("index.jsp");
            return;
        }
        
        // Only doctors can update nurse profiles
        if (!currentUser.getUserType().equals("Doctor") && !currentUser.getUserType().equals("Admin")) {
            session.setAttribute("error", "Unauthorized: Only doctors and administrators can update nurse profiles");
            
            // Redirect based on user type
            if (currentUser.getUserType().equals("Nurse")) {
                response.sendRedirect("views/nurse/profile.jsp");
            } else {
                response.sendRedirect("index.jsp");
            }
            return;
        }
        
        try {
            // Get the nurse ID from the form
            String nurseIdStr = request.getParameter("nurseId");
            int nurseId = Integer.parseInt(nurseIdStr);
            
            // Get form parameters
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String telephone = request.getParameter("telephone");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            String healthCenter = request.getParameter("healthCenter");
            
            // First, get the existing nurse from the database
            NurseDAO nurseDAO = new NurseDAO();
            Nurse existingNurse = nurseDAO.getNurseById(nurseId);
            
            if (existingNurse != null) {
                // Update nurse properties
                existingNurse.setFirstName(firstName);
                existingNurse.setLastName(lastName);
                existingNurse.setTelephone(telephone);
                existingNurse.setEmail(email);
                existingNurse.setAddress(address);
                existingNurse.setHealthCenter(healthCenter);
                
                // Update in database
                boolean updated = nurseDAO.updateNurse(existingNurse);
                
                if (updated) {
                    session.setAttribute("message", "Nurse profile updated successfully");
                } else {
                    session.setAttribute("error", "Failed to update nurse profile");
                }
            } else {
                session.setAttribute("error", "Nurse not found");
            }
            
            // Redirect to the appropriate page based on user type
            if (currentUser.getUserType().equals("Doctor")) {
                response.sendRedirect("views/doctor/nurse-detail.jsp?id=" + nurseId);
            } else if (currentUser.getUserType().equals("Admin")) {
                response.sendRedirect("views/admin/nurse-detail.jsp?id=" + nurseId);
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid nurse ID format");
            
            if (currentUser.getUserType().equals("Doctor")) {
                response.sendRedirect("views/doctor/nurses.jsp");
            } else if (currentUser.getUserType().equals("Admin")) {
                response.sendRedirect("views/admin/nurses.jsp");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Error: " + e.getMessage());
            
            if (currentUser.getUserType().equals("Doctor")) {
                response.sendRedirect("views/doctor/nurses.jsp");
            } else if (currentUser.getUserType().equals("Admin")) {
                response.sendRedirect("views/admin/nurses.jsp");
            }
        }
    }
}