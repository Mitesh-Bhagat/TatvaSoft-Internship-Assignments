CREATE DATABASE traning_db;


-- Create schema
CREATE SCHEMA tdb;

-- Create tables with constraints
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
    service_type_id INT REFERENCES tdb.service_types(service_type_id),
    category_name VARCHAR(100) NOT NULL
);

CREATE TABLE tdb.sub_categories (
    sub_category_id SERIAL PRIMARY KEY,
    category_id INT REFERENCES tdb.categories(category_id),
    sub_category_name VARCHAR(100) NOT NULL
);

CREATE TABLE tdb.users (
    user_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(255) UNIQUE,
    role_id INT REFERENCES tdb.roles(role_id),
    birth_date DATE CHECK (birth_date < CURRENT_DATE),
    mobile_number VARCHAR(20) CHECK (LENGTH(mobile_number) >= 10),
    is_active BOOLEAN DEFAULT TRUE,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data
INSERT INTO tdb.roles (role_name) VALUES ('Admin'), ('Staff'), ('Customer');

INSERT INTO tdb.service_types (type_name) VALUES ('Cleaning'), ('Repair');

INSERT INTO tdb.categories (service_type_id, category_name) VALUES
(1, 'House Cleaning'), (1, 'Office Cleaning'),
(2, 'Plumbing'), (2, 'Electrical');

INSERT INTO tdb.sub_categories (category_id, sub_category_name) VALUES
(1, 'Deep Cleaning'), (1, 'Regular Cleaning'),
(3, 'Pipe Leakage'), (4, 'Wiring');

INSERT INTO tdb.users (first_name, last_name, email, role_id, birth_date, mobile_number, is_active) VALUES
('John', 'Doe', 'john@example.com', 1, '1980-01-15', '1234567890', true),
('Jane', 'Smith', 'jane@example.com', 2, '1992-05-20', '0987654321', true),
('Bob', 'Wilson', 'bob@example.com', 3, '1975-11-08', '5555555555', false);