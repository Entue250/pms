// com.pms.model.Nurse.java
package com.pms.model;

public class Nurse {
    private int nurseId;
    private int userID;
    private String firstName;
    private String lastName;
    private String telephone;
    private String email;
    private String address;
    private String healthCenter;
    
    // Constructors
    public Nurse() {}
    
    public Nurse(int nurseId, int userID, String firstName, String lastName, 
                String telephone, String email, String address, String healthCenter) {
        this.nurseId = nurseId;
        this.userID = userID;
        this.firstName = firstName;
        this.lastName = lastName;
        this.telephone = telephone;
        this.email = email;
        this.address = address;
        this.healthCenter = healthCenter;
    }
    
    // Getters and setters
    public int getNurseId() {
        return nurseId;
    }
    
    public void setNurseId(int nurseId) {
        this.nurseId = nurseId;
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
    
    public String getHealthCenter() {
        return healthCenter;
    }
    
    public void setHealthCenter(String healthCenter) {
        this.healthCenter = healthCenter;
    }
}