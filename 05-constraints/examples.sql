-- ============================================================
-- 05 · Constraints in PostgreSQL
-- Schema: bookstore (extended with constraint demos)
-- ============================================================

-- ----------------------------------------------------------------
-- PRIMARY KEY
-- ----------------------------------------------------------------
CREATE TABLE publishers (
    publisher_id SERIAL PRIMARY KEY,   -- implicit NOT NULL + UNIQUE
    name         VARCHAR(100) NOT NULL
);

-- ----------------------------------------------------------------
-- NOT NULL
-- ----------------------------------------------------------------
CREATE TABLE book_editions (
    edition_id   SERIAL PRIMARY KEY,
    book_id      INT         NOT NULL,
    edition_no   INT         NOT NULL,
    language     VARCHAR(30) NOT NULL DEFAULT 'English'
);

-- ----------------------------------------------------------------
-- UNIQUE
-- ----------------------------------------------------------------
CREATE TABLE isbn_registry (
    isbn_id   SERIAL  PRIMARY KEY,
    isbn_code VARCHAR(13) UNIQUE NOT NULL,   -- no two books share an ISBN
    book_id   INT
);

-- ----------------------------------------------------------------
-- CHECK
-- ----------------------------------------------------------------
CREATE TABLE book_inventory (
    inventory_id  SERIAL PRIMARY KEY,
    book_id       INT  NOT NULL,
    stock_qty     INT  NOT NULL CHECK (stock_qty >= 0),       -- can't be negative
    reorder_level INT  NOT NULL CHECK (reorder_level >= 0)
);

-- Multiple CHECK conditions
CREATE TABLE discounts (
    discount_id  SERIAL PRIMARY KEY,
    code         VARCHAR(20) UNIQUE NOT NULL,
    pct_off      NUMERIC(5,2) CHECK (pct_off > 0 AND pct_off <= 100)
);

-- ----------------------------------------------------------------
-- FOREIGN KEY + ON DELETE behaviour
-- ----------------------------------------------------------------
CREATE TABLE book_reviews (
    review_id   SERIAL PRIMARY KEY,
    book_id     INT NOT NULL
                    REFERENCES books(book_id)
                    ON DELETE CASCADE,       -- delete reviews when book is deleted
    customer_id INT NOT NULL
                    REFERENCES customers(customer_id)
                    ON DELETE SET NULL,      -- keep review, null the customer ref
    rating      INT CHECK (rating BETWEEN 1 AND 5),
    body        TEXT
);

-- ----------------------------------------------------------------
-- DEFAULT
-- ----------------------------------------------------------------
CREATE TABLE audit_log (
    log_id      SERIAL PRIMARY KEY,
    action      VARCHAR(50) NOT NULL,
    happened_at TIMESTAMP   NOT NULL DEFAULT NOW(),
    performed_by VARCHAR(100) DEFAULT 'system'
);

-- ----------------------------------------------------------------
-- Adding / dropping constraints after table creation
-- ----------------------------------------------------------------

-- Add a NOT NULL constraint
ALTER TABLE book_editions
    ALTER COLUMN edition_no SET NOT NULL;

-- Add a UNIQUE constraint
ALTER TABLE publishers
    ADD CONSTRAINT uq_publisher_name UNIQUE (name);

-- Add a CHECK constraint
ALTER TABLE book_inventory
    ADD CONSTRAINT chk_reorder CHECK (reorder_level < stock_qty);

-- Drop a constraint
ALTER TABLE book_inventory
    DROP CONSTRAINT chk_reorder;

-- ----------------------------------------------------------------
-- Viewing constraints for a table
-- ----------------------------------------------------------------
SELECT constraint_name, constraint_type
FROM   information_schema.table_constraints
WHERE  table_name = 'books';
