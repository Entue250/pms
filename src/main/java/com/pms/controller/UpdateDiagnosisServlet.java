package com.pms.controller;
import com.pms.dao.DiagnosisDAO;
import com.pms.model.Diagnosis;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/updateDiagnosis")
public class UpdateDiagnosisServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DiagnosisDAO diagnosisDAO = new DiagnosisDAO();
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        int diagnosisId = Integer.parseInt(request.getParameter("diagnosisId"));
        String result = request.getParameter("result");
        
        // Check if this is a nurse update (non-referrable case)
        boolean isNonReferrable = request.getParameter("isNonReferrable") != null ? 
                Boolean.parseBoolean(request.getParameter("isNonReferrable")) : false;
                
        try {
            // Get the diagnosis record
            Diagnosis diagnosis = diagnosisDAO.getDiagnosisById(diagnosisId);
            if (diagnosis != null) {
                // For doctor updates, set doctorId
                if (!isNonReferrable && request.getParameter("doctorId") != null) {
                    int doctorId = Integer.parseInt(request.getParameter("doctorId"));
                    diagnosis.setDoctorId(doctorId);
                }
                
                // Update the result
                diagnosis.setResult(result);
                
                boolean updated = diagnosisDAO.updateDiagnosis(diagnosis);
                
                if (updated) {
                    session.setAttribute("message", "Diagnosis result updated successfully");
                } else {
                    session.setAttribute("error", "Failed to update diagnosis result");
                }
                
                // Redirect based on user role and case type
                if (isNonReferrable) {
                    // This is a nurse updating a non-referrable case
                    response.sendRedirect("views/nurse/nonreferrable-cases.jsp");
                } else {
                    // This is a doctor updating a case
                    response.sendRedirect("views/doctor/cases.jsp");
                }
            } else {
                session.setAttribute("error", "Diagnosis not found");
                response.sendRedirect("views/nurse/dashboard.jsp");
            }
        } catch (SQLException e) {
            session.setAttribute("error", "Database error: " + e.getMessage());
            response.sendRedirect("views/nurse/dashboard.jsp");
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid ID format");
            response.sendRedirect("views/nurse/dashboard.jsp");
        } catch (Exception e) {
            session.setAttribute("error", "Error: " + e.getMessage());
            response.sendRedirect("views/nurse/dashboard.jsp");
        }
    }
}