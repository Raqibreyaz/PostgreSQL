# SQL Clauses: Filtering, Grouping, Sorting & Limiting

## What it is

SQL clauses control **how data is retrieved and presented** from a database.

In this module, the focus is on practical querying of the `products` table using:

```text
SELECT
FROM
WHERE
GROUP BY
HAVING
ORDER BY
LIMIT
AS
```

These clauses are the foundation for writing useful SQL queries.

---

## One-Sentence Summary

> **SQL clauses let us choose the data we need, filter it, group it, aggregate it, sort it, limit it, and give the output readable names.**

---

# 1. The Basic SQL Query

The simplest query starts with:

```sql
SELECT ...
FROM ...;
```

Think of it as:

```text
SELECT → What do I want?
FROM   → Where should I get it from?
```

For example:

```sql
SELECT name, price
FROM products;
```

This asks PostgreSQL:

> "Give me the name and price of every product."

---

# 2. SELECT — Choosing Columns

## What it does

`SELECT` specifies the columns you want to retrieve.

Example:

```sql
SELECT name, price
FROM products;
```

The result contains only:

```text
name
price
```

It does **not** display the other columns from the table.

---

## `SELECT *`

You can also use:

```sql
SELECT *
FROM products;
```

`*` means:

> Select all columns.

So:

```sql
SELECT name, price
FROM products;
```

means:

```text
Only name + price
```

while:

```sql
SELECT *
FROM products;
```

means:

```text
All columns
```

---

# 3. FROM — Choosing the Table

`FROM` tells SQL where the data should come from.

Example:

```sql
SELECT name, price
FROM products;
```

Here:

```text
SELECT → name, price
FROM   → products
```

So the database retrieves the requested columns from the `products` table.

---

# 4. WHERE — Filtering Rows

## What it is

The `WHERE` clause filters rows based on a condition.

Example:

```sql
SELECT *
FROM products
WHERE category = 'Electronics';
```

This means:

> Return only products whose category is `Electronics`.

---

## Mental Model

Suppose the table contains:

| name   | category       |
| ------ | -------------- |
| Laptop | Electronics    |
| Pen    | Stationary     |
| Phone  | Electronics    |
| Mixer  | Home & Kitchen |

The query:

```sql
SELECT *
FROM products
WHERE category = 'Electronics';
```

filters the rows:

```text
All products
     ↓
category = 'Electronics'
     ↓
Laptop
Phone
```

---

# 5. WHERE Filters Before Grouping

One of the most important concepts in SQL is understanding that `WHERE` works on individual rows.

For example:

```sql
SELECT *
FROM products
WHERE category = 'Electronics';
```

The database checks each product and asks:

```text
Is category = Electronics?
```

If yes → keep the row.

If no → remove the row from the result.

---

# 6. GROUP BY — Grouping Data

## What it is

`GROUP BY` groups rows that have the same value in a particular column.

Example:

```sql
SELECT category
FROM products
GROUP BY category;
```

If the data contains:

```text
Electronics
Electronics
Stationary
Stationary
Home & Kitchen
```

the grouped result contains each category once:

```text
Electronics
Stationary
Home & Kitchen
```

---

# 7. Why GROUP BY Is Useful

`GROUP BY` becomes especially useful when you want to perform calculations on groups.

For example:

```text
Category
   ↓
Group products
   ↓
Count products
   ↓
Generate a report
```

This is commonly used with aggregate functions such as:

```text
COUNT()
SUM()
AVG()
MIN()
MAX()
```

The source specifically demonstrates `COUNT()`.

---

# 8. HAVING — Filtering Groups

## What it is

`HAVING` filters the results **after grouping and aggregation**.

This is different from `WHERE`.

Example:

```sql
SELECT category, COUNT(*)
FROM products
GROUP BY category
HAVING COUNT(*) > 1;
```

This means:

> Group products by category, count the products in each category, and show only categories containing more than one product.

---

# 9. Breaking Down the HAVING Query

Let's look at it step by step:

```sql
SELECT category, COUNT(*)
FROM products
GROUP BY category
HAVING COUNT(*) > 1;
```

### Step 1 — `FROM`

```sql
FROM products
```

Start with the `products` table.

### Step 2 — `GROUP BY`

```sql
GROUP BY category
```

Create one group for each category.

### Step 3 — `COUNT(*)`

```sql
COUNT(*)
```

Count the rows in each group.

### Step 4 — `HAVING`

```sql
HAVING COUNT(*) > 1
```

Keep only groups whose count is greater than `1`.

---

# 10. Example of GROUP BY + COUNT + HAVING

Suppose:

| Product  | Category       |
| -------- | -------------- |
| Laptop   | Electronics    |
| Phone    | Electronics    |
| Pen      | Stationary     |
| Notebook | Stationary     |
| Mixer    | Home & Kitchen |

After grouping:

```text
Electronics      → 2
Stationary       → 2
Home & Kitchen   → 1
```

Then:

```sql
HAVING COUNT(*) > 1
```

removes:

```text
Home & Kitchen → 1
```

Final result:

```text
Electronics → 2
Stationary  → 2
```

---

# 11. WHERE vs HAVING

This is one of the most important comparisons in this module.

| `WHERE`                  | `HAVING`                            |
| ------------------------ | ----------------------------------- |
| Filters rows             | Filters groups                      |
| Works before aggregation | Works after aggregation             |
| Used for row conditions  | Used for group/aggregate conditions |

### Example of WHERE

```sql
SELECT *
FROM products
WHERE category = 'Electronics';
```

### Example of HAVING

```sql
SELECT category, COUNT(*)
FROM products
GROUP BY category
HAVING COUNT(*) > 1;
```

Mental model:

```text
Rows
 ↓
WHERE
 ↓
Filtered rows
 ↓
GROUP BY
 ↓
Groups
 ↓
Aggregate functions
 ↓
HAVING
 ↓
Filtered groups
```

---

# 12. ORDER BY — Sorting Results

## What it is

`ORDER BY` controls the order in which rows are returned.

You can sort by:

* Numeric values such as `price`
* Character values such as `name`

Example:

```sql
SELECT *
FROM products
ORDER BY price ASC;
```

This sorts products by price.

---

# 13. ASC — Ascending Order

`ASC` means **ascending**.

For numbers:

```text
10
20
30
40
50
```

For names, it means alphabetical ordering.

The source notes that ascending order is the default behavior.

So:

```sql
ORDER BY price;
```

and:

```sql
ORDER BY price ASC;
```

represent ascending sorting.

Being explicit with `ASC` can still make your intention clearer.

---

# 14. DESC — Descending Order

To sort in descending order, use:

```sql
ORDER BY price DESC;
```

For example:

```text
5000
3000
2000
1000
500
```

So:

```text
ASC → Small → Large
DESC → Large → Small
```

---

# 15. ORDER BY Works With Different Data Types

The source highlights that `ORDER BY` is not limited to numbers.

### Numeric example

```sql
SELECT *
FROM products
ORDER BY price ASC;
```

Sorts by price.

### Character example

```sql
SELECT *
FROM products
ORDER BY name ASC;
```

Sorts by product name alphabetically.

So the general idea is:

```sql
ORDER BY column_name;
```

---

# 16. LIMIT — Restricting the Number of Rows

## What it is

`LIMIT` restricts how many rows are returned.

Example:

```sql
SELECT *
FROM products
LIMIT 3;
```

This returns only the first three records from the result.

---

# 17. Why LIMIT Is Useful

`LIMIT` becomes particularly useful when working with large datasets.

Imagine a table containing:

```text
1,000,000 products
```

You may not want to retrieve all one million rows just to inspect the data.

Instead:

```sql
SELECT *
FROM products
LIMIT 3;
```

returns only three records.

Mental model:

```text
Large dataset
     ↓
LIMIT 3
     ↓
3 rows
```

---

# 18. LIMIT + ORDER BY

`LIMIT` can be combined with `ORDER BY`.

For example, to get the three cheapest products:

```sql
SELECT *
FROM products
ORDER BY price ASC
LIMIT 3;
```

The logic is:

```text
Products
   ↓
Sort by price
   ↓
Lowest → Highest
   ↓
Take first 3
```

Similarly, the three most expensive:

```sql
SELECT *
FROM products
ORDER BY price DESC
LIMIT 3;
```

---

# 19. AS — Column Aliasing

## What it is

`AS` provides a temporary, readable name for a column in the query output.

Example:

```sql
SELECT name AS "Item Name"
FROM products;
```

Instead of displaying:

```text
name
```

the result displays:

```text
Item Name
```

---

# 20. AS Does Not Rename the Actual Column

This is important.

Suppose the actual database column is:

```text
name
```

and you write:

```sql
SELECT name AS "Item Name"
FROM products;
```

The actual table structure is unchanged.

```text
Database column
      ↓
name

Query output
      ↓
Item Name
```

The alias only affects the query result.

---

# 21. Why Use AS?

Aliases can make query results easier to understand.

For example:

```sql
SELECT
    name AS "Item Name",
    price AS "Item Price"
FROM products;
```

Result:

| Item Name | Item Price |
| --------- | ---------: |
| Laptop    |      50000 |
| Phone     |      20000 |

This is often more readable for users or reports.

---

# 22. Complete Clause Flow

The concepts in this module can be connected together:

```text
FROM
 ↓
Get data from table
 ↓
WHERE
 ↓
Filter rows
 ↓
GROUP BY
 ↓
Create groups
 ↓
Aggregate
 ↓
HAVING
 ↓
Filter groups
 ↓
SELECT
 ↓
Choose/display columns
 ↓
ORDER BY
 ↓
Sort result
 ↓
LIMIT
 ↓
Restrict number of rows
```

This is a useful mental model for understanding more complex SQL queries.

---

# 23. Practical Query Examples

## Example 1 — Name and Price

```sql
SELECT name, price
FROM products;
```

**Purpose:** Show only product names and prices.

---

## Example 2 — Electronics

```sql
SELECT *
FROM products
WHERE category = 'Electronics';
```

**Purpose:** Show products belonging to Electronics.

---

## Example 3 — Unique Categories Using GROUP BY

```sql
SELECT category
FROM products
GROUP BY category;
```

**Purpose:** Show each category once.

---

## Example 4 — Categories With More Than One Product

```sql
SELECT category, COUNT(*)
FROM products
GROUP BY category
HAVING COUNT(*) > 1;
```

**Purpose:** Show categories containing more than one product, along with their counts.

---

## Example 5 — Sort by Price

```sql
SELECT *
FROM products
ORDER BY price ASC;
```

**Purpose:** Display products from lowest price to highest price.

---

## Example 6 — Sort by Name

```sql
SELECT *
FROM products
ORDER BY name ASC;
```

**Purpose:** Sort products alphabetically by name.

---

## Example 7 — First Three Products

```sql
SELECT *
FROM products
LIMIT 3;
```

**Purpose:** Return only three records.

---

## Example 8 — Alias a Column

```sql
SELECT name AS "Item Name"
FROM products;
```

**Purpose:** Display `name` using a more readable output label.

---

# 24. Combining Multiple Clauses

Real SQL queries commonly combine several clauses.

For example:

```sql
SELECT name, price
FROM products
WHERE category = 'Electronics'
ORDER BY price ASC
LIMIT 3;
```

Read this conceptually as:

```text
products
   ↓
Only Electronics
   ↓
Sort by price
   ↓
Lowest price first
   ↓
Take 3
   ↓
Show name + price
```

This is much closer to how SQL is used in real applications.

---

# 25. Common Mistakes / Gotchas

## 1. Confusing WHERE and HAVING

Remember:

```text
WHERE  → filters rows
HAVING → filters groups
```

If your condition involves an aggregate such as:

```sql
COUNT(*)
```

you will commonly need `HAVING` when filtering the grouped result.

---

## 2. Thinking GROUP BY simply means "remove duplicates"

For a query like:

```sql
SELECT category
FROM products
GROUP BY category;
```

the output may look like unique values.

But the main purpose of `GROUP BY` is to **create groups for aggregation and analysis**.

For simply removing duplicates, `DISTINCT` is the more direct concept.

---

## 3. Thinking LIMIT chooses specific records

```sql
LIMIT 3
```

means:

> Return three rows.

It does not inherently mean:

> Return the three cheapest products.

For that, combine it with sorting:

```sql
ORDER BY price ASC
LIMIT 3;
```

---

## 4. Thinking AS permanently renames a column

```sql
name AS "Item Name"
```

only changes the label in the result.

It does not change the actual database column.

---

## 5. Forgetting DESC

If you want highest-to-lowest:

```sql
ORDER BY price DESC;
```

not:

```sql
ORDER BY price ASC;
```

---

# 26. Quick Comparison

| Clause     | Question it answers               |
| ---------- | --------------------------------- |
| `SELECT`   | What data do I want?              |
| `FROM`     | Which table contains it?          |
| `WHERE`    | Which rows should I keep?         |
| `GROUP BY` | How should I group the rows?      |
| `HAVING`   | Which groups should I keep?       |
| `ORDER BY` | In what order should I show them? |
| `LIMIT`    | How many rows should I return?    |
| `AS`       | What label should I display?      |

---

# 27. Key Takeaways

* `SELECT` chooses the columns to retrieve.
* `FROM` specifies the table.
* `SELECT *` retrieves all columns.
* `WHERE` filters individual rows based on a condition.
* `GROUP BY` creates groups of rows with the same values.
* `GROUP BY` becomes especially useful with aggregate functions such as `COUNT()`.
* `HAVING` filters groups after aggregation.
* `WHERE` works before grouping; `HAVING` works after grouping.
* `ORDER BY` controls result ordering.
* `ASC` means ascending and is the default ordering.
* `DESC` means descending.
* `ORDER BY` works with numeric and character data.
* `LIMIT` restricts the number of rows returned.
* `LIMIT` is useful when working with large datasets.
* `AS` creates a temporary alias for a column in the query output.
* `AS` does not change the actual database column name.
* Multiple clauses can be combined to answer more practical questions.

---

# 28. One-Minute Revision

```text
SELECT
→ Choose columns

FROM
→ Choose table

WHERE
→ Filter rows

GROUP BY
→ Create groups

COUNT()
→ Count rows/items

HAVING
→ Filter groups

ORDER BY
→ Sort results

ASC
→ Low → High / A → Z

DESC
→ High → Low / Z → A

LIMIT
→ Restrict number of rows

AS
→ Temporary output alias
```

Most important distinction:

```text
WHERE
  ↓
Filter individual rows

GROUP BY
  ↓
Create groups

HAVING
  ↓
Filter those groups
```

---

# 29. Minimal Self-Test

1. What is the purpose of `SELECT`?
2. What does `FROM` specify?
3. What is the difference between `SELECT *` and selecting specific columns?
4. What does `WHERE` do?
5. What does `GROUP BY` do?
6. Why is `GROUP BY` useful with aggregate functions?
7. What does `COUNT(*)` do?
8. What is the difference between `WHERE` and `HAVING`?
9. What does `ORDER BY` do?
10. What is the difference between `ASC` and `DESC`?
11. What is the default sorting direction?
12. Can `ORDER BY` sort character data?
13. What does `LIMIT 3` do?
14. How would you find the three cheapest products?
15. What does `AS` do?
16. Does `AS` permanently rename a database column?
17. Write a query that shows Electronics products ordered from cheapest to most expensive.
18. Write a query that shows categories having more than one product.
19. Write a query that displays product names as `"Item Name"`.
20. Explain the logical difference between `DISTINCT` and `GROUP BY`.

---

# 30. What to Learn Next

The natural next step is to go deeper into **SQL filtering and conditions**, including:

```text
WHERE
 ↓
Comparison operators
 ↓
AND / OR / NOT
 ↓
IN
 ↓
BETWEEN
 ↓
LIKE
 ↓
IS NULL
 ↓
More complex filtering
```

After that, aggregate functions such as `COUNT`, `SUM`, `AVG`, `MIN`, and `MAX` can be combined with `GROUP BY` and `HAVING` to build more powerful SQL reports.
