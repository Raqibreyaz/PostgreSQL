-- ============================================================
-- 08 · Operators in PostgreSQL
-- Schema: bookstore
-- ============================================================

-- ----------------------------------------------------------------
-- Comparison operators
-- ----------------------------------------------------------------
SELECT title, price FROM books WHERE price = 9.99;
SELECT title, price FROM books WHERE price != 9.99;
SELECT title, price FROM books WHERE price >  10.00;
SELECT title, price FROM books WHERE price >= 10.00;
SELECT title, price FROM books WHERE price <  10.00;
SELECT title, price FROM books WHERE price <= 10.00;

-- ----------------------------------------------------------------
-- Logical operators: AND, OR, NOT
-- ----------------------------------------------------------------

-- AND — both conditions must be true
SELECT title, genre, price
FROM   books
WHERE  genre = 'Classic' AND price < 13.00;

-- OR — at least one condition must be true
SELECT title, genre
FROM   books
WHERE  genre = 'Dystopian' OR genre = 'Satire';

-- NOT — invert a condition
SELECT title, genre
FROM   books
WHERE  NOT genre = 'Classic';

-- Combining AND / OR (use parentheses to control precedence)
SELECT title, genre, price
FROM   books
WHERE  (genre = 'Classic' OR genre = 'Literary') AND price < 11.00;

-- ----------------------------------------------------------------
-- BETWEEN  — inclusive range check
-- ----------------------------------------------------------------
SELECT title, price
FROM   books
WHERE  price BETWEEN 9.00 AND 11.00;

-- Works with dates too
SELECT title, published
FROM   books
WHERE  published BETWEEN '1940-01-01' AND '1990-12-31';

-- ----------------------------------------------------------------
-- IN  — match against a list of values
-- ----------------------------------------------------------------
SELECT title, genre
FROM   books
WHERE  genre IN ('Classic', 'Dystopian', 'Satire');

-- NOT IN — exclude a list
SELECT title, genre
FROM   books
WHERE  genre NOT IN ('Classic', 'Historical');

-- ----------------------------------------------------------------
-- LIKE / ILIKE  — pattern matching
-- ----------------------------------------------------------------

-- % matches zero or more characters
SELECT title FROM books WHERE title LIKE 'A%';      -- starts with A
SELECT title FROM books WHERE title LIKE '%and%';   -- contains "and"
SELECT title FROM books WHERE title LIKE '%m';      -- ends with m

-- _ matches exactly one character
SELECT title FROM books WHERE title LIKE '_984';    -- e.g. "1984"

-- ILIKE is case-insensitive (PostgreSQL extension)
SELECT title FROM books WHERE title ILIKE '%wood%';

-- ----------------------------------------------------------------
-- IS NULL / IS NOT NULL
-- ----------------------------------------------------------------

-- Find books without a genre set
SELECT title FROM books WHERE genre IS NULL;

-- Find books that do have a genre
SELECT title FROM books WHERE genre IS NOT NULL;

-- ----------------------------------------------------------------
-- Arithmetic operators
-- ----------------------------------------------------------------
SELECT title,
       price,
       price * 1.10             AS price_with_tax,
       price - (price * 0.15)   AS discounted_15pct
FROM   books;

-- ----------------------------------------------------------------
-- Concatenation operator
-- ----------------------------------------------------------------
SELECT first_name || ' ' || last_name AS full_name
FROM   authors;
