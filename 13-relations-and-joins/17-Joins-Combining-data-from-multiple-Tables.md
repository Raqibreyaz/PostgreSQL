# SQL JOINs: Combining Data from Multiple Tables

## What it is

A **JOIN** is used to combine rows from **two or more tables** based on a related column.

In relational databases, information is often divided across multiple tables. A JOIN allows us to bring the related information together when we need to query it.

The relationship is commonly based on:

```text
Primary Key
    ↓
Foreign Key
```

For example:

```text
students                         marks
────────                         ─────
student_id (PK) ─────────────→  student_id (FK)
name                             subject
                                 marks
```

A JOIN uses this relationship to combine information from both tables.

---

## One-sentence summary

> **A SQL JOIN combines related rows from multiple tables using matching columns, usually a Primary Key in one table and a Foreign Key in another.**

---

# 1. Why Do We Need JOINs?

In a properly organized relational database, all information is not stored in one giant table.

For example, student information might be stored separately:

### `students`

| student_id | name   |
| ---------: | ------ |
|          1 | Akarsh |
|          2 | Anjali |

And marks might be stored in:

### `marks`

| mark_id | student_id | subject | marks |
| ------: | ---------: | ------- | ----: |
|     101 |          1 | Math    |    89 |
|     102 |          1 | English |    92 |
|     103 |          2 | Math    |    95 |

Now imagine we want to answer:

> **Which student scored 89 in Math?**

The student's name is in `students`, while the marks are in `marks`.

We need a way to combine the two tables.

That's exactly what a **JOIN** does.

---

# 2. The Basic Idea

Think of a JOIN as a **bridge** between tables.

```text
┌──────────────┐                  ┌──────────────┐
│   students   │                  │    marks     │
├──────────────┤                  ├──────────────┤
│ student_id   │◄──── JOIN ─────►│ student_id   │
│ name         │                  │ subject      │
└──────────────┘                  │ marks        │
                                  └──────────────┘
```

The matching column is:

```text
students.student_id
        =
marks.student_id
```

SQL uses this relationship to determine which rows belong together.

---

# 3. Primary Key and Foreign Key

A JOIN commonly works using a **Primary Key–Foreign Key relationship**.

For example:

```text
students
───────────────
student_id  ← Primary Key
name
```

and:

```text
marks
───────────────
mark_id
student_id  ← Foreign Key
subject
marks
```

The relationship is:

```text
students.student_id
        │
        │ PK
        ↓
        ↑
        │ FK
marks.student_id
```

This provides the connection that the JOIN can use.

---

# 4. Basic JOIN Syntax

The basic structure is:

```sql
SELECT ...
FROM table1
JOIN table2
ON table1.related_column = table2.related_column;
```

The important parts are:

### `FROM`

Specifies the first table.

```sql
FROM students
```

### `JOIN`

Specifies the table that we want to combine with it.

```sql
JOIN marks
```

### `ON`

Defines **how the two tables are related**.

```sql
ON students.student_id = marks.student_id
```

So the complete query could be:

```sql
SELECT *
FROM students
JOIN marks
ON students.student_id = marks.student_id;
```

---

# 5. Understanding the `ON` Condition

The `ON` clause is extremely important.

For example:

```sql
ON students.student_id = marks.student_id
```

means:

> Match a student row with a marks row when their `student_id` values are the same.

Suppose:

### Students

| student_id | name   |
| ---------: | ------ |
|          1 | Akarsh |
|          2 | Anjali |

### Marks

| mark_id | student_id | subject | marks |
| ------: | ---------: | ------- | ----: |
|     101 |          1 | Math    |    89 |
|     102 |          1 | English |    92 |
|     103 |          2 | Math    |    95 |

The JOIN matches:

```text
Student 1 ↔ Marks 101
Student 1 ↔ Marks 102
Student 2 ↔ Marks 103
```

The result can therefore contain:

| student_id | name   | mark_id | subject | marks |
| ---------: | ------ | ------: | ------- | ----: |
|          1 | Akarsh |     101 | Math    |    89 |
|          1 | Akarsh |     102 | English |    92 |
|          2 | Anjali |     103 | Math    |    95 |

---

# 6. Why Does Student Data Repeat?

This is an important point when working with **One-to-Many relationships**.

A student can have multiple marks records.

For example:

```text
Akarsh
  │
  ├── Math → 89
  └── English → 92
```

After the JOIN:

```text
Akarsh | Math    | 89
Akarsh | English | 92
```

The student's name appears multiple times.

This is **expected behavior**.

It does not mean that duplicate student records have been created.

The JOIN is simply returning one result row for each matching relationship.

---

# 7. One-to-Many JOIN Visualization

Consider:

```text
students
──────────────
1 | Akarsh
```

and:

```text
marks
────────────────
101 | 1 | Math
102 | 1 | English
103 | 1 | Science
```

The JOIN produces:

```text
                    JOIN
                     │
                     ▼

1 | Akarsh ───────→ 101 | Math
        │
        ├─────────→ 102 | English
        │
        └─────────→ 103 | Science
```

Result:

```text
Akarsh | Math
Akarsh | English
Akarsh | Science
```

So repeated parent information is normal in a One-to-Many JOIN result.

---

# 8. Selecting Only the Required Columns

A JOIN does not mean that we have to display every column.

Usually, we only want the information that answers our question.

For example:

```sql
SELECT s.name, m.subject, m.marks
FROM students s
JOIN marks m
ON s.student_id = m.student_id;
```

The output might be:

| name   | subject | marks |
| ------ | ------- | ----: |
| Akarsh | Math    |    89 |
| Akarsh | English |    92 |
| Anjali | Math    |    95 |

Notice that `student_id` and `mark_id` are not displayed.

They were useful for establishing the relationship, but they may not be useful in the final output.

---

# 9. Table Aliases

When queries involve multiple tables, repeatedly writing full table names can become inconvenient.

For example:

```sql
SELECT students.name, marks.subject, marks.marks
FROM students
JOIN marks
ON students.student_id = marks.student_id;
```

This works, but it becomes harder to read as queries become more complex.

We can give tables short names called **aliases**.

```sql
SELECT s.name, m.subject, m.marks
FROM students AS s
JOIN marks AS m
ON s.student_id = m.student_id;
```

Here:

```text
s → students
m → marks
```

The aliases make the query shorter and easier to maintain.

---

# 10. Understanding `s.name`

When we write:

```sql
s.name
```

we mean:

```text
table alias + column
```

So:

```text
s.name
```

means:

```text
students.name
```

Similarly:

```text
m.subject
```

means:

```text
marks.subject
```

This is especially useful when different tables contain columns with the same name.

---

# 11. Example: Finding a Student Who Scored 89 in Math

Suppose the question is:

> Which student scored 89 in Math?

The information is distributed across two tables:

```text
students
    ↓
name

marks
    ↓
subject + marks
```

A JOIN brings the information together:

```sql
SELECT s.name, m.subject, m.marks
FROM students AS s
JOIN marks AS m
ON s.student_id = m.student_id
WHERE m.subject = 'Math'
  AND m.marks = 89;
```

The JOIN first connects the related student and marks data.

Then `WHERE` filters the result.

Possible result:

| name   | subject | marks |
| ------ | ------- | ----: |
| Akarsh | Math    |    89 |

This demonstrates why JOINs are useful for **real-world analytical queries**.

---

# 12. JOIN as a Data Bridge

A useful mental model:

```text
Table A                    Table B
────────                    ────────
Student information        Marks information
       │                        │
       │                        │
       └────── JOIN ────────────┘
                    │
                    ▼
             Combined Result
```

The JOIN doesn't necessarily change the underlying tables.

It creates a result set containing information from the related tables.

---

# 13. JOIN and Database Relationships

JOINs are closely connected to the relationships studied earlier.

### One-to-One

```text
Student 1 ─────── Profile 1
```

A JOIN can combine the student's information with their profile.

### One-to-Many

```text
Student 1 ─────── Mark 1
         ├─────── Mark 2
         └─────── Mark 3
```

A JOIN can combine the student's information with all matching marks.

Therefore:

```text
Relationships
      ↓
Related tables
      ↓
JOIN
      ↓
Combined query result
```

---

# 14. Important Point: JOIN Does Not Remove Repetition

A common beginner expectation is:

> "If the student appears once in the students table, shouldn't the JOIN show the student only once?"

No.

If the student has multiple matching child records, the result naturally contains multiple rows.

For example:

```text
Students

1 | Akarsh
```

Marks:

```text
1 | Math
1 | English
1 | Science
```

JOIN result:

```text
Akarsh | Math
Akarsh | English
Akarsh | Science
```

This is correct.

The database is representing **three relationships**.

---

# 15. Why Use Aliases?

Aliases are particularly useful when queries become complex.

Without aliases:

```sql
SELECT students.name, marks.subject
FROM students
JOIN marks
ON students.student_id = marks.student_id;
```

With aliases:

```sql
SELECT s.name, m.subject
FROM students AS s
JOIN marks AS m
ON s.student_id = m.student_id;
```

The second version is:

* Shorter
* Easier to read
* Easier to maintain
* Convenient when working with multiple tables

The source specifically highlights aliases such as:

```text
s → students
m → marks
```

---

# 16. Common Mistakes / Gotchas

## 1. Forgetting the `ON` condition

A JOIN needs a condition describing how the tables are related.

For example:

```sql
ON s.student_id = m.student_id
```

This tells SQL which records belong together.

---

## 2. Selecting unnecessary columns

You don't always need:

```sql
SELECT *
```

A cleaner query selects only what is required:

```sql
SELECT s.name, m.subject, m.marks
```

This makes the result easier to understand.

---

## 3. Being surprised by repeated rows

With a One-to-Many relationship:

```text
One student
    ↓
Many marks
```

the student's information can appear multiple times.

That is normal JOIN behavior.

---

## 4. Confusing table aliases

If you define:

```sql
FROM students AS s
JOIN marks AS m
```

then use:

```sql
s.name
m.subject
```

not:

```sql
student.name
mark.subject
```

unless those are the actual table names/aliases being used.

---

## 5. Forgetting which table a column belongs to

When multiple tables contain similarly named columns, explicitly qualify them:

```sql
s.student_id
m.student_id
```

rather than relying on:

```sql
student_id
```

This makes the query clearer and avoids ambiguity.

---

# 17. Core Query Pattern

For interview preparation, remember this basic pattern:

```sql
SELECT columns
FROM table1 AS t1
JOIN table2 AS t2
ON t1.common_column = t2.common_column;
```

Example:

```sql
SELECT s.name, m.subject, m.marks
FROM students AS s
JOIN marks AS m
ON s.student_id = m.student_id;
```

Mental translation:

```text
SELECT
    What do I want?

FROM
    Which table starts the query?

JOIN
    Which related table do I need?

ON
    How are these tables connected?
```

---

# 18. Complete Mental Model

The entire concept can be remembered as:

```text
                  Relational Database
                         │
             ┌───────────┴───────────┐
             ↓                       ↓
         Students                  Marks
             │                       │
             │ student_id            │ student_id
             │                       │
             └───────────┬───────────┘
                         ↓
                        JOIN
                         ↓
                 Combined Result
                         │
                         ↓
              Useful information
```

Or even more simply:

```text
Primary Key
     │
     │ relationship
     ↓
Foreign Key
     │
     ↓
    JOIN
     │
     ↓
Combined data
```

---

# Key Takeaways

* A **JOIN** combines related rows from multiple tables.
* JOINs are commonly based on a **Primary Key–Foreign Key relationship**.
* The `ON` clause defines how the tables are connected.
* Basic structure:

```sql
SELECT ...
FROM table1
JOIN table2
ON table1.column = table2.column;
```

* JOINs are useful when related information is distributed across different tables.
* Example: student names in `students` and marks in `marks`.
* One-to-Many relationships can cause parent information to appear repeatedly in the JOIN result.
* This repetition is **expected**, not necessarily duplicate data.
* You should usually select only the columns needed for the result.
* Table aliases such as `s` and `m` make JOIN queries shorter and easier to maintain.
* `s.name` means `students.name` when `s` is the alias for `students`.
* JOINs allow complex real-world queries such as finding which student achieved a particular mark in a particular subject.
* JOINs combine data in the **result set**; they do not automatically merge or modify the underlying tables.

---

# Minimal Self-Test

1. What is a SQL JOIN?
2. Why are JOINs needed in relational databases?
3. What is the role of the `ON` clause?
4. What is the relationship between a Primary Key and Foreign Key in a JOIN?
5. Write the basic syntax of a JOIN.
6. Why might a student's name appear multiple times after a JOIN?
7. Is repeated student information necessarily duplicate data? Why?
8. What does `s` represent in:

```sql
FROM students AS s
```

9. What does `s.name` mean?
10. Why are table aliases useful?
11. Given `students(student_id, name)` and `marks(student_id, subject, marks)`, write a query that displays student name, subject, and marks.
12. Write a query to find the student who scored `89` in Math.
13. Explain how a One-to-Many relationship affects a JOIN result.
14. Draw the relationship:

```text
students
student_id (PK)
      │
      │
      ↓
marks
student_id (FK)
```

15. Explain the complete flow from **relationship → JOIN → combined result set**.
