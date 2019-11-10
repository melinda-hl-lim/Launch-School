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




