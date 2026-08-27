# Many-to-Many Relationships in SQL

## What it is

A **Many-to-Many (M:N) relationship** occurs when:

* One record in **Table A** can be related to many records in **Table B**.
* At the same time, one record in **Table B** can be related to many records in **Table A**.

### Example: Students and Courses

A student can take multiple courses:

```text
Student A
   ├── Java
   ├── SQL
   └── Python
```

And a course can have multiple students:

```text
SQL
├── Student A
├── Student B
└── Student C
```

Therefore:

```text
Students  ←──── Many-to-Many ────→  Courses
```

---

## One-Sentence Summary

> **A many-to-many relationship is implemented using a third table, called a junction/bridge table, that connects records from the two parent tables using foreign keys.**

---

# 1. Understanding the Problem

Suppose we have two tables:

### Students

| student_id | name   |
| ---------: | ------ |
|          1 | Akarsh |
|          2 | Anjali |
|          3 | Rahul  |

### Courses

| course_id | course_name |
| --------: | ----------- |
|       101 | Java        |
|       102 | SQL         |
|       103 | Python      |

Now consider:

* Akarsh takes Java and SQL.
* Anjali takes SQL and Python.
* Rahul takes Java and Python.

A single student can therefore have **multiple courses**.

At the same time, a single course can have **multiple students**.

That is a **many-to-many relationship**.

---

# 2. Why Can't We Directly Implement It Using Two Tables?

A relational database cannot cleanly represent this relationship using only the two tables.

One possible but bad approach would be storing multiple course IDs inside the student table:

| student_id | name   | courses  |
| ---------: | ------ | -------- |
|          1 | Akarsh | 101, 102 |
|          2 | Anjali | 102, 103 |
|          3 | Rahul  | 101, 103 |

This creates problems because multiple values are being stored inside a single field.

Another approach could be duplicating student records:

| student_id | name   | course_id |
| ---------: | ------ | --------: |
|          1 | Akarsh |       101 |
|          1 | Akarsh |       102 |
|          2 | Anjali |       102 |
|          2 | Anjali |       103 |

Now student information is repeated.

With a large database, this can lead to significant **data duplication** and make the schema difficult to maintain.

So we need another solution.

---

# 3. The Solution: Junction / Bridge Table

The standard solution is to introduce a **third table**.

This table is called a:

* **Junction table**
* **Bridge table**
* **Associative table**

For our example, we can call it:

```text
Enrollments
```

The overall structure becomes:

```text
┌────────────┐
│  Students  │
└─────┬──────┘
      │
      │ student_id
      │
      ▼
┌────────────┐
│ Enrollments│
└─────┬──────┘
      │
      │ course_id
      │
      ▼
┌────────────┐
│  Courses   │
└────────────┘
```

The `Enrollments` table acts as the bridge between `Students` and `Courses`.

---

# 4. Structure of the Junction Table

The junction table contains the information needed to establish the relationship.

For example:

### Enrollments

| enrollment_id | student_id | course_id |
| ------------: | ---------: | --------: |
|             1 |          1 |       101 |
|             2 |          1 |       102 |
|             3 |          2 |       102 |
|             4 |          2 |       103 |
|             5 |          3 |       101 |
|             6 |          3 |       103 |

Here:

* `enrollment_id` → Primary Key
* `student_id` → Foreign Key
* `course_id` → Foreign Key

---

# 5. Primary Key in the Junction Table

The junction table can have its own primary key.

For example:

```text
enrollment_id
```

This uniquely identifies each enrollment record.

Conceptually:

```text
Enrollments
│
├── enrollment_id → PRIMARY KEY
├── student_id    → FOREIGN KEY
└── course_id     → FOREIGN KEY
```

---

# 6. Foreign Keys in the Junction Table

The junction table contains **two foreign keys**.

### `student_id`

References:

```text
Students(student_id)
```

### `course_id`

References:

```text
Courses(course_id)
```

So:

```text
Students
   │
   │ student_id
   ▼
Enrollments
   ▲
   │ course_id
   │
Courses
```

These foreign keys establish the relationships between the three tables.

---

# 7. How the Relationship Actually Works

Suppose we have:

### Students

| student_id | name   |
| ---------: | ------ |
|          1 | Akarsh |
|          2 | Anjali |

### Courses

| course_id | course_name |
| --------: | ----------- |
|       101 | Java        |
|       102 | SQL         |

### Enrollments

| enrollment_id | student_id | course_id |
| ------------: | ---------: | --------: |
|             1 |          1 |       101 |
|             2 |          1 |       102 |
|             3 |          2 |       102 |

Read the enrollment table:

```text
Akarsh → Java
Akarsh → SQL
Anjali → SQL
```

Therefore:

```text
Akarsh
 ├── Java
 └── SQL

Anjali
 └── SQL
```

And from the course's perspective:

```text
Java
 └── Akarsh

SQL
 ├── Akarsh
 └── Anjali
```

This gives us the many-to-many relationship.

---

# 8. Implementation Workflow

The implementation follows three main steps.

## Step 1: Create the Parent Tables

Create the independent entities first.

```text
Students
Courses
```

For example:

```sql
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name TEXT
);
```

```sql
CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name TEXT
);
```

The source material emphasizes defining the independent data in these parent tables first.

---

## Step 2: Create and Populate the Junction Table

Create the table that stores the relationship.

Conceptually:

```sql
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT
);
```

The important idea is that the junction table stores **IDs**, not duplicated student and course information.

For example:

```text
student_id = 1
course_id  = 102
```

means:

> Student 1 is associated with Course 102.

---

## Step 3: Use JOIN to Retrieve Meaningful Information

The junction table contains IDs, so we can use `JOIN` to retrieve the actual names.

Conceptually:

```text
Students
    ↓
Enrollments
    ↓
Courses
```

For example, we may want:

> "Show all students enrolled in SQL."

The database can join the three tables and produce:

| Student | Course |
| ------- | ------ |
| Akarsh  | SQL    |
| Anjali  | SQL    |

The important point is:

> **The junction table stores the relationship; JOINs allow us to retrieve useful information from that relationship.**

---

# 9. Why the Junction Table Is Important

Without a junction table, we would have to duplicate information or store multiple values in a single field.

With a junction table:

```text
Students
   │
   │
   ▼
Enrollments
   │
   │
   ▼
Courses
```

Each table has a clear responsibility:

| Table         | Responsibility                          |
| ------------- | --------------------------------------- |
| `Students`    | Stores student information              |
| `Courses`     | Stores course information               |
| `Enrollments` | Stores which student takes which course |

This keeps the database organized.

---

# 10. Avoiding Data Duplication

Suppose Akarsh takes 5 courses.

We don't need to store Akarsh's name five times.

Instead:

```text
Students
1 | Akarsh
```

And the enrollment table stores the relationships:

```text
Enrollments

student_id | course_id
-----------|----------
1          | 101
1          | 102
1          | 103
1          | 104
1          | 105
```

The student's information exists only once.

This is one of the major benefits of the junction-table approach.

---

# 11. Real-World Examples

Many-to-many relationships appear frequently in real applications.

### Students ↔ Courses

```text
Student can take many courses
Course can have many students
```

Use:

```text
Students
Courses
Enrollments
```

### Users ↔ Roles

```text
User can have many roles
Role can belong to many users
```

Use:

```text
Users
Roles
User_Roles
```

### Products ↔ Orders

Depending on the data model:

```text
An order can contain many products
A product can appear in many orders
```

A junction/order-item table can represent the relationship:

```text
Orders
Products
Order_Items
```

The source specifically uses **Students, Courses, and Enrollments** as the main example.

---

# 12. Many-to-Many Relationship Diagram

A useful mental model:

```text
              MANY
Students ───────────────► Courses
   │                         ▲
   │                         │
   │                         │
   └────── Enrollments ─────┘
             │
             │
       Junction Table
```

More precisely:

```text
Students                    Courses
┌──────────────┐           ┌──────────────┐
│ student_id PK│           │ course_id PK │
│ name         │           │ course_name  │
└──────┬───────┘           └──────▲───────┘
       │                          │
       │ 1                        │ 1
       │                          │
       │      MANY                │
       └───────┐     ┌────────────┘
               ▼     ▼
          ┌──────────────┐
          │ Enrollments  │
          ├──────────────┤
          │ enrollment_id│
          │ student_id FK│
          │ course_id FK │
          └──────────────┘
```

The two many-to-one relationships created through the junction table together represent the original many-to-many relationship.

---

# 13. Important Interview Concept

A common interview question is:

> **How do you implement a many-to-many relationship in a relational database?**

### Answer

Use a **junction/bridge table** between the two entities.

The junction table contains:

1. Its own primary key, if desired/used by the design.
2. A foreign key referencing the first table.
3. A foreign key referencing the second table.

Example:

```text
Students
   ↓
Enrollments
   ↓
Courses
```

This avoids unnecessary duplication and maintains relationships through foreign keys.

---

# 14. One-to-Many vs Many-to-Many

| Relationship | Example                   | Tables Required |
| ------------ | ------------------------- | --------------: |
| One-to-One   | Student ↔ Student Profile |               2 |
| One-to-Many  | Student ↔ Marks           |               2 |
| Many-to-Many | Student ↔ Course          |               3 |

### One-to-Many

One student can have many marks:

```text
Student 1
   ├── Mark 1
   ├── Mark 2
   └── Mark 3
```

A foreign key in the child table is enough.

### Many-to-Many

One student can have many courses **and** one course can have many students:

```text
Student 1 ── Course 1
          ├─ Course 2

Student 2 ── Course 1
          └─ Course 3
```

A junction table is required.

---

# 15. Common Mistakes / Gotchas

### Mistake 1: Trying to store multiple IDs in one column

Avoid designs such as:

```text
student_id | course_ids
-----------|-----------
1          | 101,102,103
```

The relationship should instead be represented using separate rows in the junction table.

---

### Mistake 2: Duplicating parent information

Avoid:

```text
student_id | student_name | course
-----------|--------------|-------
1          | Akarsh       | Java
1          | Akarsh       | SQL
1          | Akarsh       | Python
```

Student information is unnecessarily repeated.

Instead:

```text
Students
1 | Akarsh
```

and:

```text
Enrollments
1 | 101
1 | 102
1 | 103
```

---

### Mistake 3: Forgetting the foreign keys

The junction table should connect back to both parent tables.

```text
student_id → Students.student_id
course_id  → Courses.course_id
```

Without these relationships, the database cannot properly enforce referential integrity.

---

### Mistake 4: Thinking the junction table stores duplicated data

The purpose of the junction table is actually the opposite.

It stores the **relationship between entities**, usually using IDs, instead of duplicating the entities themselves.

---

# 16. Key Takeaways

* **Many-to-many** means many records on one side can relate to many records on the other side.
* Example: **Students ↔ Courses**.
* A student can take many courses.
* A course can have many students.
* A many-to-many relationship is not directly represented cleanly using only two relational tables.
* Use a **third table** called a:

  * Junction table
  * Bridge table
  * Associative table
* Example:

```text
Students
   ↓
Enrollments
   ↓
Courses
```

* The junction table contains foreign keys to both parent tables.
* It can also have its own primary key such as `enrollment_id`.
* Parent tables contain the actual entity information.
* The junction table stores the **mapping/relationship**.
* `JOIN` queries can combine all three tables to generate useful reports.
* This design reduces duplication and supports normalized database structures.
* It is an industry-standard approach for modeling many-to-many relationships.

---

# Minimal Self-Test

1. What is a many-to-many relationship?
2. Give a real-world example of an M:N relationship.
3. Why can't a many-to-many relationship be cleanly represented using only two relational tables?
4. What is a junction table?
5. What is another name for a junction table?
6. What columns would an `enrollments` table typically contain?
7. Why does a junction table need two foreign keys?
8. What does `student_id` reference in the `enrollments` table?
9. What does `course_id` reference?
10. How does a junction table reduce data duplication?
11. How would you retrieve all students enrolled in a particular course?
12. What is the difference between one-to-many and many-to-many relationships?
13. Why are `JOIN`s important when working with a junction table?

---

# What to Learn Next

The natural next step after many-to-many relationships is **advanced SQL JOINs**, especially:

```text
INNER JOIN
LEFT JOIN
RIGHT JOIN
FULL OUTER JOIN
SELF JOIN
```

Then practice joining **three tables**, because that is where many-to-many relationships become especially useful in real SQL queries.
