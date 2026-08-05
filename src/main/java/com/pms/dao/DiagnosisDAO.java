package com.pms.dao;

import com.pms.model.Diagnosis;
import com.pms.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DiagnosisDAO {
    // Add a new diagnosis
    public boolean addDiagnosis(Diagnosis diagnosis) throws SQLException {
        String sql = "INSERT INTO Diagnosis (PatientID, NurseID, DoctorID, DiagnoStatus, Result) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, diagnosis.getPatientId());
            stmt.setInt(2, diagnosis.getNurseId());
            
            if (diagnosis.getDoctorId() != null) {
                stmt.setInt(3, diagnosis.getDoctorId());
            } else {
                stmt.setNull(3, Types.INTEGER);
            }
            
            stmt.setString(4, diagnosis.getDiagnoStatus());
            stmt.setString(5, diagnosis.getResult());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        diagnosis.setDiagnosisId(rs.getInt(1));
                        return true;
                    }
                }
            }
            return false;
        }
    }
    
    // Get diagnosis by ID
    public Diagnosis getDiagnosisById(int diagnosisId) throws SQLException {
        String sql = "SELECT d.*, " +
                     "CONCAT(p.FirstName, ' ', p.LastName) AS PatientName, " +
                     "CONCAT(n.FirstName, ' ', n.LastName) AS NurseName, " +
                     "CONCAT(doc.FirstName, ' ', doc.LastName) AS DoctorName " +
                     "FROM Diagnosis d " +
                     "JOIN Patients p ON d.PatientID = p.PatientID " +
                     "JOIN Nurses n ON d.NurseID = n.NurseID " +
                     "LEFT JOIN Doctors doc ON d.DoctorID = doc.DoctorID " +
                     "WHERE d.DiagnosisID = ?";
        Diagnosis diagnosis = null;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, diagnosisId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    diagnosis = new Diagnosis();
                    diagnosis.setDiagnosisId(rs.getInt("DiagnosisID"));
                    diagnosis.setPatientId(rs.getInt("PatientID"));
                    diagnosis.setNurseId(rs.getInt("NurseID"));
                    
                    Integer doctorId = rs.getInt("DoctorID");
                    if (!rs.wasNull()) {
                        diagnosis.setDoctorId(doctorId);
                    }
                    
                    diagnosis.setDiagnoStatus(rs.getString("DiagnoStatus"));
                    diagnosis.setResult(rs.getString("Result"));
                    diagnosis.setDiagnosisDate(rs.getTimestamp("DiagnosisDate"));
                    
                    // Additional display fields
                    diagnosis.setPatientName(rs.getString("PatientName"));
                    diagnosis.setNurseName(rs.getString("NurseName"));
                    diagnosis.setDoctorName(rs.getString("DoctorName"));
                }
            }
        }
        return diagnosis;
    }
    
    // Update diagnosis information
    public boolean updateDiagnosis(Diagnosis diagnosis) throws SQLException {
        String sql = "UPDATE Diagnosis SET DoctorID = ?, DiagnoStatus = ?, Result = ? WHERE DiagnosisID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            if (diagnosis.getDoctorId() != null) {
                stmt.setInt(1, diagnosis.getDoctorId());
            } else {
                stmt.setNull(1, Types.INTEGER);
            }
            
            stmt.setString(2, diagnosis.getDiagnoStatus());
            stmt.setString(3, diagnosis.getResult());
            stmt.setInt(4, diagnosis.getDiagnosisId());
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        }
    }
    
    // Delete a diagnosis
    public boolean deleteDiagnosis(int diagnosisId) throws SQLException {
        String sql = "DELETE FROM Diagnosis WHERE DiagnosisID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, diagnosisId);
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        }
    }
    
    // Get all diagnoses
    public List<Diagnosis> getAllDiagnoses() throws SQLException {
        String sql = "SELECT d.*, " +
                     "CONCAT(p.FirstName, ' ', p.LastName) AS PatientName, " +
                     "CONCAT(n.FirstName, ' ', n.LastName) AS NurseName, " +
                     "CONCAT(doc.FirstName, ' ', doc.LastName) AS DoctorName " +
                     "FROM Diagnosis d " +
                     "JOIN Patients p ON d.PatientID = p.PatientID " +
                     "JOIN Nurses n ON d.NurseID = n.NurseID " +
                     "LEFT JOIN Doctors doc ON d.DoctorID = doc.DoctorID " +
                     "ORDER BY d.DiagnosisDate DESC";
        List<Diagnosis> diagnoses = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Diagnosis diagnosis = new Diagnosis();
                diagnosis.setDiagnosisId(rs.getInt("DiagnosisID"));
                diagnosis.setPatientId(rs.getInt("PatientID"));
                diagnosis.setNurseId(rs.getInt("NurseID"));
                
                int doctorId = rs.getInt("DoctorID");
                if (!rs.wasNull()) {
                    diagnosis.setDoctorId(doctorId);
                }
                
                diagnosis.setDiagnoStatus(rs.getString("DiagnoStatus"));
                diagnosis.setResult(rs.getString("Result"));
                diagnosis.setDiagnosisDate(rs.getTimestamp("DiagnosisDate"));
                
                // Additional display fields
                diagnosis.setPatientName(rs.getString("PatientName"));
                diagnosis.setNurseName(rs.getString("NurseName"));
                diagnosis.setDoctorName(rs.getString("DoctorName"));
                
                diagnoses.add(diagnosis);
            }
        }
        return diagnoses;
    }
    
    // Get all pending cases (referrable with null or 'pending' result)
    public List<Diagnosis> getAllPendingCases() throws SQLException {
        String sql = "SELECT d.*, " +
                     "CONCAT(p.FirstName, ' ', p.LastName) AS PatientName, " +
                     "CONCAT(n.FirstName, ' ', n.LastName) AS NurseName, " +
                     "CONCAT(doc.FirstName, ' ', doc.LastName) AS DoctorName " +
                     "FROM Diagnosis d " +
                     "JOIN Patients p ON d.PatientID = p.PatientID " +
                     "JOIN Nurses n ON d.NurseID = n.NurseID " +
                     "LEFT JOIN Doctors doc ON d.DoctorID = doc.DoctorID " +
                     "WHERE d.DiagnoStatus = 'Referrable' " +
                     "AND (d.Result IS NULL OR d.Result = 'pending') " +
                     "ORDER BY d.DiagnosisDate DESC";
        List<Diagnosis> diagnoses = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Diagnosis diagnosis = new Diagnosis();
                diagnosis.setDiagnosisId(rs.getInt("DiagnosisID"));
                diagnosis.setPatientId(rs.getInt("PatientID"));
                diagnosis.setNurseId(rs.getInt("NurseID"));
                
                int doctorId = rs.getInt("DoctorID");
                if (!rs.wasNull()) {
                    diagnosis.setDoctorId(doctorId);
                }
                
                diagnosis.setDiagnoStatus(rs.getString("DiagnoStatus"));
                diagnosis.setResult(rs.getString("Result"));
                diagnosis.setDiagnosisDate(rs.getTimestamp("DiagnosisDate"));
                
                // Additional display fields
                diagnosis.setPatientName(rs.getString("PatientName"));
                diagnosis.setNurseName(rs.getString("NurseName"));
                diagnosis.setDoctorName(rs.getString("DoctorName"));
                
                diagnoses.add(diagnosis);
            }
        }
        return diagnoses;
    }
    
    // Get diagnoses by patient ID
    public List<Diagnosis> getDiagnosesByPatientId(int patientId) throws SQLException {
        String sql = "SELECT d.*, " +
                     "CONCAT(p.FirstName, ' ', p.LastName) AS PatientName, " +
                     "CONCAT(n.FirstName, ' ', n.LastName) AS NurseName, " +
                     "CONCAT(doc.FirstName, ' ', doc.LastName) AS DoctorName " +
                     "FROM Diagnosis d " +
                     "JOIN Patients p ON d.PatientID = p.PatientID " +
                     "JOIN Nurses n ON d.NurseID = n.NurseID " +
                     "LEFT JOIN Doctors doc ON d.DoctorID = doc.DoctorID " +
                     "WHERE d.PatientID = ? " +
                     "ORDER BY d.DiagnosisDate DESC";
        List<Diagnosis> diagnoses = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, patientId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Diagnosis diagnosis = new Diagnosis();
                    diagnosis.setDiagnosisId(rs.getInt("DiagnosisID"));
                    diagnosis.setPatientId(rs.getInt("PatientID"));
                    diagnosis.setNurseId(rs.getInt("NurseID"));
                    
                    int doctorId = rs.getInt("DoctorID");
                    if (!rs.wasNull()) {
                        diagnosis.setDoctorId(doctorId);
                    }
                    
                    diagnosis.setDiagnoStatus(rs.getString("DiagnoStatus"));
                    diagnosis.setResult(rs.getString("Result"));
                    diagnosis.setDiagnosisDate(rs.getTimestamp("DiagnosisDate"));
                    
                    // Additional display fields
                    diagnosis.setPatientName(rs.getString("PatientName"));
                    diagnosis.setNurseName(rs.getString("NurseName"));
                    diagnosis.setDoctorName(rs.getString("DoctorName"));
                    
                    diagnoses.add(diagnosis);
                }
            }
        }
        return diagnoses;
    }
    
    // Get referrable cases for a specific hospital
    public List<Diagnosis> getReferrableCasesByHospital(String hospitalName) throws SQLException {
        String sql = "SELECT d.*, " +
                     "CONCAT(p.FirstName, ' ', p.LastName) AS PatientName, " +
                     "CONCAT(n.FirstName, ' ', n.LastName) AS NurseName, " +
                     "CONCAT(doc.FirstName, ' ', doc.LastName) AS DoctorName " +
                     "FROM Diagnosis d " +
                     "JOIN Patients p ON d.PatientID = p.PatientID " +
                     "JOIN Nurses n ON d.NurseID = n.NurseID " +
                     "LEFT JOIN Doctors doc ON d.DoctorID = doc.DoctorID " +
                     "WHERE d.DiagnoStatus = 'Referrable' " +
                     "AND (d.Result IS NULL OR d.Result = 'pending') " +
                     "AND n.HealthCenter = ? " +
                     "ORDER BY d.DiagnosisDate DESC";
        List<Diagnosis> diagnoses = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, hospitalName);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Diagnosis diagnosis = new Diagnosis();
                    diagnosis.setDiagnosisId(rs.getInt("DiagnosisID"));
                    diagnosis.setPatientId(rs.getInt("PatientID"));
                    diagnosis.setNurseId(rs.getInt("NurseID"));
                    
                    int doctorId = rs.getInt("DoctorID");
                    if (!rs.wasNull()) {
                        diagnosis.setDoctorId(doctorId);
                    }
                    
                    diagnosis.setDiagnoStatus(rs.getString("DiagnoStatus"));
                    diagnosis.setResult(rs.getString("Result"));
                    diagnosis.setDiagnosisDate(rs.getTimestamp("DiagnosisDate"));
                    
                    // Additional display fields
                    diagnosis.setPatientName(rs.getString("PatientName"));
                    diagnosis.setNurseName(rs.getString("NurseName"));
                    diagnosis.setDoctorName(rs.getString("DoctorName"));
                    
                    diagnoses.add(diagnosis);
                }
            }
        }
        return diagnoses;
    }
    
    // Get confirmed cases by doctor ID
    public List<Diagnosis> getConfirmedCasesByDoctor(int doctorId) throws SQLException {
        String sql = "SELECT d.*, " +
                     "CONCAT(p.FirstName, ' ', p.LastName) AS PatientName, " +
                     "CONCAT(n.FirstName, ' ', n.LastName) AS NurseName, " +
                     "CONCAT(doc.FirstName, ' ', doc.LastName) AS DoctorName " +
                     "FROM Diagnosis d " +
                     "JOIN Patients p ON d.PatientID = p.PatientID " +
                     "JOIN Nurses n ON d.NurseID = n.NurseID " +
                     "JOIN Doctors doc ON d.DoctorID = doc.DoctorID " +
                     "WHERE d.DoctorID = ? " +
                     "AND d.DiagnoStatus = 'Referrable' " +
                     "AND d.Result IS NOT NULL " +
                     "AND d.Result != 'pending' " +
                     "ORDER BY d.DiagnosisDate DESC";
        List<Diagnosis> diagnoses = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, doctorId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Diagnosis diagnosis = new Diagnosis();
                    diagnosis.setDiagnosisId(rs.getInt("DiagnosisID"));
                    diagnosis.setPatientId(rs.getInt("PatientID"));
                    diagnosis.setNurseId(rs.getInt("NurseID"));
                    diagnosis.setDoctorId(rs.getInt("DoctorID"));
                    diagnosis.setDiagnoStatus(rs.getString("DiagnoStatus"));
                    diagnosis.setResult(rs.getString("Result"));
                    diagnosis.setDiagnosisDate(rs.getTimestamp("DiagnosisDate"));
                    
                    // Additional display fields
                    diagnosis.setPatientName(rs.getString("PatientName"));
                    diagnosis.setNurseName(rs.getString("NurseName"));
                    diagnosis.setDoctorName(rs.getString("DoctorName"));
                    
                    diagnoses.add(diagnosis);
                }
            }
        }
        return diagnoses;
    }
    
    // Get diagnoses by nurse ID
    public List<Diagnosis> getDiagnosesByNurseId(int nurseId) throws SQLException {
        String sql = "SELECT d.*, " +
                     "CONCAT(p.FirstName, ' ', p.LastName) AS PatientName, " +
                     "CONCAT(n.FirstName, ' ', n.LastName) AS NurseName, " +
                     "CONCAT(doc.FirstName, ' ', doc.LastName) AS DoctorName " +
                     "FROM Diagnosis d " +
                     "JOIN Patients p ON d.PatientID = p.PatientID " +
                     "JOIN Nurses n ON d.NurseID = n.NurseID " +
                     "LEFT JOIN Doctors doc ON d.DoctorID = doc.DoctorID " +
                     "WHERE d.NurseID = ? " +
                     "ORDER BY d.DiagnosisDate DESC";
        List<Diagnosis> diagnoses = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, nurseId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Diagnosis diagnosis = new Diagnosis();
                    diagnosis.setDiagnosisId(rs.getInt("DiagnosisID"));
                    diagnosis.setPatientId(rs.getInt("PatientID"));
                    diagnosis.setNurseId(rs.getInt("NurseID"));
                    
                    int doctorId = rs.getInt("DoctorID");
                    if (!rs.wasNull()) {
                        diagnosis.setDoctorId(doctorId);
                    }
                    
                    diagnosis.setDiagnoStatus(rs.getString("DiagnoStatus"));
                    diagnosis.setResult(rs.getString("Result"));
                    diagnosis.setDiagnosisDate(rs.getTimestamp("DiagnosisDate"));
                    
                    // Additional display fields
                    diagnosis.setPatientName(rs.getString("PatientName"));
                    diagnosis.setNurseName(rs.getString("NurseName"));
                    diagnosis.setDoctorName(rs.getString("DoctorName"));
                    
                    diagnoses.add(diagnosis);
                }
            }
        }
        return diagnoses;
    }
    
    // NEW METHOD: Added for JSP compatibility - Get pending diagnoses by nurse ID
    public List<Diagnosis> getPendingDiagnosesByNurse(int nurseId) throws SQLException {
        List<Diagnosis> allDiagnoses = getDiagnosesByNurseId(nurseId);
        List<Diagnosis> pendingDiagnoses = new ArrayList<>();
        
        for (Diagnosis diagnosis : allDiagnoses) {
            if ("Referrable".equals(diagnosis.getDiagnoStatus()) && 
                (diagnosis.getDoctorId() == null || 
                 diagnosis.getResult() == null || 
                 "pending".equals(diagnosis.getResult()))) {
                pendingDiagnoses.add(diagnosis);
            }
        }
        
        return pendingDiagnoses;
    }
    
    // NEW METHOD: Added for JSP compatibility - Get confirmed diagnoses by nurse ID
    public List<Diagnosis> getConfirmedDiagnosesByNurse(int nurseId) throws SQLException {
        List<Diagnosis> allDiagnoses = getDiagnosesByNurseId(nurseId);
        List<Diagnosis> confirmedDiagnoses = new ArrayList<>();
        
        for (Diagnosis diagnosis : allDiagnoses) {
            if ("Referrable".equals(diagnosis.getDiagnoStatus()) && 
                diagnosis.getDoctorId() != null && 
                diagnosis.getResult() != null && 
                !"pending".equals(diagnosis.getResult())) {
                confirmedDiagnoses.add(diagnosis);
            }
        }
        
        return confirmedDiagnoses;
    }
    
    // NEW METHOD: Added for JSP compatibility - Get diagnoses by patient
    public List<Diagnosis> getDiagnosesByPatient(int patientId) throws SQLException {
        // This is just an alias for getDiagnosesByPatientId to maintain compatibility
        return getDiagnosesByPatientId(patientId);
    }
    
    // NEW METHOD: Get referrable diagnoses by nurse ID
    public List<Diagnosis> getReferrableDiagnosesByNurse(int nurseId) throws SQLException {
        String sql = "SELECT d.*, " +
                     "CONCAT(p.FirstName, ' ', p.LastName) AS PatientName, " +
                     "CONCAT(n.FirstName, ' ', n.LastName) AS NurseName, " +
                     "CONCAT(doc.FirstName, ' ', doc.LastName) AS DoctorName " +
                     "FROM Diagnosis d " +
                     "JOIN Patients p ON d.PatientID = p.PatientID " +
                     "JOIN Nurses n ON d.NurseID = n.NurseID " +
                     "LEFT JOIN Doctors doc ON d.DoctorID = doc.DoctorID " +
                     "WHERE d.NurseID = ? " +
                     "AND d.DiagnoStatus = 'Referrable' " +
                     "ORDER BY d.DiagnosisDate DESC";
        List<Diagnosis> diagnoses = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, nurseId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Diagnosis diagnosis = new Diagnosis();
                    diagnosis.setDiagnosisId(rs.getInt("DiagnosisID"));
                    diagnosis.setPatientId(rs.getInt("PatientID"));
                    diagnosis.setNurseId(rs.getInt("NurseID"));
                    
                    int doctorId = rs.getInt("DoctorID");
                    if (!rs.wasNull()) {
                        diagnosis.setDoctorId(doctorId);
                    }
                    
                    diagnosis.setDiagnoStatus(rs.getString("DiagnoStatus"));
                    diagnosis.setResult(rs.getString("Result"));
                    diagnosis.setDiagnosisDate(rs.getTimestamp("DiagnosisDate"));
                    
                    // Additional display fields
                    diagnosis.setPatientName(rs.getString("PatientName"));
                    diagnosis.setNurseName(rs.getString("NurseName"));
                    diagnosis.setDoctorName(rs.getString("DoctorName"));
                    
                    diagnoses.add(diagnosis);
                }
            }
        }
        return diagnoses;
    }
    
    // NEW METHOD: Get non-referrable diagnoses by nurse ID
    public List<Diagnosis> getNonReferrableDiagnosesByNurse(int nurseId) throws SQLException {
        String sql = "SELECT d.*, " +
                     "CONCAT(p.FirstName, ' ', p.LastName) AS PatientName, " +
                     "CONCAT(n.FirstName, ' ', n.LastName) AS NurseName, " +
                     "CONCAT(doc.FirstName, ' ', doc.LastName) AS DoctorName " +
                     "FROM Diagnosis d " +
                     "JOIN Patients p ON d.PatientID = p.PatientID " +
                     "JOIN Nurses n ON d.NurseID = n.NurseID " +
                     "LEFT JOIN Doctors doc ON d.DoctorID = doc.DoctorID " +
                     "WHERE d.NurseID = ? " +
                     "AND d.DiagnoStatus = 'Not Referrable' " +
                     "ORDER BY d.DiagnosisDate DESC";
        List<Diagnosis> diagnoses = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, nurseId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Diagnosis diagnosis = new Diagnosis();
                    diagnosis.setDiagnosisId(rs.getInt("DiagnosisID"));
                    diagnosis.setPatientId(rs.getInt("PatientID"));
                    diagnosis.setNurseId(rs.getInt("NurseID"));
                    
                    int doctorId = rs.getInt("DoctorID");
                    if (!rs.wasNull()) {
                        diagnosis.setDoctorId(doctorId);
                    }
                    
                    diagnosis.setDiagnoStatus(rs.getString("DiagnoStatus"));
                    diagnosis.setResult(rs.getString("Result"));
                    diagnosis.setDiagnosisDate(rs.getTimestamp("DiagnosisDate"));
                    
                    // Additional display fields
                    diagnosis.setPatientName(rs.getString("PatientName"));
                    diagnosis.setNurseName(rs.getString("NurseName"));
                    diagnosis.setDoctorName(rs.getString("DoctorName"));
                    
                    diagnoses.add(diagnosis);
                }
            }
        }
        return diagnoses;
    }
    
    // Get diagnosis count methods for dashboard statistics
    public int getTotalCasesCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Diagnosis";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    public int getPendingCasesCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Diagnosis WHERE DiagnoStatus = 'Referrable' AND (Result IS NULL OR Result = 'pending')";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    public int getConfirmedCasesCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Diagnosis WHERE DiagnoStatus = 'Referrable' AND Result IS NOT NULL AND Result != 'pending'";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    public int getNotReferrableCasesCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Diagnosis WHERE DiagnoStatus = 'Not Referrable'";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    // Get hospital-specific counts
    public int getCasesByHospital(String hospitalName) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Diagnosis d " +
                     "JOIN Nurses n ON d.NurseID = n.NurseID " +
                     "WHERE n.HealthCenter = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, hospitalName);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
    
    public int getPendingCasesByHospital(String hospitalName) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Diagnosis d " +
                     "JOIN Nurses n ON d.NurseID = n.NurseID " +
                     "WHERE n.HealthCenter = ? " +
                     "AND d.DiagnoStatus = 'Referrable' " +
                     "AND (d.Result IS NULL OR d.Result = 'pending')";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, hospitalName);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
    
    public int getConfirmedCasesByHospital(String hospitalName) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Diagnosis d " +
                     "JOIN Nurses n ON d.NurseID = n.NurseID " +
                     "WHERE n.HealthCenter = ? " +
                     "AND d.DiagnoStatus = 'Referrable' " +
                     "AND d.Result IS NOT NULL " +
                     "AND d.Result != 'pending'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, hospitalName);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
    
    // Get nurse-specific counts
    public int getReferrableCasesByNurse(int nurseId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Diagnosis " +
                     "WHERE NurseID = ? AND DiagnoStatus = 'Referrable'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, nurseId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
    
    public int getNotReferrableCasesByNurse(int nurseId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Diagnosis " +
                     "WHERE NurseID = ? AND DiagnoStatus = 'Not Referrable'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, nurseId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
    
    public int getPendingCasesByNurse(int nurseId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Diagnosis " +
                     "WHERE NurseID = ? AND DiagnoStatus = 'Referrable' " +
                     "AND (Result IS NULL OR Result = 'pending')";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, nurseId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
    
    public int getConfirmedCasesByNurse(int nurseId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Diagnosis " +
                     "WHERE NurseID = ? AND DiagnoStatus = 'Referrable' " +
                     "AND Result IS NOT NULL AND Result != 'pending'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, nurseId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
    
    // Get cases registered by a nurse
    public int getCasesByNurse(int nurseId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Diagnosis WHERE NurseID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, nurseId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
    
    // Get the latest status for a patient
    public String getLatestStatusForPatient(int patientId) throws SQLException {
        String sql = "SELECT DiagnoStatus, Result FROM Diagnosis " +
                     "WHERE PatientID = ? " +
                     "ORDER BY DiagnosisDate DESC LIMIT 1";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, patientId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String diagnoStatus = rs.getString("DiagnoStatus");
                    String result = rs.getString("Result");
                    
                    if (diagnoStatus.equals("Referrable")) {
                        if (result == null || result.equals("pending")) {
                            return "Referrable-pending";
                        } else {
                            return "Referrable-confirmed";
                        }
                    } else {
                        return diagnoStatus;
                    }
                }
            }
        }
        return "Unknown";
    }
}