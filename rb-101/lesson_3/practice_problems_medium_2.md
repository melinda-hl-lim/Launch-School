


### Question 2

Predict how the object IDs will change through the flow of the code.

#### Answer 2

Note: Rather than having a super long Q2 statement, I've taken the code blocks and incorporated them into my answer to show the flow of the method.

    def fun_with_ids
      a_outer = 42
      b_outer = "forty two"
      c_outer = [42]
      d_outer = c_outer[0]

At this point, we are initializing four new variables. Variables a_outer, b_outer, and c_outer all refer to unique objects with unique object IDs. The variable d_outer, however, refers to the same object as a_outer. So at this point we can make up some unique ids for each variable's object:
    a_outer refers to object with id A1
    b_outer refers to object with id B1
    c_outer refers to object with id C1
    d_outer refers to object with id A1

Moving on to the next code snippet:

    an_illustrative_method(a_outer, b_outer, c_outer, d_outer, a_outer_id, b_outer_id, c_outer_id, d_outer_id)

When we pass in these variables (and initialized x_outer_id variables) to the method, we encounter the next code snippet:

    a_outer_inner_id = a_outer.object_id
    b_outer_inner_id = b_outer.object_id
    c_outer_inner_id = c_outer.object_id
    d_outer_inner_id = d_outer.object_id

These variables are initialized inside the second method block and are assigned the value of the object ids A1, B1, C1, and A1 respectively. However, these values are new objects, themselves, and have unique ids.

When we attempt to print out the object IDs of x_outer inside the second method block, the ids will remain the same as A1, B1, C1, and A1 respectively. This is because Ruby has not initialized new objects; instead, it just treates the inner method's variables as pointers to the same objects initialized outside an_illustrative_method().

On the next code snippet inside an_illustrative_method():
    a_outer = 22
    b_outer = "thirty three"
    c_outer = [44]
    d_outer = c_outer[0]

Since we are assigning completely new objects to the x_outer variables, the IDs will change from A1, B1, C1, and A1 to:
    a_outer refers to object with id A2
    b_outer refers to object with id B2
    c_outer refers to object with id C2
    d_outer refers to object with id D2

In the end, the object IDs inside an_illustrative_method() are totally different from the object IDs outside an_illustrative_method(). However, the method ends with a call to puts(); this returns a value of nil for the method itself. Now we move out of the inner method block back to the next code snippet of fun_with_ids().

We have a bunch of print statements referencing: x_outer, x_outer_id, x_inner, and x_inner_id. The print statements referencing x_outer and x_outer_id will reveal that the method an_illustrative_method() did nothing to change our x_outer objects. We see that:
    a_outer has value 42 with id A1
    b_outer has value "forty two" with id B1
    c_outer has value [42] with id C1
    d_outer has value 42 with id A1

However, the print statements referencing x_inner and x_inner_id cannot access the variable initialized in the scope of an_illustrative_method. So it prints "ugh ohhhhh" and returns nil.


### Question 3

Let's call a method, and pass both a string and an array as parameters and see how even though they are treated in the same way by Ruby, the results can be different.

Study the following code and state what will be displayed...and why:

``` ruby
    def tricky_method(a_string_param, an_array_param)
      a_string_param += "rutabaga"
      an_array_param << "rutabaga"
    end

    my_string = "pumpkins"
    my_array = ["pumpkins"]
    tricky_method(my_string, my_array)

    puts "My string looks like this now: #{my_string}"
    puts "My array looks like this now: #{my_array}"
```

#### Answer 3

The trick_method() does not mutate my_string because the string method += creates a new string object with the appended string. However, my_array() is mutated because the array method << mutates the original array. Therefore the two outputs would be:

    "My string looks like this now: pumpkins"
    "My array looks like this now: [pumpkins, rutabaga]"


### Question 4

To drive that last one home...let's turn the tables and have the string show a modified output, while the array thwarts the method's efforts to modify the caller's version of it.
``` ruby
    def tricky_method_two(a_string_param, an_array_param)
      a_string_param << 'rutabaga'
      an_array_param = ['pumpkins', 'rutabaga']
    end

    my_string = "pumpkins"
    my_array = ["pumpkins"]
    tricky_method_two(my_string, my_array)

    puts "My string looks like this now: #{my_string}"
    puts "My array looks like this now: #{my_array}"
```

#### Answer 4

Now, the output will show the value of my_string has changed from "pumpkins" to "pumpkinsrutabaga". This is because the << method modifies the original string. However, the my_array value will still be ["pumpkins"], because tricky_method_two() reassigns a new value to the local variable an_array_param within its scope, but leaves the original array untouched.


### Question 5

Depending on a method to modify its arguments can be tricky:

``` ruby
    def tricky_method(a_string_param, an_array_param)
      a_string_param += "rutabaga"
      an_array_param << "rutabaga"
    end

    my_string = "pumpkins"
    my_array = ["pumpkins"]
    tricky_method(my_string, my_array)

    puts "My string looks like this now: #{my_string}"
    puts "My array looks like this now: #{my_array}"
```

Whether the above "coincidentally" does what we think we wanted "depends" upon what is going on inside the method.

How can we refactor this practice problem to make the result easier to predict and easier for the next programmer to maintain?

#### Answer 5
First, it would be easier to predict and maintain `trick_method()` if the method consistently mutated its arguments or simply output new values while leaving the arguments unmodified. To make `trick_method()` a purely destructive method, we could rewrite it as:

``` ruby
    def tricky_method(a_string_param, an_array_param)
      a_string_param << "rutabaga"
      an_array_param << "rutabaga"
    end
```

To make it a method that returns new string and and array objects, we could rewrite it as:

``` ruby
    def tricky_method(a_string_param, an_array_param)
      a_string_param += "rutabaga"
      an_array_param = an_array_param + ["rutabaga"]
      a_string_param, an_array_param
    end
```

Second, I would change the names of the method for ease of use by other programmers. If `tricky_method()` were destructive, it should be named `tricky_method!()` to reflect its destructive nature.

### CORRECTION for 5
**Note that the practice problem asks us to refactor the whole practice problem, not just `tricky_method()`**


### Question 6

How could the unnecessary duplication in this method be removed?

``` ruby
    def color_valid(color)
      if color == "blue" || color == "green"
        true
      else
        false
      end
    end
```

#### Answer 6

We could rewrite the method as:

``` ruby
    def color_valid(color)
      valid_colors = %w(blue green)
      return true if valid_colors.include?(color)
      false
    end
```

### CORRECTION for 6

Launch School says "Ruby will automatically evaluate statements, so we can rewrite the method as: "

```ruby
    def color_valid(color)
      color == "blue" || color == "green"
    end
```
