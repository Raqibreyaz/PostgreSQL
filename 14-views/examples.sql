-- ============================================================
-- 14 · Views in PostgreSQL
-- Schema: bookstore
-- ============================================================

-- ----------------------------------------------------------------
-- CREATE VIEW — save a query as a reusable named object
-- ----------------------------------------------------------------

-- View: books with author name and price
CREATE VIEW vw_book_details AS
SELECT
    b.book_id,
    b.title,
    a.first_name || ' ' || a.last_name AS author,
    b.genre,
    b.price,
    b.published
FROM   books   b
JOIN   authors a ON b.author_id = a.author_id;

-- View: expensive books (price > $10)
CREATE VIEW vw_expensive_books AS
SELECT title, author_id, price
FROM   books
WHERE  price > 10.00;

-- View: customer order summary
CREATE VIEW vw_customer_orders AS
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name   AS customer,
    c.email,
    COUNT(o.order_id)                     AS total_orders,
    SUM(b.price * o.quantity)             AS total_spent
FROM   customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN books  b ON o.book_id     = b.book_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email;

-- ----------------------------------------------------------------
-- SELECT from a view (just like a table)
-- ----------------------------------------------------------------
SELECT * FROM vw_book_details;

SELECT * FROM vw_book_details WHERE genre = 'Classic';

SELECT * FROM vw_customer_orders ORDER BY total_spent DESC;

-- ----------------------------------------------------------------
-- CREATE OR REPLACE VIEW — update an existing view definition
-- ----------------------------------------------------------------
CREATE OR REPLACE VIEW vw_book_details AS
SELECT
    b.book_id,
    b.title,
    a.first_name || ' ' || a.last_name AS author,
    a.country                           AS author_country,   -- new column
    b.genre,
    b.price,
    b.published
FROM   books   b
JOIN   authors a ON b.author_id = a.author_id;

-- ----------------------------------------------------------------
-- List all views in the current database
-- ----------------------------------------------------------------
SELECT table_name AS view_name
FROM   information_schema.views
WHERE  table_schema = 'public';

-- ----------------------------------------------------------------
-- DROP VIEW
-- ----------------------------------------------------------------
DROP VIEW IF EXISTS vw_expensive_books;
DROP VIEW IF EXISTS vw_book_details CASCADE;   -- CASCADE drops dependent objects
