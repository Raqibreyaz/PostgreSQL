# Navigating pgAdmin

## What it is

**pgAdmin** is the graphical interface used to work with PostgreSQL.

Instead of interacting with PostgreSQL entirely through the command line, pgAdmin provides a visual environment where you can:

* Browse databases and tables
* Write SQL queries
* Execute queries
* View query results
* View and edit table data
* Manage database objects

Think of it as a **control panel for PostgreSQL**.

---

## One-Sentence Summary

> **pgAdmin lets you visually navigate PostgreSQL databases, write SQL using the Query Tool, execute queries, and inspect table data through a graphical interface.**

---

# 1. The pgAdmin Interface

When you open pgAdmin, one of the most important parts is the **Browser** panel on the left.

The Browser displays your PostgreSQL objects in a tree structure.

A simplified view looks like:

```text
Browser
│
├── Servers
│   │
│   └── PostgreSQL
│       │
│       ├── Databases
│       │   │
│       │   └── my_database
│       │       │
│       │       └── Schemas
│       │           │
│       │           └── public
│       │               │
│       │               └── Tables
│       │
│       └── ...
```

This tree is how you navigate through the PostgreSQL environment.

---

# 2. Browser Tree

The **Browser** is the object explorer on the left side of pgAdmin.

It allows you to navigate through things such as:

* Servers
* Databases
* Schemas
* Tables

The exact hierarchy you will work with is:

```text
Server
  ↓
Database
  ↓
Schema
  ↓
Table
```

Understanding this hierarchy is important because SQL objects are organized inside these levels.

---

# 3. Finding the `public` Schema

One important object to recognize is:

```text
public
```

The `public` schema is the default schema discussed in the course.

When you create tables normally, they are commonly placed under this schema.

You may see something similar to:

```text
Databases
   ↓
my_database
   ↓
Schemas
   ↓
public
   ↓
Tables
```

### Mental model

Think of the `public` schema as a **default folder** inside your database.

```text
Database
   │
   └── public
        │
        ├── students
        ├── products
        └── orders
```

---

# 4. Opening the Query Tool

To write SQL in pgAdmin, you use the **Query Tool**.

### Steps

1. Find the database you want to work with.
2. Right-click the database.
3. Select **Query Tool**.

Conceptually:

```text
Database
   │
   └── Right-click
          ↓
     Query Tool
          ↓
     Write SQL
```

The Query Tool is where you will spend a lot of your time when learning SQL.

---

# 5. Query Tool Workspace

The Query Tool provides a workspace for writing and executing SQL.

The important areas discussed in the course are:

```text
+------------------------------------------+
|              Query Editor                |
|                                          |
|  SELECT * FROM students;                 |
|                                          |
+------------------------------------------+
|              Data Output                 |
|                                          |
|  student_id | name | age | grade        |
|  1          | ...  | ... | ...          |
|                                          |
+------------------------------------------+
```

There are two important parts.

---

## Query Editor

The **Query Editor** is where you write SQL.

Example:

```sql
SELECT *
FROM students;
```

You write your SQL commands here before executing them.

---

## Data Output

The **Data Output** area displays the result after your query executes.

For example, if the table contains:

| student_id | name   | age | grade |
| ---------: | ------ | --: | ----- |
|          1 | Akarsh |  20 | A     |
|          2 | Anjali |  21 | B     |

and you execute:

```sql
SELECT *
FROM students;
```

the results appear in the Data Output pane.

---

# 6. Executing a Query

After writing SQL, you need to execute it.

pgAdmin provides an **Execute/Refresh** control, commonly represented by a **lightning-bolt icon**.

The basic workflow is:

```text
Write SQL
   ↓
Click Execute
   ↓
PostgreSQL processes query
   ↓
Result appears
   ↓
Data Output
```

For example:

```sql
SELECT *
FROM students;
```

Then execute the query.

The returned rows will appear in the output area.

---

# 7. Creating Data Through Query Tool

The Query Tool is not only for reading data.

You can use it to execute SQL that changes the database.

For example:

```sql
CREATE TABLE students (
    student_id INT,
    name VARCHAR(100)
);
```

After execution, the table is created.

You can then use:

```sql
INSERT INTO students (student_id, name)
VALUES
    (1, 'Akarsh'),
    (2, 'Anjali');
```

And read the data:

```sql
SELECT *
FROM students;
```

So the Query Tool becomes your main SQL workspace.

---

# 8. Viewing Table Data Directly

pgAdmin also allows you to inspect table contents without writing a `SELECT` query.

### Steps

1. Find the table in the Browser.
2. Right-click the table.
3. Select **View/Edit Data**.
4. Select **All Rows**.

This opens the table's data in a spreadsheet-like interface.

---

# 9. Spreadsheet-Like Data View

Suppose you have:

```text
students
```

with:

| student_id | name   | age | grade |
| ---------: | ------ | --: | ----- |
|          1 | Akarsh |  20 | A     |
|          2 | Anjali |  21 | B     |
|          3 | Raj    |  22 | A     |

Using:

```text
Right-click table
      ↓
View/Edit Data
      ↓
All Rows
```

you can see the records in a graphical table.

This is useful when you want to quickly inspect what is currently stored.

---

# 10. Query Tool vs View/Edit Data

These are useful for different purposes.

| Feature                       | Query Tool  | View/Edit Data |
| ----------------------------- | ----------- | -------------- |
| Write SQL                     | Yes         | No             |
| Execute SQL                   | Yes         | No             |
| View query results            | Yes         | Yes            |
| Inspect table rows            | Yes         | Yes            |
| Spreadsheet-like interface    | No          | Yes            |
| Work directly with table data | Through SQL | Graphically    |

### Mental model

```text
Query Tool
    ↓
"I want to tell PostgreSQL what to do."

View/Edit Data
    ↓
"I want to visually inspect the table."
```

---

# 11. The Complete pgAdmin Workflow

A common workflow while learning PostgreSQL will look like this:

```text
Open pgAdmin
     ↓
Find Server
     ↓
Open Database
     ↓
Open Schema
     ↓
Find Table
     ↓
Open Query Tool
     ↓
Write SQL
     ↓
Execute
     ↓
Check Data Output
     ↓
Refresh Browser
     ↓
Inspect Table if needed
```

---

# 12. Why Refreshing Matters

One of the most important practical tips from this section is:

> **Refresh the object explorer after changing the database structure.**

Suppose you create a new table:

```sql
CREATE TABLE students (
    student_id INT,
    name TEXT
);
```

PostgreSQL creates the table.

But the Browser tree may not immediately show the newly created table.

You should refresh the relevant object explorer/tree.

Conceptually:

```text
Create table
     ↓
Database changes
     ↓
Refresh Browser
     ↓
New table appears
```

---

# 13. Why Beginners Often Get Confused Here

Imagine you execute:

```sql
CREATE TABLE students (
    student_id INT,
    name TEXT
);
```

The query succeeds.

But you look at:

```text
Schemas
  ↓
public
  ↓
Tables
```

and don't immediately see `students`.

This does **not necessarily mean the table wasn't created**.

The Browser may simply need to be refreshed.

So remember:

```text
Database state
      ≠
What the pgAdmin tree currently displays
```

Refreshing makes the interface reflect the latest database structure.

---

# 14. Important pgAdmin Mental Model

Think of pgAdmin as having two different ways of interacting with your database.

### Method 1 — SQL

```text
You
 ↓
Query Tool
 ↓
SQL
 ↓
PostgreSQL
 ↓
Result
```

### Method 2 — Graphical navigation

```text
You
 ↓
Browser
 ↓
Database / Schema / Table
 ↓
View/Edit Data
 ↓
Visual representation
```

Both interact with the same PostgreSQL database.

---

# 15. Example: Complete Small Workflow

Suppose you want to create a student table.

### Step 1 — Open the database

In the Browser:

```text
Servers
  ↓
PostgreSQL
  ↓
Databases
  ↓
your_database
```

---

### Step 2 — Open Query Tool

Right-click the database:

```text
Right-click
    ↓
Query Tool
```

---

### Step 3 — Create the table

Write:

```sql
CREATE TABLE students (
    student_id INT,
    name VARCHAR(100),
    age INT,
    grade VARCHAR(2)
);
```

---

### Step 4 — Execute

Click the Execute/Refresh button.

---

### Step 5 — Refresh the Browser

Navigate to:

```text
Schemas
   ↓
public
   ↓
Tables
```

Refresh the tree if necessary.

You should now be able to find:

```text
students
```

---

### Step 6 — Insert data

In the Query Tool:

```sql
INSERT INTO students
    (student_id, name, age, grade)
VALUES
    (1, 'Akarsh', 20, 'A'),
    (2, 'Anjali', 21, 'B'),
    (3, 'Raj', 22, 'A');
```

Execute it.

---

### Step 7 — Read the data

```sql
SELECT *
FROM students;
```

The results appear in:

```text
Data Output
```

---

### Step 8 — Inspect the table graphically

Alternatively:

```text
students
   ↓
Right-click
   ↓
View/Edit Data
   ↓
All Rows
```

Now you can see the records in a spreadsheet-like interface.

---

# 16. Common Mistakes / Gotchas

## 1. Looking for Query Tool in the wrong place

The course explains that you access the Query Tool by **right-clicking the database**.

Remember:

```text
Database
   ↓
Right-click
   ↓
Query Tool
```

---

## 2. Forgetting to execute the query

Writing:

```sql
SELECT *
FROM students;
```

does not automatically run it.

You need to execute the query using the Execute/Refresh control.

---

## 3. Looking at the wrong pane

Remember:

```text
Query Editor → Write SQL

Data Output → See query results
```

---

## 4. Assuming a newly created table should immediately appear

After changing database structure, refresh the Browser/object explorer.

---

## 5. Confusing Query Tool with View/Edit Data

They are not the same.

```text
Query Tool
→ Write and execute SQL

View/Edit Data
→ Visually inspect table records
```

---

# 17. Quick Revision Cheat Sheet

```text
pgAdmin
→ GUI for PostgreSQL

Browser
→ Left-side object explorer

Database
→ Contains schemas

Schema
→ Contains database objects

public
→ Default schema discussed in the course

Query Tool
→ Write and execute SQL

Query Editor
→ Where SQL is written

Data Output
→ Where query results appear

Execute/Refresh
→ Runs the SQL query

View/Edit Data
→ Opens table data graphically

All Rows
→ Displays the table's records

Refresh Browser
→ Updates the object explorer after structural changes
```

---

# 18. Key Workflow to Remember

```text
                pgAdmin
                   │
          ┌────────┴────────┐
          ↓                 ↓
      Browser           Query Tool
          │                 │
          ↓                 ↓
 Database → Schema       Write SQL
          ↓                 ↓
        Tables          Execute SQL
          │                 ↓
          ↓             Data Output
 View/Edit Data
          ↓
      All Rows
```

---

# 19. Key Takeaways

* **pgAdmin** is the graphical interface for PostgreSQL.
* The **Browser** lets you navigate through servers, databases, schemas, and tables.
* The **`public` schema** is the default schema discussed in this course.
* The **Query Tool** is where you write SQL.
* The **Query Editor** is the area where SQL code is written.
* **Data Output** shows the results of executed queries.
* The **Execute/Refresh** control is used to run SQL.
* You can inspect table contents through:

  ```text
  Right-click table
  → View/Edit Data
  → All Rows
  ```
* After changing the database structure, **refresh the Browser/object explorer** so pgAdmin displays the latest state.
* Query Tool and View/Edit Data are complementary:

  * Query Tool → work with SQL.
  * View/Edit Data → visually inspect table records.

---

# 20. Minimal Self-Test

1. What is pgAdmin?
2. What is the Browser panel used for?
3. What is the hierarchy from server to table?
4. What is the `public` schema?
5. How do you open the Query Tool?
6. Where do you write SQL?
7. Where do query results appear?
8. How do you execute a query in pgAdmin?
9. How can you visually inspect all rows of a table?
10. What should you do if a newly created table doesn't appear in the Browser?
11. What is the difference between Query Tool and View/Edit Data?
12. What is the purpose of the Data Output pane?

---

# 21. What to Learn Next

The next logical step is to start **creating and working with databases and tables**.

You should move from:

```text
Navigating pgAdmin
       ↓
Opening Query Tool
       ↓
Writing SQL
       ↓
CREATE DATABASE
       ↓
CREATE TABLE
       ↓
INSERT
       ↓
SELECT
```

That will take you into the practical side of PostgreSQL and basic CRUD operations.
