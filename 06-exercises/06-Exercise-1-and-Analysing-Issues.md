# PostgreSQL Product Project, Sequences & SQL Practice

## What it is

After learning **data types** and **constraints**, the next step is to apply them in a small real-world database project.

This section introduces a **product database** and then uses it to practice SQL queries.

It also covers an important PostgreSQL concept: the internal **sequence** used by `SERIAL` columns and what can go wrong when IDs are manually inserted.

---

# One-Sentence Summary

> **This module applies PostgreSQL data types and constraints to a product database, introduces practical SQL queries, and explains how to troubleshoot and resynchronize a `SERIAL` sequence when manual ID insertion causes it to become misaligned.**

---

# 1. Why Hands-On Practice Matters

After learning theoretical concepts such as:

* Data types
* Constraints
* `SERIAL`
* `NOT NULL`
* `UNIQUE`
* `PRIMARY KEY`
* `DEFAULT`
* `CHECK`

the instructor emphasizes the importance of **actually building something**.

Knowing syntax is not enough.

You should practice by:

```text id="s4m7x2"
Learn concept
    ↓
Create database/table
    ↓
Insert data
    ↓
Run queries
    ↓
Observe results
    ↓
Solve problems
```

This project provides that practical environment.

---

# 2. Product Database Project

The instructor creates a small database project based around **products**.

The purpose is to combine the concepts learned so far.

The product table contains information related to:

* Product information
* Prices
* Stock levels
* Availability
* Category

---

# 3. Product Table Structure

The project includes fields representing things such as:

```text id="k8q3v5"
Products
│
├── Product ID
├── Name
├── Price
├── Stock
├── Availability
└── Category
```

Categories can include examples such as:

* Electronics
* Stationary
* Home & Kitchen

The exact table design applies the data-type and constraint concepts learned earlier.

---

# 4. Availability as a Boolean

The product database includes an **availability** field.

This represents whether a product is currently available.

A Boolean has two logical values:

```text id="m5x7q2"
TRUE
FALSE
```

For example:

| Product   | Available |
| --------- | --------- |
| Laptop    | `TRUE`    |
| Notebook  | `TRUE`    |
| Old Phone | `FALSE`   |

This is a good example of selecting a data type based on the meaning of the data.

---

# 5. Inserting Sample Data

Once the product table is created, sample products are inserted.

The purpose of inserting sample data is to create a dataset that can be used for SQL exercises.

Conceptually:

```text id="r8m3v6"
Product Table
     ↓
Insert sample products
     ↓
Enough data for practice
     ↓
Run SQL queries
```

The upcoming exercises use this product table.

---

# 6. The `SERIAL` Sequence Problem

One of the most useful troubleshooting concepts in this section is related to `SERIAL`.

Recall:

```sql id="p4x8m2"
product_id SERIAL
```

`SERIAL` automatically generates integer IDs.

But there is an important detail:

> `SERIAL` uses an internal **sequence** to generate those IDs.

---

# 7. What Is a Sequence?

A sequence is responsible for generating successive numeric values.

Conceptually:

```text id="q7m2x9"
Sequence
   ↓
1
2
3
4
5
...
```

When a new product is inserted without manually providing its ID, the sequence provides the next value.

For example:

```text id="v5k8r3"
Insert product
      ↓
Sequence
      ↓
Next ID
      ↓
Product gets ID
```

---

# 8. How the Sequence Can Become Misaligned

Suppose we have:

```sql id="x3m7q1"
product_id SERIAL
```

The sequence is supposed to generate IDs automatically.

Now imagine you manually insert:

```text id="c8v2m5"
product_id = 1
```

The important issue discussed by the instructor is that **manually supplying a value does not necessarily advance the sequence in the way you expect**.

The table may now contain:

```text id="n4q7x2"
product_id
----------
1
```

while the sequence may still be at an earlier value.

---

# 9. Why This Causes a Problem

Imagine:

```text id="z6m3p8"
Actual table:

product_id
----------
1


Sequence:

last_value = 1
```

Now you insert another product without specifying the ID.

PostgreSQL asks the sequence:

> "What is the next ID?"

If the sequence is not synchronized with the IDs already present, it may try to generate an ID that is already being used.

For example:

```text id="w2k8m4"
Existing ID → 1

Sequence tries:
Next ID → 1

Result:
ID conflict
```

This can cause a conflict, especially when the ID column is protected by a `PRIMARY KEY` or `UNIQUE` constraint.

---

# 10. The Important Distinction

There are two things to think about:

```text id="r5x9k3"
Table Data
    ↓
Actual IDs currently stored

Sequence
    ↓
Next IDs PostgreSQL intends to generate
```

Ideally, these should be synchronized.

```text id="q8m2v6"
Actual IDs
    ↕
Sequence state
```

If they become misaligned, automatic ID generation can cause conflicts.

---

# 11. Checking the Sequence

When debugging the problem, the instructor shows how to check the sequence's current value.

The query is:

```sql id="f3x7m8"
SELECT last_value
FROM product_id_sequence;
```

This allows you to see the sequence's current `last_value`.

---

# 12. Why Check `last_value`?

Suppose your table contains:

```text id="m9v4k2"
product_id
----------
1
2
3
4
5
```

but the sequence reports an unexpectedly low value.

That tells you:

```text id="x5q8m3"
Table IDs
    ≠
Sequence state
```

This is a sign that the sequence may need to be resynchronized.

---

# 13. Resynchronizing the Sequence

The instructor demonstrates using `setval()` to update the sequence based on the maximum ID currently stored in the table.

The query is:

```sql id="v7m3q9"
SELECT setval(
    'product_id_sequence',
    (SELECT MAX(product_id) FROM products)
);
```

The idea is:

```text id="k4x8m2"
Find highest product_id
        ↓
MAX(product_id)
        ↓
Use that value
        ↓
Update sequence
        ↓
Sequence becomes synchronized
```

---

# 14. Understanding the Query

Let's break it down.

### Outer function

```sql id="z3m7q5"
setval(...)
```

is used to set the sequence value.

### Sequence name

```sql id="p8x2v6"
'product_id_sequence'
```

identifies the sequence being updated.

### Finding the maximum ID

```sql id="r4m9k1"
SELECT MAX(product_id)
FROM products
```

finds the highest ID currently present in the table.

For example:

| product_id |
| ---------: |
|          1 |
|          2 |
|          3 |
|          7 |

Then:

```text id="c5v8m2"
MAX(product_id) = 7
```

That value is used to resynchronize the sequence.

---

# 15. Sequence Resynchronization Mental Model

```text id="q2m7x4"
Products table
     │
     ├── ID 1
     ├── ID 2
     ├── ID 3
     └── ID 7
          │
          ↓
     MAX(product_id)
          │
          ↓
           7
          │
          ↓
      setval(...)
          │
          ↓
Sequence synchronized
```

---

# 16. Best Practice — Don't Manually Insert SERIAL IDs

The instructor gives an important recommendation:

> **Avoid manually inserting IDs when using `SERIAL` or auto-incrementing IDs.**

If PostgreSQL is responsible for generating the ID, let PostgreSQL generate it.

Prefer:

```sql id="b8m3x7"
INSERT INTO products (name, price, stock)
VALUES ('Laptop', 50000, 10);
```

instead of manually specifying:

```sql id="n4q7m2"
INSERT INTO products (product_id, name, price, stock)
VALUES (1, 'Laptop', 50000, 10);
```

The first approach keeps the sequence mechanism working naturally.

---

# 17. Why Manual IDs Are Risky

With automatic IDs:

```text id="w5x8m3"
INSERT
  ↓
Sequence
  ↓
Next ID
  ↓
Product
```

With manual IDs:

```text id="k2m7q4"
INSERT
  ↓
Manually chosen ID
  ↓
Sequence may not match
  ↓
Potential conflict later
```

Therefore:

> **Let the database manage auto-generated identifiers whenever possible.**

---

# 18. Product SQL Practice

Once the product table has been populated, the instructor gives several SQL exercises.

These exercises practice:

* `SELECT`
* `FROM`
* `WHERE`
* `GROUP BY`
* `HAVING`
* `ORDER BY`
* `LIMIT`
* `AS`
* `DISTINCT`

This is an important transition from **database design** to **data retrieval and analysis**.

---

# 19. Question 1 — Show Name and Price

### Requirement

> Show the name and price of all products.

Query:

```sql id="x7m3q8"
SELECT name, price
FROM product;
```

### Explanation

Instead of selecting every column, we specifically request:

```text id="r5k2v9"
name
price
```

This is a good example of selecting only the information we need.

---

# 20. Question 2 — Products in Electronics

### Requirement

> Show all products where the category is `'Electronics'`.

Query:

```sql id="m8x4q2"
SELECT *
FROM product
WHERE category = 'Electronics';
```

The `WHERE` clause filters the rows.

Conceptually:

```text id="c3v7m9"
All products
     ↓
WHERE category = 'Electronics'
     ↓
Only Electronics products
```

---

# 21. Question 3 — Group Products by Category

### Requirement

> Group products by category and show each category once.

Query:

```sql id="q6m2x8"
SELECT category
FROM product
GROUP BY category;
```

The `GROUP BY` clause creates groups based on category.

For example, if the table contains:

```text id="v8k3m5"
Electronics
Electronics
Stationary
Home & Kitchen
Stationary
```

grouping by category gives:

```text id="p4x7q2"
Electronics
Stationary
Home & Kitchen
```

---

# 22. `GROUP BY` Mental Model

Think of it as putting similar values into groups:

```text id="r3m8v5"
Products
   │
   ├── Electronics
   │      ├── Laptop
   │      └── Phone
   │
   ├── Stationary
   │      ├── Pen
   │      └── Notebook
   │
   └── Home & Kitchen
          └── Mixer
```

`GROUP BY category` groups rows according to their category.

---

# 23. Question 4 — Categories With More Than One Product

### Requirement

> Show categories that have more than one product.

Query:

```sql id="x5m9q3"
SELECT category
FROM product
GROUP BY category
HAVING COUNT(product_id) > 1;
```

This query combines:

```text id="k7v2m4"
GROUP BY
+
COUNT()
+
HAVING
```

---

# 24. Understanding This Query

First:

```sql id="n8x3q5"
GROUP BY category
```

creates one group for each category.

Then:

```sql id="m4v7k2"
COUNT(product_id)
```

counts how many products belong to each group.

Finally:

```sql id="q9x2m6"
HAVING COUNT(product_id) > 1
```

keeps only categories whose product count is greater than one.

The flow is:

```text id="c8m3x7"
Products
   ↓
GROUP BY category
   ↓
Count products in each category
   ↓
HAVING count > 1
   ↓
Categories with multiple products
```

---

# 25. WHERE vs HAVING

This exercise introduces an important distinction.

### `WHERE`

Filters individual rows **before grouping**.

```sql id="v5m8x2"
WHERE category = 'Electronics'
```

### `HAVING`

Filters groups **after grouping**.

```sql id="r7k3q9"
HAVING COUNT(product_id) > 1
```

Mental model:

```text id="m2x8v4"
Rows
 ↓
WHERE
 ↓
GROUP BY
 ↓
Groups
 ↓
HAVING
 ↓
Final groups
```

This distinction becomes extremely important in SQL.

---

# 26. Question 5 — Sort by Price

### Requirement

> Show all products sorted by price in ascending order.

Query:

```sql id="p8m4x7"
SELECT *
FROM product
ORDER BY price ASC;
```

`ORDER BY` controls the order of the result.

`ASC` means:

> Ascending order.

For prices:

```text id="z3q7m5"
100
250
500
999
1500
```

---

# 27. ASC

`ASC` means ascending.

For numbers:

```text id="j6m2v8"
Small → Large
```

For example:

```text id="k4x8q3"
10
20
30
40
```

The query:

```sql id="y7m3p5"
ORDER BY price ASC
```

sorts from the lowest price to the highest.

---

# 28. Question 6 — First Three Products

### Requirement

> Show only the first three products from the table.

Query:

```sql id="x8m2q6"
SELECT *
FROM product
LIMIT 3;
```

`LIMIT` restricts how many rows are returned.

```text id="c4v7m9"
Table
 ↓
LIMIT 3
 ↓
Maximum 3 rows returned
```

---

# 29. Important LIMIT Detail

The query:

```sql id="a5m8x3"
SELECT *
FROM product
LIMIT 3;
```

does **not** mean:

> "Give me the three cheapest products."

It simply limits the result to three rows.

If you want the three cheapest products, you need to combine `ORDER BY` with `LIMIT`:

```sql id="n7q2m5"
SELECT *
FROM product
ORDER BY price ASC
LIMIT 3;
```

This combines:

```text id="p4x8m2"
ORDER BY
   ↓
Sort products
   ↓
LIMIT
   ↓
Take first 3
```

---

# 30. Question 7 — Rename Columns Using AS

### Requirement

> Show product name as `item_name` and price as `item_price`.

Query:

```sql id="r8m3v7"
SELECT
    name AS item_name,
    price AS item_price
FROM product;
```

`AS` creates an **alias** for the selected column in the result.

Instead of:

| name   | price |
| ------ | ----: |
| Laptop | 50000 |

the result can display:

| item_name | item_price |
| --------- | ---------: |
| Laptop    |      50000 |

---

# 31. Important Point About AS

`AS` here does not rename the actual table column.

It only changes how the column is displayed in the query result.

```text id="q5m9x3"
Actual column
     ↓
name

SELECT name AS item_name
     ↓
Result label
     ↓
item_name
```

The underlying table still has:

```text id="v7m2k8"
name
```

---

# 32. Question 8 — Unique Categories

### Requirement

> Show all unique categories from the products.

Query:

```sql id="m4x8q2"
SELECT DISTINCT category
FROM product;
```

`DISTINCT` removes duplicate values from the result.

For example, if the table contains:

```text id="z8q3v6"
Electronics
Electronics
Stationary
Stationary
Home & Kitchen
```

then:

```sql id="c7m2x9"
SELECT DISTINCT category
FROM product;
```

returns:

```text id="r5v8k3"
Electronics
Stationary
Home & Kitchen
```

---

# 33. GROUP BY vs DISTINCT

Question 3 and Question 8 may look similar:

### `GROUP BY`

```sql id="x2m7q4"
SELECT category
FROM product
GROUP BY category;
```

### `DISTINCT`

```sql id="p8v3k5"
SELECT DISTINCT category
FROM product;
```

Both can produce one row per unique category in this particular situation.

But their purposes are different.

```text id="k4m9x2"
DISTINCT
→ Remove duplicate result values

GROUP BY
→ Create groups for aggregation/analysis
```

For example, `GROUP BY` becomes especially useful when combined with:

```sql id="s7q2m8"
COUNT()
SUM()
AVG()
MIN()
MAX()
```

---

# 34. All Eight Queries — Quick Reference

| # | Requirement                | Query                                                                          |
| - | -------------------------- | ------------------------------------------------------------------------------ |
| 1 | Name + price               | `SELECT name, price FROM product;`                                             |
| 2 | Electronics products       | `SELECT * FROM product WHERE category = 'Electronics';`                        |
| 3 | Each category once         | `SELECT category FROM product GROUP BY category;`                              |
| 4 | Categories with >1 product | `SELECT category FROM product GROUP BY category HAVING COUNT(product_id) > 1;` |
| 5 | Sort by price ascending    | `SELECT * FROM product ORDER BY price ASC;`                                    |
| 6 | First 3 rows               | `SELECT * FROM product LIMIT 3;`                                               |
| 7 | Rename output columns      | `SELECT name AS item_name, price AS item_price FROM product;`                  |
| 8 | Unique categories          | `SELECT DISTINCT category FROM product;`                                       |

---

# 35. SQL Concepts Used in the Exercises

The eight questions introduce several important SQL concepts:

```text id="n3v8m5"
SELECT
  ↓
Choose columns

FROM
  ↓
Choose table

WHERE
  ↓
Filter rows

GROUP BY
  ↓
Create groups

COUNT()
  ↓
Count rows/items

HAVING
  ↓
Filter groups

ORDER BY
  ↓
Sort results

LIMIT
  ↓
Restrict number of rows

AS
  ↓
Create output alias

DISTINCT
  ↓
Remove duplicate results
```

---

# 36. Complete Learning Flow

This section connects the previous modules together:

```text id="q7m3x8"
Data Types
     ↓
Constraints
     ↓
Create Product Table
     ↓
Insert Sample Data
     ↓
Run SELECT Queries
     ↓
Filter with WHERE
     ↓
Group with GROUP BY
     ↓
Filter Groups with HAVING
     ↓
Sort with ORDER BY
     ↓
Limit with LIMIT
     ↓
Rename with AS
     ↓
Remove duplicates with DISTINCT
```

This is where the theory starts becoming practical SQL.

---

# 37. Common Mistakes / Gotchas

## 1. Manually inserting `SERIAL` IDs

If you're using:

```sql id="c5m8x2"
product_id SERIAL
```

avoid manually supplying IDs unless you have a specific reason.

Manual IDs can cause the sequence to become misaligned.

---

## 2. Forgetting that the sequence is separate from table data

Remember:

```text id="v7m2q4"
Table IDs
   ≠
Sequence state
```

They normally work together, but manually inserted IDs can cause them to become inconsistent.

---

## 3. Using WHERE when you need HAVING

Wrong concept:

```sql id="x3m8q5"
WHERE COUNT(product_id) > 1
```

For grouped results, use:

```sql id="r6k2v9"
HAVING COUNT(product_id) > 1
```

---

## 4. Thinking LIMIT sorts data

This:

```sql id="p5m8x2"
LIMIT 3
```

only limits the number of returned rows.

It does not sort them.

For the three cheapest products:

```sql id="k7q3m9"
ORDER BY price ASC
LIMIT 3;
```

---

## 5. Thinking AS permanently renames a column

```sql id="m4x8v7"
SELECT name AS item_name
```

only changes the result label.

It does not rename the actual database column.

---

## 6. Confusing GROUP BY and DISTINCT

Both can produce unique categories in simple cases, but:

```text id="z8m3q6"
DISTINCT → remove duplicate results

GROUP BY → create groups, especially useful with aggregates
```

---

# 38. Sequence Troubleshooting Checklist

If you encounter an ID conflict with a `SERIAL` column:

### Step 1 — Check the table

Find the IDs currently stored:

```sql id="v5m2x8"
SELECT product_id
FROM products;
```

### Step 2 — Check the sequence

```sql id="q8k3m7"
SELECT last_value
FROM product_id_sequence;
```

### Step 3 — Compare the values

Think:

```text id="n4x7p2"
Highest table ID
       vs
Sequence last_value
```

### Step 4 — Resynchronize

```sql id="c6m8q3"
SELECT setval(
    'product_id_sequence',
    (SELECT MAX(product_id) FROM products)
);
```

### Step 5 — Avoid the problem in the future

Let the `SERIAL` sequence generate IDs automatically.

---

# 39. Key Takeaways

* Hands-on practice is essential after learning data types and constraints.
* The project uses a **product database** with information such as:

  * product details
  * price
  * stock
  * availability
  * category
* Product categories include examples such as:

  * Electronics
  * Stationary
  * Home & Kitchen
* `SERIAL` uses an internal sequence to generate IDs.
* Manually inserting IDs can cause the sequence and actual table IDs to become misaligned.
* Check a sequence using:

```sql id="h7m3q5"
SELECT last_value
FROM product_id_sequence;
```

* Resynchronize it using:

```sql id="y4m8x2"
SELECT setval(
    'product_id_sequence',
    (SELECT MAX(product_id) FROM products)
);
```

* Best practice: **avoid manually inserting IDs into `SERIAL` columns.**
* `WHERE` filters rows.
* `GROUP BY` creates groups.
* `HAVING` filters groups.
* `ORDER BY` sorts results.
* `LIMIT` restricts the number of returned rows.
* `AS` creates an alias for a result column.
* `DISTINCT` removes duplicate values from the result.
* `GROUP BY` and `DISTINCT` may produce similar output in simple queries, but they serve different purposes.

---

# 40. One-Minute Revision

```text id="s3m8x6"
Product Project
→ Practice data types + constraints

SERIAL
→ Auto-generates IDs

Sequence
→ Generates successive ID values

Manual SERIAL ID
→ Can cause sequence misalignment

Check sequence
→ SELECT last_value FROM sequence_name;

Resync
→ setval(sequence, MAX(id))


WHERE
→ Filter rows

GROUP BY
→ Group rows

HAVING
→ Filter groups

ORDER BY
→ Sort

LIMIT
→ Limit rows

AS
→ Rename output column

DISTINCT
→ Remove duplicates
```

The most important SQL distinction:

```text id="q8m4v2"
WHERE
  ↓
Filters rows

GROUP BY
  ↓
Creates groups

HAVING
  ↓
Filters groups
```

---

# 41. Minimal Self-Test

### Project & Sequences

1. Why is hands-on practice important after learning constraints?
2. What information does the product table store?
3. What is a PostgreSQL sequence?
4. How is a sequence related to `SERIAL`?
5. What can happen if you manually insert an ID into a `SERIAL` column?
6. How do you check the current sequence value?
7. How do you resynchronize the sequence with the maximum ID?
8. What is the best practice when using `SERIAL`?

### SQL Practice

9. How do you select only `name` and `price`?
10. How do you select only Electronics products?
11. How do you show each category once using `GROUP BY`?
12. How do you find categories with more than one product?
13. Why is `HAVING` used in that query?
14. How do you sort products by price in ascending order?
15. How do you return only three rows?
16. How do you rename `name` to `item_name` in the result?
17. How do you show unique categories?
18. What is the difference between `WHERE` and `HAVING`?
19. What is the difference between `GROUP BY` and `DISTINCT`?
20. Does `LIMIT 3` mean "three cheapest products"? If not, how would you get the three cheapest products?
