# Database Projects, JOINs & Real-World SQL Test Scenarios

## What it is

This module applies the SQL concepts learned so far to a more realistic database containing **Products** and **Orders**.

The main focus is:

* Importing related data correctly
* Understanding Primary Key → Foreign Key dependencies
* Using `INNER JOIN` and `LEFT JOIN`
* Using table aliases
* Combining JOINs with `WHERE`
* Combining JOINs with aggregation
* Calculating order counts and revenue
* Using `GROUP BY` and `HAVING`
* Interpreting repeated rows caused by One-to-Many relationships

---

## One-sentence summary

> **Real-world SQL analysis often combines multiple related tables using JOINs and then applies filtering, grouping, and aggregation to produce useful business information.**

---

# 1. Real-World Database Workflow

So far, we worked with individual tables and basic queries.

In a real project, however, data is usually spread across multiple related tables.

For example:

```text
                    Database
                       │
          ┌────────────┴────────────┐
          ↓                         ↓
      Products                    Orders
      ────────                    ──────
      product_id (PK)             order_id (PK)
      product_name                product_id (FK)
      category                    quantity
      price                       customer_name
                                  order_date
```

The `Orders` table depends on the `Products` table because `orders.product_id` references `products.product_id`.

That dependency becomes important when importing data.

---

# 2. CSV Import Strategy

When importing data from external CSV files, the **parent table should be imported first**.

For example:

```text
Products
   │
   │ product_id
   ↓
Orders
```

Here:

* `Products.product_id` → Primary Key
* `Orders.product_id` → Foreign Key

Therefore, import:

```text
1. Products
2. Orders
```

### Why?

Suppose the Orders CSV contains:

```text
order_id | product_id | quantity
---------|------------|---------
101      | 5          | 2
```

If product `5` does not exist in the `products` table, the foreign key constraint can reject the order.

The database is effectively saying:

> "You cannot create an order for a product that doesn't exist."

---

# 3. Import Dependency

Think of it as a parent-child relationship:

```text
Products
   │
   │ Parent
   ↓
Orders
   │
   │ Child
```

The child table depends on the parent.

Therefore:

```text
❌ Import Orders first
        ↓
Referenced product may not exist
        ↓
Foreign Key error
```

Instead:

```text
✅ Import Products first
        ↓
Product IDs exist
        ↓
Import Orders
        ↓
Foreign Keys can reference them
```

---

# 4. Troubleshooting Import Errors

If an import fails, one of the first things to check is the **schema/data dependency sequence**.

Ask:

1. Does the parent table exist?
2. Does it contain the referenced Primary Key?
3. Is the Foreign Key pointing to the correct column?
4. Am I importing the child table before the parent data?

For example:

```text
products.product_id = 10
```

must exist before an order containing:

```text
orders.product_id = 10
```

can successfully reference it.

---

# 5. Products and Orders Example

Assume we have:

### `products`

| product_id | product_name | category       | price |
| ---------: | ------------ | -------------- | ----: |
|          1 | Laptop       | Electronics    |  1000 |
|          2 | Chair        | Home & Kitchen |   500 |
|          3 | Dumbbell     | Fitness        |   100 |
|          4 | Phone        | Electronics    |   800 |

### `orders`

| order_id | product_id | quantity | customer_name | order_date |
| -------: | ---------: | -------: | ------------- | ---------- |
|      101 |          1 |        2 | Rahul         | 2026-01-10 |
|      102 |          1 |        1 | Anjali        | 2026-01-11 |
|      103 |          3 |        5 | Aman          | 2026-01-12 |

Notice:

```text
Laptop
  ├── Order 101
  └── Order 102

Dumbbell
  └── Order 103

Chair
  └── No order

Phone
  └── No order
```

This is a **One-to-Many relationship**.

---

# 6. INNER JOIN

An `INNER JOIN` returns only records where there is a match in **both tables**.

Syntax:

```sql
SELECT ...
FROM products p
INNER JOIN orders o
ON p.product_id = o.product_id;
```

Think:

```text
Products              Orders
   │                     │
   └──── matching ───────┘
             ↓
        INNER JOIN
             ↓
      Only matching rows
```

So products that have never been ordered are excluded.

---

# 7. Why Use INNER JOIN?

Suppose:

```text
Products:
Laptop
Chair
Dumbbell
Phone

Orders:
Laptop
Laptop
Dumbbell
```

An `INNER JOIN` returns information about:

```text
Laptop
Laptop
Dumbbell
```

but not:

```text
Chair
Phone
```

because those products don't have matching orders.

This is useful when the question is:

> "Show products that have orders."

---

# 8. LEFT JOIN

A `LEFT JOIN` keeps **all rows from the left table**, even when there is no matching row in the right table.

Example:

```sql
SELECT ...
FROM products p
LEFT JOIN orders o
ON p.product_id = o.product_id;
```

Here:

```text
LEFT TABLE             RIGHT TABLE
Products               Orders
    │                     │
    └──── LEFT JOIN ──────┘
             ↓
   Keep ALL products
```

If a product has no order, the order-related columns will contain `NULL`.

For example:

| product_name | order_id |
| ------------ | -------: |
| Laptop       |      101 |
| Laptop       |      102 |
| Chair        |     NULL |
| Dumbbell     |      103 |
| Phone        |     NULL |

---

# 9. INNER JOIN vs LEFT JOIN

| Feature              | INNER JOIN                  | LEFT JOIN                  |
| -------------------- | --------------------------- | -------------------------- |
| Matching rows        | Included                    | Included                   |
| Unmatched left rows  | Excluded                    | Included                   |
| Unmatched right rows | Excluded                    | Not included               |
| Useful for           | Only existing relationships | Keeping all parent records |

### Simple mental model

```text
INNER JOIN
→ "Give me only things that match."

LEFT JOIN
→ "Give me everything from the left table,
   whether it matches or not."
```

This distinction is extremely important in SQL interviews.

---

# 10. Table Aliasing

Complex JOIN queries can become long.

Instead of:

```sql
products.product_id
products.product_name
orders.order_id
orders.quantity
```

we can create aliases:

```sql
products p
orders o
```

Therefore:

```text
p → products
o → orders
```

And:

```text
p.product_id
o.order_id
p.price
o.quantity
```

are much easier to read.

---

# 11. Question 1 — Show Each Order with Product Name and Price

### Problem

> Show each order along with the product name and price.

We need information from both tables:

```text
Products → product information
Orders   → order information
```

So we use an `INNER JOIN`.

### Query

```sql
SELECT
    p.product_id,
    o.order_id,
    p.product_name,
    p.category,
    p.price,
    o.quantity,
    o.customer_name,
    o.order_date
FROM products p
INNER JOIN orders o
ON p.product_id = o.product_id;
```

### What happens?

The database matches:

```text
p.product_id = o.product_id
```

and combines the corresponding rows.

Example result:

| product_id | order_id | product_name | category    | price | quantity | customer_name |
| ---------: | -------: | ------------ | ----------- | ----: | -------: | ------------- |
|          1 |      101 | Laptop       | Electronics |  1000 |        2 | Rahul         |
|          1 |      102 | Laptop       | Electronics |  1000 |        1 | Anjali        |
|          3 |      103 | Dumbbell     | Fitness     |   100 |        5 | Aman          |

---

# 12. Question 2 — Show All Products Even If Never Ordered

### Problem

> Show all products, including products that have never been ordered.

An `INNER JOIN` won't work because it removes unmatched products.

We need a `LEFT JOIN`.

### Query

```sql
SELECT
    p.product_id,
    o.order_id,
    p.product_name,
    p.category,
    p.price,
    o.quantity,
    o.customer_name,
    o.order_date
FROM products p
LEFT JOIN orders o
ON p.product_id = o.product_id;
```

### Important idea

The left table is:

```sql
FROM products p
```

Therefore, **all products are preserved**.

If there is no order:

```text
order_id = NULL
quantity = NULL
customer_name = NULL
order_date = NULL
```

This is one of the most common practical uses of `LEFT JOIN`.

---

# 13. Question 3 — Show Orders Only for Electronics

### Problem

> Show orders for only the `Electronics` category.

First, connect the tables:

```sql
FROM products p
JOIN orders o
ON p.product_id = o.product_id
```

Then filter based on the product category:

```sql
WHERE p.category = 'Electronics'
```

### Query

```sql
SELECT
    p.product_id,
    o.order_id,
    p.product_name,
    p.category,
    p.price,
    o.quantity,
    o.customer_name,
    o.order_date
FROM products p
JOIN orders o
ON p.product_id = o.product_id
WHERE p.category = 'Electronics';
```

### Mental model

```text
Products + Orders
       ↓
     JOIN
       ↓
Related rows
       ↓
WHERE category = Electronics
       ↓
Electronics orders
```

---

# 14. Question 4 — Sort Orders by Product Price

### Problem

> List all orders sorted by product price from high to low.

Use:

```sql
ORDER BY p.price DESC
```

### Query

```sql
SELECT
    p.product_id,
    o.order_id,
    p.product_name,
    p.category,
    p.price,
    o.quantity,
    o.customer_name,
    o.order_date
FROM products p
INNER JOIN orders o
ON p.product_id = o.product_id
ORDER BY p.price DESC;
```

`DESC` means:

```text
Highest → Lowest
```

For example:

```text
1000
800
500
100
```

---

# 15. Question 5 — Number of Orders for Each Product

### Problem

> Show how many orders were placed for each product.

We need:

* `products` → to include every product
* `orders` → to count orders
* `LEFT JOIN` → so products with zero orders are also included
* `COUNT()` → to count orders
* `GROUP BY` → to calculate the count separately for each product

### Query

```sql
SELECT
    p.product_name,
    COUNT(o.order_id) AS orders_placed
FROM products p
LEFT JOIN orders o
ON p.product_id = o.product_id
GROUP BY p.product_name;
```

Possible result:

| product_name | orders_placed |
| ------------ | ------------: |
| Laptop       |             2 |
| Chair        |             0 |
| Dumbbell     |             1 |
| Phone        |             0 |

---

# 16. Why `LEFT JOIN` Is Important Here

Suppose we used:

```sql
INNER JOIN
```

Products with zero orders would disappear.

But the question asks:

> How many orders were placed **for each product**?

That includes products with:

```text
0 orders
```

Therefore:

```sql
LEFT JOIN
```

is appropriate.

---

# 17. Why `COUNT(o.order_id)`?

The query uses:

```sql
COUNT(o.order_id)
```

rather than simply relying on the product row.

For a product with no order:

```text
o.order_id = NULL
```

`COUNT(column)` does not count `NULL`.

Therefore:

```text
No matching orders
        ↓
o.order_id = NULL
        ↓
COUNT(o.order_id)
        ↓
0
```

This allows us to correctly identify products with zero orders.

---

# 18. Question 6 — Total Revenue per Product

### Problem

> Show total revenue earned for each product.

Revenue for one order is:

```text
price × quantity
```

Therefore:

```sql
p.price * o.quantity
```

For multiple orders, we use:

```sql
SUM(p.price * o.quantity)
```

### Query

```sql
SELECT
    p.product_name,
    SUM(p.price * o.quantity) AS total_revenue
FROM orders o
INNER JOIN products p
ON o.product_id = p.product_id
GROUP BY p.product_name;
```

---

# 19. Understanding the Revenue Calculation

Suppose:

```text
Laptop price = ₹1000
Order 1 quantity = 2
Order 2 quantity = 3
```

Revenue:

```text
Order 1:
1000 × 2 = 2000

Order 2:
1000 × 3 = 3000
```

Total:

```text
2000 + 3000 = 5000
```

SQL performs this using:

```sql
SUM(p.price * o.quantity)
```

---

# 20. Why `GROUP BY` Is Required

We want revenue **per product**.

So SQL needs to know:

> "Which rows belong to which product?"

That's what:

```sql
GROUP BY p.product_name
```

does.

Conceptually:

```text
Orders
   ↓
Group by product
   ↓
Calculate SUM for each group
   ↓
Total revenue per product
```

---

# 21. Question 7 — Products with Revenue Greater Than 2000

### Problem

> Show products where total order revenue is greater than 2000.

We first calculate:

```sql
SUM(p.price * o.quantity)
```

Then we need to filter the **aggregated result**.

Therefore, we use:

```sql
HAVING
```

### Query

```sql
SELECT
    p.product_name,
    SUM(p.price * o.quantity) AS total_revenue
FROM orders o
INNER JOIN products p
ON o.product_id = p.product_id
GROUP BY p.product_name
HAVING SUM(p.price * o.quantity) > 2000;
```

---

# 22. WHERE vs HAVING in This Example

This is an important distinction.

### `WHERE`

Filters individual rows **before grouping**.

Example:

```sql
WHERE p.category = 'Electronics'
```

### `HAVING`

Filters groups **after aggregation**.

Example:

```sql
HAVING SUM(p.price * o.quantity) > 2000
```

Mental model:

```text
Individual rows
      ↓
    WHERE
      ↓
   GROUP BY
      ↓
 Aggregation
      ↓
   HAVING
      ↓
Final groups
```

---

# 23. Question 8 — Unique Customers Who Ordered Fitness Products

### Problem

> Show unique customers who ordered products in the `Fitness` category.

We need:

1. `orders` → customer information
2. `products` → category information
3. JOIN → connect the two
4. `WHERE` → select Fitness
5. `DISTINCT` → remove repeated customers

### Query

```sql
SELECT DISTINCT
    customer_name
FROM orders o
INNER JOIN products p
ON o.product_id = p.product_id
WHERE p.category = 'Fitness';
```

---

# 24. Why `DISTINCT`?

Suppose a customer orders multiple Fitness products:

```text
Aman → Dumbbell
Aman → Treadmill
Aman → Yoga Mat
```

Without `DISTINCT`:

```text
Aman
Aman
Aman
```

With:

```sql
DISTINCT
```

we get:

```text
Aman
```

because the question asks for **unique customers**.

---

# 25. Aggregation with JOINs

JOINs become especially powerful when combined with aggregate functions.

Common patterns:

### Count orders

```sql
COUNT(o.order_id)
```

### Calculate revenue

```sql
SUM(p.price * o.quantity)
```

### Find products above a revenue threshold

```sql
HAVING SUM(p.price * o.quantity) > 2000
```

This allows us to perform real business analysis.

---

# 26. Sales Analysis Pattern

A very common SQL analytics pattern is:

```text
Products
    +
Orders
    ↓
   JOIN
    ↓
Filter / Group
    ↓
Aggregate
    ↓
Business Result
```

For example:

```text
Products + Orders
       ↓
Calculate price × quantity
       ↓
GROUP BY product
       ↓
SUM()
       ↓
Total revenue per product
```

---

# 27. Repeated Product Names Are Normal

Suppose:

```text
Laptop → Order 101
Laptop → Order 102
Laptop → Order 103
```

A JOIN may produce:

```text
Laptop | 101
Laptop | 102
Laptop | 103
```

The repeated product name does **not** mean that the product exists three times.

It means:

```text
One product
    ↓
Three orders
```

This is the natural result of a One-to-Many relationship.

For analytics, you must understand this before interpreting counts or repeated IDs.

---

# 28. Scenario-Based Testing

Working with realistic datasets is important because SQL behavior becomes easier to understand when you ask business-style questions.

Examples:

> Which products are selling?

> Which products have never been ordered?

> How many orders does each product have?

> Which products generate the most revenue?

> Which categories perform well?

> Which customers bought Fitness products?

These questions require combining multiple SQL concepts rather than using a single command.

---

# 29. Important Query Patterns to Remember

### Pattern 1 — Matching records

```sql
FROM products p
INNER JOIN orders o
ON p.product_id = o.product_id
```

Use when you only need matching products/orders.

---

### Pattern 2 — Keep every product

```sql
FROM products p
LEFT JOIN orders o
ON p.product_id = o.product_id
```

Use when products with zero orders must also appear.

---

### Pattern 3 — Filter joined data

```sql
WHERE p.category = 'Electronics'
```

---

### Pattern 4 — Count per product

```sql
COUNT(o.order_id)
GROUP BY p.product_name
```

---

### Pattern 5 — Calculate revenue

```sql
SUM(p.price * o.quantity)
GROUP BY p.product_name
```

---

### Pattern 6 — Filter aggregated results

```sql
HAVING SUM(p.price * o.quantity) > 2000
```

---

### Pattern 7 — Unique values

```sql
SELECT DISTINCT customer_name
```

---

# 30. Query Execution Mental Model

For these types of queries, a useful conceptual order is:

```text
FROM / JOIN
      ↓
WHERE
      ↓
GROUP BY
      ↓
Aggregate functions
      ↓
HAVING
      ↓
SELECT
      ↓
ORDER BY
```

This is a **mental model for understanding query processing**, not simply a rule about how you must write the clauses.

For example:

```sql
SELECT
    p.product_name,
    SUM(p.price * o.quantity) AS total_revenue
FROM orders o
INNER JOIN products p
ON o.product_id = p.product_id
WHERE p.category = 'Electronics'
GROUP BY p.product_name
HAVING SUM(p.price * o.quantity) > 2000
ORDER BY total_revenue DESC;
```

This combines almost everything learned so far.

---

# 31. Common Mistakes / Gotchas

## 1. Importing the child table first

If `orders.product_id` references `products.product_id`, importing orders before the required products can cause Foreign Key violations.

Remember:

```text
Parent → Child
Products → Orders
```

---

## 2. Using INNER JOIN when zero-count records matter

If the question says:

> "Show all products, including products with no orders."

Use:

```sql
LEFT JOIN
```

not:

```sql
INNER JOIN
```

---

## 3. Forgetting `GROUP BY`

If you're calculating something **per product**, you generally need to group by the product:

```sql
GROUP BY p.product_name
```

---

## 4. Using WHERE for aggregate conditions

This is wrong for filtering a calculated group:

```sql
WHERE SUM(p.price * o.quantity) > 2000
```

Use:

```sql
HAVING SUM(p.price * o.quantity) > 2000
```

because the condition applies to the aggregated group.

---

## 5. Forgetting DISTINCT

If a customer can place multiple orders, the same customer can appear multiple times.

Use:

```sql
SELECT DISTINCT customer_name
```

when the requirement is to show each customer only once.

---

## 6. Misinterpreting repeated rows

In a One-to-Many relationship:

```text
1 Product
   ↓
Many Orders
```

repeated product information in a JOIN result is expected.

Don't automatically assume it means duplicate data.

---

# 32. Interview Perspective

These exercises cover several concepts commonly tested together:

### JOIN concepts

* `INNER JOIN`
* `LEFT JOIN`
* Primary Key ↔ Foreign Key
* `ON` condition
* Table aliases

### Filtering

* `WHERE`
* Filtering columns from joined tables

### Aggregation

* `COUNT()`
* `SUM()`

### Grouping

* `GROUP BY`
* `HAVING`

### Result cleanup

* `DISTINCT`
* `ORDER BY`

### Real-world reasoning

* Zero-order products
* Revenue calculation
* Customer analysis
* Sales analysis
* Foreign Key import dependencies

The important skill is not memorizing each query separately. It is recognizing **which SQL concept solves which part of the problem**.

---

# 33. Quick Problem-Solving Framework

When given a SQL question, break it down.

### Step 1 — Which tables do I need?

Example:

> "Show product name and order quantity."

Need:

```text
products + orders
```

### Step 2 — How are they related?

```text
p.product_id = o.product_id
```

### Step 3 — Which JOIN?

Ask:

> Do I need unmatched records?

If no:

```text
INNER JOIN
```

If yes, and all rows from the first table must remain:

```text
LEFT JOIN
```

### Step 4 — Do I need filtering?

Use:

```sql
WHERE
```

### Step 5 — Do I need calculations?

Use:

```text
COUNT
SUM
AVG
MIN
MAX
```

### Step 6 — Do I need results per category/product/customer?

Use:

```sql
GROUP BY
```

### Step 7 — Am I filtering aggregated results?

Use:

```sql
HAVING
```

### Step 8 — Do I need unique values?

Use:

```sql
DISTINCT
```

This approach makes complex SQL questions much easier.

---

# Key Takeaways

* Real databases commonly split information across related tables.
* `Products` can act as a parent table while `Orders` acts as a child table.
* When importing related CSV data, import the **Primary Key/parent table first**.
* Foreign Key constraints can reject records when the referenced parent record does not exist.
* `INNER JOIN` returns only matching records.
* `LEFT JOIN` keeps every row from the left table, even when there is no match.
* Table aliases such as `p` and `o` make JOIN queries cleaner.
* JOINs can be combined with `WHERE` for filtering.
* `COUNT()` can be used to count orders per product.
* `SUM(price * quantity)` can calculate total revenue.
* `GROUP BY` allows calculations separately for each product/category/group.
* `HAVING` filters groups after aggregation.
* `DISTINCT` removes repeated values from the final result.
* Repeated product names or IDs in a JOIN result are expected in One-to-Many relationships.
* Real SQL analysis often combines several concepts in one query.
* Always read the question carefully and identify:

  * tables
  * relationship
  * JOIN type
  * filters
  * aggregation
  * grouping
  * final sorting/output

---

# Minimal Self-Test

1. Why should the `Products` table be imported before the `Orders` table?
2. What happens if an order references a product ID that does not exist?
3. What is the difference between `INNER JOIN` and `LEFT JOIN`?
4. Which JOIN should you use to show products that have never been ordered?
5. Why can a product name appear multiple times after joining `Products` and `Orders`?
6. What does `p` represent in `products p`?
7. Write a JOIN condition between `products` and `orders`.
8. How would you count the number of orders for each product?
9. Why is `LEFT JOIN` useful when counting products with zero orders?
10. How do you calculate total revenue from price and quantity?
11. Why is `GROUP BY` needed when calculating revenue per product?
12. When should you use `HAVING` instead of `WHERE`?
13. Write a query to find products whose total revenue exceeds `2000`.
14. Why is `DISTINCT` needed when finding unique customers?
15. Write a query to find unique customers who ordered Fitness products.
16. Explain the difference between:

    ```sql
    WHERE p.category = 'Fitness'
    ```

    and:

    ```sql
    HAVING SUM(p.price * o.quantity) > 2000
    ```
17. Given a question, how would you decide whether to use `INNER JOIN` or `LEFT JOIN`?
18. Explain the overall flow:

```text
Products + Orders
       ↓
      JOIN
       ↓
    WHERE
       ↓
   GROUP BY
       ↓
  Aggregation
       ↓
    HAVING
       ↓
 Final Result
```

---

# What to Learn Next

The natural next step is to go deeper into **SQL JOIN types and advanced JOIN problems**, especially:

```text
INNER JOIN
LEFT JOIN
RIGHT JOIN
FULL OUTER JOIN
SELF JOIN
CROSS JOIN
```

Then practice combining JOINs with:

```text
WHERE
GROUP BY
HAVING
Subqueries
Aggregate Functions
CASE
```

That combination is where SQL starts becoming powerful for real-world data analysis and interviews.
