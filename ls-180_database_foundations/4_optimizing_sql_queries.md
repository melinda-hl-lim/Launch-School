## What to Focus On

- Optimization is something to be aware of. So we should understand what indexes are, how to implement them, and the trade-offs involved in using them.

- Subqueries can be useful. We should know what a subquery is and how to use it. Many queries can be accomplished using JOINs *or* subqueries, and knowing which is best requires understanding a lot about the specific scenario being considered.


## Indexes

Another potential way of optimizing a database-backed application is to add indexes to the database tables. 

### What is an index?

**Index**, in the context of a database, is a mechanism that SQL engines use to speed up queries. They store indexed data in a table-like structure which can be quickly searched using particular search algorithms. The results of the search link back to the record(s) to which the indexed data belongs. 
- DB engine can locate column values more efficiently since it doesn't have to search through every record in the table in sequence

### When to use an index

If we index every column in a table, we end up with slower tables because:
- when you build an index of a field, read becomes faster but updates and inserts have an extra step updating/inserting the index

Rules of thumb to help assess trade-offs of using index:
- indexes are best used in cases where sequential reading is inadequate
  - ex: coluns used frequentyly in an `ORDER BY` clause
  - ex: columns aiding in mapping relatioships (i.e. foreign key columns)
- best used in tables/columns where data will be read much more frequently than created or updated

#### Types of Index

Some index types with PostgreSQL are B-tree (default for index), Hash, GiST, and GIN. 

### Creating Indexes

At this point we've created indexes on columns, but not explicitly. When defining a `PRIMARY KEY` constraint or a `UNIQUE` constraint, we automatically create an index on that column. The index is the mechanism by which these constraints enforce uniqueness.

The general form for adding an index to a table is:
``` SQL
CREATE INDEX index_name ON table_name (field_name);
```
If `index_name` is omitted, PostgreSQL automatically generates a unique name for the index. 

#### Unique and Non-unique

A *unique index* is created when using `PRIMARY KEY` or `UNIQUE` constraints. When an index is unique, multiple table rows with equal values for that index are not allowed.

#### Multicolumn Indexes

Indexes can be created on more than one column (in addition to indexing a single column). Instead of specifying a single column name, you can specify more than one:
``` SQL
CREATE INDEX index_name ON table_name (field_name_1, field_name_2);
```
Only certain index type support multi-column indexes, and there's a limit to the number of columns that can be combined in an index.

#### Partial Indexes

Partial indexes are built from a subset of the data in a table. The subset of data is defined by a conditional expression, and the index contains entries only for the rows from the table where the value in the indexed column satisfies the condition.

### Deleting Indexes

To delete an index, we need the index's name:
``` SQL
DROP INDEX index_name;
```


## Comparing SQL Statements

Structuring a query differently results in:
- a different amount of time to run the query

Although the database engine abstracts away how the query is actually run, the structure of our SQL statements can influence the *how* of the process.

One way to assess the structure of our query is to compare the efficiency of a run by different queries. 

### Assessing a Query with EXPLAIN

The `EXPLAIN` command gives a step by step analysis of how the query will be run internally by PostgreSQL.

To execute each query, PostgreSQL devises a **query plan**. `EXPLAIN` allows us to access that query plan.

We prepend `EXPLAIN` keyword to the query:
``` SQL
EXPLAIN SELECT * FROM books; 
--                      QUERY PLAN
-- ----------------------------------------------------------
--  Seq Scan on books  (cost=0.00..12.60 rows=260 width=282)
-- (1 row)
```
This doesn't execute the query, but returns the query plan. The values that `EXPLAIN` outputs are estimates, based on the planner's knowledge of the schema and assumptions based on PostgreSQL system statistics. 

The structure of a query plan is a *node-tree*. The more 'elements' there are in the query, the more nodes there will be in the tree. Each node consists of:
- the node type
- estimated cost for that node (start up cost and total cost)

- estimated number of rows to be output by the node
- estimated average width of the rows in bytes

Regardless of how many nodes a query plan has, one key piece of information for comparing queries is the estimated 'total cost' value of the top-most node. 

#### EXPLAIN ANALYZE

To assess a query using actual data, you can add the `ANALYZE` option to an `EXPLAIN` command:
``` SQL
my_books=# EXPLAIN ANALYZE SELECT books.title FROM books
my_books-# JOIN authors ON books.author_id = authors.id
my_books-# WHERE authors.name = 'William Gibson';
--                         QUERY PLAN
------------------------------------------------------------
--  Hash Join  (cost=14.03..27.62 rows=2 width=218) (actual time=0.029..0.034 rows=3 loops=1)
--    Hash Cond: (books.author_id = authors.id)
--    ->  Seq Scan on books  (cost=0.00..12.60 rows=260 width=222) (actual time=0.009..0.012 rows=7 loops=1)
--    ->  Hash  (cost=14.00..14.00 rows=2 width=4) (actual time=0.010..0.010 rows=1 loops=1)
--          Buckets: 1024  Batches: 1  Memory Usage: 9kB
--          ->  Seq Scan on authors  (cost=0.00..14.00 rows=2 width=4) (actual time=0.006..0.007 rows=1 loops=1)
--                Filter: ((name)::text = 'William Gibson'::text)
--                Rows Removed by Filter: 2
--  Planning time: 0.201 ms
--  Execution time: 0.074 ms
-- (10 rows)
```
Using the `ANALYZE` option actually runs the query and includes the actual time required to run the query and its constituent parts, and the actual rows returned by each plan node.


## Subqueries

The key thing to understand conceptually is that you are using the nested query to generate a set of one or more values, you then use those values as part of an outer query (usually as part of a condition). 

For example:
``` SQL
SELECT title FROM books WHERE author_id =
  (SELECT id FROM authors WHERE name = 'William Gibson');
```
The nested query, when executed, returns the `id` value from the `authors` table for `William Gibson`, which is integer `1`. So the outer query uses that value in the `WHERE` condition and effectively becomes:
``` SQL
SELECT title FROM books WHERE author_id = 1;
```

### Subquery Expressions

Most of the time when using subqueries, the nested query will return more than one value; this is where subquery expressions come in.

*Subquery expressions* are a special set of operators specifically used with subqueries, most commonly within a conditional subquery.

These operators include:

**`EXISTS`**: checks whether *any* rows are returned by the nested query. If at least one row is returned, the result of `EXISTS` is 'true'; otherwise it's 'false'.
``` SQL
SELECT 1 WHERE EXISTS
  (SELECT id FROM books
    WHERE isbn = '9780316005388');
--  ?column?
-- ----------
--         1
-- (1 row)
-- Would return no rows if subquery returned 0
```

**`IN`**: compares an evaluated expression to every row in the subquery result. If a row equal to the evaluted expression is found, then the results of `IN` is 'true', otherwise it's 'false'.
``` SQL
SELECT name FROM authors WHERE id IN
  (SELECT author_id FROM books
    WHERE title LIKE 'The%');
--       name
-- ----------------
--  Iain M. Banks
--  Philip K. Dick
-- (2 rows)
```

**`NOT IN`**: similar to `IN` except that the results of `NOT IN` is 'true' if an equal row is not found.

**`ANY/SOME`**: synonyms that can be used interchangeably. These expressions are used along with an operator (ex: `=`, `<`, `>`). The result of `ANY`/`SOME` is 'true' if *any* true result is obtained when the expression to the left of the operator is evaluated against the results of the nested query.
``` SQL
SELECT name FROM authors WHERE length(name) > ANY
  (SELECT length(title) FROM books
    WHERE title LIKE 'The%');
--       name
-- ----------------
--  William Gibson
--  Philip K. Dick
-- (2 rows)
```

**`ALL`**: `ALL` is used along with an operator. The result of `ALL` is true if all the results are true when the expression to the left of the operator is evaluated against the results of the nested query.
``` SQL
SELECT name FROM authors WHERE length(name) > ALL
  (SELECT length(title) FROM books
    WHERE title LIKE 'The%');
--  name
-- ------
-- (0 rows)
```

*Note*: when the `<>` / `!=` operator is used with `ALL`, this is equivalent to `NOT IN`.

### When to use Subqueries

There are some cases where subqueries are more readable or make more logical sense.

For example, if you want to return data from one table conditional on data from another table, but don't need to return any data from the second table, then a subquery may make more logical sense and be more readable. If you need to return data from both tables then you would need to use a join.


## Summary

