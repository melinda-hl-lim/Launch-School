####################
# 1 Inherited Year #
####################
# Using the following code, create two classes - Truck and Car - that both inherit from Vehicle.

class Vehicle
  attr_reader :year

  def initialize(year)
    @year = year
  end
end

class Car < Vehicle # Answer
end

class Truck < Vehicle # Answer
end

truck1 = Truck.new(1994)
puts truck1.year # => 1994

car1 = Car.new(2006)
puts car1.year # => 2006


######################
# 2 Start the Engine #
######################
# Change the following code so that creating a new `Truck` automatically invokes `#start_engine`.

class Vehicle
  attr_reader :year

  def initialize(year)
    @year = year
  end
end

class Truck < Vehicle

  def initialize(year) # Answer
    super(year)
    self.start_engine
  end

  def start_engine
    puts 'Ready to go!'
  end
end

truck1 = Truck.new(1994) # => Ready to go!
puts truck1.year # => 1994

# Discussion
# When invoking `#super` without parentheses, all arguments are passed to the superclass's method.



########################
# 3 Only Pass the Year #
########################
# Using the following code, allow `Truck` to accept a second argument upon instantiation. Name the parameter `bed_type` and implement the modification so that `Car` continues to only accept one argument.

class Vehicle
  attr_reader :year

  def initialize(year)
    @year = year
  end
end

class Truck < Vehicle
  attr_accessor :bed_type # Answer: LS only made it an attr_reader

  def initialize(year, bed_type) # Answer
    super(year)
    @bed_type = bed_type
  end
end

class Car < Vehicle
end

truck1 = Truck.new(1994, 'Short')
puts truck1.year
puts truck1.bed_type


###############################
# 4 Start the Engine (Part 2) #
###############################
# Given the following code, modify `#start_engine` in `Truck` by appending `Drive fast, please!` to the return value of #`start_engine` in `Vehicle`. The `fast` in `Drive fast, please!` should be the value of `speed`.

class Vehicle
  def start_engine
    'Ready to go!'
  end
end

class Truck < Vehicle
  def start_engine(speed) # Answer
    super + " Drive #{speed}, please!"
  end
end

truck1 = Truck.new
puts truck1.start_engine('fast')


######################
# 5 Towable (Part 1) #
######################
# Using the following code, create a `Towable` module that contains a method named `tow` that prints `I can tow a trailer!` when invoked. Include the module in the `Truck` class.

module Towable # Answer
  def tow
    puts "I can tow a trailer!"
  end
end

class Truck
  include Towable # Answer
end

class Car
end

truck1 = Truck.new
truck1.tow # => I can tow a trailer!

# Discussion
# Modules are useful for organizing similar methods that may be relevant to multiple classes.
# The reserved word `include` gives `Truck` access to the methods in `Towable`


######################
# 6 Towable (Part 2) #
######################
# Using the following code, create a class named `Vehicle` that, upon installation, assigns the passed in argument to `@year`.

module Towable
  def tow
    'I can tow a trailer!'
  end
end

class Vehicle # Answer
  attr_reader :year

  def initialize(year)
    @year = year
  end
end

class Truck < Vehicle
  include Towable
end

class Car < Vehicle
end

truck1 = Truck.new(1994)
puts truck1.year
puts truck1.tow

car1 = Car.new(2006)
puts car1.year

# Discussion
# Modules are useful for containing similar methods; however, sometimes class inheritance is also needed. So we can use both!


############################
# 7 Method Lookup (Part 1) #
############################
# Using the following code, determine the lookup path used when invoking `cat1.color`. Only list the classes that were checked by Ruby when searching for the `#color` method.

class Animal
  attr_reader :color

  def initialize(color)
    @color = color
  end
end

class Cat < Animal
end

class Bird < Animal
end

cat1 = Cat.new('Black')
cat1.color

# Answer
# Cat
# Animal


############################
# 8 Method Lookup (Part 2) #
############################
# Using the following code, determine the looup path used when invoking `cat1.color`. Onl list the classes and modules that Ruby will check when searching for the `#color` method.

class Animal
end

class Cat < Animal
end

class Bird < Animal
end

cat1 = Cat.new
cat1.color

# Answer
# Cat
# Animal
# Object
# Kernel
# Basic Object

# Dicussion:
# `Object` class inherits from `Kernel` module
# Since the method `color` doesn't exist, Ruby had to check every class and module in `Cat`'s ancestors.


############################
# 9 Method Lookup (Part 3) #
############################
# Using the following code, determine the lookup path used when invoking `bird1.color`. Only list the classes or modules that were checked by Ruby when searching for the `#color` method.

module Flyable
  def fly
    "I'm flying!"
  end
end

class Animal
  attr_reader :color

  def initialize(color)
    @color = color
  end
end

class Cat < Animal
end

class Bird < Animal
  include Flyable
end

bird1 = Bird.new('Red')
bird1.color

# Answer:
# Bird
# Flyable
# Animal


#####################
# 10 Transportation #
#####################
# Create a module named `Transportation` that contains three classes: `Vehicle`, `Truck`, and `Car`. `Truck` and `Car` should both inherit from `Vehicle`.

# Answer:

module Transportation
  class Vehicle
  end

  class Truck < Vehicle
  end

  class Car < Vehicle
  end
end

# Discussion:
# Modules are usefule for:
# 1. grouping common methods together
# 2. namespacing: where similar classes are grouped within a module
# Two benefits of namespacing:
# - make it easier to recognize the purpose of the contained classes
# - avoid collision with classes of the same name
# We instantiate classes within a module by invoking the following:
Transportation::Truck.new
