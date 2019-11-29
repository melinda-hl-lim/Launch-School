### Database Backed Applications

The most common paradigm for dynamic web is *"databased backed applications"*.
    1. Server queries backend DB
    2. Result of query used to assemble response
    3. Response returned to client

The server queries the backend database and uses the result of that query to assemble a response to return to the client.

The dynamic nature of the response comes from the *state* of the backend database (not the data in the request).

Note: this is a big topic/paradigm


### Prepare the Database

In this tutorial, we use SQLite3 database (a lightweight DB that Rails has built-in support for)

In dealing with the database, we need to think about:

    1. The structure of the DB (a table and its columns)
    2. The data itself (rows representing individual posts)


#### Example DB setup and population: SQLite3, a **DBMS** (Database Management System)

Here's an example SQL file for creating the table:
`db/posts.sql`
``` SQL
CREATE TABLE "posts" (
  "id"         INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  "title"      varchar,
  "body"       text,
  "author"     varchar,
  "created_at" datetime NOT NULL);
```

And an example file to populate the `posts` table:
`db/posts.csv`
```
1,Blog 1,Lorem ipsum dolor sit amet.,Brad,2014-12-07
2,Blog 2,Lorem ipsum dolor sit amet.,Chris,2014-12-08
3,Blog 3,Lorem ipsum dolor sit amet.,Kevin,2014-12-09
```

To create the database, we run this command from the app's root directory:
`$ sqlite3 db/development.sqlite3 < db/posts.sql`

At this point, the table exists but there are no rows of data in our table yet.

To import the CSV file of dummy data, we issue these commands:

``` bash
$ sqlite3 db/development.sqlite3 # enter the SQLite3 console

sqlite> .mode csv # tell SQLite3 we're importing a CSV file

sqlite> .import db/posts.csv posts #import contents of file to posts table

sqlite> SELECT * FROM posts; # view rows of posts table
1,"Blog 1","Lorem ipsum dolor sit amet.",Brad,2014-12-07
2,"Blog 2","Lorem ipsum dolor sit amet.",Chris,2014-12-08
3,"Blog 3","Lorem ipsum dolor sit amet.",Kevin,2014-12-09

sqlite> .quit # exit the sqlite REPL (i.e. console...?)
```


### Interacting with the Database

Before talking about how to work with the DB in Rails, we're going to interact with it with pure Ruby.

To do so, we'll need a way of connecting to the SQLite3 DB from Ruby. Use the Ruby library `sqlite3`.

Melinda tl;dr: we can do it with Ruby. But it's less convinient and uses commands such as:
- `SQLITE3::Database.new 'db/development.sqlite3'` to instantiate a DB object for quering our app DB
- `connection.execute 'SELECT * FROM posts'` to connect and query our DB object about rows in the post table -- returns an array of arrays


