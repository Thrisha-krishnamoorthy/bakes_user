create database bakes_db;
use bakes_db;
show databases;
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(15) NOT NULL,
    address TEXT,
    role ENUM('user', 'admin') NOT NULL DEFAULT 'user',
    password_hash VARCHAR(255) NOT NULL
);
SELECT phone, COUNT(*) 
FROM Users
GROUP BY phone
HAVING COUNT(*) > 1;


ALTER TABLE Users ADD CONSTRAINT unique_phone UNIQUE (phone);

show tables;
select * from Users;
CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    image_url VARCHAR(255),
    category VARCHAR(255)
);
select * from Products;
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    order_status ENUM('pending', 'shipped', 'delivered') NOT NULL DEFAULT 'pending',
    total_price DECIMAL(10, 2) NOT NULL,
    delivery_type ENUM('pickup', 'delivery') NOT NULL,
    delivery_address TEXT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);
select * from Orders;
-- First, drop any existing payment_method column if it exists

ALTER TABLE Orders
ADD COLUMN advance_payment DECIMAL(10, 2) DEFAULT 0;
ALTER TABLE Orders 
MODIFY COLUMN order_status ENUM('pending', 'order confirmation', 'baked', 'shipped', 'delivered') 
NOT NULL DEFAULT 'pending';
-- Verify the change
DESCRIBE Orders;

-- Then add the payment_method column with the correct ENUM values
ALTER TABLE Orders
ADD COLUMN payment_method ENUM('cod', 'advance') NOT NULL DEFAULT 'cod';
ALTER TABLE Orders 

ADD COLUMN payment_status ENUM('not paid', 'advance paid', 'full paid') NOT NULL DEFAULT 'not paid';
ALTER TABLE Orders
MODIFY COLUMN order_status ENUM('order confirmation', 'baked', 'shipped', 'delivered') NOT NULL DEFAULT 'order confirmation';
SELECT * FROM users WHERE user_id = 3;
CREATE TABLE Order_Items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE
);
select *from Order_Items;
SELECT DISTINCT order_status FROM Orders;
UPDATE Orders 
SET order_status = 'order confirmation' 
WHERE order_status = 'pending';
ALTER TABLE Orders  
MODIFY COLUMN order_status ENUM('pending', 'shipped', 'delivered', 'order confirmation', 'baked') 
NOT NULL DEFAULT 'pending';
ALTER TABLE Orders  
MODIFY COLUMN order_status ENUM('order confirmation', 'baked', 'shipped', 'delivered') 
NOT NULL DEFAULT 'order confirmation';

SELECT 
    Orders.order_id,
    Users.name AS customer_name,
    Users.email,
    Users.phone,
    Orders.order_status,
    Orders.total_price,
    Orders.payment_status,
    Orders.delivery_type,
    Orders.delivery_address,
    Products.name AS product_name,
    Order_Items.quantity,
    Order_Items.price AS item_price
FROM 
    Orders
JOIN 
    Users ON Orders.user_id = Users.user_id
JOIN 
    Order_Items ON Orders.order_id = Order_Items.order_id
JOIN 
    Products ON Order_Items.product_id = Products.product_id;
CREATE TABLE IF NOT EXISTS admins (
    admin_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL
);
select * from admins;
ALTER TABLE products ADD COLUMN quantity INT NOT NULL DEFAULT 0;
ALTER TABLE products ADD COLUMN status ENUM('in_stock', 'out_of_stock') NOT NULL DEFAULT 'in_stock';
show tables;
