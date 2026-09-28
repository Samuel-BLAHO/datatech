CREATE DATABASE superstore;

CREATE TABLE customers
(
    customer_id VARCHAR(20) PRIMARY KEY ,
    customer_name VARCHAR(100),
    segment VARCHAR(20),
    country VARCHAR(50),
    region VARCHAR(50)
);

CREATE Table products(
    product_id VARCHAR(20) PRIMARY KEY ,
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(100)
);

CREATE Table orders(
    order_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20),
    product_id VARCHAR(20),
    order_date DATE,
    ship_date DATE,
    sales DECIMAL(10,2),
    quantity INTEGER,
    discount DECIMAL(10,2),
    profit DECIMAL(10,2),
    Foreign Key (customer_id) REFERENCES customers (customer_id),
    Foreign Key (product_id) REFERENCES products (product_id)
);

SELECT * FROM customers;
SELECT * FROM products;