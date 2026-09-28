--Uloha 1
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

--Uloha 2
SELECT o.order_id,c.customer_name,o.sales FROM orders o INNER JOIN customers c ON c.customer_id = o.customer_id WHERE o.sales>500;

--Uloha 3
SELECT o.order_id,c.customer_name,p.category,o.sales FROM orders o inner JOIN customers c on c.customer_id = o.customer_id 
inner JOIN products p on p.product_id= o.product_id;

--Uloha 4
SELECT c.region,SUM(o.sales) FROM customers c inner JOIN orders o on o.customer_id = c.customer_id GROUP BY c.region;

--Uloha 5
SELECT p.product_name,Sum(o.sales) FROM products p INNER JOIN orders o on o.product_id=p.product_id GROUP BY p.product_name;