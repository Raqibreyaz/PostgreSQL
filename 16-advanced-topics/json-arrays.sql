-- ============================================================
-- 16 · Advanced: JSON & Array Data Types
-- Schema: bookstore (extended)
-- ============================================================

-- ============================================================
-- JSON / JSONB
-- ============================================================

-- ----------------------------------------------------------------
-- Create a table with a JSONB column
-- ----------------------------------------------------------------
CREATE TABLE book_metadata (
    book_id   INT  PRIMARY KEY REFERENCES books(book_id),
    meta      JSONB
);

INSERT INTO book_metadata (book_id, meta) VALUES
    (1, '{"awards":["Prometheus Award"],"tags":["classic","political"],"pages":328}'),
    (2, '{"awards":[],"tags":["satire","animals"],"pages":112}'),
    (3, '{"awards":["Pulitzer Prize"],"tags":["russian","philosophy"],"pages":671}'),
    (6, '{"awards":[],"tags":["japan","love","literary"],"pages":296}');

-- ----------------------------------------------------------------
-- Querying JSONB
-- ----------------------------------------------------------------

-- Extract a value with -> (returns JSON)
SELECT book_id, meta -> 'pages' AS pages FROM book_metadata;

-- Extract a value with ->> (returns TEXT)
SELECT book_id, meta ->> 'pages' AS pages FROM book_metadata;

-- Extract nested value
SELECT book_id, meta -> 'tags' -> 0 AS first_tag FROM book_metadata;

-- Filter by JSONB value
SELECT book_id
FROM   book_metadata
WHERE  meta ->> 'pages' = '328';

-- Cast to integer for numeric comparison
SELECT book_id
FROM   book_metadata
WHERE  (meta ->> 'pages')::INT > 300;

-- Check if a key exists
SELECT book_id, meta
FROM   book_metadata
WHERE  meta ? 'awards';

-- Check if array contains a value
SELECT book_id
FROM   book_metadata
WHERE  meta -> 'tags' @> '["satire"]';

-- ----------------------------------------------------------------
-- Updating JSONB — jsonb_set()
-- ----------------------------------------------------------------
UPDATE book_metadata
SET    meta = jsonb_set(meta, '{pages}', '330')
WHERE  book_id = 1;

-- Add a new key
UPDATE book_metadata
SET    meta = meta || '{"language":"English"}'
WHERE  book_id = 1;

-- ----------------------------------------------------------------
-- Expanding JSONB arrays — jsonb_array_elements()
-- ----------------------------------------------------------------
SELECT book_id, tag
FROM   book_metadata,
       jsonb_array_elements_text(meta -> 'tags') AS tag
ORDER BY book_id;

-- ----------------------------------------------------------------
-- Creating a GIN index on JSONB (for fast containment queries)
-- ----------------------------------------------------------------
CREATE INDEX idx_book_meta_gin ON book_metadata USING GIN (meta);

-- ============================================================
-- ARRAYS
-- ============================================================

-- ----------------------------------------------------------------
-- Create a table with array columns
-- ----------------------------------------------------------------
CREATE TABLE author_profiles (
    author_id  INT PRIMARY KEY REFERENCES authors(author_id),
    languages  TEXT[],     -- languages the author writes in
    awards     TEXT[],
    birth_year INT
);

INSERT INTO author_profiles (author_id, languages, awards, birth_year) VALUES
    (1, ARRAY['English'], ARRAY['Prometheus Award (posthumous)'], 1903),
    (2, ARRAY['Russian'], ARRAY['Fyodor Prize'], 1821),
    (3, ARRAY['English'], ARRAY['Pulitzer Prize','Nobel Prize in Literature'], 1931),
    (4, ARRAY['Japanese','English'], ARRAY['Yomiuri Prize','Franz Kafka Prize'], 1949);

-- ----------------------------------------------------------------
-- Querying arrays
-- ----------------------------------------------------------------

-- Select array column
SELECT author_id, languages FROM author_profiles;

-- Access a specific element (1-indexed in PostgreSQL)
SELECT author_id, awards[1] AS first_award FROM author_profiles;

-- Filter: array contains a value
SELECT author_id
FROM   author_profiles
WHERE  'English' = ANY(languages);

-- Filter: array contains ALL specified values
SELECT author_id
FROM   author_profiles
WHERE  languages @> ARRAY['Japanese','English'];

-- ----------------------------------------------------------------
-- Array functions
-- ----------------------------------------------------------------

-- Length of an array
SELECT author_id, array_length(awards, 1) AS award_count
FROM   author_profiles;

-- Append an element
UPDATE author_profiles
SET    awards = array_append(awards, 'New Award 2025')
WHERE  author_id = 4;

-- Remove an element
UPDATE author_profiles
SET    languages = array_remove(languages, 'English')
WHERE  author_id = 2;

-- Expand array into rows — unnest()
SELECT author_id, award
FROM   author_profiles,
       unnest(awards) AS award
ORDER BY author_id;

-- Array to string
SELECT author_id, array_to_string(languages, ', ') AS langs
FROM   author_profiles;
