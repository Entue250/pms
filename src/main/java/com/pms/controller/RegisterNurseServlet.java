// com.pms.controller.RegisterNurseServlet.java
package com.pms.controller;

import com.pms.dao.NurseDAO;
import com.pms.dao.UserDAO;
import com.pms.model.Doctor;
import com.pms.model.Nurse;
import com.pms.model.User;
import com.pms.dao.DoctorDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/registerNurse")
public class RegisterNurseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO = new UserDAO();
    private NurseDAO nurseDAO = new NurseDAO();
    private DoctorDAO doctorDAO = new DoctorDAO();
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user is logged in and is a doctor
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null || !currentUser.getUserType().equals("Doctor")) {
            response.sendRedirect("index.jsp");
            return;
        }
        
        // Get doctor information to associate with health center
        try {
            Doctor doctor = doctorDAO.getDoctorByUserId(currentUser.getUserID());
            
            // Get form parameters
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String telephone = request.getParameter("telephone");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            String healthCenter = request.getParameter("healthCenter");
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            
            // If no health center is specified, use doctor's hospital
            if (healthCenter == null || healthCenter.trim().isEmpty()) {
                healthCenter = doctor.getHospitalName();
            }
            
            // Check if username already exists
            if (userDAO.checkUsernameExists(username)) {
                request.setAttribute("errorMessage", "Username already exists");
                request.getRequestDispatcher("views/doctor/addNurse.jsp").forward(request, response);
                return;
            }
            
            // Create user account first
            User user = new User();
            user.setUsername(username);
            user.setPassword(password);
            user.setUserType("Nurse");
            
            int userId = userDAO.addUser(user);
            
            if (userId > 0) {
                // Create nurse record
                Nurse nurse = new Nurse();
                nurse.setUserID(userId);
                nurse.setFirstName(firstName);
                nurse.setLastName(lastName);
                nurse.setTelephone(telephone);
                nurse.setEmail(email);
                nurse.setAddress(address);
                nurse.setHealthCenter(healthCenter);
                
                boolean success = nurseDAO.addNurse(nurse);
                
                if (success) {
                    response.sendRedirect("views/doctor/nurses.jsp?success=true");
                } else {
                    // If nurse creation fails, delete the user account
                    userDAO.deleteUser(userId);
                    request.setAttribute("errorMessage", "Failed to register nurse");
                    request.getRequestDispatcher("views/doctor/addNurse.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("errorMessage", "Failed to create user account");
                request.getRequestDispatcher("views/doctor/addNurse.jsp").forward(request, response);
            }
            
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
}