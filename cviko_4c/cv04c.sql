-- Active: 1791132784653@@127.0.0.1@5432@retail

--Uloha1
CREATE DATABASE retail;
CREATE Table retail_sales(   
    invoice_no VARCHAR(20),
    stock_code VARCHAR(50),
    description VARCHAR,
    quantity INTEGER,
    invoice_date DATE,
    unit_price DECIMAL(10,2),
    customer_id INTEGER,
    country VARCHAR(100)
);

SELECT *
FROM retail_sales;

--Uloha2

