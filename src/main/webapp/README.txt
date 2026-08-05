Patient Management System
Overview
The Patient Management System (PMS) is a web-based application designed to streamline healthcare workflows by providing an integrated platform for managing patients, nurses, doctors, and diagnoses. The system features role-based access control, allowing different healthcare professionals to perform their specific functions securely and efficiently.
Key Features
Role-Based User Management:

Admin: Manage doctors and nurses, view system-wide data, access detailed doctor and nurse profiles
Doctor: Manage nurses, review referrable cases, provide diagnoses, update personal profile
Nurse: Register patients, make initial diagnoses, update personal profile
Patient: View personal medical records and diagnosis results

User Profile Management:

Doctors can update their personal profiles and hospital information
Nurses can update their personal profiles and view health center information
Password change functionality for all users with verification
Real-time updates with proper error handling

Patient Management:

Patient registration with photo upload capability
Medical records tracking
Diagnosis history and results viewing

Diagnosis System:

Initial screening by nurses with referrable/non-referrable classification
Referral system for cases requiring doctor attention
Diagnosis result recording and tracking
Detailed case views for all healthcare providers

Reporting and Statistics:

Dashboard with key metrics
Case statistics for administrators
Hospital and healthcare provider performance tracking
Detailed doctor and nurse performance statistics

Recent Updates
Database Compatibility Updates (April 2025)

Adapted JSP views and backend code to work with the existing database structure rather than modifying the schema
Added compatibility methods in DiagnosisDAO.java to support all JSP functionality
Modified case-detail.jsp, pending-cases.jsp, and patient-detail.jsp to use existing database fields

Form Submission Fixes (April 2025)

Fixed the URL pattern mismatch in edit-patient.jsp to correctly submit to the updatePatientProfile servlet
Fixed modal dialog issues in nonreferrable-cases.jsp to prevent flickering and allow proper editing of results

Patient Profile Enhancement (April 2025)

Enhanced UpdatePatientProfileServlet.java to support both patient and nurse-initiated profile updates
Added image upload handling in patient profile updates
Improved error handling and user feedback for form submissions

Diagnosis Updates (April 2025)

Modified UpdateDiagnosisServlet.java to handle both referrable and non-referrable cases
Improved session message handling for better user experience
Added specific error handling for different scenarios

User Profile Management (Previous Update)

Added capability for doctors to update their profiles and hospital information
Added capability for nurses to update their profiles and view health center information
Implemented secure password changing functionality
Added appropriate validation and error handling

Bug Fixes (April 2025)

Fixed modal dialog issues in non-referrable cases page
Resolved URL mapping inconsistencies between JSP forms and servlets
Enhanced error handling throughout the application
Added session-based user feedback messaging
Fixed issues with patient profile editing by nurses

Technology Stack

Jakarta EE 9+ (Servlet 5.0)
JSP (JavaServer Pages)
MySQL Database
HTML5, CSS3, JavaScript
Bootstrap 5 for responsive design
JSTL for JSP templating

Setup Instructions
Prerequisites

Jakarta EE 9+ compatible server (Apache Tomcat 10.0+, Jetty 11+, or GlassFish 6+)
JDK 11 or higher
MySQL 8.0 or higher
Maven or Gradle (for dependency management)

Database Setup

Create a MySQL database named pms_db
Execute the SQL script located in database/pms_schema.sql to create the necessary tables and relationships

Configuration

Update the database connection details in com.pms.util.DBConnection.java with your MySQL credentials
Ensure your servlet container is configured to run Jakarta EE 9+ applications

Deployment

Build the project using Maven or your preferred build tool
Deploy the resulting WAR file to your servlet container
Access the application at http://localhost:8080/PatientManagementSystem/

Default Login Credentials
The system comes with the following default users for testing:
Admin:

Username: admin
Password: admin123

Doctor:

Username: doctor
Password: doctor123

Nurse:

Username: nurse
Password: nurse123

Patient:

Username: patient
Password: patient123

Important Notes

The images upload directory (webapp/images/patients/) will be created automatically for patient photo uploads
Servlet mapping is handled via annotations (@WebServlet) for most servlets
For modal-based editing, make sure Bootstrap JS is correctly included
HTTPS is recommended for production deployments to secure sensitive patient information
When deploying changes, restart your servlet container to ensure all changes take effect
After making changes to Java files, ensure the project is rebuilt before redeployment

Jakarta EE Notes
This application uses the Jakarta EE 9+ namespace (jakarta.) instead of the older Java EE namespace (javax.). If you're migrating from an older version, note that all servlet-related imports have changed from javax.servlet.* to jakarta.servlet.*.
Key Workflows
User Profile Management

User logs in and clicks on "My Profile" in the dropdown menu
Updates personal information as needed
Clicks "Update Profile" to save changes
For password changes, user enters current password and new password
System validates the current password and updates if correct

Patient Registration & Management (Nurse)

Nurse logs in
Navigates to "Add Patient" or selects "Edit" on an existing patient
Enters/updates patient details and uploads photo if needed
For new patients, selects diagnosis status (Referrable or Not Referrable)
If referrable, the case appears in doctors' pending cases

Diagnosis Review (Doctor)

Doctor logs in
Views pending cases
Reviews patient details and initial diagnosis
Provides diagnosis result
Status is updated and visible to both the nurse and patient

Non-Referrable Case Management (Nurse)

Nurse logs in
Views non-referrable cases
Can edit diagnosis results
Changes are saved and visible to patients

Case Follow-up (Nurse)

Nurse logs in
Views referrable cases
Checks which cases have been reviewed by doctors
Communicates results to patients as needed

Doctor/Nurse Management (Admin)

Admin logs in
Views list of doctors/nurses
Can view detailed profiles of each healthcare provider
Can edit doctor/nurse information or delete accounts as needed
Can view statistics on case assignments and resolutions

Troubleshooting
Common Issues and Solutions

"The import jakarta.servlet cannot be resolved": Ensure you're using a Jakarta EE 9+ compatible server
Database connection issues: Verify your MySQL credentials and that the MySQL service is running
Image upload errors: Check directory permissions for the images folder
Servlet mappings not working: Ensure servlet annotations match form action URLs
404 errors when accessing URLs: Verify file paths, servlet mappings, and that all files exist in the correct locations
Form submissions not saving: Check the servlet code, data model properties, and form field names match
Bootstrap modals not working: Ensure Bootstrap JS is included and properly initialized
Session timeout issues: Verify session management code in servlets

Modal Dialog Issues
If experiencing issues with Bootstrap modals:

Check that the Bootstrap JS file is correctly included
Ensure the modal is placed outside any table or complex DOM structure
Add event.stopPropagation() to modal trigger buttons
Use try/catch blocks in JavaScript to identify errors
Inspect the browser console for JavaScript errors

License
This project is for educational purposes only.
Contributors
Your Name/Team