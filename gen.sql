DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS brands;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS reviews;
-- 1. USERS TABLE
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    address TEXT,
    role VARCHAR(20) DEFAULT 'customer', -- 'admin' or 'customer'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. CATEGORIES TABLE
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

-- 3. BRANDS TABLE
CREATE TABLE brands (
    brand_id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

-- 4. PRODUCTS TABLE
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    image_url TEXT,
    category_id INT REFERENCES categories(category_id),
    brand_id INT REFERENCES brands(brand_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. ORDERS TABLE
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'pending', -- 'pending', 'shipped', 'delivered', 'cancelled'
    total_amount DECIMAL(10,2) NOT NULL,
    shipping_address TEXT
);

-- 6. ORDER_ITEMS TABLE
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id INT REFERENCES products(product_id),
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL
);

-- 7. PAYMENTS TABLE
CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id) ON DELETE CASCADE,
    amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(50), -- e.g., 'Credit Card', 'PayPal'
    status VARCHAR(20) DEFAULT 'pending', -- 'paid', 'failed', 'pending'
    paid_at TIMESTAMP
);

-- 8. REVIEWS TABLE (optional)
CREATE TABLE reviews (
    review_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    product_id INT REFERENCES products(product_id),
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (user_id, name, email, password_hash, phone_number, address, role, created_at, updated_at)
VALUES
(1, 'Alice Smith', 'alice@example.com', 'hashed_pw_alice', '1234567890', '123 Tech St, Silicon Valley', 'customer', '2025-07-01 10:00:00', '2025-07-01 10:00:00'),
(2, 'Bob Johnson', 'bob@example.com', 'hashed_pw_bob', '0987654321', '456 Code Ave, New York', 'customer', '2025-07-02 11:00:00', '2025-07-02 11:00:00'),
(3, 'Admin User', 'admin@example.com', 'hashed_pw_admin', '0000000000', '789 Admin Blvd, HQ', 'admin', '2025-07-03 12:00:00', '2025-07-03 12:00:00');

INSERT INTO categories (category_id, name)
VALUES
(1, 'Smartphones'),
(2, 'Laptops'),
(3, 'Accessories');

INSERT INTO brands (brand_id, name)
VALUES
(1, 'Apple'),
(2, 'Samsung'),
(3, 'Dell'),
(4, 'Logitech');

INSERT INTO products (product_id, name, description, price, stock_quantity, image_url, category_id, brand_id)
VALUES
(1, 'iPhone 14', 'Latest Apple smartphone with A15 chip', 999.99, 10, 'http://example.com/iphone14.jpg', 1, 1),
(2, 'Galaxy S22', 'Samsung flagship phone', 899.50, 15, 'http://example.com/galaxys22.jpg', 1, 2),
(3, 'Dell XPS 13', 'High-performance laptop for professionals', 1199.00, 8, 'http://example.com/dellxps13.jpg', 2, 3),
(4, 'Logitech Mouse', 'Wireless ergonomic mouse', 49.99, 30, 'http://example.com/logitechmouse.jpg', 3, 4);

INSERT INTO orders (order_id, user_id, order_date, status, total_amount, shipping_address)
VALUES
(1, 1, CURRENT_TIMESTAMP, 'shipped', 1049.98, '123 Tech St, Silicon Valley'),
(2, 2, CURRENT_TIMESTAMP, 'pending', 899.50, '456 Code Ave, New York');

-- Order 1: Alice buys iPhone and Mouse
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price)
VALUES
(1, 1, 1, 1, 999.99), -- iPhone 14
(2, 1, 4, 1, 49.99);  -- Logitech Mouse

-- Order 2: Bob buys Galaxy S22
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price)
VALUES
(3, 2, 2, 1, 899.50); -- Galaxy S22

INSERT INTO payments (payment_id, order_id, amount, payment_method, status, paid_at)
VALUES
(1, 1, 1049.98, 'Credit Card', 'paid', CURRENT_TIMESTAMP),
(2, 2, 899.50, 'PayPal', 'pending', NULL);

INSERT INTO reviews (review_id, user_id, product_id, rating, comment)
VALUES
(1, 1, 1, 5, 'Absolutely love my iPhone!'),
(2, 2, 2, 4, 'Great phone, but a bit pricey.'),
(3, 1, 4, 5, 'This mouse is super comfortable.');
