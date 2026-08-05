// com.pms.controller.LoginServlet.java
package com.pms.controller;

import com.pms.dao.UserDAO;
import com.pms.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO = new UserDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            User user = userDAO.getUserByLogin(username, password);
            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);

                // Redirect based on user type
                switch (user.getUserType()) {
                    case "Admin":
                        response.sendRedirect("views/admin/dashboard.jsp");
                        break;
                    case "Doctor":
                        response.sendRedirect("views/doctor/dashboard.jsp");
                        break;
                    case "Nurse":
                        response.sendRedirect("views/nurse/dashboard.jsp");
                        break;
                    case "Patient":
                        response.sendRedirect("views/patient/dashboard.jsp");
                        break;
                    default:
                        response.sendRedirect("index.jsp");
                        break;
                }
            } else {
                request.setAttribute("errorMessage", "Invalid username or password");
                request.getRequestDispatcher("index.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
}