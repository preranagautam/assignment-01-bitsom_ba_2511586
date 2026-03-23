-- Q1: List all customers along with the total number of orders they have placed
SELECT
    c.customer_id,
    c.name                 AS customer_name,
    c.city,
    COUNT(o.order_id)      AS total_orders
FROM       read_csv_auto('datasets/customers.csv')  c
LEFT JOIN  read_json_auto('datasets/orders.json')   o  ON c.customer_id = o.customer_id
GROUP BY   c.customer_id, c.name, c.city
ORDER BY   total_orders DESC, c.name;


-- Q2: Find the top 3 customers by total order value
SELECT
    c.customer_id,
    c.name                   AS customer_name,
    c.city,
    COUNT(o.order_id)        AS total_orders,
    SUM(o.total_amount)      AS total_order_value
FROM       read_csv_auto('datasets/customers.csv')  c
JOIN       read_json_auto('datasets/orders.json')   o  ON c.customer_id = o.customer_id
GROUP BY   c.customer_id, c.name, c.city
ORDER BY   total_order_value DESC
LIMIT 3;


-- Q3: List all products purchased by customers from Bangalore
SELECT DISTINCT
    c.customer_id,
    c.name                   AS customer_name,
    p.product_id,
    p.product_name,
    p.category
FROM       read_csv_auto('datasets/customers.csv')   c
JOIN       read_json_auto('datasets/orders.json')    o  ON c.customer_id = o.customer_id
JOIN       read_parquet('datasets/products.parquet') p  ON o.order_id    = p.order_id
WHERE      c.city = 'Bangalore'
ORDER BY   c.name, p.category, p.product_name;


-- Q4: Join all three files to show: customer name, order date, product name, and quantity
SELECT
    c.name                       AS customer_name,
    c.city,
    o.order_id,
    CAST(o.order_date AS DATE)   AS order_date,
    o.status,
    p.product_name,
    p.category,
    p.quantity
FROM       read_csv_auto('datasets/customers.csv')   c
JOIN       read_json_auto('datasets/orders.json')    o  ON c.customer_id = o.customer_id
JOIN       read_parquet('datasets/products.parquet') p  ON o.order_id    = p.order_id
ORDER BY   order_date, c.name, p.product_name;