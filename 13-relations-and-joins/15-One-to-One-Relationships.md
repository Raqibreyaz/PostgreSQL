# One-to-One Relationships in SQL

## What it is

A **One-to-One (1:1) relationship** exists when **one record in one table is associated with exactly one record in another table**.

For example, suppose we have:

### Students

| student_id | name   |
| ---------: | ------ |
|          1 | Akarsh |
|          2 | Anjali |

### Student Details

| student_id | phone      | address |
| ---------: | ---------- | ------- |
|          1 | 9876543210 | Delhi   |
|          2 | 9123456780 | Mumbai  |

Each student has exactly one corresponding record in `student_details`.

```text
Students                    Student Details
────────────                ───────────────
student_id  ─────────────→  student_id
name                        phone
                            address
```

This is a **One-to-One relationship**.

---

# 1. One-Sentence Summary

> **A One-to-One relationship connects one record in one table to exactly one record in another table, typically using a foreign key that references a primary key.**

---

# 2. Intuition

Think about a person and their passport.

```text
One Person
    │
    │
    └────────→ One Passport
```

One person is associated with one passport record.

Similarly, in a database:

```text
One Student
    │
    │
    └────────→ One Student Profile
```

The two pieces of information can be stored in separate tables while still being connected.

---

# 3. Why Use Two Tables?

Suppose we have student information:

```text
student_id
name
age
phone
address
```

Instead of putting everything into one table, we could separate the information:

### Students

```text
student_id
name
age
```

### Student Details

```text
student_id
phone
address
```

This keeps the information organized into specialized tables.

```text
Students
──────────────
student_id
name
age

        +
        │ relationship
        ↓

Student Details
──────────────
student_id
phone
address
```

The source emphasizes that this is useful for understanding **database normalization**, although One-to-One relationships are not as common in real-world applications as One-to-Many relationships.

---

# 4. Creating the Two Tables

Initially, the tables can exist independently.

For example:

```text
Students
────────────────
student_id
name
age
```

and:

```text
Student Details
────────────────
student_id
phone
address
```

At this point, simply having a column with the same name does not automatically establish a formal database relationship.

A relationship needs to be explicitly defined.

---

# 5. Primary Key

The main table contains a **Primary Key**.

For example:

```sql
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    name TEXT,
    age INT
);
```

Here:

```text
student_id
```

uniquely identifies each student.

Conceptually:

```text
Students
────────────────
student_id ← Primary Key
name
age
```

---

# 6. Foreign Key

To formally connect the second table to the first table, we introduce a **Foreign Key**.

The foreign key is a column whose values refer to the primary key of another table.

For example:

```text
Students                    Student Details
────────────                ───────────────
student_id ← PK ─────────→ student_id ← FK
name                        phone
age                         address
```

The foreign key creates a formal bridge between the tables.

---

# 7. Adding the Foreign Key with ALTER TABLE

The source demonstrates creating the relationship on an existing table using `ALTER TABLE`.

General syntax:

```sql
ALTER TABLE table_name
ADD CONSTRAINT constraint_name
FOREIGN KEY (column_name)
REFERENCES target_table (target_column);
```

For example:

```sql
ALTER TABLE student_details
ADD CONSTRAINT fk_student
FOREIGN KEY (student_id)
REFERENCES students (student_id);
```

This tells PostgreSQL:

> `student_details.student_id` references `students.student_id`.

---

# 8. Breaking Down the Syntax

Consider:

```sql
ALTER TABLE student_details
ADD CONSTRAINT fk_student
FOREIGN KEY (student_id)
REFERENCES students (student_id);
```

### `ALTER TABLE`

Specifies which existing table we are modifying.

```text
student_details
```

### `ADD CONSTRAINT`

Adds a new rule to the table.

```text
fk_student
```

is the name given to the constraint.

### `FOREIGN KEY`

Specifies that this constraint is a foreign-key relationship.

```text
FOREIGN KEY (student_id)
```

means the `student_id` column in `student_details` is the foreign key.

### `REFERENCES`

Specifies the table and column being referenced.

```text
REFERENCES students (student_id)
```

So the complete relationship becomes:

```text
student_details.student_id
          │
          │ Foreign Key
          ↓
students.student_id
          │
          │ Primary Key
```

---

# 9. Why the Foreign Key Matters

The foreign key is not just a label saying that two columns are related.

It establishes a **database constraint** that helps maintain data integrity.

The secondary table is now formally connected to the primary table.

Conceptually:

```text
Primary Table
Students
    │
    │ Primary Key
    ↓
student_id
    ↑
    │ Foreign Key
    │
Student Details
```

This prevents the relationship from being merely an informal convention in application code.

---

# 10. Retrieving Data from Both Tables

Once the relationship has been established, SQL can retrieve information from both tables together.

For example, suppose:

### Students

| student_id | name   |
| ---------: | ------ |
|          1 | Akarsh |
|          2 | Anjali |

### Student Details

| student_id | phone      | address |
| ---------: | ---------- | ------- |
|          1 | 9876543210 | Delhi   |
|          2 | 9123456780 | Mumbai  |

The related data can be combined to produce:

| name   | phone      | address |
| ------ | ---------- | ------- |
| Akarsh | 9876543210 | Delhi   |
| Anjali | 9123456780 | Mumbai  |

The relationship allows SQL to connect the records using `student_id`.

Conceptually:

```text
Students
    │
    │ student_id
    ↓
Relationship
    ↑
    │ student_id
Student Details
    │
    ↓
Combined Result
```

The actual SQL JOIN syntax will be covered in more detail when studying JOIN types.

---

# 11. Complete Example

### Main table

```sql
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    name TEXT,
    age INT
);
```

### Secondary table

```sql
CREATE TABLE student_details (
    student_id INT,
    phone TEXT,
    address TEXT
);
```

At this stage, the tables exist separately.

Now establish the relationship:

```sql
ALTER TABLE student_details
ADD CONSTRAINT fk_student
FOREIGN KEY (student_id)
REFERENCES students (student_id);
```

The resulting structure is:

```text
                 One-to-One Relationship

┌─────────────────────┐
│      students       │
├─────────────────────┤
│ student_id  PK      │
│ name                │
│ age                 │
└──────────┬──────────┘
           │
           │ referenced by
           │
           ▼
┌─────────────────────┐
│   student_details   │
├─────────────────────┤
│ student_id  FK      │
│ phone               │
│ address             │
└─────────────────────┘
```

---

# 12. Important Relationship Terminology

| Term                  | Meaning                                                       |
| --------------------- | ------------------------------------------------------------- |
| **Primary Key (PK)**  | Uniquely identifies a record in a table                       |
| **Foreign Key (FK)**  | Column that references a key in another table                 |
| **Referenced Table**  | The table containing the key being referenced                 |
| **Referencing Table** | The table containing the foreign key                          |
| **Constraint**        | A rule enforced by the database                               |
| **One-to-One**        | One record corresponds to exactly one record in another table |

---

# 13. One-to-One Relationship Flow

Remember the process:

```text
1. Create Table A
       ↓
2. Create Table B
       ↓
3. Give Table A a Primary Key
       ↓
4. Add corresponding column to Table B
       ↓
5. Make that column a Foreign Key
       ↓
6. Reference Table A's Primary Key
       ↓
7. Tables are formally related
       ↓
8. JOIN can retrieve related information
```

---

# 14. Relationship Before and After

### Before the relationship

```text
Students                    Student Details

student_id                  student_id
name                        phone
age                         address

    No formal connection
```

### After adding the foreign key

```text
Students                    Student Details
────────                    ───────────────
student_id  ←────────────── student_id
   PK                           FK
name                         phone
age                          address
```

Now the database knows that the two columns are related.

---

# 15. One-to-One vs One-to-Many

The source makes an important observation:

> **One-to-One relationships are used less frequently in real-world scenarios compared with One-to-Many relationships.**

### One-to-One

```text
Student 1 ─────── 1 Student Profile
```

One student has one profile.

### One-to-Many

```text
Student 1 ─────── * Courses
```

One student can have multiple courses.

For example:

```text
Akarsh
  │
  ├── SQL
  ├── Java
  └── Python
```

One-to-Many relationships are extremely useful because real-world entities often have multiple related records.

The current module focuses specifically on understanding the **One-to-One** relationship.

---

# 16. Common Mistakes / Gotchas

## 1. Same column name does not automatically create a relationship

Having:

```text
students.student_id
```

and:

```text
student_details.student_id
```

does not by itself create a formal relationship.

You need a foreign-key constraint.

---

## 2. Foreign key points to a key in another table

The relationship follows the pattern:

```text
Foreign Key
     ↓
References
     ↓
Primary Key
```

For example:

```text
student_details.student_id
              ↓
       references
              ↓
students.student_id
```

---

## 3. `ALTER TABLE` changes the structure

The foreign key is added using:

```sql
ALTER TABLE ...
ADD CONSTRAINT ...
```

This is a structural change to the table.

---

## 4. Relationship and JOIN are not the same thing

A relationship defines how tables are connected.

A JOIN is used when you want to retrieve related information from those tables together.

```text
Relationship
     ↓
Defines connection

JOIN
     ↓
Uses connection to retrieve combined data
```

---

## 5. One-to-One is less common

One-to-One relationships are important to understand because they teach the fundamentals of relational database design and normalization.

However, according to the source, they are **less frequently used in real-world scenarios than One-to-Many relationships**.

---

# 17. Key Takeaways

* A **One-to-One relationship** means one record in one table corresponds to exactly one record in another table.
* Data can be separated into two specialized tables.
* The main table usually contains the **Primary Key**.
* The secondary table contains a **Foreign Key** referencing that key.
* `ALTER TABLE` can be used to add the foreign-key constraint to an existing table.
* General syntax:

```sql
ALTER TABLE table_name
ADD CONSTRAINT constraint_name
FOREIGN KEY (column_name)
REFERENCES target_table (target_column);
```

* The foreign key creates a formal bridge between the tables.
* Once tables are related, SQL can retrieve their information together using JOINs.
* One-to-One relationships are useful for understanding normalization.
* In practical systems, **One-to-Many relationships are generally more common** than One-to-One relationships.

---

# 18. Minimal Self-Test

1. What is a One-to-One relationship?
2. Give a real-world example of a One-to-One relationship.
3. Why might we split information into two tables?
4. What is a Primary Key?
5. What is a Foreign Key?
6. Which table normally contains the Primary Key in the example?
7. Which table contains the Foreign Key?
8. What does `REFERENCES` do?
9. Write the general syntax for adding a foreign-key constraint.
10. Why is `ALTER TABLE` used in this example?
11. What is the purpose of the foreign-key constraint?
12. Does having two columns with the same name automatically create a relationship?
13. What is the difference between a relationship and a JOIN?
14. Why are One-to-One relationships less common than One-to-Many relationships?
15. Draw the relationship:

```text
Students
student_id (PK)
     │
     │
     ↓
Student Details
student_id (FK)
```

16. Explain the complete process of creating a One-to-One relationship from two initially independent tables.
