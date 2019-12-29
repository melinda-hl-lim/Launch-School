require 'pry'

###############################
# 1 Generic Greeting (Part 1) #
###############################
# Modify the given code so that `Hello! I'm a cat!` is printed when `Cat.generic_greeting` is invoked.
    # class Cat
    # end

    # Cat.generic_greeting

# Answer:

class Cat
  def self.generic_greeting
    puts "Hello! I'm a cat!"
  end
end

Cat.generic_greeting

# Discussion:
# Note the method invocation given by the problem: it's being invoked on the `Cat` class, not an instance of `Cat`.
# In the solution, `self` refers to the `Cat` class.


###################
# 2 Hello, Chloe! #
###################
# Using the following code, add an instance method named #rename that renames kitty when invoked.

# class Cat
#   attr_accessor :name

#   def initialize(name)
#     @name = name
#   end
# end

# kitty = Cat.new('Sophie')
# kitty.name
# kitty.rename('Chloe')
# kitty.name

# Answer:

class Cat
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def rename(new_name)
    self.name = new_name
  end
end

kitty = Cat.new('Kitti')
puts kitty.name
kitty.rename('Chloe')
puts kitty.name

# Discussion:
# When invoking a setter method, they must be denoted with `self` so that Ruby knows we're NOT initializing a local variable.


################################
# 3 Identify Yourself (Part 1) #
################################
# Using the following code, add a method named `#identify` that returns its calling object.

class Cat
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def identify # Answer
    self
  end
end

kitty = Cat.new('Sophie')
p kitty.identify


###############################
# 4 Generic Greeting (Part 2) #
###############################
# Using the following code, add two methods: `::generic_greeting` and `#personal_greeting`. The first method should be a class method and print a greeting that's generic to the class. The second method should be an instance method and print a greeting that's custom to the object.

class Cat
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def self.generic_greeting # Answer
    puts "Meow there!"
  end

  def personal_greeting # Answer
    name = 'hi'
    puts "Meow there! I'm #{name} the cat!" # Melinda is unsure of why `name` can invoke the getter method here and why it's not interpreted as a local variable...
  end
end

# Andrew Discussion
# Answering the question in comments above: Ruby will first look for local variables, and then methods accesible. Since there is no local variable named `name`, Ruby knows to start looking for methods and find the getter method `name`. However, if a local variable `name` existed within `personal_greeting`, then it would have inserted the value of that local variable via string interpolation.

kitty = Cat.new('Sophie')

Cat.generic_greeting
kitty.personal_greeting


###################
# 5 Counting Cats #
###################
# Using the following code, create a class named Cat that tracks the number of times a new Cat object is instantiated. The total number of Cat instances should be printed when ::total is invoked.

kitty1 = Cat.new
kitty2 = Cat.new

Cat.total

# Answer:

class Cat
  @@total = 0

  def initialize
    @@total += 1
  end

  def self.total
    puts @@total
  end
end


##################
# 6 Colorful Cat #
##################
# Using the following code, create a class named `Cat` that prints a greeting when `#greet` is invoked. The greeting should include the name and color of the cat. Use a constant to define the color.

kitty = Cat.new('Sophie')
kitty.greet # => Hello! My name is Sophie and I'm a purple cat!

# Answer:

class Cat
  attr_accessor :name, :colour

  def initialize(name, colour)
    @name = name
    @colour = colour
  end

  def greet
    puts "Meow there! I'm #{name}, the #{colour} cat :3"
  end
end

# Melinda did not do the constant colour route .-.


###############################
# 7 Idetify Yourself (Part 2) #
###############################
# Update the following code so that it prints I'm Sophie! when it invokes puts kitty.

class Cat
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def to_s
    "I'm #{name} the cat!"
  end
end

kitty = Cat.new('Sophie')
puts kitty

# Discuccions:
# Key point of exercise: every class has a `#to_s` method. `puts` calls `#to_s` for every argument that gets passed


###################
# 8 Public Secret #
###################
# Using the following code, create a class named `Person` with an instance variable named `@secret`. Use a setter method to add a value to `@secret`, then use a getter method to print `@secret`.

person1 = Person.new
person1.secret = 'Shh.. this is a secret!'
puts person1.secret # => Shh.. this is a secret!

# Answer

class Person
  attr_accessor :secret
end

# Discussion:
# Manually write getters and setters
  # def secret
  #   @secret
  # end

  # def secret=(value)
  #   @secret = value
  # end


####################
# 9 Private Secret #
####################
# Using the following code, add a method named `share_secret` that prints the value of `@secret` when invoked
class Person
  attr_writer :secret

  def share_secret # answer
    puts secret
  end

  private

  attr_reader :secret
end

person1 = Person.new
person1.secret = 'Shh.. this is a secret!'
person1.share_secret


#######################
# 10 Protected Secret #
#######################
# Using the following code, add an instance method named `compare_secret` that compares the value of `@secret` from `person1` with the value of `@secret` from `person2`.

class Person
  attr_writer :secret

  def compare_secret(other_person) # Answer
    secret == other_person.secret
  end

  protected

  attr_reader :secret
end

person1 = Person.new
person1.secret = 'Shh.. this is a secret!'

person2 = Person.new
person2.secret = 'Shh.. this is a different secret!'

puts person1.compare_secret(person2)

# Discussion
# Proteched methods allow access between class instances, while private methods do not. However, a proteced method cannot be invoked from outside the class.
