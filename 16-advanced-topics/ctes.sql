-- ============================================================
-- 16 · Advanced: Common Table Expressions (CTEs)
-- Schema: bookstore
-- ============================================================

-- ----------------------------------------------------------------
-- Basic CTE  — WITH clause
-- ----------------------------------------------------------------

-- CTE to find books priced above the overall average
WITH avg_price AS (
    SELECT AVG(price) AS mean FROM books
)
SELECT title, price
FROM   books, avg_price
WHERE  price > avg_price.mean
ORDER BY price DESC;

-- ----------------------------------------------------------------
-- Named CTE improving readability
-- ----------------------------------------------------------------

-- Without CTE (harder to read):
SELECT customer_id, SUM(b.price * o.quantity) AS total
FROM   orders o
JOIN   books b ON o.book_id = b.book_id
GROUP BY customer_id
HAVING SUM(b.price * o.quantity) > 15;

-- With CTE (cleaner):
WITH customer_spending AS (
    SELECT
        o.customer_id,
        SUM(b.price * o.quantity) AS total_spent
    FROM   orders o
    JOIN   books  b ON o.book_id = b.book_id
    GROUP BY o.customer_id
)
SELECT
    c.first_name || ' ' || c.last_name AS customer,
    cs.total_spent
FROM   customer_spending cs
JOIN   customers         c  ON cs.customer_id = c.customer_id
WHERE  cs.total_spent > 15
ORDER BY cs.total_spent DESC;

-- ----------------------------------------------------------------
-- Multiple CTEs in one query
-- ----------------------------------------------------------------
WITH
    top_authors AS (
        -- Authors with 2+ books
        SELECT author_id
        FROM   books
        GROUP BY author_id
        HAVING COUNT(*) >= 2
    ),
    author_avg_price AS (
        -- Average book price per author
        SELECT author_id, ROUND(AVG(price), 2) AS avg_price
        FROM   books
        GROUP BY author_id
    )
SELECT
    a.first_name || ' ' || a.last_name AS author,
    ap.avg_price
FROM   authors        a
JOIN   top_authors    ta ON a.author_id = ta.author_id
JOIN   author_avg_price ap ON a.author_id = ap.author_id
ORDER BY ap.avg_price DESC;

-- ----------------------------------------------------------------
-- CTE vs Subquery — same result, different readability
-- ----------------------------------------------------------------

-- Subquery version
SELECT title, price
FROM   books
WHERE  price > (SELECT AVG(price) FROM books);

-- CTE version (equivalent, easier to extend)
WITH book_avg AS (
    SELECT AVG(price) AS mean FROM books
)
SELECT b.title, b.price
FROM   books    b
JOIN   book_avg ba ON b.price > ba.mean;

-- ----------------------------------------------------------------
-- Recursive CTE  — traverse hierarchical data
-- ----------------------------------------------------------------

-- Setup: an employee hierarchy table
CREATE TABLE employees (
    emp_id     SERIAL PRIMARY KEY,
    name       VARCHAR(100) NOT NULL,
    manager_id INT REFERENCES employees(emp_id)  -- NULL = top-level
);

INSERT INTO employees (name, manager_id) VALUES
    ('CEO',        NULL),   -- emp_id 1
    ('Manager A',  1),      -- emp_id 2
    ('Manager B',  1),      -- emp_id 3
    ('Alice',      2),      -- emp_id 4
    ('Bob',        2),      -- emp_id 5
    ('Carol',      3),      -- emp_id 6
    ('Dave',       3);      -- emp_id 7

-- Recursive CTE: walk from root down to every employee
WITH RECURSIVE org_chart AS (
    -- Anchor: start at the top (no manager)
    SELECT emp_id, name, manager_id, 0 AS depth
    FROM   employees
    WHERE  manager_id IS NULL

    UNION ALL

    -- Recursive step: find employees managed by the previous level
    SELECT e.emp_id, e.name, e.manager_id, oc.depth + 1
    FROM   employees e
    JOIN   org_chart oc ON e.manager_id = oc.emp_id
)
SELECT
    REPEAT('  ', depth) || name AS org_tree,
    depth
FROM org_chart
ORDER BY depth, name;

-- Recursive CTE: find all reports under Manager A (emp_id = 2)
WITH RECURSIVE reports AS (
    SELECT emp_id, name, manager_id
    FROM   employees
    WHERE  emp_id = 2         -- starting node

    UNION ALL

    SELECT e.emp_id, e.name, e.manager_id
    FROM   employees e
    JOIN   reports   r ON e.manager_id = r.emp_id
)
SELECT * FROM reports;
