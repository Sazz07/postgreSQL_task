CREATE DATABASE bookstore_db;
\c bookstore_db;

CREATE TABLE books (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    price NUMERIC(10,2) CHECK (price >= 0),
    stock INTEGER CHECK (stock >= 0),
    published_year INTEGER CHECK (published_year > 0)
);


CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    joined_date DATE DEFAULT CURRENT_DATE
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(id),
    book_id INTEGER REFERENCES books(id),
    quantity INTEGER CHECK (quantity > 0),
    order_date DATE DEFAULT CURRENT_DATE
);

-- Inserting sample data into the tables
INSERT INTO books (id, title, author, price, stock, published_year) VALUES
(1, 'The Pragmatic Programmer', 'Andrew Hunt', 40.00, 10, 1999),
(2, 'Clean Code', 'Robert C. Martin', 35.00, 5, 2008),
(3, 'You Don''t Know JS', 'Kyle Simpson', 30.00, 8, 2014),
(4, 'Refactoring', 'Martin Fowler', 50.00, 3, 1999),
(5, 'Database Design Principles', 'Jane Smith', 20.00, 0, 2018);

INSERT INTO customers (id, name, email, joined_date) VALUES
(1, 'Alice', 'alice@email.com', '2023-01-10'),
(2, 'Bob', 'bob@email.com', '2022-05-15'),
(3, 'Charlie', 'charlie@email.com', '2023-06-20');


INSERT INTO orders (id, customer_id, book_id, quantity, order_date) VALUES
(1, 1, 2, 1, '2024-03-10'),
(2, 2, 1, 1, '2024-02-20'),
(3, 1, 3, 2, '2024-03-05');



-- 1️⃣ Find books that are out of stock.
SELECT title FROM books
WHERE stock = 0;

-- 2️⃣ Retrieve the most expensive book in the store.
SELECT * FROM books 
ORDER BY price DESC 
LIMIT 1;

-- 3️⃣ Find the total number of orders placed by each customer.
SELECT customers.name, COUNT(*) as total_orders
FROM customers
JOIN orders ON customers.id=orders.customer_id
GROUP BY customers.name;

-- 4️⃣ Calculate the total revenue generated from book sales.
SELECT SUM(price*quantity) AS total_revenue
FROM books
JOIN orders ON books.id = orders.book_id;

-- 5️⃣ List all customers who have placed more than one order.
SELECT customers.name, COUNT(*) as orders_count
FROM customers
JOIN orders ON customers.id=orders.customer_id
GROUP BY customers.name
HAVING COUNT(*) > 1;

-- 6️⃣ Find the average price of books in the store.
SELECT AVG(price) AS avg_book_price FROM books;

-- 7️⃣ Increase the price of all books published before 2000 by 10%.
UPDATE books
SET price = price + (price * 0.10)
WHERE published_year < 2000;

-- 8️⃣ Delete customers who haven't placed any orders.
DELETE FROM customers
WHERE id NOT IN (SELECT DISTINCT customer_id FROM orders);