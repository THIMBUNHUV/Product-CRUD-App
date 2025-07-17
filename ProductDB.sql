-- Create the database
CREATE DATABASE ProductDB;

-- Use the database
USE ProductDB;

-- Create the PRODUCTS table
CREATE TABLE PRODUCTS (
    PRODUCTID INT,
    PRODUCTNAME VARCHAR(50),
    PRICE DECIMAL(10, 2),
    STOCK INT
);

-- Insert data into the PRODUCTS table
INSERT INTO PRODUCTS (PRODUCTID, PRODUCTNAME, PRICE, STOCK) VALUES
(2, 'New Product Name', 19.99, 50),
(16, 'Phone', 300.00, 2),
(19, 'Sample Product', 19.99, 100),
(24, 'Iphone 16', 1500.00, 4),
(25, 'Iphone 5', 500.00, 2);