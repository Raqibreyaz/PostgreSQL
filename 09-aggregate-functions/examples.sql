-- ============================================================
-- 09 · Aggregate Functions in PostgreSQL
-- Schema: bookstore
-- ============================================================

-- ----------------------------------------------------------------
-- COUNT
-- ----------------------------------------------------------------

-- Total number of books
SELECT COUNT(*) AS total_books FROM books;

-- Count only rows where price is not NULL
SELECT COUNT(price) AS books_with_price FROM books;

-- Count distinct genres
SELECT COUNT(DISTINCT genre) AS unique_genres FROM books;

-- ----------------------------------------------------------------
-- SUM
-- ----------------------------------------------------------------

-- Total value of all book stock (assuming 1 copy each)
SELECT SUM(price) AS total_inventory_value FROM books;

-- Total quantity ordered per book
SELECT book_id, SUM(quantity) AS total_ordered
FROM   orders
GROUP BY book_id
ORDER BY total_ordered DESC;

-- ----------------------------------------------------------------
-- AVG
-- ----------------------------------------------------------------

-- Average price across all books
SELECT ROUND(AVG(price), 2) AS avg_price FROM books;

-- Average price per genre
SELECT genre, ROUND(AVG(price), 2) AS avg_price
FROM   books
GROUP BY genre
ORDER BY avg_price DESC;

-- ----------------------------------------------------------------
-- MIN / MAX
-- ----------------------------------------------------------------

-- Cheapest and most expensive book
SELECT MIN(price) AS cheapest, MAX(price) AS priciest FROM books;

-- Per-genre min and max
SELECT genre,
       MIN(price) AS cheapest,
       MAX(price) AS priciest
FROM   books
GROUP BY genre;

-- Earliest and latest publication date
SELECT MIN(published) AS oldest, MAX(published) AS newest FROM books;

-- ----------------------------------------------------------------
-- Combining multiple aggregate functions
-- ----------------------------------------------------------------
SELECT
    genre,
    COUNT(*)                    AS total_books,
    ROUND(AVG(price), 2)        AS avg_price,
    MIN(price)                  AS min_price,
    MAX(price)                  AS max_price,
    ROUND(SUM(price), 2)        AS total_value
FROM   books
GROUP BY genre
ORDER BY total_books DESC;

-- ----------------------------------------------------------------
-- HAVING  — filter aggregated groups
-- ----------------------------------------------------------------

-- Genres with more than 1 book and average price above $10
SELECT genre, COUNT(*) AS cnt, ROUND(AVG(price),2) AS avg_price
FROM   books
GROUP BY genre
HAVING COUNT(*) > 1 AND AVG(price) > 10;

-- ----------------------------------------------------------------
-- Aggregate on joined data
-- ----------------------------------------------------------------

-- Revenue per customer (quantity × price)
SELECT
    c.first_name || ' ' || c.last_name AS customer,
    SUM(b.price * o.quantity)           AS total_spent
FROM   orders   o
JOIN   customers c ON o.customer_id = c.customer_id
JOIN   books     b ON o.book_id     = b.book_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;
