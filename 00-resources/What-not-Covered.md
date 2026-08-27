# Advanced SQL Topics — What to Learn Next

## What it is

The previous SQL course provides a strong foundation for **data analytics and fundamental database management**.

However, it mainly covers:

* Core SQL operations
* Basic relationships
* Joins
* Constraints
* Aggregations
* Fundamental database concepts

For **data engineering** and **complex analytics**, you need to go beyond these fundamentals.

This module identifies the important advanced SQL topics that were **not covered in the course**.

---

## One-Sentence Summary

> **After mastering fundamental SQL, the next step is learning advanced querying, performance optimization, set operations, data modeling, and PostgreSQL-specific features.**

---

# 1. Window Functions

## What they are

**Window functions** perform calculations across a set of related rows while still keeping the individual rows in the result.

This is different from `GROUP BY`.

With `GROUP BY`, multiple rows are usually collapsed into one summary row.

With a window function, the original rows remain visible.

### Common window functions

* `RANK()`
* `LEAD()`
* `LAG()`
* `SUM() OVER()`

---

## Example

Suppose we have:

| employee | salary |
| -------- | -----: |
| A        |  50000 |
| B        |  70000 |
| C        |  60000 |

We can rank employees:

```sql
SELECT
    employee,
    salary,
    RANK() OVER (ORDER BY salary DESC) AS salary_rank
FROM employees;
```

Result:

| employee | salary | salary_rank |
| -------- | -----: | ----------: |
| B        |  70000 |           1 |
| C        |  60000 |           2 |
| A        |  50000 |           3 |

Notice that every employee remains in the result.

---

## Important Functions

### `RANK()`

Assigns a rank to rows.

```sql
RANK() OVER (ORDER BY salary DESC)
```

Useful for questions like:

> Who has the highest salary?

---

### `LAG()`

Looks at a previous row.

```sql
LAG(salary) OVER (ORDER BY salary)
```

Useful for:

> How much did sales change compared with the previous month?

---

### `LEAD()`

Looks at a following row.

```sql
LEAD(salary) OVER (ORDER BY salary)
```

Useful when you need information from the next row.

---

### `SUM() OVER()`

Performs a running or windowed sum.

```sql
SUM(sales) OVER (ORDER BY date)
```

This can be used to calculate a **running total**.

---

## Why Window Functions Matter

They are extremely important in:

* Data analytics
* Reporting
* Ranking
* Running totals
* Comparing current and previous records
* Time-series analysis

---

# 2. Common Table Expressions — CTEs

## What is a CTE?

A **Common Table Expression (CTE)** allows you to create a temporary named result that can be used inside a query.

It is created using the `WITH` clause.

Basic structure:

```sql
WITH temporary_result AS (
    SELECT ...
)
SELECT *
FROM temporary_result;
```

---

## Why Use CTEs?

Large SQL queries can become difficult to read.

Instead of writing everything as one huge query, a CTE allows you to break the query into logical steps.

### Without a CTE

A complex query may contain:

```text
SELECT
   ...
FROM
   ...
JOIN
   ...
WHERE
   ...
GROUP BY
   ...
HAVING
   ...
```

with multiple nested subqueries.

### With a CTE

You can organize it:

```text
Step 1 → Calculate sales
             ↓
Step 2 → Filter products
             ↓
Step 3 → Generate final report
```

This makes complex SQL more **readable and modular**.

---

## CTE vs View

You already learned about views.

| CTE                                           | View                        |
| --------------------------------------------- | --------------------------- |
| Defined using `WITH`                          | Defined using `CREATE VIEW` |
| Usually exists only for the current query     | Database object             |
| Does not permanently create a database object | Stored in the database      |
| Useful for breaking down complex queries      | Useful for reusable queries |

### Mental model

> **CTE = temporary named query step**

> **View = saved query/database object**

---

# 3. Recursive CTEs

A normal CTE handles a query in logical steps.

A **recursive CTE** goes further.

It allows a query to repeatedly reference its own result.

This is useful for **hierarchical data**.

---

## Where Are Recursive CTEs Useful?

Examples include:

* Organizational structures
* Parent-child relationships
* Folder structures
* Category hierarchies
* Tree-like data

For example:

```text
CEO
 ├── Manager A
 │    ├── Employee 1
 │    └── Employee 2
 │
 └── Manager B
      ├── Employee 3
      └── Employee 4
```

A normal join can become difficult when the hierarchy has an unknown number of levels.

A recursive CTE can repeatedly follow:

```text
Parent
  ↓
Child
  ↓
Child
  ↓
Child
  ↓
...
```

---

# 4. Performance Optimization and Indexing

As a database grows, query performance becomes increasingly important.

A query that works quickly on:

```text
1,000 rows
```

may become much slower with:

```text
10 million rows
```

This is where **indexes** become important.

---

## What is an Index?

An index is a database structure designed to make certain data lookups faster.

Think of it like the index of a book.

### Without an index

You may need to examine many rows:

```text
Row 1
Row 2
Row 3
...
Row 10,000,000
```

### With a suitable index

The database can locate relevant records much more efficiently.

---

## Why Indexing Matters

Indexes can significantly improve queries involving frequently searched or joined columns.

For example:

```sql
SELECT *
FROM users
WHERE email = 'user@example.com';
```

An index on `email` can make this lookup much faster on a large table.

---

## Important Trade-off

Indexes are not free.

They:

* Consume storage.
* Can make `INSERT`, `UPDATE`, and `DELETE` operations more expensive because indexes may also need to be updated.

Therefore:

> **Don't blindly create indexes on every column.**

Indexing is part of database performance optimization.

---

# 5. Set Operators

SQL also provides **set operators** for combining the results of multiple queries.

Important operators include:

```text
UNION
UNION ALL
INTERSECT
EXCEPT
```

---

## `UNION`

Combines results from two queries and removes duplicate rows.

Example:

```sql
SELECT name FROM students
UNION
SELECT name FROM teachers;
```

Conceptually:

```text
Query A
   +
Query B
   ↓
Combined unique results
```

---

## `UNION ALL`

Also combines results, but **keeps duplicates**.

```sql
SELECT name FROM students
UNION ALL
SELECT name FROM teachers;
```

### Difference

| Operator    | Duplicates         |
| ----------- | ------------------ |
| `UNION`     | Removes duplicates |
| `UNION ALL` | Keeps duplicates   |

`UNION ALL` is often preferable when duplicate removal is not required.

---

## `INTERSECT`

Returns rows that exist in both query results.

```text
Query A: {A, B, C}
Query B: {B, C, D}

INTERSECT
    ↓

{B, C}
```

---

## `EXCEPT`

Returns rows from the first query that are not present in the second.

```text
Query A: {A, B, C}
Query B: {B, C}

EXCEPT
    ↓

{A}
```

---

# 6. Data Modeling and Normalization

The previous course introduced relationships such as:

* One-to-One
* One-to-Many
* Many-to-Many

The next step is understanding **database design and normalization more deeply**.

---

## What is Normalization?

Normalization is the process of organizing database data to reduce:

* Unnecessary duplication
* Inconsistency
* Data anomalies

Instead of putting everything into one huge table, related information is separated into appropriate tables.

For example, instead of:

```text
Student + Course + Teacher + Marks + Department
```

in one massive table, we might have:

```text
Students
Courses
Teachers
Departments
Enrollments
Marks
```

and connect them using keys.

---

## Normal Forms

Important normal forms include:

* **1NF — First Normal Form**
* **2NF — Second Normal Form**
* **3NF — Third Normal Form**

These provide increasingly strict rules for organizing relational data.

The previous course introduced relationships, but **deeper normalization principles were not covered**.

---

# 7. Advanced PostgreSQL Data Types and Functions

The course introduced fundamental PostgreSQL data types.

Professional PostgreSQL work often requires additional features.

Important areas include:

* JSON
* Arrays
* Advanced date/time operations
* PostgreSQL-specific functions

---

# 8. JSON Data

PostgreSQL supports JSON data.

This is useful when some data is semi-structured.

For example:

```json
{
  "name": "Laptop",
  "brand": "Dell",
  "specs": {
    "ram": "16GB",
    "storage": "512GB"
  }
}
```

Instead of representing every nested property as a separate relational column, JSON can be used when appropriate.

This is particularly useful when working with:

* APIs
* Semi-structured data
* Dynamic attributes
* Application data

---

# 9. Array Data Types

PostgreSQL also supports arrays.

For example, a column could contain:

```text
{SQL, Java, Python}
```

representing multiple skills.

This is a PostgreSQL-specific capability that goes beyond the basic SQL data types covered earlier.

---

# 10. Advanced Date-Time Operations

Real-world analytics frequently involves dates and timestamps.

Basic date handling is often not enough.

Professional SQL work may require operations such as:

```text
Extracting year/month/day
Calculating date differences
Adding or subtracting time
Grouping data by time periods
Working with timestamps
```

For example, analytics questions may look like:

> How many orders were placed each month?

or:

> How many days passed between order creation and delivery?

PostgreSQL provides functions specifically for these types of operations.

---

# What Was Covered vs. What Comes Next

The course gave you the fundamentals:

| Area              | Foundation Covered          | Advanced Next Step          |
| ----------------- | --------------------------- | --------------------------- |
| Queries           | `SELECT`, `WHERE`           | Complex query patterns      |
| Aggregation       | `COUNT`, `SUM`, `AVG`, etc. | Window functions            |
| Relationships     | Basic relationships         | Advanced data modeling      |
| Joins             | Basic joins                 | Complex multi-table queries |
| Temporary logic   | Subqueries                  | CTEs                        |
| Hierarchies       | Basic relationships         | Recursive CTEs              |
| Performance       | Not covered deeply          | Indexing & optimization     |
| Combining results | Not covered                 | Set operators               |
| Database design   | Basic relationships         | Normalization               |
| Data types        | Basic types                 | JSON, arrays                |
| Date/time         | Basic usage                 | Advanced date-time analysis |

---

# Recommended Learning Order

Do not try to learn all advanced topics randomly.

A good progression is:

```text
SQL Fundamentals
      ↓
JOINs + Aggregations
      ↓
Subqueries
      ↓
CTEs
      ↓
Window Functions
      ↓
Set Operators
      ↓
Advanced Date/Time
      ↓
JSON + Arrays
      ↓
Normalization & Data Modeling
      ↓
Indexes
      ↓
Query Optimization
      ↓
Recursive CTEs
```

For **data analytics**, prioritize:

```text
CTEs
   ↓
Window Functions
   ↓
Advanced Aggregations
   ↓
Date/Time
   ↓
Set Operators
```

For **data engineering**, additionally prioritize:

```text
Data Modeling
   ↓
Normalization
   ↓
Indexes
   ↓
Query Optimization
   ↓
Advanced PostgreSQL Features
   ↓
Recursive CTEs
```

---

# Common Mistakes / Gotchas

## 1. Thinking SQL ends with `JOIN`

`JOIN` is extremely important, but advanced analytics often requires:

```text
JOIN
+
CTE
+
Window Function
+
Aggregation
+
Filtering
```

---

## 2. Confusing CTEs and Views

A CTE is generally used as part of a query.

A view is a saved database object.

---

## 3. Using `GROUP BY` when you actually need a window function

If you need to **keep individual rows while also calculating information across rows**, a window function may be more appropriate.

---

## 4. Creating indexes everywhere

Indexes can improve read performance, but they also consume storage and can add overhead to data modifications.

---

## 5. Ignoring data modeling

Writing queries is only one part of professional SQL work.

Poor database design can create:

* Duplicate data
* Inconsistent data
* Difficult queries
* Update anomalies

Good data modeling makes later querying much easier.

---

# Key Takeaways

* The previous course provides a **SQL foundation**, not complete mastery.
* **Window functions** are essential for advanced analytics.
* **CTEs** make complex queries easier to structure and understand.
* **Recursive CTEs** are useful for hierarchical data.
* **Indexes** are important for database performance.
* Indexes have trade-offs and should be used thoughtfully.
* **Set operators** allow multiple query results to be combined.
* Important set operators are:

  * `UNION`
  * `UNION ALL`
  * `INTERSECT`
  * `EXCEPT`
* **Normalization** helps reduce duplication and data anomalies.
* Important normal forms include `1NF`, `2NF`, and `3NF`.
* PostgreSQL provides advanced support for:

  * JSON
  * Arrays
  * Date/time operations
* For analytics, **window functions and CTEs should be among your first advanced topics to learn**.
* For data engineering, also develop strong knowledge of **data modeling, indexing, and query optimization**.

---

# Minimal Self-Test

1. What problem do window functions solve?
2. How is a window function different from `GROUP BY`?
3. What does `RANK()` do?
4. What are `LAG()` and `LEAD()` used for?
5. What is a CTE?
6. How is a CTE different from a View?
7. What kind of problems require recursive CTEs?
8. What is an index?
9. Why can adding too many indexes be problematic?
10. What is the difference between `UNION` and `UNION ALL`?
11. What does `INTERSECT` return?
12. What does `EXCEPT` return?
13. Why is normalization important?
14. What are 1NF, 2NF, and 3NF?
15. Why is PostgreSQL's JSON support useful?
16. When might an array data type be useful?
17. Why are advanced date-time functions important for analytics?
18. Which advanced SQL topics would you prioritize for a data analytics career?
19. Which additional topics become particularly important for data engineering?

---

# What to Learn Next

The strongest next module is **Window Functions**.

Once you are comfortable with:

```text
SELECT
WHERE
GROUP BY
HAVING
JOIN
Subqueries
```

you are ready to learn:

```sql
RANK()
DENSE_RANK()
ROW_NUMBER()
LAG()
LEAD()
SUM() OVER()
AVG() OVER()
PARTITION BY
ORDER BY
```

These are some of the most important SQL skills for **data analytics interviews and real-world analytical queries**.
