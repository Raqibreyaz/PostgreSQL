-- ============================================================
-- 13 · One-to-Many Relationships
-- Schema: bookstore
-- One author → many books
-- ============================================================

-- The existing tables already model this:
--   authors (1) ──── books (many)

-- ----------------------------------------------------------------
-- Re-create the relationship cleanly (for reference)
-- ----------------------------------------------------------------
CREATE TABLE authors (
    author_id  SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name  VARCHAR(50) NOT NULL,
    country    VARCHAR(50)
);

CREATE TABLE books (
    book_id    SERIAL PRIMARY KEY,
    title      VARCHAR(200) NOT NULL,
    author_id  INT REFERENCES authors(author_id) ON DELETE CASCADE,
    genre      VARCHAR(50),
    price      NUMERIC(8,2)
);

-- ----------------------------------------------------------------
-- Seed data
-- ----------------------------------------------------------------
INSERT INTO authors (first_name, last_name, country) VALUES
    ('George',  'Orwell',     'UK'),
    ('Haruki',  'Murakami',   'Japan');

INSERT INTO books (title, author_id, genre, price) VALUES
    ('1984',             1, 'Dystopian', 9.99),
    ('Animal Farm',      1, 'Satire',    7.49),
    ('Norwegian Wood',   2, 'Literary',  9.49),
    ('Kafka on the Shore', 2, 'Literary', 10.49);

-- ----------------------------------------------------------------
-- Query: show each book with its author
-- ----------------------------------------------------------------
SELECT
    a.first_name || ' ' || a.last_name AS author,
    b.title,
    b.genre,
    b.price
FROM   books   b
JOIN   authors a ON b.author_id = a.author_id
ORDER BY author;

-- ----------------------------------------------------------------
-- Query: count books per author
-- ----------------------------------------------------------------
SELECT
    a.first_name || ' ' || a.last_name AS author,
    COUNT(b.book_id)                   AS book_count
FROM   authors a
LEFT JOIN books b ON a.author_id = b.author_id
GROUP BY a.author_id, a.first_name, a.last_name
ORDER BY book_count DESC;

-- ----------------------------------------------------------------
-- Query: find authors who have written more than 1 book
-- ----------------------------------------------------------------
SELECT
    a.first_name || ' ' || a.last_name AS author,
    COUNT(*) AS total
FROM   authors a
JOIN   books   b ON a.author_id = b.author_id
GROUP BY a.author_id, a.first_name, a.last_name
HAVING COUNT(*) > 1;

-- ----------------------------------------------------------------
-- ON DELETE CASCADE demo
-- Deleting an author removes all their books automatically
-- ----------------------------------------------------------------
-- DELETE FROM authors WHERE author_id = 1;
-- SELECT * FROM books;  -- Orwell's books are gone
