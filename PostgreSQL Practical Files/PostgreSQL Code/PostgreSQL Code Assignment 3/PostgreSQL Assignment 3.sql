-- ==========================================
-- ASSIGNMENT 3
-- ==========================================

-- ------------------------------------------
-- 1. VIEWS
-- ------------------------------------------
CREATE MATERIALIZED VIEW mv_role_user_count AS
SELECT 
    r.role_name, 
    COUNT(u.user_id) AS total_users
FROM tdb.roles r
LEFT JOIN tdb.users u ON r.role_id = u.role_id
GROUP BY r.role_name;

-- d. Refresh materialized view
REFRESH MATERIALIZED VIEW mv_role_user_count;


-- ------------------------------------------
-- 2. FUNCTIONS
-- ------------------------------------------
-- a. Return total users by role
CREATE OR REPLACE FUNCTION get_user_count_by_role(p_role_id INT)
RETURNS INT LANGUAGE sql AS $$
    SELECT COUNT(*)::INT FROM tdb.users WHERE role_id = p_role_id;
$$;

-- b. Return user full name
CREATE OR REPLACE FUNCTION get_user_fullname(p_user_id INT)
RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE 
    v_full_name VARCHAR;
BEGIN
    SELECT first_name || ' ' || last_name INTO v_full_name
    FROM tdb.users WHERE user_id = p_user_id;
    RETURN v_full_name;
END;
$$;

-- c. Calculate age
CREATE OR REPLACE FUNCTION calculate_age(p_birth_date DATE)
RETURNS INT LANGUAGE plpgsql AS $$
BEGIN
    RETURN EXTRACT(YEAR FROM AGE(p_birth_date))::INT;
END;
$$;

-- d. Return all users created today
CREATE OR REPLACE FUNCTION get_todays_users()
RETURNS TABLE (
    user_id INT, first_name VARCHAR, last_name VARCHAR, 
    email VARCHAR, created_date TIMESTAMP
) LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY
    SELECT u.user_id, u.first_name, u.last_name, u.email, u.created_date
    FROM tdb.users u WHERE u.created_date::DATE = CURRENT_DATE;
END;
$$;

-- e. Demonstrate IN, OUT parameters
CREATE OR REPLACE FUNCTION get_user_stats(
    IN p_role_id INT, OUT total_users INT, OUT active_users INT
) LANGUAGE plpgsql AS $$
BEGIN
    SELECT COUNT(*), COUNT(NULLIF(is_active, false))
    INTO total_users, active_users
    FROM tdb.users WHERE role_id = p_role_id;
END;
$$;


-- ------------------------------------------
-- 3. STORED PROCEDURES
-- ------------------------------------------
-- a. Insert new user
CREATE OR REPLACE PROCEDURE sp_insert_user(
    p_first_name VARCHAR, p_last_name VARCHAR, p_email VARCHAR, p_role_id INT
) LANGUAGE plpgsql AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM tdb.users WHERE email = p_email) THEN
        RAISE EXCEPTION 'Email % is already in use.', p_email;
    END IF;
    INSERT INTO tdb.users (first_name, last_name, email, role_id)
    VALUES (p_first_name, p_last_name, p_email, p_role_id);
END;
$$;

-- Setup for b: Add soft delete column
ALTER TABLE tdb.users ADD COLUMN is_deleted BOOLEAN DEFAULT false;

-- b. Soft delete user
CREATE OR REPLACE PROCEDURE sp_soft_delete_user(p_user_id INT)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE tdb.users
    SET is_deleted = true, is_active = false 
    WHERE user_id = p_user_id;
END;
$$;

-- Setup for c & d: Create audit table
CREATE TABLE tdb.role_audit (
    audit_id SERIAL PRIMARY KEY, user_id INT, 
    old_role_id INT, new_role_id INT, changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- c & d. Update user role and log to audit table
CREATE OR REPLACE PROCEDURE sp_update_user_role(p_user_id INT, p_new_role_id INT)
LANGUAGE plpgsql AS $$
DECLARE 
    v_old_role_id INT;
BEGIN
    SELECT role_id INTO v_old_role_id FROM tdb.users WHERE user_id = p_user_id;
    UPDATE tdb.users SET role_id = p_new_role_id WHERE user_id = p_user_id;
    
    INSERT INTO tdb.role_audit (user_id, old_role_id, new_role_id)
    VALUES (p_user_id, v_old_role_id, p_new_role_id);
END;
$$;


-- ------------------------------------------
-- 4. TRIGGERS
-- ------------------------------------------
-- Setup for a: Add modified_date column
ALTER TABLE tdb.users ADD COLUMN modified_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- a. Update modified_date automatically
CREATE OR REPLACE FUNCTION update_modified_date()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    NEW.modified_date = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_update_users_modified_date
BEFORE UPDATE ON tdb.users FOR EACH ROW EXECUTE FUNCTION update_modified_date();

-- b. Prevent user deletion
CREATE OR REPLACE FUNCTION prevent_user_deletion()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    RAISE EXCEPTION 'Deletion of users is not allowed.';
END;
$$;

CREATE TRIGGER trg_prevent_user_delete
BEFORE DELETE ON tdb.users FOR EACH ROW EXECUTE FUNCTION prevent_user_deletion();

-- Setup for c: Create user audit table
CREATE TABLE tdb.user_audit (
    audit_id SERIAL PRIMARY KEY, user_id INT, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- c. Log user creation
CREATE OR REPLACE FUNCTION log_user_creation()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO tdb.user_audit (user_id) VALUES (NEW.user_id);
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_log_user_creation
AFTER INSERT ON tdb.users FOR EACH ROW EXECUTE FUNCTION log_user_creation();


-- ------------------------------------------
-- 5. CURSORS
-- ------------------------------------------
DO $$
DECLARE
    cur_users CURSOR FOR SELECT user_id, email FROM tdb.users;
    rec_user RECORD;
BEGIN
    FOR rec_user IN cur_users LOOP
        RAISE NOTICE 'User ID: %, Email: %', rec_user.user_id, rec_user.email;
    END LOOP;
END;
$$;


-- ------------------------------------------
-- 6. JOBS / SCHEDULING
-- ------------------------------------------
-- Note: pg_cron requires a Linux environment or cloud PostgreSQL
CREATE EXTENSION IF NOT EXISTS pg_cron;

SELECT cron.schedule(
    'hourly_mv_refresh', 
    '0 * * * *', 
    'REFRESH MATERIALIZED VIEW mv_role_user_count'
);