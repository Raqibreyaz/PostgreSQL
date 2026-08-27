# SQL Operators: LIKE, Wildcards & Logical Operators

## What it is

SQL operators allow us to create more precise conditions when filtering data.

This module focuses on two important categories:

1. **Pattern matching**

   * `LIKE`
   * `%`
   * `_`

2. **Logical operators**

   * `AND`
   * `OR`
   * `NOT`

These operators are mainly used with the `WHERE` clause.

---

## One-Sentence Summary

> **SQL operators make filtering more powerful by allowing us to search for text patterns and combine multiple conditions logically.**

---

# 1. Why SQL Operators Are Needed

A simple `WHERE` condition can perform an exact match:

```sql
SELECT *
FROM products
WHERE category = 'Electronics';
```

But real-world questions are often more flexible.

For example:

* Find names starting with `W`.
* Find values containing `123`.
* Find values where the second character is `B`.
* Find products that belong to Electronics **and** cost more than a certain amount.
* Find products from either Electronics **or** Stationary.
* Exclude products matching a particular condition.

For these situations, SQL operators are useful.

---

# 2. Pattern Matching with LIKE

## What is `LIKE`?

`LIKE` is used when you want to search for a **pattern** rather than an exact value.

Basic syntax:

```sql
SELECT *
FROM table_name
WHERE column_name LIKE 'pattern';
```

For example:

```sql
SELECT *
FROM products
WHERE name LIKE 'W%';
```

This does not search for the exact value `W`.

Instead, it searches for values that **match the specified pattern**.

---

# 3. The `%` Wildcard

The `%` symbol is a wildcard.

It represents:

> **Zero, one, or multiple characters.**

This makes `%` very flexible for text searching.

Think of it as:

```text
% → "Anything can come here"
```

---

# 4. `LIKE 'W%'` — Starts With W

Consider:

```sql
SELECT *
FROM products
WHERE name LIKE 'W%';
```

The pattern is:

```text
W%
```

Meaning:

```text
W + anything
```

So values such as:

```text
W
Watch
Wallet
Window
Water Bottle
```

can match the pattern.

The important idea is:

> The value must start with `W`.

---

## Mental Model

```text
W%
││
│└── Zero or more characters
└── Must start with W
```

So:

```text
W + anything
```

---

# 5. `%` Can Also Search for Something Anywhere

Consider:

```sql
SELECT *
FROM products
WHERE name LIKE '%123%';
```

The pattern is:

```text
%123%
```

This means:

```text
anything + 123 + anything
```

Therefore, `123` can appear:

* At the beginning
* In the middle
* At the end

of the value.

---

# 6. Example — `%123%`

Values such as:

```text
123
ABC123
123ABC
ABC123XYZ
XYZ123
```

can match:

```sql
LIKE '%123%'
```

because they contain `123` somewhere.

Mental model:

```text
%123%
│   │
│   └── Anything after 123
└────── Anything before 123
```

The key requirement is simply:

```text
123 must appear somewhere
```

---

# 7. The `_` Wildcard

The underscore `_` is another wildcard.

Unlike `%`, it represents:

> **Exactly one character.**

Think of:

```text
_ → Exactly one character
```

For example:

```sql
LIKE '_B%'
```

---

# 8. Understanding `LIKE '_B%'`

The pattern is:

```text
_B%
```

Break it down:

```text
_ → exactly one character
B → second character must be B
% → zero or more characters after that
```

So the structure is:

```text
[one character][B][anything]
```

Therefore, the important condition is:

> **The second character must be `B`.**

---

# 9. Example of `_B%`

Consider these values:

```text
AB
ABC
XB
XBOX
1B123
```

They can match:

```sql
LIKE '_B%'
```

because:

```text
AB
││
│└── B is second
└── One character

ABC
││
│└── B is second
└── One character
```

But a value such as:

```text
Bicycle
```

does not match `_B%` because `B` is the **first** character, not the second.

---

# 10. Multiple Underscores

You can use multiple `_` characters when you want to represent multiple specific character positions.

For example:

```sql
LIKE '__B%'
```

means:

```text
_ → first character
_ → second character
B → third character
% → anything after it
```

So:

```text
[character][character]B[anything]
```

The third character must be `B`.

---

# 11. `%` vs `_`

This distinction is extremely important.

| Wildcard | Meaning                       |
| -------- | ----------------------------- |
| `%`      | Zero, one, or many characters |
| `_`      | Exactly one character         |

### `%`

```text
W%
```

means:

```text
W + any number of characters
```

### `_`

```text
_B%
```

means:

```text
exactly one character + B + anything
```

---

# 12. Visual Comparison

```text
%  → 0 or more characters

_  → exactly 1 character
```

Example:

```text
LIKE 'W%'
```

```text
W______
```

The number of characters after `W` can vary.

Whereas:

```text
LIKE '_B%'
```

has a fixed position:

```text
_B______
││
│└── B must be here
└── exactly one character before B
```

---

# 13. Logical Operators

Pattern matching helps us create conditions involving strings.

But sometimes we need to combine **multiple conditions**.

For this, SQL provides logical operators:

```text
AND
OR
NOT
```

These are commonly used inside `WHERE`.

---

# 14. AND

## What it does

`AND` requires **all conditions to be true**.

Example:

```sql
SELECT *
FROM products
WHERE category = 'Electronics'
AND price > 1000;
```

This means:

> Return products that are Electronics **and** have a price greater than 1000.

Both conditions must be satisfied.

---

# 15. AND Mental Model

```text
Condition 1 → TRUE
Condition 2 → TRUE
                 ↓
              Include
```

But:

```text
Condition 1 → TRUE
Condition 2 → FALSE
                 ↓
              Exclude
```

Similarly:

```text
Condition 1 → FALSE
Condition 2 → TRUE
                 ↓
              Exclude
```

So:

```text
TRUE AND TRUE = TRUE
TRUE AND FALSE = FALSE
FALSE AND TRUE = FALSE
FALSE AND FALSE = FALSE
```

The simple rule:

> **AND = everything must be true.**

---

# 16. OR

## What it does

`OR` requires **at least one condition to be true**.

Example:

```sql
SELECT *
FROM products
WHERE category = 'Electronics'
OR category = 'Stationary';
```

This means:

> Return products that are either Electronics or Stationary.

A product does not need to satisfy both conditions.

---

# 17. OR Mental Model

```text
Condition 1 → TRUE
Condition 2 → FALSE
                 ↓
              Include
```

Because at least one condition is true.

Similarly:

```text
Condition 1 → FALSE
Condition 2 → TRUE
                 ↓
              Include
```

Only when both conditions are false do we exclude the row.

```text
TRUE OR TRUE = TRUE
TRUE OR FALSE = TRUE
FALSE OR TRUE = TRUE
FALSE OR FALSE = FALSE
```

The simple rule:

> **OR = at least one must be true.**

---

# 18. NOT

## What it does

`NOT` reverses or excludes a condition.

For example:

```sql
SELECT *
FROM products
WHERE NOT category = 'Electronics';
```

This means:

> Return products whose category is **not** Electronics.

Conceptually:

```text
category = Electronics
          ↓
         NOT
          ↓
category ≠ Electronics
```

---

# 19. NOT Mental Model

Think of `NOT` as:

> **"Give me everything except this condition."**

For example:

```sql
WHERE NOT category = 'Electronics'
```

means:

```text
Electronics → Exclude
Everything else → Include
```

---

# 20. Combining LIKE with Logical Operators

These concepts become much more powerful when combined.

For example:

```sql
SELECT *
FROM products
WHERE name LIKE 'W%'
AND category = 'Electronics';
```

This means:

> Find products whose names start with `W` **and** whose category is Electronics.

The database checks two conditions:

```text
name starts with W
       AND
category is Electronics
```

Both must be true.

---

# 21. Combining OR with LIKE

You can also combine patterns using `OR`.

Example:

```sql
SELECT *
FROM products
WHERE name LIKE 'W%'
OR name LIKE 'P%';
```

Meaning:

> Find products whose names start with either `W` or `P`.

---

# 22. Combining NOT with LIKE

You can also exclude a pattern.

Example:

```sql
SELECT *
FROM products
WHERE name NOT LIKE 'W%';
```

Meaning:

> Return products whose names do not start with `W`.

This is useful when you want to explicitly exclude a particular pattern.

---

# 23. Practical Examples

## Example 1 — Names Starting With W

```sql
SELECT *
FROM products
WHERE name LIKE 'W%';
```

**Meaning:** Name starts with `W`.

---

## Example 2 — Values Containing 123

```sql
SELECT *
FROM products
WHERE name LIKE '%123%';
```

**Meaning:** `123` appears somewhere in the value.

---

## Example 3 — Second Character Is B

```sql
SELECT *
FROM products
WHERE name LIKE '_B%';
```

**Meaning:** The second character is `B`.

---

## Example 4 — Electronics AND Expensive

```sql
SELECT *
FROM products
WHERE category = 'Electronics'
AND price > 1000;
```

**Meaning:** Both conditions must be true.

---

## Example 5 — Electronics OR Stationary

```sql
SELECT *
FROM products
WHERE category = 'Electronics'
OR category = 'Stationary';
```

**Meaning:** At least one condition must be true.

---

## Example 6 — Everything Except Electronics

```sql
SELECT *
FROM products
WHERE NOT category = 'Electronics';
```

**Meaning:** Exclude Electronics products.

---

# 24. AND vs OR vs NOT

| Operator | Meaning                             | Example   |
| -------- | ----------------------------------- | --------- |
| `AND`    | All conditions must be true         | `A AND B` |
| `OR`     | At least one condition must be true | `A OR B`  |
| `NOT`    | Exclude/reverse a condition         | `NOT A`   |

Quick memory trick:

```text
AND → ALL
OR  → ANY
NOT → EXCLUDE/REVERSE
```

---

# 25. Pattern Matching Cheat Sheet

| Pattern   | Meaning                 |
| --------- | ----------------------- |
| `'W%'`    | Starts with `W`         |
| `'%123%'` | Contains `123` anywhere |
| `'_B%'`   | Second character is `B` |
| `'__B%'`  | Third character is `B`  |
| `'W'`     | Exact pattern `W`       |

Remember:

```text
% → zero or more
_ → exactly one
```

---

# 26. Common Mistakes / Gotchas

## 1. Confusing `%` and `_`

Do not think both wildcards mean "anything."

They are different:

```text
% → any number of characters, including zero
_ → exactly one character
```

---

## 2. Misunderstanding `_B%`

This:

```sql
LIKE '_B%'
```

does **not** mean:

> Contains B.

It means:

> `B` must be the **second character**.

For example:

```text
AB     → matches
XB     → matches
ABC    → matches
XBOX   → matches
```

But:

```text
BABC   → does not match
```

because `B` is the first character.

---

## 3. Using `%` when an exact position matters

If you need the second character to be `B`, use:

```sql
LIKE '_B%'
```

not:

```sql
LIKE '%B%'
```

The second pattern only means:

> `B` exists somewhere.

---

## 4. Assuming AND means either condition

It does not.

```sql
WHERE A AND B
```

requires:

```text
A = TRUE
B = TRUE
```

---

## 5. Assuming OR means both conditions

It does not.

```sql
WHERE A OR B
```

requires only:

```text
A = TRUE
OR
B = TRUE
```

---

## 6. Forgetting that NOT excludes matching rows

```sql
WHERE NOT category = 'Electronics'
```

means:

```text
Electronics → exclude
Other categories → include
```

---

# 27. Real-World Use Cases

These operators are not just for simple exercises.

### `LIKE`

Useful for searches such as:

```text
Find users whose names start with "Ra"
Find products containing "phone"
Find emails matching a pattern
```

### `AND`

Useful when multiple requirements must be satisfied:

```text
Electronics
AND
Price > 50000
```

### `OR`

Useful when multiple alternatives are acceptable:

```text
Electronics
OR
Stationary
```

### `NOT`

Useful when excluding unwanted data:

```text
Everything except discontinued products
```

---

# 28. Putting Everything Together

A realistic query might combine all these ideas:

```sql
SELECT *
FROM products
WHERE name LIKE 'W%'
AND NOT category = 'Stationary';
```

Read it as:

> Find products whose names start with `W` and whose category is not Stationary.

The filtering process becomes:

```text
Products
   ↓
name starts with W
   ↓
AND
   ↓
category is NOT Stationary
   ↓
Final matching products
```

This is the foundation for writing more complex filtering queries.

---

# 29. Key Takeaways

* `LIKE` is used for **pattern matching**.
* `%` represents **zero, one, or many characters**.
* `_` represents **exactly one character**.
* `LIKE 'W%'` finds values starting with `W`.
* `LIKE '%123%'` finds values containing `123` anywhere.
* `LIKE '_B%'` finds values where `B` is the second character.
* Multiple `_` characters represent multiple exact character positions.
* `AND` requires all conditions to be true.
* `OR` requires at least one condition to be true.
* `NOT` excludes or reverses a condition.
* These operators are mainly used with `WHERE`.
* Pattern matching and logical operators can be combined to create precise filters.

---

# 30. One-Minute Revision

```text
LIKE
→ Pattern matching

%
→ Zero or more characters

_
→ Exactly one character


'W%'
→ Starts with W

'%123%'
→ Contains 123

'_B%'
→ B is second character

'__B%'
→ B is third character


AND
→ All conditions must be true

OR
→ At least one condition must be true

NOT
→ Exclude/reverse condition
```

The most important distinction:

```text
%  → variable number of characters
_  → exactly one character
```

And:

```text
AND → ALL
OR  → ANY
NOT → EXCLUDE
```

---

# 31. Minimal Self-Test

1. What is the purpose of `LIKE`?
2. What does `%` represent?
3. What does `_` represent?
4. What does `LIKE 'W%'` match?
5. What does `LIKE '%123%'` match?
6. What does `LIKE '_B%'` mean?
7. What does `LIKE '__B%'` mean?
8. What is the difference between `%` and `_`?
9. What does `AND` do?
10. What does `OR` do?
11. What does `NOT` do?
12. When would you use `HAVING` instead of `WHERE`?
13. Write a query to find products whose names start with `P`.
14. Write a query to find products whose names contain `phone`.
15. Write a query to find products whose second character is `B`.
16. Write a query to find Electronics products costing more than `1000`.
17. Write a query to find Electronics or Stationary products.
18. Write a query to exclude Electronics products.
19. What is the difference between `_B%` and `%B%`?
20. Explain `AND`, `OR`, and `NOT` using the words **all**, **any**, and **exclude**.
