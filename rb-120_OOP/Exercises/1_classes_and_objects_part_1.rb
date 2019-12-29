require 'pry'

####################
# 1 Find the Class #
####################
# Update the following code so that each statement prints the name of the class, not the value.

puts "Hello"    # => String
puts 5          # => Integer
puts [1, 2, 3]  # => Array

# Answer

# We invoke the `#class` method to find the class an object belongs to

puts "Hello".class    # => String
puts 5.class          # => Integer
puts [1, 2, 3].class  # => Array


######################
# 2 Create the Class #
######################
# Create an empty class named `Cat`

# Answer

class Cat
  include Walkable

  attr_accessor :name

  def initialize(name)
    @name = name
    # puts "Hi there! I'm #{@name} the cat!" -- Q4&5
  end

  def greeting
    puts "Hi there! I'm #{name} the cat!"
  end

end

kitty = Cat.new("Kitti")
kitty.greeting
p "Output of kitty.name is #{kitty.name}"
kitty.name = "Luna"
kitty.greeting


#######################
# 3 Create the Object #
#######################
# Using the code from the previous exercise, create an instance of `Cat` and assign it to a variable named `kitty`

# Answer: in Question 2: "Create the Class"


###################
# 4 What Are You? #
###################
# Using the code from the previous exercise, add an `#initialize` methods that prints `I'm a cat!` when a new `Cat` object is initialized

# Answer: in Question 2: "Create the Class"

# Discussion:
# The `#initialize` method is useful for setting up (i.e. initializing) an object so the object is ready for immediate use.


#############################
# 5 Hello, Sophie! (Part 1) #
#############################
# Using the code from the previous exercise, add a parameter to `#initialize` that provides a name for the `Cat` object. Use an instance variable to print a greeting with the provided name.

# Answer: in Question 2: "Create the Class"

# Discussion:
# Instance variables only exist within an object instance. They are available to reference only once the object has been initialized.


#############################
# 6 Hello, Sophie! (Part 2) #
#############################
# Using the code from the previous exercise, move the greeting from the #initialize method to an instance method named #greet that prints a greeting when invoked.

# Answer: in Question 2: "Create the Class"

# Discussion:
# Instance methods are only available when there's an instance of the class


############
# 7 Reader #
############
# Using the code from the previous exercise, add a getter method named `#name` and invoke it in place of `@name` in `#greet`

# Answer: in Question 2: "Create the Class"

# Discussion:
# The getter method such as `#name` can be invoked inside the class like:
    # def greeting
    #   puts "Hi there! I'm #{name} the cat!"
    # end
# and outside the class via the object:
    # kitty.name


############
# 8 Writer #
############
# Using the code from the previous exercise, add a setter method named `#name`. Then, rename kitty to `'Luna'` and invoke `#greet` again.

# Answer: in Question 2: "Create the Class"

# Discussion:
# Setter methods can be invoked on the object (Melinda addition: to change the value of that object's state.)


##############
# 9 Accessor #
##############

# Answer: in Question 2: "Create the Class"


###################
# 10 Walk the Cat #
###################
# Using the code from the previous exercises, create a module named `Walkable` that contains a method naed `#walk`. The method should print `Let's go for a walk!  when invoked. Include `Walkable` in `Cat` and invoke `#walk` on `kitty`.

# Answer: in Question 2: "Create the Class" and below

module Walkable
  def walk
    puts "Let's go for a walk, #{name}!"
  end
end
