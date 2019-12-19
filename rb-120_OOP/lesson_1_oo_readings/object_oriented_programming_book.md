## **The Object Model**

### Why Object Oriented Programming?

This section introduces a bunch of new concepts. It's a very quick overview of OOP.

**Object Oriented Programming (OOP)**:
- A programming paradigm created to deal with complex, large software systems
    - As programs grew, they became difficult to maintain because a small change could ripple through the program and cause errors due to dependencies.
- Create containers for data to section off code such that changes and manipulation won't break everything
    - Program becomes the interaction of many small parts, not a massive blob of dependency

*Some OOP terminology*

**Encapsulation**: hiding pieces of functionality and making it unavailable to the rest of the code base.
- Helps with *data protection* (data can't be manipulated/changed without obvious intention)
- Allow programmers to think on a new level of abstraction

**Polymorphism**: ability for data to be represented as many different types
- OOP gives flexibility in using pre-written code for new purposes

**Inheritance**: classes inherit behaviours from another class, the **superclass**.
- Allows programmers to define basic classes with large reusability and smaller **subclasses** for more detailed behaviours

*`Module`*:
- Another way to apply polymorphic structures
- We can't create an object with a module -- Modules must be mixed in with a class using the `include` method invocation (called a **mixin**).
    - After mixing in a module, behaviours delcared in that module are available to the class and its objects


### What Are Objects?

Objects are created from classes:
- class = mold
- object is thing produced from mold
Individual objects contain different information, yet they are *instances* of the same class


### Classes Define Objects

In Ruby, classes define the *attributes* and *behaviours* of its objects.

**Instantiation**: the entire workflow of creating a new object (an instance). An object is returned by calling the *class method* `new`

``` ruby
# good_dog.rb # NOTE: file names are "class_name.rb"

class GoodDog
end

sparky = GoodDog.new
```

*Launch School Explanation*
> In the above example, we created an instance of our `GoodDog` class and stored it in the variable `sparky`. We now have an object. We say that `sparky` is an object or instance of class `GoodDog`.


### Modules

**Module**: a collectin of behaviours usable in other classes via *mixins*.

Example: we want our `GoodDog` class to have a `speak` method, but we have other classes that we want to use a speak method with too.

``` ruby
# good_dog.rb

module Speak
  def speak(sound)
    puts sound
  end
end

class GoodDog
  include Speak
end

sparky = GoodDog.new
sparky.speak("Arf!")        # => Arf!
```


### Method Lookup

When calling a method, Ruby knows where to look for the method because of a distinct lookup path. We can use the `ancestors` method on any class to find out the method lookup chain.

``` ruby
puts GoodDog.ancestors
# => GoodDog
# => Speak
# => Object
# => Kernel
# => BasicObject
```

Note that the `Speak` module is placed right in between our custom class (`GoodDog`) and the `Object` class that comes with Ruby. Since `speak` method is not defined in the `GoodDog` class, the next place it looks is the `Speak` module. This continues up the ancestors until the method is found or there are no more places to look.

We'll investigate the method lookup chain with both mixins and class inheritance in the *inheritance* section.


---


## **Classes and Objects - Part 1**

### States and Behaviours

When defining a class, we focus on two things: *states* and *behaviours*
- States: track attributes for individual objects
- Behaviours: what objects are capable of doing

*Instance variables* keep track of objects' states, and are scoped at the object (instance) level.

*Instance methods* expose behaviours for objects, and those defined in a class are available to objects (instances) of that class.


### Initializing a New Object

Reworking the `GoodDog` class:

``` ruby
class GoodDog
    def initialize
        puts "This object was initialized!"
    end
end

sparky = GoodDog.new
# => "This object was initialized!"
```

The `initialize` method:
- a *constructor*
- gets called every time you create a new object.

Calling the **`new` class method** eventually leads us to the **`initialize` instance method**.
(Will cover class vs. instance methods later.)


### Instance Variables

**Instance varaibles**:
- has the `@` symbol in front of it
- exists as long as the object instance exists
- a way we tie data to objects
- keeps track of every objects' unique states

Example:
``` ruby
class GoodDog
  def initialize(name)
    @name = name
  end
end

sparky = GoodDog.new("Sparky")
```

In the method call above:
> Here, the string "Sparky" is being passed from the new method through to the initialize method, and is assigned to the local variable name. Within the constructor (i.e., the initialize method), we then set the instance variable @name to name, which results in assigning the string "Sparky" to the @name instance variable.


### Instance Methods

Right now the `GoodDog` class can't really do anything, so we're giving it behaviours.

``` ruby
class GoodDog
  def initialize(name)
    @name = name
  end

  def speak
    "#{@name} says arf!"
  end
end

sparky = GoodDog.new("Sparky")
puts sparky.speak
# => Spaky says arf!
```

Above, we are exposing information about the state of the object (i.e. name) using instance methods


### Accessor Methods

With our current `GoodDog` class, we have no method to print out only `sparky`'s name. Running `puts sparky.name` returns a `NoMethodError`.

If we want to access an object's name stored in the @name instance variable, we have to create an *getter method*. Similarly, to change `sparky`'s name, we have to create a *setter method*.

``` ruby
class GoodDog
  def initialize(name)
    @name = name
  end

  def name
    @name
  end

  def name=(n)
    @name = n
  end

  def speak
    "#{@name} says arf!"
  end
end
```
- Re: `def name=(n)`: Ruby gives us special syntax to use the setter method. We can call `sparky.name = "Spartacus"` and behind the Ruby syntactical sugar, it's the setter method working.
- Following Ruby convention, the getter and setter method names use the same name as the instance variable they're exposing and setting

Because getter and setter methods are so commonplace, Ruby has a built-in way to automatically create getter and setter methods: using the **attr_accessor** method.

We can refactor the above code as:
``` ruby
class GoodDog
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def speak
    "#{@name} says arf!"
  end
end
```
The `attr_accessor` method takes a symbol as an argument. It uses the argument to create the method name for the getter and setter methods.
The `attr_accessor` line above gives us:
- `name` getter method
- `name=` setter method
- `@name` instance variable

If we want only the `getter` method, then we use the `attr_reader` method. If we only want the `setter` method, then we use the `attr_writer` method. All `attr_*` methods take a `Symbol` as parameters.

#### Accessor Methods in Action

With getter and setter methods, we can expose and change an object's state.

We can also use these methods from within the class.
Instead of writing:
``` ruby
def speak
  "#{@name} says arf!"
end
```
which references the instance variable directly, we can use the `name` getter method to rewrite `speak`:
``` ruby
def speak
  "#{name} says arf!"
end
```
By removing the `@` symbol, we're calling the instance method for getting `name` rather than the instance variable directly.

It's a good idea to call the getter method instead of referencing the instance variable directly because it's better practice.
    LS gave an SSN example where if we use the instance variable @ssn, we have to mask the numbers all over the code with `'xxx-xx-' + @ssn.split('-').last` and this could cause errors. However, if we have a getter method to hold this masking, the code is all kept in one place. It's dryer and easier to debug.

Suppose we want to create a new method to change several states at once. We'll create a `change_info` method for the `GoodDog` class.
``` ruby
class GoodDog
  attr_accessor :name, :height, :weight

  def initialize(n, h, w)
    @name = n
    @height = h
    @weight = w
  end

  def speak
    "#{name} says arf!"
  end

  def change_info(n, h, w)
    @name = n
    @height = h
    @weight = w
  end

  def info
    "#{name} weighs #{weight} and is #{height} tall."
  end
end
```
If we rewrite `change_info` to access instance variables with setter methods like this:
``` ruby
def change_info(n, h, w)
  name = n
  height = h
  weight = w
end
```
then this `change_info` method doesn't change the object's information? Why?

#### Calling Methods With `self`

The implementation of `change_info` above doesn't work because *Ruby thought we were initializing local variables*. To disambiguate from creating a lcal variable, we use `self.name=` to let Ruby know we're calling a setter method. So we update `change_info` as:
``` ruby
def change_info(n, h, w)
  self.name = n
  self.height = h
  self.weight = w
end
```

Prefixing `self.` is not restricted to accessor methods -- we can use it with any instance method. For example:
``` ruby
class GoodDog
  # ... rest of code omitted for brevity
  def some_method
    self.info
  end
end
```


---


## **Classes and Object - Part 2**

### Class Methods

**Class Methods**: methods we can call directly on the calss itself without having to instantiate any objects. They are defined by prepending the method name with the reserved word `self.`.

Class methods contain functionality that does not pertain to individual objects -- objects contain states, and if we have a method that does not need to deal with states then we can just use a class method.

``` ruby
def self.what_am_i         # Class method definition
  "I'm a GoodDog class!"
end
```


### Class Variables

**Class variables**: keeps track of class level details that pertain only to the class and not to individual objects. Create one using two `@` symbols: `@@`.

``` ruby
class GoodDog
  @@number_of_dogs = 0

  def initialize
      @@number_of_dogs += 1
  end

  def self.total_number_of_dogs
      @@number_of_dogs
  end
end
```
Note:
- `initialize` is an instance method, as it gets called each time we instantiate a new object via `new`
- We can access class variables from within an instance method


### Constants

**Constants**: certain variables we never want to change

``` ruby
class GoodDog
  DOG_YEARS = 7

  attr_accessor :name, :age

  def initialize(n, a)
    self.name = n
    self.age = a * DOG_YEARS
  end
end
```
Note: we used the setter methods in `initialize` to initialize the `@name` and `@age` instance variables given to us by the `attr_accessor` method


### The `to_s` Method

The `to_s` instance method comes built into every Ruby class.
It's called automatically when:
- `puts` method invocation
    - Calling `puts sparky` is equivalent to `puts sparky.to_s`.
- string interpolation

We can always add a custom `to_s` method to our `GoodDog` class to override the default `to_s` method.

``` ruby
class GoodDog
  DOG_YEARS = 7

  attr_accessor :name, :age

  def initialize(n, a)
    self.name = n
    self.age = a * DOG_YEARS
  end

  def to_s
    "This dog's name is #{name} and it is #{age} in dog years."
  end
end
```

Another method, `p`, is similar to `puts` but doesn't call `to_s` on its argument. Instead, it calls another build-in Ruby instance method `inspect`, which is super useful for debugging.

Calling `p sparky` is equivalent to `puts sparky.inspect`.


### More About `self`

We want to:
- understand exactly what `self` is
- know how to understand what its referencing

We use `self` to specify a certain scope for our program. Depending on where it's used, `self` can refere to different things.

Two uses of `self` from within a class so far:
1. When using `self` *within* an instance method, it references the instance (object) that called the method.
    - ex: `self.weight=` is the same as `sparky.weight=`.
2. When using `self` *outside* of an instance method, it references the class and can be used to define class methods.
    - ex: `def self.name=(n)` is the same as `def GoodDog.name=(n)`.


### Summary

In this chapter we covered:
- Initializing objects with the new method
- How instance variables keep track of an object's state
- Learning how `attr_*` methods generate getters and setters
- Using instance methods to perform operations on our objects
- Using class methods to perform operations at the class level
- Assigning class variables to relate specifically to our class
- Assigning constants that never change to perform operations in our classes
- How the `to_s` method is used and when it's been implicitly called
- How and when to use `self`


---


## Inheritance

**Inheritance** is when a class **inherits** behaviour from another class. The class inheriting behaviour is called the *subclass* and the class it inherits from is called the *superclass*.

We use inheritance as a way to extract common behaviours from classes that share that behaviour, thus keeping logic in one place.


### Class Inheritance

Example: here we're extracting the `speak` method into a superclass `Animal` and we use inheritance to make that behaviour available to `GoodDog` and `Cat` classes:

``` ruby
class Animal
  def speak
    "HelloW!"
  end
end

class GoodDog < Animal
end

class Cat < Animal
end
```
We use the `<` symbol to signify that `GoodDog` class is inheriting from `Animal` class, so all methods in `Animal` are available to the `GoodDog` class.

We can **override** methods provided by a superclass in the subclass because Ruby checks the object's class first for the method beore looking in the superclass.

Inheritance is great for removing duplication in code bases.


### `super`

Ruby provides a built-in function called `super` that allows us to call methods up the inheritance hierarchy. When you call `super` from within a method, it will search the inheritance hierarchy for a method by the same name and then invoke it.

``` ruby
class Animal
  def speak
    "Hello!"
  end
end

class GoodDog < Animal
  def speak
    super + " from GoodDog class"
  end
end

sparky = GoodDog.new
sparky.speak        # => "Hello! from GoodDog class"
```

Another common way of using `super` is with `initialize`.
``` ruby
class Animal
  attr_accessor :name

  def initialize(name)
    @name = name
  end
end

class GoodDog < Animal
  def initialize(color)
    super
    @color = color
  end
end

bruno = GoodDog.new("brown")
# => #<GoodDog:0x007fb40b1e6718 @color="brown", @name="brown">
```
Note: `@name = "brown"` because `super` (invoked in the `initialize` method in `GoodDog` class) automatically forwards the arguments passed into the `GoodDog#initialize` method.


### Mixing in Modules

**Modules** provide another way to DRY up code.

Extracting common methods to a superclass is a great way to model concepts that are naturally hierarchical.

However when the natural hierarchical approach fails between concepts, we can extract behaviours into modules:

``` ruby
module Swimmable
  def swim
    "I'm swimming!"
  end
end

class Animal; end

class Fish < Animal
  include Swimmable
end

class Mammal < Animal
end

class Cat < Mammal
end

class Dog < Mammal
    include Swimmable
end
```
Note: `Fish` and `Dog` can both swim without having to store swimming behaviours in `Animal`, `Mammal`, or `Cat`

Using modules to group common behaviours allows us to build a more powerful, flexible, DRY design


### Inheritance vs. Modules

Now we know the two primary ways that Ruby implements inheritance:
- class inheritance
- mixing in modules

To know when to use one vs. the other, keep in mind:
- You can only subclass from one class, but you can mix in as many modules as you'd like
- If it's an "is-a" relationship, choose class inheritance. If it's a "has-a" relationship, choose modules.
    - ex: a dog "is an" animal; a dog "has an" ability to swim.
- You can't instantiate modules (i.e. no object can be created from a module). *Modules are only for namespacing and grouping common methods together.*


### Method Lookup Path

Now we'll put together inheritance and mixins to see how they affect the *method lookup path*.

Given the code example below with three modules and one class:
``` ruby
module Walkable
  def walk
    "I'm walking."
  end
end

module Swimmable
  def swim
    "I'm swimming."
  end
end

module Climbable
  def climb
    "I'm climbing."
  end
end

class Animal
  include Walkable

  def speak
    "I'm an animal, and I speak!"
  end
end
```

At this point, we've mixed in one module into the `Animal` class. We can look at the path with `Animal.ancestors`:

``` ruby
Animal
Walkable
Object
Kernel
BasicObject
```

We will add another class to the code above:

``` ruby
class GoodDog < Animal
  include Swimmable
  include Climbable
end
```

Looking up GoodDog's ancestors shows us:

``` ruby
GoodDog
Climbable
Swimmable
Animal
Walkable
Object
Kernel
BasicObject
```

**From the output above, we know:**
- The order in which we include modules is important. It will affect the method lookup path.
- The module included in the superclass is in the method lookup path

By understanding the method lookup path, we can have a better idea of where and how all available methods are organized.


### More Modules

At this point, we've seen how modules can be used to mix-in common behaviour into classes. Now we'll explore two more uses for modules.

*Case 1: **namespacing***
Namespacing means organizing/grouping similar classes under a module. This provides two advantages:
1. Makes it easier for us to recognize related classes
2. Reduces the likelihood of our classes colliding with other similarly named classes in our codebase

Example:

``` ruby
module Mammal
  class Dog
    def speak(sound)
      p "#{sound}"
    end
  end

  class Cat
    def say_name(name)
      p "#{name}"
    end
  end
end
```
We call classes in a module by appending the class name to the module name with two colons (`::`)
``` ruby
puppi = Mammal::Dog.new
kitty = Mammal::Cat.new
puppi.speak('Arf!')           # => "Arf!"
kitty.say_name('kitty')       # => "kitty"
```

*Case 2: **module methods** (i.e. containers for methods)*

Using modules to house other methods is useful for methods that seem out of place within your code. For example:

``` ruby
module Mammal
  ...

  def self.some_out_of_place_method(num)
    num ** 2
  end
end
```

We can call this method directly from the module like so: `value = Mammal.some_out_of_place_method(4)`


### Private, Protected, and Public

**Public methods**: a method that is available to anyone who knows either the class name or the object's name
- readily available for the rest of the program to use
- comprise the class's *interface* (i.e. how other classes and objects will interact with this class and its objects)

**Private methods**: Methods that are doing work in the class but don't need to be available to the rest of the program.
- only accessible from other methods in the class when called without `self`
- not accessible outside of the class definition at all

**Protected methods**: Follow two rules to understand this approach in-between public and private
- from outside the class, `protected` methods act like `private` methods
- from inside the class, `protected` methods are accessible just like `public` methods


### Accidental Method Overriding

Remember that every class inherently subclasses from `Object`. As `Object` comes with many critical methods, don't accidentally overwrite any of them or your application might break!


## Summary of Lesson:

At this point we should be familar with the basics of OOP in Ruby.

**We should understand these major concepts:**

- relationship between a class and an object
- idea that a class groups behaviours (i.e. methods)

At the object level:

- objects do not hsare states between other objects, but they do share behaviours
- the values in an object's instance variables (states) are different, but they can call the same instance methods (behaviours) defined in the class

At the class level:

- classes also have behaviours not for objects (class methods)

Regarding inheritance:

- classes can only sub-class from 1 parent class
- subclassing is used to model hierarchical relationships
- we can mix in as many modules as needed -- this is a way of implementing multiple inheritance
- understand how sub-classing and/or mixing in modules affects the method lookup path
