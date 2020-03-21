## 1. Enumerable Class Creation

Assume we have a `Tree` class that implements a binary tree. 
What methods would the `Tree` class have to provide to use the module `Enumerable`?

ANSWER: The `Tree` class must provide two methods: `#each` and `#<=>`.

## 2. Optional Blocks

Write a method that takes an optional block. If the block is specified, the method should execute it, and return the value returned by the block. If no block is specified, the method should simply return the String 'Does not compute.'.

Examples:
``` ruby
compute { 5 + 3 } == 8
compute { 'a' + 'b' } == 'ab'
compute == 'Does not compute.'
```

ANSWER: 
``` ruby
def compute
  block_given? ? yield : 'Does not compute'
end
```

## 3. Find Missing Numbers

Write a method that takes a sorted array of integers as an argument, and returns an array that includes all of the missing integers (in order) between the first and last elements of the argument.

``` ruby
def missing(sorted_array)
  given_range = (sorted_array[0]..sorted_array[-1])
  missing_elements = []
  
  for num in given_range
    missing_elements << num unless sorted_array.include?(num)
  end

  missing_elements
end
```

## 4. Divisors

Write a method that returns a list of all of the divisors of the positive integer passed in as an argument. The return value can be in any sequence you wish.

Test cases:
``` ruby
divisors(1) == [1]
divisors(7) == [1, 7]
divisors(12) == [1, 2, 3, 4, 6, 12]
divisors(98) == [1, 2, 7, 14, 49, 98]
divisors(99400891) == [1, 9967, 9973, 99400891] # may take a minute
```

ANSWER: 
``` ruby
def divisors(num)
  (1..num).select { |n| num % n == 0 }
end
```

## 5. Encrypted Pioneers

The following list contains the names of individuals who are pioneers in the field of computing or that have had a significant influence on the field. The names are in an encrypted form, though, using a simple (and incredibly weak) form of encryption called Rot13.

Test cases:
``` ruby
Nqn Ybirynpr
Tenpr Ubccre
Nqryr Tbyqfgvar
Nyna Ghevat
Puneyrf Onoontr
```

ANSWER:
``` ruby
def decipher_rot13_character(encrypted_char)
  case encrypted_char
  when 'a'..'m', 'A'..'M' then (encrypted_char.ord + 13).chr
  when 'n'..'z', 'N'..'Z' then (encrypted_char.ord - 13).chr
  else                         encrypted_char
  end
end

def decrypt_rot13(string)
  encrypt = string.chars
  decrypt = encrypt.map { |char| decipher_rot13_character(char) }
  decrypt.join
end
```

## 6. Iterators: True for Any?

Implement `Enumerable#any?`. The `Enumerable#any?` method processes elements in a collection by passing each element value to a block that is provided in the method call. If the block returns a value of true for any element, then #any? returns true. Otherwise, #any? returns false. Note in particular that #any? will stop searching the collection the first time the block returns true.

Write a method called any? that behaves similarly for Arrays. It should take an Array as an argument, and a block. It should return true if the block returns true for any of the element values. Otherwise, it should return false.

Your method should stop processing elements of the Array as soon as the block returns true.

If the Array is empty, any? should return false, regardless of how the block is defined.

Your method may not use any standard ruby method that is named all?, any?, none?, or one?.

ANSWER:
``` ruby
def any?(array)
  return false if array.empty?
  for elem in array
    return true if yield(elem)
  end
  false
end
```

## 7. Iterators: True for All?

Implement `Enumerable#all?`. `Enumerable#all?` processes elements in a collection by passing each element value to a block that is provided in the method call. If the block returns a value of true for every element, then #all? returns true. Otherwise, #all? returns false. Note in particular that #all? will stop searching the collection the first time the block returns false.

Write a method called all? that behaves similarly for Arrays. It should take an Array as an argument, and a block. It should return true if the block returns true for all of the element values. Otherwise, it should return false.

Your method should stop processing elements of the Array as soon as the block returns false.

If the Array is empty, all? should return true, regardless of how the block is defined.

Your method may not use any standard ruby method that is named all?, any?, none?, or one?.

ANSWER: 
``` ruby
def all?(collection)
  collection.each do |elem|
    return false unless yield(elem)
  end
  true
end
```

## 8. Iterators: True for None?

Enumerable#none? processes elements in a collection by passing each element value to a block that is provided in the method call. If the block returns true for any element, then #none? returns false. Otherwise, #none? returns true. Note in particular that #none? will stop searching the collection the first time the block returns true.

Write a method called none? that behaves similarly for Arrays. It should take an Array as an argument, and a block. It should return true if the block returns false for all of the element values. Otherwise, it should return false.

Your method should stop processing elements of the Array as soon as the block returns true.

If the Array is empty, none? should return true, regardless of how the block is defined.

Your method may not use any of the following methods from the Array and Enumerable classes: all?, any?, none?, one?. You may, however, use either of the methods created in the previous two exercises.

ANSWER:
``` ruby
def none?(collection)
  collection.each do |elem|
    return false if yield(elem)
  end
  true
end
```

## 9. Iterators: True for One?

Enumerable#one? processes elements in a collection by passing each element value to a block that is provided in the method call. If the block returns a value of true for exactly one element, then #one? returns true. Otherwise, #one? returns false. Note in particular that #one? will stop searching the collection the second time the block returns true.

Implement this method for arrays.

ANSWER:
``` ruby
def one?(collection)
  counter = 0
  collection.each do |elem|
    counter += 1 if yield(elem)
  end
  counter == 1
end
```

## 10. Count Items

Write a method that takes an array as an argument, and a block that returns true or false depending on the value of the array element passed to it. The method should return a count of the number of times the block returns true.

You may not use Array#count or Enumerable#count in your solution.

ANSWER:
``` ruby
def count(collection)
  counter = 0
  collection.each do |elem|
    counter += 1 if yield(elem)
  end
  counter
end
```