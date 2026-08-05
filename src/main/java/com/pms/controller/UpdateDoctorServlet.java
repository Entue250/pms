package com.pms.controller;

import java.io.IOException;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.pms.dao.DoctorDAO;
import com.pms.model.Doctor;

@WebServlet("/UpdateDoctorServlet")
public class UpdateDoctorServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get parameters from request
        String doctorIdStr = request.getParameter("doctorId");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String telephone = request.getParameter("telephone");
        String address = request.getParameter("address");
        String hospitalName = request.getParameter("hospitalName");
        
        try {
            int doctorId = Integer.parseInt(doctorIdStr);
            
            // Get existing doctor
            DoctorDAO doctorDAO = new DoctorDAO();
            Doctor doctor = doctorDAO.getDoctorById(doctorId);
            
            if (doctor != null) {
                // Update doctor properties with values from the form
                doctor.setFirstName(firstName);
                doctor.setLastName(lastName);
                doctor.setEmail(email);
                doctor.setTelephone(telephone);
                doctor.setAddress(address);
                doctor.setHospitalName(hospitalName);
                
                // Update doctor in database
                boolean result = doctorDAO.updateDoctor(doctor);
                
                if (result) {
                    // Success
                    response.sendRedirect(request.getContextPath() + "/views/admin/doctor-detail.jsp?id=" + doctorId + "&updated=true");
                } else {
                    // Failed
                    response.sendRedirect(request.getContextPath() + "/views/admin/doctor-detail.jsp?id=" + doctorId + "&error=true");
                }
            } else {
                // Doctor not found
                response.sendRedirect(request.getContextPath() + "/views/admin/doctors.jsp?error=notfound");
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