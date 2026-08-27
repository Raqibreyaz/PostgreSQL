# SQL Relationships and Joins

## What it is

In a **relational database**, data is usually not stored in one huge table.

Instead, related information is divided into **multiple tables**. These tables are connected through **relationships** based on common data fields.

For example:

```text
Students Table          Courses Table
───────────────         ──────────────
student_id  ─────────→  student_id
name                    course
age                     marks
```

Because the tables are related, SQL can combine information from both tables when needed.

### One-sentence summary

> **Relationships connect related tables through common data, while JOINs allow us to retrieve and combine that related data in a query.**

---

# 1. Why Do We Need Multiple Tables?

Imagine a student database.

You could put everything into one massive table:

```text
student_id
student_name
age
course
course_teacher
teacher_phone
course_fee
...
```

This can become difficult to manage.

Instead, related information can be separated:

```text
Students
──────────────
student_id
name
age


Courses
──────────────
course_id
course_name
teacher
fee
```

This organization keeps each table focused on a particular type of information.

---

# 2. What Is a Relationship?

A **relationship** is a connection between two or more tables.

The connection is established by identifying some **common element/data field** between the tables.

For example:

```text
Students
────────────────
student_id
name
age

Orders
────────────────
order_id
student_id
product
```

Both tables contain:

```text
student_id
```

This common field can be used to establish a relationship between them.

Conceptually:

```text
Students                  Orders
─────────                 ──────
student_id  ───────────→  student_id
name                      order_id
age                       product
```

Now SQL can use information from both tables.

---

# 3. Real-World Analogy

The instructor compares database relationships to **human relationships**.

Two people can have a connection because they share something in common.

Similarly, two database tables can be connected because they contain related/common data.

```text
Human relationship
       ↓
Shared/common connection
       ↓
Database relationship
       ↓
Common/related data between tables
```

The important idea is:

> **Tables don't need to contain all the same information. They only need a meaningful connection through related data.**

---

# 4. Why Not Keep Everything in One Table?

A database could theoretically store everything in one large table, but relational databases organize information into smaller, specialized tables.

For example:

```text
        Database
           │
     ┌─────┴─────┐
     ↓           ↓
 Students      Courses
     │           │
     └─────┬─────┘
           ↓
       Relationship
```

This approach is part of **normalization**.

### Normalization

Normalization means organizing data into smaller, logical tables rather than repeatedly storing the same information everywhere.

The source highlights this strategy because it helps maintain:

* **Efficiency**
* **Data integrity**
* Better organization

---

# 5. Example of the Problem with One Huge Table

Suppose a student takes multiple courses.

A single-table design might look like:

| student_id | student_name | course |
| ---------: | ------------ | ------ |
|          1 | Akarsh       | SQL    |
|          1 | Akarsh       | Java   |
|          1 | Akarsh       | Python |

Notice that:

```text
Akarsh
```

is repeated multiple times.

If more student information exists, such as age, email, address, etc., that information may also be repeatedly stored.

Instead, we can separate the information:

### Students

| student_id | name   |
| ---------: | ------ |
|          1 | Akarsh |

### Courses/Enrollment

| student_id | course |
| ---------: | ------ |
|          1 | SQL    |
|          1 | Java   |
|          1 | Python |

The `student_id` provides the connection.

---

# 6. What Are Joins?

Once tables have relationships, we need a way to **retrieve data from those related tables together**.

This is where **JOINs** come in.

A JOIN allows SQL to combine related rows from multiple tables.

Conceptually:

```text
Table A
   │
   │ relationship
   ↓
 JOIN
   ↑
   │ relationship
Table B
   │
   ↓
Combined result
```

For example, suppose we have:

### Students

| student_id | name   |
| ---------: | ------ |
|          1 | Akarsh |
|          2 | Anjali |

### Marks

| student_id | marks |
| ---------: | ----: |
|          1 |    90 |
|          2 |    85 |

The common field is:

```text
student_id
```

A JOIN can combine them into:

| student_id | name   | marks |
| ---------: | ------ | ----: |
|          1 | Akarsh |    90 |
|          2 | Anjali |    85 |

Now we can see both the student's name and their marks.

---

# 7. Relationship vs JOIN

These two concepts are related but should not be confused.

### Relationship

Describes the **connection between tables**.

```text
Students.student_id
        ↕
Marks.student_id
```

### JOIN

Is the SQL operation used to **retrieve related data from those tables**.

```sql
SELECT ...
FROM students
JOIN marks
ON students.student_id = marks.student_id;
```

So:

```text
Relationship
     ↓
Tables are logically connected

JOIN
     ↓
SQL uses that connection to combine data
```

---

# 8. Why Relationships Matter

Relationships allow databases to keep information organized while still making it possible to work with the information together.

Without relationships, separating data into different tables would make it difficult to connect the information.

With relationships:

```text
Specialized tables
       ↓
Related through common data
       ↓
JOIN
       ↓
Combined information
```

This gives us both:

* **Organized storage**
* **Combined querying**

---

# 9. Example: Products and Categories

Consider a product system.

Instead of storing everything repeatedly:

### Products

| product_id | name      | category_id |
| ---------: | --------- | ----------: |
|          1 | Laptop    |          10 |
|          2 | Mouse     |          10 |
|          3 | Treadmill |          20 |

### Categories

| category_id | category_name |
| ----------: | ------------- |
|          10 | Electronics   |
|          20 | Fitness       |

The common field is:

```text
category_id
```

This creates the relationship:

```text
Products                    Categories
────────────                ─────────────
category_id ─────────────→  category_id
```

A JOIN can then be used to retrieve:

```text
Product name + Category name
```

For example:

| name      | category_name |
| --------- | ------------- |
| Laptop    | Electronics   |
| Mouse     | Electronics   |
| Treadmill | Fitness       |

---

# 10. Data Organization Strategy

The main strategy discussed in this section is:

> **Don't put everything into one massive table.**

Instead:

```text
Massive table
     ↓
Break into logical/specialized tables
     ↓
Create relationships between them
     ↓
Use JOINs when information needs to be combined
```

For example:

```text
                    Database
                       │
       ┌───────────────┼───────────────┐
       ↓               ↓               ↓
    Students         Courses         Products
       │               │               │
       └───────────────┴───────────────┘
                Relationships
                       ↓
                    JOINs
```

This structure helps maintain efficiency and data integrity.

---

# 11. Important Terminology

| Term                    | Meaning                                                                           |
| ----------------------- | --------------------------------------------------------------------------------- |
| **Relational Database** | A database where data is organized into related tables                            |
| **Table**               | A structured collection of rows and columns                                       |
| **Relationship**        | A logical connection between tables                                               |
| **Common Field**        | Related data used to connect tables                                               |
| **JOIN**                | SQL operation used to combine related data from tables                            |
| **Normalization**       | Organizing data into smaller, specialized tables to reduce unnecessary repetition |

---

# 12. Key Takeaways

* Relational databases store data across **multiple tables**.
* Tables can be connected through **relationships**.
* Relationships are established using **common/related data fields**.
* Related tables can be queried together.
* **JOINs** are used to retrieve and combine related data.
* A relationship is the **logical connection**.
* A JOIN is the **SQL operation that uses that connection**.
* Keeping everything in one massive table can lead to unnecessary repetition and poor organization.
* Data is instead divided into **smaller, specialized tables**.
* This organization is related to **normalization**.
* The main benefits are improved **efficiency** and **data integrity**.

---

# 13. Minimal Self-Test

1. What is a relational database?
2. Why is data divided into multiple tables?
3. What is a relationship between two tables?
4. How can two tables be connected?
5. Why do we need JOINs?
6. What is the difference between a relationship and a JOIN?
7. What is normalization?
8. Why is storing everything in one massive table generally undesirable?
9. Give an example of two tables that could share a common field.
10. If `students` and `marks` both contain `student_id`, how could that field help connect the tables?
11. What are the two main benefits of organizing data into specialized related tables?
12. Draw the flow:

```text
Multiple Tables
      ↓
Relationships
      ↓
JOIN
      ↓
Combined Data
```

# 14. What to Learn Next

The natural next step is to learn the different types of SQL JOINs:

```text
JOINs
 │
 ├── INNER JOIN
 ├── LEFT JOIN
 ├── RIGHT JOIN
 └── FULL OUTER JOIN
```

These determine **which rows are included when combining related tables**.
