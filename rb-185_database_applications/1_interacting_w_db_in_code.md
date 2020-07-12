# 1. Interacting With Databases In Code

## What This Course Covers

Learn how to interact with SQL and relational databases via a programming language (Ruby). 
- Use `pg` gem to work with PostgreSQL db


## Getting Started

In this course we will learn how to:
- connect to PostgreSQL from Ruby
- use the `pg` gem to perform queries
- build dynamic SQL statements safely
- structure small command-line applications
- optimize queries made from Ruby programs


## What to Focus On

- Observe the progression of steps from high-level requirements to low-level implementation details
- Understand how to dynamically generate SQL
- Focus on the database, not the application


## Executing SQL Statements from Ruby

Note: All values from db are returned as strings. 

Useful commands we learnt:
- `PG.connect(dbname: "a_db")`: Creates a new `PG::Connection` object
- `connection.exec("SOME SQL QUERY")`: Executes a SQL query and returns a `PG::Result` object

And see these also-useful commands at this [handy-dandy table](https://launchschool.com/lessons/10f7102d/assignments/003e5e30).
- `result.values`
- `result.fields`
- `result.ntuples`
- `result.each(&block)`
- `result.each_row(&block)`
- `result[index]`
- `result.field_values(column)`
- `result.column_values(index)`


# 2. Database-backed Web Applications

## What to Focus On

- What schema does an application require?
- Project setup is secondary: focus on database and web apps


# 3. Optimization

## What to Focus On

- Be aware of the concept of optimizing the way an application interacts with a database
- Be able to describe what N+1 queries are and how they can be addressed

## Identifying Optimizations

An *N + 1 query* is where you have an SQL query for each n elements on the page plus one for the original query to load the list. 

## Optimizing N+1 Queries

Reduce the number of queries required by application by pulling only the information required.

Ex: In our todo application, we first had N + 1 queries to load a page that lists all our todo lists and the task counts. To reduce number of queries, we used a JOIN table to pull only list name and task counts.

## Pushing Down Operations to the Database

We moved some of the counting functionality with todos down to the database; this allowed us to remove some helper methods. Same functionality, more efficient.

Standardized hashes that the todos and lists were stored in. Allows rest of code to make assumptions about the hash.

## Summary

- How N+1 queries are the result of performing an additional query for each element in a collection
- How to move business logic from Ruby into the database by adding to a query's select list
- How making database interactions more efficient often involves making SQL queries more specialized
