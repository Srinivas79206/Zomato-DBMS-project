CREATE DATABASE IF NOT EXISTS zomato;

USE zomato;

-- Categories table
CREATE TABLE IF NOT EXISTS categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL
);

-- Insert categories
INSERT INTO categories (category_name) VALUES
('Vegetarian'),
('Non-Vegetarian'),
('Vegan'),
('Beverages'),
('Desserts');

-- Items table
CREATE TABLE IF NOT EXISTS items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    item_name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    category_id INT,
    description TEXT,
    image_url VARCHAR(500),
    rating DECIMAL(2,1) DEFAULT 4.0,
    is_bestseller BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Insert menu items (more variety)
INSERT INTO items (item_name, price, category_id, description, image_url, rating, is_bestseller) VALUES
-- Non-Vegetarian
('Chicken Biriyani', 250.00, 2, 'Aromatic basmati rice with tender chicken pieces, cooked with special spices', 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=400', 4.5, TRUE),
('Butter Chicken', 280.00, 2, 'Creamy tomato-based curry with tender chicken chunks', 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?w=400', 4.6, TRUE),
('Chicken Tikka', 220.00, 2, 'Marinated chicken pieces grilled to perfection in a tandoor', 'https://images.unsplash.com/photo-1599487488170-d11ec9c172f0?w=400', 4.3, FALSE),
('Mutton Rogan Josh', 350.00, 2, 'Slow-cooked mutton in a rich aromatic Kashmiri gravy', 'https://images.unsplash.com/photo-1574653853027-5382a3d23a15?w=400', 4.4, FALSE),
('Fish Fry', 200.00, 2, 'Crispy fried fish marinated with coastal spices', 'https://images.unsplash.com/photo-1534766555764-ce878a4e2da1?w=400', 4.2, FALSE),
('Egg Biriyani', 180.00, 2, 'Fragrant rice layered with spiced boiled eggs', 'https://images.unsplash.com/photo-1642821373181-696a54913e93?w=400', 4.1, FALSE),

-- Vegetarian
('Paneer Butter Masala', 200.00, 1, 'Soft paneer cubes in rich creamy tomato gravy', 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?w=400', 4.5, TRUE),
('Veg Biriyani', 180.00, 1, 'Fragrant basmati rice with mixed vegetables and aromatic spices', 'https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=400', 4.2, FALSE),
('Dal Makhani', 160.00, 1, 'Creamy black lentils slow-cooked overnight with butter and cream', 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=400', 4.4, TRUE),
('Palak Paneer', 190.00, 1, 'Fresh spinach curry with soft paneer cubes', 'https://images.unsplash.com/photo-1618449840665-9ed506d73a34?w=400', 4.3, FALSE),
('Chole Bhature', 150.00, 1, 'Spicy chickpea curry served with fluffy fried bread', 'https://images.unsplash.com/photo-1626132647523-66f5bf380027?w=400', 4.5, TRUE),
('Masala Dosa', 120.00, 1, 'Crispy crepe filled with spiced potato filling', 'https://images.unsplash.com/photo-1630383249896-424e482df921?w=400', 4.6, TRUE),

-- Vegan
('Veg Manchurian', 140.00, 3, 'Deep-fried vegetable balls in tangy Indo-Chinese sauce', 'https://images.unsplash.com/photo-1645177628172-a94c1f96e6db?w=400', 4.1, FALSE),
('Aloo Gobi', 130.00, 3, 'Dry-roasted cauliflower and potatoes with Indian spices', 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=400', 4.0, FALSE),

-- Beverages
('Mango Lassi', 80.00, 4, 'Refreshing yogurt drink blended with sweet mangoes', 'https://images.unsplash.com/photo-1527661591475-527312dd65f5?w=400', 4.7, TRUE),
('Masala Chai', 40.00, 4, 'Traditional Indian tea brewed with aromatic spices', 'https://images.unsplash.com/photo-1564890369478-c89ca6d9cde9?w=400', 4.5, FALSE),
('Fresh Lime Soda', 60.00, 4, 'Chilled lime juice with soda, sugar and a pinch of salt', 'https://images.unsplash.com/photo-1513558161293-cdaf765ed514?w=400', 4.3, FALSE),
('Cold Coffee', 100.00, 4, 'Blended cold coffee with ice cream and chocolate syrup', 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=400', 4.4, FALSE),

-- Desserts
('Gulab Jamun', 90.00, 5, 'Soft milk-solid balls soaked in rose-flavored sugar syrup', 'https://images.unsplash.com/photo-1666190060498-0aaae2470a51?w=400', 4.6, TRUE),
('Rasmalai', 110.00, 5, 'Soft cottage cheese patties soaked in sweetened, flavored milk', 'https://images.unsplash.com/photo-1645177628172-a94c1f96e6db?w=400', 4.5, FALSE),
('Ice Cream Sundae', 150.00, 5, 'Three scoops of ice cream with chocolate sauce and nuts', 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=400', 4.4, FALSE);

-- Customers table
CREATE TABLE IF NOT EXISTS customers (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    phone_number VARCHAR(15),
    email VARCHAR(255)
);

-- Insert sample customers
INSERT INTO customers (first_name, last_name, phone_number, email) VALUES
('John', 'Doe', '123-456-7890', 'john.doe@example.com'),
('Jane', 'Smith', '987-654-3210', 'jane.smith@example.com'),
('Alice', 'Johnson', '111-222-3333', 'alice.johnson@example.com'),
('Bob', 'Brown', '444-555-6666', 'bob.brown@example.com'),
('Srinivas', 'Kumar', '777-888-9999', 'srinivas.kumar@example.com');

-- Orders table
CREATE TABLE IF NOT EXISTS orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    item_id INT,
    quantity INT NOT NULL,
    delivery_address VARCHAR(255) NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) DEFAULT 'Placed',
    FOREIGN KEY (item_id) REFERENCES items(item_id)
);

-- Insert sample orders
INSERT INTO orders (user_id, item_id, quantity, delivery_address) VALUES
(1, 1, 2, '123 Main St'),
(2, 7, 1, '456 Oak Rd'),
(3, 2, 3, '789 Pine Ave');

-- Order items table
CREATE TABLE IF NOT EXISTS order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    item_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (item_id) REFERENCES items(item_id)
);

-- Insert sample order items
INSERT INTO order_items (order_id, item_id, quantity, price) VALUES
(1, 1, 2, 250.00),
(2, 7, 1, 200.00),
(3, 2, 3, 280.00);

-- Payments table
CREATE TABLE IF NOT EXISTS payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    payment_method VARCHAR(50),
    payment_status VARCHAR(50),
    amount DECIMAL(10, 2),
    paid_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Insert sample payments
INSERT INTO payments (order_id, payment_method, payment_status, amount) VALUES
(1, 'Credit Card', 'Paid', 500.00),
(2, 'Debit Card', 'Paid', 200.00),
(3, 'GPay', 'Pending', 840.00);
