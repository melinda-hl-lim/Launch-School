## Practice Problems: Easy 2

### Question 1

You are given the following code:
``` ruby
class Oracle
  def predict_the_future
    "You will " + choices.sample
  end

  def choices
    ["eat a nice lunch", "take a nap soon", "stay at work late"]
  end
end
```
What is the result of executing the following code:
``` ruby
oracle = Oracle.new
oracle.predict_the_future
```

**Launch School answer**: Each time you call, a string is returned which will be of the form "You will < something >", where the something is one of the 3 phrases defined in the array returned by the choices method. The specific string will be chosen randomly.


### Question 2

We have an `Oracle` class and a `RoadTrip` class that inherits from the `Oracle` class.
``` ruby
class Oracle
  def predict_the_future
    "You will " + choices.sample
  end

  def choices
    ["eat a nice lunch", "take a nap soon", "stay at work late"]
  end
end

class RoadTrip < Oracle
  def choices
    ["visit Vegas", "fly to Fiji", "romp in Rome"]
  end
end
```
What's the result of the following:
``` ruby
trip = RoadTrip.new
trip.predict_the_future
```

A string will be returned of the format "You will [ something ]". This [ something ] will be a random choice of strings from the `RoadTrip#choices` method.

**Launch School elaboration**: Ruby looks for `choices` in the `Roadtrip` class instead of the `Oracle` class because we are invoking these methods with an instance of the `Roadtrip` class, thus setting the start of the method lookup path for `choices` to the `Roadtrip` class.


### Question 3

How do you find where Ruby will look for a method when that method is called? How can you find an object's ancestors?
``` ruby
module Taste
  def flavor(flavor)
    puts "#{flavor}"
  end
end

class Orange
  include Taste
end

class HotSauce
  include Taste
end

```
What is the lookup chain for `Orange` and `HotSauce`?

You can find the method lookup path for any object by invoking the `ancestors` method on the object. The order in which the methods are searched for follow the output of `Class.ancestors`.

In this case, both `Orange` and `HotSauce` have very similar method lookup paths. It starts with `Orange` or `HotSauce` depending on the class you're looking at, and then goes: `Taste, Object, Kernel, BasicObject`


### Question 4

What could you add to this class to simplify it and remove two methods from the class definition while still maintaining the same functionality?
``` ruby
class BeesWax
  def initialize(type)
    @type = type
  end

  def type
    @type
  end

  def type=(t)
    @type = t
  end

  def describe_type
    puts "I am a #{@type} of Bees Wax"
  end
end
```
To simplify the implementation of `BeesWax`, we could replace the `type` and `type=()` getter and setter methods with Ruby's `attr_accessor` method.


### Question 5

There are a number of variables listed below. What are the different types and how do you know which is which?
``` ruby
excited_dog = "excited dog"
@excited_dog = "excited dog"
@@excited_dog = "excited dog"
```

The first variable is a local variable, the second variable is an instnace variable, and the third variable is a class variable. We can identify these by the symbols prepended (or not prepended) to the variable names. No symbols in front signify a local variable, one `@` symbol in front signifies an instance varable, and two `@` symbols in front signifies a class variable.


### Question 6

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
Which one of these is a class method (if any) and how do you know? How would you call a class method?

Of the methods above, `Television#manufacturer` is the class method. We know this because class methods are prepended with a `self` in the method definition.


### Question 7

If we have a class such as the one below:
``` ruby
class Cat
  @@cats_count = 0

  def initialize(type)
    @type = type
    @age  = 0
    @@cats_count += 1
  end

  def self.cats_count
    @@cats_count
  end
end
```
Explain what the `@@cats_count` variable does and how it works. What code would you need to write to test your theory?

The `@@cats_count` is a class variable. This means that all instances of the `Cat` class have a copy and are able to access the variable. Based on the variable name, I assume the class variable is keeping track of the number of instances of `Cat` exist.

To test this theory, we would need to make some `Cat` instances and see if each new `Cat` instance is incrementing the `@@cats_count` value.
``` ruby
Cat.new('tabby')
Cat.cats_count # => 1
Cat.new('fatty')
Cat.cats_count # => 2
```


### Question 8

If we have these classes:
``` ruby
class Game
  def play
    "Start the game!"
  end
end

class Bingo
  def rules_of_play
    #rules of play
  end
end
```
What can we add to the `Bingo` class to allow it to inherit the play method from the `Game` class?

We can make the `Bingo` class subclass from the `Game` class by rewriting the class definition line like so: `class Bingo < Game`. This will give `Bingo` access to any of `Game`'s methods that haven't been overwritten by `Bingo`.

### Question 9

If we have these classes:
``` ruby
class Game
  def play
    "Start the game!"
  end
end

class Bingo < Game
  def rules_of_play
    #rules of play
  end
end
```

What would happen if we added a `play` method to the `Bingo` class, keeping in mind that there is already a method of this name in the `Game` class that the Bingo class inherits from.

If we add a `play` method to the `Bingo` class, then whenever we invoke play on an instance of the `Bingo` class, we would enter the implementation of `Bingo#play` only and never reach `Game#play`. If we wanted to reach `Game#play` within the `Bingo#play` method, we would have to make a call to `#super`.

### Question 10

What are the benefits of using Object Oriented Programming in Ruby? Think of as many as you can.

Melinda answer:
- compartmentalizes methods into certain classes:
    - this helps with organization of code
    - and abstracting away certain methods that not every necessarily has to know the implementation of

**Launch School answer**:

1. Creating objects allows programmers to think more abstractly about the code they are writing.
2. Objects are represented by nouns so are easier to conceptualize.
3. It allows us to only expose functionality to the parts of code that need it, meaning namespace issues are much harder to come across.
4. It allows us to easily give functionality to different parts of an application without duplication.
5. We can build applications faster as we can reuse pre-written code.
6. As the software becomes more complex this complexity can be more easily managed.


