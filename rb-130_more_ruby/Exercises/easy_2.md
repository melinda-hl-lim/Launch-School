## 1. From-To-Step Sequence Generator

The `Range#step` method lets you iterate over a range of values where each value in the iteration is the previous value plus a "step" value. It returns the original range.

Write a method that does the same thing as `Range#step`, but does not operate on a range. Instead, your method should take 3 arguments: 
    1. the starting value,
    2. the ending value, 
    3. and the step value to be applied to each iteration. 
Your method should also take a block to which it will yield (or call) successive iteration values.

Test case:
``` ruby
step(1, 10, 3) { |value| puts "value = #{value}" }
```

ANSWER:
``` ruby
def step(min, max, step)
  range = create_range(min, max, step)
  range.each { |num| yield(num) if block_given? }

  range
end

def create_range(min, max, step)
  range = []
  counter = min

  while counter <= max
    range << counter
    counter += step
  end

  range
end
```

## 2. Zipper

The `Array#zip` method takes two arrays, and combines them into a single array in which each element is a two-element array where the first element is a value from one array, and the second element is a value from the second array, in order. For example:
``` ruby
[1, 2, 3].zip([4, 5, 6]) == [[1, 4], [2, 5], [3, 6]]
```

Write your own version of zip that does the same type of operation. It should take two Arrays as arguments, and return a new Array (the original Arrays should not be changed). Do not use the built-in Array#zip method. You may assume that both input arrays have the same number of elements.

ANSWER
``` ruby
def zip(arr1, arr2)
  zipped = []
  arr1.length.times { |n| zipped << [arr1[n], arr2[n]] }
  zipped
end
```

## 3. map

Write a method called map that behaves similarly for Arrays. It should take an Array as an argument, and a block. It should return a new Array that contains the return values produced by the block for each element of the original Array.

If the Array is empty, map should return an empty Array, regardless of how the block is defined.

Tests given:
``` ruby
map([1, 3, 6]) { |value| value**2 } == [1, 9, 36]
map([]) { |value| true } == []
map(['a', 'b', 'c', 'd']) { |value| false } == [false, false, false, false]
map(['a', 'b', 'c', 'd']) { |value| value.upcase } == ['A', 'B', 'C', 'D']
map([1, 3, 4]) { |value| (1..value).to_a } == [[1], [1, 2, 3], [1, 2, 3, 4]]
```

ANSWER:
``` ruby
def map(arr)
  result = []
  arr.each { |elem| result << yield(elem) if block_given? }
  result
end
```

## 4. count

The Enumerable#count method iterates over the members of a collection, passing each element to the associated block. It then returns the number of elements for which the block returns a truthy value.

Write a method called count that behaves similarly for an arbitrarily long list of arguments. It should take 0 or more arguments and a block, and then return the total number of arguments for which the block returns true.

If the argument list is empty, count should return 0.

Tests given:
``` ruby
count(1, 3, 6) { |value| value.odd? } == 2
count(1, 3, 6) { |value| value.even? } == 1
count(1, 3, 6) { |value| value > 6 } == 0
count(1, 3, 6) { |value| true } == 3
count() { |value| true } == 0
count(1, 3, 6) { |value| value - 6 } == 3
```

ANSWER:
``` ruby
def count(*args)
  count = 0
  args.each do |arg|
    result = yield(arg) if block_given?
    count += 1 if result
  end
  count
end
```

## 5. drop_while

The Enumerable#drop_while method begins by iterating over the members of a collection, passing each element to the associated block until it finds an element for which the block returns false or nil. It then converts the remaining elements of the collection (including the element that resulted in a falsey return) to an Array, and returns the result.

Write a method called drop_while that behaves similarly for Arrays. It should take an Array as an argument, and a block. It should return all the elements of the Array, except those elements at the beginning of the Array that produce a truthy value when passed to the block.

If the Array is empty, or if the block returns a truthy value for every element, drop_while should return an empty Array.

Tests given:
``` ruby
drop_while([1, 3, 5, 6]) { |value| value.odd? } == [6]
drop_while([1, 3, 5, 6]) { |value| value.even? } == [1, 3, 5, 6]
drop_while([1, 3, 5, 6]) { |value| true } == []
drop_while([1, 3, 5, 6]) { |value| false } == [1, 3, 5, 6]
drop_while([1, 3, 5, 6]) { |value| value < 5 } == [5, 6]
drop_while([]) { |value| true } == []
```

LS ANSWER:
``` ruby
def drop_while(array)
  index = 0
  while index < array.size && yield(array[index])
    index += 1
  end

  array[index..-1]
end
```

## 6. each_with_index

The Enumerable#each_with_index method iterates over the members of a collection, passing each element and its index to the associated block. The value returned by the block is not used. each_with_index returns a reference to the original collection.

Write a method called each_with_index that behaves similarly for Arrays. It should take an Array as an argument, and a block. It should yield each element and an index number to the block. each_with_index should return a reference to the original Array.

Test case:
``` ruby
result = each_with_index([1, 3, 6]) do |value, index|
  puts "#{index} -> #{value**index}"
end

puts result == [1, 3, 6]
# Should output: 
# 0 -> 1
# 1 -> 3
# 2 -> 36
# true
```

ANSWER:
``` ruby
def each_with_index(array)
  index = 0
  array.each do |value|
    yield(value, index)
    index += 1
  end
  array
end
```

## 7. each_with_object

## 8. max_by

## 9. each_cons (Part 1)

## 10. each_cons (Part 2)