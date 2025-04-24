CREATE DATABASE ecommerce_dbs;
USE ecommerce_dbs;
-- Customers
CREATE TABLE customers (
  customer_id INT PRIMARY KEY,
  name VARCHAR(100), 
  email VARCHAR(100),
  join_date DATE
);

INSERT INTO customers VALUES
(1, 'Alice', 'alice@example.com', '2023-06-01'),
(2, 'Bob', 'bob@example.com', '2024-01-15');

-- Products
CREATE TABLE products (
  product_id INT PRIMARY KEY,
  name VARCHAR(100),
  category VARCHAR(50),
  price DECIMAL(10,2)
);

INSERT INTO products VALUES
(1, 'Laptop', 'Electronics', 1200.00),
(2, 'Phone', 'Electronics', 800.00),
(3, 'Desk', 'Furniture', 150.00);

-- Orders
CREATE TABLE orders (
  order_id INT PRIMARY KEY,
  customer_id INT,
  order_date DATE,
  total_amount DECIMAL(10,2),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO orders VALUES
(1, 1, '2024-04-10', 1950.00),
(2, 2, '2024-04-18', 800.00);

-- Order Items
CREATE TABLE order_items (
  order_item_id INT PRIMARY KEY,
  order_id INT,
  product_id INT,
  quantity INT,
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO order_items VALUES
(1, 1, 1, 1),  
(2, 1, 3, 5),  
(3, 2, 2, 1); 

SELECT * FROM customers
WHERE join_date >= '2024-01-01'
ORDER BY join_date DESC;

SELECT c.name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

SELECT o.order_id, p.name AS product_name, oi.quantity, p.price, (p.price * oi.quantity) AS total_price
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id;

SELECT name FROM customers
WHERE customer_id IN (
  SELECT customer_id FROM orders
  GROUP BY customer_id
  HAVING SUM(total_amount) > 1000
);

SELECT name FROM customers
WHERE customer_id IN (
  SELECT customer_id FROM orders
  GROUP BY customer_id
  HAVING SUM(total_amount) > 1000
);
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
