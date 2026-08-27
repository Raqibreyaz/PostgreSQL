# Conditional Logic with CASE in SQL

## What it is

The SQL **`CASE`** expression allows you to perform conditional logic inside a query.

It works like an **`if-then-else`** statement in programming.

You can use it to:

* Categorize data.
* Create calculated fields.
* Assign labels based on conditions.
* Dynamically generate a new value while retrieving data.

### One-sentence summary

> **`CASE` lets SQL make decisions for each row and return different values depending on which condition is satisfied.**

---

# 1. Intuition

If you know programming, think of `CASE` like:

```text
if condition:
    return result
else:
    return another_result
```

For example:

```text
If price > 1000
    → "Expensive"

Otherwise
    → "Affordable"
```

SQL can perform this logic directly while retrieving data.

---

# 2. Basic CASE Syntax

The general structure is:

```sql
CASE
    WHEN condition THEN result
    WHEN condition THEN result
    ELSE default_result
END
```

It is commonly given an alias using `AS`:

```sql
CASE
    WHEN condition THEN result
    ELSE default_result
END AS column_name
```

### Main keywords

| Keyword | Purpose                                       |
| ------- | --------------------------------------------- |
| `CASE`  | Starts the conditional expression             |
| `WHEN`  | Defines a condition                           |
| `THEN`  | Defines the result when the condition is true |
| `ELSE`  | Defines the default result                    |
| `END`   | Ends the `CASE` expression                    |
| `AS`    | Gives the resulting column a name             |

---

# 3. Simple Example — Categorizing Products by Price

Suppose the `products` table contains:

| name     | price |
| -------- | ----: |
| Laptop   |  1200 |
| Mouse    |   500 |
| Keyboard |   800 |
| TV       |  1500 |

We want to classify products as either **Expensive** or **Affordable**.

```sql
SELECT
    name,
    price,
    CASE
        WHEN price > 1000 THEN 'Expensive'
        ELSE 'Affordable'
    END AS price_tag
FROM products;
```

Result:

| name     | price | price_tag  |
| -------- | ----: | ---------- |
| Laptop   |  1200 | Expensive  |
| Mouse    |   500 | Affordable |
| Keyboard |   800 | Affordable |
| TV       |  1500 | Expensive  |

The `price_tag` is calculated while the query runs.

---

# 4. CASE Creates a Virtual Column

An important concept is that a `CASE` expression inside a `SELECT` does **not** automatically create a physical column in the database.

For example:

```sql
SELECT
    name,
    CASE
        WHEN price > 1000 THEN 'Expensive'
        ELSE 'Affordable'
    END AS price_tag
FROM products;
```

`price_tag` behaves like a temporary or **virtual column** in the query result.

Conceptually:

```text
Physical table
────────────────────────
name
price
category
...

        │
        │ SELECT + CASE
        ↓

Query result
────────────────────────
name
price
price_tag   ← calculated temporarily
```

The actual `products` table is not modified.

---

# 5. Snapshot vs Permanent Change

This distinction is very important.

## Using CASE inside SELECT

```sql
SELECT
    name,
    CASE
        WHEN price > 1000 THEN 'Expensive'
        ELSE 'Affordable'
    END AS price_tag
FROM products;
```

This gives you a **snapshot** of the classification.

The result is generated when the query runs.

It does **not** permanently store `price_tag` in the table.

---

## Making the Classification Permanent

If you want to actually store the classification in the database, two steps are required:

```text
ALTER TABLE
     ↓
Add a new column
     ↓
UPDATE
     ↓
Use CASE to populate it
```

### Step 1 — Add the column

For example:

```sql
ALTER TABLE products
ADD COLUMN price_tag TEXT;
```

The new column is now part of the physical table.

Initially, existing rows will contain:

```text
NULL
```

because no values have been assigned yet.

---

### Step 2 — Populate the column

Use `UPDATE` together with `CASE`:

```sql
UPDATE products
SET price_tag =
    CASE
        WHEN price > 1000 THEN 'Expensive'
        ELSE 'Affordable'
    END;
```

Now the values are actually stored.

Conceptually:

```text
Before UPDATE

name       price    price_tag
──────────────────────────────
Laptop     1200     NULL
Mouse       500     NULL
TV         1500     NULL


After UPDATE

name       price    price_tag
──────────────────────────────
Laptop     1200     Expensive
Mouse       500     Affordable
TV         1500     Expensive
```

---

# 6. How CASE Evaluates Conditions

`CASE` evaluates its conditions **from top to bottom**.

For each row:

```text
WHEN condition 1
      │
      ├── TRUE → return its THEN result
      │
      └── FALSE
            ↓
       WHEN condition 2
            │
            ├── TRUE → return its THEN result
            │
            └── FALSE
                  ↓
               ELSE
```

Once a condition is satisfied, SQL returns that result and stops evaluating further `WHEN` conditions for that row.

---

# 7. Why the Order of WHEN Conditions Matters

Because conditions are checked sequentially, the order can affect the result.

Suppose:

```text
price = 1500
```

And the conditions are:

```sql
CASE
    WHEN price > 1000 THEN 'Expensive'
    WHEN price > 500 THEN 'Moderate'
    ELSE 'Affordable'
END
```

The first condition is:

```text
price > 1000
```

Since `1500 > 1000` is true, SQL returns:

```text
Expensive
```

It does not continue to the next condition.

So remember:

> **The first matching `WHEN` wins.**

---

# 8. Multiple WHEN Conditions

`CASE` can contain multiple conditions.

For example, products could be divided into three categories:

```sql
CASE
    WHEN price > 1000 THEN 'Expensive'
    WHEN price > 500 THEN 'Moderate'
    ELSE 'Affordable'
END AS price_tag
```

The logic is:

```text
price > 1000
    ↓
Expensive

Otherwise, price > 500
    ↓
Moderate

Otherwise
    ↓
Affordable
```

This makes `CASE` useful for creating meaningful categories from raw data.

---

# 9. ELSE Is Optional

The source explains `ELSE` as an optional clause that provides a default value when no condition is satisfied.

For example:

```sql
CASE
    WHEN price > 1000 THEN 'Expensive'
    ELSE 'Affordable'
END
```

Here, every product that does not satisfy:

```text
price > 1000
```

gets:

```text
Affordable
```

The important role of `ELSE` is to handle the case where none of the `WHEN` conditions match.

---

# 10. CASE Does Not Modify the Original Data

Consider:

```sql
SELECT
    name,
    CASE
        WHEN price > 1000 THEN 'Expensive'
        ELSE 'Affordable'
    END AS price_tag
FROM products;
```

This query:

* Reads the product data.
* Evaluates the condition.
* Generates `price_tag`.
* Returns the result.

It does **not** modify the underlying table.

So:

```text
SELECT + CASE
      ↓
Read and calculate
      ↓
Return result
      ↓
Original table unchanged
```

---

# 11. CASE with ALTER TABLE + UPDATE

When you want the result permanently stored:

### Step 1

Modify the table:

```sql
ALTER TABLE products
ADD COLUMN price_tag TEXT;
```

### Step 2

Populate the new column:

```sql
UPDATE products
SET price_tag =
    CASE
        WHEN price > 1000 THEN 'Expensive'
        ELSE 'Affordable'
    END;
```

This connects the concepts from the previous module:

```text
ALTER TABLE
→ changes table structure

CASE
→ provides conditional logic

UPDATE
→ modifies existing data
```

Together, they allow you to create and populate a permanent calculated/classification field.

---

# 12. NULL Values During Permanent Changes

Suppose the table already contains data:

```text
products
────────────────────
product_id
name
price
category
```

You add:

```sql
ALTER TABLE products
ADD COLUMN price_tag TEXT;
```

The new column exists, but existing rows initially contain:

```text
NULL
```

Why?

Because PostgreSQL has not yet been told what `price_tag` should contain for those existing records.

You then execute:

```sql
UPDATE products
SET price_tag =
    CASE
        WHEN price > 1000 THEN 'Expensive'
        ELSE 'Affordable'
    END;
```

The `NULL` values are replaced by the calculated classifications.

---

# 13. Complete Example

Suppose:

| product_id | name    | price |
| ---------: | ------- | ----: |
|          1 | Laptop  |  1200 |
|          2 | Mouse   |   400 |
|          3 | Monitor |   900 |
|          4 | TV      |  1500 |

### Temporary classification

```sql
SELECT
    name,
    price,
    CASE
        WHEN price > 1000 THEN 'Expensive'
        ELSE 'Affordable'
    END AS price_tag
FROM products;
```

Result:

| name    | price | price_tag  |
| ------- | ----: | ---------- |
| Laptop  |  1200 | Expensive  |
| Mouse   |   400 | Affordable |
| Monitor |   900 | Affordable |
| TV      |  1500 | Expensive  |

The database table itself remains unchanged.

---

### Permanent classification

First:

```sql
ALTER TABLE products
ADD COLUMN price_tag TEXT;
```

Then:

```sql
UPDATE products
SET price_tag =
    CASE
        WHEN price > 1000 THEN 'Expensive'
        ELSE 'Affordable'
    END;
```

Now `price_tag` is physically stored as a column in the table.

---

# 14. Common Mistakes / Gotchas

## 1. Thinking CASE creates a permanent column

This:

```sql
SELECT
    name,
    CASE
        WHEN price > 1000 THEN 'Expensive'
        ELSE 'Affordable'
    END AS price_tag
FROM products;
```

does **not** add `price_tag` to the table.

It only creates a calculated result for that query.

---

## 2. Forgetting the `END`

Every `CASE` expression must eventually be closed with:

```sql
END
```

Basic structure:

```sql
CASE
    WHEN condition THEN result
    ELSE result
END
```

---

## 3. Ignoring condition order

Because `WHEN` conditions are evaluated from top to bottom, the first matching condition determines the result.

Therefore, when conditions overlap, put the more specific/high-priority condition first.

---

## 4. Assuming new columns automatically contain calculated values

After:

```sql
ALTER TABLE products
ADD COLUMN price_tag TEXT;
```

existing rows initially contain `NULL`.

You still need:

```sql
UPDATE
```

to populate them.

---

# 15. CASE vs Programming IF-ELSE

The mental comparison is:

| Programming        | SQL       |
| ------------------ | --------- |
| `if`               | `WHEN`    |
| condition          | condition |
| result inside `if` | `THEN`    |
| `else`             | `ELSE`    |
| end of logic       | `END`     |

Example programming logic:

```text
if price > 1000:
    "Expensive"
else:
    "Affordable"
```

SQL:

```sql
CASE
    WHEN price > 1000 THEN 'Expensive'
    ELSE 'Affordable'
END
```

The idea is essentially the same: **evaluate a condition and choose a result.**

---

# 16. Important Mental Model

Remember these three operations separately:

```text
CASE
 │
 └── Decides what value to produce
```

```text
SELECT
 │
 └── Retrieves/displays the calculated result
```

```text
UPDATE
 │
 └── Changes stored data
```

```text
ALTER TABLE
 │
 └── Changes table structure
```

Therefore:

```text
SELECT + CASE
→ temporary calculated result


ALTER TABLE + UPDATE + CASE
→ permanent stored classification
```

---

# 17. Key Takeaways

* `CASE` provides **conditional logic inside SQL queries**.
* It is similar to **if-then-else** logic in programming.
* `WHEN` defines the condition.
* `THEN` defines what to return when the condition is true.
* `ELSE` provides the default result when no condition matches.
* `END` closes the `CASE` expression.
* `AS` can give the calculated result a readable column name.
* `CASE` conditions are evaluated **from top to bottom**.
* Once the first matching condition is found, SQL returns its result for that row.
* A `CASE` expression in `SELECT` behaves like a **virtual/calculated column**.
* It does not modify the physical database table.
* To permanently store a classification, first use `ALTER TABLE` to create a column.
* Then use `UPDATE` with `CASE` to populate that column.
* A newly added column initially contains `NULL` for existing rows until it is populated.
* The source's main practical example is categorizing products based on their price.

---

# 18. Minimal Self-Test

1. What problem does `CASE` solve in SQL?
2. What is the SQL equivalent of an `if-else` statement?
3. What is the purpose of `WHEN`?
4. What does `THEN` specify?
5. What is the purpose of `ELSE`?
6. Why is `END` required?
7. In what order does SQL evaluate multiple `WHEN` conditions?
8. What happens after the first `WHEN` condition becomes true?
9. Does `CASE` inside `SELECT` permanently modify a table?
10. What is meant by a virtual/calculated column?
11. How would you classify products with prices above `1000` as `"Expensive"`?
12. How would you permanently store that classification?
13. Why do existing rows contain `NULL` after adding a new column?
14. What is the difference between `SELECT + CASE` and `UPDATE + CASE`?
15. Why does the order of `WHEN` conditions matter?
