############################
# Methods and More Methods #
############################

# Goal of practice problems: gain a deep understanding of specific concepts.
# What specific concepts?

# From the summary, the key things to think about are:

    # How does the method treat the block's return value?
    # What is the return value of the method?
    # How can you use the Ruby docs to learn more about a method?
    # Is the method destructive?

# Problem 1

# What is the return value of the `select` method below? Why?

[1, 2, 3].select do |num|
  num > 5
  'hi'
end

# Answer: The method `select` returns an array containing all of the elements that gives the block a return truthy return value. Since the last line of the block is 'hi', a string with a truthy value, all elements `num` result in the block returning a truthy value, even though none of the numbers are greater than 5. Therefore we expect `select` to return a new array object with all the original elements: [1, 2, 3]

# Problem 2

# How does `count` treat the block's return value? How can we find out?

['ant', 'bat', 'caterpillar'].count do |str|
  str.length < 4
end

# Answer: To answer the second question, we can find out how `count` treates the block's return value by looking at the documentation!
# According to the documentation, `count` returns an integer. In the case of a block, the return value is evaluated to see if it is "truthy" or "falsey". Elements that result in a "truthy" value add one to the integer count that is returned by `count`.

# Problem 3

# What is the return value of `reject` in the following code? Why?

[1, 2, 3].reject do |num|
  puts num
end

# Answer: According to the documentation, the return value of `reject` is an array containing the elements for which the block returns `false`.
# In this block, the block will return `nil` for each element since the return value of `puts` is `nil`. Since `nil` is a "falsey" value, I would expect the return value to be a new array with all elements from the original collection: [1, 2, 3].

# Problem 4

# What is the return value of `each_with_object` in the following code? Why?

['ant', 'bear', 'cat'].each_with_object({}) do |value, hash|
  hash[value[0]] = value
end

# I would expect the return value of this method call to be the hash:
# { a: 'ant', b: 'bear', c: 'cat'}.
# The method `each_with_object` modifies the collection passed in as an argument. On each iteration, a key-value pair is added to this hash (referenced by variable `hash`). The key is set to be the first element of the element `value`; since we are indexing a string, the key is the first character of the string. We then set the key's corresponding value to be the string associated with variable `value`, which is the whole string.

# Problem 5

# What does shift do in the following code? How can we find out?

hash = { a: 'ant', b: 'bear' }
hash.shift

# Answer: To find out what `shift` does, we can look at the documentation! It says:
# "Removes a key-value pair from [the calling hash] and returns it as the two-item array [key, value], or the hash's default value if the ash is empty."
# Based on the documentation, it sounds like `hash` will be modified to remove the first key-pair value, and the `shift` method will return the removed key-pair value. In the end, hash = { b: 'bear' } and the return value of hash.shift is [a:, 'ant'].

# Problem 6

# What is the return value of the following statement? Why?

['ant', 'bear', 'caterpillar'].pop.size

# Here, we are chaining the methods `pop` and `size` to the calling array. 'Array#pop' destructively removes the last element from the calling array and returns the mutated calling array. `Array#size`returns an integer reflecting the number of elements in the calling array. Therefore, we would expect the return value of the statement to be 2, the size of the original array with an element removed.

# MELINDA WAS WRONG:
# There are a couple things going on here. First, pop is being called on the array. pop destructively removes the last element from the calling array and **returns it**. Second, size is being called on the return value by pop. Once we realize that size is evaluating the return value of pop (which is "caterpillar") then the final return value of 11 should make sense.

# Problem 7

# What is the block's return value in the following code? How is it determined?
# Also, what is the return value of any? in this code and what does it output?

[1, 2, 3].any? do |num|
  puts num
  num.odd?
end

# Answer: The block's return value is either true or false, depending on if the element referenced by `num` is an odd or even number.
# The return value of `any?` is also either true or false, depending on if there was an element in the original collection that resulted in a return value of `true` by the block.

# Problem 8

# How does `take` work? Is it destructive? How can we find out?

arr = [1, 2, 3, 4, 5]
arr.take(2)

# Answer: According to the ruby documentation, `Array#take` has one argument - an integer n for the number of elements to take from the array. The return value is a new array filled with the elements taken.
# The method `Array#take` is not destructive because it populates and returns a new array object with the first n elements of the calling array.
# To verify this method's behaviour, we can make a couple test cases in irb to see if the calling object is mutated or not.

# Problem 9

# What is the return value of `map` in the following code? Why?

{ a: 'ant', b: 'bear' }.map do |key, value|
  if value.size > 3
    value
  end
end

# Answer: The retunr value of `map` is typically a new array object with the results of running the block on each element of the calling collection.
# In this case, the return value will be ['bear'], as it is the only value in the given hash that has a size greater than 3.

# MELINDA WAS WRONG
# The return value is [nil, "bear"].
# There are some interesting things to point out here. First, the return value of map is an array, which is the collection type that map always returns. Second, where did that nil come from? If we look at the if condition (value.size > 3), we'll notice that it evaluates to true when the length of value is greater than 3. In this case, the only value with a length greater than 3 is 'bear'. This means that for the first element, 'ant', the condition evaluates to false and value isn't returned.
# When none of the conditions in an if statement evaluates as true, the if statement itself returns nil. That's why we see nil as the first element in the returned array.

# Problem 10

# What is the return value of the following code? Why?

[1, 2, 3].map do |num|
  if num > 1
    puts num
  else
    num
  end
end

# The return value is [1, nil, nil]. The method `map` returns an array with the return value of the block after processing each element of the calling collection. Since any number greater than 1 will enter the if statement and the output of `puts` is nil, the resulting array will be nil for any element greater than 1.



#######################
# Additional Practice #
#######################

# Problem 1

# Given the array:

flintstones = ["Fred", "Barney", "Wilma", "Betty", "Pebbles", "BamBam"]

# Turn this array into a hash where the names are the keys and the values are the positions in the array.

# Answer:

flintstones_hash = {}
flintstones.each_with_index do |name, idx|
  flintstones_hash[name.to_sym] = idx
end

# Problem 2

# Add up all the ages from the Munster family hash:

ages = { "Herman" => 32, "Lily" => 30, "Grandpa" => 5843, "Eddie" => 10, "Marilyn" => 22, "Spot" => 237 }

# Answer:
total_ages = 0
ages.each { |key, value| total_ages += value }

# Another solution from launch school
ages.values.inject(:+)

# `ages.values` makes an array of the values. Using the `Enumerable#inject` method the way we have says "apply the `+` operator to the accumulator and object parameters of `inject`."

# Problem 3

# In the age hash:

ages = { "Herman" => 32, "Lily" => 30, "Grandpa" => 402, "Eddie" => 10 }

# remove people with age 100 and greater

# Answer
age.delete_if { |key, value| value >= 100 }

# Launch School solution
ages.keep_if { |_, age| age < 100 }

# You could also use #select! here. When using similar methods however, it is important to be aware of the subtle differences in their implementation. For example, the Ruby Documentation for Hash#select! tells us that it is "Equivalent to Hash#keep_if, but returns nil if no changes were made", though in this case that wouldn't have made any difference.

# Problem 4

# Pick out the minimum age from our current Munster family hash:

ages = { "Herman" => 32, "Lily" => 30, "Grandpa" => 5843, "Eddie" => 10, "Marilyn" => 22, "Spot" => 237 }

# Answer:
min_age = ages.first[1] # record the first age in the hash
ages.values.each { |age| min_age = age if age < min_age }

# Launch School solution
ages.values.min

# Problem 5

# In the array:
flintstones = %w(Fred Barney Wilma Betty BamBam Pebbles)
# Find the index of the first name that starts with "Be"

# Answer
index = nil
flintstones.each_with_index do |name, idx|
  index = idx if name[0,2] == "Be"
end

# Launch School solution:
flintstones.index { |name| name[0, 2] == "Be" }

# Problem 6

# Amend this array so that the names are all shortened to just the first three characters:
flintstones = %w(Fred Barney Wilma Betty BamBam Pebbles)

# Answer
flintstones.map!{ |name| name[0,3] }

# Problem 7

# Create a hash that expresses the frequency with which each letter occurs in this string:
statement = "The Flintstones Rock"

# Answer
letter_count = {}
statement = statement.downcase
statement.each_char do |char|
  if letter_count.keys.include?(char)
    letter_count[char] += 1
  else
    letter_count[char] = 1
  end
end

# Launch school solution
result = {}
letters = ('A'..'Z').to_a + ('a'..'z').to_a
letters.each do |letter|
  letter_frequency = statement.scan(letter).count
  result[letter] = letter_frequency if letter_frequency > 0
end

# Problem 8

# What happens when we modify an array while we are iterating over it? What would be output by this code?

numbers = [1, 2, 3, 4]
numbers.each do |number|
  p number
  numbers.shift(1)
end

# What would be output by this code?

numbers = [1, 2, 3, 4]
numbers.each do |number|
  p number
  numbers.pop(1)
end




