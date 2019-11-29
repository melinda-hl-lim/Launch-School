## Sorting

Sorting is typically used on arrays (because its elements are indexed). You can now sort hashes since Ruby keeps their input order, but it isn't typical.

### What is sorting?

Ruby provides methods `sort` and `sort_by` to help sort arrays.

The return value of `sort` is a *new* array. We don't need to understand the method implementation, but we need to unerstand how `sort` applies criterion to return an ordered collection.

### Comparison

Sorting is carried out by *comparing* items in a collection with each other and ordering them based on the result of that comparison. *Comparison is at the heart of how sorting works.*

The method to determine the order of elements is this: `<=>`, the spaceshpi operator.

### The `<=>` Method

Any object in a collection we want to sort **must** implement a `<=>` method. This method performs a comparison between two objects of the same type and reterns -1, 0, or 1 depending on whether the first object is less than, equal to, or greater than the second object. If two objects can't be compared, it returns `nil`.

If you want to sort a collection containing particular types of objects, you need to know two things:

    1. Does the object type implement a `<=>` comparison method?
    2. If yes, what is the specific implementation of that method for that object type?

### The `sort` Method

Return value: a new array of ordered items
Comparisons are carried out using the `<=>` method on items being sorted.

Calling `sort` with a block gives us more control over how the items are sorted. The block needs two arguments (for two items to be compared). The return value of the block has to be `-1`, `0`, `1`, or `nil`.

The example below shows us a little peak behind the `sort` method's inner workings:

``` ruby
[2, 5, 3, 4, 1].sort do |a, b|
  puts "a is #{a} and b is #{b}"
  a <=> b
end
# a is 2 and b is 5
# a is 4 and b is 1
# a is 3 and b is 1
# a is 3 and b is 4
# a is 2 and b is 1
# a is 2 and b is 3
# a is 5 and b is 3
# a is 5 and b is 4
# => [1, 2, 3, 4, 5]
```

### The `sort_by` Method

Return value is always a new array (regardless of calling collection type). This method is usually called with a block, and the block determines how the items are compared.

``` ruby
['cot', 'bed', 'mat'].sort_by do |word|
  word[1]
end
# => ["mat", "bed", "cot"]
```

### Other Methods Which Use Comparison

Objects being compared need to implement a `<=>` method in order to use these methods:
    - min
    - max
    - minmax
    - min_by
    - max_by
    - minmax_by

### Summary

- Sorting is complex to carry out algorithmically on your own, so we can use the built-in `sort` and `sort_by` methods to do it for us
- Comparison is at the heart of sorting.
- Objects in collections we want to sort must implement a `<=>` method for comparison



## Nested Data Structure

Here, we'll explore a few examples of how to work with nested data structures.

### Referencing Collection Elements

Given `arr = [[1, 3], [2]]`, `arr[0][1] == 3`.

### Updating Collection Elements

Recall that we can conveninently update array elements using a *destructive action*:

``` ruby
arr = [[1, 3], [2]]
arr[1] = "hi there"
arr # => [[1, 3], "hi there"]
```

We can modify nested arrays in a similar way:

``` ruby
arr = [[1, 3], [2]]
arr[0][1] = 5
```

*Note:* The first part of the array `arr[0]` is an *element reference* returning the inner array. The second part is the same as `[1, 3][1] = 5` - a *chained action* that is a *destructive array element update*.

How would we insert an additional element into an inner array? We have to chain element reference with appending an element.

``` ruby
arr = [[1], [2]]

arr[0] << 3
arr # => [[1, 3], [2]]
```

### Other nested structures

Hashes can also be nested.

Adding a key-value pair to a nested hash:

``` ruby
arr = [{ a: 'ant' }, { b: 'bear' }]

arr[0][:c] = 'cat'
arr # => [{ :a => "ant", :c => "cat" }, { :b => "bear" }]
```

#### Variable Reference for Nested Collections

A confusing aspect of nested collections is knowing when variables are referencing inner collections directly.

For example:

``` ruby
a = [1, 3]
b = [2]
arr = [a, b]
arr # => [[1, 3], [2]]
```

Local variables `a` and `b` point to two `Array` objects. These local variables are then placed as elements in the array `arr`.

After placing `a` and `b` in array `arr`, we see that the objects the local variables reference is not changed. Changing the first element in `a` to 5 also changes the value of the zeroth element in `arr`. Likewise, changing the first element in the zeroth element of `arr` changes the value of the array `a` references.

``` ruby
a[1] = 5
arr # => [[1, 5], [2]]

arr[0][1] = 8
arr # => [[1, 8], [2]]
a   # => [1, 8]
```

Remember, **variables are pointers to objects**.

#### Shallow Copy

Sometimes we need to copy the entire collection (usually when we want to save the original collection before performing some modifications).

Ruby provides two methods to copy an object, including collections: `dup` and `clone`. Both these methods create a *shallow copy*. This means that only the calling object is copied; objects inside the calling object (ex: a string element of an array) are *shared*, not copied.

Method `dup` allows objects within the copied object to be modified:

``` ruby
arr1 = ["a", "b", "c"]
arr2 = arr1.dup
arr2[1].upcase!

arr2 # => ["a", "B", "c"]
arr1 # => ["a", "B", "c"]
```

Method `clone` works the same way:

``` ruby
arr1 = ["abc", "def"]
arr2 = arr1.clone
arr2[0].reverse!

arr2 # => ["cba", "def"]
arr1 # => ["cba", "def"]
```

The two examples above modified both `arr1` and `arr2` because we called destructive methods on the objects *within* the array, rather than on the array itself. **We are affecting the object, not the collection.**


Here's an example of modifying the duplicated collection rather than the objects within the collection:
``` ruby
arr1 = ["a", "b", "c"]
arr2 = arr1.dup
arr2.map! do |char|
  char.upcase
end

arr1 # => ["a", "b", "c"]
arr2 # => ["A", "B", "C"]
```
We called the destructive method `Array#map!` on `arr2`. The method modifies the array by replacing each element of `arr2` with a new value.


And here's another example of modifying the objects within the duplicated collection, thus changing the objects within the original collection.
``` ruby
arr1 = ["a", "b", "c"]
arr2 = arr1.dup
arr2.each do |char|
  char.upcase!
end

arr1 # => ["A", "B", "C"]
arr2 # => ["A", "B", "C"]

```
We called the destructive method `String#upcase!` on each element of `arr2`. Since every element of `arr2` is a reference to the same object of the corresponding element in `arr1`, both arrays are changed.

**Note:** Be wary of the level you're working on: is it the level of the outer collection, or the level of the object within the collection?

#### Freezing Objects

The main difference between `dup` and `clone`: `clone` preserves the frozen state of the object

``` ruby
arr1 = ["a", "b", "c"].freeze
arr2 = arr1.clone
arr2 << "d"
# => RuntimeError: can't modify frozen Array

arr3 = arr1.dup
arr3 << "d"

arr1 # => ["a", "b", "c"]
arr3 # => ["a", "b", "c", "d"]
```

*What is freezing?* In Ruby, objects can be frozen to prevent them from being modified. Only mutable objects can be frozen, as immutable objects are already frozen.

*What does `freeze` actually freeze?* Method `freeze` only freezes the object it's called on -- objects contained inside the calling object are not frozen.

``` ruby
arr = ["a", "b", "c"].freeze
arr[2] << "d"
arr # => ["a", "b", "cd"]
```

#### Deep Copy

In Ruby, there's no built-in or easy way to create a *deep copy* or *deep freeze* objects within objects.

Therefore, it's important to be aware of:
    1. The level of objects you're working with
    2. The side effects of `freeze`, `dup`, and `clone`



## Working with Blocks

Example 1:

``` ruby
[[1, 2], [3, 4]].each do |arr|
  puts arr.first
end
# 1
# 3
# => [[1, 2], [3, 4]]
```

When evaluating code like the example above, we ask the following questions:

- What is the type of *action* being performed?
    - Method call; block; conditional; etc...
- What is the *object* that action is being performed on?
- What is the *side-effect* of that action?
    - E.g. Output or destructive action?
- What is the *return value* of that action?
- Is the *return value used* by whatever instigated the action?


Example for Melinda to try:

``` ruby
[[1, 2], [3, 4]].map do |arr|
  puts arr.first
  arr.first
end
```

The `Array#map` method is being called on the two-dimensional array object `[[1, 2], [3, 4]]`. In turn, each inner array is passed to the block and assigned to the local variable `arr`.

Within the block, two methods are called on the object referenced by local variable `arr`: first, the method `Array#first` is called to return the object at index `0`: with the current array, this returns `1` and `3` The `puts` method then outputs a string representation of the integer, and returns `nil`. However, the second line of the block is another method call to `Array#first` and returns the object at index `0`, which is also the return value of the block.

Back to the outer method call of `Array#map` on the 2D array: the method `map` uses the block's return value to populate a new array object, which is then returned. Therefore, the return value of this code snippet is a new Array object `[1, 3]`.

**Remember:** Don't mutate the collection you're iterating through.



## Lesson 5 Summary

Important points to remember:

- Reference items within nested collections in order to manipulate them
- When making a copy of a collection object, it's just a shallow copy -- objects within the collection are shared between the original and copy
- When working with blocks:
    - understand the structure of a collection
    - choose an appropriate method and be clear on its implementation and return value
    - Understand what's being returned by various methods and blocks at each level





