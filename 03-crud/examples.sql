-- ============================================================
-- 03 · CRUD Operations
-- Schema: bookstore
-- ============================================================

-- ----------------------------------------------------------------
-- CREATE (INSERT)
-- ----------------------------------------------------------------

-- Insert a single row
INSERT INTO authors (first_name, last_name, country)
VALUES ('Leo', 'Tolstoy', 'Russia');

-- Insert multiple rows at once
INSERT INTO books (title, author_id, genre, price, published)
VALUES
    ('War and Peace',  5, 'Classic', 14.99, '1869-01-01'),
    ('Anna Karenina',  5, 'Classic', 12.99, '1877-01-01');

-- Insert and return the generated id
INSERT INTO customers (email, first_name, last_name)
VALUES ('dan@example.com', 'Dan', 'Russo')
RETURNING customer_id;


-- ----------------------------------------------------------------
-- READ (SELECT)
-- ----------------------------------------------------------------

-- Read all books
SELECT * FROM books;

-- Read with filter
SELECT title, price
FROM   books
WHERE  genre = 'Classic';

-- Read with ordering
SELECT title, price
FROM   books
ORDER BY price DESC;

-- Read with LIMIT + OFFSET (pagination)
SELECT title, price
FROM   books
ORDER BY price DESC
LIMIT  3 OFFSET 0;


-- ----------------------------------------------------------------
-- UPDATE
-- ----------------------------------------------------------------

-- Update a single column for one row
UPDATE books
SET    price = 8.99
WHERE  book_id = 2;

-- Update multiple columns
UPDATE authors
SET    first_name = 'George Herbert',
       country    = 'United Kingdom'
WHERE  author_id = 1;

-- Update based on a subquery
UPDATE books
SET    price = price * 0.90       -- 10 % discount
WHERE  author_id = (
    SELECT author_id FROM authors WHERE last_name = 'Orwell'
);


-- ----------------------------------------------------------------
-- DELETE
-- ----------------------------------------------------------------

-- Delete a specific row
DELETE FROM orders
WHERE  order_id = 5;

-- Delete all rows matching a condition
DELETE FROM books
WHERE  price < 8.00;

-- Truncate (remove all rows, reset sequence)
-- TRUNCATE TABLE orders RESTART IDENTITY;
