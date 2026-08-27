# SQL ALTER TABLE Command

## What it is

The SQL **`ALTER TABLE`** command is used to modify the **structure (schema)** of an existing table.

It changes how the table is defined rather than directly changing the existing data stored in the table.

You can use `ALTER TABLE` to:

* Add columns.
* Remove columns.
* Rename columns.
* Change column data types.
* Rename the table.
* Set default values.
* Remove default values.
* Add constraints.
* Remove constraints.

### One-sentence summary

> **`ALTER TABLE` lets you change the structure of an existing table without recreating the entire table.**

---

# 1. Intuition

Think of a database table as a form.

Initially, your form might have:

```text
students
────────────────────────
student_id
name
age
```

Later, you realize you also need:

```text
email
```

Instead of deleting the table and creating it again, you can modify its structure:

```sql
ALTER TABLE students
ADD COLUMN email VARCHAR(100);
```

Now the table becomes:

```text
students
────────────────────────
student_id
name
age
email
```

This structural modification is what `ALTER TABLE` is designed for.

---

# 2. What Can ALTER TABLE Do?

The major operations covered in this section are:

```text
ALTER TABLE
    │
    ├── ADD COLUMN
    ├── DROP COLUMN
    ├── RENAME COLUMN
    ├── ALTER COLUMN TYPE
    ├── SET DEFAULT
    ├── DROP DEFAULT
    ├── ADD CONSTRAINT
    ├── DROP CONSTRAINT
    └── RENAME TABLE
```

So `ALTER TABLE` is not a single operation. It is a command used with different clauses to perform different schema changes.

---

# 3. Database and Table Setup

The instructor creates a database called:

```text
new_db
```

The purpose is to have a separate database where table structure modifications can be demonstrated safely.

The instructor then connects to `new_db` using the **`psql` shell**.

---

# 4. Inspecting a Table with `\d`

Inside the PostgreSQL `psql` shell, the command:

```text
\d
```

can be used to inspect database objects and table information.

This is useful when learning `ALTER TABLE` because you can:

```text
Before ALTER
     ↓
Inspect table
     ↓
Run ALTER TABLE
     ↓
Inspect table again
     ↓
Verify structural change
```

For example, after changing a table, you can use `\d` to verify that the new column, data type, or default value has actually been applied.

---

# 5. Initial `students` Table

The demonstration starts with a simple `students` table containing three columns:

```text
students
──────────────────
student_id
name
age
```

This table becomes the starting point for demonstrating different `ALTER TABLE` operations.

---

# 6. Adding a Column

## Purpose

Use `ADD COLUMN` when you need to add a new field to an existing table.

Syntax:

```sql
ALTER TABLE table_name
ADD COLUMN column_name data_type;
```

Example:

```sql
ALTER TABLE students
ADD COLUMN email VARCHAR(100);
```

The table changes from:

```text
Before
────────────────
student_id
name
age
```

to:

```text
After
────────────────
student_id
name
age
email
```

---

## Important Point: Existing Rows

When you add a new column to a table that already contains rows, the existing rows will contain:

```text
NULL
```

for that new column, unless a value/default is otherwise provided.

For example, suppose the table contains:

| student_id | name   | age |
| ---------: | ------ | --: |
|          1 | Akarsh |  21 |
|          2 | Anjali |  22 |

Then:

```sql
ALTER TABLE students
ADD COLUMN email VARCHAR(100);
```

results conceptually in:

| student_id | name   | age | email  |
| ---------: | ------ | --: | ------ |
|          1 | Akarsh |  21 | `NULL` |
|          2 | Anjali |  22 | `NULL` |

The new column exists, but PostgreSQL does not know the email addresses of the existing students.

---

# 7. Dropping a Column

## Purpose

Use `DROP COLUMN` when an existing column is no longer needed.

Syntax:

```sql
ALTER TABLE table_name
DROP COLUMN column_name;
```

Example:

```sql
ALTER TABLE students
DROP COLUMN age;
```

Before:

```text
student_id
name
age
email
```

After:

```text
student_id
name
email
```

The `age` column is removed from the table structure.

---

## Important Idea

`DROP COLUMN` removes the column itself from the table.

So this is a structural change, not merely hiding the column from a query.

If you only want to avoid displaying a column, you don't need `ALTER TABLE`; simply don't include that column in your `SELECT`.

For example:

```sql
SELECT student_id, name
FROM students;
```

does not change the table.

---

# 8. Renaming a Column

Sometimes a column contains the correct data but has a poor or outdated name.

Use:

```sql
ALTER TABLE table_name
RENAME COLUMN old_name TO new_name;
```

Example:

```sql
ALTER TABLE students
RENAME COLUMN name TO student_name;
```

Before:

```text
student_id
name
age
```

After:

```text
student_id
student_name
age
```

The column's name changes, but the purpose of the stored data remains the same.

---

# 9. Changing a Column's Data Type

Sometimes the requirements of a column change.

For example, you may need to change a column from one data type to another.

Syntax:

```sql
ALTER TABLE table_name
ALTER COLUMN column_name
TYPE new_data_type;
```

Example structure:

```sql
ALTER TABLE students
ALTER COLUMN age TYPE new_data_type;
```

The exact new data type depends on the requirement.

---

## Why Change a Data Type?

Suppose a column was originally created with a type that is no longer appropriate.

Changing the type can make the schema better match the data requirements.

Conceptually:

```text
Old requirement
      ↓
Existing data type
      ↓
Requirements change
      ↓
ALTER COLUMN ... TYPE ...
      ↓
New data type
```

The important point is that the operation changes the **column definition**.

---

# 10. Data Consistency When Changing Types

Changing a data type is not something to do blindly.

The existing values must be compatible with the new type.

For example, if existing values cannot be converted to the new data type, PostgreSQL can reject the operation.

Therefore:

> Before changing a column's type, consider the existing data stored in that column.

The source specifically emphasizes that changing the data type helps ensure that the column matches its new requirements and maintains data consistency.

---

# 11. Setting a DEFAULT Value

A default value tells PostgreSQL:

> If an `INSERT` does not provide a value for this column, use this value automatically.

Syntax:

```sql
ALTER TABLE table_name
ALTER COLUMN column_name
SET DEFAULT value;
```

Example:

```sql
ALTER TABLE students
ALTER COLUMN age
SET DEFAULT 18;
```

Now, if a future insertion doesn't specify `age`, PostgreSQL can use:

```text
18
```

as the default.

---

# 12. DEFAULT and Future Inserts

Consider:

```text
students
────────────────────
student_id
name
age
```

Set a default:

```sql
ALTER TABLE students
ALTER COLUMN age
SET DEFAULT 18;
```

Now suppose an insert does not provide an age.

The database can automatically use:

```text
age = 18
```

The important word is **future**.

Setting a default is mainly about what happens when new rows are inserted without a value for that column.

---

# 13. Removing a DEFAULT

The source also identifies removing defaults as one of the operations supported by `ALTER TABLE`.

The corresponding PostgreSQL operation is:

```sql
ALTER TABLE table_name
ALTER COLUMN column_name
DROP DEFAULT;
```

For example:

```sql
ALTER TABLE students
ALTER COLUMN age
DROP DEFAULT;
```

This removes the default value from the column definition.

After that, PostgreSQL will no longer automatically use the previously configured default for future inserts.

---

# 14. Adding Constraints

`ALTER TABLE` can also be used to add constraints to an existing table.

Constraints are rules that protect data integrity.

Examples include:

```text
NOT NULL
UNIQUE
CHECK
```

For example, a table may initially allow:

```text
name = NULL
```

Later, you may decide that every student must have a name.

A constraint can then be added to enforce that requirement.

The important idea is:

> `ALTER TABLE` can modify not only columns, but also the rules applied to those columns.

---

# 15. Removing Constraints

Just as constraints can be added, they can also be removed using `ALTER TABLE`.

This is useful when the database requirements change.

Conceptually:

```text
Requirement changes
       ↓
Existing constraint is no longer appropriate
       ↓
ALTER TABLE
       ↓
Remove constraint
```

The source lists adding and removing constraints as an important use case, including constraints such as:

```text
NOT NULL
UNIQUE
CHECK
```

---

# 16. Renaming the Table

`ALTER TABLE` can also be used to rename an entire table.

The general form is:

```sql
ALTER TABLE old_table_name
RENAME TO new_table_name;
```

For example:

```sql
ALTER TABLE students
RENAME TO student_details;
```

Before:

```text
students
```

After:

```text
student_details
```

The table's name changes, while the table itself is not recreated.

---

# 17. ALTER TABLE vs Data Modification

This distinction is important.

### `ALTER TABLE`

Changes the **structure**.

Examples:

```text
Add column
Remove column
Rename column
Change data type
Set default
Add constraint
```

### `INSERT`, `UPDATE`, `DELETE`

Change the **data**.

```text
INSERT → add rows
UPDATE → modify existing values
DELETE → remove rows
```

Think of it like this:

```text
DATABASE TABLE
      │
      ├── Structure
      │      └── ALTER TABLE
      │
      └── Data
             ├── INSERT
             ├── UPDATE
             └── DELETE
```

---

# 18. Practical Workflow

When modifying a table, a useful workflow is:

```text
1. Inspect existing table
        ↓
2. Decide what structural change is required
        ↓
3. Run ALTER TABLE
        ↓
4. Inspect the table again
        ↓
5. Verify the change
```

Using `psql`, the `\d` command is useful for checking the schema.

---

# 19. Example: Evolving the Students Table

Suppose we start with:

```text
students
────────────────────
student_id
name
age
```

### Step 1 — Add email

```sql
ALTER TABLE students
ADD COLUMN email VARCHAR(100);
```

Now:

```text
student_id
name
age
email
```

---

### Step 2 — Rename name

```sql
ALTER TABLE students
RENAME COLUMN name TO student_name;
```

Now:

```text
student_id
student_name
age
email
```

---

### Step 3 — Change a data type

```sql
ALTER TABLE students
ALTER COLUMN age TYPE ...;
```

The specific type depends on the new requirement.

---

### Step 4 — Set a default

```sql
ALTER TABLE students
ALTER COLUMN age
SET DEFAULT ...;
```

Now future inserts can use the configured default when no value is supplied.

---

### Step 5 — Inspect the schema

Use:

```text
\d
```

in `psql` to verify the updated structure.

---

# 20. Important Gotchas

## 1. Adding a column does not automatically know existing values

When a new column is added, existing rows receive `NULL` unless a value/default is provided.

```text
Existing row
      ↓
New column
      ↓
NULL
```

---

## 2. Dropping a column is a structural removal

```sql
ALTER TABLE students
DROP COLUMN age;
```

does not merely hide `age`.

It removes the column from the table.

---

## 3. Renaming a column affects how you reference it

If you rename:

```text
name
```

to:

```text
student_name
```

queries that refer to the old name need to use the new name.

---

## 4. Be careful when changing data types

Existing data must be compatible with the new type.

Changing a column type without considering existing data can cause the operation to fail or require conversion.

---

## 5. DEFAULT is not the same as updating existing data

Setting:

```sql
ALTER TABLE students
ALTER COLUMN age SET DEFAULT 18;
```

defines what should happen for applicable **future inserts**.

It should not be confused with:

```sql
UPDATE students
SET age = 18;
```

`UPDATE` changes existing rows.

`SET DEFAULT` changes the column's default behavior.

---

# 21. Quick Syntax Cheat Sheet

### Add column

```sql
ALTER TABLE table_name
ADD COLUMN column_name data_type;
```

### Drop column

```sql
ALTER TABLE table_name
DROP COLUMN column_name;
```

### Rename column

```sql
ALTER TABLE table_name
RENAME COLUMN old_name TO new_name;
```

### Change data type

```sql
ALTER TABLE table_name
ALTER COLUMN column_name TYPE new_data_type;
```

### Set default

```sql
ALTER TABLE table_name
ALTER COLUMN column_name SET DEFAULT value;
```

### Remove default

```sql
ALTER TABLE table_name
ALTER COLUMN column_name DROP DEFAULT;
```

### Rename table

```sql
ALTER TABLE old_table_name
RENAME TO new_table_name;
```

### Add constraint

```sql
ALTER TABLE table_name
ADD CONSTRAINT constraint_name ...;
```

### Remove constraint

```sql
ALTER TABLE table_name
DROP CONSTRAINT constraint_name;
```

---

# 22. `ALTER TABLE` Mental Model

Remember the command as:

```text
ALTER TABLE
     │
     ├── ADD      → add something
     ├── DROP     → remove something
     ├── RENAME   → change its name
     ├── ALTER    → change its definition
     └── SET      → configure its behavior
```

For example:

```text
ADD COLUMN
→ Add a new field

DROP COLUMN
→ Remove a field

RENAME COLUMN
→ Change field name

ALTER COLUMN TYPE
→ Change field type

SET DEFAULT
→ Give the field a fallback value
```

---

# 23. Key Takeaways

* `ALTER TABLE` modifies the **structure/schema** of an existing table.
* It is different from `INSERT`, `UPDATE`, and `DELETE`, which primarily operate on data.
* `ADD COLUMN` adds a new field.
* Existing rows generally contain `NULL` for a newly added column when no value/default is supplied.
* `DROP COLUMN` removes a field from the table.
* `RENAME COLUMN` changes a column's name.
* `ALTER COLUMN ... TYPE` changes a column's data type.
* Existing data must be considered when changing a data type.
* `SET DEFAULT` defines a fallback value for future inserts where a value isn't supplied.
* `DROP DEFAULT` removes an existing default.
* `ALTER TABLE` can also add or remove constraints.
* `ALTER TABLE` can rename the entire table.
* PostgreSQL's `psql` shell provides `\d` for inspecting table/schema information.
* Checking the schema before and after an `ALTER TABLE` operation helps verify that the intended structural change occurred.

---

# 24. Minimal Self-Test

1. What is the purpose of `ALTER TABLE`?
2. How is `ALTER TABLE` different from `UPDATE`?
3. How do you add a new column?
4. What happens to the new column for existing rows?
5. How do you remove a column?
6. How do you rename a column?
7. How do you change a column's data type?
8. Why should you check existing data before changing a data type?
9. What does `SET DEFAULT` do?
10. Does setting a default mean existing rows are automatically updated?
11. How do you remove a default?
12. Can `ALTER TABLE` modify constraints?
13. Can `ALTER TABLE` rename a table?
14. What is the purpose of `\d` in `psql`?
15. Write the syntax for adding an `email` column to `students`.
16. Write the syntax for removing the `age` column.
17. Write the syntax for renaming `name` to `student_name`.
18. Explain the difference between `DROP COLUMN` and simply not selecting a column.
19. Explain the difference between `SET DEFAULT` and `UPDATE`.
20. Draw the workflow you would follow before and after making a structural table change.
