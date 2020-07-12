# Schema, Data, and SQL

### What to Focus On

- Learn the SQL and relational database features metnioned in this lesson
- Spend some time with parts of the documentation
- Learn the difference between data and schema

## The SQL Language

**Def'n SQL.** A language used to manipulate the structure and values of datasets stored in a relational database.
- Is a *special purpose language*: only used to interact with relational databases
- Is (mostly) a **declarative language**: describe what needs to be done, but no details on how to accomplish the objective

SQL contains three sub languages:

**Data Definition Language (DDL)**: relation structure and rules 
- allows user to create and modify 
  - the schema (structure?) stored within the database
  - the rules that govern the data held within 
- ex: `CREATE`, `DROP`, `ALTER`

**Data Manipulation Language (DML)**: values stored within relations 
- allows user to retrieve or modify data stored in the db
- ex: `SELECT`, `INSERT`, `UPDATE`, `DELETE`

**Data Control Language (DCL)**: permissions 
- controls the rights and access roles of users interacting with the db or table
  - ex: if you have read-only access, you can only use `SELECT` statements
- ex: `GRANT`

### Syntax

SQL is made up of **statements**. A statement is terminated by a semicolon (and composed of expressions???)

**Expressions** in SQL can make use of operators and functions. 

### Notes from exercises

1. Write the following values as quoted string values that could be used in a SQL query.
`canoe` | `a long road` | `weren't` | `"No way!"`

Answer: `'canoe'` | `'a long road'` | `'weren''t'` | `'"No way!"'`

2. What operator is used to concatenate strings

Answer: `||`

3. What function returns a lowercased version of a string? Write a SQL statement using it.

Answer: `lower()` with the query: `SELECT lower('AlPhAbEt');`

4. How does the `psql` console display true and false values? 

Answer: `t` and `f`


## Assignment: SQL Fundamentals - DML, DDL, and DCL

The two other sublanguages are data manipulation language (DML) and data definition language. 

Data Manipulation Language allows us to create, read, update, and delete the data values within our database with expressions such as `SELECT` or `INSERT`. 

Data Definition Language allows us to create and modify the schema (structure) of our database, as well as the rules that govern the data populating the db. Expressions include `CREATE` or `DROP`.

Some other terminology: 
- alter data definitions

`CREATE SEQUENCE `: this statement modifies the characteristics and attributes of a database by adding a sequence object to the db structure. In this regard, it's part of DDL. The sequence object it creates is a bit of data used to keep track of a sequence of automatically generated values.


## SQL Style Guide

Find it [here](https://www.sqlstyle.guide/).


## PostgreSQL Data Types

We'll focus on the types found in this [table](https://launchschool.com/lessons/a1779fd2/assignments/83481591).

### `NULL`

`NULL` is a special value that represents nothing (i.e. the absence of any other value).

When a `NULL` value appears on either side of any ordinary comparison operator, the operator will return `NULL` instead of `true` or `false`.
``` SQL
sql-course=# SELECT NULL = NULL;
--  ?column?
-- ----------

-- (1 row)
```

When dealing with `NULL` values, always use the `IS NULL` or `IS NOT NULL` constructs. For example:

``` SQL
sql-course=# SELECT NULL IS NULL;
--  ?column?
-- ----------
--  t
-- (1 row)

sql-course=# SELECT NULL IS NOT NULL;
--  ?column?
-- ----------
--  f
-- (1 row)
``` 

### Practice Problems:

1. Difference between `varchar` and `text` data types?

Both store textual data. However, `varchar(n)` shores up to `n` characters while text columns store an unlimited number of characters.

2. Difference between `integer`, `decimal`, `real` data types? 

- `integer`: non-fractional numbers
- `real`: floating-point numbers including fractional values
- `decimal`: can contain non-floating point fractional values with a limited precision

3. Largest value stored in an `integer` column?

2147483647

4. Can a time with a time zone be stored in a column of type `timestampe`?

No. But there is a `timestamp with time zone` (or `timestamptz`) data type that will store a timestamp with a timezone.


## Working with a Single Table

1. Write a SQL statement that will create the following table, `people`.

2. Write SQL statements to insert the data shown in #1 into the table. 

3. Write 3 SQL queries that can be used to retrieve the second row of the table shown in #1 and #2.

Answer for 1, 2, 3:
``` SQL
-- 1. Create table
CREATE TABLE people (
  name varchar(255),
  age integer,
  occupation varchar(255)
);

-- 2. Insert data
INSERT INTO people (name, age, occupation)
VALUES ('Abby', 34, 'biologist'), 
       ('Mu''nisah', 26, NULL),
       ('Mirabelle', 40, 'contractor');

-- 3. SQL queries (3x) to be used to retrieve the second row of the table
SELECT * FROM people WHERE name = 'Mu''nisah';
SELECT * FROM people WHERE age = 26;
SELECT * FROM people WHERE occupation IS NULL;
```


4. Write a SQL statement that will create a table named birds that can hold the following values.

5. Using the table created in #4, write the SQL statements to insert the data.

6. Write an SQL statement that finds the names and families for all birds that are not extinct in order from longest to shortest.

7. Use SQL to determine the average, minimum and maximum wingspan for the birds shown in the table.

Answer for 4, 5, 6:
``` SQL
-- 4. Create table
CREATE TABLE birds (
  name varchar(255),
  length decimal(4, 1),
  wingspan decimal(4, 1),
  family varchar(255),
  extinct boolean
);

-- 5. Insert data
INSERT INTO birds VALUES ('Spotted Towhee', 21.6, 26.7, 'Emberizidae', false);
INSERT INTO birds VALUES ('American Robin', 25.5, 36.0, 'Turdidae', false);
INSERT INTO birds VALUES ('Greater Koa Finch', 19.0, 24.0, 'Fringillidae', true);
INSERT INTO birds VALUES ('Carolina Parakeet', 33.0, 55.8, 'Psittacidae', true);
INSERT INTO birds VALUES ('Common Kestrel', 35.5, 73.5, 'Falconidae', false);

-- 6. SQL query
SELECT name, family FROM birds 
  WHERE extinct=false
  ORDER BY length DESC;

-- 7. Avg, min, max wingspan
SELECT round(avg(wingspan), 1), min(wingspan), max(wingspan) FROM birds;
```


8. Write a SQL statement to create the table shown below, `menu_items`.

9. Write SQL statements to insert the data shown in #8 into the table.

10. Write a SQL query to determine which menu item is the most profitable based on the cost of its ingredients, returning the name of the item and its profit.

11. Write a SQL query to determine how profitable each item on the menu is based on the amount of time it takes to prepare. Assume that whoever is preparing the food is being paid $13 an hour. List the most profitable items first. Keep in mind that prep_time is represented in minutes and ingredient_cost and menu_price are in dollars and cents):

``` SQL
-- 8. Create table
CREATE TABLE menu_items (
  item text,
  prep_time integer,
  ingredient_cost decimal(5, 2),
  sales integer,
  menu_price decimal(4, 2)
);

-- 9. Insert data
INSERT INTO menu_items (item, prep_time, ingredient_cost, sales, menu_price)
VALUES ('omelette', 10, 1.50, 182, 7.99),
       ('tacos', 5, 2.00, 254, 8.99),
       ('oatmeal', 1, 0.50, 79, 5.99);

-- 10. SQL query for most profitable
SELECT item, menu_price - ingredient_cost AS profit FROM menu_items ORDER BY profit DESC LIMIT 1;
-- The following DOES NOT work
-- SELECT item, max(menu_price - ingredient_cost) FROM menu_items;

-- 11. SQL query for profitable by time
SELECT item, menu_price, ingredient_cost,
       round(prep_time/60.0 * 13.0, 2) AS labor,
       menu_price - ingredient_cost - round(prep_time/60.0 * 13.0, 2) AS profit
  FROM menu_items
  ORDER BY profit DESC;
```


## Loading Database Dumps

There are two ways to load SQL files into a PostgreSQL database. 

### psql

Pipe the SQL file into the `psql` program, using redirection on the command line to stream thte SQL file into `psql`'s stanrdard intput:

`$ psql -d my_database < file_to_import.sql`

This will execute the SQL statements within `file_to_import.sql` within the `my_database` db.

From within a `psql` session, you can import SQL file using the `\i` meta command:

`my_database=# \i ~/some/files/file_to_import.sql`

### Exercises

Not done yet.


## More Single Table Queries

1. Create a new database called `residents` using the PostgreSQL command line tools.

`createdb residents`

2. Load the given file into database created in #1.

`psql -d residents < residents_with_data.sql`

3. Write a SQL query to list the ten states with the most rows in the people table in descending order.

`SELECT state, COUNT(state) FROM people GROUP BY state ORDER BY count DESC LIMIT 10;`

4. Write a SQL query that lists each domain used in an email address in the `people table` and how many people in the database have an email address containing that domain. Domains should be listed with the most popular first.

`SELECT substr(email, strpos(email, '@') + 1) as domain, COUNT(id) FROM people GROUP BY domain ORDER BY count DESC;`

5. Write a SQL statement that will delete the person with ID 3399 from the people table. 

`DELETE FROM people WHERE id =  3399;`

6. Write a SQL statement that will delete all users that are located in the state of California (CA).

`DELETE FROM people WHERE state = 'CA';`

7. Write a SQL statement that will update the `given_name` values to be all uppercase for all users with an email address that contains `teleworm.us`.

`UPDATE people SET given_name = UPPER(given_name) WHERE email LIKE '%teleworm.us';`

8. Write a SQL statement that will delete all rows from the `people` table.

`DELETE FROM people;`


## NOT NULL and Default Values

Design and power of relational databases comes from defining a common set of attributes (the values of which are stored in columns). The more specific and exact the design of the schema, the neater and more consistent the data will be. Rules set by the schema designer allow users of the system to make certain assumptions about the data.

If we order a column of values with `NULL`, the `NULL` value is positioned arbitrarily (first when descending, last when ascending).

Best practice: only allow `NULL` in the database when absolutely needed. 

We can set a `NOT NULL` constraint and set a default value.

### Exercises

1. What is the result of using an operator on a NULL value?

The resulting value will also be NULL, which signifies an unknown value.

``` SQL
-- 2. Set the default value of column `department` to "unassigned". 
-- Then set the value of the department column to "unassigned" for any rows where it has a NULL value. 
-- Finally, add a NOT NULL constraint to the department column.

ALTER TABLE employees ALTER COLUMN department SET DEFAULT 'unassigned';

UPDATE employees SET department = 'unassigned' WHERE department IS NULL;

ALTER TABLE employees ALTER COLUMN department SET NOT NULL;
```

``` SQL
-- 3. Write the SQL statement to create a table called temperatures to hold the following data. Keep in mind that all rows in the table should always contain all three values.

CREATE TABLE temperatures (
  date date NOT NULL,
  low integer NOT NULL,
  high integer NOT NULL
);

-- 4. Write the SQL statements needed to insert the data shown in #3 into temperatures table.

INSERT INTO temperatures (date, low, high)
  VALUES ('2016-03-01', 34, 43),
         ('2016-03-02', 32, 44);

-- 5. Write a SQL statement to determine the average (mean) temperature -- divide the sum of the high and low temperatures by two) for each day from March 2, 2016 through March 8, 2016. Make sure to round each average value to one decimal place.

SELECT date, ROUND((high - low) / 2.0, 1) as average 
  FROM temperatures
  WHERE date BETWEEN '2016-03-02' AND '2016-03-08';

-- 6. Write a SQL statement to add a new column, `rainfall`, to the temperatures table. It should store millimeters of rain as integers an have a default value of 0.

ALTER TABLE temperatures
  ADD COLUMN rainfall integer DEFAULT 0;

-- 7. Each day, it rains one millimeter for every degree the average temperature goes above 35. Write a SQL statement to update the data in the table temperatures to reflect this.

UPDATE temperatures 
  SET rainfall = ((high - low) / 2) - 35 
  WHERE ((high - low) / 2) > 35;

-- 8. A decision has been made to store rainfall data in inches. Write the SQL statements required to modify the rainfall column to reflect these new requirements.

ALTER TABLE temperatures
  ALTER COLUMN rainfall TYPE numeric(6,3);
UPDATE temperatures 
  SET rainfall = rainfall * 0.039;

-- 9. Write a SQL statement that renames the temperatures table to weather.

ALTER TABLE temperatures RENAME TO weather;
```

11. What PostgreSQL program can be used to create a SQL file that contains the SQL commands needed to recreate the current structure and data of the weather table?

```
$ pg_dump -d sql-course -t weather --inserts > dump.sql
```

Leaving off the `--inserts` argument to `pg_dump` will still resotre talble and its data. The format will just be different: it will use a `COPY FROM stdin` statement instead of multiple `INSERT` statements. 


## More Constraints

1. Import the file `films2.sql` into a PostgreSQL database

`$ psql -d sql-course < films2.sql`

2. Modify all of the columns to be `NOT NULL`

``` SQL
ALTER TABLE films ALTER COLUMN title SET NOT NULL;
ALTER TABLE films ALTER COLUMN year SET NOT NULL;
ALTER TABLE films ALTER COLUMN genre SET NOT NULL;
ALTER TABLE films ALTER COLUMN director SET NOT NULL;
ALTER TABLE films ALTER COLUMN duration SET NOT NULL;
```

3. How does modifying a column to be NOT NULL affect how it is displayed by \d films?

`not null` will be included in that column's `Modifiers` column

4. Add a constraint to the table films that ensures that all films have a unique title.

``` SQL
ALTER TABLE films ADD CONSTRAINT title_unique UNIQUE (title);
```

5. How is the constraint added in #4 displayed by `\d films`?

It appears as an index: `Indexes: "title_unique" UNIQUE CONSTRAINT, btree (title)`

6. Write a SQL statement to remove the constriant added in #4.

`ALTER TABLE films DROP CONSTRAINT title_unique;`

7. Add a constraint to films that requires all rows to have a value for `title` that is at least 1 character long.

`ALTER TABLE films ADD CONSTRAINT title_length CHECK (length(title) >= 1);`

8. What error is shown if the constraint created in #7 is violated? Write a SQL INSERT statement that demonstrates this.

``` SQL
INSERT INTO films VALUES ('', 1901, 'action', 'JJ Abrams', 126);
-- ERROR:  new row for relation "films" violates check constraint "title_length"
-- DETAIL:  Failing row contains (, 1901, action, JJ Abrams, 126).
```

9. How is the constraint added in #7 displayed by `\d films`?

It appears as a "check constraint": `Check constraints: "title_length" CHECK (length(title::text) >= 1)`

10. Write a SQL statement to remove the constraint added in #7:

`ALTER TABLE films DROP CONSTRAINT title_length;`

11. Add a constraint to the table films that ensures that all films have a year between 1900 and 2100.

`ALTER TABLE films ADD CONSTRAINT year_range CHECK (year BETWEEN 1900 and 2100);`

12. How is the constraint added in #11 displayed by `\d films`?

It appears as a "check constraint".

13. Add a constraint to films that requires all rows to have a value for director that is at least 3 characters long and contains at least one space character ().

``` SQL
ALTER TABLE films ALTER COLUMN director SET NOT NULL;
ALTER TABLE films ADD CONSTRAINT director_length CHECK (length(director) >= 3);
```

Launch School answer:
``` SQL
ALTER TABLE films ADD CONSTRAINT director_name
    CHECK (length(director) >= 3 AND position(' ' in director) > 0);
```

14. How does the constraint created in #13 appear in `\d films`?

It's a check constraint.

15. Write an `UPDATE` statement that attempts to change the director for "Die Hard" to "Johnny". Show the error that occurs when this statement is executed.

``` SQL
UPDATE films SET director = 'Johnny' WHERE title = 'Die Hard';
-- ERROR:  new row for relation "films" violates check constraint "director_name"
-- DETAIL:  Failing row contains (Die Hard, 1988, action, Johnny, 132).
```

16. List three ways to use the schema to restrict what values can be stored in a column.

The three ways include:
- limiting the data type of the column
- adding a NOT NULL constraint
- adding a CHECK constraint

17. Is it possible to define a default value for a column that will be considered invalid by a constraint? Create a table that tests this.

It is possible to have a default value violate a constraint. For example:
``` SQL
CREATE TABLE shoes (name text, size numeric(3,1) DEFAULT 0);
ALTER TABLE shoes ADD CONSTRAINT shoe_size CHECK (size BETWEEN 1 AND 15);

-- And if we try to insert a row with the default value for size:
INSERT INTO shoes (name) VALUES ('blue sneakers');
-- ERROR:  new row for relation "shoes" violates check constraint "shoe_size"
-- DETAIL:  Failing row contains (blue sneakers, 0.0).
``` 

18. How can you see a list of all the constraints on a table?

We can use `\d tablename` to view the constraints on that table.


## Using Keys

*It's possible to have identical rows of data that represent different real-world entities. This makes updating harder.*

The solution: keys.

**Def'n Key.** A value carefully selected to uniquely identify a single row in a db table.

Two types of keys: 
(1) Natural key
(2) Surrogate key

A **natural key** is an *existing value* in a dataset that can be used to uniquely ID each row.
- A lot of values seem like they're UIDs, but they aren't reliable
- **Composite key**: 1+ existing values combined (to defer the problem of natural keys)

A **surrogate key** is a *value created solely* for uniquely identifying rows. This avoids the natural key problems.

### IDs created by the database

``` SQL
CREATE TABLE colours (id serial, name text);
-- 'id serial' above is shorthand for:
CREATE SEQUENCE colours_id_seq;
CREATE TABLE colours(
  id integer NOT NULL DEFAULT nextval('colours_id_seq'),
  name text
);
```

A **sequence** is a special kind of relation that generates a series of numbers. Once a number is returned by `nextval()` for a standard sequence, it is never returned again.

To enfore uniqueness of the `colours` table id column:
``` SQL
ALTER TABLE colours ADD CONSTRAINT id_unique UNIQUE(id);
```

**Primary Key**: PostgreSQL shortcut for creating UID columns.
``` SQL
CREATE TABLE more_colours (id int PRIMARY KEY, name text);
```

Specifying `PRIMARY KEY` ensures enforcing unique values and preventing `NULL`. Using `PRIMARY KEY` also documents design intention, that this column is the intended UID. 

**Conventions for tables and primary keys**

1. All tables have a primary key column called 'id'
2. 'id' value automatically sets unique values when row is inserted
3. 'id' column is often an integer, but there are other data types with special benefits (ex: UID)

### Exercises

Completed verbally on road trip


## GROUP BY and Aggregate Functions 

1. Import the given file: `psql -d films < films4.sql`.

2. Write SQL statements that will insert the following films into the database.

``` SQL
INSERT INTO films (title, year, genre, director, duration)
  VALUES ('Wayne''s World', 1992, 'comedy', 'Penelope Spheeris', 95),
  ('Bourne Identity', 2002, 'espionage', 'Doug Liman', 118);
```

3. Write a SQL query that lists all genres for which there is a movie in the `films` table.

``` SQL
SELECT DISTINCT genre FROM films;
```

4. Write a SQL query that returns the same result as the answer for #3 but without using `DISTINCT`.

``` SQL
SELECT genre FROM films GROUP BY genre;
```

5. Write a SQL query that determines the average duration across all the movies in the `films` table, rounded to the nearest minute. 

``` SQL
SELECT ROUND(AVG(duration)) FROM films;
```

6. Write a SQL query that determines the average duration for each genre in the `films` table, rounded to the nearest minute.

``` SQL
SELECT genre, ROUND(AVG(duration)) as average_duration 
  FROM films
  GROUP BY genre;
```

7. Write a SQL query that determines the average duration of movies for each decade represented in the `films` table, rounded to the nearest minute and listed in chronological order.

``` SQL
SELECT year / 10 * 10 as decade,
  ROUND(AVG(duration)) as average_duration
  FROM films 
  GROUP BY decade
  ORDER BY decade;
```

8. Write a SQL query that finds all films whose director has the first name `John`.

``` SQL
SELECT * FROM films WHERE director LIKE 'John %';
```

9. Write a SQL query that will return the genre with each movie count.

``` SQL
SELECT genre, count(id) FROM films GROUP BY genre ORDER BY count DESC;
```

10. Write a SQL query that will return the following data:
decade | genre | films (including all titles)

``` SQL
SELECT year / 10 * 10 AS decade, genre, string_agg(title, ', ') AS films
  FROM films GROUP BY decade, genre ORDER BY decade, genre;
```

11. Write a SQL query that will return the following data:
genre | total_duration

``` SQL
SELECT genre, SUM(duration) as total_duration FROM films GROUP BY genre ORDER BY total_duration ASC;
```


## How PostgreSQL Executes Queries  

### A Declarative Language

SQL is a declarative language: describes *what* to do, not *how* to do it. The PostgreSQL server takes each query, determines how to best execute, and returns the results.
- Simplifies db interactions for user: user only has to think about what data they want returned and in what format
- However, a negative: db sometimes executes inefficiently (because the only way to know how long execution takes is to execute)

### How PostgreSQL Executes a Query

Understanding the general high-level process helps us know 
- the difference between two queries that appear to return the same results
- why some queries are rejected by the db

Basic process for a `SELECT` query:

1. Rows collected into a virtual derived table
- the db creates a new temporary table using the data from all the tables listed in the query's `FROM` clause (includes tables used in `JOIN` clauses)

2. Rows are filtered using `WHERE` conditions

3. Rows are divided into groups (if query includes `GROUP BY` clause)

4. Groups are filtered using `HAVING` conditions
- `HAVING` conditions are similar to `WHERE` conditions. However, they are applied to values used to create groups, not individual rows
  - Thus, a column in a `HAVING` clause should almost always appear in a `GROUP BY` clause and/or an aggregate function

5. Compute values to return using select list
- each element in the select list is evaluated, including any functions
- resulting values are associated with either the column name, the name of the last function, or a name specified in the query with `AS`

6. Sort results
- Resulting set is sorted as specified in an `ORDER BY` clause. 
- If there is no `ORDER BY` clause, then rows are returned in the order they appear in the table

7. Limit results
- If `LIMIT` of `OFFSET` clauses are included in the query, these are used to adjust which rows in the result set are returned.


## Table and Column Aliases

Using aliases: refers to using the `AS` keyword to rename something that exists in the db or schema (usually column?)

Can also change the name of a table. But isn't done unless absolutely necessary.
``` SQL
SELECT f.title, f.year FROM films AS f;
```

