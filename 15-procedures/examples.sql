-- ============================================================
-- 15 · Stored Procedures in PostgreSQL
-- Schema: bookstore
-- ============================================================

-- ----------------------------------------------------------------
-- Basic PROCEDURE — apply a discount to a specific book
-- ----------------------------------------------------------------
CREATE OR REPLACE PROCEDURE apply_discount(
    p_book_id  INT,
    p_discount NUMERIC   -- e.g. 0.10 means 10 %
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE books
    SET    price = ROUND(price * (1 - p_discount), 2)
    WHERE  book_id = p_book_id;

    RAISE NOTICE 'Discount of % applied to book_id %', p_discount, p_book_id;
END;
$$;

-- Call the procedure
CALL apply_discount(1, 0.10);   -- 10 % off book 1

-- ----------------------------------------------------------------
-- PROCEDURE with OUT parameter (via INOUT)
-- ----------------------------------------------------------------
CREATE OR REPLACE PROCEDURE get_book_price(
    p_book_id  INT,
    INOUT p_price NUMERIC DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT price INTO p_price
    FROM   books
    WHERE  book_id = p_book_id;
END;
$$;

CALL get_book_price(1, NULL);

-- ----------------------------------------------------------------
-- PROCEDURE with transaction control
-- ----------------------------------------------------------------
CREATE OR REPLACE PROCEDURE place_order(
    p_customer_id INT,
    p_book_id     INT,
    p_quantity    INT DEFAULT 1
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Insert the order
    INSERT INTO orders (customer_id, book_id, quantity)
    VALUES (p_customer_id, p_book_id, p_quantity);

    -- Log to audit (if table exists)
    -- INSERT INTO audit_log (action) VALUES ('order placed');

    COMMIT;  -- explicit commit inside a procedure
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
$$;

CALL place_order(1, 3, 2);

-- ----------------------------------------------------------------
-- PROCEDURE vs FUNCTION — key difference
-- Procedures: called with CALL, can COMMIT/ROLLBACK
-- Functions:  called in SELECT, must RETURN a value
-- ----------------------------------------------------------------

-- FUNCTION example (for comparison)
CREATE OR REPLACE FUNCTION total_revenue()
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE
    v_total NUMERIC;
BEGIN
    SELECT SUM(b.price * o.quantity)
    INTO   v_total
    FROM   orders o
    JOIN   books  b ON o.book_id = b.book_id;

    RETURN v_total;
END;
$$;

-- Call the function
SELECT total_revenue();

-- ----------------------------------------------------------------
-- List procedures in the database
-- ----------------------------------------------------------------
SELECT routine_name, routine_type
FROM   information_schema.routines
WHERE  routine_schema = 'public'
  AND  routine_type IN ('PROCEDURE', 'FUNCTION')
ORDER BY routine_type, routine_name;

-- ----------------------------------------------------------------
-- Drop a procedure
-- ----------------------------------------------------------------
DROP PROCEDURE IF EXISTS apply_discount(INT, NUMERIC);
