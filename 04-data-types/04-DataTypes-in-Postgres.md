# SQL String Functions

## What it is

**String functions** are SQL functions used to work with text values.

They are useful when you need to:

* Extract part of a string.
* Find the length of text.
* Convert text to uppercase or lowercase.
* Remove unwanted whitespace.
* Join multiple strings.
* Replace one piece of text with another.
* Standardize text data across a table.

In this module, the main functions are:

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
CONCAT_WS()
```

---

## One-Sentence Summary

> **SQL string functions allow us to inspect, extract, modify, clean, and combine text stored in database columns.**

---

# 1. Why String Functions Are Needed

Databases often contain text such as:

```text
Product names
SKU codes
Category names
Email addresses
Usernames
Product descriptions
```

Suppose a product has this SKU:

```text
EL123456
```

Maybe:

```text
EL
```

represents the product category.

Instead of manually processing the SKU outside the database, SQL can extract those characters:

```sql
SELECT SUBSTRING(sku_code FROM 1 FOR 2)
FROM product;
```

This gives:

```text
EL
```

String functions let us perform this kind of text processing directly inside SQL.

---

# 2. SUBSTRING()

## What it does

`SUBSTRING()` extracts a specific portion of a string.

The source uses the PostgreSQL syntax:

```sql
SUBSTRING(column_name FROM start_position FOR length)
```

The three important parts are:

```text
SUBSTRING(
    column
    FROM starting position
    FOR number of characters
)
```

---

# 3. SUBSTRING() Example

Suppose:

```text
Brother in arms
```

We can extract part of it using:

```sql
SELECT substring('Brother in arms', 3, 4);
```

The intention is to start at a specific position and retrieve a fixed number of characters.

Conceptually:

```text
Brother in arms
  ↑
  Start position
```

The function returns the requested section of the string.

---

# 4. SUBSTRING() with SKU Codes

A common practical use is extracting a category prefix from an SKU.

For example:

```text
EL123456
```

Suppose the first two characters represent the category.

We can use:

```sql
SELECT SUBSTRING(sku_code FROM 1 FOR 2)
FROM product;
```

This extracts:

```text
EL
```

from:

```text
EL123456
```

### Mental model

```text
SKU_CODE
   ↓
EL123456
││
└┴── category prefix
```

So `SUBSTRING()` is useful when the important information is located at a known position inside a string.

---

# 5. LEFT()

## What it does

`LEFT()` extracts a specified number of characters from the **beginning/left side** of a string.

Syntax:

```sql
LEFT(column_name, number_of_characters)
```

Example:

```sql
SELECT left('Brother Arms', 7);
```

This asks:

> Give me the first 7 characters.

Conceptually:

```text
Brother Arms
│──────│
 first 7 characters
```

Result:

```text
Brother
```

---

# 6. LEFT() with a Column

You can also use `LEFT()` with a table column.

For example:

```sql
SELECT LEFT(sku_code, 2)
FROM product;
```

This extracts the first two characters of every `sku_code`.

If the SKU values are:

```text
EL123456
FT987654
HK456789
```

the result can be:

```text
EL
FT
HK
```

This is another way of extracting category prefixes.

---

# 7. RIGHT()

## What it does

`RIGHT()` extracts characters from the **end/right side** of a string.

Example:

```sql
SELECT right('Brother arms', 2);
```

This asks:

> Give me the last 2 characters.

The string ends with:

```text
...ms
```

So the result is:

```text
ms
```

---

# 8. LEFT() vs RIGHT() vs SUBSTRING()

These three functions all extract parts of strings, but they work differently.

| Function      | Purpose                          |
| ------------- | -------------------------------- |
| `LEFT()`      | Extract from the beginning       |
| `RIGHT()`     | Extract from the end             |
| `SUBSTRING()` | Extract from a specific position |

### Example

For:

```text
ABC123XYZ
```

`LEFT()`:

```sql
SELECT LEFT('ABC123XYZ', 3);
```

Result:

```text
ABC
```

`RIGHT()`:

```sql
SELECT RIGHT('ABC123XYZ', 3);
```

Result:

```text
XYZ
```

`SUBSTRING()`:

```sql
SELECT SUBSTRING('ABC123XYZ' FROM 4 FOR 3);
```

Result:

```text
123
```

### Mental model

```text
ABC123XYZ
│││   │││
└──   └──
LEFT  RIGHT

    │───│
    SUBSTRING
```

---

# 9. REPLACE()

## What it does

`REPLACE()` finds a particular piece of text and replaces it with another piece of text.

Conceptually:

```text
old text
   ↓
find
   ↓
replace with new text
```

The function needs:

1. The original string/column.
2. The substring to find.
3. The replacement string.

General form:

```sql
REPLACE(source, target, replacement)
```

---

# 10. REPLACE() Example

Suppose:

```text
Hello World
```

We want to replace:

```text
World
```

with:

```text
SQL
```

We can use:

```sql
SELECT REPLACE('Hello World', 'World', 'SQL');
```

Result:

```text
Hello SQL
```

---

# 11. Practical REPLACE() Example with SKU

The source gives this query:

```sql
SELECT name,
       replace(sku_code, left(sku_code, 2), 'GG')
FROM product;
```

This is an interesting example because it combines multiple string functions.

Let's break it down.

### Step 1 — Get the first two characters

```sql
LEFT(sku_code, 2)
```

Suppose:

```text
sku_code = EL123456
```

Then:

```text
LEFT(sku_code, 2)
       ↓
       EL
```

### Step 2 — Replace that prefix

```sql
REPLACE(sku_code, 'EL', 'GG')
```

Result:

```text
GG123456
```

So the complete expression:

```sql
REPLACE(sku_code, LEFT(sku_code, 2), 'GG')
```

means:

> Find the first two characters of the SKU and replace them with `GG`.

---

# 12. Why This Is Useful

This technique can be used for **data standardization**.

Suppose many SKU codes use different category prefixes:

```text
EL123456
FT234567
HK345678
ST456789
```

You may want to replace the existing prefix with a standard code:

```text
GG123456
GG234567
GG345678
GG456789
```

The query can perform this transformation for every row.

This is an example of using string functions for bulk data manipulation or standardization.

---

# 13. LOWER()

## What it does

`LOWER()` converts text to lowercase.

Example:

```sql
SELECT LOWER('BROTHER');
```

Result:

```text
brother
```

This is useful when you want text in a consistent lowercase format.

---

# 14. UPPER()

## What it does

`UPPER()` converts text to uppercase.

Example:

```sql
SELECT UPPER('brother');
```

Result:

```text
BROTHER
```

It can also be used on columns:

```sql
SELECT UPPER(category)
FROM product;
```

If the category is:

```text
Electronics
```

the output becomes:

```text
ELECTRONICS
```

---

# 15. LOWER() vs UPPER()

| Function  | Example          | Result  |
| --------- | ---------------- | ------- |
| `LOWER()` | `LOWER('Hello')` | `hello` |
| `UPPER()` | `UPPER('Hello')` | `HELLO` |

Mental shortcut:

```text
LOWER → lowercase
UPPER → uppercase
```

---

# 16. LENGTH()

## What it does

`LENGTH()` returns the number of characters in a string.

Example:

```sql
SELECT LENGTH('brother');
```

The result is:

```text
7
```

because:

```text
b r o t h e r
1 2 3 4 5 6 7
```

---

# 17. LENGTH() with a Column

You can apply `LENGTH()` to every value in a column.

For example:

```sql
SELECT length(sku_code) AS sku_code_len
FROM product;
```

This returns the length of each SKU.

The alias:

```sql
AS sku_code_len
```

makes the output easier to understand.

Example result:

| sku_code_len |
| -----------: |
|            8 |
|            8 |
|           10 |
|           12 |

---

# 18. LENGTH() in WHERE

String functions can also be used inside filtering conditions.

The source gives:

```sql
SELECT *
FROM product
WHERE length(sku_code) >= 8;
```

This means:

> Return products whose SKU code has at least 8 characters.

The process is:

```text
sku_code
   ↓
LENGTH()
   ↓
number of characters
   ↓
>= 8 ?
   ↓
YES → include row
NO  → exclude row
```

---

# 19. TRIM()

## What it does

`TRIM()` removes whitespace from the **beginning and end** of a string.

For example:

```text
"   brother   "
```

contains spaces around the word.

Using:

```sql
SELECT trim('   brother   ');
```

produces:

```text
brother
```

The surrounding spaces are removed.

---

# 20. LENGTH() vs LENGTH(TRIM())

The source demonstrates an important comparison.

First:

```sql
SELECT length('   brother   ');
```

This counts the characters, including the surrounding spaces.

Then:

```sql
SELECT length(trim('   brother   '));
```

First `TRIM()` removes the surrounding spaces.

Then `LENGTH()` counts the remaining characters.

So conceptually:

```text
'   brother   '
       ↓
     TRIM()
       ↓
   'brother'
       ↓
    LENGTH()
       ↓
       7
```

This is useful when cleaning data before processing it.

---

# 21. CONCAT()

## What it does

`CONCAT()` joins two or more values together.

Example:

```sql
SELECT concat(name, category)
FROM product;
```

Suppose:

```text
name     = Laptop
category = Electronics
```

The result conceptually becomes:

```text
LaptopElectronics
```

The strings are joined directly because no separator was provided.

---

# 22. CONCAT() with Multiple Columns

You can combine several columns:

```sql
SELECT CONCAT(name, category, sku_code)
FROM product;
```

This joins:

```text
name
  +
category
  +
sku_code
```

into one output value.

---

# 23. CONCAT_WS()

`CONCAT_WS()` means **CONCAT With Separator**.

It allows you to specify a separator between the values.

The source gives:

```sql
SELECT concat_ws(' ', name, category, sku_code)
FROM product;
```

The first argument:

```text
' '
```

is the separator.

So instead of:

```text
LaptopElectronicsEL123456
```

you can get:

```text
Laptop Electronics EL123456
```

The spaces make the output easier to read.

---

# 24. CONCAT() vs CONCAT_WS()

This distinction is important.

### CONCAT()

```sql
SELECT CONCAT(name, category, sku_code)
FROM product;
```

Conceptually:

```text
Laptop + Electronics + EL123456
```

Result:

```text
LaptopElectronicsEL123456
```

### CONCAT_WS()

```sql
SELECT CONCAT_WS(' ', name, category, sku_code)
FROM product;
```

Conceptually:

```text
Laptop + space + Electronics + space + EL123456
```

Result:

```text
Laptop Electronics EL123456
```

So:

```text
CONCAT
→ joins values

CONCAT_WS
→ joins values using a specified separator
```

---

# 25. Complete Function Reference

| Function      | Purpose                       | Example                            |
| ------------- | ----------------------------- | ---------------------------------- |
| `LOWER()`     | Convert to lowercase          | `LOWER(name)`                      |
| `UPPER()`     | Convert to uppercase          | `UPPER(category)`                  |
| `LENGTH()`    | Count characters              | `LENGTH(sku_code)`                 |
| `TRIM()`      | Remove surrounding whitespace | `TRIM(name)`                       |
| `CONCAT()`    | Join strings                  | `CONCAT(name, category)`           |
| `CONCAT_WS()` | Join strings with separator   | `CONCAT_WS(' ', name, category)`   |
| `LEFT()`      | Extract from beginning        | `LEFT(sku_code, 2)`                |
| `RIGHT()`     | Extract from end              | `RIGHT(sku_code, 2)`               |
| `SUBSTRING()` | Extract a specific section    | `SUBSTRING(sku_code FROM 1 FOR 2)` |
| `REPLACE()`   | Replace text                  | `REPLACE(name, 'old', 'new')`      |

---

# 26. Practical Code Examples

## 1. Find products with SKU length >= 8

```sql
SELECT *
FROM product
WHERE length(sku_code) >= 8;
```

### Meaning

Only products whose SKU contains at least 8 characters are returned.

---

## 2. Display SKU length

```sql
SELECT length(sku_code) AS sku_code_len
FROM product;
```

### Meaning

Calculate the character count of every SKU.

---

## 3. Extract characters using SUBSTRING()

```sql
SELECT substring('Brother in arms', 3, 4);
```

### Meaning

Extract a specific section of the given string starting from the specified position.

---

## 4. Get the first 7 characters

```sql
SELECT left('Brother Arms', 7);
```

### Result

```text
Brother
```

---

## 5. Get the last 2 characters

```sql
SELECT right('Brother arms', 2);
```

### Result

```text
ms
```

---

## 6. Join name and category

```sql
SELECT concat(name, category)
FROM product;
```

### Meaning

Combine the two values into one string.

---

## 7. Join values with spaces

```sql
SELECT concat_ws(' ', name, category, sku_code)
FROM product;
```

### Meaning

Combine the values using a space as the separator.

---

## 8. Measure a string containing spaces

```sql
SELECT length('   brother   ');
```

This counts the entire string, including the surrounding whitespace.

---

## 9. Remove whitespace before measuring

```sql
SELECT length(trim('   brother   '));
```

Here:

```text
TRIM()
  ↓
remove surrounding spaces
  ↓
LENGTH()
  ↓
count remaining characters
```

---

## 10. Replace SKU prefixes

```sql
SELECT name,
       replace(sku_code, left(sku_code, 2), 'GG')
FROM product;
```

### Meaning

Take the first two characters of each SKU and replace them with `GG`.

---

# 27. Combining String Functions

One of the most important ideas in this module is that functions can be **nested**.

For example:

```sql
REPLACE(
    sku_code,
    LEFT(sku_code, 2),
    'GG'
)
```

There are actually two functions here:

```text
LEFT()
   ↓
find first two characters
   ↓
REPLACE()
   ↓
replace those characters with GG
```

Similarly:

```sql
LENGTH(TRIM('   brother   '))
```

has two functions:

```text
TRIM()
   ↓
remove surrounding spaces
   ↓
LENGTH()
   ↓
count characters
```

This pattern is common in SQL:

> **One function can be used as the input to another function.**

---

# 28. String Functions + WHERE

String functions aren't limited to the `SELECT` section.

They can also be used for filtering.

Example:

```sql
SELECT *
FROM product
WHERE LENGTH(sku_code) >= 8;
```

Here:

```text
LENGTH()
```

is used inside:

```text
WHERE
```

This lets you filter data based on properties of the text itself.

---

# 29. String Functions + SELECT

They can also be used to transform output.

For example:

```sql
SELECT UPPER(category)
FROM product;
```

The stored category isn't necessarily changed.

The query simply displays the category in uppercase.

Similarly:

```sql
SELECT LEFT(sku_code, 2)
FROM product;
```

extracts part of the SKU for the output.

---

# 30. String Functions for Data Cleaning

Some string functions are particularly useful when dealing with messy data.

For example:

```text
"   Brother   "
```

could contain unwanted whitespace.

Using:

```sql
TRIM()
```

gives:

```text
"Brother"
```

Then:

```sql
UPPER()
```

could convert it to:

```text
"BROTHER"
```

So functions can be combined:

```sql
SELECT UPPER(TRIM(name))
FROM product;
```

Conceptually:

```text
Original text
     ↓
   TRIM()
     ↓
Remove surrounding spaces
     ↓
   UPPER()
     ↓
Convert to uppercase
     ↓
Clean standardized output
```

---

# 31. Common Mistakes / Gotchas

## 1. Confusing LEFT() and RIGHT()

```sql
LEFT(value, 2)
```

takes characters from the beginning.

```sql
RIGHT(value, 2)
```

takes characters from the end.

Remember:

```text
LEFT  → beginning
RIGHT → end
```

---

## 2. Confusing `_` from LIKE with string functions

The `_` wildcard from `LIKE` means:

```text
Exactly one character
```

It is different from:

```sql
LEFT()
RIGHT()
SUBSTRING()
```

Those are functions used to explicitly extract text.

---

## 3. Forgetting that LENGTH() counts whitespace

For:

```text
'   brother   '
```

the surrounding spaces are characters too.

Therefore:

```sql
LENGTH('   brother   ')
```

is different from:

```sql
LENGTH(TRIM('   brother   '))
```

The second first removes the surrounding whitespace.

---

## 4. CONCAT() does not automatically add spaces

This:

```sql
CONCAT(name, category)
```

joins the values directly.

If you need a separator, use:

```sql
CONCAT_WS(' ', name, category)
```

---

## 5. Understanding REPLACE()

This:

```sql
REPLACE(source, old, new)
```

means:

```text
source
 ↓
find old
 ↓
replace with new
```

It isn't simply "change the first characters."

The source's SKU example specifically uses `LEFT()` to identify the prefix that should be replaced.

---

# 32. Interview-Level Understanding

### Q: What is a string function?

A SQL function that operates on text values to extract, transform, clean, measure, combine, or replace strings.

---

### Q: What is the difference between LEFT(), RIGHT(), and SUBSTRING()?

```text
LEFT()
→ beginning

RIGHT()
→ end

SUBSTRING()
→ specific position and length
```

---

### Q: What does TRIM() do?

It removes whitespace from the beginning and end of a string.

---

### Q: What is the difference between CONCAT() and CONCAT_WS()?

```text
CONCAT()
→ joins strings directly

CONCAT_WS()
→ joins strings using a specified separator
```

---

### Q: How can you find SKUs having at least 8 characters?

```sql
SELECT *
FROM product
WHERE LENGTH(sku_code) >= 8;
```

---

### Q: How can you replace the first two characters of every SKU with `GG`?

```sql
SELECT name,
       REPLACE(sku_code, LEFT(sku_code, 2), 'GG')
FROM product;
```

The important idea is that `LEFT()` identifies the prefix and `REPLACE()` substitutes it.

---

# 33. Key Takeaways

* String functions are used to manipulate and analyze text.
* `SUBSTRING()` extracts text from a specific position.
* `LEFT()` extracts characters from the beginning.
* `RIGHT()` extracts characters from the end.
* `REPLACE()` substitutes matching text with new text.
* `LOWER()` converts text to lowercase.
* `UPPER()` converts text to uppercase.
* `LENGTH()` counts characters.
* `TRIM()` removes whitespace from the beginning and end.
* `CONCAT()` joins multiple values.
* `CONCAT_WS()` joins values using a specified separator.
* String functions can be used in `SELECT` and `WHERE`.
* Functions can be nested inside other functions.
* `LENGTH(TRIM(...))` is an example of nested functions.
* `REPLACE(sku_code, LEFT(sku_code, 2), 'GG')` combines `LEFT()` and `REPLACE()` to standardize SKU prefixes.
* String functions are useful for **data extraction, cleaning, transformation, and standardization**.

---

# 34. One-Minute Revision

```text
LOWER()
→ lowercase

UPPER()
→ uppercase

LENGTH()
→ character count

TRIM()
→ remove surrounding whitespace

CONCAT()
→ join strings

CONCAT_WS()
→ join strings with separator

LEFT()
→ take characters from beginning

RIGHT()
→ take characters from end

SUBSTRING()
→ take characters from a specific position

REPLACE()
→ find and replace text
```

### Most important examples

```sql
SELECT *
FROM product
WHERE LENGTH(sku_code) >= 8;
```

→ Products whose SKU has at least 8 characters.

```sql
SELECT LENGTH(sku_code) AS sku_code_len
FROM product;
```

→ Length of every SKU.

```sql
SELECT LEFT('Brother Arms', 7);
```

→ First 7 characters.

```sql
SELECT RIGHT('Brother arms', 2);
```

→ Last 2 characters.

```sql
SELECT CONCAT(name, category)
FROM product;
```

→ Join name and category.

```sql
SELECT CONCAT_WS(' ', name, category, sku_code)
FROM product;
```

→ Join values using spaces.

```sql
SELECT LENGTH(TRIM('   brother   '));
```

→ Remove surrounding whitespace, then count characters.

```sql
SELECT name,
       REPLACE(sku_code, LEFT(sku_code, 2), 'GG')
FROM product;
```

→ Replace each SKU's first two characters with `GG`.

---

# 35. Minimal Self-Test

1. What are SQL string functions?
2. What does `SUBSTRING()` do?
3. What does `LEFT()` do?
4. What does `RIGHT()` do?
5. What is the difference between `LEFT()` and `SUBSTRING()`?
6. What does `REPLACE()` do?
7. What does `LOWER()` do?
8. What does `UPPER()` do?
9. What does `LENGTH()` return?
10. What does `TRIM()` remove?
11. What is the difference between `CONCAT()` and `CONCAT_WS()`?
12. Why would you use `CONCAT_WS(' ', ...)` instead of `CONCAT()`?
13. Write a query to find products whose SKU length is at least 8.
14. Write a query to display the length of every SKU.
15. Write a query to extract the first two characters of every SKU.
16. Write a query to extract the last two characters of every SKU.
17. What happens when `LENGTH()` is applied before and after `TRIM()`?
18. Explain how `REPLACE(sku_code, LEFT(sku_code, 2), 'GG')` works step by step.
19. Give an example where string functions can help clean database data.
20. Explain how multiple SQL string functions can be nested together.
