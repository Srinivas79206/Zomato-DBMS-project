CREATE DATABASE zomato;

USE zomato;

CREATE TABLE IF NOT EXISTS orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    item_id INT,
    quantity INT NOT NULL,
    delivery_address VARCHAR(255) NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data into orders table
INSERT INTO orders (user_id, item_id, quantity, delivery_address) VALUES
(1, 1, 2, '123 Main St'),
(2, 2, 1, '456 Oak Rd'),
(3, 3, 3, '789 Pine Ave');


CREATE TABLE IF NOT EXISTS categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL
);

-- Insert sample data into categories table
INSERT INTO categories (category_name) VALUES
('Vegetarian'),
('Non-Vegetarian'),
('Vegan');


CREATE TABLE IF NOT EXISTS items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    item_name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    category_id INT
);

-- Insert sample data into items table
INSERT INTO items (item_name, price, category_id) VALUES
('Biriyani', 150.00, 2),  -- Non-Vegetarian
('Paneer', 100.00, 1),    -- Vegetarian
('Butter Chicken', 200.00, 2);  -- Non-Vegetarian

CREATE TABLE IF NOT EXISTS order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    item_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10, 2),
    FOREIGN KEY (item_id) REFERENCES items(item_id)
);

-- Insert sample data into order_items table
INSERT INTO order_items (order_id, item_id, quantity, price) VALUES
(1, 1, 2, 150.00),
(2, 2, 1, 100.00),
(3, 3, 3, 200.00);

CREATE TABLE IF NOT EXISTS payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    payment_method VARCHAR(50),
    payment_status VARCHAR(50),
    amount DECIMAL(10, 2),
    paid_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data into payments table
INSERT INTO payments (order_id, payment_method, payment_status, amount) VALUES
(1, 'Credit Card', 'Paid', 300.00),
(2, 'Debit Card', 'Paid', 100.00),
(3, 'GPay', 'Pending', 600.00);


CREATE TABLE IF NOT EXISTS customers (
    user_id INT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    phone_number VARCHAR(15),
    email VARCHAR(255)
);

-- Insert sample data into customers table
INSERT INTO customers (user_id, first_name, last_name, phone_number, email) VALUES
(1, 'John', 'Doe', '123-456-7890', 'john.doe@example.com'),
(2, 'Jane', 'Smith', '987-654-3210', 'jane.smith@example.com'),
(3, 'Alice', 'Johnson', '111-222-3333', 'alice.johnson@example.com'),
(4, 'Bob', 'Brown', '444-555-6666', 'bob.brown@example.com'),
(5, 'Gowtham', 'Kumar', '777-888-9999', 'gowtham.kumar@example.com');



========== ETL ===================

1. Total Revenue from All Orders

SELECT SUM(oi.price * oi.quantity) AS total_revenue
FROM order_items oi;

2. Revenue by Item

SELECT i.item_name, SUM(oi.price * oi.quantity) AS total_revenue
FROM order_items oi
JOIN items i ON oi.item_id = i.item_id
GROUP BY i.item_name
ORDER BY total_revenue DESC;

3. Revenue by Payment Method

SELECT p.payment_method, SUM(p.amount) AS total_revenue
FROM payments p
JOIN orders o ON p.order_id = o.order_id
GROUP BY p.payment_method;

4. Total Revenue by Date

SELECT DATE(p.paid_at) AS date, SUM(p.amount) AS daily_revenue
FROM payments p
GROUP BY DATE(p.paid_at)
ORDER BY date;

5. Total Orders and Revenue by User

SELECT 
    u.first_name,
    u.last_name,
    u.phone_number,
    u.email,
    COUNT(o.order_id) AS total_orders,
    SUM(oi.price * oi.quantity) AS total_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN users u ON o.user_id = u.user_id
GROUP BY u.user_id
ORDER BY total_revenue DESC;

6. Items Ordered by Category

SELECT c.category_name, i.item_name, SUM(oi.quantity) AS total_quantity_ordered
FROM order_items oi
JOIN items i ON oi.item_id = i.item_id
JOIN categories c ON i.category_id = c.category_id
GROUP BY c.category_name, i.item_name
ORDER BY total_quantity_ordered DESC;

7. Orders by Payment Status

SELECT p.payment_status, COUNT(o.order_id) AS total_orders
FROM payments p
JOIN orders o ON p.order_id = o.order_id
GROUP BY p.payment_status;

8. Users with Most Orders

SELECT 
    u.first_name, 
    u.last_name, 
    COUNT(o.order_id) AS total_orders
FROM users u
JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id
ORDER BY total_orders DESC
LIMIT 5;

9. Revenue by Category

SELECT c.category_name, SUM(oi.price * oi.quantity) AS total_revenue
FROM order_items oi
JOIN items i ON oi.item_id = i.item_id
JOIN categories c ON i.category_id = c.category_id
GROUP BY c.category_name;

10. Items Purchased in Specific Order

SELECT oi.order_id, i.item_name, oi.quantity, oi.price
FROM order_items oi
JOIN items i ON oi.item_id = i.item_id
WHERE oi.order_id = 1;

11. Customer Details with Orders

SELECT 
    c.first_name, 
    c.last_name, 
    c.phone_number, 
    c.email, 
    o.order_id, 
    o.delivery_address, 
    oi.item_id, 
    oi.quantity
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN customers c ON o.user_id = c.user_id;

12. Revenue by Customer

SELECT 
    c.first_name, 
    c.last_name, 
    c.phone_number, 
    c.email, 
    SUM(oi.price * oi.quantity) AS total_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN customers c ON o.user_id = c.user_id
GROUP BY c.user_id
ORDER BY total_revenue DESC;
