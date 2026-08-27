-- ============================================================
-- 01 · SQL Introduction & Fundamentals
-- Schema: bookstore
-- ============================================================

-- 1. Create the database (run outside a transaction if needed)
-- CREATE DATABASE bookstore;

-- 2. Create the core tables that are reused across all modules
CREATE TABLE authors (
    author_id   SERIAL PRIMARY KEY,
    first_name  VARCHAR(50)  NOT NULL,
    last_name   VARCHAR(50)  NOT NULL,
    country     VARCHAR(50)
);

CREATE TABLE books (
    book_id     SERIAL PRIMARY KEY,
    title       VARCHAR(200) NOT NULL,
    author_id   INT          REFERENCES authors(author_id),
    genre       VARCHAR(50),
    price       NUMERIC(8,2),
    published   DATE
);

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    email       VARCHAR(100) UNIQUE NOT NULL,
    first_name  VARCHAR(50)  NOT NULL,
    last_name   VARCHAR(50)  NOT NULL,
    joined_at   TIMESTAMP    DEFAULT NOW()
);

CREATE TABLE orders (
    order_id    SERIAL PRIMARY KEY,
    customer_id INT  REFERENCES customers(customer_id),
    book_id     INT  REFERENCES books(book_id),
    quantity    INT  DEFAULT 1,
    ordered_at  TIMESTAMP DEFAULT NOW()
);

-- ----------------------------------------------------------------
-- 3. Seed data
-- ----------------------------------------------------------------
INSERT INTO authors (first_name, last_name, country) VALUES
    ('George',   'Orwell',     'UK'),
    ('Fyodor',   'Dostoevsky', 'Russia'),
    ('Toni',     'Morrison',   'USA'),
    ('Haruki',   'Murakami',   'Japan');

INSERT INTO books (title, author_id, genre, price, published) VALUES
    ('1984',                         1, 'Dystopian',  9.99,  '1949-06-08'),
    ('Animal Farm',                  1, 'Satire',     7.49,  '1945-08-17'),
    ('Crime and Punishment',         2, 'Classic',    11.99, '1866-01-01'),
    ('The Brothers Karamazov',       2, 'Classic',    13.49, '1880-11-01'),
    ('Beloved',                      3, 'Historical', 10.99, '1987-09-02'),
    ('Norwegian Wood',               4, 'Literary',   9.49,  '1987-09-04'),
    ('Kafka on the Shore',           4, 'Literary',   10.49, '2002-09-12');

INSERT INTO customers (email, first_name, last_name) VALUES
    ('alice@example.com', 'Alice', 'Walker'),
    ('bob@example.com',   'Bob',   'Chen'),
    ('cara@example.com',  'Cara',  'Patel');

INSERT INTO orders (customer_id, book_id, quantity) VALUES
    (1, 1, 1),
    (1, 6, 2),
    (2, 3, 1),
    (3, 5, 1),
    (3, 7, 1);

-- ----------------------------------------------------------------
-- 4. Basic SELECT queries
-- ----------------------------------------------------------------

-- Select all rows from a table
SELECT * FROM books;

-- Select specific columns
SELECT title, genre, price FROM books;

-- Select with a simple filter
SELECT title, price
FROM   books
WHERE  price < 10.00;

-- Select with column alias
SELECT title AS book_title, price AS cost
FROM   books;
