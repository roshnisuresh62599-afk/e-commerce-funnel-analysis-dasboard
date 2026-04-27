CREATE DATABASE funnel_project;
USE funnel_project;
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    signup_date DATE,
    city VARCHAR(50),
    device_type VARCHAR(20),
    acquisition_channel VARCHAR(50)
);
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    category VARCHAR(50),
    product_name VARCHAR(100),
    price INT,
    rating DECIMAL(2,1)
);
CREATE TABLE events (
    event_id INT PRIMARY KEY,
    user_id INT,
    event_type VARCHAR(30),
    product_id INT,
    event_time DATETIME
);
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    user_id INT,
    product_id INT,
    quantity INT,
    order_date DATE,
    revenue INT
);
SELECT COUNT(*) FROM users;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM events;
SELECT COUNT(*) FROM orders;
SELECT DISTINCT event_type FROM events;
SELECT COUNT(DISTINCT user_id) AS visitors
FROM events
WHERE event_type='product_view';
SELECT ROUND(
COUNT(DISTINCT CASE WHEN event_type='purchase' THEN user_id END)*100.0/
COUNT(DISTINCT CASE WHEN event_type='product_view' THEN user_id END),2
) AS conversion_rate
FROM events;
SELECT event_type, COUNT(*) AS total
FROM events
GROUP BY event_type;
SELECT p.product_name,
SUM(o.revenue) AS revenue
FROM orders o
JOIN products p
ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 10;
SELECT u.city,
SUM(o.revenue) AS revenue
FROM orders o
JOIN users u
ON o.user_id = u.user_id
GROUP BY u.city
ORDER BY revenue DESC;
SELECT user_id,
COUNT(order_id) AS total_orders
FROM orders
GROUP BY user_id
HAVING COUNT(order_id) > 1
ORDER BY total_orders DESC;
SELECT DATE_FORMAT(order_date,'%Y-%m') AS month,
SUM(revenue) AS revenue
FROM orders
GROUP BY month
ORDER BY month;
SELECT user_id,
SUM(revenue) AS total_spent,
RANK() OVER(ORDER BY SUM(revenue) DESC) AS rank_num
FROM orders
GROUP BY user_id;