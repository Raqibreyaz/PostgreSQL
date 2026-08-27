-- ============================================================
-- 16 · Advanced: Set Operators
-- Schema: bookstore
-- ============================================================

-- Setup: a second table — out-of-print books archive
CREATE TABLE archived_books (
    book_id  SERIAL PRIMARY KEY,
    title    VARCHAR(200) NOT NULL,
    genre    VARCHAR(50),
    price    NUMERIC(8,2)
);

INSERT INTO archived_books (title, genre, price) VALUES
    ('Animal Farm',       'Satire',    7.49),    -- also in books
    ('Beloved',           'Historical',10.99),   -- also in books
    ('The Idiot',         'Classic',   10.49),   -- archive only
    ('The Metamorphosis', 'Classic',    8.99);   -- archive only

-- ----------------------------------------------------------------
-- UNION  — combine results, remove duplicates
-- ----------------------------------------------------------------

-- All distinct titles across both tables
SELECT title, genre FROM books
UNION
SELECT title, genre FROM archived_books
ORDER BY genre, title;

-- ----------------------------------------------------------------
-- UNION ALL  — combine results, keep duplicates
-- ----------------------------------------------------------------

-- All titles including duplicates (useful for total counts, audits)
SELECT title, genre FROM books
UNION ALL
SELECT title, genre FROM archived_books
ORDER BY genre, title;

-- ----------------------------------------------------------------
-- INTERSECT  — rows present in BOTH results
-- ----------------------------------------------------------------

-- Books that exist in both the active catalog and archive
SELECT title FROM books
INTERSECT
SELECT title FROM archived_books
ORDER BY title;

-- ----------------------------------------------------------------
-- EXCEPT  — rows in the first result but NOT in the second
-- ----------------------------------------------------------------

-- Active books that have NOT been archived yet
SELECT title FROM books
EXCEPT
SELECT title FROM archived_books
ORDER BY title;

-- Archived books that are no longer in the active catalog
SELECT title FROM archived_books
EXCEPT
SELECT title FROM books
ORDER BY title;

-- ----------------------------------------------------------------
-- Practical: UNION ALL for reporting across tables
-- ----------------------------------------------------------------

-- Combined price list from both catalogs, labelled by source
SELECT title, price, 'active'   AS source FROM books
UNION ALL
SELECT title, price, 'archived' AS source FROM archived_books
ORDER BY price DESC;

-- ----------------------------------------------------------------
-- Using set operators with WHERE
-- ----------------------------------------------------------------

-- Classic books from active OR archived catalog
SELECT title, genre FROM books        WHERE genre = 'Classic'
UNION
SELECT title, genre FROM archived_books WHERE genre = 'Classic'
ORDER BY title;

-- ----------------------------------------------------------------
-- UNION rules reminder:
--   1. Same number of columns in each SELECT
--   2. Corresponding columns must have compatible data types
--   3. Column names in result come from the FIRST SELECT
-- ----------------------------------------------------------------
