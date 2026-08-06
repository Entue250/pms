-- Create database
CREATE DATABASE PMS;
USE PMS;

-- Create Users table
CREATE TABLE Users (
    UserID INT PRIMARY KEY AUTO_INCREMENT,
    Username VARCHAR(50) UNIQUE NOT NULL,
    Password VARCHAR(100) NOT NULL,
    UserType ENUM('Admin', 'Doctor', 'Nurse', 'Patient') NOT NULL
);

-- Create Patients table
CREATE TABLE Patients (
    PatientID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT UNIQUE,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Telephone VARCHAR(20) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Address VARCHAR(200) NOT NULL,
    PImageLink VARCHAR(255),
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

-- Create Nurses table
CREATE TABLE Nurses (
    NurseID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT UNIQUE,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Telephone VARCHAR(20) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Address VARCHAR(200) NOT NULL,
    HealthCenter VARCHAR(100) NOT NULL,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

-- Create Doctors table
CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT UNIQUE,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Telephone VARCHAR(20) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Address VARCHAR(200) NOT NULL,
    HospitalName VARCHAR(100) NOT NULL,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

-- Create Diagnosis table
CREATE TABLE Diagnosis (
    DiagnosisID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT NOT NULL,
    NurseID INT NOT NULL,
    DoctorID INT,
    DiagnoStatus ENUM('Referrable', 'Not Referrable') NOT NULL,
    Result TEXT,
    DiagnosisDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (NurseID) REFERENCES Nurses(NurseID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- Insert initial admin user
-- Password is bcrypt-hashed (plaintext value was 'admin123'). Passwords are
-- hashed with jBCrypt in com.pms.dao.UserDAO (BCrypt.hashpw on write,
-- BCrypt.checkpw on login) — never stored or compared as plaintext.
-- NOTE: if you have an existing dev database seeded before this change,
-- its Users rows still hold plaintext passwords and will no longer
-- authenticate. Re-run this script against a fresh database, or delete
-- and re-register those accounts (see README.md).
INSERT INTO Users (Username, Password, UserType) VALUES ('admin', '$2a$10$L0901NWvRIc0PPZu1kF2vOSyPVN5Bl5jK9GQNcM3XxRkDE32v0m3y', 'Admin');