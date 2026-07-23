-- ==========================================
-- SETUP: Schema, Tables, and Data
-- ==========================================
DROP SCHEMA IF EXISTS tdb CASCADE;
CREATE SCHEMA tdb;

CREATE TABLE tdb.roles (
    role_id SERIAL PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL
);

CREATE TABLE tdb.service_types (
    service_type_id SERIAL PRIMARY KEY,
    type_name VARCHAR(100) NOT NULL
);

CREATE TABLE tdb.categories (
    category_id SERIAL PRIMARY KEY,
    service_type_id INT,
    category_name VARCHAR(100) NOT NULL
);

CREATE TABLE tdb.sub_categories (
    sub_category_id SERIAL PRIMARY KEY,
    category_id INT,
    sub_category_name VARCHAR(100) NOT NULL
);

CREATE TABLE tdb.users (
    user_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(255),
    role_id INT,
    birth_date DATE,
    mobile_number VARCHAR(20),
    is_active BOOLEAN DEFAULT TRUE,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO tdb.roles (role_name) VALUES ('Admin'), ('Staff'), ('Customer');
INSERT INTO tdb.service_types (type_name) VALUES ('Cleaning'), ('Repair');
INSERT INTO tdb.categories (service_type_id, category_name) VALUES (1, 'House Cleaning'), (1, 'Office Cleaning'), (2, 'Plumbing'), (2, 'Electrical');
INSERT INTO tdb.sub_categories (category_id, sub_category_name) VALUES (1, 'Deep Cleaning'), (1, 'Regular Cleaning'), (3, 'Pipe Leakage'), (4, 'Wiring');
INSERT INTO tdb.users (first_name, last_name, email, role_id, birth_date, mobile_number, is_active) VALUES
('John', 'Doe', 'john@example.com', 1, '1980-01-15', '1234567890', true),
('Jane', 'Smith', 'jane@example.com', 2, '1992-05-20', '0987654321', true),
('Bob', 'Wilson', 'bob@example.com', 3, '1975-11-08', '5555555555', false);

-- ==========================================
-- 6. Constraints 
-- ==========================================
ALTER TABLE tdb.users ADD CONSTRAINT unique_user_email UNIQUE (email);
ALTER TABLE tdb.users ADD CONSTRAINT fk_users_roles FOREIGN KEY (role_id) REFERENCES tdb.roles(role_id);
ALTER TABLE tdb.categories ADD CONSTRAINT fk_categories_services FOREIGN KEY (service_type_id) REFERENCES tdb.service_types(service_type_id);
ALTER TABLE tdb.sub_categories ADD CONSTRAINT fk_subcat_categories FOREIGN KEY (category_id) REFERENCES tdb.categories(category_id);
ALTER TABLE tdb.users ADD CONSTRAINT chk_mobile_length CHECK (LENGTH(mobile_number) >= 10);
ALTER TABLE tdb.users ADD CONSTRAINT chk_birth_date CHECK (birth_date < CURRENT_DATE);

-- ==========================================
-- 7. Indexes
-- ==========================================
CREATE INDEX idx_users_email ON tdb.users(email);

-- ==========================================
-- 1. Aggregate Functions
-- ==========================================
-- a.
SELECT COUNT(*) FROM tdb.users;
-- b.
SELECT COUNT(*) FROM tdb.users WHERE is_active = true;
-- c.
SELECT role_id, COUNT(*) FROM tdb.users GROUP BY role_id;
-- d.
SELECT MIN(birth_date), MAX(birth_date) FROM tdb.users;
-- e.
SELECT AVG(EXTRACT(YEAR FROM AGE(birth_date))) AS average_age FROM tdb.users;
-- f.
SELECT service_type_id, COUNT(*) FROM tdb.categories GROUP BY service_type_id;
-- g.
SELECT category_id, COUNT(*) FROM tdb.sub_categories GROUP BY category_id;

-- ==========================================
-- 2. GROUP BY & HAVING
-- ==========================================
-- a.
SELECT role_id, COUNT(*) FROM tdb.users GROUP BY role_id;
-- b.
SELECT role_id, COUNT(*) FROM tdb.users GROUP BY role_id HAVING COUNT(*) > 2;
-- c.
SELECT service_type_id, COUNT(*) FROM tdb.categories GROUP BY service_type_id HAVING COUNT(*) > 3;
-- d.
SELECT category_id, COUNT(*) FROM tdb.sub_categories GROUP BY category_id HAVING COUNT(*) >= 2;
-- e.
SELECT EXTRACT(YEAR FROM birth_date) AS birth_year, COUNT(*) FROM tdb.users GROUP BY EXTRACT(YEAR FROM birth_date);
-- f.
SELECT EXTRACT(YEAR FROM birth_date) AS birth_year, COUNT(*) FROM tdb.users GROUP BY EXTRACT(YEAR FROM birth_date) HAVING COUNT(*) > 5;

-- ==========================================
-- 3. Joins
-- ==========================================
-- a. INNER JOIN
SELECT c.category_name, s.type_name FROM tdb.categories c INNER JOIN tdb.service_types s ON c.service_type_id = s.service_type_id;
-- b. LEFT JOIN
SELECT s.type_name, c.category_name FROM tdb.service_types s LEFT JOIN tdb.categories c ON s.service_type_id = c.service_type_id;
-- c. RIGHT JOIN
SELECT c.category_name, sc.sub_category_name FROM tdb.sub_categories sc RIGHT JOIN tdb.categories c ON sc.category_id = c.category_id;

-- ==========================================
-- 4. EXISTS
-- ==========================================
-- a.
SELECT * FROM tdb.roles r WHERE EXISTS (SELECT 1 FROM tdb.users u WHERE u.role_id = r.role_id);
-- b.
SELECT * FROM tdb.service_types st WHERE EXISTS (SELECT 1 FROM tdb.categories c WHERE c.service_type_id = st.service_type_id);
-- c.
SELECT * FROM tdb.categories c WHERE EXISTS (SELECT 1 FROM tdb.sub_categories sc WHERE sc.category_id = c.category_id);
-- d.
SELECT * FROM tdb.users u WHERE EXISTS (SELECT 1 FROM tdb.roles r WHERE r.role_id = u.role_id);

-- ==========================================
-- 5. Common Table Expression (CTE)
-- ==========================================
WITH CategoryCountCTE AS (
    SELECT service_type_id, COUNT(*) AS total_categories FROM tdb.categories GROUP BY service_type_id
)
SELECT * FROM CategoryCountCTE;

-- ==========================================
-- 8. Date & Time Handling
-- ==========================================
-- a.
SELECT * FROM tdb.users WHERE created_date::DATE = CURRENT_DATE;
-- b.
SELECT * FROM tdb.users WHERE created_date >= CURRENT_DATE - 30;
-- c.
SELECT EXTRACT(YEAR FROM birth_date) AS birth_year FROM tdb.users;
-- d.
SELECT user_id, first_name, AGE(birth_date) AS current_age FROM tdb.users;
-- e.
SELECT EXTRACT(YEAR FROM birth_date) AS birth_year, COUNT(*) FROM tdb.users GROUP BY EXTRACT(YEAR FROM birth_date);

-- ==========================================
-- 9. Window Functions
-- ==========================================
-- a.
SELECT user_id, first_name, role_id, created_date, ROW_NUMBER() OVER(PARTITION BY role_id ORDER BY created_date) AS row_num FROM tdb.users;
-- b.
WITH RoleCounts AS (
    SELECT role_id, COUNT(*) AS total_users FROM tdb.users GROUP BY role_id
)
SELECT role_id, total_users, RANK() OVER(ORDER BY total_users DESC) AS role_rank FROM RoleCounts;
-- c.
SELECT user_id, role_id, created_date, LAG(created_date) OVER(PARTITION BY role_id ORDER BY created_date) AS prev_created_date FROM tdb.users;
-- d.
SELECT user_id, role_id, created_date, LEAD(created_date) OVER(PARTITION BY role_id ORDER BY created_date) AS next_created_date FROM tdb.users;
-- e.
WITH RankedUsers AS (
    SELECT user_id, first_name, role_id, birth_date, ROW_NUMBER() OVER(PARTITION BY role_id ORDER BY birth_date ASC) AS age_rank FROM tdb.users
)
SELECT * FROM RankedUsers WHERE age_rank = 2;