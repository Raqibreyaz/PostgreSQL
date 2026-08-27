-- ============================================================
-- 16 · Advanced: Window Functions
-- Schema: bookstore
-- ============================================================

-- ----------------------------------------------------------------
-- Setup: add more sales data for meaningful window demos
-- ----------------------------------------------------------------
CREATE TABLE monthly_sales (
    sale_id     SERIAL PRIMARY KEY,
    genre       VARCHAR(50),
    sale_month  DATE,          -- first day of each month
    revenue     NUMERIC(10,2)
);

INSERT INTO monthly_sales (genre, sale_month, revenue) VALUES
    ('Classic',   '2024-01-01', 1200.00),
    ('Classic',   '2024-02-01', 980.00),
    ('Classic',   '2024-03-01', 1450.00),
    ('Dystopian', '2024-01-01', 870.00),
    ('Dystopian', '2024-02-01', 920.00),
    ('Dystopian', '2024-03-01', 760.00),
    ('Literary',  '2024-01-01', 540.00),
    ('Literary',  '2024-02-01', 610.00),
    ('Literary',  '2024-03-01', 590.00);

-- ----------------------------------------------------------------
-- RANK()  — rank rows within a partition
-- ----------------------------------------------------------------

-- Rank books by price globally
SELECT
    title,
    price,
    RANK() OVER (ORDER BY price DESC) AS price_rank
FROM books;

-- Rank books by price within each genre
SELECT
    title,
    genre,
    price,
    RANK() OVER (PARTITION BY genre ORDER BY price DESC) AS genre_rank
FROM books;

-- ----------------------------------------------------------------
-- DENSE_RANK()  — like RANK() but no gaps on ties
-- ----------------------------------------------------------------
SELECT
    title,
    price,
    RANK()       OVER (ORDER BY price DESC) AS rank_with_gaps,
    DENSE_RANK() OVER (ORDER BY price DESC) AS rank_no_gaps
FROM books;

-- ----------------------------------------------------------------
-- ROW_NUMBER()  — unique sequential number per row
-- ----------------------------------------------------------------
SELECT
    ROW_NUMBER() OVER (ORDER BY book_id) AS row_num,
    title,
    genre
FROM books;

-- ----------------------------------------------------------------
-- LAG()  — access the previous row's value
-- ----------------------------------------------------------------

-- Month-over-month revenue change per genre
SELECT
    genre,
    sale_month,
    revenue,
    LAG(revenue) OVER (PARTITION BY genre ORDER BY sale_month) AS prev_month_revenue,
    revenue - LAG(revenue) OVER (PARTITION BY genre ORDER BY sale_month) AS change
FROM monthly_sales
ORDER BY genre, sale_month;

-- ----------------------------------------------------------------
-- LEAD()  — access the next row's value
-- ----------------------------------------------------------------
SELECT
    genre,
    sale_month,
    revenue,
    LEAD(revenue) OVER (PARTITION BY genre ORDER BY sale_month) AS next_month_revenue
FROM monthly_sales
ORDER BY genre, sale_month;

-- ----------------------------------------------------------------
-- SUM() OVER()  — running total
-- ----------------------------------------------------------------

-- Running total of revenue across all months (all genres combined)
SELECT
    sale_month,
    genre,
    revenue,
    SUM(revenue) OVER (ORDER BY sale_month, genre) AS running_total
FROM monthly_sales
ORDER BY sale_month, genre;

-- Running total per genre
SELECT
    genre,
    sale_month,
    revenue,
    SUM(revenue) OVER (PARTITION BY genre ORDER BY sale_month) AS genre_running_total
FROM monthly_sales
ORDER BY genre, sale_month;

-- ----------------------------------------------------------------
-- AVG() OVER()  — moving average (3-month window per genre)
-- ----------------------------------------------------------------
SELECT
    genre,
    sale_month,
    revenue,
    ROUND(
        AVG(revenue) OVER (
            PARTITION BY genre
            ORDER BY sale_month
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ), 2
    ) AS moving_avg_3m
FROM monthly_sales
ORDER BY genre, sale_month;

-- ----------------------------------------------------------------
-- NTILE()  — divide rows into n equal buckets
-- ----------------------------------------------------------------
SELECT
    title,
    price,
    NTILE(3) OVER (ORDER BY price) AS price_bucket   -- 1=cheap, 3=expensive
FROM books;
