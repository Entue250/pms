// com.pms.dao.DoctorDAO.java
package com.pms.dao;

import com.pms.model.Doctor;
import com.pms.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DoctorDAO {
    // Add a new doctor
    public boolean addDoctor(Doctor doctor) throws SQLException {
        String sql = "INSERT INTO Doctors (UserID, FirstName, LastName, Telephone, Email, Address, HospitalName) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, doctor.getUserID());
            stmt.setString(2, doctor.getFirstName());
            stmt.setString(3, doctor.getLastName());
            stmt.setString(4, doctor.getTelephone());
            stmt.setString(5, doctor.getEmail());
            stmt.setString(6, doctor.getAddress());
            stmt.setString(7, doctor.getHospitalName());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        doctor.setDoctorId(rs.getInt(1));
                        return true;
                    }
                }
            }
            return false;
        }
    }
    
    // Get doctor by ID
    public Doctor getDoctorById(int doctorId) throws SQLException {
        String sql = "SELECT * FROM Doctors WHERE DoctorID = ?";
        Doctor doctor = null;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, doctorId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    doctor = new Doctor();
                    doctor.setDoctorId(rs.getInt("DoctorID"));
                    doctor.setUserID(rs.getInt("UserID"));
                    doctor.setFirstName(rs.getString("FirstName"));
                    doctor.setLastName(rs.getString("LastName"));
                    doctor.setTelephone(rs.getString("Telephone"));
                    doctor.setEmail(rs.getString("Email"));
                    doctor.setAddress(rs.getString("Address"));
                    doctor.setHospitalName(rs.getString("HospitalName"));
                }
            }
        }
        return doctor;
    }
    
    // Get doctor by user ID
    public Doctor getDoctorByUserId(int userId) throws SQLException {
        String sql = "SELECT * FROM Doctors WHERE UserID = ?";
        Doctor doctor = null;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    doctor = new Doctor();
                    doctor.setDoctorId(rs.getInt("DoctorID"));
                    doctor.setUserID(rs.getInt("UserID"));
                    doctor.setFirstName(rs.getString("FirstName"));
                    doctor.setLastName(rs.getString("LastName"));
                    doctor.setTelephone(rs.getString("Telephone"));
                    doctor.setEmail(rs.getString("Email"));
                    doctor.setAddress(rs.getString("Address"));
                    doctor.setHospitalName(rs.getString("HospitalName"));
                }
            }
        }
        return doctor;
    }
    
    // Update doctor information
    public boolean updateDoctor(Doctor doctor) throws SQLException {
        String sql = "UPDATE Doctors SET FirstName = ?, LastName = ?, Telephone = ?, Email = ?, Address = ?, HospitalName = ? WHERE DoctorID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, doctor.getFirstName());
            stmt.setString(2, doctor.getLastName());
            stmt.setString(3, doctor.getTelephone());
            stmt.setString(4, doctor.getEmail());
            stmt.setString(5, doctor.getAddress());
            stmt.setString(6, doctor.getHospitalName());
            stmt.setInt(7, doctor.getDoctorId());
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        }
    }
    
    // Delete a doctor
    public boolean deleteDoctor(int doctorId) throws SQLException {
        String sql = "DELETE FROM Doctors WHERE DoctorID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, doctorId);
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        }
    }
    
    // Get all doctors
    public List<Doctor> getAllDoctors() throws SQLException {
        String sql = "SELECT * FROM Doctors";
        List<Doctor> doctors = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Doctor doctor = new Doctor();
                doctor.setDoctorId(rs.getInt("DoctorID"));
                doctor.setUserID(rs.getInt("UserID"));
                doctor.setFirstName(rs.getString("FirstName"));
                doctor.setLastName(rs.getString("LastName"));
                doctor.setTelephone(rs.getString("Telephone"));
                doctor.setEmail(rs.getString("Email"));
                doctor.setAddress(rs.getString("Address"));
                doctor.setHospitalName(rs.getString("HospitalName"));
                doctors.add(doctor);
            }
        }
        return doctors;
    }
    
    // Get doctors by hospital name
    public List<Doctor> getDoctorsByHospital(String hospitalName) throws SQLException {
        String sql = "SELECT * FROM Doctors WHERE HospitalName = ?";
        List<Doctor> doctors = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, hospitalName);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Doctor doctor = new Doctor();
                    doctor.setDoctorId(rs.getInt("DoctorID"));
                    doctor.setUserID(rs.getInt("UserID"));
                    doctor.setFirstName(rs.getString("FirstName"));
                    doctor.setLastName(rs.getString("LastName"));
                    doctor.setTelephone(rs.getString("Telephone"));
                    doctor.setEmail(rs.getString("Email"));
                    doctor.setAddress(rs.getString("Address"));
                    doctor.setHospitalName(rs.getString("HospitalName"));
                    doctors.add(doctor);
                }
            }
        }
        return doctors;
    }
}