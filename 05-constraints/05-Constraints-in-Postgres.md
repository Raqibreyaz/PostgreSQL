# SQL Constraints in PostgreSQL

## What it is

**Constraints** are rules applied to table columns that control what data can be inserted into a database.

Their main purpose is to protect **data accuracy, consistency, and reliability**.

For example, if every user must have an email address and no two users should have the same email, we can tell PostgreSQL to enforce those rules:

```sql
email TEXT NOT NULL UNIQUE
```

Now PostgreSQL itself prevents invalid data from being inserted.

---

## One-Sentence Summary

> **SQL constraints are database-level rules that restrict invalid data and help maintain clean, accurate, and reliable tables.**

---

# 1. Why Do We Need Constraints?

Without constraints, applications could accidentally insert bad or inconsistent data.

Imagine a users table:

| id | username | email                                           | age |
| -: | -------- | ----------------------------------------------- | --: |
|  1 | Akarsh   | [akarsh@example.com](mailto:akarsh@example.com) |  21 |
|  2 | Akarsh   | [akarsh@example.com](mailto:akarsh@example.com) |  21 |
|  3 | NULL     | NULL                                            |  15 |

Depending on the application's requirements, some of these records may be invalid.

Constraints allow us to tell PostgreSQL:

```text id="k3x8m2"
"These are the rules my data must follow."
```

PostgreSQL then enforces those rules.

---

# 2. Core Constraints Covered

This section introduces five important constraints:

```text id="v7m4q9"
SQL Constraints
│
├── NOT NULL
├── UNIQUE
├── PRIMARY KEY
├── DEFAULT
└── CHECK
```

Each solves a different problem.

| Constraint    | Main purpose                   |
| ------------- | ------------------------------ |
| `NOT NULL`    | Value must be provided         |
| `UNIQUE`      | Values cannot be duplicated    |
| `PRIMARY KEY` | Uniquely identifies each row   |
| `DEFAULT`     | Provides a value automatically |
| `CHECK`       | Validates a condition          |

---

# 3. NOT NULL

## What it is

`NOT NULL` prevents a column from containing `NULL`.

Example:

```sql id="q8n2v6"
CREATE TABLE students (
    name TEXT NOT NULL
);
```

This means:

> Every student record must have a value for `name`.

---

## Valid Insert

```sql id="s4m7p1"
INSERT INTO students (name)
VALUES ('Akarsh');
```

This works because `name` has been provided.

---

## Invalid Insert

```sql id="r6x3k8"
INSERT INTO students
DEFAULT VALUES;
```

If `name` is required and no value is provided, PostgreSQL rejects the operation.

The database is enforcing:

```text id="y9c5v2"
name
 ↓
NOT NULL
 ↓
Must have a value
```

---

# 4. What Is NULL?

`NULL` means that a value is **missing or unknown**.

It is not the same as:

```text id="p4m8x1"
''
```

(empty string)

and it is not necessarily the same as:

```text id="w6k2r9"
0
```

(zero).

The important point for this module is:

> `NOT NULL` prevents a column from having a `NULL` value.

---

# 5. UNIQUE

## What it is

`UNIQUE` ensures that values in a column are distinct.

For example, usernames should generally not be duplicated.

```sql id="h7q3m5"
CREATE TABLE users (
    username TEXT UNIQUE
);
```

Now PostgreSQL ensures that two rows cannot have the same username value under this constraint.

---

## Example

First insert:

```sql id="f2m8k4"
INSERT INTO users (username)
VALUES ('akarsh');
```

This works.

Trying to insert the same username again:

```sql id="c9v5x7"
INSERT INTO users (username)
VALUES ('akarsh');
```

violates the `UNIQUE` constraint and PostgreSQL returns an error.

---

# 6. Common Uses of UNIQUE

`UNIQUE` is commonly useful for fields such as:

* Email addresses
* Usernames

For example:

```sql id="t3k7q1"
CREATE TABLE users (
    email TEXT UNIQUE,
    username TEXT UNIQUE
);
```

This prevents duplicate values for those columns.

---

# 7. PRIMARY KEY

## What it is

A **primary key** is the unique identifier for each row in a table.

For example:

```sql id="m8x4p2"
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name TEXT
);
```

Here:

```text id="q2r6v9"
student_id
     ↓
PRIMARY KEY
     ↓
Unique identifier for each row
```

---

# 8. PRIMARY KEY = NOT NULL + UNIQUE

The source explains a primary key as a combination of:

```text id="z4k8m1"
NOT NULL
    +
UNIQUE
    ↓
PRIMARY KEY
```

Therefore, a primary key:

1. Cannot be `NULL`.
2. Must be unique.

For example:

| student_id | name   |
| ---------: | ------ |
|          1 | Akarsh |
|          2 | Anjali |
|          3 | Raj    |

Each student has a unique ID.

---

# 9. Why Do We Need a Primary Key?

Imagine trying to identify a student only by their name.

Two students could potentially have the same name.

Instead, we use an identifier:

```text id="c7m3x8"
student_id
    ↓
1
2
3
4
...
```

This gives every row a unique identity.

### Mental model

```text id="r9v2k6"
Table
 │
 ├── Row 1 → ID 1
 ├── Row 2 → ID 2
 ├── Row 3 → ID 3
 └── Row 4 → ID 4
```

---

# 10. One Primary Key Per Table

The source notes that a table can typically have **only one primary key**.

For example:

```sql id="k4x7m2"
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name TEXT
);
```

`student_id` is the table's primary key.

It serves as the main identifier for the rows.

---

# 11. SERIAL + PRIMARY KEY

A very common pattern is to combine an automatically generated ID with a primary key.

For example:

```sql id="w8q3p5"
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);
```

Now:

```text id="s6m2x9"
SERIAL
  ↓
Automatically generates ID

PRIMARY KEY
  ↓
ID must be unique
and not NULL
```

This is a useful pattern for table identifiers.

---

# 12. DEFAULT

## What it is

`DEFAULT` provides a fallback value when the user does not explicitly provide one.

Example:

```sql id="n5v8q2"
created_at TIMESTAMP DEFAULT NOW()
```

This means:

> If the user does not provide `created_at`, PostgreSQL automatically uses the current date and time.

---

# 13. DEFAULT NOW()

The source specifically demonstrates:

```sql id="j7m3x9"
DEFAULT NOW()
```

Example:

```sql id="b4q8k1"
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);
```

Now you can insert:

```sql id="v6x2m8"
INSERT INTO students (name)
VALUES ('Akarsh');
```

You don't need to manually provide the creation timestamp.

PostgreSQL supplies it.

Conceptually:

```text id="r8m5q3"
INSERT student
      ↓
created_at not provided
      ↓
DEFAULT NOW()
      ↓
Current date/time stored
```

---

# 14. Why DEFAULT Is Useful

`DEFAULT` is useful when a column normally has a predictable fallback value.

For example:

```text id="z2k7p4"
created_at → current timestamp
```

Instead of making every application explicitly provide the timestamp, the database can handle it.

---

# 15. CHECK

## What it is

`CHECK` validates data using a condition.

Example:

```sql id="c5m8x2"
age INT CHECK (age >= 18)
```

This means:

> The database should only accept values where `age >= 18`.

---

# 16. CHECK Example

Create a table:

```sql id="q9v3k7"
CREATE TABLE users (
    age INT CHECK (age >= 18)
);
```

Then:

```sql id="m4x8p1"
INSERT INTO users (age)
VALUES (25);
```

The condition is:

```text id="j6k2r5"
25 >= 18
```

which is true, so the value is accepted.

But:

```sql id="w3p7m9"
INSERT INTO users (age)
VALUES (15);
```

results in a failed constraint check because:

```text id="d8q4x1"
15 >= 18
     ↓
FALSE
```

---

# 17. CHECK as Conditional Logic

The instructor compares `CHECK` with conditional logic in programming languages such as Python.

The mental model is:

```text id="n7m2x5"
CHECK(condition)
       ↓
Is condition TRUE?
       │
   ┌───┴───┐
   ↓       ↓
 TRUE    FALSE
   ↓       ↓
Accept   Reject
```

For example:

```sql id="a8v3q6"
CHECK (age >= 18)
```

acts like a rule:

```python
# Mental model only
if age >= 18:
    accept()
else:
    reject()
```

---

# 18. Combining Multiple Constraints

A column can have multiple constraints.

For example:

```sql id="t4m8q2"
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username TEXT NOT NULL UNIQUE,
    age INT CHECK (age >= 18),
    created_at TIMESTAMP DEFAULT NOW()
);
```

This single table now has several rules:

```text id="x7k3p9"
user_id
   ↓
SERIAL + PRIMARY KEY
   ↓
Auto-generated + unique + not NULL


username
   ↓
NOT NULL + UNIQUE
   ↓
Must exist + no duplicates


age
   ↓
CHECK (age >= 18)
   ↓
Must be 18 or older


created_at
   ↓
DEFAULT NOW()
   ↓
Automatically gets current timestamp
```

---

# 19. Practical Table Example

The instructor demonstrates a table named:

```text id="v8m4q2"
random
```

with constraints applied to its columns.

The important lesson is not the table name itself.

The important lesson is:

> Once constraints are defined, they become rules that PostgreSQL strictly enforces.

Conceptually:

```text id="q5x9m2"
Table Definition
      ↓
Constraints
      ↓
Database Rules
      ↓
Every INSERT must follow them
```

---

# 20. What Happens During INSERT?

Suppose we have:

```sql id="k7r3m8"
CREATE TABLE random (
    id SERIAL PRIMARY KEY,
    email TEXT NOT NULL UNIQUE,
    age INT CHECK (age >= 18),
    created_at TIMESTAMP DEFAULT NOW()
);
```

Now an insert occurs.

PostgreSQL checks the constraints.

```text id="b6m2q8"
INSERT
  ↓
Check NOT NULL
  ↓
Check UNIQUE
  ↓
Check PRIMARY KEY
  ↓
Apply DEFAULT if needed
  ↓
Check CHECK condition
  ↓
Accept or reject
```

This is the important database-protection mechanism.

---

# 21. Example — Valid Insert

```sql id="p8v4k1"
INSERT INTO random (email, age)
VALUES ('akarsh@example.com', 21);
```

Assuming this email does not already exist:

```text id="f3m7x9"
email provided       → NOT NULL ✓
email unique         → UNIQUE ✓
age = 21             → CHECK ✓
id not provided      → SERIAL generates it ✓
created_at omitted   → DEFAULT NOW() ✓
```

The record can be inserted.

---

# 22. Example — NOT NULL Violation

Suppose:

```sql id="m6q2v8"
email TEXT NOT NULL
```

Then:

```sql id="z4k7p3"
INSERT INTO random (age)
VALUES (21);
```

The email wasn't provided.

Result:

```text id="x8m3q5"
email = NULL
     ↓
NOT NULL violated
     ↓
INSERT rejected
```

---

# 23. Example — UNIQUE Violation

Suppose this already exists:

```text id="c7v2m9"
akarsh@example.com
```

Then:

```sql id="r5k8q1"
INSERT INTO random (email, age)
VALUES ('akarsh@example.com', 22);
```

The email is duplicated.

Result:

```text id="n3m7x4"
Duplicate value
      ↓
UNIQUE violated
      ↓
INSERT rejected
```

---

# 24. Example — CHECK Violation

If:

```sql id="q8x4m2"
age INT CHECK (age >= 18)
```

and we try:

```sql id="v6m9k3"
INSERT INTO random (email, age)
VALUES ('test@example.com', 15);
```

then:

```text id="p2r7x5"
15 >= 18
   ↓
FALSE
   ↓
CHECK violated
   ↓
INSERT rejected
```

---

# 25. Example — DEFAULT in Action

Suppose:

```sql id="y4m8q2"
created_at TIMESTAMP DEFAULT NOW()
```

and we insert:

```sql id="c6v3p9"
INSERT INTO random (email, age)
VALUES ('test@example.com', 20);
```

We didn't provide `created_at`.

PostgreSQL uses:

```text id="r7k2m5"
DEFAULT NOW()
```

automatically.

---

# 26. Example — SERIAL in Action

Suppose:

```sql id="n5x8q3"
id SERIAL PRIMARY KEY
```

When inserting:

```sql id="m2v7k4"
INSERT INTO random (email, age)
VALUES ('test@example.com', 20);
```

you don't need:

```text id="q8r3m6"
id = ?
```

PostgreSQL generates the ID.

---

# 27. Constraint Failure Is a Good Thing

When PostgreSQL returns an error because a constraint was violated, that is not simply a problem.

It means the database is **protecting the data**.

For example:

```text id="w4m9x2"
Application sends invalid data
          ↓
PostgreSQL checks constraints
          ↓
Constraint violated
          ↓
ERROR
          ↓
Invalid data is not stored
```

This prevents bad data from silently entering the database.

---

# 28. Constraints and Data Integrity

This is the main idea of the entire module.

Without constraints:

```text id="p7x3m8"
Application
    ↓
Database
    ↓
Almost anything might be inserted
```

With constraints:

```text id="k2m8q4"
Application
    ↓
Database
    ↓
Constraint checks
    ↓
Valid data → Stored
Invalid data → Rejected
```

Therefore:

> **Constraints move important data-validation rules into the database itself.**

---

# 29. Constraint Comparison

| Constraint    | What it guarantees              | Example                    |
| ------------- | ------------------------------- | -------------------------- |
| `NOT NULL`    | Value cannot be `NULL`          | `name TEXT NOT NULL`       |
| `UNIQUE`      | Duplicate values aren't allowed | `email TEXT UNIQUE`        |
| `PRIMARY KEY` | Unique row identifier           | `id INT PRIMARY KEY`       |
| `DEFAULT`     | Provides fallback value         | `created_at DEFAULT NOW()` |
| `CHECK`       | Value must satisfy condition    | `age CHECK (age >= 18)`    |

---

# 30. NOT NULL vs UNIQUE

These are easy to confuse.

### NOT NULL

Asks:

> **"Must a value exist?"**

```sql id="q5m8v2"
email TEXT NOT NULL
```

The email cannot be missing.

### UNIQUE

Asks:

> **"Can two rows have the same value?"**

```sql id="x7r3k9"
email TEXT UNIQUE
```

Duplicate values are not allowed.

They solve different problems.

---

# 31. UNIQUE vs PRIMARY KEY

A `PRIMARY KEY` is more than just a unique value.

The source describes it as:

```text id="m4q8x2"
PRIMARY KEY
    =
NOT NULL + UNIQUE
```

So:

```text id="j7v3p5"
UNIQUE
→ prevents duplicates

PRIMARY KEY
→ prevents duplicates
→ cannot be NULL
→ identifies the row
```

---

# 32. DEFAULT vs CHECK

These also solve different problems.

### DEFAULT

Provides a value when one isn't supplied.

```sql id="c8m2x6"
created_at TIMESTAMP DEFAULT NOW()
```

### CHECK

Validates a supplied value against a condition.

```sql id="v4q7m9"
age INT CHECK (age >= 18)
```

Think:

```text id="n6x3k8"
DEFAULT → "What should I use if nothing is provided?"

CHECK   → "Is the provided value valid?"
```

---

# 33. Common Mistakes / Gotchas

## 1. Thinking constraints are optional suggestions

They are rules enforced by the database.

If an `INSERT` violates a constraint, PostgreSQL rejects it.

---

## 2. Confusing NULL with an empty value

`NULL` represents missing/unknown data.

`NOT NULL` specifically prevents `NULL`.

---

## 3. Forgetting that UNIQUE prevents duplicates

For example:

```sql id="t8m4q1"
email TEXT UNIQUE
```

means you cannot store the same email value multiple times under that constraint.

---

## 4. Forgetting that PRIMARY KEY combines uniqueness and non-nullability

Remember:

```text id="r5x8m2"
PRIMARY KEY
=
UNIQUE + NOT NULL
```

---

## 5. Manually providing SERIAL IDs unnecessarily

If:

```sql id="p3k7v9"
id SERIAL
```

the database can generate the ID automatically.

---

## 6. Thinking DEFAULT validates a value

`DEFAULT` supplies a value when one isn't provided.

It is not the same as `CHECK`.

---

## 7. Ignoring constraint errors

An error caused by a constraint usually means:

> **The database successfully prevented invalid data from being stored.**

You should investigate why the value violates the rule rather than simply trying to bypass the constraint.

---

# 34. Complete Example

Here's a practical table combining all the concepts:

```sql id="z8m3q5"
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username TEXT NOT NULL UNIQUE,
    age INT CHECK (age >= 18),
    created_at TIMESTAMP DEFAULT NOW()
);
```

### What each part does

```text id="f4k7x2"
id
↓
SERIAL
↓
Automatically generated ID

PRIMARY KEY
↓
Unique + NOT NULL


username
↓
NOT NULL
↓
Must be provided

UNIQUE
↓
Cannot be duplicated


age
↓
CHECK (age >= 18)
↓
Must be 18 or older


created_at
↓
DEFAULT NOW()
↓
Automatically gets current timestamp
```

---

# 35. Key Takeaways

* **Constraints are rules applied to database columns.**
* Their purpose is to maintain **accuracy, consistency, and reliability**.
* `NOT NULL` prevents `NULL` values.
* `UNIQUE` prevents duplicate values.
* `PRIMARY KEY` uniquely identifies each row and combines the ideas of `NOT NULL` and `UNIQUE`.
* A table typically has one primary key.
* `DEFAULT` provides a fallback value when no value is supplied.
* `DEFAULT NOW()` can automatically store the current date and time when a row is created.
* `CHECK` validates a value against a condition.
* `CHECK (age >= 18)` only allows ages satisfying that condition.
* `SERIAL` columns can automatically generate IDs, so you don't need to manually provide them during insertion.
* When a constraint is violated, PostgreSQL returns an error and rejects the invalid operation.
* Constraint errors are an important **data-protection mechanism**.
* Constraints are one of the primary ways to keep a database clean and reliable.

---

# 36. One-Minute Revision

```text id="q3m8v5"
NOT NULL
→ Value must exist

UNIQUE
→ No duplicate values

PRIMARY KEY
→ Unique row identifier
→ NOT NULL + UNIQUE

DEFAULT
→ Automatic fallback value

DEFAULT NOW()
→ Current date/time automatically

CHECK
→ Value must satisfy a condition

SERIAL
→ Auto-generated integer ID
```

The core mental model:

```text id="v7x2k9"
                  INSERT
                     │
                     ↓
             Constraint Checks
                     │
        ┌────────────┴────────────┐
        ↓                         ↓
   Valid data                Invalid data
        ↓                         ↓
     Stored                    ERROR
```

> **Constraints are the database's built-in rules for protecting data integrity.**

---

# 37. Minimal Self-Test

1. What is a SQL constraint?
2. Why do we need constraints?
3. What does `NOT NULL` do?
4. What does `UNIQUE` do?
5. What is a primary key?
6. Why is a primary key described as `NOT NULL + UNIQUE`?
7. How many primary keys can a table typically have?
8. What is the purpose of `DEFAULT`?
9. What does `DEFAULT NOW()` do?
10. What is a `CHECK` constraint?
11. What does `CHECK (age >= 18)` mean?
12. What happens when an `INSERT` violates a constraint?
13. Why is a constraint error actually useful?
14. What is the difference between `NOT NULL` and `UNIQUE`?
15. What is the difference between `DEFAULT` and `CHECK`?
16. Why don't you normally provide a value for a `SERIAL` ID?
17. Write a table definition containing:

    * `SERIAL PRIMARY KEY`
    * `NOT NULL`
    * `UNIQUE`
    * `DEFAULT NOW()`
    * `CHECK`

---

# 38. What to Learn Next

Now that you understand:

```text id="k5x9m3"
Data Types
     ↓
Constraints
     ↓
Valid Table Structure
```

the next logical step is learning **SQL Clauses**.

That will move you from defining and protecting data to actually **filtering, sorting, grouping, and analyzing it** using clauses such as:

```text id="r8m2q6"
SELECT
FROM
WHERE
GROUP BY
HAVING
ORDER BY
LIMIT
DISTINCT
```
