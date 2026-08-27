-- ============================================================
-- 16 · Advanced: Advanced Date-Time Operations
-- Schema: bookstore
-- ============================================================

-- ----------------------------------------------------------------
-- Current date / time functions
-- ----------------------------------------------------------------
SELECT NOW();                   -- current timestamp with timezone
SELECT CURRENT_TIMESTAMP;       -- same as NOW()
SELECT CURRENT_DATE;            -- today's date only
SELECT CURRENT_TIME;            -- current time only

-- ----------------------------------------------------------------
-- EXTRACT  — pull out a part of a date/time
-- ----------------------------------------------------------------
SELECT
    published,
    EXTRACT(YEAR  FROM published) AS pub_year,
    EXTRACT(MONTH FROM published) AS pub_month,
    EXTRACT(DAY   FROM published) AS pub_day
FROM books;

-- Extract from NOW()
SELECT
    EXTRACT(YEAR   FROM NOW()) AS year,
    EXTRACT(MONTH  FROM NOW()) AS month,
    EXTRACT(DOW    FROM NOW()) AS day_of_week,  -- 0=Sunday, 6=Saturday
    EXTRACT(HOUR   FROM NOW()) AS hour;

-- ----------------------------------------------------------------
-- DATE_PART  — alternative to EXTRACT (same result)
-- ----------------------------------------------------------------
SELECT
    title,
    DATE_PART('year', published) AS year
FROM books;

-- ----------------------------------------------------------------
-- DATE_TRUNC  — truncate to a time unit (useful for grouping)
-- ----------------------------------------------------------------

-- Truncate to month (sets day/time to 01 00:00:00)
SELECT DATE_TRUNC('month', NOW());
SELECT DATE_TRUNC('year',  NOW());

-- Group orders by month
SELECT
    DATE_TRUNC('month', ordered_at)    AS order_month,
    COUNT(*)                           AS total_orders,
    SUM(b.price * o.quantity)          AS monthly_revenue
FROM   orders  o
JOIN   books   b ON o.book_id = b.book_id
GROUP BY DATE_TRUNC('month', ordered_at)
ORDER BY order_month;

-- ----------------------------------------------------------------
-- Arithmetic with dates
-- ----------------------------------------------------------------

-- How many days since each book was published?
SELECT
    title,
    published,
    (CURRENT_DATE - published)::INT AS days_since_published
FROM books;

-- Add / subtract intervals
SELECT NOW() + INTERVAL '7 days'   AS one_week_later;
SELECT NOW() - INTERVAL '1 month'  AS one_month_ago;
SELECT NOW() + INTERVAL '2 hours'  AS two_hours_later;

-- ----------------------------------------------------------------
-- AGE()  — human-readable difference between two dates
-- ----------------------------------------------------------------
SELECT
    title,
    published,
    AGE(CURRENT_DATE, published) AS age_of_book
FROM books;

-- Age since a specific date
SELECT AGE('2024-01-01'::DATE, '2000-06-15'::DATE);

-- ----------------------------------------------------------------
-- TO_CHAR  — format a date as a string
-- ----------------------------------------------------------------
SELECT
    title,
    TO_CHAR(published, 'DD Month YYYY') AS formatted_date,
    TO_CHAR(published, 'Mon YYYY')      AS short_date
FROM books;

-- ----------------------------------------------------------------
-- TO_DATE / TO_TIMESTAMP  — parse a string into a date
-- ----------------------------------------------------------------
SELECT TO_DATE('15-08-1947', 'DD-MM-YYYY');
SELECT TO_TIMESTAMP('2024-06-01 14:30:00', 'YYYY-MM-DD HH24:MI:SS');

-- ----------------------------------------------------------------
-- Working with timezones
-- ----------------------------------------------------------------
SELECT NOW() AT TIME ZONE 'UTC';
SELECT NOW() AT TIME ZONE 'Asia/Kolkata';
SELECT NOW() AT TIME ZONE 'America/New_York';

-- Convert stored UTC timestamp to local time
SELECT ordered_at AT TIME ZONE 'Asia/Kolkata' AS local_time
FROM   orders;

-- ----------------------------------------------------------------
-- Practical: orders placed in the last 30 days
-- ----------------------------------------------------------------
SELECT *
FROM   orders
WHERE  ordered_at >= NOW() - INTERVAL '30 days';

-- ----------------------------------------------------------------
-- Practical: group books by publication decade
-- ----------------------------------------------------------------
SELECT
    (EXTRACT(YEAR FROM published) / 10 * 10)::INT AS decade,
    COUNT(*) AS books_published
FROM   books
WHERE  published IS NOT NULL
GROUP BY decade
ORDER BY decade;
