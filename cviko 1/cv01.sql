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
SELECT c.region,o.sales FROM customers c inner JOIN orders o on o.customer_id = c.customer_id GROUP BY c.region;

--Uloha 5
SELECT p.product_name,Sum(o.sales) FROM products p LEFT JOIN orders o on o.product_id=p.product_id GROUP BY p.product_name;

--Uloha 6
SELECT c.customer_name,o.order_id,o.sales FROM customers c full outer  JOIN orders o ON c.customer_id = o.customer_id

--Uloha 7
SELECT c.region,SUM(o.sales) FROM customers c inner JOIN orders o on o.customer_id

--Uloha 8
SELECT c.customer_name, count(o.customer_id) from customers c Left JOIN orders o ON o.customer_id =c.customer_id  group by customer_name;

--Uloha 9
SELECT p.category,avg(o.discount) FROM products p INNER JOIN orders o ON p.product_id = o.product_id GROUP BY p.category;

--Uloha 10
SELECT c.customer_name,sum(o.sales) as celkova_hod from customers c inner JOIN orders o On o.customer_id = c.customer_id group by c.customer_name having sum(o.sales)>2000;

--Uloha 11
SELECT sum(o.sales),avg(o.discount),count(o.order_id) from orders o inner JOIN customers c on c.customer_id = o.customer_id GROUP BY c.region;

 --Uloha 12
SELECT c.region,COUNT(CASE WHEN o.sales > 1000 THEN 1  END) AS high_value,
COUNT(CASE WHEN o.sales <= 1000 THEN 1 END) AS low_value FROM customers c 
INNER JOIN orders o ON o.customer_id = c.customer_id GROUP BY c.region;

--Uloha 13
SELECT c.customer_name,SUM(o.sales) AS celkovy_predaj,AVG(o.discount) AS priemerna_zlava,COUNT(o.order_id) AS pocet_objednavok,
CASE WHEN SUM(o.sales) > 2500 THEN 'VIP' ELSE 'REGULAR' END AS typ_zakaznika FROM customers c
INNER JOIN orders o ON o.customer_id = c.customer_id GROUP BY c.customer_id, c.customer_name ORDER BY celkovy_predaj DESC;