## Practice Problems: Easy 3

### Question 1

If we have this code:
``` ruby
class Greeting
  def greet(message)
    puts message
  end
end

class Hello < Greeting
  def hi
    greet("Hello")
  end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end
```
What happens in each of the following cases:
``` ruby
# Case 1
hello = Hello.new
hello.hi

# Case 2
hello = Hello.new
hello.bye

# Case 3
hello = Hello.new
hello.greet

# Case 4
hello = Hello.new
hello.greet("Goodbye")

# Case 5
Hello.hi
```

Case 1: In case one, we initialize a new `Hello` object and call the instance method `hi`. This will result in `"Hello"` being printed out, as the `Hello#hi` method invokes `Greeting#greet`, which then outputs whatever `String` argument is passed in.

Case 2: We would get a `NameError` as there is no variable or method named "bye" available to the `Hello` object.

Case 3: We would get an `ArgumentError`, as `Greeting#greet` requires one argument. We would *not* get a `NameError` for invoking `greet` on `hello` since `Hello` class subclasses from `Greeting`, and thus has access to its parent's method `greet`.

Case 4: We would get the output "Goodbye". Since `hello` is an instance of `Hello`, which is a subclass of `Greeting`, we can invoke the method `greet` with `hello` with no errors. As the method `Greeting#greet` takes one argument and prints it, we would print the argument string `"Goodbye"`.

Case 5: There is no class method `hi` for `Hello`, so we would get a `NameError`.


### Question 2

In the last question we had the following classes:
``` ruby
class Greeting
  def greet(message)
    puts message
  end
end

class Hello < Greeting
  def hi
    greet("Hello")
  end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end
```
If we call `Hello.hi` we get an error message. How would you fix this?

I would fix this by either writing a new class method:
``` ruby
def self.hi
    # some stuff to do
end
```


### Question 3

When objects are created they are a separate realization of a particular class.

Given the class below, how do we create two different instances of this class, both with separate names and ages?
``` ruby
class AngryCat
  def initialize(age, name)
    @age  = age
    @name = name
  end

  def age
    puts @age
  end

  def name
    puts @name
  end

  def hiss
    puts "Hisssss!!!"
  end
end
```

We can make two unique instances of `AngryCat` by invoking the `new` method twice and passing in different arguments like so:
``` ruby
boots = AngryCat.new(2, "Boots")
hercules = AngryCat.new(7, "Hercules")
```


### Question 4

Given the class below, if we created a new instance of the class and then called `to_s` on that instance we would get something like `"#<Cat:0x007ff39b356d30>"`
``` ruby
class Cat
  def initialize(type)
    @type = type
  end
end
```
How could we go about changing the `to_s` output on this method to look like this: `I am a tabby cat`? (This is assuming that "tabby" is the type we passed in during initialization.)

We could implement a `to_s` method within the class that specifies the output when `to_s` is called on an instance of `Cat`:
``` ruby
def to_s
  puts "I am a #{type} cat!"
end
```
Notice above that we insert the cat's type by referencing a getter method for `@type` that doesn't exist yet! So we would have to add one more line to the class definition: `attr_reader :type`.


### Question 5

If I have the following class:
``` ruby
class Television
  def self.manufacturer
    # method logic
  end

  def model
    # method logic
  end
end
```
What would happen if I called the methods like shown below?
``` ruby
tv = Television.new
tv.manufacturer
tv.model

Television.manufacturer
Television.model
```

Given the code, the first line `tv = Television.new` should be okay, as its just initializing a new `Television` object. The next line `tv.manufacturer` will result in a `NameError`, as there is no instance method `manufacturer` defined within the class. However, the following line will be okay since `tv` is an instance of `Television` and has access to the `Television#model` instance method.

If we were to call `Television.manufacturer`, that would be okay since we are invoking the class method `manufacturer` with the class `Television`. However, we would get a `NameError` for undefined method model with the line `Television.model` since there is no class method `model` for `Television` (only an instance method).


### Question

If we have a class such as the one below:
``` ruby
class Cat
  attr_accessor :type, :age

  def initialize(type)
    @type = type
    @age  = 0
  end

  def make_one_year_older
    self.age += 1
  end
end
```
In the `make_one_year_older` method we have used `self`. What is another way we could write this method so we don't have to use the `self` prefix?

Instead of writing `self.age += 1`, we could write `@age += 1`.

**Launch School elaboration**: `self` in this case is referencing the setter method provided by `attr_accessor` - this means that we could replace `self` with `@`


### Question

What is used in this class but doesn't add any value?
``` ruby
class Light
  attr_accessor :brightness, :color

  def initialize(brightness, color)
    @brightness = brightness
    @color = color
  end

  def self.information
    return "I want to turn on the light with a brightness level of super high and a color of green"
  end

end
```
We currently have no use for getter and setter methods for `@brightness` and `@color`. Also, the `return` in `Light#information` does not add any value, as the string will be returned regardless.
