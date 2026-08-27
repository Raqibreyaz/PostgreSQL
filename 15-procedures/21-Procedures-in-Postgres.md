# SQL Stored Procedures

## What it is

A **Stored Procedure** is a collection of SQL statements that is **saved inside the database** and can be executed as a single unit.

It is similar to a **function in programming**.

Instead of repeatedly writing the same SQL logic, you can save that logic as a procedure and execute it whenever needed.

```text
Application
     │
     │ CALL procedure
     ▼
Database
     │
     ├── SQL statement 1
     ├── SQL statement 2
     ├── SQL statement 3
     └── ...
```

---

## One-Sentence Summary

> **A Stored Procedure is reusable SQL logic saved inside the database that can be executed as a single unit, helping automate repetitive tasks and centralize business logic.**

---

# 1. Why Do We Need Stored Procedures?

Imagine an application needs to perform the same sequence of database operations repeatedly.

Without a procedure:

```text
Application
   │
   ├── SQL Query 1
   ├── SQL Query 2
   ├── SQL Query 3
   └── SQL Query 4
```

The application has to send multiple SQL statements to the database.

With a Stored Procedure:

```text
Application
     │
     │ CALL procedure
     ▼
Database
     │
     ├── Query 1
     ├── Query 2
     ├── Query 3
     └── Query 4
```

The logic is already stored in the database.

The application only needs to call the procedure.

---

# 2. Stored Procedure as a Programming Function

A useful mental model is:

```text
Programming Function
        ≈
Stored Procedure
```

For example, in programming you might have:

```text
calculateSalary()
```

and call it whenever required.

Similarly, a database can contain a procedure such as:

```text
processOrder()
```

which contains multiple SQL operations.

The exact implementation can be complex, but the application only needs to call the procedure.

---

# 3. Basic Structure

The source introduces the following general structure:

```sql
CREATE PROCEDURE procedure_name()
BEGIN
    -- SQL statements
END;
```

The important pieces are:

| Part               | Purpose                               |
| ------------------ | ------------------------------------- |
| `CREATE PROCEDURE` | Creates the procedure                 |
| `procedure_name`   | Name of the procedure                 |
| `BEGIN`            | Starts the procedure logic            |
| SQL statements     | Operations performed by the procedure |
| `END`              | Ends the procedure logic              |

> **Note:** The source describes the syntax using `BEGIN` and `END`. Exact procedure syntax can vary between database systems.

---

# 4. Executing a Stored Procedure

Once the procedure has been created, it can be executed using the `CALL` command.

```sql
CALL procedure_name();
```

For example:

```sql
CALL process_order();
```

Conceptually:

```text
CREATE PROCEDURE
       ↓
Procedure stored in database
       ↓
CALL procedure_name()
       ↓
Procedure executes
```

---

# 5. Parameters

Stored Procedures can accept **input parameters**.

Parameters make the procedure dynamic.

Without parameters:

```text
CALL procedure_name();
```

The procedure always works with the same predefined logic.

With parameters:

```text
CALL procedure_name(value);
```

the procedure can work with different input values.

### Mental model

Think of parameters like arguments passed to a programming function:

```text
Function:
calculate(x)

Procedure:
process_product(product_id)
```

The procedure can use the provided value while executing its SQL logic.

---

# 6. Benefits of Stored Procedures

## 6.1 Efficiency

The source states that stored procedures can improve efficiency because the code is **pre-compiled**, reducing the time required to repeatedly parse and optimize queries.

Conceptually:

```text
Without Procedure

Application
    ↓
SQL
    ↓
Parse
    ↓
Optimize
    ↓
Execute
```

With a Stored Procedure, some of the work associated with repeatedly processing the same logic can be reduced.

This can lead to better performance.

---

# 7. Reduced Network Traffic

This is another important advantage.

Suppose an application needs to execute five SQL statements.

### Without a procedure

```text
Application
   │
   ├──── Query 1 ────→ Database
   ├──── Query 2 ────→ Database
   ├──── Query 3 ────→ Database
   ├──── Query 4 ────→ Database
   └──── Query 5 ────→ Database
```

There are multiple application-to-database communications.

### With a procedure

```text
Application
     │
     │ CALL procedure
     ▼
  Database
     │
     ├── Query 1
     ├── Query 2
     ├── Query 3
     ├── Query 4
     └── Query 5
```

Only one call is needed from the application.

Therefore, Stored Procedures can **reduce network traffic**.

---

# 8. Maintainability

Stored Procedures centralize database logic.

Without a procedure:

```text
Application File 1 → SQL Logic
Application File 2 → SQL Logic
Application File 3 → SQL Logic
```

The same logic may exist in multiple places.

This makes maintenance difficult.

With a procedure:

```text
              ┌── Application 1
              │
Stored ───────┼── Application 2
Procedure     │
              └── Application 3
```

The logic exists in one location.

If the logic needs to change, it can be updated in the procedure instead of changing the same SQL logic across multiple application files.

---

# 9. Security

Stored Procedures can also provide an **abstraction layer** between users/applications and the underlying tables.

For example, imagine a user needs to perform a particular database operation.

Instead of giving the user direct access to the underlying tables:

```text
User
  │
  ├── Direct table access
  ├── Direct table access
  └── Direct table access
```

you can allow them to execute a procedure:

```text
User
  │
  │ CALL procedure
  ▼
Procedure
  │
  ▼
Underlying Tables
```

Permissions can be configured so that a user can execute the procedure without necessarily being given direct access to the underlying tables.

This can improve security and control over database operations.

---

# 10. Conditional Logic

Stored Procedures are not limited to simple SQL statements.

The source states that they can support **conditional logic**, such as:

```text
IF
ELSE
```

This allows database-side decisions to be made based on conditions.

Conceptually:

```text
IF condition is true
       ↓
   Do Action A
ELSE
       ↓
   Do Action B
```

For example:

```text
IF stock > 0
    process order
ELSE
    reject order
```

This allows business logic to be handled directly on the database server.

---

# 11. Loops

Stored Procedures can also support **loops**.

A loop allows a block of logic to be executed repeatedly.

Conceptually:

```text
Start
  ↓
Check condition
  ↓
Execute logic
  ↓
Check condition again
  ↓
Repeat
  ↓
Stop
```

This is useful when database operations require repeated processing.

---

# 12. Stored Procedures and Business Logic

One important idea from this module is that Stored Procedures can move some **business logic** into the database.

For example:

```text
Application
     │
     │ CALL process_order()
     ▼
Database Procedure
     │
     ├── Check stock
     ├── Check conditions
     ├── Update data
     ├── Perform calculations
     └── Complete operation
```

Instead of the application individually controlling every database operation, the procedure can handle the complete sequence.

---

# 13. Complete Mental Model

Think of a Stored Procedure as a **reusable recipe stored inside the database**.

```text
           Stored Procedure
        ┌───────────────────┐
        │ SQL Statement 1   │
        │ SQL Statement 2   │
        │ IF / ELSE         │
        │ Loops             │
        │ SQL Statement 3   │
        └───────────────────┘
                  ▲
                  │
               CALL
                  │
             Application
```

The application doesn't need to know every internal SQL statement.

It can simply call the procedure.

---

# 14. Stored Procedure vs Normal SQL Query

| Normal SQL Query                      | Stored Procedure                        |
| ------------------------------------- | --------------------------------------- |
| Usually sent directly for execution   | Saved inside the database               |
| Individual query                      | Collection of SQL statements            |
| Logic may be repeated                 | Logic can be reused                     |
| Application may send multiple queries | Application can make one procedure call |
| Harder to centralize repeated logic   | Logic is centralized                    |
| Limited to the query itself           | Can contain conditional logic and loops |

---

# 15. Stored Procedure vs Programming Function

The source compares procedures to functions in programming.

| Programming Function             | Stored Procedure                     |
| -------------------------------- | ------------------------------------ |
| Stored in application code       | Stored in database                   |
| Called by program                | Called using `CALL`                  |
| Can accept parameters            | Can accept parameters                |
| Contains reusable logic          | Contains reusable SQL/database logic |
| Can contain conditions and loops | Can contain conditions and loops     |

The key difference is **where the logic lives**.

```text
Programming Function
      ↓
Application

Stored Procedure
      ↓
Database
```

---

# 16. Practical Example

Imagine an application needs to process an order.

The process might involve:

```text
1. Check product availability
2. Check stock
3. Update stock
4. Record the order
5. Perform other required operations
```

Without a procedure, the application might need to send several SQL commands.

With a procedure:

```sql
CALL process_order(...);
```

The database executes the predefined logic.

```text
CALL process_order()
        │
        ▼
   Check stock
        │
        ▼
   Update stock
        │
        ▼
   Create order
        │
        ▼
   Complete
```

This demonstrates why procedures are useful for **automation and reusable database operations**.

---

# 17. Common Mistakes / Gotchas

### 1. Confusing a procedure with a normal query

A query is generally an individual SQL operation.

A procedure is a **saved collection of operations**.

```text
Query       → Individual operation
Procedure   → Reusable group of operations
```

---

### 2. Forgetting that procedures can accept parameters

Procedures don't have to work with fixed values.

Parameters make them reusable for different inputs.

```text
CALL process_order(101);
CALL process_order(102);
CALL process_order(103);
```

The same procedure can process different values.

---

### 3. Putting repeated logic everywhere

If the same database logic is implemented in many application files, changing it becomes harder.

A Stored Procedure can centralize that logic.

---

### 4. Assuming procedures are only for simple CRUD

Stored Procedures can support more complex logic.

The source specifically mentions:

* SQL statements
* Parameters
* `IF/ELSE`
* Loops
* Business logic
* Automation

---

# Key Takeaways

* A **Stored Procedure** is a collection of SQL statements saved inside the database.
* It can be treated conceptually like a **function in programming**.
* Procedures help with **reusability** and **automation**.
* They can improve **efficiency** by reducing repeated parsing/optimization work.
* They can reduce **network traffic** because applications can make one call instead of sending many queries.
* They improve **maintainability** by keeping logic in one location.
* They can improve **security** by acting as an abstraction layer between users and underlying tables.
* Procedures can accept **input parameters**.
* Procedures are executed using:

```sql
CALL procedure_name();
```

* They can support **conditional logic such as IF/ELSE**.
* They can support **loops**.
* They can be used to implement complex **business logic directly on the database server**.

---

# Minimal Self-Test

1. What is a Stored Procedure?
2. Why is a Stored Procedure compared to a programming function?
3. Where is a Stored Procedure stored?
4. How do you execute a Stored Procedure?
5. Why are parameters useful?
6. How can Stored Procedures reduce network traffic?
7. How do Stored Procedures improve maintainability?
8. How can Stored Procedures help with security?
9. Can a Stored Procedure contain conditional logic?
10. Can a Stored Procedure contain loops?
11. What is the difference between a normal SQL query and a Stored Procedure?
12. Why are Stored Procedures useful for repetitive database operations?
13. How can Stored Procedures handle business logic?

---

# What to Learn Next

A logical progression after Stored Procedures is:

```text
SQL Views
    ↓
Stored Procedures
    ↓
Functions
    ↓
Triggers
    ↓
Transactions
    ↓
Advanced Database Programming
```

The next especially important concept is **SQL Triggers**, because they introduce automatic database actions that execute when events such as `INSERT`, `UPDATE`, or `DELETE` occur.
