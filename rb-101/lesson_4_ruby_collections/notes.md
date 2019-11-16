## Introduction

Programmers need to store, search and manipulate data. To store data, we put them into structure containers called
*collections*.

In this lesson, we worked with three of the most commonly used collections: `String`, `Array`, and `Hash`.



## Collections Basics

Goals:
    - Understand how collections are structure
    - Understand how to reference and assign individual elements in collections


### Element Reference

#### String Element Reference

Given: `str = 'horses are cool'`, we can retrive parts of the string with the following commands.

    - `str[0] = 'h'`
    - `str[0..2] = 'hor'`
    - `str[0,5] = 'horse'`

Note: the last example above is actually a call to the String#slice method, which can take a variety of arguments. Above, `str[0,5]` is a call to start at index 0 and retrive a string of length 5.

#### Array Element Reference

Arrays are a list of *elements* that are ordered by index. Each element can be any object. Arrays use integer-based indices to maintain the order of its elements.

We can retrieve elements similar to how we retrieved string parts above (including the 3rd example). However, it's important to know that `Array#slice` is not the same method as `String#slice`.

#### Hash Element Reference

Hashes keep track of its elements with key-pair values. Note that keys must be **unique**.

We can access just the keys or just the values of a hash with `Hash#keys` and `Hash#values` methods. Both these methods return an array.

*It's common practice to use symbols as keys.* There's a number of advantages for using symbols as keys, but Launch School didn't go into it yet.

#### Element Reference Gotchas

**Out of Bound Indices**

Referencing out-of-bounds indices returns `nil`. This may cause issues if a container (arrays and hashes) can hold `nil` as a valid element value.

To tell the difference between valid return values and out-of-bound references in *arrays*, we can use `Array#fetch`. This method will throw an IndexError exception if the referenced index is out of bounds.

**Negative Indices**

We can reference elements in `String` and `Array` objects with negative indices; the index on the far right starts at -1.

**Invalid Hash Keys**

Invalid *hash* keys also return `nil`. To differentiate from `nil` values from a valid hash key, we can use the `Hash#fetch` method. It will throw a KeyError exception if the key is not valid.


### Conversion

Strings and arrays share similarities and can be converted from one to the other.A couple of methods include:
    - `String#chars`: returns an array of individual characters
    - `Array#join`: returns a string with elements joined together in a string

Hashes can turn into an array using the `Hash#to_a` method. The key-pair values are in nested arrays. For example:

``` ruby
    hsh = { sky: "blue", grass: "green" }
    hsh.to_a # => [[:sky, "blue"], [:grass, "green"]]
```

And arrays can turn into hashes with the `Array#to_h` method. It requires an array of `[key, value]` pairs.


### Element Assignment

#### String Element Assignment

You can change the value of a specific character in a string by referring to its index. For example:

``` ruby
    str = "horse"
    str[0] = "B"
    str # =? "Borse"
```

Note: this is a destructive action.

#### Array Element Assignment

Array element assignment is similar (and looks almost identical) to string element assignment.

#### Hash Element Assignment

Hash element assignment is similar, except we use the hash key instead of the index.



## Looping

Use loops to perform a single action on each element in a collection.de

### Controlling a Loop

Create a simple loop calling the `Kernel#loop` method and passing a block to it. For example:
    ``` ruby
    loop do
        number = rand(1..10)
        puts 'Hello!'
        break if number == 5
    end
    ```

### Iteration
In the loop above, the loop will iterate an unknown number of times since `number` is a random number. We can tell `loop` to iterate a specific number of times using a variable `counter` that represents the current iteration number. For example:
    ```ruby
    counter = 0

    loop do
        puts 'Hello!'
        counter += 1
        break if counter == 5 # See Sidenote: `if` modifier
    end
    ```

#### Sidenote: `if` modifier

We can shorten the `if` statement by changing it to an `if` modifier. This is implemened by appending the keyword `if` and adding the condition to a statement. It can only be used when there is a single line of code within the `if` block.

#### Break Placement

With a *"do/while" loop*, the code in the block is guaranteed to execute **at least once**. We can mimic this behaviour with a `loop` by placing `break` on the last line in the loop:
    ``` ruby
    loop do
        number = rand(1..10)
        puts 'Hello!'
        break if number == 5
    end
    ```

With a `while` loop, the loop executes if the condition evaluates to `true`. The code within a `while` loop **may not execute at all** if the condition is not met. We can mimc this behaviour with a `loop` by placing `break` on the first line of the loop:
    ``` ruby
    counter = 0

    loop do
      break if counter == 0
      puts 'Hello!'
      counter += 1
    end
    ```

#### Next

When the `next` keyword is executed, it tells the loop to skip the rest of the current iteration and begin the next iteration.

For example, let's say we want to skip every odd number:
    ``` ruby
    counter = 0

    loop do
      counter += 1
      next if counter.odd?
      puts counter
      break if counter > 5 # Since 5 is odd, the condition changed from `counter == 5`
    end
    ```
*Note:* we had to move the counter += 1 up because the counter might not increment if it were after the `next` statement

### Iterating Over Collections

#### Strings & Arrays

*String example:*

``` ruby
alphabet = 'abcdefghijklmnopqrstuvwxyz'
counter = 0

loop do
  break if counter == alphabet.size
  puts alphabet[counter]
  counter += 1
end
```

With the loop above, the order of `counter += 1` and `break` doesn't matter too much. However, there are a couple edge cases that could break loops:
    - If our counter somehow surpassed `alphabet.size` (i.e. start at `counter >26`), then we could have an infinite loop

*Array example:*
``` ruby
colors = ['green', 'blue', 'purple', 'orange']
counter = 0

loop do
  break if counter == colors.size
  puts "I'm the color #{colors[counter]}!"
  counter += 1
end
```

#### Hash

Using `loop` to iterate over a hash is a bit more complicated because hashes use key-value pairs instead of a zero-based index. Since hash keys can be any object type, a simple counter variable won't let us retrieve the values.

Below, we get around this issue we create an array containing all of the keys in the hash using `Hash#keys`. Then we use this new array to iterate over the hash.

``` ruby
number_of_pets = {
  'dogs' => 2,
  'cats' => 4,
  'fish' => 1
}
pets = number_of_pets.keys # => ['dogs', 'cats', 'fish']
counter = 0

loop do
  break if counter == number_of_pets.size
  current_pet = pets[counter]
  current_pet_number = number_of_pets[current_pet]
  puts "I have #{current_pet_number} #{current_pet}!"
  counter += 1
end
```

### Summary

Looping has four basic elements:
    1. a loop
    2. a counter
    3. a way to retrieve the current value
    4. a way to exit the loop



## Introduction to PEDAC process

The *PEDAC process* is an approach to solving programming problems. It helps us identify and avoid pitfalls we may encounter when we code without intent.
    - P: Understand the *Problem*
    - E: *Examples*/Test cases
    - D: *Data structure*
    - A: *Algorithm*
    - C: *Code*

This framework helps us save time and solve complex problems efficiently.

In this section, we'll focus on three steps: *Understand the Problem*, *Data Structure* and *Algorithm*.


### P: Understand the Problem

Understanding the problem has three steps:
    1. Read the problem description
    2. Check the test cases, if any
    3. If any part of the problem is unclear, ask for clarification

Example:

``` ruby
# PROBLEM:

# Given a string, write a method change_me which returns the same string but with all the words in it that are palindromes uppercased.

# change_me("We will meet at noon") == "We will meet at NOON"
# change_me("No palindromes here") == "No palindromes here"
# change_me("") == ""
# change_me("I LOVE my mom and dad equally") == "I LOVE my MOM and DAD equally"
```

    Melinda attempt at understanding problem:
    - components to problem:
        - break sentence-string into words
        - identify palindrome
        - upper case certain words
        - assemble changed string

Launch School example of understanding problem:

Ask some clarifying questions such as:
    - What is a palindrome?
    - Should the words in the string remain the same if they already use uppercase?
    - How should I deal with empty string inputs? (*edge cases*)
    - Can I assume that all inputs are strings?
    - Should I consider leter case when deciding if the word is a palindrome?
    - *Do I need to return the same string object or an entirely new string?*

**I often make assumptions about the problem. Always verify assumptions either by looking at test cases or by asking the interviewer.**

Then to conclude the 'Understand the Problem' step, we should write down inputs, outputs, and describe rules to follow.

input: string
output: string (not the same object)
rules:
    Explicit requirements:
        every palindrome in the string must be converted to uppercase. (Reminder: a palindrome is a word that reads the same forwards and backward).
        Palindromes are case sensitive ("Dad" is not a palindrome, but "dad" is.)
    Implicit requirements:
        the returned string shouldn't be the same tring object.


### D&A: Data Structure & Algorithm

Data structures influence your algorithm; this is why these two steps are often paired. Deciding a data structure is usually easy. However, designing the right algorithm is more challenging -- *often students do not provide sufficient detail when writing algorithms.*

Example problem and 'Understand the problem' write-up:

PROBLEM: Given a string, write a method `palindrome_substrings` which returns all the substrings from a given string which are palindromes. Consider palindrome words case sensitive.

Test cases:
- palindrome_substrings("supercalifragilisticexpialidocious") == ["ili"]
- palindrome_substrings("abcddcbA") == ["bcddcb", "cddc", "dd"]
- palindrome_substrings("palindrome") == []
- palindrome_substrings("") == []

Some questions you might have?
1. What is a substring?
2. What is a palindrome?
3. Will inputs always be strings?
4. What does it mean to treat palindrome words case-sensitively?

- Input: string
- Output: an array of substrings
- Rules:
....- Explicit requirements:
........- return only substrings which are palindromes.
........- palindrome words should be case sensitive, meaning "abBA" is not a palindrome.

Algorithm:

*substrings method*

 - create an empty array called `result` which will contain all
    the required substrings
  - initialize variable start_substring_idx and assign 0 to it.
  - initialize variable end_substring_idx and assign value of
    start_substring_idx + 1 to it.
  - Enter loop which will break when start_substring_idx is equal
      to str.size - 1
    - Within that loop enter another loop which will break if
      end_substring_idx is equal to str.size
      - append to the result array part of the string from
        start_substring_idx to end_substring_idx
      - increment `end_substring_idx` by 1.
    - end the inner loop
    - increment `start_substring_idx` by 1.
    - reassign `end_substring_idx` to `start_substring_idx += 1`
  - end outer loop
  - return `result` array

*is_palindrome? method*

  - check whether the string value is equal to its reversed
    value. You can use the String#reverse method.

*palindrome_substrings method*

  - initialize a result variable to an empty array
  - create an array named substring_arr that contains all of the
    substrings of the input string that are at least 2 characters long.
  - loop through the words in the substring_arr array.
    - if the word is a palindrome, append it to the result
      array
  - return the result array



## Selection & Transformation

Besides *iteration*, two more actions to perform on a collection are:
    - *Selection*: picking certain elements out of the collection depending on some criterion.
    - *Transformation*: manipulating every element in the collection.

Remeber that selection and transformation both use the basics of looping:
    1. A loop
    2. A counter
    3. A way to retrieve the current value
    4. A way to exit the loop
And they require an additional piece of information: *some criteria*
    - Selection: uses criteria to determine which elements are selected
    - Transformation: uses criteria to determine how to perform the transformation

### Looping to Select and Transform

*Selection criteria*: what determines which values are selected and which are ignored
*Transformation criteria*: the line in code that transforms each element of the collection...?

**When performing a transformation, pay attention to whether the original collection was mutated or if a new collection was returned**

### Extracting to Methods

Since usually selecting or transforming a collection is a very specific action, this action is usually extracted into convenience methods.

Regarding mutating arrays: Rather than returning a reference to a new arrray object, this method returns a reference to the mutated original array.

Whether a method mutates its arguments depends on its implementation.

### More Flexible Methods

We can create more flexible and generic methods by passing in additional arguments to alter the logic of the iteration. (Earlier we were only passing in one argument -- the object to iterate, select and transform on.)

#### Side note: The `for` loop

``` ruby
alphabet = 'abcdefghijklmnopqrstuvwxyz'

for char in alphabet.chars
  puts char
end
```
- Calling `String#chars` method on `alphabet` results in an array with each character of the String `alphabet` as its own element.
Launch School says we can think of `loop` and `for` as interchangable syntax.

### Summary

Key points:
1. We often perform iteration, selection or transformation operations on a collection to manipulate a collection nearly any way we need to
2. These actions can be moved into methods to reuse on different collections.
3. Note if the method mutates or returns the original collection.
4. We can make these methods more generic by allowing parameters to specify some criteria for selection or transformation
5. We can chain actions on collections; however, pay attention to the return value of these methods as we might end up invoking a method on an *empty collection* of `nil`.



## Methods

Ruby provides built-in methods to work with collections. Here, we'll look at: `each`, `select`, and `map`.

### `each` (an idiomatic iteration)

``` ruby
[1, 2, 3].each do |num|
  puts num
end
# => [1,2,3]
```
In the example above, the method `each` is being called on the array `[1,2,3]`. The method `each` takes a block (the `do...end` part). The code within the block is executed for each iteration.

How does the block know what `num` is? During each iteration, `each` sends the value of the current element to the block in the form of an argument. The argument for the block above is `num` and it represents the value of the current element in the array.

The *return value* for `each` is the original collection. The original collection is not mutated.

### `select`

``` ruby
[1, 2, 3].select do |num|
  num.odd?
end
# => [1,3]
```
To perform selection, `select` evaluates the **return value of the block**. More specifically, it looks at the **truthiness** of the return value (remember, only `nil` and `false` are not considered "truthy"). The method `select` will only select the element if the block returns a "truthy" value.

The *return value* of `select` is a *new collection* containing all selected elements. It no elements are selected, `select` returns an empty collection.

### `map`

``` ruby
[1, 2, 3].map do |num|
  num * 2
end
```

The method `map` uses the return value of the block to perform a *transformation*. It takes the value evaluated from the block and places it in a *new collection*.

The *return value* of `map` is a *new collection* whose elements are the return values of the block -- essentially each element of the original collection transformed.

#### Side note: Enumerable

`Array` and `Hash` both have their own `each` method specific to their class.

Methods `select` and `map` are defined in a module **Enumerable**, which is available to the `Array` and `Hash` classes.

The main point is: certain collection types have access to specific methods for a reason. However, not all methods are available to all different object types.

### Summary

Methods like `each`, `select`, and `map` allow for simpler implementations of common collection manipulation tasks.

It's crucial to understand how these methods use the block's return value to perform their inteded task.

