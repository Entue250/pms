package com.pms.controller;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.pms.dao.DoctorDAO;
import com.pms.model.Doctor;
import com.pms.model.User;

@WebServlet("/updateDoctorProfile")
public class UpdateDoctorProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect("index.jsp");
            return;
        }
        
        // Only administrators can update doctor profiles
        if (!currentUser.getUserType().equals("Admin")) {
            session.setAttribute("error", "Unauthorized: Only administrators can update doctor profiles");
            
            // Redirect based on user type
            if (currentUser.getUserType().equals("Doctor")) {
                response.sendRedirect("views/doctor/profile.jsp");
            } else {
                response.sendRedirect("index.jsp");
            }
            return;
        }
        
        try {
            // Get the doctor ID from the form
            String doctorIdStr = request.getParameter("doctorId");
            int doctorId = Integer.parseInt(doctorIdStr);
            
            // Get form parameters
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String telephone = request.getParameter("telephone");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            String hospitalName = request.getParameter("hospitalName");
            
            // First, get the existing doctor from the database
            DoctorDAO doctorDAO = new DoctorDAO();
            Doctor existingDoctor = doctorDAO.getDoctorById(doctorId);
            
            if (existingDoctor != null) {
                // Update doctor properties
                existingDoctor.setFirstName(firstName);
                existingDoctor.setLastName(lastName);
                existingDoctor.setTelephone(telephone);
                existingDoctor.setEmail(email);
                existingDoctor.setAddress(address);
                existingDoctor.setHospitalName(hospitalName);
                
                // Update in database
                boolean updated = doctorDAO.updateDoctor(existingDoctor);
                
                if (updated) {
                    session.setAttribute("message", "Doctor profile updated successfully");
                } else {
                    session.setAttribute("error", "Failed to update doctor profile");
                }
            } else {
                session.setAttribute("error", "Doctor not found");
            }
            
            // Redirect to the admin's doctor detail page
            response.sendRedirect("views/admin/doctor-detail.jsp?id=" + doctorId);
            
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid doctor ID format");
            response.sendRedirect("views/admin/doctors.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Error: " + e.getMessage());
            response.sendRedirect("views/admin/doctors.jsp");
        }
    }
}