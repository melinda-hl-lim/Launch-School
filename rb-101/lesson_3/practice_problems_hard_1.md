### Question 1
What do you expect to happen when the greeting variable is referenced in the last line of the code below?

``` ruby
if false
  greeting = “hello world”
end

greeting
```

#### Answer 1

The greeting variable is initialized inside the `if` block; therefore it is local to the block and only accessible within the block. Therefore the last line of code will return an error about an undefined variable.

#### CORRECTION for 1

Launch School says: "`greeting` is `nil` here, and there is no "undefined method or local variable" error thrown. Typically, when you reference an uninitialized variable, Ruby will raise an exception, stating that it’s undefined. However, when you initialize a local variable within an `if` block, even if that `if` block doesn’t get executed, the local variable is initialized to `nil`."


### Question 2

What is the result of the last line in the code below?

``` ruby
greetings = { a: 'hi' }
informal_greeting = greetings[:a]
informal_greeting << ' there'

puts informal_greeting  #  => "hi there"
puts greetings
```

#### Answer 2

The last line of code, `puts greetings` will output the hash object that variable `greetings` refers to. The return value will be `nil`, however, because the return value of `puts()` is always `nil`.

#### CORRECTION for 2

The output is `{:a => "hi there"}` because (1) `informal_greeting` references the original key-pair value in the `greetings` hash and (2) the line `informal_greeting << ' there'` mutates the caller object.


### Question 3

In other practice problems, we have looked at how the scope of variables affects the modification of one "layer" when they are passed to another.

To drive home the salient aspects of variable scope and modification of one scope by another, consider the following similar sets of code.

What will be printed by each of these code groups?

#### Answer 3a

``` ruby
def mess_with_vars(one, two, three)
  one = two
  two = three
  three = one
end

one = "one"
two = "two"
three = "three"

mess_with_vars(one, two, three)

puts "one is: #{one}"
puts "two is: #{two}"
puts "three is: #{three}"
```

In the definition of `mess_with_vars()` above, we reassign local varaible `one` to reference the object referenced by `two`, we reassign local variable `two` to reference the object referenced by `three`, and we reasign local variable `three` to reference the objected referenced by `one` (which so happens to now be the object originally referenced by `two`). So we get the output shows that:

    one is: two
    two is: three
    three is: two

#### CORRECTION for 3a

    one is: one
    two is: two
    three is: three

#### Answer 3b

``` ruby
def mess_with_vars(one, two, three)
  one = "two"
  two = "three"
  three = "one"
end

one = "one"
two = "two"
three = "three"

mess_with_vars(one, two, three)

puts "one is: #{one}"
puts "two is: #{two}"
puts "three is: #{three}"
```

In the definition of `mess_with_vars()` above, we reassign:
 - local variable `one` to reference an object with value "two",
 - local variable `two` to reference an object with value "three",
 - and local variable `three` to reference an object with value "one"

 Therefore we expect the output to be:

    one is: two
    two is: three
    three is: two

#### CORRECTION for 3b

    one is: one
    two is: two
    three is: three

#### Answer 3c

``` ruby
def mess_with_vars(one, two, three)
  one.gsub!("one","two")
  two.gsub!("two","three")
  three.gsub!("three","one")
end

one = "one"
two = "two"
three = "three"

mess_with_vars(one, two, three)

puts "one is: #{one}"
puts "two is: #{two}"
puts "three is: #{three}"
```

In the definition of `mess_with_vars()` above, we use the `String#gsub!` method to change the value of the local variables. Since `String#gsub!` is a destructive method and modifies the caller object, we can expect the output to be:

    one is: two
    two is: three
    three is: two

And I got this part right!!!


### Question 4

Ben was tasked to write a simple ruby method to determine if an input string is an IP address representing dot-separated numbers. e.g. "10.4.5.11". He is not familiar with regular expressions. Alyssa supplied Ben with a method called is_an_ip_number? that determines if a string is a numeric string between 0 and 255 as required for IP numbers and asked Ben to use it.

``` ruby
def dot_separated_ip_address?(input_string)
  dot_separated_words = input_string.split(".")
  while dot_separated_words.size > 0 do
    word = dot_separated_words.pop
    break unless is_an_ip_number?(word)
  end
  return true
end
```

Alyssa reviewed Ben's code and says "It's a good start, but you missed a few things.
- You're not returning a false condition,
- and you're not handling the case that there are more or fewer than 4 components to the IP address (e.g. "4.5.5" or "1.2.3.4.5" should be invalid)."

Help Ben fix his code.

#### Answer 4

``` ruby
def dot_separated_ip_address?(input_string)
  dot_separated_words = input_string.split(".")
  return false if dot_seperated_words.length != 4

  while dot_separated_words.size > 0 do
    word = dot_separated_words.pop
    return false unless is_an_ip_number?(word)
  end

  return true
end
```

I got this right!!!





