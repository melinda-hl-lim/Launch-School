### Controller Patterns in a Datacentric App

So far each action in our controller does one of the following:

    1. Interact with the DB (either reading or writing data)
    2. Retrive data to render a view template (in the case of "read") or redirect to a different page (in the case of "write")

**A fundamental pattern of controllers:**

**The controller stands between the data (in the DB) and the presentation (view templates) to coordinate the flow of requests and responses.**


### CRUD

CRUD stands for Create, Read, Update, and Delete.
These are the four basic actions to interact with data. They map directly to the four core SQL commands: INSERT, SELECT, UPDATE and DELETE.
