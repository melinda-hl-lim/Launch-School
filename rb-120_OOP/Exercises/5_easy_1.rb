##################
# 1 Banner Class #
##################
# Given an incomplete class for constructing boxed banner, complete the class so that the test cases work as intended. You are free to add any methods or instance variables you need. However, do not make the implementation details public.

class Banner
  def initialize(message, length=message.length)
    @message = message
    @length = length # answer: bonus feature
  end

  def to_s
    [horizontal_rule, empty_line, message_line, empty_line, horizontal_rule].join("\n")
  end

  private

  def horizontal_rule
    create_edge("+-", "-") # answer
  end

  def empty_line
    create_edge("| ", " ") # answer
  end

  def message_line
    "| #{@message} |"
  end

  # def message_line -- answer: bonus feature
  #   "| " + @message.center(@length) + " |"
  # end

  def create_edge(end_piece, mid_piece) # answer
    edge = end_piece.clone
    @length.times { |_| edge << mid_piece }
    edge << end_piece.reverse
    edge
  end
end

# Test cases:
banner = Banner.new('To boldly go where no one has gone before.')
puts banner
# +--------------------------------------------+
# |                                            |
# | To boldly go where no one has gone before. |
# |                                            |
# +--------------------------------------------+

banner = Banner.new('')
puts banner
# +--+
# |  |
# |  |
# |  |
# +--+

# LS's answer:
#   def empty_line
#     "| #{' ' * (@message.size)} |"
#   end

#   def horizontal_rule
#     "+-#{'-' * (@message.size)}-+"
#   end


########################
# 2 What's the Output? #
########################
# Given the following code, what output does this code print? Fix the class so that there are no surprises waiting in store for the unsuspecting developer.

class Pet
  attr_reader :name

  def initialize(name)
    @name = name.to_s
  end

  def to_s
    @name.upcase! # answer: remove this line
    "My name is #{@name.upcase}." # answer: add upcase call here and make it non-mutating
  end
end

name = 'Fluffy'
fluffy = Pet.new(name)
puts fluffy.name # My name is FLUFFY."
puts fluffy  # "My name is My name is FLUFFY."
puts fluffy.name  # "My name is FLUFFY."
puts name # 'Fluffy'


######################################
# 3 Fix the Program - Books (Part 1) #
######################################
# Complete this program so that it produces the expected output:

class Book
  attr_reader :title, :author # answer

  def initialize(author, title)
    @author = author
    @title = title
  end

  def to_s
    %("#{title}", by #{author})
  end
end

book = Book.new("Neil Stephenson", "Snow Crash")
puts %(The author of "#{book.title}" is #{book.author}.)
# => The author of "Snow Crash" is Neil Stephenson.
puts %(book = #{book}.)
# => book = "Snow Crash", by Neil Stephenson.

# Further exploration:
# In this case, there is no advantage in writing out a getter method rather than using `attr_reader`. The alternative exists for cases when we want to do something ore than simply get/set the attribute.


######################################
# 4 Fix the Program - Books (Part 2) #
######################################
# Complete the program so that it produces the expected output:

class Book
  attr_accessor :title, :author

  def to_s
    %("#{title}", by #{author})
  end
end

book = Book.new
book.author = "Neil Stephenson"
book.title = "Snow Crash"
puts %(The author of "#{book.title}" is #{book.author}.)
# => The author of "Snow Crash" is Neil Stephenson.
puts %(book = #{book}.)
# => book = "Snow Crash", by Neil Stephenson.


###############################
# 5 Fix the Program - Persons #
###############################
# Complete the program so that it produces the expected output:

class Person
  def initialize(first_name, last_name)
    @first_name = first_name.capitalize
    @last_name = last_name.capitalize
  end

  def to_s
    "#{@first_name} #{@last_name}"
  end

  def first_name=(first_name) # answer
    @first_name = first_name.capitalize
  end

  def last_name=(last_name) # answer
    @last_name = last_name.capitalize
  end
end

person = Person.new('john', 'doe')
puts person # => John Doe

person.first_name = 'jane'
person.last_name = 'smith'
puts person # => Jane Smith


###################################
# 6 Fix the Program - Flight Data #
###################################
# Consider the following class definition:
class Flight
  attr_accessor :database_handle

  def initialize(flight_number)
    @database_handle = Database.init
    @flight_number = flight_number
  end
end
# Though nothing is technically incorrect about this class, the definition may lead to problems in the future. How can this class be fixed to be resistant to future problems?

# Hint: Consider what might happen if you leave this class defined as it is and later decide to alter the implementation so that a database is not used.

# Answer: Delete `attr_accessor :database_handle`
# The problem with this definition is that we are providing easy access to the `@database_handle` instance variable, which is almost certainly an implementation detail. Implementation details should not be used by users of the class; therefore we shouldn't provide direct access.
# If we don't change this line, some things may go wrong.
# 1. Making access to `@database_handle` easy may tempt a user of the class to use it in their code. Once the database handle is being used in real code, modifications to the class may break their code.


##############################
# 7 Buggy Code - Car Mileage #
##############################
# Fix the following code so it works properly

class Car
  attr_accessor :mileage

  def initialize
    @mileage = 0
  end

  def increment_mileage(miles)
    self.mileage += miles # answer
    # total = mileage + miles -- answer - comment out these lines
    # mileage = total
  end

  def print_mileage
    puts mileage
  end
end

car = Car.new
car.mileage = 5000
car.increment_mileage(678)
car.print_mileage  # should print 5678


############################
# 8 Rectangles and Squares #
############################
# Given the class `Rectangle`, write a class called `Square` that inherits from `Rectangle` and use it like the given output.

class Rectangle
  def initialize(height, width)
    @height = height
    @width = width
  end

  def area
    @height * @width
  end
end

class Square < Rectangle # answer
  def initialize(length)
    super(length, length)
  end
end

square = Square.new(5)
puts "area of square = #{square.area}"


##################################
# 9 Complete the Program - Cats! #
##################################
# Consider the given program. Update the code so that when you run it, you see the following output.

class Pet
  attr_reader :name, :age # answer

  def initialize(name, age)
    @name = name
    @age = age
  end
end

class Cat < Pet # answer
  attr_reader :color

  def initialize(name, age, color)
    super(name, age)
    @color = color
  end

  def to_s
    "My cat #{self.name} is #{self.age} years old and has #{self.color} fur."
  end
end

pudding = Cat.new('Pudding', 7, 'black and white')
butterscotch = Cat.new('Butterscotch', 10, 'tan and white')
puts pudding, butterscotch
# => My cat Pudding is 7 years old and has black and white fur.
# => My cat Butterscotch is 10 years old and has tan and white fur.


###########################
# 10 Refactoring Vehicles #
###########################
# Given the `Car`, `Motorcycle`, and `Truck` classes, refactor the classes so they all use a common super class and inherit behaviour as needed.
      # class Car
      #   attr_reader :make, :model

      #   def initialize(make, model)
      #     @make = make
      #     @model = model
      #   end

      #   def wheels
      #     4
      #   end

      #   def to_s
      #     "#{make} #{model}"
      #   end
      # end

      # class Motorcycle
      #   attr_reader :make, :model

      #   def initialize(make, model)
      #     @make = make
      #     @model = model
      #   end

      #   def wheels
      #     2
      #   end

      #   def to_s
      #     "#{make} #{model}"
      #   end
      # end

      # class Truck
      #   attr_reader :make, :model, :payload

      #   def initialize(make, model, payload)
      #     @make = make
      #     @model = model
      #     @payload = payload
      #   end

      #   def wheels
      #     6
      #   end

      #   def to_s
      #     "#{make} #{model}"
      #   end
      # end

class Vehicle
  attr_reader :make, :model

  def initialize(make, model)
    @make = make
    @model = model
  end

  def to_s
    "#{make} #{model}"
  end
end

class Car < Vehicle
  def wheels
    4
  end
end

class Motorcycle < Vehicle
  def wheels
    2
  end
end

class Truck < Vehicle
  attr_reader :payload

  def initialize(make, model, payload)
    super(make, model)
    @payload = payload
  end

  def wheels
    6
  end
end
