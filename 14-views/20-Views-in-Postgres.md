# SQL Views

## What it is

A **View** in SQL is a **virtual table** created from a SQL query.

You can think of a View as a **saved query**.

It does not store the actual data itself. Instead, it provides a window into the underlying tables.

```text
Underlying Tables
       │
       ▼
    SQL Query
       │
       ▼
      View
       │
       ▼
  SELECT from View
```

For example, suppose you frequently need product information only for available products.

Instead of writing the same query repeatedly, you can save it as a View.

---

## One-Sentence Summary

> **A SQL View is a virtual table based on a saved query that simplifies repeated data access while reflecting changes in the underlying tables.**

---

# 1. Why Do We Need Views?

Imagine you repeatedly need to run a complex query:

```sql
SELECT product_name, category, price
FROM products
WHERE is_available = true;
```

You could write this query every time.

But if the query becomes more complex:

```sql
SELECT ...
FROM products p
JOIN orders o
    ON p.product_id = o.product_id
WHERE ...
GROUP BY ...
HAVING ...;
```

writing it repeatedly becomes inconvenient.

A View allows you to save the query once and reuse it.

```text
Complex Query
     ↓
   Saved
     ↓
    View
     ↓
Use it like a table
```

---

# 2. View as a Virtual Table

A View behaves like a table when you query it:

```sql
SELECT *
FROM product_view;
```

But conceptually, the View is not another copy of the underlying data.

Think of it as a **window** into existing tables.

### Mental model

Imagine a table contains:

```text
Products
────────────────────────
product_id
product_name
category
price
stock
supplier
internal_code
```

You might create a View containing only:

```text
product_name
category
price
```

The View gives users access to the required information without exposing everything in the underlying table.

---

# 3. Creating a View

The basic syntax is:

```sql
CREATE VIEW view_name AS
SELECT column_names
FROM table_name
WHERE conditions;
```

### Example

Suppose we have:

```text
products
```

and we want a View containing only available products.

```sql
CREATE VIEW available_products AS
SELECT product_name, category, price
FROM products
WHERE is_available = true;
```

Now `available_products` can be queried like a table:

```sql
SELECT *
FROM available_products;
```

---

# 4. How a View Works

Suppose the original table contains:

| product_id | product_name | category       | price | is_available |
| ---------: | ------------ | -------------- | ----: | ------------ |
|          1 | Laptop       | Electronics    | 80000 | true         |
|          2 | Chair        | Home & Kitchen |  5000 | false        |
|          3 | Keyboard     | Electronics    |  2000 | true         |

We create:

```sql
CREATE VIEW available_products AS
SELECT product_name, category, price
FROM products
WHERE is_available = true;
```

The View will show:

| product_name | category    | price |
| ------------ | ----------- | ----: |
| Laptop       | Electronics | 80000 |
| Keyboard     | Electronics |  2000 |

The original `products` table is not replaced.

The View simply provides a filtered representation of it.

---

# 5. Views Do Not Store Actual Data

This is one of the most important concepts.

A normal table stores data:

```text
Table
 ↓
Actual stored data
```

A View represents a query:

```text
View
 ↓
Saved query
 ↓
Underlying table(s)
```

So a View is called a **virtual table**.

### Important distinction

| Table                        | View                                  |
| ---------------------------- | ------------------------------------- |
| Stores actual data           | Does not store the actual data itself |
| Physical data structure      | Virtual representation                |
| Data is stored in the table  | Query defines what is shown           |
| Can be queried with `SELECT` | Can also be queried with `SELECT`     |

---

# 6. View as a Snapshot / Window

The source describes a View as a **snapshot or window** into the underlying tables.

The important idea is that the View represents the result of its underlying query.

For example:

```text
Products Table
      │
      │
      ▼
  View Query
      │
      ▼
Available Products View
```

Users can interact with the View without directly writing the underlying query every time.

---

# 7. Views and Real-Time Data Changes

Because a View is dynamic, changes to the underlying data are reflected when the View is queried.

Suppose:

```text
products
────────────────
Laptop → available
Keyboard → available
```

The View:

```sql
SELECT *
FROM available_products;
```

returns those available products.

Now suppose the underlying table changes:

```text
Keyboard → unavailable
```

When the View is queried again:

```sql
SELECT *
FROM available_products;
```

the result automatically reflects the updated underlying data.

Conceptually:

```text
Underlying Data Changes
          ↓
       Query View
          ↓
 Updated Result
```

So you should remember:

> **A normal View does not act like a separately stored copy of the source data.**

---

# 8. Major Advantages of Views

## 8.1 Security

Views can help hide sensitive columns.

Suppose the original table contains:

```text
employees
────────────────────────
employee_id
name
department
salary
password_hash
```

You may not want every user to access sensitive information.

Instead, create a View containing only the required columns:

```sql
CREATE VIEW employee_public_info AS
SELECT employee_id, name, department
FROM employees;
```

Users can query:

```sql
SELECT *
FROM employee_public_info;
```

without the sensitive columns being included in that View.

### Mental model

```text
Original Table
├── employee_id
├── name
├── department
├── salary          ← hidden from this View
└── password_hash   ← hidden from this View

             ↓

        Public View
        ├── employee_id
        ├── name
        └── department
```

So Views can provide an additional layer of **data access control**.

---

# 9. Complexity Management

Views are especially useful when queries become complicated.

Suppose a report requires:

* Multiple `JOIN`s
* `WHERE` conditions
* `GROUP BY`
* Aggregation
* Other filtering logic

Instead of making every user understand and write that entire query, you can create a View containing the logic.

```text
Complex SQL Logic
       ↓
      View
       ↓
Simple SELECT
```

The user can then write:

```sql
SELECT *
FROM sales_report;
```

instead of rewriting the entire complex query.

This makes report generation easier.

---

# 10. Views with JOINs

Views are not limited to a single table.

They can be based on queries involving multiple tables.

For example:

```text
Products ─────┐
              ├── JOIN → View
Orders  ──────┘
```

The View can contain the predefined join logic.

Then the user can simply query:

```sql
SELECT *
FROM product_sales;
```

This is particularly useful for reporting and Business Intelligence systems.

---

# 11. Reusability

A View allows the same SQL logic to be reused.

Suppose several reports need the same definition of "available products."

Without a View:

```text
Report 1 → Query A
Report 2 → Query A
Report 3 → Query A
Dashboard → Query A
```

Each system has to reproduce the same logic.

With a View:

```text
             ┌── Report 1
             ├── Report 2
Available ───┼── Report 3
Products     └── Dashboard
   View
```

Everyone uses the same predefined query.

This helps maintain **consistency**.

---

# 12. Views for BI and Reporting

Views are particularly useful in reporting systems and BI dashboards.

For example, suppose a company repeatedly needs:

```text
Product Name
Category
Total Orders
Total Revenue
```

Instead of making every dashboard write its own complex SQL, a View can provide a standardized dataset.

```text
Raw Tables
    │
    ├── Products
    └── Orders
          │
          ▼
     Complex Query
          │
          ▼
    Sales Report View
          │
     ┌────┴────┐
     ▼         ▼
 Dashboard   Report
```

This improves consistency across reports.

---

# 13. Common Use Cases

Views are useful when:

### 1. The same query is used repeatedly

```text
Repeated query
      ↓
     View
```

### 2. A query is complicated

Hide the complexity behind a simple View.

### 3. Certain columns should not be exposed

Create a View containing only safe/required columns.

### 4. Multiple reports need the same dataset

Create one standardized View and reuse it.

### 5. Data changes frequently

The View reflects changes in its underlying tables when queried.

---

# 14. Important Mental Model

Think of a View as a **named window**.

```text
                 Database
                    │
          ┌─────────┴─────────┐
          │                   │
      Products              Orders
          │                   │
          └─────────┬─────────┘
                    │
              View Definition
                    │
                    ▼
             ┌─────────────┐
             │ Sales View  │
             └─────────────┘
                    │
                    ▼
             SELECT * FROM
                sales_view
```

The View gives you a convenient and reusable way to access the required information.

---

# 15. View vs Table

This distinction is important for interviews.

| Feature                           | Table                      | View              |
| --------------------------------- | -------------------------- | ----------------- |
| Stores actual data                | Yes                        | No                |
| Based on a query                  | Not necessarily            | Yes               |
| Can be queried with `SELECT`      | Yes                        | Yes               |
| Can simplify complex queries      | Not its main purpose       | Yes               |
| Can hide selected columns         | Not in the same way        | Yes               |
| Reflects underlying table changes | It is the source data      | Yes, when queried |
| Useful for reusable reports       | Yes, but different purpose | Very useful       |

---

# 16. Example: Complete View Workflow

### Step 1 — Create the View

```sql
CREATE VIEW available_products AS
SELECT product_name, category, price
FROM products
WHERE is_available = true;
```

### Step 2 — Query the View

```sql
SELECT *
FROM available_products;
```

### Step 3 — Use it like a table

You can use the View as the source of another query:

```sql
SELECT product_name, price
FROM available_products
WHERE price > 1000;
```

The View therefore provides a simpler interface over the underlying query.

---

# 17. Common Mistakes / Gotchas

### Mistake 1: Thinking a View is a physical copy

A normal View should be understood as a **virtual table / saved query**, not as a separate copy of the underlying data.

```text
❌ View = copied table

✅ View = saved query / virtual table
```

---

### Mistake 2: Assuming the View becomes stale

The source material emphasizes that Views are dynamic.

If the underlying data changes, querying the View reflects those changes.

```text
Table changes
     ↓
Query View
     ↓
Updated result
```

---

### Mistake 3: Rewriting complex queries everywhere

If the same complex query is repeatedly used in reports, a View can simplify the process.

Instead of:

```sql
-- complicated query every time
```

use:

```sql
SELECT *
FROM report_view;
```

---

### Mistake 4: Exposing unnecessary columns

If users only need:

```text
name
department
```

there may be no reason for a View to expose:

```text
salary
password_hash
```

A View can expose only the required information.

---

# Key Takeaways

* A **View** is a **virtual table**.
* It is essentially a **saved SQL query**.
* A normal View does **not store the actual data itself**.
* You create one using:

```sql
CREATE VIEW view_name AS
SELECT ...
FROM ...
WHERE ...;
```

* You query it like a table:

```sql
SELECT *
FROM view_name;
```

* Views can simplify complex queries.
* Views can contain predefined:

  * Filters
  * Joins
  * Aggregations
* Views can help hide sensitive or unnecessary columns.
* Views improve **reusability**.
* Views help maintain **consistency** across reports and BI dashboards.
* When the underlying data changes, the View's output reflects those changes when queried.
* Think of a View as a **window into the underlying tables**, not as a duplicate table.

---

# Minimal Self-Test

1. What is a SQL View?
2. Why is a View called a virtual table?
3. Does a normal View store actual data?
4. What is the basic syntax for creating a View?
5. How do you query a View?
6. How can Views simplify complex SQL queries?
7. How can a View improve security?
8. Can a View be based on multiple tables?
9. Why are Views useful for BI dashboards?
10. What happens to a View's output when the underlying table data changes?
11. What is the difference between a table and a View?
12. Why are Views useful for maintaining consistency across reports?

---

# What to Learn Next

After **SQL Views**, the next useful topics are:

```text
Views
  ↓
Subqueries
  ↓
CTEs (WITH clause)
  ↓
Window Functions
  ↓
Advanced Reporting Queries
```

These topics build directly on your current SQL knowledge and are especially important for **SQL interviews and data-analysis queries**.
