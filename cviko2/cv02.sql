-- Active: 1791132784653@@127.0.0.1@5432@datacraftinglab_db@public
CREATE DATABASE datacraftinglab_db;
DROP Table flourmills_sales;
CREATE Table flourmills_sales(
    sales_id INT PRIMARY KEY,
    sale_date DATE,
    region VARCHAR(100),
    state VARCHAR(100),
    product_category VARCHAR(100),
    product_name VARCHAR(150),
    customer_type VARCHAR(100),
    customer_id INT,
    quantity_sold INT,
    unit_price DECIMAL(10,2),
    discount_rate INT,
    payment_method VARCHAR(100),
    sales_rep VARCHAR(150),
    warehouse VARCHAR(100),
    delivery_status VARCHAR(100),
    order_channel VARCHAR(100),
    batch_number INT,
    production_date DATE,
    total_amount DECIMAL(10,2)
);
SELECT * FROM flourmills_sales;

--Uloha1
SELECT product_name,total_amount FROM flourmills_sales
WHERE total_amount>(SELECT avg(total_amount) FROM flourmills_sales);

--Uloha2
SELECT sales_id,sale_date,region,product_category FROM flourmills_sales 
WHERE product_category =(SELECT product_category FROM flourmills_sales 
GROUP BY product_category ORDER BY sum(total_amount) DESC LIMIT 1)
ORDER BY sales_id ASC;

--Uloha3
SELECT product_name,total_amount,(SELECT avg(total_amount) FROM flourmills_sales) as avg_amount FROM flourmills_sales;

--Uloha4
SELECT product_name, total_amount, total_amount / (SELECT sum(total_amount)  FROM flourmills_sales ) as amount_share
FROM flourmills_sales ;

--Uloha5
SELECT month,monthly_sales FROM (SELECT EXTRACT(MONTH FROM sale_date) AS month, SUM(total_amount) AS monthly_sales
FROM flourmills_sales GROUP BY EXTRACT(MONTH FROM sale_date) ) AS monthly_summary ORDER BY monthly_sales DESC;

--Uloha6
SELECT product_category, total_sales FROM ( SELECT product_category, SUM(total_amount)
AS total_sales FROM flourmills_sales GROUP BY product_category) AS category_summary 
WHERE total_sales > 50000000 ORDER BY total_sales DESC;

--Uloha7
SELECT COUNT(*) AS pocet_transakcii FROM flourmills_sales f1
WHERE f1.total_amount > ( SELECT AVG(f2.total_amount) FROM flourmills_sales f2 WHERE f2.product_category = f1.product_category);

--Uloha8
SELECT f1.product_name,f1.region,f1.total_amount,(SELECT MIN(f2.total_amount)
FROM flourmills_sales f2 WHERE f2.region = f1.region) AS region_min_amount FROM flourmills_sales f1;

--Uloha9
SELECT f1.product_name,f1.product_category,f1.sale_date,f1.total_amountFROM flourmills_sales f1
WHERE EXISTS (SELECT 1FROM flourmills_sales f2WHERE f2.product_name = f1.product_name 
GROUP BY f2.product_nameHAVING COUNT(DISTINCT EXTRACT(MONTH FROM f2.sale_date)) > 1);

--Uloha10
SELECT f1.product_category,f1.product_name,f1.total_amount FROM flourmills_sales f1 WHERE EXISTS (
SELECT 1 FROM flourmills_sales f2 WHERE f2.product_category = f1.product_category AND f2.total_amount > 200000);

--Uloha11
SELECT f1.product_category FROM flourmills_sales f1 WHERE EXISTS ( SELECT 1 FROM flourmills_sales f2
WHERE f2.product_category = f1.product_category GROUP BY f2.product_category 
HAVING COUNT(DISTINCT f2.region) > 3)GROUP BY f1.product_category;

--Uloha12
SELECT f1.* FROM flourmills_sales f1 WHERE EXISTS (SELECT 1
FROM flourmills_sales f2 WHERE f2.region = f1.region AND EXTRACT(YEAR FROM f2.sale_date) = 2024);

--Uloha13
SELECT COUNT(*) AS pocet_kategorii FROM (SELECT f1.product_category FROM flourmills_sales f1 
WHERE NOT EXISTS (SELECT 1 FROM flourmills_sales f2 WHERE f2.product_category = f1.product_category 
AND f2.total_amount > 500000)GROUP BY f1.product_category) AS kategorie;

--Uloha14
SELECT DISTINCT f1.region FROM flourmills_sales f1 WHERE NOT EXISTS (SELECT 1 
FROM flourmills_sales f2 WHERE f2.region = f1.region AND f2.product_category = 'Flour');