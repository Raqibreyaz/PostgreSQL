-- ============================================================
-- 04 · Data Types in PostgreSQL
-- Schema: bookstore (extended demo table)
-- ============================================================

-- Demo table showcasing common PostgreSQL data types
CREATE TABLE data_type_demo (
    -- Integer family
    col_smallint    SMALLINT,           -- -32768 to 32767
    col_int         INT,                -- -2.1B to 2.1B
    col_bigint      BIGINT,             -- very large integers
    col_serial      SERIAL,             -- auto-increment integer (shorthand)

    -- Floating point / exact numeric
    col_real        REAL,               -- 6 decimal digits precision
    col_double      DOUBLE PRECISION,   -- 15 decimal digits precision
    col_numeric     NUMERIC(10, 2),     -- exact: 10 digits total, 2 after decimal

    -- Text family
    col_varchar     VARCHAR(100),       -- variable length, max 100 chars
    col_char        CHAR(5),            -- fixed length, padded with spaces
    col_text        TEXT,               -- unlimited length

    -- Boolean
    col_bool        BOOLEAN,            -- TRUE / FALSE / NULL

    -- Date & Time
    col_date        DATE,               -- YYYY-MM-DD
    col_time        TIME,               -- HH:MM:SS
    col_timestamp   TIMESTAMP,          -- date + time, no timezone
    col_timestamptz TIMESTAMPTZ,        -- date + time, with timezone

    -- UUID
    col_uuid        UUID DEFAULT gen_random_uuid(),

    -- JSON
    col_json        JSON,               -- stored as text, validated JSON
    col_jsonb       JSONB,              -- binary JSON (indexed, preferred)

    -- Arrays
    col_int_array   INT[],
    col_text_array  TEXT[]
);

-- ----------------------------------------------------------------
-- Insert sample data demonstrating each type
-- ----------------------------------------------------------------
INSERT INTO data_type_demo (
    col_smallint, col_int, col_bigint,
    col_real, col_double, col_numeric,
    col_varchar, col_char, col_text,
    col_bool,
    col_date, col_time, col_timestamp, col_timestamptz,
    col_json, col_jsonb,
    col_int_array, col_text_array
) VALUES (
    32000, 2100000000, 9223372036854775807,
    3.14,  3.14159265358979, 9999.99,
    'Hello, PostgreSQL!', 'ABC  ', 'This is unlimited text.',
    TRUE,
    '2024-01-15', '14:30:00', '2024-01-15 14:30:00', NOW(),
    '{"name":"Alice"}',
    '{"name":"Alice","scores":[100,95,87]}',
    ARRAY[1, 2, 3],
    ARRAY['sql', 'postgres', 'data']
);

-- ----------------------------------------------------------------
-- Type casting
-- ----------------------------------------------------------------

-- Cast text to integer
SELECT CAST('42' AS INT);
SELECT '42'::INT;           -- PostgreSQL shorthand

-- Cast integer to text
SELECT 100::TEXT;

-- Cast to date
SELECT '2024-06-15'::DATE;

-- ----------------------------------------------------------------
-- Checking types
-- ----------------------------------------------------------------

-- See column types for an existing table
SELECT column_name, data_type, character_maximum_length
FROM   information_schema.columns
WHERE  table_name = 'books';
