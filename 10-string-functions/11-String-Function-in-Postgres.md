# SQL String Functions

## What it is

**String functions** are SQL functions used to work with text values.

They are useful when you need to:

* Extract part of a string.
* Change text to uppercase or lowercase.
* Count characters.
* Remove unwanted spaces.
* Join multiple strings.
* Replace one piece of text with another.

These functions are especially useful when working with columns containing names, codes, SKUs, categories, addresses, and other textual data.

---

## One-Sentence Summary

> **SQL string functions allow you to extract, modify, format, combine, and analyze text stored in database columns.**

---

# 1. Why String Functions Are Needed

Suppose a table contains a column called `SKU_CODE`:

| SKU_CODE |
| -------- |
| EL12345  |
| EL67890  |
| FK12345  |
| ST45678  |

You may want to extract:

```text
EL
FK
ST
```

because those first characters represent a category prefix.

Instead of modifying the original data, SQL provides functions that can extract or transform the required part.

For example:

```sql
SELECT SUBSTRING(SKU_CODE FROM 1 FOR 2)
FROM products;
```

---

# 2. Main String Functions

The important functions covered in this section are:

```text
SUBSTRING()
LEFT()
RIGHT()
REPLACE()
LOWER()
UPPER()
LENGTH()
TRIM()
CONCAT()
```

A quick overview:

| Function      | Purpose                                             |
| ------------- | --------------------------------------------------- |
| `SUBSTRING()` | Extracts part of a string using position and length |
| `LEFT()`      | Extracts characters from the beginning              |
| `RIGHT()`     | Extracts characters from the end                    |
| `REPLACE()`   | Replaces specific text                              |
| `LOWER()`     | Converts text to lowercase                          |
| `UPPER()`     | Converts text to uppercase                          |
| `LENGTH()`    | Counts characters                                   |
| `TRIM()`      | Removes leading/trailing whitespace                 |
| `CONCAT()`    | Joins strings together                              |

---

# 3. SUBSTRING()

## What it does

`SUBSTRING()` extracts a specific portion of a string.

The PostgreSQL syntax covered here is:

```sql
SUBSTRING(column_name FROM start_position FOR length)
```

It tells SQL:

```text
Start at this position
       ↓
Extract this many characters
```

---

# 4. SUBSTRING() Example

Suppose:

```text
SKU_CODE = EL12345
```

We want the first two characters:

```text
EL
```

Use:

```sql
SELECT SUBSTRING(SKU_CODE FROM 1 FOR 2)
FROM products;
```

Breakdown:

```text
SUBSTRING(SKU_CODE FROM 1 FOR 2)
             │          │    │
             │          │    └── Extract 2 characters
             │          └─────── Start at position 1
             └────────────────── Source column
```

Result:

```text
EL
```

---

# 5. SUBSTRING() for Category Prefixes

This is a practical use case.

Suppose SKU codes follow this structure:

```text
EL12345
││
│└── Category prefix
└─── Category prefix
```

You can extract the category prefix using:

```sql
SELECT SUBSTRING(SKU_CODE FROM 1 FOR 2)
FROM products;
```

For:

| SKU_CODE |
| -------- |
| EL12345  |
| EL67890  |
| FK12345  |
| ST45678  |

the extracted values are:

| Result |
| ------ |
| EL     |
| EL     |
| FK     |
| ST     |

This can help identify or analyze categories encoded inside strings.

---

# 6. LEFT()

## What it does

`LEFT()` extracts a specified number of characters from the **beginning** of a string.

Syntax:

```sql
LEFT(column_name, number_of_characters)
```

Example:

```sql
SELECT LEFT(SKU_CODE, 2)
FROM products;
```

For:

```text
EL12345
```

the result is:

```text
EL
```

---

## Mental Model

```text
EL12345
││
└┴── LEFT(..., 2)
```

`LEFT()` starts from the left side and takes the requested number of characters.

---

# 7. RIGHT()

## What it does

`RIGHT()` extracts characters from the **end** of a string.

For example:

```sql
SELECT RIGHT(SKU_CODE, 2)
FROM products;
```

For:

```text
EL12345
```

the result is:

```text
45
```

Mental model:

```text
EL12345
      ││
      └┴── RIGHT(..., 2)
```

So:

```text
LEFT()  → beginning
RIGHT() → end
```

---

# 8. LEFT() vs RIGHT() vs SUBSTRING()

These functions all extract pieces of strings, but they work differently.

| Function                       | What it does                                |
| ------------------------------ | ------------------------------------------- |
| `LEFT(text, 2)`                | Takes 2 characters from the beginning       |
| `RIGHT(text, 2)`               | Takes 2 characters from the end             |
| `SUBSTRING(text FROM 2 FOR 3)` | Starts at position 2 and takes 3 characters |

For:

```text
EL12345
```

we get:

```text
LEFT(..., 2)
→ EL

RIGHT(..., 2)
→ 45

SUBSTRING(... FROM 2 FOR 3)
→ L12
```

The important idea:

```text
LEFT / RIGHT
→ Position is fixed to an edge

SUBSTRING
→ You control the starting position and length
```

---

# 9. REPLACE()

## What it does

`REPLACE()` substitutes one piece of text with another.

It is useful when you need to standardize or modify text stored in a database.

The function needs:

1. The source string/column.
2. The text to find.
3. The replacement text.

Conceptually:

```text
REPLACE(source, old_text, new_text)
```

---

# 10. REPLACE() Example

Suppose a category code contains an old prefix:

```text
AB12345
AB67890
```

and you want to replace `AB` with `GG`.

You can use:

```sql
SELECT REPLACE(SKU_CODE, 'AB', 'GG')
FROM products;
```

Conceptually:

```text
AB12345
   ↓
Replace AB with GG
   ↓
GG12345
```

---

# 11. Practical Use of REPLACE()

`REPLACE()` is useful for **standardizing data**.

For example, imagine different records contain an old category prefix:

```text
OLD123
OLD456
OLD789
```

You can replace the old prefix with a common code:

```sql
REPLACE(column_name, 'OLD', 'GG')
```

Result:

```text
GG123
GG456
GG789
```

This can be useful when existing data needs to follow a new naming or coding standard.

---

# 12. LOWER()

`LOWER()` converts text to lowercase.

Example:

```sql
SELECT LOWER(category)
FROM products;
```

If the original value is:

```text
Electronics
```

the result becomes:

```text
electronics
```

Another example:

```text
HELLO WORLD
      ↓
hello world
```

---

# 13. UPPER()

`UPPER()` does the opposite.

It converts text to uppercase.

Example:

```sql
SELECT UPPER(category)
FROM products;
```

If the original value is:

```text
electronics
```

the result becomes:

```text
ELECTRONICS
```

---

## LOWER() vs UPPER()

| Function         | Result  |
| ---------------- | ------- |
| `LOWER('Hello')` | `hello` |
| `UPPER('Hello')` | `HELLO` |

Mental shortcut:

```text
LOWER → lowercase
UPPER → uppercase
```

---

# 14. LENGTH()

## What it does

`LENGTH()` returns the number of characters in a string.

Example:

```sql
SELECT LENGTH('Hello');
```

Result:

```text
5
```

Because:

```text
H e l l o
1 2 3 4 5
```

It can also be used with a column:

```sql
SELECT LENGTH(name)
FROM products;
```

This returns the character count of each product name.

---

# 15. Practical Use of LENGTH()

Suppose you have:

```text
SKU_CODE
```

and want to determine how many characters each SKU contains:

```sql
SELECT SKU_CODE, LENGTH(SKU_CODE)
FROM products;
```

This can help identify unexpected values or validate the structure of stored text.

---

# 16. TRIM()

## What it does

`TRIM()` removes whitespace from the **beginning and end** of a string.

For example, suppose the data contains:

```text
"   Electronics   "
```

There are unwanted spaces around the actual text.

Using:

```sql
SELECT TRIM(category)
FROM products;
```

produces:

```text
"Electronics"
```

---

## Mental Model

```text
"   Electronics   "
       ↓ TRIM()
"Electronics"
```

The important point is that `TRIM()` removes whitespace from the **edges** of the string.

---

# 17. CONCAT()

## What it does

`CONCAT()` joins two or more strings together.

For example:

```sql
SELECT CONCAT('Hello', 'World');
```

produces:

```text
HelloWorld
```

It can also combine values from multiple columns.

For example:

```sql
SELECT CONCAT(first_name, last_name)
FROM students;
```

This joins the values from the two columns.

---

# 18. Adding a Separator with CONCAT()

If you want a space between two values, include the space as another argument:

```sql
SELECT CONCAT(first_name, ' ', last_name)
FROM students;
```

For:

```text
first_name = Akarsh
last_name  = Kumar
```

the result is:

```text
Akarsh Kumar
```

Conceptually:

```text
Akarsh + " " + Kumar
          ↓
     Akarsh Kumar
```

---

# 19. String Functions Working Together

The real power comes from combining these functions.

For example:

```sql
SELECT UPPER(LEFT(category, 2))
FROM products;
```

This can be understood from the inside out:

```text
category
   ↓
LEFT(category, 2)
   ↓
First two characters
   ↓
UPPER(...)
   ↓
Convert those characters to uppercase
```

This is a common SQL pattern:

> One function's result can become another function's input.

---

# 20. Example: Clean and Standardize Text

Suppose the database contains:

```text
"  electronics  "
```

You could use:

```sql
SELECT UPPER(TRIM(category))
FROM products;
```

Processing:

```text
"  electronics  "
        ↓
      TRIM()
        ↓
"electronics"
        ↓
      UPPER()
        ↓
"ELECTRONICS"
```

This is useful when displaying standardized data.

---

# 21. String Function Reference Table

| Function      | Example                         | Purpose                            |
| ------------- | ------------------------------- | ---------------------------------- |
| `LOWER()`     | `LOWER(name)`                   | Convert to lowercase               |
| `UPPER()`     | `UPPER(name)`                   | Convert to uppercase               |
| `LENGTH()`    | `LENGTH(name)`                  | Count characters                   |
| `TRIM()`      | `TRIM(name)`                    | Remove leading/trailing whitespace |
| `CONCAT()`    | `CONCAT(first_name, last_name)` | Join strings                       |
| `LEFT()`      | `LEFT(name, 3)`                 | Take characters from the beginning |
| `RIGHT()`     | `RIGHT(name, 3)`                | Take characters from the end       |
| `SUBSTRING()` | `SUBSTRING(name FROM 2 FOR 3)`  | Extract a specific section         |
| `REPLACE()`   | `REPLACE(name, 'old', 'new')`   | Replace text                       |

---

# 22. Quick Comparison

Suppose:

```text
SKU_CODE = EL12345
```

### `LEFT()`

```sql
SELECT LEFT(SKU_CODE, 2);
```

Result:

```text
EL
```

### `RIGHT()`

```sql
SELECT RIGHT(SKU_CODE, 2);
```

Result:

```text
45
```

### `SUBSTRING()`

```sql
SELECT SUBSTRING(SKU_CODE FROM 1 FOR 2);
```

Result:

```text
EL
```

### `LENGTH()`

```sql
SELECT LENGTH(SKU_CODE);
```

Result:

```text
7
```

### `UPPER()`

```sql
SELECT UPPER(SKU_CODE);
```

Result:

```text
EL12345
```

### `LOWER()`

```sql
SELECT LOWER(SKU_CODE);
```

Result:

```text
el12345
```

---

# 23. Common Mistakes / Gotchas

## 1. Confusing LEFT() and RIGHT()

Remember:

```text
LEFT()  → start of string
RIGHT() → end of string
```

For:

```text
ABC123
```

```text
LEFT(..., 3)  → ABC
RIGHT(..., 3) → 123
```

---

## 2. Confusing SUBSTRING() with LEFT()

`LEFT()` is specifically for taking characters from the beginning.

```sql
LEFT(SKU_CODE, 2)
```

But `SUBSTRING()` gives more control:

```sql
SUBSTRING(SKU_CODE FROM 3 FOR 2)
```

You can start from a specific position.

---

## 3. Forgetting that functions don't necessarily modify the stored value

For example:

```sql
SELECT UPPER(category)
FROM products;
```

changes how the value is returned by the query.

It does **not automatically update the stored database value**.

Similarly:

```sql
SELECT REPLACE(name, 'Old', 'New')
FROM products;
```

produces transformed output but does not permanently modify the column.

To actually modify stored data, an `UPDATE` statement is required.

---

## 4. Using REPLACE() without understanding what is being replaced

For example:

```sql
REPLACE(column, 'AB', 'GG')
```

looks for the specified text and replaces it.

So you should understand exactly what substring you're targeting before using it for data standardization.

---

## 5. Forgetting whitespace problems

Data can sometimes contain unwanted spaces:

```text
" Electronics "
```

Using:

```sql
TRIM(category)
```

can clean the surrounding whitespace.

This is especially useful when comparing or standardizing text.

---

# 24. Practical Data-Cleaning Mental Model

String functions are especially useful in data cleaning.

Imagine messy data:

```text
"  electronics "
"Electronics"
"ELECTRONICS"
```

Different formatting can make data inconsistent.

Functions can help transform values:

```text
TRIM()
   ↓
Remove unnecessary spaces

UPPER()
   ↓
Standardize capitalization
```

For example:

```sql
SELECT UPPER(TRIM(category))
FROM products;
```

can turn differently formatted values into a common uppercase representation.

---

# 25. Key Takeaways

* String functions are used to manipulate and analyze text.
* `SUBSTRING()` extracts part of a string using a starting position and length.
* Syntax covered:

```sql
SUBSTRING(column_name FROM start_position FOR length)
```

* `LEFT()` extracts characters from the beginning.
* `RIGHT()` extracts characters from the end.
* `REPLACE()` substitutes specific text with replacement text.
* `LOWER()` converts text to lowercase.
* `UPPER()` converts text to uppercase.
* `LENGTH()` returns the number of characters.
* `TRIM()` removes whitespace from the beginning and end.
* `CONCAT()` joins two or more strings.
* String functions can be combined together.
* They are useful for text extraction, formatting, standardization, and data cleaning.
* Functions used inside `SELECT` generally transform the value returned by the query; they do not automatically change the stored database value.

---

# 26. One-Minute Revision

```text
SUBSTRING()
→ Extract a specific section

LEFT()
→ Extract from beginning

RIGHT()
→ Extract from end

REPLACE()
→ Replace text

LOWER()
→ lowercase

UPPER()
→ UPPERCASE

LENGTH()
→ Count characters

TRIM()
→ Remove surrounding whitespace

CONCAT()
→ Join strings
```

### Most important syntax

```sql
SUBSTRING(column_name FROM start_position FOR length)
```

```sql
LEFT(column_name, number_of_characters)
```

```sql
RIGHT(column_name, number_of_characters)
```

```sql
REPLACE(column_name, old_text, new_text)
```

---

# 27. Minimal Self-Test

1. What are SQL string functions?
2. Why are string functions useful in databases?
3. What does `SUBSTRING()` do?
4. What is the syntax of `SUBSTRING()`?
5. Write a query to extract the first two characters of `SKU_CODE`.
6. What is the difference between `LEFT()` and `RIGHT()`?
7. Write a query to extract the last three characters of `SKU_CODE`.
8. What does `REPLACE()` do?
9. How could `REPLACE()` be used to standardize category prefixes?
10. What is the difference between `LOWER()` and `UPPER()`?
11. What does `LENGTH()` return?
12. What problem does `TRIM()` solve?
13. What does `CONCAT()` do?
14. How would you combine `first_name` and `last_name` with a space between them?
15. What is the difference between `LEFT()` and `SUBSTRING()`?
16. What happens when you use `UPPER(category)` in a `SELECT` query?
17. Does `SELECT REPLACE(...)` permanently modify the stored value?
18. How can `TRIM()` and `UPPER()` be combined to standardize text?
19. Given `SKU_CODE = 'EL12345'`, what do `LEFT(..., 2)` and `RIGHT(..., 2)` return?
20. Explain the purpose of each: `SUBSTRING`, `LEFT`, `RIGHT`, `REPLACE`, `LOWER`, `UPPER`, `LENGTH`, `TRIM`, and `CONCAT`.
