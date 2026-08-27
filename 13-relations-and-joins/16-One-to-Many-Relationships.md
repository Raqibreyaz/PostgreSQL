# One-to-Many Relationships in SQL

## What it is

A **One-to-Many (1:N) relationship** exists when **one record in one table is related to multiple records in another table**.

A simple example is a student and their marks:

```text
One Student
    │
    ├────────→ Marks Record 1
    ├────────→ Marks Record 2
    └────────→ Marks Record 3
```

For example, one student can have marks for multiple subjects.

---

## One-sentence summary

> **A One-to-Many relationship allows one parent record to be associated with multiple child records through a primary key–foreign key relationship.**

---

# 1. Intuition

Think about a **student and their marks**.

One student can have:

* English marks
* Mathematics marks
* Science marks

So:

```text
Student
   │
   ├── English
   ├── Mathematics
   └── Science
```

There is **one student**, but **multiple related records**.

This is different from a One-to-One relationship:

```text
One-to-One

Student 1 ─────────→ Profile 1
```

versus:

```text
One-to-Many

Student 1 ─────────→ Mark 1
         ├─────────→ Mark 2
         └─────────→ Mark 3
```

---

# 2. Parent Table and Child Table

A One-to-Many relationship normally involves two tables:

* **Parent table** — contains the main entity.
* **Child table** — contains multiple records related to the parent.

In this example:

```text
Parent Table
    ↓
students

Child Table
    ↓
marks
```

The relationship looks like:

```text
students                         marks
────────                         ─────
student_id (PK) ─────────────→  student_id (FK)
name                             mark_id (PK)
                                 english
                                 math
                                 science
```

---

# 3. The Important Difference from One-to-One

In a One-to-One relationship, a parent's ID corresponds to only one record in the child table.

In a One-to-Many relationship, the parent's ID can appear **multiple times** in the child table.

For example:

### Students

| student_id | name   |
| ---------: | ------ |
|          1 | Akarsh |
|          2 | Anjali |

### Marks

| mark_id | student_id | english | math | science |
| ------: | ---------: | ------: | ---: | ------: |
|     101 |          1 |      85 |   90 |      88 |
|     102 |          1 |      78 |   92 |      84 |
|     103 |          2 |      91 |   87 |      95 |

Notice:

```text
student_id = 1
```

appears multiple times in the `marks` table.

```text
marks
────────────────────────
mark_id   student_id
101          1
102          1
103          2
```

So:

```text
Student 1
   │
   ├── Mark record 101
   └── Mark record 102
```

This is the defining idea of **One-to-Many**.

---

# 4. Creating the Student Table

The parent table contains a unique `student_id`.

For example:

```sql
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name TEXT
);
```

The important part is:

```sql
student_id INT PRIMARY KEY
```

Because `student_id` is a primary key, each student has a unique identifier.

Example:

| student_id | name   |
| ---------: | ------ |
|          1 | Akarsh |
|          2 | Anjali |
|          3 | Rahul  |

---

# 5. Creating the Marks Table

The child table contains:

* `mark_id`
* `student_id`
* Subject-specific columns

For example:

```sql
CREATE TABLE marks (
    mark_id INT PRIMARY KEY,
    student_id INT,
    english INT,
    math INT,
    science INT
);
```

Here:

```text
mark_id
```

uniquely identifies each marks record.

While:

```text
student_id
```

identifies **which student the marks belong to**.

---

# 6. Establishing the Relationship

The `student_id` in the `marks` table becomes a **Foreign Key** referencing `student_id` in the `students` table.

Conceptually:

```text
students                          marks
────────                          ─────
student_id (PK) ───────────────→  student_id (FK)
name                              mark_id (PK)
                                  english
                                  math
                                  science
```

The relationship is:

```text
students.student_id
        │
        │ Primary Key
        ↓
marks.student_id
        │
        │ Foreign Key
        ↓
Multiple marks records
```

---

# 7. Why Can the Foreign Key Appear Multiple Times?

This is one of the most important points.

The **primary key** in the parent table must be unique.

But the **foreign key** in the child table can appear multiple times.

Example:

```text
students
──────────────
student_id
    1
    2
    3
```

The `marks` table can contain:

```text
student_id
──────────
1
1
1
2
2
3
```

This means:

```text
Student 1 → 3 marks records
Student 2 → 2 marks records
Student 3 → 1 marks record
```

Therefore:

> **One parent record can have many child records.**

---

# 8. Practical Data Structure

The source uses a `students` table and a `marks` table.

### Students

```text
students
────────────────
student_id
name
```

Example:

```text
┌────────────┬─────────┐
│ student_id │ name    │
├────────────┼─────────┤
│ 1          │ Akarsh  │
│ 2          │ Anjali  │
└────────────┴─────────┘
```

### Marks

```text
marks
────────────────────────────
mark_id
student_id
english
math
science
```

Example:

```text
┌─────────┬────────────┬─────────┬──────┬─────────┐
│ mark_id │ student_id│ english │ math │ science │
├─────────┼────────────┼─────────┼──────┼─────────┤
│ 101     │ 1          │ 85      │ 90   │ 88      │
│ 102     │ 1          │ 78      │ 92   │ 84      │
│ 103     │ 2          │ 91      │ 87   │ 95      │
└─────────┴────────────┴─────────┴──────┴─────────┘
```

Here, `student_id = 1` appears twice.

Therefore:

```text
Akarsh
  │
  ├── Marks Record 101
  └── Marks Record 102
```

---

# 9. Relationship Diagram

A useful way to remember One-to-Many is:

```text
                ONE
                 │
                 │
                 ▼
        ┌─────────────────┐
        │     students    │
        │─────────────────│
        │ student_id (PK) │
        │ name            │
        └────────┬────────┘
                 │
                 │ student_id
                 │
            ┌────┴────┐
            │         │
            ▼         ▼
        ┌───────┐ ┌───────┐
        │ marks │ │ marks │
        │  101  │ │  102  │
        └───────┘ └───────┘
             MANY
```

The parent has **one record**.

The child can have **many records** associated with it.

---

# 10. Implementation Steps

The process can be remembered as:

```text
1. Create parent table
        ↓
2. Give parent table a Primary Key
        ↓
3. Create child table
        ↓
4. Add the parent's key as a column in child table
        ↓
5. Make it a Foreign Key
        ↓
6. Multiple child rows can reference the same parent
```

For this example:

```text
students
    │
    │ student_id PK
    ↓
marks
    │
    │ student_id FK
    ↓
Multiple records
```

---

# 11. One-to-Many vs One-to-One

| Feature       | One-to-One        | One-to-Many                            |
| ------------- | ----------------- | -------------------------------------- |
| Relationship  | 1 → 1             | 1 → Many                               |
| Parent record | One               | One                                    |
| Child records | One               | Multiple                               |
| Foreign key   | References parent | Can repeat for different child records |
| Example       | Student → Profile | Student → Marks                        |

### One-to-One

```text
Student 1 ─────→ Profile 1
```

### One-to-Many

```text
Student 1 ─────→ Marks 1
         ├─────→ Marks 2
         └─────→ Marks 3
```

The key difference is **how many child records can be associated with one parent**.

---

# 12. Why One-to-Many Is Important

Many real-world relationships naturally follow this pattern.

For example:

```text
Customer → Orders
Teacher  → Students
Department → Employees
Student → Marks
Category → Products
```

The source specifically focuses on:

```text
Student → Marks
```

because one student can have multiple related marks records.

This makes One-to-Many relationships an important part of relational database modeling.

---

# 13. Common Mistakes / Gotchas

## 1. Confusing Primary Key and Foreign Key

In the example:

```text
students.student_id
```

is the **Primary Key**.

```text
marks.student_id
```

is the **Foreign Key**.

Remember:

```text
Parent:
student_id → PK

Child:
student_id → FK
```

---

## 2. Expecting the Foreign Key to be unique

In One-to-Many relationships, the foreign key can appear multiple times.

This is valid:

```text
student_id
──────────
1
1
1
2
2
3
```

Because multiple child records can belong to the same parent.

---

## 3. Confusing One-to-Many with One-to-One

If every student can have only one corresponding record:

```text
Student 1 → Profile 1
```

that is One-to-One.

If a student can have multiple records:

```text
Student 1 → Mark 1
         → Mark 2
         → Mark 3
```

that is One-to-Many.

---

# 14. Core Mental Model

When you see:

```text
Parent
   │
   ├── Child
   ├── Child
   ├── Child
   └── Child
```

think:

> **One-to-Many**

When you see:

```text
Parent
   │
   └── Child
```

with exactly one corresponding child, think:

> **One-to-One**

For SQL tables:

```text
One parent ID
      ↓
Repeated foreign key values
      ↓
Multiple child records
      ↓
One-to-Many relationship
```

---

# 15. Key Takeaways

* **One-to-Many** means one record is related to multiple records.
* The table containing the main entity is the **parent table**.
* The table containing multiple related records is the **child table**.
* The parent table has a **Primary Key**.
* The child table contains a **Foreign Key** referencing the parent's Primary Key.
* Unlike a One-to-One relationship, the foreign key can appear **multiple times** in the child table.
* Example:

```text
students.student_id
        ↓
marks.student_id
```

* One student can therefore have multiple marks records.
* The source's example uses:

  * `students(student_id, name)`
  * `marks(mark_id, student_id, english, math, science)`
* One-to-Many relationships are essential for efficient relational database modeling.

---

# 16. Minimal Self-Test

1. What is a One-to-Many relationship?
2. What is the parent table?
3. What is the child table?
4. In the student-marks example, which table is the parent?
5. Which column connects the two tables?
6. Which table contains the Primary Key?
7. Which table contains the Foreign Key?
8. Can a foreign key appear multiple times in a One-to-Many relationship?
9. Why can `student_id = 1` appear multiple times in the `marks` table?
10. What is the difference between One-to-One and One-to-Many?
11. Draw the relationship between `students` and `marks`.
12. Give two real-world examples of One-to-Many relationships.
13. Explain why `mark_id` is needed in the `marks` table.
14. What does the following structure represent?

```text
Student 1
   ├── Record A
   ├── Record B
   └── Record C
```

15. Explain the complete process of implementing a One-to-Many relationship using a Primary Key and Foreign Key.
