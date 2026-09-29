# PostgreSQL — Learning Notes & SQL Examples

A structured collection of notes and hands-on SQL examples covering PostgreSQL
from first principles through advanced topics. The repository accompanies a
video-based SQL course and serves as a long-term personal reference.

---

## About

This is a **study and reference repository**, not an application or library.

Each module contains:

- A detailed Markdown note file explaining concepts, mental models, common
  mistakes, key takeaways, and self-test questions.
- An `examples.sql` file (or topic-specific `.sql` files) with runnable
  queries that illustrate the concepts discussed in the note.

The notes are written to be readable on their own — without needing to watch
the course again. The self-test questions at the end of each note make the
material useful for revision and interview preparation.

---

## What You'll Find Here

| Area | Topics Covered |
|------|----------------|
| **Foundations** | Databases, tables, rows/columns, basic `SELECT`, pgAdmin GUI |
| **Core SQL** | CRUD operations, clauses, operators, aggregate functions, string functions |
| **Schema Design** | Data types, constraints, `ALTER TABLE`, relationships |
| **Querying** | `CASE` expressions, `GROUP BY`, `HAVING`, all `JOIN` types |
| **Relational Modelling** | One-to-one, one-to-many, many-to-many relationships |
| **Database Objects** | Views, stored procedures |
| **Advanced SQL** | Window functions, CTEs, set operators, indexes, JSON/arrays, date-time |
| **Practice** | Three structured exercises with analysis and solutions |
| **Career & Roadmap** | Post-course advice, advanced topics roadmap |

---

## Repository Structure

```
PostgreSQL/
├── 00-resources/              → Reference PDF, career advice, advanced topics roadmap
├── 01-fundamentals/           → Databases, tables, rows/columns, basic SELECT
├── 02-pgadmin/                → Navigating the pgAdmin GUI
├── 03-crud/                   → INSERT, SELECT, UPDATE, DELETE
├── 04-data-types/             → INT, TEXT, BOOLEAN, NUMERIC, DATE, JSON, arrays
├── 05-constraints/            → PRIMARY KEY, FOREIGN KEY, NOT NULL, UNIQUE, CHECK
├── 06-exercises/              → Practice exercises 1, 2, and 3
├── 07-clauses/                → WHERE, ORDER BY, LIMIT, OFFSET, GROUP BY, HAVING
├── 08-operators/              → AND/OR/NOT, BETWEEN, IN, LIKE, IS NULL
├── 09-aggregate-functions/    → COUNT, SUM, AVG, MIN, MAX
├── 10-string-functions/       → LENGTH, SUBSTRING, CONCAT, TRIM, REPLACE
├── 11-alter-command/          → ALTER TABLE — add/drop/rename columns & constraints
├── 12-case-conditionals/      → CASE WHEN … THEN … ELSE … END
├── 13-relations-and-joins/    → One-to-one, one-to-many, many-to-many, all JOIN types
├── 14-views/                  → CREATE VIEW, SELECT from view, DROP VIEW
├── 15-procedures/             → Stored procedures, functions, CALL
└── 16-advanced-topics/        → Window functions, CTEs, set operators, indexes, JSON/arrays, date-time
```

Each folder (except `00-resources` and `06-exercises`) follows the same pattern:

```
<topic>/
├── <number>-<Topic-Name>.md   → Concept notes
└── examples.sql               → Runnable SQL queries
```

`13-relations-and-joins/` contains separate `.sql` files per relationship type
because the schema differs between them. `16-advanced-topics/` contains only
`.sql` files — the conceptual notes for those topics live in
[`00-resources/What-not-Covered.md`](00-resources/What-not-Covered.md).

---

## Note Format

Every Markdown note follows a consistent internal structure:

1. **What it is** — brief scope statement
2. **One-sentence summary** — the single most important idea
3. **Numbered sections** — concepts with plain language, mental models, and ASCII diagrams
4. **Common mistakes / gotchas** — pitfalls to watch for
5. **Key takeaways** — bullet summary for fast review
6. **One-minute revision** — ultra-condensed version for pre-interview recall
7. **Minimal self-test** — questions to verify understanding without looking back

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

## The Bookstore Schema

Most `examples.sql` files share a common **bookstore schema** to keep queries
consistent across topics:

```
authors      books        customers      orders
─────────    ─────────    ─────────      ─────────
author_id    book_id      customer_id    order_id
name         title        name           customer_id
             author_id    email          book_id
             price                       quantity
             genre                       order_date
```

To set up the schema before following along with any topic:

1. Create a database:
   ```sql
   CREATE DATABASE bookstore;
   ```
2. Run the seed file:
   ```
   \i 01-fundamentals/examples.sql
   ```
3. Open any topic's `examples.sql` and run the queries.

---

## How to Use This Repository

| Goal | Where to start |
|------|----------------|
| Learn a topic from scratch | Open the numbered `.md` note for that topic |
| Follow along with working SQL | Open `examples.sql` in the same folder |
| Quick pre-interview review | Use the "One-minute revision" section in each note |
| Test your understanding | Work through the "Minimal self-test" at the end of each note |
| Practice writing queries | Work through the exercises in [`06-exercises/`](06-exercises/) |
| Explore advanced topics | See [`16-advanced-topics/`](16-advanced-topics/) and [`What-not-Covered.md`](00-resources/What-not-Covered.md) |
| Plan what to learn next | Read [`SQL-Career-Advice.md`](00-resources/SQL-Career-Advice.md) |

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

For **revision**, jump directly to the note for the topic you need — each note
is self-contained and includes a quick-recall section.

For **interview preparation**, use the self-test questions and one-minute
revision summaries at the end of each note.

---

## Interview Preparation

The notes are structured with interview scenarios in mind:

- **Conceptual questions** — covered in the main body of each note
- **Common mistakes** — explicitly listed per topic
- **Key takeaways** — condensed bullet lists for fast review
- **One-minute revision** — the most important summary per topic
- **Self-test questions** — unseen questions to verify recall

The exercises in [`06-exercises/`](06-exercises/) include problem analysis and
worked solutions, useful for practising query-writing under realistic
conditions.

---

## Resources

| File | Description |
|------|-------------|
| [SQL-PDF.pdf](00-resources/SQL-PDF.pdf) | Course reference PDF |
| [SQL-Career-Advice.md](00-resources/SQL-Career-Advice.md) | Post-course career & practice guidance |
| [What-not-Covered.md](00-resources/What-not-Covered.md) | Advanced topics roadmap — window functions, CTEs, indexing, normalization, and more |

---

## Current Status

This is an evolving knowledge base. Notes and SQL examples are added and
refined as topics are studied. The `16-advanced-topics/` folder currently
contains `.sql` examples; detailed concept notes for those topics live in
[`What-not-Covered.md`](00-resources/What-not-Covered.md).
