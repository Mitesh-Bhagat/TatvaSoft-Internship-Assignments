CREATE DATABASE homecare_db; 
 
CREATE SCHEMA hc; 
 
CREATE TABLE hc.users ( 
user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(), 
    first_name VARCHAR(100), 
    last_name VARCHAR(100), 
    email VARCHAR(255) UNIQUE, 
    password TEXT, 
    created_by UUID, 
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    modified_by UUID, 
    modified_date TIMESTAMP, 
    is_active BOOLEAN DEFAULT TRUE, 
    is_deleted BOOLEAN DEFAULT FALSE, 
    birth_date DATE, 
    address TEXT, 
    mobile_number VARCHAR(20) 
); 
 
SELECT * FROM hc.users; 
 
INSERT INTO hc.users ( 
    first_name,  
    last_name,  
    email,  
    password,  
    birth_date,  
    address,  
    mobile_number 
) VALUES ( 
    'Alice',  
    'Smith',  
    'alice@example.com',  
    'encrypted_pass_123',  
    '1985-06-15',  
    '123 Maple Street',  
    '555-1234' 
); 
 
INSERT INTO hc.users (first_name, last_name, email, password, birth_date, address, mobile_number) 
VALUES  
    ('Bob', 'Jones', 'bob@example.com', 'pass123', '1990-08-20', '456 Oak Ave', '555-5678'), 
    ('Charlie', 'Brown', 'charlie@example.com', 'pass123', '1975-12-05', '789 Pine Rd', '555-9012'), 
    ('Diana', 'Prince', 'diana@example.com', 'pass123', '1988-03-22', '321 Elm St', '555-3456'), 
    ('Evan', 'Wright', 'evan@example.com', 'pass123', '1995-11-10', '654 Birch Blvd', '555-7890'), 
    ('Fiona', 'Gallagher', 'fiona@example.com', 'pass123', '1992-07-08', '987 Cedar Ln', '555-2345'), 
    ('George', 'Miller', 'george@example.com', 'pass123', '1980-02-14', '147 Spruce Ct', '555-6789'), 
    ('Hannah', 'Abbott', 'hannah@example.com', 'pass123', '1998-09-30', '258 Willow Dr', '555-0123'), 
    ('Ian', 'Malcolm', 'ian@example.com', 'pass123', '1970-05-18', '369 Aspen Way', '555-4567'), 
    ('Julia', 'Roberts', 'julia@example.com', 'pass123', '1982-10-25', '741 Cherry Pl', '555-8901'); 
 
 

SELECT first_name || ' ' || last_name AS user_name, email  
FROM hc.users; 

SELECT * FROM hc.users  
WHERE is_active = false; 

SELECT * FROM hc.users  
WHERE first_name LIKE 'A%' AND last_name LIKE '%i'; 

SELECT * FROM hc.users  
WHERE email LIKE '%@example%'; 

SELECT * FROM hc.users  
WHERE first_name ILIKE 'a%'; 

SELECT * FROM hc.users  
ORDER BY created_date DESC; 

SELECT * FROM hc.users  
ORDER BY created_date DESC  
LIMIT 5; 

SELECT * FROM hc.users  
ORDER BY created_date DESC  
LIMIT 5 OFFSET 5; 