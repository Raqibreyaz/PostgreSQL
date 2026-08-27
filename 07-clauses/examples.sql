-- ============================================================
-- 07 · Clauses in PostgreSQL
-- Schema: bookstore
-- ============================================================

-- ----------------------------------------------------------------
-- WHERE  — filter rows
-- ----------------------------------------------------------------
SELECT title, price
FROM   books
WHERE  price > 10.00;

-- ----------------------------------------------------------------
-- ORDER BY  — sort results
-- ----------------------------------------------------------------

-- Ascending (default)
SELECT title, price
FROM   books
ORDER BY price ASC;

-- Descending
SELECT title, price
FROM   books
ORDER BY price DESC;

-- Multi-column sort
SELECT title, genre, price
FROM   books
ORDER BY genre ASC, price DESC;

-- ----------------------------------------------------------------
-- LIMIT  — cap the number of rows returned
-- ----------------------------------------------------------------
SELECT title, price
FROM   books
ORDER BY price DESC
LIMIT 3;

-- ----------------------------------------------------------------
-- OFFSET  — skip rows (useful for pagination)
-- ----------------------------------------------------------------
-- Page 1: rows 1-3
SELECT title, price FROM books ORDER BY book_id LIMIT 3 OFFSET 0;

-- Page 2: rows 4-6
SELECT title, price FROM books ORDER BY book_id LIMIT 3 OFFSET 3;

-- ----------------------------------------------------------------
-- DISTINCT  — remove duplicate values
-- ----------------------------------------------------------------
SELECT DISTINCT genre
FROM   books;

-- ----------------------------------------------------------------
-- GROUP BY  — aggregate rows that share the same value
-- ----------------------------------------------------------------
SELECT genre, COUNT(*) AS total_books
FROM   books
GROUP BY genre;

SELECT genre, AVG(price) AS avg_price
FROM   books
GROUP BY genre
ORDER BY avg_price DESC;

-- ----------------------------------------------------------------
-- HAVING  — filter on aggregated groups (like WHERE but after GROUP BY)
-- ----------------------------------------------------------------

-- Only genres with more than 1 book
SELECT genre, COUNT(*) AS total
FROM   books
GROUP BY genre
HAVING COUNT(*) > 1;

-- Genres where average price exceeds $10
SELECT genre, ROUND(AVG(price), 2) AS avg_price
FROM   books
GROUP BY genre
HAVING AVG(price) > 10;

-- ----------------------------------------------------------------
-- Combining multiple clauses
-- ----------------------------------------------------------------
SELECT genre,
       COUNT(*)         AS total_books,
       MIN(price)       AS cheapest,
       MAX(price)       AS priciest,
       ROUND(AVG(price),2) AS avg_price
FROM   books
WHERE  published > '1900-01-01'
GROUP BY genre
HAVING COUNT(*) > 1
ORDER BY avg_price DESC
LIMIT 5;
