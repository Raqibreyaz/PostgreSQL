# PostgreSQL — Learning Notes & SQL Examples

A structured collection of notes and hands-on SQL examples covering PostgreSQL from fundamentals through to advanced topics.

All SQL examples use a consistent **bookstore schema** (`authors`, `books`, `customers`, `orders`) seeded in [`01-fundamentals/examples.sql`](01-fundamentals/examples.sql) — run that file first to set up the data.

---

## Repository Structure

```
PostgreSQL/
├── 00-resources/          → PDF, career advice, advanced topics roadmap
├── 01-fundamentals/       → Databases, tables, rows/columns, basic SELECT
├── 02-pgadmin/            → Navigating the pgAdmin GUI
├── 03-crud/               → INSERT, SELECT, UPDATE, DELETE
├── 04-data-types/         → INT, TEXT, BOOLEAN, NUMERIC, DATE, JSON, arrays…
├── 05-constraints/        → PRIMARY KEY, FOREIGN KEY, NOT NULL, UNIQUE, CHECK
├── 06-exercises/          → Practice exercises 1, 2, and 3
├── 07-clauses/            → WHERE, ORDER BY, LIMIT, OFFSET, GROUP BY, HAVING
├── 08-operators/          → AND/OR/NOT, BETWEEN, IN, LIKE, IS NULL
├── 09-aggregate-functions/→ COUNT, SUM, AVG, MIN, MAX
├── 10-string-functions/   → LENGTH, SUBSTRING, CONCAT, TRIM, REPLACE…
├── 11-alter-command/      → ALTER TABLE — add/drop/rename columns & constraints
├── 12-case-conditionals/  → CASE WHEN … THEN … ELSE … END
├── 13-relations-and-joins/→ One-to-one, one-to-many, many-to-many, all JOIN types
├── 14-views/              → CREATE VIEW, SELECT from view, DROP VIEW
├── 15-procedures/         → Stored procedures, functions, CALL
└── 16-advanced-topics/    → Window functions, CTEs, set operators, indexes, JSON/arrays, date-time
```

---

## Topic Index

| # | Topic | Notes | SQL |
|---|-------|-------|-----|
| 01 | SQL Introduction & Fundamentals | [📄](01-fundamentals/01-SQL-Introduction-and-Fundamentals.md) | [🗄](01-fundamentals/examples.sql) |
| 02 | Navigating pgAdmin | [📄](02-pgadmin/02-Navigating-PGAdmin.md) | — |
| 03 | CRUD Operations | [📄](03-crud/03-CRUD-Operations.md) | [🗄](03-crud/examples.sql) |
| 04 | Data Types | [📄](04-data-types/04-DataTypes-in-Postgres.md) | [🗄](04-data-types/examples.sql) |
| 05 | Constraints | [📄](05-constraints/05-Constraints-in-Postgres.md) | [🗄](05-constraints/examples.sql) |
| 06 | Exercises 1–3 | [📄](06-exercises/) | — |
| 07 | Clauses | [📄](07-clauses/07-Clauses-in-Postgres.md) | [🗄](07-clauses/examples.sql) |
| 08 | Operators | [📄](08-operators/08-Operators-in-Postgres.md) | [🗄](08-operators/examples.sql) |
| 09 | Aggregate Functions | [📄](09-aggregate-functions/09-Aggregate-Functions-in-Postgres.md) | [🗄](09-aggregate-functions/examples.sql) |
| 10 | String Functions | [📄](10-string-functions/11-String-Function-in-Postgres.md) | [🗄](10-string-functions/examples.sql) |
| 11 | ALTER Command | [📄](11-alter-command/12-ALTER-Command-in-Postgres.md) | [🗄](11-alter-command/examples.sql) |
| 12 | CASE Conditionals | [📄](12-case-conditionals/13-CASE-Conditional-Logic-in-Postgres.md) | [🗄](12-case-conditionals/examples.sql) |
| 13 | Relations & Joins | [📄](13-relations-and-joins/) | [One-to-one](13-relations-and-joins/15-one-to-one.sql) · [One-to-many](13-relations-and-joins/16-one-to-many.sql) · [Joins](13-relations-and-joins/17-joins.sql) · [Many-to-many](13-relations-and-joins/19-many-to-many.sql) |
| 14 | Views | [📄](14-views/20-Views-in-Postgres.md) | [🗄](14-views/examples.sql) |
| 15 | Stored Procedures | [📄](15-procedures/21-Procedures-in-Postgres.md) | [🗄](15-procedures/examples.sql) |
| 16 | Advanced Topics | [📄](00-resources/What-not-Covered.md) | [Window functions](16-advanced-topics/window-functions.sql) · [CTEs](16-advanced-topics/ctes.sql) · [Set operators](16-advanced-topics/set-operators.sql) · [Indexes](16-advanced-topics/indexes.sql) · [JSON & Arrays](16-advanced-topics/json-arrays.sql) · [Date-time](16-advanced-topics/advanced-datetime.sql) |

---

## Quick Start

1. **Install PostgreSQL** and open pgAdmin or `psql`.
2. Create a new database:
   ```sql
   CREATE DATABASE bookstore;
   ```
3. **Run the seed file first** — it creates and populates all tables:
   ```
   \i 01-fundamentals/examples.sql
   ```
4. Then open any topic folder and run `examples.sql` to follow along.

---

## Resources

| File | Description |
|------|-------------|
| [SQL-PDF.pdf](00-resources/SQL-PDF.pdf) | Course reference PDF |
| [SQL-Career-Advice.md](00-resources/SQL-Career-Advice.md) | Post-course career & practice guidance |
| [What-not-Covered.md](00-resources/What-not-Covered.md) | Advanced topics roadmap (window functions, CTEs, indexing, etc.) |

---

## Recommended Learning Path

```
Fundamentals → CRUD → Data Types → Constraints
      ↓
Clauses → Operators → Aggregates → String Functions
      ↓
ALTER → CASE → Relations & Joins
      ↓
Views → Stored Procedures
      ↓
Advanced: CTEs → Window Functions → Set Operators → Indexes → JSON/Arrays → Date-Time
```
