package com.pms.model;

import java.sql.Timestamp;

public class Diagnosis {
    private int diagnosisId;
    private int patientId;
    private int nurseId;
    private Integer doctorId; // Can be null if not referred to a doctor
    private String diagnoStatus;
    private String result;
    private Timestamp diagnosisDate;
    
    // Additional fields for displaying related information
    private String patientName;
    private String nurseName;
    private String doctorName;
    
    // These fields are missing and causing errors
    private String symptoms;
    private String nurseDiagnosis;
    private String doctorDiagnosis;
    private String prescription;
    
    // Constructors
    public Diagnosis() {}
    
    public Diagnosis(int diagnosisId, int patientId, int nurseId, Integer doctorId,
                    String diagnoStatus, String result, Timestamp diagnosisDate) {
        this.diagnosisId = diagnosisId;
        this.patientId = patientId;
        this.nurseId = nurseId;
        this.doctorId = doctorId;
        this.diagnoStatus = diagnoStatus;
        this.result = result;
        this.diagnosisDate = diagnosisDate;
    }
    
    // Existing getters and setters
    public int getDiagnosisId() {
        return diagnosisId;
    }
    
    public void setDiagnosisId(int diagnosisId) {
        this.diagnosisId = diagnosisId;
    }
    
    public int getPatientId() {
        return patientId;
    }
    
    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }
    
    public int getNurseId() {
        return nurseId;
    }
    
    public void setNurseId(int nurseId) {
        this.nurseId = nurseId;
    }
    
    public Integer getDoctorId() {
        return doctorId;
    }
    
    public void setDoctorId(Integer doctorId) {
        this.doctorId = doctorId;
    }
    
    public String getDiagnoStatus() {
        return diagnoStatus;
    }
    
    public void setDiagnoStatus(String diagnoStatus) {
        this.diagnoStatus = diagnoStatus;
    }
    
    public String getResult() {
        return result;
    }
    
    public void setResult(String result) {
        this.result = result;
    }
    
    public Timestamp getDiagnosisDate() {
        return diagnosisDate;
    }
    
    public void setDiagnosisDate(Timestamp diagnosisDate) {
        this.diagnosisDate = diagnosisDate;
    }
    
    public String getPatientName() {
        return patientName;
    }
    
    public void setPatientName(String patientName) {
        this.patientName = patientName;
    }
    
    public String getNurseName() {
        return nurseName;
    }
    
    public void setNurseName(String nurseName) {
        this.nurseName = nurseName;
    }
    
    public String getDoctorName() {
        return doctorName;
    }
    
    public void setDoctorName(String doctorName) {
        this.doctorName = doctorName;
    }
    
    // New getters and setters for the missing fields
    public String getSymptoms() {
        return symptoms;
    }
    
    public void setSymptoms(String symptoms) {
        this.symptoms = symptoms;
    }
    
    public String getNurseDiagnosis() {
        return nurseDiagnosis;
    }
    
    public void setNurseDiagnosis(String nurseDiagnosis) {
        this.nurseDiagnosis = nurseDiagnosis;
    }
    
    public String getDoctorDiagnosis() {
        return doctorDiagnosis;
    }
    
    public void setDoctorDiagnosis(String doctorDiagnosis) {
        this.doctorDiagnosis = doctorDiagnosis;
    }
    
    public String getPrescription() {
        return prescription;
    }
    
    public void setPrescription(String prescription) {
        this.prescription = prescription;
    }
    
    // Helper method to check if diagnosis is referrable
    public boolean isReferrable() {
        return "Referrable".equals(this.diagnoStatus);
    }
}