-- Active: 1791132784653@@127.0.0.1@5432@superstore
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


--Uloha1
with new_orders as(
    SELECT c.customer_name, o.order_id, o.order_date,
           ROW_NUMBER() OVER (PARTITION BY c.customer_name ORDER BY o.order_date) AS order_rank
    FROM orders o
    INNER JOIN customers c ON o.customer_id = c.customer_id
)
SELECT customer_name, order_id, order_date 
from new_orders
where order_rank <=2;

--Uloha2
with customer_orders as (
    select c.region,c.customer_name, sum(o.profit) as total_profit
    from orders o
    inner join customers c on o.customer_id = c.customer_id
     group by c.region, c.customer_name
)
select region, customer_name, total_profit,
    rank() over (partition by region order by total_profit desc) as profit_rank,
    dense_rank() over (partition by region order by total_profit desc) as profit_dense_rank
from customer_orders;

--Uloha3
with customer_orders as (
    select c.customer_name, sum(o.sales) as total_sales
    from orders o
    inner join customers c on o.customer_id = c.customer_id
    group by c.customer_name
)
select customer_name,total_sales,
ntile(4) over(order by total_sales DESC) as quartile
from customer_orders;

--Uloha4
with month_sales as(
    select date_trunc('month', order_date) as month, sum(sales) as monthly_sales
    from orders 
    group by month
)
select month,monthly_sales,
lag(monthly_sales) over(order by month) as prev_month_sales,
lead(monthly_sales) over(order by month) as next_month_sales
from month_sales
order by month ASC;

--Uloha5
SELECT 
    p.category,
    p.product_name,
    SUM(o.sales) AS product_sales,
    SUM(SUM(o.sales)) OVER (PARTITION BY p.category) AS category_total,
    ROUND(
        SUM(o.sales) * 100.0 /
        SUM(SUM(o.sales)) OVER (PARTITION BY p.category),
        2
    ) AS pct_of_category
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.category, p.product_name;

with category_sales as (
    SELECT p.category,p.product_name,SUM(o.sales) AS product_sales
    FROM orders o
    JOIN products p ON o.product_id = p.product_id
    GROUP BY p.product_name, p.category
),category_totals as (
select category, product_name, product_sales,
sum(product_sales) over(partition by category) as category_total
from category_sales
)
select category, product_name, product_sales, category_total,
ROUND(product_sales* 100.0 /category_total,2) AS pct_of_category
from category_totals;

