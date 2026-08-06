# Patient Management System (PMS)

A JSP + Servlet + MySQL patient management system built for the Advanced Java
Programming module, University of Rwanda (Musanze Campus, Group 5).

## Stack
- Jakarta EE 10 (Servlet 6.0 / JSP), Apache Tomcat 10.1
- MySQL 8+, JDBC (`mysql-connector-j`)
- Bootstrap 5, JSTL
- No build tool (Maven/Gradle) — dependency jars are checked into `src/main/webapp/WEB-INF/lib`

## Roles
Admin, Doctor, Nurse, Patient — each with a role-scoped dashboard under
`src/main/webapp/views/`.

## Configuration
Database credentials are loaded at startup from `src/main/webapp/WEB-INF/.env`
(via `com.pms.util.EnvLoader`), never hardcoded in source. Copy `.env.example`
to `src/main/webapp/WEB-INF/.env` and fill in your own values before running.

## Running locally
1. Start MySQL and run `database/pms_schema.sql` to create the `PMS` database.
2. Set up `src/main/webapp/WEB-INF/.env` (see `.env.example`).
3. Deploy to Apache Tomcat 10.1.
4. Open `http://localhost:8080/PatientManagementSystem/index.jsp`.

## Password hashing
All passwords are hashed with bcrypt (jBCrypt, `WEB-INF/lib/jbcrypt-0.4.jar`) —
`UserDAO` hashes on registration/password-change and verifies with
`BCrypt.checkpw()` on login. Passwords are never stored or compared as
plaintext.

**If you have an existing dev database created before this change**, its
`Users` rows still hold plaintext passwords and will no longer authenticate
(the login check now expects a bcrypt hash). There's no migration script —
either re-run `database/pms_schema.sql` against a fresh database, or delete
and re-register those specific accounts through the app.

See `src/main/webapp/README.txt` for detailed application-facing documentation
and workflows.
