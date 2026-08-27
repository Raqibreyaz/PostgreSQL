# SQL Exercise 2: Subqueries, IN, Aggregation & Advanced Filtering

## What it is

This module applies the SQL concepts learned so far through practical exercises.

The main concepts are:

* **Subqueries**
* Finding minimum and maximum values
* `IN` for matching multiple values
* Combining `WHERE` with aggregation
* Multiple conditions using `AND`
* `<>` for "not equal"
* `GROUP BY` with aggregate functions
* Column aliasing using `AS`
* `DISTINCT`
* `UPPER()`
* Sorting transformed values using `ORDER BY`
* Understanding why `GROUP BY` is required in certain aggregate queries

---

## One-Sentence Summary

> **This exercise shows how to combine SQL filtering, aggregation, subqueries, grouping, functions, and operators to solve practical data-analysis questions.**

---

# 1. Finding the Cheapest Product

## Problem

> Display the `name` and `price` of the cheapest product in the table.

We need to solve two separate problems:

1. Find the minimum price.
2. Find the product(s) having that price.

---

## Step 1 — Find the Minimum Price

We can use:

```sql
SELECT MIN(price)
FROM product;
```

Suppose the result is:

```text
299
```

Now we know that the cheapest price is `299`.

But this query only gives us the price.

It does **not** give us the product name.

---

# 2. Using a Subquery

A **subquery** is a query written inside another SQL query.

Here:

```sql
SELECT name, price
FROM product
WHERE price = (
    SELECT MIN(price)
    FROM product
);
```

The inner query:

```sql
SELECT MIN(price)
FROM product
```

runs first conceptually and determines the minimum price.

Then the outer query uses that value:

```sql
WHERE price = minimum_price
```

---

## Visual Flow

```text
product table
     │
     ▼
SELECT MIN(price)
     │
     ▼
minimum price
     │
     ▼
WHERE price = minimum price
     │
     ▼
name + price of cheapest product
```

---

# 3. Why Use a Subquery Here?

Suppose the data is:

| name     | price |
| -------- | ----: |
| Laptop   | 50000 |
| Phone    | 20000 |
| Mouse    |   299 |
| Keyboard |  1000 |

First:

```sql
SELECT MIN(price)
FROM product;
```

gives:

```text
299
```

Then:

```sql
SELECT name, price
FROM product
WHERE price = 299;
```

returns:

| name  | price |
| ----- | ----: |
| Mouse |   299 |

The subquery combines both steps into one query:

```sql
SELECT name, price
FROM product
WHERE price = (SELECT MIN(price) FROM product);
```

### Important point

If multiple products have the same minimum price, this query can return **multiple products**.

For example:

| name  | price |
| ----- | ----: |
| Mouse |   299 |
| Cable |   299 |

Both satisfy:

```text
price = MIN(price)
```

So both can be returned.

---

# 4. Average Price for Multiple Categories

## Problem

> Find the average price of products belonging to either `Home & Kitchen` or `Fitness`.

We need:

1. `AVG()` → calculate average.
2. `IN` → match multiple categories.
3. `WHERE` → filter the products.

Query:

```sql
SELECT AVG(price)
FROM product
WHERE category IN ('Home & Kitchen', 'Fitness');
```

---

# 5. Understanding IN

`IN` allows us to check whether a value belongs to a list of specified values.

Instead of writing:

```sql
WHERE category = 'Home & Kitchen'
   OR category = 'Fitness'
```

we can write:

```sql
WHERE category IN ('Home & Kitchen', 'Fitness')
```

This is cleaner and easier to read.

Mental model:

```text
category IN (A, B, C)
             │  │  │
             └──┴──┴── allowed values
```

So:

```sql
category IN ('Fitness', 'Home & Kitchen')
```

means:

> Category must be either `Fitness` or `Home & Kitchen`.

---

# 6. Combining IN with AVG

The complete query is:

```sql
SELECT AVG(price)
FROM product
WHERE category IN ('Home & Kitchen', 'Fitness');
```

Conceptually:

```text
All products
     ↓
Keep Fitness + Home & Kitchen
     ↓
Take their prices
     ↓
AVG(price)
     ↓
Average price
```

### Important distinction

This query calculates **one overall average** across products belonging to those two categories.

It does **not** calculate a separate average for each category.

For separate averages, you would need `GROUP BY category`.

---

# 7. Multiple Conditions with AND

## Problem

> Show product names and stock quantity where:
>
> * Product is available.
> * Stock is greater than 50.
> * Price is not equal to 299.

We have three conditions.

```sql
SELECT name, stock_quantity
FROM product
WHERE is_available = true
AND stock_quantity > 50
AND price <> 299;
```

---

# 8. Breaking Down the Query

### Condition 1

```sql
is_available = true
```

The product must be available.

### Condition 2

```sql
stock_quantity > 50
```

The stock must be greater than 50.

### Condition 3

```sql
price <> 299
```

The price must not be equal to 299.

Because these conditions are connected using `AND`, **all three conditions must be satisfied**.

```text
Available
   AND
Stock > 50
   AND
Price ≠ 299
```

Only then is the row returned.

---

# 9. The `<>` Operator

The operator:

```sql
<>
```

means:

> **Not equal to**

For example:

```sql
price <> 299
```

means:

```text
price is anything except 299
```

So:

```text
299 → excluded
500 → included
1000 → included
1999 → included
```

---

# 10. `AND` Reminder

This exercise is another practical example of `AND`.

```sql
WHERE A
AND B
AND C
```

means:

```text
A = TRUE
B = TRUE
C = TRUE
```

All conditions must be true.

If even one condition is false, the row is excluded.

---

# 11. Finding the Most Expensive Product in Each Category

## Problem

> Find the most expensive product in each category and show its category and maximum price.

This is where `GROUP BY` and `MAX()` work together.

Query:

```sql
SELECT category, MAX(price) AS max_price
FROM product
GROUP BY category;
```

---

# 12. Understanding MAX()

`MAX(price)` finds the highest price.

For the whole table:

```sql
SELECT MAX(price)
FROM product;
```

returns one maximum price.

But the question asks:

> Maximum price **in each category**.

Therefore, we need to divide the data into categories.

That's the job of:

```sql
GROUP BY category
```

---

# 13. GROUP BY + MAX()

Suppose the table contains:

| category    | name      | price |
| ----------- | --------- | ----: |
| Electronics | Laptop    | 50000 |
| Electronics | Mouse     |  1000 |
| Electronics | Phone     | 20000 |
| Fitness     | Treadmill | 50000 |
| Fitness     | Yoga Mat  |  1000 |
| Stationary  | Pen       |    50 |
| Stationary  | Notebook  |   200 |

Running:

```sql
SELECT category, MAX(price) AS max_price
FROM product
GROUP BY category;
```

could produce:

| category    | max_price |
| ----------- | --------: |
| Electronics |     50000 |
| Fitness     |     50000 |
| Stationary  |       200 |

The database:

```text
Groups rows by category
        ↓
Finds MAX(price) inside each group
        ↓
Returns one result per category
```

---

# 14. Important: "Maximum Product" vs "Maximum Price"

The exercise asks for:

```text
category + maximum price
```

The query:

```sql
SELECT category, MAX(price) AS max_price
FROM product
GROUP BY category;
```

does **not** return the name of the product having that maximum price.

For example, if:

```text
Electronics → Laptop → 50000
```

the query returns:

```text
Electronics | 50000
```

It does not return:

```text
Electronics | Laptop | 50000
```

The source specifically demonstrates the category and maximum price query.

---

# 15. Why GROUP BY Is Required

Consider:

```sql
SELECT category, MAX(price)
FROM product;
```

There is a problem.

`MAX(price)` produces a single aggregate result, but `category` contains potentially many different values.

SQL needs to know:

> How should categories be associated with the aggregated price?

Do we want:

```text
One maximum for the entire table?
```

or:

```text
One maximum for each category?
```

`GROUP BY category` gives SQL that instruction.

Correct:

```sql
SELECT category, MAX(price)
FROM product
GROUP BY category;
```

---

# 16. The General Rule

When using an aggregate function together with a normal column in the `SELECT` list, the normal column generally needs to be included in `GROUP BY`.

For example:

```sql
SELECT category, MAX(price)
FROM product
GROUP BY category;
```

Here:

```text
category → grouped column
MAX(price) → aggregate
```

This tells SQL:

> Calculate the maximum price separately for each category.

---

# 17. Column Aliasing with AS

The query uses:

```sql
MAX(price) AS max_price
```

`AS` creates an alias.

Instead of displaying the expression:

```text
max
```

or an automatically generated column name, we give the output a readable name:

```text
max_price
```

Example:

```sql
SELECT MAX(price) AS max_price
FROM product;
```

The actual database column is **not renamed**.

The alias only changes the name shown in the query result.

---

# 18. DISTINCT + UPPER() + ORDER BY

## Problem

> Show all unique categories in uppercase and sort them in descending order.

Query:

```sql
SELECT DISTINCT UPPER(category) AS category
FROM product
ORDER BY category DESC;
```

This query combines three concepts:

```text
DISTINCT
UPPER()
ORDER BY ... DESC
```

---

# 19. UPPER()

`UPPER()` converts text to uppercase.

For example:

```text
electronics
```

becomes:

```text
ELECTRONICS
```

Example:

```sql
SELECT UPPER(category)
FROM product;
```

If the original values are:

```text
Electronics
Fitness
Home & Kitchen
```

the output becomes:

```text
ELECTRONICS
FITNESS
HOME & KITCHEN
```

---

# 20. DISTINCT

`DISTINCT` removes duplicate values from the result.

Suppose:

```text
Electronics
Electronics
Fitness
Fitness
Stationary
```

Without `DISTINCT`:

```text
Electronics
Electronics
Fitness
Fitness
Stationary
```

With:

```sql
SELECT DISTINCT category
FROM product;
```

we get:

```text
Electronics
Fitness
Stationary
```

Each category appears once.

---

# 21. Combining DISTINCT and UPPER()

The query:

```sql
SELECT DISTINCT UPPER(category) AS category
FROM product;
```

means:

1. Take the category.
2. Convert it to uppercase.
3. Remove duplicate results.

Example:

```text
Electronics
ELECTRONICS
electronics
Fitness
FITNESS
```

After applying:

```sql
UPPER(category)
```

they become:

```text
ELECTRONICS
ELECTRONICS
ELECTRONICS
FITNESS
FITNESS
```

Then `DISTINCT` removes duplicates:

```text
ELECTRONICS
FITNESS
```

---

# 22. Sorting in Descending Order

The query ends with:

```sql
ORDER BY category DESC;
```

`DESC` means:

> Descending order.

So the unique uppercase categories are sorted from higher to lower according to their text ordering.

Example:

```text
FITNESS
HOME & KITCHEN
STATIONARY
```

would be ordered according to descending alphabetical order.

---

# 23. Why Use the Alias in ORDER BY?

The query is:

```sql
SELECT DISTINCT UPPER(category) AS category
FROM product
ORDER BY category DESC;
```

Here:

```sql
UPPER(category) AS category
```

gives the transformed result the alias `category`.

Then:

```sql
ORDER BY category DESC
```

sorts using that output name.

This makes the query cleaner than repeating:

```sql
ORDER BY UPPER(category) DESC;
```

---

# 24. Complete Exercise Cheat Sheet

## Question 1 — Cheapest Product

```sql
SELECT name, price
FROM product
WHERE price = (
    SELECT MIN(price)
    FROM product
);
```

### Concepts

```text
MIN()
Subquery
WHERE
```

---

## Question 2 — Average Price of Selected Categories

```sql
SELECT AVG(price)
FROM product
WHERE category IN ('Home & Kitchen', 'Fitness');
```

### Concepts

```text
AVG()
IN
WHERE
```

---

## Question 3 — Available Products With Stock > 50 and Price ≠ 299

```sql
SELECT name, stock_quantity
FROM product
WHERE is_available = true
AND stock_quantity > 50
AND price <> 299;
```

### Concepts

```text
WHERE
AND
>
<>
Boolean condition
```

---

## Question 4 — Maximum Price Per Category

```sql
SELECT category, MAX(price) AS max_price
FROM product
GROUP BY category;
```

### Concepts

```text
MAX()
GROUP BY
AS
```

---

## Question 5 — Unique Uppercase Categories, Descending

```sql
SELECT DISTINCT UPPER(category) AS category
FROM product
ORDER BY category DESC;
```

### Concepts

```text
DISTINCT
UPPER()
AS
ORDER BY
DESC
```

---

# 25. Important Concepts From This Exercise

This exercise connects several SQL concepts together:

```text
                    SQL Exercise
                         │
       ┌─────────────────┼─────────────────┐
       ↓                 ↓                 ↓
   Subquery          Filtering         Aggregation
       │                 │                 │
    MIN()           WHERE / AND       AVG() / MAX()
       │                 │                 │
       ↓                 ↓                 ↓
  Cheapest       Multiple conditions   GROUP BY
       │                                   │
       └───────────────────────────────────┘
                         │
                    Output formatting
                         │
                  DISTINCT / UPPER / AS
                         │
                       ORDER BY
```

---

# 26. Common Mistakes / Gotchas

## 1. Using `MIN(price)` alone when the name is required

This:

```sql
SELECT MIN(price)
FROM product;
```

only gives the minimum price.

If you also need the product name, use the subquery approach:

```sql
SELECT name, price
FROM product
WHERE price = (SELECT MIN(price) FROM product);
```

---

## 2. Forgetting that multiple products can have the same minimum price

If two products have the same cheapest price, the subquery approach can return both.

That is often correct because both products satisfy:

```text
price = minimum price
```

---

## 3. Using OR instead of IN unnecessarily

Instead of:

```sql
WHERE category = 'Fitness'
OR category = 'Home & Kitchen'
```

you can use:

```sql
WHERE category IN ('Fitness', 'Home & Kitchen')
```

`IN` is especially convenient when the list becomes larger.

---

## 4. Forgetting GROUP BY

This is problematic:

```sql
SELECT category, MAX(price)
FROM product;
```

because `category` is not aggregated and SQL has not been told how to group the categories.

Use:

```sql
SELECT category, MAX(price)
FROM product
GROUP BY category;
```

---

## 5. Thinking MAX() returns the product name

This:

```sql
MAX(price)
```

returns the maximum **price**, not the product that owns that price.

So:

```sql
SELECT category, MAX(price)
FROM product
GROUP BY category;
```

returns:

```text
category + maximum price
```

not:

```text
category + product name + maximum price
```

---

## 6. Confusing `<>` with `=`

```sql
price = 299
```

means:

> Price must be 299.

While:

```sql
price <> 299
```

means:

> Price must not be 299.

---

## 7. Forgetting that `DISTINCT` applies to the selected result

In:

```sql
SELECT DISTINCT UPPER(category)
FROM product;
```

the uppercase transformation happens before considering the final distinct values.

This is useful when category values may differ in letter casing.

---

# 27. Interview-Level Understanding

### Q: What is a subquery?

A query nested inside another query.

Example:

```sql
SELECT name, price
FROM product
WHERE price = (
    SELECT MIN(price)
    FROM product
);
```

---

### Q: Why use `GROUP BY` with `MAX()`?

Because `GROUP BY` allows the aggregate calculation to happen separately for each group.

```sql
MAX(price)
```

alone:

```text
Maximum price of entire result
```

While:

```sql
MAX(price) + GROUP BY category
```

means:

```text
Maximum price for each category
```

---

### Q: What does `IN` do?

It checks whether a value matches one of several specified values.

```sql
category IN ('Fitness', 'Home & Kitchen')
```

is a concise way to express multiple equality conditions.

---

### Q: What does `AS` do?

It creates an alias for an output column.

```sql
MAX(price) AS max_price
```

The underlying database column is not renamed.

---

### Q: What does `<>` mean?

It means **not equal to**.

```sql
price <> 299
```

means the price is not 299.

---

# 28. Key Takeaways

* A **subquery** is a query inside another query.
* `MIN()` can be used inside a subquery to find the cheapest product.
* The outer query can then use that value to retrieve related information such as `name` and `price`.
* `IN` is useful when filtering against multiple possible values.
* `AVG()` calculates the average of the filtered rows.
* `AND` requires every condition to be true.
* `<>` means "not equal to."
* `MAX()` finds the highest value.
* `GROUP BY` allows aggregate calculations such as `MAX()` to be performed separately for each category.
* `AS` creates a temporary output alias.
* `UPPER()` converts text to uppercase.
* `DISTINCT` removes duplicate results.
* `ORDER BY ... DESC` sorts results in descending order.
* Combining these concepts is what makes SQL powerful for practical data analysis.

---

# 29. One-Minute Revision

```text
Subquery
→ Query inside another query

MIN()
→ Smallest value

MAX()
→ Largest value

AVG()
→ Average value

IN
→ Match any value from a list

AND
→ All conditions must be true

<>
→ Not equal

GROUP BY
→ Create groups for aggregation

AS
→ Give output a temporary alias

UPPER()
→ Convert text to uppercase

DISTINCT
→ Remove duplicate results

ORDER BY ... DESC
→ Sort in descending order
```

### Most important queries

```sql
-- Cheapest product
SELECT name, price
FROM product
WHERE price = (SELECT MIN(price) FROM product);
```

```sql
-- Average price for selected categories
SELECT AVG(price)
FROM product
WHERE category IN ('Home & Kitchen', 'Fitness');
```

```sql
-- Multiple filtering conditions
SELECT name, stock_quantity
FROM product
WHERE is_available = true
AND stock_quantity > 50
AND price <> 299;
```

```sql
-- Maximum price per category
SELECT category, MAX(price) AS max_price
FROM product
GROUP BY category;
```

```sql
-- Unique uppercase categories, descending
SELECT DISTINCT UPPER(category) AS category
FROM product
ORDER BY category DESC;
```

---

# 30. Minimal Self-Test

1. What is a subquery?
2. Why can't `SELECT MIN(price) FROM product` alone give you the product name?
3. Write a query to find the cheapest product's name and price.
4. What happens if multiple products have the same minimum price?
5. What does the `IN` operator do?
6. Rewrite an `IN` condition using `OR`.
7. What does `price <> 299` mean?
8. Why are all three conditions in Question 3 connected using `AND`?
9. What does `MAX(price)` return?
10. How does `GROUP BY category` change the meaning of `MAX(price)`?
11. Why is `GROUP BY` needed when selecting `category` with `MAX(price)`?
12. What does `AS max_price` do?
13. Does a column alias permanently rename the database column?
14. What does `UPPER(category)` do?
15. What does `DISTINCT` do?
16. What does `ORDER BY category DESC` do?
17. Explain the execution idea behind the cheapest-product subquery.
18. Explain the difference between `MAX(price)` for the entire table and `MAX(price) GROUP BY category`.
19. Write a query to find products whose price is not `299`.
20. Write a query to display unique categories in uppercase and sort them in descending order.
