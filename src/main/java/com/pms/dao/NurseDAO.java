// com.pms.dao.NurseDAO.java
package com.pms.dao;

import com.pms.model.Nurse;
import com.pms.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NurseDAO {
    // Add a new nurse
    public boolean addNurse(Nurse nurse) throws SQLException {
        String sql = "INSERT INTO Nurses (UserID, FirstName, LastName, Telephone, Email, Address, HealthCenter) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, nurse.getUserID());
            stmt.setString(2, nurse.getFirstName());
            stmt.setString(3, nurse.getLastName());
            stmt.setString(4, nurse.getTelephone());
            stmt.setString(5, nurse.getEmail());
            stmt.setString(6, nurse.getAddress());
            stmt.setString(7, nurse.getHealthCenter());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        nurse.setNurseId(rs.getInt(1));
                        return true;
                    }
                }
            }
            return false;
        }
    }
    
    // Get nurse by ID
    public Nurse getNurseById(int nurseId) throws SQLException {
        String sql = "SELECT * FROM Nurses WHERE NurseID = ?";
        Nurse nurse = null;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, nurseId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    nurse = new Nurse();
                    nurse.setNurseId(rs.getInt("NurseID"));
                    nurse.setUserID(rs.getInt("UserID"));
                    nurse.setFirstName(rs.getString("FirstName"));
                    nurse.setLastName(rs.getString("LastName"));
                    nurse.setTelephone(rs.getString("Telephone"));
                    nurse.setEmail(rs.getString("Email"));
                    nurse.setAddress(rs.getString("Address"));
                    nurse.setHealthCenter(rs.getString("HealthCenter"));
                }
            }
        }
        return nurse;
    }
    
    // Get nurse by user ID
    public Nurse getNurseByUserId(int userId) throws SQLException {
        String sql = "SELECT * FROM Nurses WHERE UserID = ?";
        Nurse nurse = null;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    nurse = new Nurse();
                    nurse.setNurseId(rs.getInt("NurseID"));
                    nurse.setUserID(rs.getInt("UserID"));
                    nurse.setFirstName(rs.getString("FirstName"));
                    nurse.setLastName(rs.getString("LastName"));
                    nurse.setTelephone(rs.getString("Telephone"));
                    nurse.setEmail(rs.getString("Email"));
                    nurse.setAddress(rs.getString("Address"));
                    nurse.setHealthCenter(rs.getString("HealthCenter"));
                }
            }
        }
        return nurse;
    }
    
    // Update nurse information
    public boolean updateNurse(Nurse nurse) throws SQLException {
        String sql = "UPDATE Nurses SET FirstName = ?, LastName = ?, Telephone = ?, Email = ?, Address = ?, HealthCenter = ? WHERE NurseID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, nurse.getFirstName());
            stmt.setString(2, nurse.getLastName());
            stmt.setString(3, nurse.getTelephone());
            stmt.setString(4, nurse.getEmail());
            stmt.setString(5, nurse.getAddress());
            stmt.setString(6, nurse.getHealthCenter());
            stmt.setInt(7, nurse.getNurseId());
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        }
    }
    
    // Delete a nurse
    public boolean deleteNurse(int nurseId) throws SQLException {
        String sql = "DELETE FROM Nurses WHERE NurseID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, nurseId);
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        }
    }
    
    // Get all nurses
    public List<Nurse> getAllNurses() throws SQLException {
        String sql = "SELECT * FROM Nurses";
        List<Nurse> nurses = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Nurse nurse = new Nurse();
                nurse.setNurseId(rs.getInt("NurseID"));
                nurse.setUserID(rs.getInt("UserID"));
                nurse.setFirstName(rs.getString("FirstName"));
                nurse.setLastName(rs.getString("LastName"));
                nurse.setTelephone(rs.getString("Telephone"));
                nurse.setEmail(rs.getString("Email"));
                nurse.setAddress(rs.getString("Address"));
                nurse.setHealthCenter(rs.getString("HealthCenter"));
                nurses.add(nurse);
            }
        }
        return nurses;
    }
    
    // Get nurses by health center
    public List<Nurse> getNursesByHealthCenter(String healthCenter) throws SQLException {
        String sql = "SELECT * FROM Nurses WHERE HealthCenter = ?";
        List<Nurse> nurses = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, healthCenter);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Nurse nurse = new Nurse();
                    nurse.setNurseId(rs.getInt("NurseID"));
                    nurse.setUserID(rs.getInt("UserID"));
                    nurse.setFirstName(rs.getString("FirstName"));
                    nurse.setLastName(rs.getString("LastName"));
                    nurse.setTelephone(rs.getString("Telephone"));
                    nurse.setEmail(rs.getString("Email"));
                    nurse.setAddress(rs.getString("Address"));
                    nurse.setHealthCenter(rs.getString("HealthCenter"));
                    nurses.add(nurse);
                }
            }
        }
        return nurses;
    }
}