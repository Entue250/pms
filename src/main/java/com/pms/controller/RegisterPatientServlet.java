// com.pms.controller.RegisterPatientServlet.java
package com.pms.controller;

import com.pms.dao.DiagnosisDAO;
import com.pms.dao.NurseDAO;
import com.pms.dao.PatientDAO;
import com.pms.dao.UserDAO;
import com.pms.model.Diagnosis;
import com.pms.model.Nurse;
import com.pms.model.Patient;
import com.pms.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.UUID;

@WebServlet("/registerPatient")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 10,  // 10 MB
    maxRequestSize = 1024 * 1024 * 15 // 15 MB
)
public class RegisterPatientServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO = new UserDAO();
    private PatientDAO patientDAO = new PatientDAO();
    private DiagnosisDAO diagnosisDAO = new DiagnosisDAO();
    private NurseDAO nurseDAO = new NurseDAO();
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user is logged in and is a nurse
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null || !currentUser.getUserType().equals("Nurse")) {
            response.sendRedirect("index.jsp");
            return;
        }
        
        try {
            // Get nurse information
            Nurse nurse = nurseDAO.getNurseByUserId(currentUser.getUserID());
            
            // Get form parameters
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String telephone = request.getParameter("telephone");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String diagnosisStatus = request.getParameter("diagnosisStatus");
            String result = request.getParameter("result");
            
            // Check if username already exists
            if (userDAO.checkUsernameExists(username)) {
                request.setAttribute("errorMessage", "Username already exists");
                request.getRequestDispatcher("views/nurse/addPatient.jsp").forward(request, response);
                return;
            }
            
            // Create user account first
            User user = new User();
            user.setUsername(username);
            user.setPassword(password);
            user.setUserType("Patient");
            
            int userId = userDAO.addUser(user);
            
            if (userId > 0) {
                // Create patient record
                Patient patient = new Patient();
                patient.setUserID(userId);
                patient.setFirstName(firstName);
                patient.setLastName(lastName);
                patient.setTelephone(telephone);
                patient.setEmail(email);
                patient.setAddress(address);
                
                // Handle image upload
                String imageLink = "";
                Part filePart = request.getPart("patientImage");
                
                if (filePart != null && filePart.getSize() > 0) {
                    // Create the upload directory if it doesn't exist
                    String uploadPath = getServletContext().getRealPath("") + File.separator + "images";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdir();
                    }
                    
                    // Generate unique filename
                    String fileName = UUID.randomUUID().toString() + getFileName(filePart);
                    String filePath = "images" + File.separator + fileName;
                    
                    // Save the file
                    filePart.write(uploadPath + File.separator + fileName);
                    imageLink = filePath;
                }
                
                patient.setImageLink(imageLink);
                int patientId = patientDAO.addPatient(patient);
                
                if (patientId > 0) {
                    // Create diagnosis record
                    Diagnosis diagnosis = new Diagnosis();
                    diagnosis.setPatientId(patientId);
                    diagnosis.setNurseId(nurse.getNurseId());
                    diagnosis.setDiagnoStatus(diagnosisStatus);
                    
                    // Set initial result based on diagnosis status
                    if (diagnosisStatus.equals("Referrable")) {
                        diagnosis.setResult("pending");
                    } else {
                        diagnosis.setResult("Negative");
                        if (result != null && !result.trim().isEmpty()) {
                            diagnosis.setResult(result);
                        }
                    }
                    
                    boolean diagnosisSuccess = diagnosisDAO.addDiagnosis(diagnosis);
                    
                    if (diagnosisSuccess) {
                        response.sendRedirect("views/nurse/patients.jsp?success=true");
                    } else {
                        // Cleanup if diagnosis creation fails
                        patientDAO.deletePatient(patientId);
                        userDAO.deleteUser(userId);
                        request.setAttribute("errorMessage", "Failed to create diagnosis record");
                        request.getRequestDispatcher("views/nurse/addPatient.jsp").forward(request, response);
                    }
                } else {
                    // Cleanup if patient creation fails
                    userDAO.deleteUser(userId);
                    request.setAttribute("errorMessage", "Failed to register patient");
                    request.getRequestDispatcher("views/nurse/addPatient.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("errorMessage", "Failed to create user account");
                request.getRequestDispatcher("views/nurse/addPatient.jsp").forward(request, response);
            }
            
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
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