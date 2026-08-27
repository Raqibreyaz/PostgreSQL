# SQL Aggregation Functions

## What it is

**Aggregation functions** perform calculations on a set of database values and return a **single summary result**.

They are useful when raw rows are not enough and you want information such as:

* How many products are there?
* What is the total price?
* What is the average price?
* What is the cheapest value?
* What is the most expensive value?

The main aggregation functions covered here are:

```text
COUNT()
SUM()
AVG()
MIN()
MAX()
```

---

## One-Sentence Summary

> **Aggregation functions turn many database values into useful summary information such as count, total, average, minimum, and maximum.**

---

# 1. Why Aggregation Functions Are Needed

Imagine the `products` table contains thousands or millions of products.

Simply running:

```sql
SELECT *
FROM products;
```

gives you the raw data.

But often you don't need every row.

Instead, you may want to ask:

```text
How many products exist?
What is the total value of all products?
What is the average product price?
What is the cheapest product?
What is the most expensive product?
```

Aggregation functions answer these kinds of questions.

---

# 2. The Five Important Aggregation Functions

| Function  | Purpose                  |
| --------- | ------------------------ |
| `COUNT()` | Counts rows/values       |
| `SUM()`   | Adds numeric values      |
| `AVG()`   | Calculates the average   |
| `MIN()`   | Finds the smallest value |
| `MAX()`   | Finds the largest value  |

A simple way to remember them:

```text
COUNT → How many?
SUM   → How much in total?
AVG   → What is the average?
MIN   → What is the smallest?
MAX   → What is the largest?
```

---

# 3. COUNT()

## What it does

`COUNT()` is used to calculate the number of rows or values.

For example:

```sql
SELECT COUNT(product_id)
FROM products;
```

This asks:

> How many `product_id` entries exist in the `products` table?

---

## Example

Suppose the table contains:

| product_id | name     |
| ---------: | -------- |
|          1 | Laptop   |
|          2 | Phone    |
|          3 | Keyboard |
|          4 | Mouse    |

Then:

```sql
SELECT COUNT(product_id)
FROM products;
```

returns:

```text
4
```

So:

```text
COUNT()
↓
Number of entries
```

---

# 4. COUNT() and Large Datasets

The source specifically points out that the result of `COUNT()` is typically returned as a **`bigint`**.

Why?

Because databases may contain extremely large numbers of rows.

For example:

```text
Millions of rows
Billions of rows
Potentially trillions of rows
```

A `bigint` provides a large range suitable for representing very large counts.

So a query such as:

```sql
SELECT COUNT(product_id)
FROM products;
```

does not simply return an ordinary small integer conceptually; PostgreSQL typically represents the count as `bigint`.

---

# 5. SUM()

## What it does

`SUM()` adds together numeric values in a column.

For example, suppose `products` contains:

| name   | price |
| ------ | ----: |
| Laptop | 50000 |
| Phone  | 20000 |
| Mouse  |  1000 |

You can calculate the total price using:

```sql
SELECT SUM(price)
FROM products;
```

Conceptually:

```text
50000 + 20000 + 1000
        ↓
       71000
```

So the result is the total of all the values in the `price` column.

---

# 6. Why SUM() Is Useful

`SUM()` is useful for calculating totals.

For example:

```text
Total product prices
Total sales
Total stock
Total revenue
```

The exact business meaning depends on what the numeric column represents.

For the `products` example:

```sql
SELECT SUM(price)
FROM products;
```

means:

> Calculate the sum of all product prices.

---

# 7. AVG()

## What it does

`AVG()` calculates the average of numeric values.

For example:

```sql
SELECT AVG(price)
FROM products;
```

Suppose the prices are:

```text
100
200
300
```

The average is:

```text
(100 + 200 + 300) / 3
= 200
```

So:

```sql
SELECT AVG(price)
FROM products;
```

returns the average price.

---

# 8. MIN()

## What it does

`MIN()` finds the smallest value in a column.

Example:

```sql
SELECT MIN(price)
FROM products;
```

Suppose:

```text
500
200
1000
50
```

Then:

```text
MIN(price)
    ↓
   50
```

So the query tells you the lowest product price.

---

# 9. MAX()

## What it does

`MAX()` finds the largest value in a column.

Example:

```sql
SELECT MAX(price)
FROM products;
```

If the prices are:

```text
500
200
1000
50
```

then:

```text
MAX(price)
    ↓
   1000
```

So the query tells you the highest product price.

---

# 10. Comparing the Aggregation Functions

Suppose:

```text
Prices:
100
200
300
400
```

Then:

```text
COUNT(price) → 4
SUM(price)   → 1000
AVG(price)   → 250
MIN(price)   → 100
MAX(price)   → 400
```

This gives you a quick summary of the entire column.

---

# 11. Aggregation + GROUP BY

Aggregation functions become even more useful when combined with `GROUP BY`.

For example:

```sql
SELECT category, COUNT(*)
FROM products
GROUP BY category;
```

This means:

> Group products by category and count the products in each category.

Conceptually:

```text
Products
   ↓
GROUP BY category
   ↓
┌─────────────────────┐
│ Electronics         │
│ Stationary          │
│ Home & Kitchen      │
└─────────────────────┘
   ↓
COUNT() for each group
```

The result could look like:

| category       | count |
| -------------- | ----: |
| Electronics    |     5 |
| Stationary     |     3 |
| Home & Kitchen |     4 |

---

# 12. Aggregation + HAVING

Aggregation can also be combined with `HAVING`.

For example:

```sql
SELECT category, COUNT(*)
FROM products
GROUP BY category
HAVING COUNT(*) > 1;
```

This means:

1. Group products by category.
2. Count products in each category.
3. Keep only categories whose count is greater than `1`.

So:

```text
GROUP BY
   ↓
COUNT()
   ↓
HAVING
   ↓
Only groups with count > 1
```

This connects directly with the previous SQL clauses module.

---

# 13. Aggregation + SQL Operators

Aggregation functions can also be used together with filtering and other SQL operators.

For example:

```sql
SELECT category, COUNT(*)
FROM products
WHERE name LIKE 'W%'
GROUP BY category;
```

Conceptually:

```text
Products
   ↓
WHERE name LIKE 'W%'
   ↓
Only matching products
   ↓
GROUP BY category
   ↓
COUNT()
   ↓
Category-wise count
```

This is where SQL starts becoming useful for real data analysis.

---

# 14. Aggregation in Data Analysis

Aggregation functions are foundational for:

* Reporting
* Data analysis
* Business intelligence
* Data science
* Database queries

Raw database data often contains thousands or millions of records.

Aggregation lets us turn that raw data into useful information.

For example:

```text
Raw data
   ↓
Aggregation
   ↓
Summary
```

Instead of looking at every product individually, you can ask:

```text
Total number of products?
Total value?
Average price?
Lowest price?
Highest price?
Products per category?
```

---

# 15. Practical Examples

## Example 1 — Count Products

```sql
SELECT COUNT(product_id)
FROM products;
```

**Question answered:**

> How many product IDs are present?

---

## Example 2 — Total Price

```sql
SELECT SUM(price)
FROM products;
```

**Question answered:**

> What is the sum of all product prices?

---

## Example 3 — Average Price

```sql
SELECT AVG(price)
FROM products;
```

**Question answered:**

> What is the average product price?

---

## Example 4 — Cheapest Product Price

```sql
SELECT MIN(price)
FROM products;
```

**Question answered:**

> What is the lowest price?

---

## Example 5 — Most Expensive Product Price

```sql
SELECT MAX(price)
FROM products;
```

**Question answered:**

> What is the highest price?

---

## Example 6 — Count Products by Category

```sql
SELECT category, COUNT(*)
FROM products
GROUP BY category;
```

**Question answered:**

> How many products are there in each category?

---

# 16. Important Mental Model

Think of aggregation functions as a way to **compress many rows into useful information**.

For example:

```text
1000 product rows
       ↓
   COUNT()
       ↓
  1000
```

Or:

```text
1000 product prices
       ↓
     SUM()
       ↓
 Total price
```

Or:

```text
1000 product prices
       ↓
     AVG()
       ↓
 Average price
```

Or:

```text
1000 product prices
       ↓
 MIN() / MAX()
       ↓
 Lowest / Highest price
```

---

# 17. Aggregation Functions Cheat Sheet

```text
COUNT()
→ Number of rows/values

SUM()
→ Total of numeric values

AVG()
→ Average of numeric values

MIN()
→ Smallest value

MAX()
→ Largest value
```

A good interview memory trick:

> **COUNT = quantity, SUM = total, AVG = average, MIN = lowest, MAX = highest.**

---

# 18. Common Mistakes / Gotchas

## 1. Using SUM() on non-numeric data

`SUM()` is intended for numeric values.

For example:

```sql
SELECT SUM(price)
FROM products;
```

makes sense because `price` is numeric.

But trying to sum a text column does not make sense.

---

## 2. Forgetting GROUP BY for category-wise aggregation

This:

```sql
SELECT COUNT(*)
FROM products;
```

counts products in the **whole table**.

While:

```sql
SELECT category, COUNT(*)
FROM products
GROUP BY category;
```

counts products **for each category**.

So:

```text
No GROUP BY
→ One overall summary

GROUP BY
→ One summary per group
```

---

## 3. Confusing COUNT with SUM

They answer completely different questions.

```sql
COUNT(price)
```

asks:

> How many values/rows?

While:

```sql
SUM(price)
```

asks:

> What is the total of the values?

Example:

```text
Prices:
100
200
300

COUNT → 3
SUM   → 600
```

---

## 4. Confusing AVG with SUM

```text
SUM → total
AVG → average
```

For:

```text
10, 20, 30
```

we get:

```text
SUM = 60
AVG = 20
```

---

# 19. Aggregation vs Normal SELECT

### Normal query

```sql
SELECT price
FROM products;
```

returns individual values:

```text
500
1000
2000
3000
...
```

### Aggregation query

```sql
SELECT SUM(price)
FROM products;
```

returns a summary:

```text
6500
```

So:

```text
Normal SELECT
→ Individual data

Aggregation
→ Summary data
```

---

# 20. Key Takeaways

* Aggregation functions perform calculations over database values.
* The five important functions covered are `COUNT`, `SUM`, `AVG`, `MIN`, and `MAX`.
* `COUNT()` calculates the number of rows/values.
* `COUNT(product_id)` can be used to count product IDs.
* PostgreSQL typically returns `COUNT()` as `bigint`, allowing very large counts.
* `SUM()` adds numeric values.
* `AVG()` calculates an average.
* `MIN()` finds the smallest value.
* `MAX()` finds the largest value.
* Aggregation functions are extremely useful for reporting and data analysis.
* They are frequently combined with `GROUP BY`.
* `HAVING` can filter grouped results based on aggregate values.
* Operators and filtering clauses can also be combined with aggregation to create more specific analysis queries.

---

# 21. One-Minute Revision

```text
COUNT()
→ How many?

SUM()
→ What is the total?

AVG()
→ What is the average?

MIN()
→ What is the smallest?

MAX()
→ What is the largest?
```

Example:

```sql
SELECT COUNT(product_id)
FROM products;
```

→ Total number of product entries.

```sql
SELECT SUM(price)
FROM products;
```

→ Total of all prices.

```sql
SELECT AVG(price)
FROM products;
```

→ Average price.

```sql
SELECT MIN(price)
FROM products;
```

→ Lowest price.

```sql
SELECT MAX(price)
FROM products;
```

→ Highest price.

And with grouping:

```sql
SELECT category, COUNT(*)
FROM products
GROUP BY category;
```

→ Number of products in each category.

---

# 22. Minimal Self-Test

1. What is an aggregation function?
2. What does `COUNT()` do?
3. What does `SUM()` do?
4. What does `AVG()` do?
5. What does `MIN()` do?
6. What does `MAX()` do?
7. What is the difference between `COUNT()` and `SUM()`?
8. What is the difference between `SUM()` and `AVG()`?
9. What data type does PostgreSQL typically return for `COUNT()`?
10. Why is `bigint` useful for `COUNT()`?
11. Write a query to count all product IDs.
12. Write a query to calculate the total price of all products.
13. Write a query to find the average product price.
14. Write a query to find the cheapest product price.
15. Write a query to find the highest product price.
16. Write a query to count products in each category.
17. Why is `GROUP BY` useful with aggregation functions?
18. How can `HAVING` be used with `COUNT()`?
19. What is the difference between aggregation over the whole table and aggregation with `GROUP BY`?
20. Explain `COUNT`, `SUM`, `AVG`, `MIN`, and `MAX` using one simple example.
