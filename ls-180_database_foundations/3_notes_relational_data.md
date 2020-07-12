## What to Focus On

- How to work with multiple tables using `JOIN`
- SQL has a lot of optional keywords
- Think about how schemas change over time


## What is Relational Data?

Relational databases are called **relational** because they persist data in a set of relations.

A **relation** is *usually* another way to say "table".

A **relationship** is an association between the data stored in those relations
- a connection between entities (rows of data), usually resulting from what those entities represent and how they relate to one another.

*Relation* and *relationship* are two distinct things within a database.


## Database Diagrams: Levels of Schema

Levels of schema (from least to most detail):
- *conceptual*: bigger objects and higher level concepts
  - data in a very abstract way with no worry about storing data
- *logical*: list of attributes and datatypes but not specific to a database
- *physical*: database specific implementations; may include attributes, data types, rules about entities and how they relate to each other

**Def'n Conceptual Schema.** high-level design focused on identifying entities and their relationships

**Def'n Physical Schema.** low-level database-specific design focused on implementation

**Entity-relationship model/diagram**: usually referring to a conceptual schema

*Note:* With many-to-many relationships, there is always one extra table called the join table to represent the many-to-many relationships.


## Database Diagrams: Cardinality and Modality

**Def'n Cardinality.** the number of objects on each side of the relationship (i.e. 1:1, 1:M, M:M)

**Def'n Modality.** if the relationship is required (1) or optional (0)


## A Review of JOINS

Go look at the notes on `JOIN`s from the book...

Execpt for `FULL OUTER JOIN`. This type of JOIN is sort of a combination of the `LEFT OUTER JOIN` and `RIGHT OUTER JOIN`. It basically returns all rows from both tables, with those that have no relations having `NULL` in the columns.


## Working with Multiple Tables

This section is a set of exercises. They gave us a file to import and seed our database (step 1). The database has tables: `customers`, `tickets`, `seats`, `sections`, `events`. 

2. Write a query that determines how many tickets have been sold.

Expected output: 3783

``` SQL
SELECT count(id) FROM tickets;
```

3. Write a query that determines how many different customers purchased tickets to at least one event.

Expected output: 1652

``` SQL
SELECT COUNT(DISTINCT customer_id) FROM tickets;
```

4. Write a query that determines what percentage of the customers in the database have purchased a ticket to one or more events. 

Expected output: percent: 16.52

``` SQL
SELECT COUNT(DISTINCT tickets.customer_id)
       / COUNT(DISTINCT customers.id)::float * 100 
       AS percent 
  FROM customers 
  LEFT OUTER JOIN tickets 
    ON customers.id = tickets.customer_id;
```

5. Write a query that returns the name of each event and how many tickets were sold for it, in order from most popular to least popular.

``` SQL
SELECT events.name AS name, 
       COUNT(tickets.id) AS popularity 
  FROM events 
  INNER JOIN tickets 
    ON events.id = tickets.event_id
  GROUP BY name
  ORDER BY popularity DESC;
```

6. Write a query that returns the user id, email address, and the number of events for all customers that have purchased tickets to three events. 

``` SQL
SELECT customers.id, customers.email, COUNT(DISTINCT tickets.event_id)
  FROM customers
  INNER JOIN tickets
    on tickets.customer_id = customers.id
  GROUP BY customers.id
  HAVING COUNT(DISTINCT tickets.event_id) = 3;
```

7. Write a query to print out a report of all tickets purchased by the customer with the email address 'gennaro.rath@mcdermott.co'. The report should include the event name and starts_at and the seat's section name, row, and seat number.

``` SQL
SELECT events.name AS event,
       events.starts_at,
       sections.name AS section,
       seats.row,
       seats.number AS seat
  FROM tickets
  INNER JOIN events
    ON tickets.event_id = events.id
  INNER JOIN customers
    ON tickets.customer_id = customers.id
  INNER JOIN seats
    ON tickets.seat_id = seats.id
  INNER JOIN sections
    ON seats.section_id = sections.id
  WHERE customers.email = 'gennaro.rath@mcdermott.co';
```


## Using Foreign Keys

Foreign key can refer to:
- *Foreign key column*: a column that represents a relationship between two rows by pointing to a specific row in another table using its primary key. 
- *Foreign key constraint*: a constraint that enforces certain rules about what values are permitted in these foreign key relationships.

### Creating Foreign Key Columns

Create a column that is the same type as the primary key column (i.e. the primary key is type `INTEGER`, then make that column type `INTEGER`)

### Creating Foreign Key Constraints

Two syntaxes can be used. 

1. Add a `REFERENCES` clause to the description of the column in a `CREATE TABLE` statement:
``` SQL
CREATE TABLE orders (
  id serial PRIMARY KEY,
  product_id integer REFERENCES products (id),
  quantity integer NOT NULL
);
```

2. Add the foreign key constraint separately just like any other constraint:
``` SQL
ALTER TABLE orders ADD CONSTRAINT orders_product_id_fkey FOREIGN KEY (product_id) REFERENCES products(id);
```

### Referential Integrity

A benefit of using the foreign key constraints provided by the db is to preserve *referential integrity* of the data in the db. 

The db does this by *ensuring every value in a foreign key column exists in the primary key column of the referenced table*. 

### Practice Problems

1. Import the given file. The database consists of tables `orders` and `products`.

2. Update the `orders` table so that referntial integrity will be preserved for the data between `orders` and `products`.

``` SQL
ALTER TABLE orders ADD CONSTRAINT orders_product_id_fkey FOREIGN KEY (product_id) REFERENCES products(id);
```

3. Use `psql` to insert the data shown in the following table into the database.

``` SQL
-- First insert the products needed for the order
INSERT INTO products (name)
  VALUES ('small bolt'), ('large bolt');

-- Next insert the order information
INSERT INTO orders (product_id, quantity)
  VALUES (1, 10), (1, 25), (2, 15);
```

4. Write a SQL statement that returns a result like this:

 quantity |    name
----------+------------
       10 | small bolt
       25 | small bolt
       15 | large bolt
(3 rows)

``` SQL
SELECT orders.quantity, products.name 
  FROM orders
  INNER JOIN products
    ON orders.product_id = products.id;
```

5. Can you insert a row into `orders` without a product_id? Write a SQL statement to prove your answer.

Yes, you can insert a row into `orders` without a product_id. Even though we have placed a foreign key constraint on the `orders.product_id` column, this constraint only ensures the existence of the value in the `products.id` column; it does not ensure that the value is not `NULL`. Therefore the following SQL statement will successfully insert a row with no product_id.

``` SQL
INSERT INTO orders (quantity)
  VALUES (42);
```

6. Write a SQL statement that will prevent `NULL` values from being stored in `orders.product_id`. What happens if you execute that statement?
7. Make any changes needed to avoid the error message encountered in #6. 

We can add the `NOT NULL` constraint to `orders.product_id` using the following SQL statement:
``` SQL
ALTER TABLE orders ALTER COLUMN product_id SET NOT NULL;
```
However, from the previous question the `orders.product_id` column contains a `NULL` value. To properly add this constraint, we first need to remove the last row we inserted into orders:
``` SQL
DELETE FROM orders WHERE product_id IS NULL;
```
Then we can add the `NOT NULL` constraint.

8. Create a new table called `reviews` to store the data shown below. This table should include a primary key and a refernece to the `products` table.
9. Then write SQL statements to insert the data shown.

 Product  |   Review
----------+------------
small bolt| a little small
small bolt| very round!
large bolt| could have been smaller

``` SQL
-- Create the reviews table
CREATE TABLE reviews (
  id SERIAL PRIMARY KEY,
  body text NOT NULL,
  product_id integer REFERENCES products (id)
);

-- Insert info given above
INSERT INTO reviews (body, product_id)
  VALUES ('a little small', 1), ('very round!', 1), ('could have been smaller', 2);
```

10. True or false: A foreign key constraint prevents `NULL` values from being stored in a column.

False.


## One to Many Relationships

Import the given file into a new database for this section. The database contains tables `calls` and `contacts`.

### An Not-Normalized Schema and the Anomalies We May Encounter

To understand some concepts, we'll pretend that we have only one table for calls storing the following information:
- id primary key
- when the call was made
- duration of call
- first name of contact
- last name of contact
- contact's phone number

Because this table set up will result in *duplicate data* (ex: if I call andrew twice, his name and contact info shows up twice) we can run into the *following problems*:

**Update anomaly**: If we need to update Andrew's name or phone number, we would need to update every row he appears in. It's easy to miss a row when updating, thus making the *database inconsistent* (meaning it contains more than one answer for a given question). When this occurs, we have an *update anomaly*.

**Insertion anomaly**: We can't store the information of a contact without having placed a call to them. This is an example of insertion anomaly.

**Deletion anomaly**: Likewise we lose all information about a contact if we delete the call history with them. This is an example of deletion anomaly.

### A Normalized Schema 

**Def'n Normalization.** The process of esigning schema that *minimize/eliminate the possible occurences of these anomalies*. The basic procedure of normalization involves extracting data into additional tabales and using foreign keys to tie it back to its associated data.

*Side note: denormalized.* Sometimes we want to have duplicated data (i.e. denormalized data) as it can make some retrieval operations more efficient. 

In this case, we create two tables `contacts` and `calls` to remove the duplicate data.

*Side note* If we use the following SQL statement to join the two tables, we basically get a CROSS JOIN.
`SELECT * FROM calls, contacts`

### Practice Problems

1. Write an SQL statement to add the given call data to the database.

``` SQL
INSERT INTO calls (contact_id, "when", duration)
  VALUES (6, '2016-01-18 14:47:00', 632);
```

2. Write a SQL statement to retrieve the call times, duration and first name for all calls *not* made to William Swift.

``` SQL
SELECT calls.when, calls.duration, contacts.first_name
  FROM calls INNER JOIN contacts
    ON calls.contact_id = contacts.id
  WHERE (contacts.first_name || ' ' || contacts.last_name) != 'William Swift';
```

3. Write SQL statements to add the given call data to the database.

``` SQL
INSERT INTO contacts (first_name, last_name, number)
  VALUES ('Merve', 'Elk', '6343511126'), ('Sawa', 'Fyodorov', '6125594874');

INSERT INTO calls (contact_id, "when", duration)
  VALUES (27, '2016-01-17 11:52:00', 175), (28, '2016-01-18 21:22:00', 79);
```

4. Add a contraint to `contacts` that prevents a duplicate value being added in the column `number`.

``` SQL
ALTER TABLE contacts ADD CONSTRAINT number_unique UNIQUE (number);
```

5. Write a SQL statement that attempts to insert a duplicate number for a new contact but fails. What error is shown?

The following SQL statement will try to add Merve Elk's number again. Below the statement is the resulting error message.
``` SQL
INSERT INTO contacts (first_name, last_name, number)
  VALUES ('Puppi', 'Pupperooni', '6343511126');
--ERROR:  duplicate key value violates unique constraint "number_unique"
--DETAIL:  Key (number)=(6343511126) already exists.
```

6. Why does "when" need to be quoted in many of the queries in this lesson?

"when" is a reserved word in SQL. 

Note that there are words on that list that are "non-reserved", which means they are allowed as table or column names but are known to the SQL parser as having a special meaning.

7. Draw an entity-relationship diagram for the data we've been working with in this assignment.

Calls >-0-------1-1- Contacts


## Extracting a 1:M Relationship From Existing Data

Import the given database file for this section. The database has one table `films`.

We will walk through the process of:
- separating data from a single table into two tables
- creating a foreign key to connect values that are now stored in two tables instead of one 

The current `films` table also stores director information, meaning we can only have director info with a movie and that director info is duplicated. To remedy this, we'll create a new `directors` table:
``` SQL
CREATE TABLE directors (
  id serial PRIMARY KEY, 
  name text NOT NULL
);
```

After inserting the directors' names, we'll create a relationship between the `directors` and `films` tables.
``` SQL
ALTER TABLE films ADD COLUMN director_id integer REFERENCES directors (id);
```
Then we insert the director_id values using many `UPDATE` statements:
``` SQL
UPDATE films SET director_id=1 WHERE director = 'John McTiernan';
-- do this statement for every movie/director row
```

Now we need to clean up the films table.
- Set `films.director_id` to be `NOT NULL`
`ALTER TABLE films ALTER COLUMN director_id SET NOT NULL;`
- Drop the `director` column from `films`
`ALTER TABLE films DROP COLUMN director;`
- Restore the constraint that was on the `films.director` column to the `directors.name` column:
``` SQL
ALTER TABLE directors ADD CONSTRAINT valid_name 
  CHECK (length(name) >= 1 AND position(' ' in name) > 0);
 ```

### NOT NULL or NULL

In the case above, we set the `films.director_id` to `NOT NULL` since all films have directors. 

There are other cases, however, where the value in a foreign key column can be `NULL`. This most often occurs as data changes over time.

It's usually a good idea to try to keep a table's schema restrictive in order to help preserve the integrity of the data within it. But keep in mind that the same constraints that can help ensure this integrity also limit what data is stored, and often more importantly, how data can be added and modified.


## Many to Many Relationships

**Many-to-many** relationships are those where there can be multiple instances on both sides of the relationship. You can think of them as one-to-many relationships that go from the first table to the sceond *and* from the second table to the first.

For example, we can have `books` and `genres`. A book can have multiple genres, and a genre can have multiple books.

In the schema, we have three tables: `books`, `genres`, and `books_genres`. 

The `books_genres` table is a **join table**, a table used to persist the state of many-to-many relationships. It is responsible for storing information about the relationships between specific books and categories. It would hold `book_id` and `genre_id`. 

*Should join tables include a primary key column?* It depends. The `books_genres` table does not since we can identify any row using a combination of `book_id` and `genre_id`. However, sometimes it's simpler to include a primary key column, thus treating the table as first-class entities in the system.

### Practice Problems

0. Import the given file. We have two tables: `books` and `categories`. We also see a `books_categories` join table.

1. Write a SQL statement that will return the following result:
 id |     author      |           categories
----+-----------------+--------------------------------
  1 | Charles Dickens | Fiction, Classics
  2 | J. K. Rowling   | Fiction, Fantasy
  3 | Walter Isaacson | Nonfiction, Biography, Physics
(3 rows)

``` SQL
SELECT books.id, books.author, string_agg(categories.name, ', ') AS categories
  FROM books
    INNER JOIN books_categories ON books.id = books_categories.book_id
    INNER JOIN categories ON books_categories.category_id = categories.id
  GROUP BY books.id ORDER BY books.id;
```

2. Write SQL statements to insert the following new books into the database. What do you need to do to ensure this data fits in the database?

``` SQL
-- First we need to ensure the categories for the books exist
INSERT INTO categories (name)
  VALUES ('Space Exploration'), ('Cookbook'), ('South Asia');
-- Then we insert the new books' titles and authors
INSERT INTO books (title, author)
  VALUES ('Sally Ride: America''s First Woman in Space', 'Lynn Sherr'), ('Jane Eyre', 'Charlotte Bronte'), ('Indian Cuisine', 'Meeru Dhalwala');

-- Apparently one of the titles was too long so we need to change the schema:
ALTER TABLE books ALTER COLUMN title TYPE text;

-- Then we add the id pairs for books and categories in the join table
INSERT INTO books_categories(4, 1);
...
```

3. Write a SQL statement to add a uniqueness constraint on the combination of columns `book_id` and `category_id` of the `books_categories` table. This constraint should be a table constraint; so, it should check for uniqueness on the combination of `book_id` and `category_id` across all rows of the `books_categories` table.

``` SQL
ALTER TABLE books_categories ADD UNIQUE (book_id, category_id); 
```

4. Write an SQL statement that will return the following:
      name        | book_count |                                 book_titles
------------------+------------+-----------------------------------------------------------------------------
Biography         |          2 | Einstein: His Life and Universe, Sally Ride: America's First Woman in Space
Classics          |          2 | A Tale of Two Cities, Jane Eyre
Cookbook          |          1 | Vij's: Elegant and Inspired Indian Cuisine
Fantasy           |          1 | Harry Potter
...

``` SQL
SELECT categories.name, count(books.title) AS book_count, string_agg(books.title, ', ') AS book_titles
  FROM categories
    INNER JOIN books_categories ON categories.id = books_categories.category_id
    INNER JOIN books ON books_categories.book_id = books.id
  GROUP BY categories.name ORDER BY categories.name;
```


## Converting a 1:M Relationship to a M:M Relationship

As applications grow and their requirements change, it's common for relationships to change from one type to another. 

In context of the `films` and `directors` tables. Eventually, we're going to find a movie that has more than one director, so we will have to convert the 1:M relationship to a M:M relationship. 

### Practice Problems

1. Import the given file. We have a database with `directors` and `films` with a 1:M relationship between directors and films.

2. Write the SQL statement needed to create a join table that will allow a film to have multiple directors, and directors to have multiple films. Include an `id` column in this table, and add foreign key constraints to the other columns.

``` SQL
-- note: The table is called directors_films, not films_directors because it's convention to list the part alphabetically
CREATE TABLE directors_films (
  id serial PRIMARY KEY,
  director_id integer REFERENCES directors (id),
  film_id integer REFERENCES films (id)
);
```

3. Write the SQL statements needed to insert data into the new join table to represent the existing one-to-many relationships.

``` SQL
-- First we find the ids of each existing movie and director combo by selecting all from the films table
SELECT id, director_id FROM films;
-- Then we write a bunch of insert statements:
INSERT INTO directors_films (director_id, film_id)
  VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (3, 7), (7, 8), (8, 9), (4, 10);
```

4. Write a SQL statement to remove any unneeded columns from `film`. 

``` SQL
-- The unneeded columns in film are director_id
ALTER TABLE films DROP COLUMN director_id;
```

5. Write a SQL statement that will return the following result:
           title           |         name
---------------------------+----------------------
 12 Angry Men              | Sidney Lumet
 1984                      | Michael Anderson
 Casablanca                | Michael Curtiz
...

``` SQL
SELECT films.title, directors.name 
  FROM films
    INNER JOIN directors_films 
      ON films.id = directors_films.film_id
    INNER JOIN directors 
      ON directors_films.director_id = directors.id
  ORDER BY films.title ASC;
```

6. Write SQL statements to insert data for the given films.

``` SQL
INSERT INTO directors (name)
  VALUES ('Joel Coen'), ('Ethan Coen'), ('Frank Miller'), ('Robert Rodriguez');

INSERT INTO films (title, year, genre, duration)
  VALUES ('Fargo', 1996, 'comedy', 98), ('No Country for Old Men', 2007, 'western', 122), ('Sin City', 2005, 'crime', 124), ('Spy Kids', 2001, 'scifi', 88);

INSERT INTO directors_films (director_id, film_id)
  VALUES (9, 11), (9, 12), (10, 12), (11, 13), (12, 13), (12, 14);
```

7. Write a SQL statement that determines how many films each director in the database has directed. Sort the results by number of films (greatest first) and then name (in alphabetical order).

``` SQL
SELECT directors.name AS director, count(films.title) AS films
  FROM directors
    INNER JOIN directors_films 
      ON directors.id = directors_films.director_id
    INNER JOIN films
      ON directors_films.film_id = films.id
  GROUP BY directors.name
  ORDER BY films DESC, director ASC;
```


## Summary

- *Relational databases* are called *relational* because they persist data in a set of relations, or, as they are more commonly called, tables.

- A *relationship* is a connection between entity instances, or rows of data, usually resulting from a relationship between what those rows of data represent.

- The three levels of schema are *conceptual*, *logical*, and *physical*.

- The three types of relationships are *one to one*, *one to many*, and *many to many*.

- A conceptual schema is a high-level design focused on identifying entities and their relationships.

- A physical schema is a low-level database-specific design focused on implementation.

- *Cardinality* is the number of objects on each side of the relationship.

- The *modality* of a relationship indicates if that relationship is required or not.

- *Referential integrity* is a data property that requires every value in one column of a table to appear in a column of (usually) another table.
