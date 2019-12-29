## Classes and Objects

### Exercises:

``` ruby
class Person
  attr_accessor :first_name, :last_name

  def initialize(full_name)
    parse_full_name(full_name)
  end

  def name
    "#{self.first_name} #{self.last_name}".strip
  end

  def name=(full_name)
    parse_full_name(full_name)
  end

  def to_s
    name
  end

  private

  def parse_full_name(full_name)
    parts = full_name.split
    self.first_name = parts.first
    self.last_name = parts.size > 1 ? parts.last : ''
  end
end

andrew = Person.new("Andrew Crotwell")
p andrew.first_name
p andrew.last_name
puts "The person'a name is #{andrew}"
```


---


## Inheritance

Suppose we're building a software system for a pet hotel business. Our classes deal with pets! :DD

Given:

``` ruby
class Dog
  def speak
    'bark!'
  end

  def swim
    'swimming!'
  end

  def run
    'running!'
  end

  def jump
    'jumping!'
  end

  def fetch
    'fetching!'
  end
end

teddy = Dog.new
puts teddy.speak # => "bark!"
puts teddy.swim # => "swimming!"
```
1. We need to keep track of dog breeds, so create a sub-class called `Bulldog` and override the `swim` method to return "I can't swim!"

Answer:
``` ruby
class BullDog < Dog
  def swim
    'No swim! D:'
  end
end
```

2. Create a new class called `Cat` which can do everything a dog can except swim or fetch. Assum the methods do the exact same thing. (Hint: don't just copy and paste all methods; try to come up with some class heirarchy.)

``` ruby
class Pet
  def run
    'running!'
  end

  def jump
    'jumping!'
  end
end

class Dog < Pet
  def speak
    'bark!'
  end

  def fetch
    'fetching!'
  end

  def swim
    'swimming!'
  end
end

class Cat < Pet
  def speak
    'meow!'
  end
end
```

4. What is the *method lookup path* and how important is it?

The method lookup opath is the order in which Ruby traverses the class hierarchy looking for methods to invoke. Ruby will look in the class of the calling object first and continue traversing up the chain of super-classes until it invokes the first method with a matching name or finds nothing.

The path is important to know since in larger programs, the class hierarchies can get complicated quickly. Being able to see the method lookup path using `.ancestors` class method helps us find the order of super classes.


---


## Polymorphism and Encapsulation

### Polymorphism

Polymorphism refers to the ability of different objects to respond in different wayts to the same message (or method invocation).

There are several ways to implement polymorphism:
- Through inheritance
- Through duck typing
- **Note from Andrew**: Modules also have to do with polymorphism. However, it isn't covered in this lecture.

#### Polymorphism through inheritance

The given code implements polymorphism through inheritance:

``` ruby
class Animal
  def eat
    # generic eat method
  end
end

class Fish < Animal
  def eat
    # eating specific to fish
  end
end

class Cat < Animal
  def eat
     # eat implementation for cat
  end
end

def feed_animal(animal)
  animal.eat
end

array_of_animals = [Animal.new, Fish.new, Cat.new]
array_of_animals.each do |animal|
  feed_animal(animal)
end
```

In this example, every object within `array_of_animals` is a different animal; however, the code can treat them all as a generic animal that can eat. Even though the implementation of each animal's `eat` method may be different, the public interface lets us work with all of these types in the same way.

#### Polymorphism through duck typing

Duck typing in Ruby doesn't concern itself with the class of an object; instead, it concerns itself with what methods are available on the object. (I.e. if an object quacks like a duck, we can treat it like a duck.)

First we'll take a look at how **not** to do duck typing. This example attempts to implement polymorphic behaviour without using duck typing.

``` ruby
class Wedding
  attr_reader :guests, :flowers, :songs

  def prepare(preparers)
    preparers.each do |preparer|
      case preparer
      when Chef
        preparer.prepare_food(guests)
      when Decorator
        preparer.decorate_place(flowers)
      when Musician
        preparer.prepare_performance(songs)
      end
    end
  end
end

class Chef
  def prepare_food(guests)
    # implementation
  end
end

class Decorator
  def decorate_place(flowers)
    # implementation
  end
end

class Musician
  def prepare_performance(songs)
    #implementation
  end
end
```

The issue with this approach above is **the `prepare` method has too many dependencies**. It relies on specific classes and their names, and needs to know which method it should call on each of the objects and the arguments those methods require. If we want to change anything within the classes, we need to refactor the method.

We can refactor the code to implement polymorphism with duck typing:

``` ruby
class Wedding
  attr_reader :guests, :flowers, :songs

  def prepare(preparers)
    preparers.each do |preparer|
      preparer.prepare_wedding(self)
    end
  end
end

class Chef
  def prepare_wedding(wedding)
    prepare_food(wedding.guests)
  end

  def prepare_food(guests)
    #implementation
  end
end

class Decorator
  def prepare_wedding(wedding)
    decorate_place(wedding.flowers)
  end

  def decorate_place(flowers)
    # implementation
  end
end

class Musician
  def prepare_wedding(wedding)
    prepare_performance(wedding.songs)
  end

  def prepare_performance(songs)
    #implementation
  end
end
```

In this example above, we have polymorphism: each class defines a `prepare_wedding` method and implements it in its own way. To add another preparer, we can create another class and just implement `prepare_wedding`.


### Encapsulation

Encapsulation lets us:
- hide the internal representation of an object from the outside and
- only expose method and properties that users of objects need to know
  - we expose these properties and methods through the public interface of a class: its public methods

  ``` ruby
  class Dog
  attr_reader :nickname

  def initialize(n)
    @nickname = n
  end

  def change_nickname(n)
    self.nickname = n
  end

  def greeting
    "#{nickname.capitalize} says Woof Woof!"
  end

  private
    attr_writer :nickname
end

dog = Dog.new("rex")
dog.change_nickname("barny") # changed nickname to "barny"
puts dog.greeting # Displays: Barny says Woof Woof!
```

Notes for the code above:
- We can use methods `change_nickname` and `greeting` without knowing how to the method is implemented
- When alling private setter methods, we need to use `self` or else Ruby will think we're creating a local variable
- We should have as few public methods as possible to simply using the class and protect data from undesired changes from the outer worls


---


## Collaborator Objects

At this point we know:
- classes group common behaviours
- objects encapsulate state

Instance variables save the object's state. These states saved to the instance variables can be of any object type, including arrays, hashes, even custom classes.

**Collaborator Objects**: objects that are stored as state within another object. They work in conjunction (or collaboration) with teh class they're associated with. For example:
``` ruby
class Person
  attr_accessor :name, :pet

  def initialize(name)
    @name = name
  end
end

bob = Person.new("Robert")
bud = Bulldog.new  # assume Bulldog class from previous assignment

bob.pet = bud
bob.pet.fetch
```
In the last line of this code snippet, we go through `bob` to call the method on the object stored in `@pet`.

Collaborator objects play an important role in the OO design since they represent the connections between various actors in your program. When working on an OO program, consider what collaborators your classes will have and if those associations make sense from a technical and modeling (objects to solve problem) perspective.

### Additional Notes from Medium Post: "No Object is an Island"

#### What is collaboration?

Collaboration is a way of modeling relationships between different objects. A collaborative relationship is a relationship of association.

Some relationships that we've covered include:
- *Inheritance*: can be thought of as an *is-a* relationship
- *Association*: can be thought of as a *has-a* relationship

#### What are collaborator objects and how can you spot them in the wild?

Collaborator *objects* can be:
- any class type. The class of the object really depends on the program you're designing
- part of another object's state

You've spotted a collaborator *object* when:
- an object is assigned to an instance variable of another object inside a class definition
  - though sometimes the object is not associated until a setter method is invoked
  - collaboration doesn't always happen the minute an object is instantiated

#### When does collaboration occur?

Collaboration doesn't just occur when the code is executed and objects are occupying space in memory. However, it does exist from the design phase of your program.


---


## Modules

Limitation of inheritance: class can only sub-class from one super class.

This is a classic question of how a luanguage should support *multiple inheritance* -- Ruby supports it by *mixing in* behaviours. A class can only sub-class from one parent, but can mix in multiple modules.

Remmeber: mixing in modules changes the method lookup path.
