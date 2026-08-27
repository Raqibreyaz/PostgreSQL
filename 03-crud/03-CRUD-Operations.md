# PostgreSQL CRUD Operations

## What it is

**CRUD** is the basic set of operations used to work with data in a database:

```text id="j8q5bz"
C → Create
R → Read
U → Update
D → Delete
```

In PostgreSQL, these operations allow you to:

* Create tables and insert data.
* Read existing data.
* Modify existing records.
* Remove records.

CRUD is one of the most important foundations of SQL because almost every application needs these four capabilities.

---

## One-Sentence Summary

> **CRUD represents the four fundamental ways we work with database data: create it, read it, update it, and delete it.**

---

# 1. CRUD Overview

The four operations map to common SQL commands:

| CRUD       | Purpose                        | SQL                           |
| ---------- | ------------------------------ | ----------------------------- |
| **Create** | Create structure / add records | `CREATE TABLE`, `INSERT INTO` |
| **Read**   | Retrieve data                  | `SELECT`                      |
| **Update** | Modify existing data           | `UPDATE`                      |
| **Delete** | Remove data                    | `DELETE`                      |

A simple mental model:

```text id="0s4jxn"
             DATABASE
                 │
       ┌─────────┼─────────┐
       ↓         ↓         ↓
    Create      Read     Update/Delete
       │         │         │
       ↓         ↓         ↓
    Add data   Get data  Change/Remove
```

---

# 2. CREATE — Creating a Table

Before storing records, we need to define the structure of the data.

This is done using:

```sql id="j2k8so"
CREATE TABLE
```

A table defines:

* Column names
* Data types
* The structure of the records

---

## Basic Syntax

```sql id="6e1p8h"
CREATE TABLE table_name (
    column1 data_type,
    column2 data_type,
    column3 data_type
);
```

For example:

```sql id="zv0f4a"
CREATE TABLE students (
    student_id INT,
    name VARCHAR(100),
    age INT,
    grade TEXT
);
```

Here:

```text id="1psd2g"
student_id → INT
name       → VARCHAR(100)
age        → INT
grade      → TEXT
```

So the table structure becomes:

| Column       | Data Type      |
| ------------ | -------------- |
| `student_id` | `INT`          |
| `name`       | `VARCHAR(100)` |
| `age`        | `INT`          |
| `grade`      | `TEXT`         |

---

# 3. Why Data Types Are Required

When creating a table, each column needs an appropriate data type.

For example:

```text id="2t0zlj"
student_id → INT
age        → INT
name       → VARCHAR
grade      → TEXT
```

The data type tells PostgreSQL what kind of data the column is intended to contain.

Think of it like defining the rules for each field before entering the actual records.

---

# 4. INSERT — Adding Records

After creating the table, we need to put data into it.

PostgreSQL uses:

```sql id="n9g5mg"
INSERT INTO
```

The `INSERT INTO` command adds records to a table.

---

## Basic Syntax

```sql id="u2s4qv"
INSERT INTO table_name (column1, column2, column3)
VALUES (value1, value2, value3);
```

For example:

```sql id="0c5xpg"
INSERT INTO students (student_id, name, age, grade)
VALUES (1, 'Akarsh', 20, 'A');
```

The structure is:

```text id="1i7e6t"
INSERT INTO
     ↓
table name
     ↓
columns
     ↓
VALUES
     ↓
actual values
```

---

# 5. Column Names and Values

Consider:

```sql id="q8h2gc"
INSERT INTO students (student_id, name, age, grade)
VALUES (1, 'Akarsh', 20, 'A');
```

The columns are:

```text id="hrr6w9"
student_id
name
age
grade
```

The corresponding values are:

```text id="3kjvbi"
1
Akarsh
20
A
```

They match positionally:

```text id="xapmgi"
student_id → 1
name       → Akarsh
age        → 20
grade      → A
```

---

# 6. Inserting Multiple Records

You can insert more than one record using a single `INSERT` statement.

For example:

```sql id="f9ofqu"
INSERT INTO students (student_id, name, age, grade)
VALUES
    (1, 'Akarsh', 20, 'A'),
    (2, 'Anjali', 21, 'B'),
    (3, 'Raj', 22, 'A');
```

This adds three rows.

Result:

| student_id | name   | age | grade |
| ---------: | ------ | --: | ----- |
|          1 | Akarsh |  20 | A     |
|          2 | Anjali |  21 | B     |
|          3 | Raj    |  22 | A     |

---

# 7. `SERIAL` and Auto-Incrementing IDs

The source highlights an important point about `SERIAL`.

If a column is defined as:

```sql id="lq7d2c"
student_id SERIAL
```

PostgreSQL automatically generates the ID.

For example:

```sql id="3jpv1r"
CREATE TABLE students (
    student_id SERIAL,
    name VARCHAR(100),
    age INT,
    grade TEXT
);
```

You can then insert:

```sql id="r1g3tg"
INSERT INTO students (name, age, grade)
VALUES ('Akarsh', 20, 'A');
```

You **do not need to provide `student_id` manually**.

PostgreSQL automatically generates the ID.

Conceptually:

```text id="w9qj5f"
First record  → ID 1
Second record → ID 2
Third record  → ID 3
```

---

## Important Rule

When using an auto-generated `SERIAL` ID:

```text id="zv2cwt"
Don't manually provide the ID
           ↓
PostgreSQL generates it
```

So instead of:

```sql id="j9h6ri"
INSERT INTO students
    (student_id, name, age)
VALUES
    (1, 'Akarsh', 20);
```

you can write:

```sql id="xj8h8y"
INSERT INTO students
    (name, age)
VALUES
    ('Akarsh', 20);
```

---

# 8. READ — Retrieving Data

The **Read** operation is performed using:

```sql id="r3l7o8"
SELECT
```

`SELECT` is one of the most important SQL commands because it allows you to retrieve information from the database.

---

# 9. Selecting Everything

The basic query is:

```sql id="0c2g89"
SELECT *
FROM students;
```

Here:

```text id="i9z5k7"
SELECT → what to retrieve

*      → every column

FROM   → which table
```

So:

```sql id="3dr8sm"
SELECT * FROM students;
```

means:

> Retrieve every column from every row in the `students` table.

---

# 10. What Does `*` Mean?

The wildcard:

```text id="z7r4m4"
*
```

means:

> **All columns**

For example, if `students` contains:

```text id="12jzlh"
student_id
name
age
grade
```

then:

```sql id="a8k7h5"
SELECT *
FROM students;
```

returns all four columns.

---

# 11. Selecting Specific Columns

You don't always need every column.

You can specify exactly which columns you want:

```sql id="mg4f0s"
SELECT name, age
FROM students;
```

This retrieves only:

```text id="bqwx2j"
name
age
```

instead of:

```text id="z6n5yv"
student_id
name
age
grade
```

---

## Why Select Specific Columns?

The source highlights two benefits:

### 1. Readability

The query clearly communicates which information you need.

Instead of:

```sql id="d7j7xn"
SELECT *
FROM students;
```

you can write:

```sql id="x2j6e8"
SELECT name, age
FROM students;
```

This makes your intention clearer.

### 2. Performance

Selecting only the required columns can be more efficient than retrieving unnecessary data, especially when dealing with larger datasets.

---

# 12. UPDATE — Modifying Existing Records

The third CRUD operation is **Update**.

Use:

```sql id="7n4j1h"
UPDATE
```

when you want to change data that already exists.

---

## Basic Syntax

```sql id="x7x5k3"
UPDATE table_name
SET column_name = new_value
WHERE condition;
```

There are three important parts:

```text id="6q6fkt"
UPDATE
   ↓
Which table?

SET
   ↓
What should change?

WHERE
   ↓
Which rows should change?
```

---

# 13. Example of UPDATE

Suppose we have:

| student_id | name   | age | grade |
| ---------: | ------ | --: | ----- |
|          1 | Akarsh |  20 | A     |
|          2 | Anjali |  21 | B     |
|          3 | Raj    |  22 | A     |

Suppose Akarsh's age needs to be changed from `20` to `21`.

We can write:

```sql id="0b4f5a"
UPDATE students
SET age = 21
WHERE student_id = 1;
```

The database finds the row where:

```text id="y9y5eo"
student_id = 1
```

and changes:

```text id="v4c1qa"
age = 20
```

to:

```text id="7t6cga"
age = 21
```

---

# 14. The Critical Importance of `WHERE`

This is the **most important warning in this section**.

Consider:

```sql id="1j9czr"
UPDATE students
SET age = 21;
```

There is no `WHERE`.

Therefore, PostgreSQL will update **every row**.

The result could become:

| student_id | name   | age | grade |
| ---------: | ------ | --: | ----- |
|          1 | Akarsh |  21 | A     |
|          2 | Anjali |  21 | B     |
|          3 | Raj    |  21 | A     |

That is usually not what you intended.

---

## Safe UPDATE Mental Model

Before executing an `UPDATE`, ask:

> **Which rows am I changing?**

Then make sure your `WHERE` clause identifies those rows.

```sql id="z2g9nq"
UPDATE students
SET age = 21
WHERE student_id = 1;
```

Think:

```text id="9z8v5s"
UPDATE
  ↓
SET
  ↓
WHERE
  ↓
Specific rows
```

---

# 15. DELETE — Removing Records

The fourth CRUD operation is **Delete**.

Use:

```sql id="6v5g0u"
DELETE
```

to remove records from a table.

---

## Basic Syntax

```sql id="1r2x8v"
DELETE FROM table_name
WHERE condition;
```

For example:

```sql id="c7g8t5"
DELETE FROM students
WHERE student_id = 3;
```

This removes the student whose ID is `3`.

---

# 16. DELETE and `WHERE`

The same warning that applies to `UPDATE` applies to `DELETE`.

If you want to delete only specific records, use a `WHERE` condition.

Safe example:

```sql id="n8d8a2"
DELETE FROM students
WHERE student_id = 3;
```

Only the matching record is removed.

---

# 17. Dangerous DELETE

Consider:

```sql id="5v7y3h"
DELETE FROM students;
```

There is no `WHERE` clause.

This means:

> Delete **all rows** from the table.

The important distinction is that the **table itself remains**.

```text id="y0k3wm"
Before:
students
├── row 1
├── row 2
└── row 3

DELETE FROM students;

After:
students
└── empty table
```

The table structure is still present.

For example, the columns:

```text id="e2m5gk"
student_id
name
age
grade
```

still exist.

Only the records have been removed.

---

# 18. CRUD in One Example

Let's put all four operations together.

## Step 1 — CREATE

Create the table:

```sql id="v2dy9s"
CREATE TABLE students (
    student_id SERIAL,
    name VARCHAR(100),
    age INT,
    grade TEXT
);
```

---

## Step 2 — CREATE/INSERT

Add records:

```sql id="4xj8j8"
INSERT INTO students (name, age, grade)
VALUES
    ('Akarsh', 20, 'A'),
    ('Anjali', 21, 'B'),
    ('Raj', 22, 'A');
```

---

## Step 3 — READ

Read all records:

```sql id="5f7e0o"
SELECT *
FROM students;
```

---

## Step 4 — UPDATE

Change Akarsh's age:

```sql id="9d4k2s"
UPDATE students
SET age = 21
WHERE name = 'Akarsh';
```

---

## Step 5 — DELETE

Remove Raj:

```sql id="q8y0k4"
DELETE FROM students
WHERE name = 'Raj';
```

---

# 19. CRUD Flow

The entire process can be visualized as:

```text id="d8e4g2"
              STUDENTS TABLE
                    │
          ┌─────────┼─────────┐
          ↓         ↓         ↓
       INSERT     SELECT    UPDATE
          │         │         │
          ↓         ↓         ↓
        Add       Read      Modify
       records    records   records
                              │
                              ↓
                           DELETE
                              │
                              ↓
                           Remove
```

---

# 20. Important Difference: DELETE vs Dropping a Table

Based on this section, remember that:

```sql id="v0s6v4"
DELETE FROM students;
```

removes the **rows**.

The table structure remains.

Conceptually:

```text id="k3h6l4"
DELETE
 ↓
Remove records
 ↓
Table remains
```

This is different from removing the entire table structure, which is a separate operation not covered in this section.

---

# 21. Common Mistakes / Gotchas

## Mistake 1 — Forgetting `WHERE` in UPDATE

Dangerous:

```sql id="h2z3rq"
UPDATE students
SET age = 25;
```

Result:

```text
Every student's age → 25
```

---

## Mistake 2 — Forgetting `WHERE` in DELETE

Dangerous:

```sql id="u8k2p4"
DELETE FROM students;
```

Result:

```text
All rows → deleted
Table → remains
```

---

## Mistake 3 — Manually inserting a SERIAL ID

If:

```sql id="z5k7ab"
student_id SERIAL
```

you normally don't need to provide:

```text id="6g4e1v"
student_id
```

PostgreSQL generates it automatically.

---

## Mistake 4 — Using `SELECT *` everywhere

`SELECT *` is useful when you genuinely need all columns.

But when you only need a few fields, explicitly selecting columns can improve:

* readability
* efficiency

Example:

```sql id="j2p9c5"
SELECT name, age
FROM students;
```

is clearer when those are the only values needed.

---

# 22. CRUD Cheat Sheet

| Operation    | SQL            | Example                                     |
| ------------ | -------------- | ------------------------------------------- |
| Create table | `CREATE TABLE` | `CREATE TABLE students (...)`               |
| Add data     | `INSERT INTO`  | `INSERT INTO students (...) VALUES (...)`   |
| Read data    | `SELECT`       | `SELECT * FROM students`                    |
| Update data  | `UPDATE`       | `UPDATE students SET age = 21 WHERE id = 1` |
| Delete data  | `DELETE`       | `DELETE FROM students WHERE id = 1`         |

---

# 23. Most Important SQL Patterns

### Create table

```sql
CREATE TABLE students (
    student_id SERIAL,
    name VARCHAR(100),
    age INT,
    grade TEXT
);
```

### Insert one row

```sql
INSERT INTO students (name, age, grade)
VALUES ('Akarsh', 20, 'A');
```

### Insert multiple rows

```sql
INSERT INTO students (name, age, grade)
VALUES
    ('Akarsh', 20, 'A'),
    ('Anjali', 21, 'B'),
    ('Raj', 22, 'A');
```

### Read everything

```sql
SELECT *
FROM students;
```

### Read selected columns

```sql
SELECT name, age
FROM students;
```

### Update specific record

```sql
UPDATE students
SET age = 21
WHERE student_id = 1;
```

### Delete specific record

```sql
DELETE FROM students
WHERE student_id = 1;
```

---

# 24. Key Takeaways

* **CRUD** means:

  * Create
  * Read
  * Update
  * Delete
* `CREATE TABLE` defines the structure of a table.
* Columns require appropriate data types such as:

  * `INT`
  * `VARCHAR`
  * `TEXT`
* `INSERT INTO` adds records.
* `VALUES` contains the actual values being inserted.
* A `SERIAL` column can automatically generate IDs, so you don't normally provide the ID manually.
* `SELECT` retrieves data.
* `SELECT *` retrieves all columns and rows.
* Selecting only required columns can improve readability and performance.
* `UPDATE` modifies existing records.
* `SET` specifies the new values.
* **Always be careful with `WHERE` in `UPDATE`.**
* Without `WHERE`, an `UPDATE` affects every row.
* `DELETE` removes records.
* **Always be careful with `WHERE` in `DELETE`.**
* `DELETE FROM table_name;` removes all rows but leaves the table structure intact.

---

# 25. Minimal Self-Test

Try answering these without looking at the notes.

### CREATE

1. What does CRUD stand for?
2. What is the purpose of `CREATE TABLE`?
3. What information do you define when creating a table?
4. Write a `CREATE TABLE` statement for a `students` table.

### INSERT

5. What does `INSERT INTO` do?
6. What is the purpose of `VALUES`?
7. How do you insert multiple rows?
8. What happens when `student_id` is `SERIAL`?
9. Do you need to manually provide a `SERIAL` ID?

### SELECT

10. What does `SELECT *` mean?
11. How do you select only `name` and `age`?
12. Why might selecting specific columns be preferable to `SELECT *`?

### UPDATE

13. What does `UPDATE` do?
14. What is the purpose of `SET`?
15. Why is `WHERE` extremely important in an `UPDATE`?
16. What happens if you execute:

```sql
UPDATE students
SET age = 25;
```

### DELETE

17. What does `DELETE` do?
18. What happens when you execute:

```sql
DELETE FROM students
WHERE student_id = 3;
```

19. What happens when you execute:

```sql
DELETE FROM students;
```

20. Does `DELETE FROM students;` remove the table itself?

---

# 26. Final Mental Model

If you remember only one thing from this module, remember:

```text id="w9l5k6"
             CRUD
              │
      ┌───────┼───────┐
      ↓       ↓       ↓
   CREATE    READ    UPDATE
      │       │       │
      ↓       ↓       ↓
   INSERT   SELECT    SET
                        │
                        ↓
                     WHERE
                        │
                        ↓
                     DELETE
```

And the **golden rule**:

> **Before executing `UPDATE` or `DELETE`, check your `WHERE` clause. Without it, you may affect every row in the table.**
