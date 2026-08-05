// com.pms.model.Doctor.java
package com.pms.model;

public class Doctor {
    private int doctorId;
    private int userID;
    private String firstName;
    private String lastName;
    private String telephone;
    private String email;
    private String address;
    private String hospitalName;
    
    // Constructors
    public Doctor() {}
    
    public Doctor(int doctorId, int userID, String firstName, String lastName, 
                 String telephone, String email, String address, String hospitalName) {
        this.doctorId = doctorId;
        this.userID = userID;
        this.firstName = firstName;
        this.lastName = lastName;
        this.telephone = telephone;
        this.email = email;
        this.address = address;
        this.hospitalName = hospitalName;
    }
    
    // Getters and setters
    public int getDoctorId() {
        return doctorId;
    }
    
    public void setDoctorId(int doctorId) {
        this.doctorId = doctorId;
    }
    
    public int getUserID() {
        return userID;
    }
    
    public void setUserID(int userID) {
        this.userID = userID;
    }
    
    public String getFirstName() {
        return firstName;
    }
    
    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }
    
    public String getLastName() {
        return lastName;
    }
    
    public void setLastName(String lastName) {
        this.lastName = lastName;
    }
    
    public String getTelephone() {
        return telephone;
    }
    
    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getAddress() {
        return address;
    }
    
    public void setAddress(String address) {
        this.address = address;
    }
    
    public String getHospitalName() {
        return hospitalName;
    }
    
    public void setHospitalName(String hospitalName) {
        this.hospitalName = hospitalName;
    }
}