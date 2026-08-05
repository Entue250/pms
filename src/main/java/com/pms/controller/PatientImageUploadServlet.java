package com.pms.controller;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.UUID;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import com.pms.dao.PatientDAO;
import com.pms.model.Patient;
import com.pms.model.User;

@WebServlet("/PatientImageUploadServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 10,  // 10 MB
    maxRequestSize = 1024 * 1024 * 15 // 15 MB
)
public class PatientImageUploadServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PatientDAO patientDAO = new PatientDAO();
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        try {
            int patientId = Integer.parseInt(request.getParameter("patientId"));
            
            // Check if this is a patient updating their own profile
            boolean isPatientProfile = false;
            if (currentUser != null && currentUser.getUserType().equals("Patient")) {
                Patient patient = patientDAO.getPatientByUserId(currentUser.getUserID());
                if (patient != null && patient.getPatientId() == patientId) {
                    isPatientProfile = true;
                } else {
                    session.setAttribute("error", "Unauthorized access");
                    response.sendRedirect("views/patient/profile.jsp");
                    return;
                }
            }
            
            // Create the upload directory if it doesn't exist
            String uploadPath = getServletContext().getRealPath("") + File.separator + "images";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }
            
            // Process the uploaded file
            Part filePart = request.getPart("patientImage");
            String fileName = UUID.randomUUID().toString() + getFileName(filePart);
            String filePath = "images" + File.separator + fileName;
            
            // Save the file
            filePart.write(uploadPath + File.separator + fileName);
            
            // Update patient record with image link
            Patient patient = patientDAO.getPatientById(patientId);
            if (patient != null) {
                patient.setImageLink(filePath);
                boolean updated = patientDAO.updatePatient(patient);
                
                if (updated) {
                    session.setAttribute("message", "Photo updated successfully");
                } else {
                    session.setAttribute("error", "Failed to update photo");
                }
                
                // Redirect based on who is updating
                if (isPatientProfile) {
                    response.sendRedirect("views/patient/profile.jsp");
                } else {
                    response.sendRedirect("views/nurse/patients.jsp?success=true");
                }
            } else {
                if (isPatientProfile) {
                    response.sendRedirect("views/patient/profile.jsp?error=true");
                } else {
                    response.sendRedirect("views/nurse/patients.jsp?error=true");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("error", "Database error: " + e.getMessage());
            response.sendRedirect("views/patient/profile.jsp");
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid patient ID");
            response.sendRedirect("views/patient/profile.jsp");
        }
    }
    
    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String item : items) {
            if (item.trim().startsWith("filename")) {
                return item.substring(item.indexOf("=") + 2, item.length() - 1);
            }
        }
        return "";
    }
}