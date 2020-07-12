## Data Definition Language (DDL)

1. Create an Extrasolar Planetary Database

Create the database 'extrasolar': `CREATE DATABASE extrasolar`

Then create two tables following Launch School's column specifications:

`stars` table:
``` SQL
CREATE TABLE stars (
  id serial PRIMARY KEY,
  name varchar(25) UNIQUE NOT NULL,
  distance integer NOT NULL CHECK (distance > 0),
  spectral_type char(1),
  companions integer NOT NULL CHECK (companions >= 0)
);
```

`planets` table:
``` SQL
CREATE TABLE planets (
  id serial PRIMARY KEY,
  designation char(1),
  mass integer
);
```

2. Relating Stars and Planets

To create a connection between the `stars` and `planets` tables, add a `star_id` column to the `planets` table. This column will be used to relate each planet in the `planets` table to its home star in the `stars` table. Make sure the row is defined in such a way that it is required and must have a value that is present as an `id` in the `stars` table.

``` SQL
ALTER TABLE planets
  ADD COLUMN star_id integer NOT NULL REFERENCES stars (id);
```

Above, we are using the stars.id column to establish a relationship between two tables. Therefore, the column must be defined as a **foreign key** using the `REFERENCES` clause.

Everything to do with modifying the schema of a table involves the `ALTER TABLE` command, hence its use here.

Note that we also have to specify `NOT NULL` for the foreign key column, as foreign keys don't receive the `NOT NULL` constraint automatically.

3. Increase Star Name Length

Change the `stars` table `name` column to hold not 25 characters, but 50 characters. 

``` SQL
ALTER TABLE stars
  ALTER COLUMN name TYPE varchar(50);
```

4. Stellar Distance Precision

Modify the `distance` column in the `stars` table so that it allows fractional light years to any degree of precision required.

``` SQL
ALTER TABLE stars
  ALTER COLUMN distance TYPE numeric;
```

5. Check Values in List

Add a constraint to the table `stars` that will ensure values in the `spectral_type` is one of the following: `O`, `B`, `A`, `F`, `G`, `K`, or `M`.

``` SQL
ALTER TABLE stars
  ADD CHECK (spectral_type IN ('O', 'B', 'A', 'F', 'G', 'K', 'M')),
  ALTER COLUMN spectral_type SET NOT NULL;
```

6. Enumerated Types

PostgreSQL provides what is called an enumerated data type; that is, a data type that must have one of a finite set of values. For instance, a traffic light can be red, green, or yellow: these are enumerate values for the color of the currently lit signal light.

Modify the stars table to remove the `CHECK` constraint on the `spectral_type` column, and then modify the `spectral_type` column so it becomes an enumerated type that restricts it to one of the following 7 values: 'O', 'B', 'A', 'F', 'G', 'K', and 'M'.

``` SQL
ALTER TABLE stars
  DROP CONSTRAINT stars_spectral_type_check;

-- Create an enumerated type, with values restricted to those specified in the `AS ENUM` clause
CREATE TYPE spectral_type_enum AS ENUM ('O', 'B', 'A', 'F', 'G', 'K', 'M');

ALTER TABLE stars
  ALTER COLUMN spectral_type TYPE spectral_type_enum
                             USING spectral_type::spectral_type_enum;
-- The `USING` clause tells PostgreSQL to use the existing values from `spectral_type` as if they were enumerated values. There is no defined way to change `char` values to an enumerated type, so without the `USING` clause we would get an error.
```

7. Planetary Mass Precision

Modify the `mass` column in the `planets` table so that it allows fractional masses to any degree of precision required.

Also, change the `designation` column so it's required.
``` SQL
ALTER TABLE planets
  ALTER COLUMN mass TYPE numeric,
  ALTER COLUMN mass SET NOT NULL,
  ADD CHECK (mass > 0.0),
  ALTER COLUMN designation SET NOT NULL;
```

8. Add a Semi-major Axis Column

Add a `semi_major_axis` column for the semi-major axis of each planet's orbit; the semi-major axis is the average distance from the planet's star as measured in astronomical units (1 AU is the average distance of the Earth from the Sun). Use a data type of `numeric`, and require that each planet have a value for the `semi_major_axis`.

``` SQL
ALTER TABLE planets
  ADD COLUMN semi_major_axis numeric NOT NULL;
```

9. Add a Moons Table

Create a `moons` table as specified by LS:
``` SQL
CREATE TABLE moons (
  id serial PRIMARY KEY,
  designation integer NOT NULL CHECK (designation > 0),
  semi_major_axis numeric CHECK (semi_major_axis > 0.0),
  mass numeric CHECK (mass > 0.0),
  planet_id integer NOT NULL REFERENCES planets (id)
);
```

10. Delete the Database

``` SQL
\c another_database
DROP DATABASE extrasolar;
```

Before dropping the database, it's a good idea to make a database dump like so:
``` bash
$ pg_dump --inserts extrasolar > extrasolar.dump.sql
```

## Data Manipulation Language (DML)

1. Set Up Database

Create a database to store information and tables related to a workshop.

Create db: `CREATE DATABASE workshop`

Table `devices`: 
``` SQL
CREATE TABLE devices (
  id serial PRIMARY KEY,
  name text NOT NULL,
  created_at timestamp DEFAULT CURRENT_TIMESTAMP
);
```

Table `parts`:
``` SQL
CREATE TABLE parts (
  id serial PRIMARY_KEY,
  part_number integer UNIQUE NOT NULL,
  device_id integer REFERENCES devices (id)
);
```

2. Insert Data for Parts and Devices

``` SQL
INSERT INTO devices (name)
VALUES ('Accelerometer'), ('Gyroscope');

INSERT INTO parts (part_number, device_id) 
VALUES (12, 1), (14, 1), (16, 1), -- 3 parts for accelerometer
(31, 2), (33, 2),(35, 2),(37, 2),(39, 2); -- 5 parts for gyro

INSERT INTO parts (part_number) 
VALUES (50), (54), (58);
```

3. INNER JOIN

We want the follwoing output:
- - - 
     name      | part_number
---------------+-------------
 Accelerometer |          12
 Accelerometer |          14
 Accelerometer |          16
 Gyroscope     |          31
 Gyroscope     |          33
 Gyroscope     |          35
 Gyroscope     |          37
 Gyroscope     |          39
(8 rows)
- - - 

``` SQL
SELECT devices.name, parts.part_number FROM devices
INNER JOIN parts ON devices.id = parts.device_id;
```

4. SELECT part_number

Write a `SELECT` query to grab all part numbers that start with 3.

`SELECT * FROM parts WHERE part_number::text LIKE '3%';`

5. Aggregate Functions

Write an SQL query that returns a result table with the name of each device in our database together with the number of parts for that device.

``` SQL
SELECT devices.name, COUNT(parts.device_id) AS number_of_parts
FROM devices LEFT JOIN parts ON devices.id = parts.device_id
GROUP BY devices.name;
```

6. ORDER BY

Alter the SQL query from above so that part names are listed in descending alphabetical order.

``` SQL
SELECT devices.name, COUNT(parts.device_id) AS number_of_parts
FROM devices LEFT JOIN parts ON devices.id = parts.device_id
GROUP BY devices.name 
ORDER BY devices.name DESC;
```

7. IS NULL and IS NOT NULL

Write two SQL queries:
- One that generates a listing of parts that currently belong to a device.
- One that generates a listing of parts that don't belong to a device.

Do not include the id column in your queries. 

``` SQL
SELECT part_number, device_id FROM parts WHERE device_id IS NOT NULL;

SELECT part_number, device_id FROM parts WHERE device_id IS NULL;
```

8. Oldest Device

Write an SQL statement that will return the name of the oldest device from our devices table.

``` SQL
SELECT name AS oldest_device FROM devices
ORDER BY created_at ASC LIMIT 1;
```

9. UPDATE device_id

We've realized that the last two parts we're using for device number 2, "Gyroscope", actually belong to an "Accelerometer". Write an SQL statement that will associate the last two parts from our parts table with an "Accelerometer" instead of a "Gyroscope".

``` SQL
UPDATE parts SET device_id = 1 WHERE id IN (
  SELECT id FROM parts 
  WHERE device_id = 2 
  ORDER BY id DESC LIMIT 2
);
```

10. Delete Accelerometer

``` SQL
DELETE FROM parts WHERE device_id = 1;
DELETE FROM devices WHERE name = 'Accelerometer';
```


## Many to Many

1. Set Up Database

In this set of exercises, we will work with a billing database for a company that provides web hosting services to its customers. The database will contain information about its customers and the services each customer uses. Each customer can have any number of services, and every service can have any number of customers. Thus, there will be a many-to-many (M:M) relationship between the customers and the services. Some customers don't presently have any services, and not every service must be in use by any customers.

We need to create a `customers` table and a `services` table.

``` SQL
CREATE TABLE customers (
  id serial PRIMARY KEY,
  name text NOT NULL,
  payment_token char(8) NOT NULL UNIQUE CHECK (payment_token ~ '^[A-Z]{8}$') -- this check constraint uses the ~ operator to perform a regular expression match of the column's value vs the regex on the right. It ensures the payment token is a string of 8 upper case letters.
);

CREATE TABLE services (
  id serial PRIMARY KEY,
  description text NOT NULL,
  price numeric(10, 2) NOT NULL CHECK (price >= 0.00)
);
```

Then we need to insert the data given, which I stole from the LS solutions:
``` SQL
INSERT INTO customers (name, payment_token)
VALUES
  ('Pat Johnson', 'XHGOAHEQ'),
  ('Nancy Monreal', 'JKWQPJKL'),
  ('Lynn Blake', 'KLZXWEEE'),
  ('Chen Ke-Hua', 'KWETYCVX'),
  ('Scott Lakso', 'UUEAPQPS'),
  ('Jim Pornot', 'XKJEYAZA');

INSERT INTO services (description, price)
VALUES
  ('Unix Hosting', 5.95),
  ('DNS', 4.95),
  ('Whois Registration', 1.95),
  ('High Bandwidth', 15.00),
  ('Business Support', 250.00),
  ('Dedicated Hosting', 50.00),
  ('Bulk Email', 250.00),
  ('One-to-one Training', 999.00);
```

Then we need to **create a join table** that associateds customers with services and vice versa. The join table should have columns for both the services id and the customers id, as well as a primary key named `id` that auto-increments.
``` SQL
CREATE TABLE customers_services (
  id serial PRIMARY KEY,
  customer_id integer 
    REFERENCES customers (id) 
    ON DELETE CASCADE 
    NOT NULL,
  service_id integer 
    REFERENCES services (id)
    NOT NULL,
  UNIQUE(customer_id, service_id)
);
```

And then enter some customer-services relationships.
``` SQL
INSERT INTO customers_services (customer_id, service_id)
VALUES
  (1, 1), -- Pat Johnson/Unix Hosting
  (1, 2), --            /DNS
  (1, 3), --            /Whois Registration
  (3, 1), -- Lynn Blake/Unix Hosting
  (3, 2), --           /DNS
  (3, 3), --           /Whois Registration
  (3, 4), --           /High Bandwidth
  (3, 5), --           /Business Support
  (4, 1), -- Chen Ke-Hua/Unix Hosting
  (4, 4), --            /High Bandwidth
  (5, 1), -- Scott Lakso/Unix Hosting
  (5, 2), --            /DNS
  (5, 6), --            /Dedicated Hosting
  (6, 1), -- Jim Pornot/Unix Hosting
  (6, 6), --           /Dedicated Hosting
  (6, 7); --           /Bulk Email
```

2. Get Customers With Services

Write a query to retrieve the customer data for every customer who currently subscribes to at least one service.

``` SQL
SELECT DISTINCT customers.* 
  FROM customers
    INNER JOIN customers_services 
      ON customers.id = customers_services.customer_id;
```

3. Get Customers With No Services

Write a query to retrieve the customer data for every customer who does not currently subscribe to any services.

``` SQL
SELECT DISTINCT customers.*
  FROM customers
    LEFT OUTER JOIN customers_services
      ON customers.id = customers_services.customer_id
  WHERE customers_services.service_id IS NULL;
```

Bonus: Write a query that displays all customers with no services and all services that currently don't have any customers.

``` SQL
SELECT DISTINCT customers.*, services.*
  FROM customers
    FULL OUTER JOIN customers_services
      ON customers.id = customers_services.customer_id
    FULL OUTER JOIN services
      ON services.id = customers_services.service_id
  WHERE 
    customers_services.service_id IS NULL OR customers_services.customer_id IS NULL;
```

4. Get Services With No Customers

Using RIGHT OUTER JOIN, write a query to display a list of all services that are not currently in use. 

``` SQL
SELECT DISTINCT services.* 
  FROM customers_services
    RIGHT OUTER JOIN services
      ON customers_services.service_id = services.id
  WHERE customers_services.customer_id IS NULL;
```

5. Services For Each Customer

Write a query to display a list of all customer names together with a comma-separated list of the services they use. 

``` SQL
SELECT customers.name, 
       string_agg(services.description, ', ') AS services
FROM customers
LEFT OUTER JOIN customers_services
             ON customers.id = customers_services.customer_id
LEFT OUTER JOIN services
             ON customers_services.service_id = services.id
GROUP BY customers.name;
```

6. Services With At Least 3 Customers

Write a query that displays the description for every service that is subscribed to by at least 3 customers. Include the customer count for each description in the report. 

Launch School solution
``` SQL
SELECT description, COUNT(service_id)
FROM services
INNER JOIN customers_services
             ON services.id = service_id
GROUP BY description
HAVING COUNT(customers_services.customer_id) >= 3
ORDER BY description;
```

7. Total Gross Income

Assuming that everybody in our database has a bill coming due, and that all of them will pay on time, write a query to compute the total gross income we expect to receive.

``` SQL
SELECT sum(services.price) AS gross
FROM services
INNER JOIN customers_services
        ON services.id = customers_services.service_id;
```

8. Add New Customer

A new customer, 'John Doe', has signed up with our company. His payment token is 'EYODHLCN'. Initially, he has signed up for UNIX hosting, DNS, and Whois Registration. Create any SQL statement(s) needed to add this record to the database.

``` SQL
INSERT INTO customers (name, payment_token)
  VALUES ('John Doe', 'EYODHLCN');

INSERT INTO customers_services (customer_id, service_id)
  VALUES (7, 1), (7, 2), (7, 3);
```

9. Hypothetically

The company president is looking to increase revenue. As a prelude to his decision making, he asks for two numbers: the amount of expected income from "big ticket" services (those services that cost more than $100) and the maximum income the company could achieve if it managed to convince all of its customers to select all of the company's big ticket items.

For simplicity, your solution should involve two separate SQL queries: one that reports the current expected income level, and one that reports the hypothetical maximum. 

``` SQL
-- Current income from big ticket services
SELECT sum(services.price)
FROM services
INNER JOIN customers_services
        ON services.id = customers_services.service_id
WHERE services.price > 100;

-- Hypothetical maximum if all customers select all big ticket items

SELECT sum(price)
FROM customers
CROSS JOIN services
WHERE price > 100;
```

10. Deleting Rows

Write the necessary SQL statements to delete the "Bulk Email" service and customer "Chen Ke-Hua" from the database.

``` SQL
-- Delete "Bulk email" from JOIN table
DELETE FROM customers_services WHERE service_id = 7;

-- Delete "Chen Ke-Hua" from JOIN table
DELETE FROM customers_services WHERE customer_id = 4;

-- Delete the records from services and customers
DELETE FROM services WHERE id = 7;
DELETE FROM customers WHERE id = 4;
```

**Note:** We don't have to delete Chen's customer id from the join table because we defined `customer_id` in the join table to be a foreign key that included the `ON DELETE CASECADE` clause.


## Subqueries and More

1. Set Up the Database using \copy

Given database tables descriptions, create the tables:
``` SQL
CREATE TABLE bidders (
  id serial PRIMARY KEY,
  name text NOT NULL
);

CREATE TABLE items (
  id serial PRIMARY KEY,
  name text NOT NULL,
  initial_price numeric(6, 2) NOT NULL CHECK(initial_price BETWEEN 0.01 AND 1000.00),
  sales_price numeric(6, 2) CHECK(sales_price BETWEEN 0.01 AND 1000.00)
);

CREATE TABLE bids (
  id serial PRIMARY KEY,
  bidder_id integer NOT NULL REFERENCES bidders (id) ON DELETE CASCADE,
  item_id integer NOT NULL REFERENCES items (id),
  amount numeric(6, 2) NOT NULL CHECK(amount BETWEEN 0.01 AND 1000.00)
);

CREATE INDEX ON bids (bidder_id, item_id);
```

2. Conditional Subqueries: IN

Write a SQL query that shows all items that have had bids put on them. Use the logical operator `IN` for this exercise, as well as a subquery.

``` SQL
SELECT name AS "Bid on Items" FROM items 
WHERE id IN (
  SELECT DISTINCT item_id FROM bids
);
```

3. Conditional Subqueries: NOT IN

Write a SQL query that shows all items that have not had bids put on them. Use the logical operator `NOT IN` for this exercise, as well as a subquery.

``` SQL
SELECT name AS "Not Bid On" FROM items
WHERE id NOT IN (
  SELECT DISTINCT item_id FROM bids
);
```

4. Conditional Subqueries: EXISTS

Write a `SELECT` query that returns a list of names of everyone who has bid in the auction. While it is possible (and perhaps easier) to do this with a `JOIN` clause, we're going to do things differently: use a subquery with the `EXISTS` clause instead.

``` SQL
SELECT name FROM bidders
WHERE EXISTS ( 
  SELECT 1 FROM bids WHERE bids.bidder_id = bidders.id
);
```

5. Query From a Virtual Table

For this exercise, we'll make a slight departure from how we've been using subqueries. We have so far used subqueries to filter our results using a WHERE clause. In this exercise, we will build that filtering into the table that we will query. Write an SQL query that finds the largest number of bids from an individual bidder.

For this exercise, you must use a subquery to generate a result table (or virtual table), and then query that table for the largest number of bids.

``` SQL
SELECT count AS max FROM (
  SELECT bidder_id, COUNT(item_id)
  FROM bids
  GROUP BY bidder_id
) AS num_bids 
ORDER BY count DESC
LIMIT 1;
```

Launch School's solution:
``` SQL
SELECT MAX(bid_counts.count) FROM
  (SELECT COUNT(bidder_id) FROM bids GROUP BY bidder_id) AS bid_counts;
```

6. Scalar Subqueries

For this exercise, use a scalar subquery to determine the number of bids on each item. The entire query should return a table that has the `name` of each item along with the number of bids on an item.

``` SQL
SELECT name,
       (SELECT COUNT(item_id) FROM bids WHERE item_id = items.id)
FROM items;
```

7. Row Comparison

We want to check that a given item is in our database. There is one problem though: we have all of the data for the item, but we don't know the `id` number. Write an SQL query that will display the id for the item that matches all of the data that we know, but does not use the `AND` keyword. 

Here is the data we know: 'Painting', 100.00, 250.00

``` SQL
SELECT id FROM items
WHERE ROW('Painting', 100.00, 250.00) = ROW(name, initial_price, sales_price);
```

We need to use `ROW` to *construct two virtual rows*: one that contains the data we want, and one that represents the data for each row in the table. We then compare these two virtual rows to find the row that matches our data and extract its id.

8. EXPLAIN

The launch school explanation and solution is a great guide for reviewing `EXPLAIN` and `EXPLAIN ANALYZE`.

9. Comparing SQL statements