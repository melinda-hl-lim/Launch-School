## Equivalence

Everything in Ruby is an object! Except: methods, blocks, if statements, argument lists, etc... It's a super usefule shorthand though!

There are a couple methods to check for equality in Ruby.
    - `#==`: checks for equivalent values within the object
        - This is the most important method to remember
    - `#equal?`: checks that the variables are pointing to the same object
        - DO NOT override `equal?`
    - `#===`: checks if the second object belongs with the first object if the first object is a group
        - Rarely called explicitly; usually implemented in custom classes if objects will be used in `case` statements
    - `#eql?`: this method is very rarely used


### The `==` Method

*Note:* `==` is NOT an operator; it's an instnace method available on all objects

For custom objects from a class we write, we need to write a `==` method:

``` ruby
class Person
    attr_accessor :name

    def ==(other)
        name == other.name
    end
end
```
Here, we override the default `BasicObject#==` method (that checks that the variables are pointing to the same object)

We can implement `#==` however we want, and can even include conversions such as how `Integer#==` can convert a `Float` into an `Integer` object.

Another note: when you define a `==` method, you do not have to implement `!=` for it to work!

### The `object_id` Method

We can play around with the `object_id` method and learn something interesting:

``` ruby
arr1 = [1, 2, 3]
arr2 = [1, 2, 3]
arr1.object_id == arr2.object_id      # => false

sym1 = :something
sym2 = :something
sym1.object_id == sym2.object_id      # => true

int1 = 5
int2 = 5
int1.object_id == int2.object_id      # => true
```
Above, we see that symbols and integers behave differently than other objects in Ruby. If two symbols/integers have the same value, they are the same object.

### The `===` Method

The `===` is an instance method.

A good example to see `===` in action is when we have ranges in a `when` clause:

``` ruby
num = 25

case num
when 1..50
  puts "small number"
when 51..100
  puts "large number"
else
  puts "not in range"
end
```

Behind the scenes, `case` statement is using `===` to compare each `when` clause with `num`. We can visualize how it uses `===` below:

``` ruby
num = 25

if (1..50) === num
  puts "small number"
elsif (51..100) === num
  puts "large number"
else
  puts "not in range"
end
```

Unlike `==`, this method does *not* compare two objects' values. Instead, it makes a comparison asking *"if `(1..50)` is group, would `25` belong in that group?"*

### The `eql?` Method

This method checks if the two objects contain the same value and if they're of the same class. It's most often used by `Hash` to determine equality among its members; otherwise, it's not used often.


---


## Variable Scope

### Instance Variable Scope

Instance variables start with a `@` and are *scoped at the object level*. They're used to track individual object states and don't cross between objects.

With scope at the object level, instance variables are accesible in an object's instance methods.

If we try to reference an unititialized instance variable, we get `nil`. This is different from referencing uninitialized local variables, which returns a `NameError`.

### Class Variable Scope

Class variables start with a `@@` and are *scoped at the class level*. There are two main behaviours:
- all objects share 1 copy of the class variable
    - so objects can access class variables through instance methods
- class methods can access class variables, regardless of initialization location

### Constant Variable Scope

Constant variables (i.e. constants) are not supposed to be reassigned to a different value. Constants are usually all caps and have a *lexical scope*.

    Lexical scope is also known as static scope. This means "grouping things together based on where they appear in the code"

Constants are accessible from class and instance methods (which means they're accessible from objects).

Things get a bit tricky when inheritance is involved -- this is when we have to remember its lexical scope.


---


## Inheritance and Variable Scope

How does inheritance (subclassing and mixing in modules) affect variables?

### Instance Variables

With subclassing: if the initialize methods are written correctly, objects in the child class can have the same instance variables (without values) as those in the parent class

With mixing in modules: there aren't really surprising behaviours. Once the instance method from the module is initialized, the object can access that instance variable.

See example below:
``` ruby
module Swim
  def enable_swimming
    @can_swim = true
  end
end

class Animal
  def initialize(name)
    @name = name
  end
end

class Dog < Animal
  include Swim

  def dog_name
    "bark! bark! #{@name} bark! bark!"    # can @name be referenced here?
  end

  def swim
    "swimming!" if @can_swim
  end
end

teddy = Dog.new("Teddy")
puts teddy.dog_name     # => bark! bark! Teddy bark! bark!
teddy.enable_swimming
teddy.swim              # => swimming

```

### Class Variables

``` ruby
class Animal
  @@total_animals = 0

  def initialize
    @@total_animals += 1
  end
end

class Dog < Animal
  def total_animals
    @@total_animals
  end
end

spike = Dog.new
spike.total_animals     # => 1
```

Class variables look accessile to sub-classes.

However, it can be dangerous to work with class variables with inheritance because there's only one copy of the class variable across all sub-classes. See below:

``` ruby
class Vehicle
  @@wheels = 4

  def self.wheels
    @@wheels
  end
end

class Motorcycle < Vehicle
  @@wheels = 2
end

class Car < Vehicle; end

Motorcycle.wheels       # => 2
Vehicle.wheels          # => 2
Car.wheels              # =>
```

The original class variable `@@wheels` in `Vehicle` seems to have been overwritten by `@wheels` in `Motorcycle`! Also, this new value is reflected in not only the parent class, but also all subclasses of `Vehicle`.

So avoid using class variables when working with inheritance.
(The solution is to use *class instance variables*, but we haven't learnt that stuff yet.)

### Constants

When a constant is initialized in a super-class, its inherited y the sub-class and can be accessd by both class and instance methods (from the subclass).

However, things get a little hairier when modules are mixed in.

Constants are not evaluated at runtime, so their lexical scope (where they are used in the code) is very important.

``` ruby
module Maintenance
  def change_tires
    "Changing #{WHEELS} tires."
    # To fix the NameError, we rewrite the string interpolation as: #{Vehicle::WHEELS} or #{Car::WHEELS}
  end
end

class Vehicle
  WHEELS = 4
end

class Car < Vehicle
  include Maintenance
end

a_car = Car.new
a_car.change_tires # => NameError: uninitialized constant Maintenance::WHEELS
```

In the case above, Ruby looks for `WHEELS` in the `Maintenance` module. Even though `change_tires` can be called from a `Car` object, Ruby can't find the constant.

To fix it, see comment in `change_tires` definition.

Keep in mind: constant resolution rules are different from method lookup path or instance variables. Constant resolution will look at the lexical scope first, and then look at the inheritance hierarchy.


---


## Fake Operators

There's a handy-dandy table showing which operators are real operators, and which are methods in disguise. Go look at it.

Here's a quick list of operators that *are* operators:
- Logical "and": `&&`,
- Logical "or": `||`,
- Inclusive/exclusive rante: `..`, `...`,
- Ternary if-then-else: `? : `,
- Assignment (and shortcuts): `=`, `%=`, `/=`, `-=`, `+=`, `|=`, `&=`, `>>=`, `<<=`, `*=`, `&&=`, `||=`, `**=`,
    - *Note*: This does *not* mean that the `+` sign is an operator. It's a method.
- Block delimiter: `{`

**Some cool syntactical sugar that disguises methods as operators:**

Getter and setter methods for array elements
``` ruby
my_array = %w(first second third fourth) # ["first", "second", "third", "fourth"]

# element reference
my_array[2]                              # => "third"
my_array.[](2)                           # => "third"
```
The getter method is `Array#[]` and the setter method is `Array#[]=`

---


## Exceptions

Information from blog post: https://launchschool.com/blog/getting-started-with-ruby-exceptions

### What is an Exception?

An exception is simply an *exceptional state* in your code. It's not always bad: it's just Ruby's way of letting you know that your code is behaving unexpectedly.

If an exception is raised and your code doesn't handle the exception, the program will crash and you'll get a message about the error encountered.

Ruby provides a hierarchy of built-in classes to simply exception handling. The very top class of the hierarchy is `Exception`

#### The Exception Class Hierarchy

See the blog post for a nice long list of all exception classes! It's even got tabs to show parent/child relationships.

Cool fact Melinda learnt: Pressing `ctrl-c` to exit out of a prgraom is raising an exception via the `Interrupt` class!

### When Should You Handle an Exception

You mostly want to handle errors that are descendents of the `StandardError` class. It's relatively safe to handles these exceptions and continue running the program.

Some exceptions are more serious than others, and there are some errors that we *should* allow to crash the program. Errors such as `NoMemoryError`, `SyntaxError`, and `LoadError` must be addressed before the program can run properly.

Tl;dr: be very intentional and specific about which exceptions you want to handle and what action you want to take when you handle them.

### How to Handle an Exceptional State

*Note*: **Handling** an exception is a reaction to an exception that has already been *raised*.

#### The `begin/rescue` Block

``` ruby
begin
  # put code at risk of failing here
rescue TypeError, ZeroDivisionError # this block will handle two exception types
  # take action
rescue ArgumentError
  # take a different action
end
```
If the code in the `begin` block raises a `TypeError`, the code in the `rescue` block will be executed rather than exiting the program.

If no error type is specified at the begining of the `rescue` block, all `StandardError` exceptions will be rescued and handled.

#### Exception Objects and Built-In Methods

Exception objects are normal Ruby objects with built-in behaviours to make handling the exception/debugging easier.

The snippet `rescue TypeError => e` rescues any `TypeError` and stores the exception object in `e`.

**`ensure`**

We can also include an `ensure` clause in the `being/rescue` block. The clause will always execute, regardless of whether an exception was raised or not.

``` ruby
file = open(file_name, 'w')

begin
  # do something with file
rescue
  # handle exception
rescue
  # handle a different exception
ensure
  file.close
  # executes every time
end
```

It's a great place to serve as a single exit point for the block and allows us to put all of our cleanup code in one place.
*Note*: it's critical that the code in the `ensure` clause will *NOT* raise an exception.

**`retry`**

This method allows usto redirect the program to the `begin` statement and make another attempt to execute the code that raised an exception.

``` ruby
RETRY_LIMIT = 5

begin
  attempts = attempts || 0
  # do something
rescue
  attempts += 1
  retry if attempts < RETRY_LIMIT
end

```

*Note*: it's a good idea to limit the number of `retry` calls so you don't have an infinite loop.

Method `retry` must be used *within a `rescue` clause*; otherwise, there'll be a `SyntaxError`.

### Raising Exceptions Manually

Ruby gives us the power to manually raise exceptions by calling `Kernel#raise`. This allows us to choose the type of exception to raise and set our own error messages (with default exception being `RuntimeError`).

An example:
``` ruby
def validate_age(age)
  raise("invalid age") unless (0..105).include?(age)
end
```

We can handle these exceptions we raise manually in the same manner as any other exception Ruby raises:

``` ruby
begin
  validate_age(age)
rescue RuntimeError => e
  puts e.message              #=> "invalid age"
end
```

### Raising Custom Exceptions

We can create our own custom exception classes!
``` ruby
class ValidateAgeError < StandardError; end
```
We mostly want to inherit these custom exceptions from `StandardError`

