// com.pms.controller.RegisterDoctorServlet.java
package com.pms.controller;

import com.pms.dao.DoctorDAO;
import com.pms.dao.UserDAO;
import com.pms.model.Doctor;
import com.pms.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/registerDoctor")
public class RegisterDoctorServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO = new UserDAO();
    private DoctorDAO doctorDAO = new DoctorDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is logged in and is an admin
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null || !currentUser.getUserType().equals("Admin")) {
            response.sendRedirect("index.jsp");
            return;
        }

        // Get form parameters
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String telephone = request.getParameter("telephone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String hospitalName = request.getParameter("hospitalName");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            // Check if username already exists
            if (userDAO.checkUsernameExists(username)) {
                request.setAttribute("errorMessage", "Username already exists");
                request.getRequestDispatcher("views/admin/addDoctor.jsp").forward(request, response);
                return;
            }

            // Create user account first
            User user = new User();
            user.setUsername(username);
            user.setPassword(password);
            user.setUserType("Doctor");

            int userId = userDAO.addUser(user);

            if (userId > 0) {
                // Create doctor record
                Doctor doctor = new Doctor();
                doctor.setUserID(userId);
                doctor.setFirstName(firstName);
                doctor.setLastName(lastName);
                doctor.setTelephone(telephone);
                doctor.setEmail(email);
                doctor.setAddress(address);
                doctor.setHospitalName(hospitalName);

                boolean success = doctorDAO.addDoctor(doctor);

                if (success) {
                    response.sendRedirect("views/admin/doctors.jsp?success=true");
                } else {
                    // If doctor creation fails, delete the user account
                    userDAO.deleteUser(userId);
                    request.setAttribute("errorMessage", "Failed to register doctor");
                    request.getRequestDispatcher("views/admin/addDoctor.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("errorMessage", "Failed to create user account");
                request.getRequestDispatcher("views/admin/addDoctor.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
}