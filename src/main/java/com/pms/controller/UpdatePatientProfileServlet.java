package com.pms.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import com.pms.dao.PatientDAO;
import com.pms.model.Patient;
import com.pms.model.User;

import java.io.File;
import java.nio.file.Paths;

@WebServlet("/updatePatientProfile")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 5 * 1024 * 1024,    // 5 MB
    maxRequestSize = 10 * 1024 * 1024 // 10 MB
)
public class UpdatePatientProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Check if user is logged in and is a Nurse, Doctor, or Admin
        if (currentUser == null || 
            (!currentUser.getUserType().equals("Nurse") && 
             !currentUser.getUserType().equals("Doctor") && 
             !currentUser.getUserType().equals("Admin"))) {
            
            if (currentUser != null && currentUser.getUserType().equals("Patient")) {
                session.setAttribute("error", "Unauthorized: Only nurses can update patient profiles");
                response.sendRedirect("views/patient/profile.jsp");
            } else {
                response.sendRedirect("index.jsp");
            }
            return;
        }
        
        try {
            // Get the patient ID from the form
            String patientIdStr = request.getParameter("patientId");
            int patientId = Integer.parseInt(patientIdStr);
            
            // Get form parameters
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String telephone = request.getParameter("telephone");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            
            // First, get the existing patient from the database
            PatientDAO patientDAO = new PatientDAO();
            Patient existingPatient = patientDAO.getPatientById(patientId);
            
            if (existingPatient != null) {
                // Update patient properties
                existingPatient.setFirstName(firstName);
                existingPatient.setLastName(lastName);
                existingPatient.setTelephone(telephone);
                existingPatient.setEmail(email);
                existingPatient.setAddress(address);
                
                // Handle image upload if present
                Part filePart = request.getPart("patientImage");
                if (filePart != null && filePart.getSize() > 0) {
                    String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                    
                    if (!fileName.isEmpty()) {
                        // Create images directory if it doesn't exist
                        String uploadPath = getServletContext().getRealPath("") + File.separator + "images" + File.separator + "patients";
                        File uploadDir = new File(uploadPath);
                        if (!uploadDir.exists()) {
                            uploadDir.mkdirs();
                        }
                        
                        // Create a unique filename
                        String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
                        String filePath = uploadPath + File.separator + uniqueFileName;
                        
                        // Save the file
                        filePart.write(filePath);
                        
                        // Update the patient's image link in database
                        String imageLink = "images/patients/" + uniqueFileName;
                        existingPatient.setImageLink(imageLink);
                    }
                }
                
                // Update in database
                boolean updated = patientDAO.updatePatient(existingPatient);
                
                if (updated) {
                    session.setAttribute("message", "Patient profile updated successfully");
                } else {
                    session.setAttribute("error", "Failed to update patient profile");
                }
                
                // Redirect based on user type
                if (currentUser.getUserType().equals("Nurse")) {
                    response.sendRedirect("views/nurse/patient-detail.jsp?id=" + patientId);
                } else if (currentUser.getUserType().equals("Doctor")) {
                    response.sendRedirect("views/doctor/patient-detail.jsp?id=" + patientId);
                } else {
                    // Admin
                    response.sendRedirect("views/admin/patients.jsp");
                }
            } else {
                session.setAttribute("error", "Patient not found");
                
                if (currentUser.getUserType().equals("Nurse")) {
                    response.sendRedirect("views/nurse/patients.jsp");
                } else if (currentUser.getUserType().equals("Doctor")) {
                    response.sendRedirect("views/doctor/all-patients.jsp");
                } else {
                    // Admin
                    response.sendRedirect("views/admin/patients.jsp");
                }
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid patient ID format");
            
            if (currentUser.getUserType().equals("Nurse")) {
                response.sendRedirect("views/nurse/patients.jsp");
            } else if (currentUser.getUserType().equals("Doctor")) {
                response.sendRedirect("views/doctor/all-patients.jsp");
            } else {
                // Admin
                response.sendRedirect("views/admin/patients.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Error: " + e.getMessage());
            
            if (currentUser.getUserType().equals("Nurse")) {
                response.sendRedirect("views/nurse/patients.jsp");
            } else if (currentUser.getUserType().equals("Doctor")) {
                response.sendRedirect("views/doctor/all-patients.jsp");
            } else {
                // Admin
                response.sendRedirect("views/admin/patients.jsp");
            }
        }
    }
}