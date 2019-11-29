A model is *just a Ruby class*. They exist to group all SQL commands about a piece of data in a single place, making it easier to update.

Note: must look up Ruby `attr_reader` and associated declarations...?

### Model Validations

We use model validations to ensure that records save have the correct data.

General guideline: if collecting user input, then validate data as early as possible (i.e. before saving in DB)

#### Integrate Validations With Forms

Add checks in the controller...?


### Model associations

*Adding comments to the blogging app*

We need to create a new model for comments. A post will have many comments -- to keep track of this relationship, we need a **foreign key**.
    In this case, foreign key column is `post_id`.


#### Working with Model Associations

*Creation through association*

Since a comment is associated to a post, we're concerned about the `post_id` when creating a comment. We can pass the `post_id` value through a URL parameter.

