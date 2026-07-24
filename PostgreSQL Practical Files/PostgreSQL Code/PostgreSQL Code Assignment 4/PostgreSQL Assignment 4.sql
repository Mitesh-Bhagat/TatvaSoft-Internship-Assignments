-- 1. Insert Data Transaction
BEGIN;
INSERT INTO tdb.roles (role_name) VALUES ('Guest');
INSERT INTO tdb.users (first_name, last_name, email, role_id) VALUES ('New', 'User', 'newuser@example.com', 2);
COMMIT;

-- 2. Create Database Roles
CREATE ROLE db_admin;
CREATE ROLE app_owner;
CREATE ROLE app_user;
CREATE ROLE app_readonly;

-- 3. Grant Initial Privileges
GRANT ALL PRIVILEGES ON SCHEMA tdb TO db_admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA tdb TO app_owner;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA tdb TO app_user;
GRANT SELECT ON ALL TABLES IN SCHEMA tdb TO app_readonly;

-- 4. Revoke Initial Privileges
REVOKE ALL PRIVILEGES ON SCHEMA tdb FROM db_admin;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA tdb FROM app_owner;
REVOKE SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA tdb FROM app_user;
REVOKE SELECT ON ALL TABLES IN SCHEMA tdb FROM app_readonly;

-- 5. Demonstrate Security Levels
GRANT USAGE, CREATE ON SCHEMA tdb TO db_admin;
GRANT USAGE ON SCHEMA tdb TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON tdb.users TO db_admin;
GRANT SELECT ON tdb.roles TO app_readonly;

-- 6. Revoke Default Public Privileges
REVOKE ALL PRIVILEGES ON DATABASE postgres FROM PUBLIC;
REVOKE ALL PRIVILEGES ON SCHEMA tdb FROM PUBLIC;
REVOKE ALL PRIVILEGES ON SCHEMA public FROM PUBLIC;

-- 7. Grant Specific Schema Privileges
GRANT USAGE ON SCHEMA tdb TO app_user;
GRANT USAGE ON SCHEMA tdb TO app_readonly;

-- 8. Configure Table Object Privileges for Schema 'hc'
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA hc TO app_user;
GRANT SELECT ON ALL TABLES IN SCHEMA hc TO app_readonly;
REVOKE TRUNCATE ON ALL TABLES IN SCHEMA hc FROM app_user;