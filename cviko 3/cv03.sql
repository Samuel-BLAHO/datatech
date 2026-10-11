-- Active: 1790616889982@@127.0.0.1@5432@retail_sales
--Uloha1
create View high_value_customers AS
select c.customer_id,c.customer_name, sum(o.sales) FROM customers c
inner join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name having sum(o.sales) > 2000;
SELECT *
FROM high_value_customers;

--Uloha2
create View regional_monthly_sales AS
select c.region, DATE_TRUNC('month', o.order_date) as month, sum(o.sales) as total_sales
from customers c
inner join orders o on c.customer_id = o.customer_id
group by c.region, DATE_TRUNC('month', o.order_date);
select *
from regional_monthly_sales
where region = 'West';

--Uloha3
create View analyst_orders AS
select order_id,customer_id,product_id,sales,discount FROM orders;
select *
from analyst_orders;

--Uloha4
create INDEX idx_orders_customer_id ON orders(customer_id);
SELECT *
FROM orders
WHERE customer_id = 'C001';

--Uloha5
create INDEX idx_orders_order_date ON orders(order_date);
SELECT DATE_TRUNC('month', order_date) as month, SUM(sales) as total_sales 
FROM orders
GROUP BY DATE_TRUNC('month', order_date)
order by month ASC;

--Uloha6
create INDEX idx_orders_region_category ON orders(customer_id, order_date);
SELECT c.customer_name, o.profit FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
WHERE c.region = 'West' AND o.order_date >= '2024-01-01';


--Uloha7
EXPLAIN ANALYZE
SELECT *
FROM orders
WHERE customer_id = 'C001';


Create DATABASE retail_sales;

create TABLE orders (
    order_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    product_id VARCHAR(20) NOT NULL,
    order_date DATE NOT NULL,
    region VARCHAR(20)not null,
    category VARCHAR(50) not null,
    ship_mode VARCHAR(30) not null,
    sales DECIMAL(10,2) not null,
    profit DECIMAL(10,2) not null
);
alter DATABASE retail_sales SET datestyle = 'ISO, MDY';

SELECT *
FROM orders;

--Uloha8
CREATE PROCEDURE get_customer_sales(
    p_customer_id VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_total_sales DECIMAL(10,2);
BEGIN
    SELECT COALESCE(SUM(sales), 0)
    INTO v_total_sales
    FROM orders
    WHERE customer_id = p_customer_id;

    RAISE NOTICE 'Customer ID: %, Total Sales: %',
        p_customer_id, v_total_sales;
END;
$$;
CALL get_customer_sales('C001');

--Uloha9
CREATE OR REPLACE PROCEDURE apply_regional_discount(
    region_name VARCHAR,
    discount_rate decimal(5,2)
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE orders
    SET sales = sales * (1 - discount_rate)
    WHERE region = region_name;

    RAISE NOTICE 'Discount of % applied to region %',
        discount_rate * 100, region_name;
END;
$$;

CALL apply_regional_discount('West', 0.10);

--Uloha10
CREATE OR REPLACE PROCEDURE get_sales_between(
    start_date DATE,
    end_date DATE
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_total_sales NUMERIC;
BEGIN
    SELECT COALESCE(SUM(sales), 0)
    INTO v_total_sales
    FROM orders
    WHERE order_date BETWEEN start_date AND end_date;

    RAISE NOTICE 'Period: % to %, Total sales: %',
        start_date, end_date, v_total_sales;
END;
$$;

CALL get_sales_between('2024-01-01', '2024-03-31');