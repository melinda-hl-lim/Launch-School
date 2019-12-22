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
