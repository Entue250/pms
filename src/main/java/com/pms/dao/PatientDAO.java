// com.pms.dao.PatientDAO.java
package com.pms.dao;

import com.pms.model.Patient;
import com.pms.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PatientDAO {
    // Add a new patient
    public int addPatient(Patient patient) throws SQLException {
        String sql = "INSERT INTO Patients (UserID, FirstName, LastName, Telephone, Email, Address, PImageLink) VALUES (?, ?, ?, ?, ?, ?, ?)";
        int generatedId = 0;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, patient.getUserID());
            stmt.setString(2, patient.getFirstName());
            stmt.setString(3, patient.getLastName());
            stmt.setString(4, patient.getTelephone());
            stmt.setString(5, patient.getEmail());
            stmt.setString(6, patient.getAddress());
            stmt.setString(7, patient.getImageLink());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        generatedId = rs.getInt(1);
                        patient.setPatientId(generatedId);
                    }
                }
            }
        }
        return generatedId;
    }
    
    // Get patient by ID
    public Patient getPatientById(int patientId) throws SQLException {
        String sql = "SELECT * FROM Patients WHERE PatientID = ?";
        Patient patient = null;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, patientId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    patient = new Patient();
                    patient.setPatientId(rs.getInt("PatientID"));
                    patient.setUserID(rs.getInt("UserID"));
                    patient.setFirstName(rs.getString("FirstName"));
                    patient.setLastName(rs.getString("LastName"));
                    patient.setTelephone(rs.getString("Telephone"));
                    patient.setEmail(rs.getString("Email"));
                    patient.setAddress(rs.getString("Address"));
                    patient.setImageLink(rs.getString("PImageLink"));
                }
            }
        }
        return patient;
    }
    
    // Get patient by user ID
    public Patient getPatientByUserId(int userId) throws SQLException {
        String sql = "SELECT * FROM Patients WHERE UserID = ?";
        Patient patient = null;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    patient = new Patient();
                    patient.setPatientId(rs.getInt("PatientID"));
                    patient.setUserID(rs.getInt("UserID"));
                    patient.setFirstName(rs.getString("FirstName"));
                    patient.setLastName(rs.getString("LastName"));
                    patient.setTelephone(rs.getString("Telephone"));
                    patient.setEmail(rs.getString("Email"));
                    patient.setAddress(rs.getString("Address"));
                    patient.setImageLink(rs.getString("PImageLink"));
                }
            }
        }
        return patient;
    }
    
    // Update patient information
    public boolean updatePatient(Patient patient) throws SQLException {
        String sql = "UPDATE Patients SET FirstName = ?, LastName = ?, Telephone = ?, Email = ?, Address = ?, PImageLink = ? WHERE PatientID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, patient.getFirstName());
            stmt.setString(2, patient.getLastName());
            stmt.setString(3, patient.getTelephone());
            stmt.setString(4, patient.getEmail());
            stmt.setString(5, patient.getAddress());
            stmt.setString(6, patient.getImageLink());
            stmt.setInt(7, patient.getPatientId());
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        }
    }
    
    // Delete a patient
    public boolean deletePatient(int patientId) throws SQLException {
        String sql = "DELETE FROM Patients WHERE PatientID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, patientId);
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        }
    }
    
    // Get all patients
    public List<Patient> getAllPatients() throws SQLException {
        String sql = "SELECT * FROM Patients";
        List<Patient> patients = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Patient patient = new Patient();
                patient.setPatientId(rs.getInt("PatientID"));
                patient.setUserID(rs.getInt("UserID"));
                patient.setFirstName(rs.getString("FirstName"));
                patient.setLastName(rs.getString("LastName"));
                patient.setTelephone(rs.getString("Telephone"));
                patient.setEmail(rs.getString("Email"));
                patient.setAddress(rs.getString("Address"));
                patient.setImageLink(rs.getString("PImageLink"));
                patients.add(patient);
            }
        }
        return patients;
    }
    
    // Get patients by nurse ID - gets patients registered by a specific nurse
    public List<Patient> getPatientsByNurse(int nurseId) throws SQLException {
        String sql = "SELECT p.* FROM Patients p " +
                     "JOIN Diagnosis d ON p.PatientID = d.PatientID " +
                     "WHERE d.NurseID = ? " +
                     "GROUP BY p.PatientID " +
                     "ORDER BY p.PatientID DESC";
        List<Patient> patients = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, nurseId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Patient patient = new Patient();
                    patient.setPatientId(rs.getInt("PatientID"));
                    patient.setUserID(rs.getInt("UserID"));
                    patient.setFirstName(rs.getString("FirstName"));
                    patient.setLastName(rs.getString("LastName"));
                    patient.setTelephone(rs.getString("Telephone"));
                    patient.setEmail(rs.getString("Email"));
                    patient.setAddress(rs.getString("Address"));
                    patient.setImageLink(rs.getString("PImageLink"));
                    patients.add(patient);
                }
            }
        }
        return patients;
    }
    
    // Get patients by hospital name - gets patients registered by nurses from a specific hospital
    public List<Patient> getPatientsByHospital(String hospitalName) throws SQLException {
        String sql = "SELECT DISTINCT p.* FROM Patients p " +
                    "JOIN Diagnosis d ON p.PatientID = d.PatientID " +
                    "JOIN Nurses n ON d.NurseID = n.NurseID " +
                    "WHERE n.HealthCenter = ? " +
                    "ORDER BY p.PatientID DESC";
        List<Patient> patients = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, hospitalName);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Patient patient = new Patient();
                    patient.setPatientId(rs.getInt("PatientID"));
                    patient.setUserID(rs.getInt("UserID"));
                    patient.setFirstName(rs.getString("FirstName"));
                    patient.setLastName(rs.getString("LastName"));
                    patient.setTelephone(rs.getString("Telephone"));
                    patient.setEmail(rs.getString("Email"));
                    patient.setAddress(rs.getString("Address"));
                    patient.setImageLink(rs.getString("PImageLink"));
                    patients.add(patient);
                }
            }
        }
        return patients;
    }
}