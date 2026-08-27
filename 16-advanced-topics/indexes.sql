-- ============================================================
-- 16 · Advanced: Indexes in PostgreSQL
-- Schema: bookstore
-- ============================================================

-- ----------------------------------------------------------------
-- Why indexes? — without one PostgreSQL does a sequential scan
-- ----------------------------------------------------------------

-- This query on a large books table would scan every row:
EXPLAIN SELECT * FROM books WHERE genre = 'Classic';

-- ----------------------------------------------------------------
-- CREATE INDEX  — default B-Tree index
-- ----------------------------------------------------------------

-- Single-column index on a frequently filtered column
CREATE INDEX idx_books_genre ON books(genre);

-- Index on a foreign key column (speeds up JOINs)
CREATE INDEX idx_books_author_id ON books(author_id);

-- Index on customers email (unique lookups)
CREATE INDEX idx_customers_email ON customers(email);

-- ----------------------------------------------------------------
-- UNIQUE INDEX  — enforces uniqueness AND speeds up lookups
-- ----------------------------------------------------------------
CREATE UNIQUE INDEX uidx_customers_email ON customers(email);
-- (note: UNIQUE constraint already creates this implicitly)

-- ----------------------------------------------------------------
-- COMPOSITE INDEX  — multiple columns
-- ----------------------------------------------------------------

-- Useful when queries filter/sort on genre AND price together
CREATE INDEX idx_books_genre_price ON books(genre, price);

-- Rule of thumb: put the most selective column first
-- This index helps:  WHERE genre = 'Classic' ORDER BY price
-- Less useful for:   WHERE price < 10  (doesn't start with genre)

-- ----------------------------------------------------------------
-- PARTIAL INDEX  — index only a subset of rows
-- ----------------------------------------------------------------

-- Index only expensive books (price > 10) — smaller, faster
CREATE INDEX idx_books_expensive
    ON books(price)
    WHERE price > 10.00;

-- ----------------------------------------------------------------
-- Expression / Functional index
-- ----------------------------------------------------------------

-- If you frequently query by lower-cased title
CREATE INDEX idx_books_title_lower ON books(LOWER(title));

-- Now this query can use the index:
SELECT * FROM books WHERE LOWER(title) = 'beloved';

-- ----------------------------------------------------------------
-- EXPLAIN / EXPLAIN ANALYZE  — see if indexes are being used
-- ----------------------------------------------------------------

EXPLAIN        SELECT * FROM books WHERE genre = 'Classic';
EXPLAIN ANALYZE SELECT * FROM books WHERE genre = 'Classic';

-- Look for:
--   "Index Scan using idx_books_genre"  → index used ✓
--   "Seq Scan"                          → full table scan, no index

-- ----------------------------------------------------------------
-- Listing existing indexes
-- ----------------------------------------------------------------
SELECT indexname, indexdef
FROM   pg_indexes
WHERE  tablename = 'books';

-- ----------------------------------------------------------------
-- DROP INDEX
-- ----------------------------------------------------------------
DROP INDEX IF EXISTS idx_books_genre;
DROP INDEX IF EXISTS idx_books_genre_price;

-- ----------------------------------------------------------------
-- Trade-off reminder
-- Indexes speed up SELECT but slow down INSERT/UPDATE/DELETE
-- because the index structure must also be maintained.
-- Don't create indexes blindly — profile first.
-- ----------------------------------------------------------------
