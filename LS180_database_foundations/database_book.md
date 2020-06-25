## SQL Basics

Selecting columns: 
`SELECT column_name FROM table_name;`

Selecting rows:
`SELECT * FROM table_name WHERE id = 1;`
with `id = 1` being some condition that holds true for the rows we select.

*Note: the `=` in the SQL query above is an **equality operator**.*

### Sub-languages of SQL

Data Definition Language (DDL): allows us to CRUD schema

Data Maniuplation Language (DML): allows us to CRUD data

Data Control Language (DCL): concerned with db permissions 

### Data vs Schema

Schema is concerned with the *structure* of a database. 
- The structure is defined by things such as:
  - the names of tables and columns, 
  - data types and constraints of columns.

Data is concerned with the *contents* of a database. 
- i.e. actual values in specific rows and columns in the database table


# Your First Database: Schema

*Setting the stage for how we store data, format of storage, format to expect upon retrival...*

## Create, View (and Delete) Databases

**Creating Databases**

From terminal: 
1. Create a database called 'sql_book': `createdb sql_book`
  - this command provided by `psql` acts as a wrapper around actual SQL syntax and is only accesible in terminal
2. Connect to database with `psql` console: `psql -d sql_book`

Within `psql` console:
1. Create a database: `CREATE DATABASE database_name;`
  - Within `psql`, we must use SQL to manipulate databases

**Connecting and Viewing Databases**

Within `psql` console:
- `\c another_database`: connect to another_database
- `\list`: Show current list of databases

**Deleting Databases**

From terminal:
- `dropdb another_database`: deletes another_database

Within `psql` console:
- `DROP DATABASE another_database;`: deletes another_database

**Arranged by command type:**

PSQL Command:
- `\l` or `\list`
- `\c db_name` or `\connect db_name`
- `\q`

Terminal Command:
- `psql -d db_name`
- `createdb db_name`
- `dropdb db_name`

SQL Statement:
- `CREATE DATABASE db_name`
- `DROP DATABASE db_name`


## Create, View (and Delete) Tables

### Table Creation Syntax

``` SQL
CREATE TABLE table_name (
  column_1_name column_1_data_type [constraints, ...],
  column_2_name column_2_data_type [constraints, ...],
  .
  .
  .
  table_constraints
);
```

### Data Types

- serial: integers that autoincrement (with special constraint) and can't be null
- char(N): fills all unused char with space chars
- varchar(N): remaining string length not used
- boolean:
- integer or INT:
- decimal(precision, scale):
  - precision: total num digits in entire number
  - scale: num digits to right of decimal point
- timestamp: in YYYY-MM-DD HH:MM:SS format
- date

### Keys and Constraints

Keys and Constraints are rules that define what data values are allowed in certain columns
- an important database concept
- part of a database's schema definition
- ensures that the data within a db is reliable and maintains its integrity

Constraints can apply to a specific column, an entire table, more than one table, or the entire schema!

Constraints:
- `UNIQUE`
- `NOT NULL`
- `DEFAULT default_value`

### View Table

Commands relating to db schema (not data):
- `\dt` meta-command shows us a list of all tables (or relations) in the db
- `\d table_name` lets us see the structure of table_name table

### Schema and DCL

DCL: the 'security' of a db; concerned with controlling who's allowed to perform certain actions within a db

When we look up table information with `\dt`, we see `Schema`, `Name`, `Type`, `Owner`.

We can use DCL to allow or restrict access to certain parts of the db or specific tables. Different users can have different permissions in the db.


## Alter Table

Data Definition Language (DDL) provides a way for us to make changes to db tables' definitions.

### Alter Table Syntax

The basic format of an `ALTER TABLE` statement is:
``` SQL
ALTER TABLE table_to_change HOW_TO_CHANGE_THE_TABLE additional arguments
```

Renaming a table: `ALTER TABLE users RENAME TO all_users;`

Renaming a column: `ALTER TABLE all_users RENAME COLUMN username TO full_name;`

Changing a column's datatype: `ALTER TABLE all_users ALTER COLUMN full_name TYPE varchar(25);`

*Side note*: When converting data types, if there's no implicit conversion from the old type to new type we need at add a `USING` clause:
```
ALTER COLUMN column_name
TYPE new_data_type
USING column_name::new_data_type
```

Adding a column constraint: `ALTER TABLE table_name ALTER COLUMN column_name SET constraint clause`

Adding table constraint: `ALTER TABLE table_name ADD CONSTRAINT constraint_name constraint clause`

Removing both column and table constraint: `ALTER TABLE table_name DROP CONSTRAINT constraint_name`

Removing DEFAULT clause: `ALTER TABLE all_users ALTER COLUMN id DROP DEFAULT;`

*Note on constraints*: With all other actions unrelated to constraints, we alter the existing definition to make changes. With constraints, we simply *add or remove* them from the column definition.

Add column: `ALTER TABLE all_users ADD COLUMN last_login timestamp NOT NULL DEFAULT NOW();`

Remove column: `ALTER TABLE all_users DROP COLUMN active?`

Drop table: `DROP TABLE all_users;`


# Your First Database: Data

## Inserting Data into a Table

### Data and DML

Data Manipulation Language: used to write data manipulation statements used for accessing and manipulating data in dbs. 

There are four types of data manipulation statements:
- `INSERT`: add new data into db table
- `SELECT`: a.k.a. Queries; retrieve existing data from db tables
- `UPDATE`: update existing data in db table
- `DELETE`: delete existing data from db table

The actions performed by these four types of statements are CRUD operations.

### Insertion Statement Syntax

Three pieces of info required:
1. table name
2. names of columns we're adding to
3. values we wish to store in the columns 

``` SQL
INSERT INTO table_name (column1_name, column2_name, ...)
  VALUES (data_for_column1, data_for_column2, ...);
```

### Adding Rows of Data

Columns give structure to the table, rows actually contain the data. Each row is an individtual entity - a record.

``` SQL
INSERT INTO users (full_name, enabled)
  VALUES ('Puppi Pupperooni', true);
```

#### Adding Multiple Rows

``` SQL
INSERT INTO users (full_name, enabled)
  VALUES ('Puppi Pupperooni', true), 
  ('Hercules Cat', false);
```

### Constraints and Adding Data

#### Default Values

Default values are used when a value isn't specified in the `INSERT` statement.

#### NOT NULL Constraints

`NOT NULL` constraints ensure a value is specified for that column on record insertion. If not, we get the following response:
``` SQL
ERROR:  null value in column "full_name" violates not-null constraint
DETAIL:  Failing row contains (1, null, f, 2017-10-18 12:20:02.067639).
```

#### Unique Constraints

Self-explanatory? Is the hope...

#### CHECK Constraints

Check constraints limit the type of data that can be included in a column based on some condition we set in the constraint. 

To add a `CHECK` constraint to our `users` table:
``` SQL
ALTER TABLE users ADD CHECK (full_name <> '');
```
This check should prevent empty space values in the full_name column.

The `<>` operator in SQL: is a 'not equal to'.  


## Select Queries

### Select Query Syntax

``` SQL
SELECT [*, (column_name1, column_name2, ...)]
FROM table_name WHERE (condition);
```

The format above is a straightforward `SELECT` statement. The statement is very flexible and can be used with a number of different clauses. 

The three parts above are:
- column list
- table name
- `WHERE` clause

A note on `SELECT` query:
- columns returned in order specified in query, not in table

**Identifiers and Keywords**

In a SQL statement like `SELECT age, full_name FROM users;` 
- identifiers: `age`, `full_name`, and `users`
- keywords: `SELECT`, `FROM`

If, for whatever reason, you need to name an identifier the same name as a keyword, putting it in double quotes ("") will tell SQL it's an identifier.

### ORDER BY

`ORDER BY column_name`: Another clause used in a `SELECT` query.
  - `ASC` or `DESC`: specify ascend or descend

``` SQL
SELECT [*, (column_name1, column_name2, ...)]
  FROM table_name WHERE (condition)
  ORDER BY column_name;
```

*Side notes*: 
- when ordering by booleans, `false` comes before `true`
- when ordering with the same value in column, order within those rows is arbitrary 

### Operators

Operators are usually used in the `WHERE` clause. These operators can be grouped for:

**Comparison:**

- `<>` and `!=`: not equal to
- `<` and `>`: less than and greater than

There are *comparison predicates* - like operators with special syntax.
  - `BETWEEN`
  - `NOT BETWEEN`
  - `IS DINSTINCT FROM`
  - `IS NOT DISTINCT FROM`
  - `IS NULL`
  - `IS NOT NULL`

*Note on `NULL`:* `NULL` represents an **unknown value**. So when we want to use it in a comparison, we must use the `IS NULL` predicate
  `SELECT * FROM my_table WHERE my_column IS NULL;` 

**Logical:**

Three logical operators: `AND`, `OR`, `NOT`

Example:
`SELECT * FROM users WHERE full_name = 'Harry Potter' OR enabled = 'false';`

**String Matching:**

Example:
`SELECT * FROM users WHERE full_name LIKE '%Smith';`
- `LIKE` operator: 
- `%Smith` character: Match all users that have a full name with any number of characters followed by 
  - `_` can also be used as a wild card

- `SIMILAR TO`: Works like `LIKE` except that it compares the target column to a Regex pattern


## More on Select

- Introduce processing data with functions
- Explore how data can be grouped together based on various criteria

### LIMIT and OFFSET

So far, `SELECT` statements have returned *all* of the results that atch the conditions of the statement.

`LIMIT` and `OFFSET` clauses of `SELECT` are the base on which we can use pagination to display limited results. 

Example:
`SELECT * FROM users LIMIT 1;`
Limits the retunred records to 1

Example:
`SELECT * FROM users OFFSET 1`
Skips the first row and returns the rest

### DISTINCT

Deal with duplication using the `DISTINCT` qualifier. 

Example:
`SELECT DISTINCT full_name FROM users;`

### Functions

Most common functiontypes:
- String
- Date/Time
- Aggregate

**String Functions:** perform some sort of operation on values whose data type is String

Examples:
- `length(column_name)`
  - ex: `SELECT length(full_name) FROM users;`
- `trim(args)`
  - ex: `SELECT trim(leading ' ' from full_name) FROM users;`

**Date/Time Functions:** perform operations on Date/Time functions

Examples:
- `date_part`
  - ex: `SELECT full_name, date_part('year', last_login) FROM users;`
- `age`
  - ex: `SELECT full_name, age(last_login) FROM users;`

**Aggregate Functions:** perform aggregation (i.e. return a single result from a set of input values)

Examples:
- `count`
  - ex: `SELECT count(id) FROM users;`
- `sum`
  - ex: `SELECT sum(id) FROM users;`
- `min`
  - ex: `SELECT min(last_login) FROM users;`
- `max`
  - ex: `SELECT max(last_login) FROM users;`
- `avg`
  - ex: `SELECT avg(id) FROM users;`

Aggregate functions start to be useful when grouping table rows together. We do that by using the `GROUP BY` clause.

### GROUP BY

Example:
``` SQL
sql_book=# SELECT enabled, count(id) FROM users GROUP BY enabled;
 enabled | count
---------+-------
 f       |     1
 t       |     4
(2 rows)
```


## Update Data in a Table

### Updating Data

``` SQL
UPDATE table_name SET [column_name1 = value1, ...]
WHERE (expression);
```
Without the `WHERE` clause, PostgreSQL will update *every* row. 

### Deleting Data

To delete specific rows that match the expression:
``` SQL
DELETE FROM table_name WHERE (expression);
```

To delete all rows from a table:
``` SQL
DELETE FROM users;
```

### Update vs. Delete

Key differences to keep in mind:
- `UPDATE` can update one or more columns wihin one or more rows using the `SET` clause
- `DELETE` can only delete one or more entire rows, not pieces of data in the rows

We cannot delete specific values within a row but we can use `NULL` to approximate it.


# Working With Multiple Tables

## Table Relationships

In this section, we look at:
- why databases have multiple tables
- how to define relationships between different tables
- outline the different types of table relationships that can exist

### Normalization

**Def'n Normalization.** The process of splitting up data between tables and creating relationships between tables to remove duplication and improve data integrity. 

*'Normal forms'* are the complex set of rules which dictate the extent to which a database is judged to be normalized. These rules are beyond the scope of the book, but we need to know two things:
1. The *reason* for normalization is to reduce data redundancy and improve data integrity
2. The *mechanism* for carrying out normalization is arranging data in multiple tables and defining relationships between them.

### Database Design

At a high level, the process of database design involves:
- defining **entities** to represent different sorts of data
- designing **relationships** between those entities

**Entities** represent real world objects or sets of data that we want to model within our database. Usually they're major nouns of the system.

**Relationships**:

An example of an **Entity Relationship Diagram (ERD)** using *crow's foot notation*:
![ERD](https://d186loudes4jlv.cloudfront.net/sql/images/table_relationships/simple-erd-fixed.png)

### Keys

To actually implement the tables and relationships between tables, we need to use *keys*. 

**Def'n Keys.** Keys are special type of constraint used to establish relationships and uniqueness. 

**Primary keys** refer to a specific row within the current data. To be a unique identifier, the column must have a value (i.e. `NOT NULL` constraint) and be unique (i.e. `UNIQUE` constraint). 

**Foreign keys** allow us to associate a row in one table to a row in another table. 

To create this relationship, we use the `REFERENCES` keyword:
`FOREIGN KEY (fk_col_name) REFERENCES target_table_name (pk_col_name)`

By setting up this reference, we're ensuring the *referntial integrity* of a relationship. 
- Referential integrity: the assurance that a column value within a record must reference an existing value.

### One-to-One

A one-to-one relationship exists between two entitues when a particular entity instance exists in one table and can have only one associated entity instance in another table.

``` SQL
-- creating a one-to-one relationship between users and addresses

CREATE TABLE addresses (
  user_id int, -- Both a primary and foreign key
  street varchar(30) NOT NULL,
  city varchar(30) NOT NULL,
  state varchar(30) NOT NULL,
  PRIMARY KEY (user_id),
  FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
);
```

### Referential Integrity

Referential integrity is a concept used when discussing relational data which state the table relationships must always be consistent. 

... 

### One-to-Many

### Many-to-Many

### Summary


## SQL Joins

When data is split across tables, we first have to **join** those tables together before we can select the data we need.

### What is a SQL Join?

JOINs are clauses in SQL statements that link two tables together, usually based on the keys that define the relationship between those two tables. 

### Join Syntax

``` SQL
SELECT table_1.col_name_1, table_1.col_name_2, table_2.col_name_x FROM
  table_1 join_type JOIN table_2 ON
  table_1.pk = table_2.fk;
```

To join a table to another, we need to know the following info:
- name of first table to join
- type of join to use (before `JOIN` keyword)
- name of second table to join
- join condition (following `ON` keyword)
  - defines the logic by which a row in one table is joined to a row in another table (usually primary key of one table and foreign key of other table)

### Types of Joins

**INNER JOIN**: returns a result set that contains the common elements of the tables (i.e. the intersection where they match on the joined condition). 

**LEFT JOIN** (i.e. LEFT OUTER JOIN): Takes all the rows from one table defined as the `LEFT` table and joins it with a second table. The `JOIN` is based on the conditions supplied in the parentheses. 

Note: `LEFT JOIN` will always include all rows from the `LEFT` table, even if there's no matchng row in the table it is JOINed with.

``` SQL
SELECT users.*, addresses.*
FROM users
LEFT JOIN addresses
ON (users.id = addresses.user_id);
```

**RIGHT JOIN**: Similar to LEFT JOIN, only it includes all the rows from the second table (i.e. `addresses` in the example above, not `users`).

**FULL JOIN**: Contains all rows from both tables. Where the join condition is met, the rows of the two tables are joined. Otherwise, the columsn for the other table are filled with `NULL` values.

**CROSS JOIN**: Every possible combination of all rows from both tables (the cross product). No `ON` clause is required.

`SELECT * FROM users CROSS JOIN addresses;`

### Multiple Joins

To join multiple tables in this way, there must be a logical relationship between the tables involved. 

When joining more than two tables, we just add additional `JOIN` clauses to your `SELECT` statement. 

``` SQL
SELECT users.full_name, books.title, checkouts.checkout_date
FROM users
INNER JOIN checkouts ON (users.id = checkouts.user_id)
INNER JOIN books ON (books.id = checkouts.book_id);
```

### Aliasing

Aliasing allows us to specify another name for a column or table and then use that name in later parts of a query to allow for more concise syntax.

Rewriting the previous query with aliasing:
``` SQL
SELECT u.full_name, b.title, c.checkout_date
FROM users AS u
INNER JOIN checkouts AS c ON (u.id = c.user_id)
INNER JOIN books AS b ON (b.id = c.book_id);
```

Aliasing isn't only for shortening queries. We can also use it to display more meaningful information in our results table. (So rename columns.)

### Subqueries

Imagine executing a `SELECT` query and then using the results of that first SELECT query as a condition in another `SELECT` query.

This is called nesting. The query that is nested is referred to as a **subquery**. 

``` SQL
SELECT u.full_name FROM users u
WHERE u.id NOT IN (
  SELECT c.user_id FROM checkouts c
);
```

*Subquery expressions*: PostgreSQL provides a number of expressions that can be used specifically with sub-queries: `IN`, `NOT IN`, `ANY`, `SOME`, and `ALL`

In some situations, a subquery can be used as an alternative to a join.

We can rewrite the query example above as a JOIN:
``` SQL
SELECT u.full_name FROM users u
LEFT JOIN checkouts c ON (u.id = c.user_id)
WHERE c.user_id IS NULL;
```

In general, JOINs are faster to run than subqueries.

### Summary