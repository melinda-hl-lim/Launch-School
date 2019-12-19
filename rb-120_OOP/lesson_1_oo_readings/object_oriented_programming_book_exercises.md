## **The Object Model**

1. How do we create an object in Ruby? Give an example of the creation of an object.

To create an object in Ruby, we must define a class and instantiate it by invoking the `.new` method.

2. What is a module? What is its purpose? How do we use them with our classes?

A module allows us to group reusable code into one place. They are "mixed in" with classes by invoking the `include` method. Modules are also used as a *namespace*.


## **Classes and Objects - Part 1**

1. Create a class called MyCar:
    - Users should be able to define instance variables year, color, and model when instantiating an object
    - Create an instance variable set to `0` during instantiation of the object to track the current speed of the car
    - Create instance methods that allow the car to speed up, brake, and shut off

2. Add an accessor method to MyCar to change and view the color of your car. Then add an accessor method that allows you to view, but not modify, the year of your car.

3. You want to create a nice interface to accurately describe the action you want your program to perform. Create a method `spray_paint` that can be called on an object and will modify the color of the car.

```ruby
class MyCar
  attr_accessor :color, :model, :speed
  attr_reader :year

  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @speed = 0
  end

  def info
    puts "Your #{color} #{model} from #{year} is going at #{speed} mph."
  end

  def current_speed
    puts "You are going at #{speed} mph."
  end

  def speed_up(number)
    self.speed += number
    puts "You push the gas and are going #{speed} mph."
  end

  def brake(number)
    self.speed -= number
    puts "You push the brake and are going #{speed} mph."
  end

  def shut_off
    self.speed = 0
    puts "Your car has shut off. Oh no."
  end

  def spray_paint(color)
    self.color = color
    puts "Your new #{color} paint job looks great!"
  end

end

# The test drive
car = MyCar.new(2013, 'Hyundai Sonata', 'pearl')
car.info
car.speed_up(46)
car.brake(15)
car.current_speed
car.shut_off
```

*At the end of this exercise, Melinda is confused about:*
- When, in these method definitions, should we reference the instance variable directly and when should we use the getter/setter methods?
- The above question has only instance methods. No class methods up to this point.

## **Classes and Object - Part 2**

1. Add a class method to your MyCar class that calculatese the gas mileage of any car.

2. Override the `to_s` method to create a user friendly print out of your object.

``` ruby
class MyCar
  attr_accessor :color, :model, :speed
  attr_reader :year

  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @speed = 0
  end

  def to_s
    "Your car is a #{color} #{model} from #{year}."
  end

  def current_speed
    puts "You are going at #{speed} mph."
  end

  def speed_up(number)
    self.speed += number
    puts "You push the gas and are going #{speed} mph."
  end

  def brake(number)
    self.speed -= number
    puts "You push the brake and are going #{speed} mph."
  end

  def shut_off
    self.speed = 0
    puts "Your car has shut off. Oh no."
  end

  def spray_paint(color)
    self.color = color
    puts "Your new #{color} paint job looks great!"
  end

  def self.calc_gas_mileage(gallons, miles)
    puts "Your gas mileage is #{miles/gallons} miles per gallon of gas."
  end

end

# The test drive
car = MyCar.new(2013, 'Hyundai Sonata', 'pearl')
car.info
car.speed_up(46)
car.brake(15)
car.current_speed
car.shut_off
```

3. When running the following code...
``` ruby
class Person
  attr_reader :name
  def initialize(name)
    @name = name
  end
end

bob = Person.new("Steve")
bob.name = "Bob"
```
We get the following error:
``` ruby
test.rb:9:in `<main>': undefined method `name=' for
  #<Person:0x007fef41838a28 @name="Steve"> (NoMethodError)
```
Why do we get this error and how do we fix it?

This error occurs because we have only created a getter method for `name` using the `attr_reader` method. When we try to reassign the `name` instance variable to `"Bob"`, we need a setter method called `name=`.

To create both a getter and setter method, we need to call `attr_accessor :name`.


## **Practice with Andrew <3**

``` ruby
class GoodDog
  attr_reader :name

  def initialize
    self.name = 'Puppi'
  end

  private
  attr_writer :name
end

puppi = GoodDog.new
p puppi.name
```

What I learnt:

- `attr_reader`, `attr_writer`, and `attr_accessor`  all create getter/setter/both *methods*
- Inside `initialize` we can use a couple things to set the state of the object's attributes:
    - `@name`
    - if setter `name=` is available `self.name`
- However, `name = 'Puppi'` in `initialize` doesn't set the attribute of the object since we're just assigning a local variable `name` to the String `Puppi`.
- Ruby convention states that outside `initialize`, we reference object's attributes using the getter method (i.e. `self.name`) rather than with the instance variable `@name`
- We want to be careful who has access to setter methods and what they can do with them. So we normally:
    - invoke `attr_writer :name` in the `private` section of the class
    - write our own setter method that formats arguments in a specific way or only accepts certain things or etc...
        - in this case, we don't need to have an `attr_writer` since we're just overwriting the setter method it creates
- Setter methods always:
    - return the argument they were passed in
    - return true (unless the arguments are `false` or `nil`)


## **Inheritance**

TIL:
- `#ancestors` is a *public instance method* of `Module`
    - We can only call it on classes we make, not instances of our class.
- **Private methods are not avaialbe to objects of the class**
    - Because we want to initialize `Student`s outside of the class, we must make the setter methods for `@name` and `@grade` *protected*, not private

``` ruby
require 'pry'

module Towable

  def tow(vehicle_string)
    puts "Now we're towing #{vehicle_string}!"
  end

  def can_tow?(pounds)
    pounds < 2000
  end

end

class Vehicle
  attr_accessor :color, :speed
  attr_reader :year, :model

  @@vehicles_created = 0

  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @speed = 0
    @@vehicles_created += 1
  end

  def to_s
    "Your car is a #{color} #{model} from #{year}."
  end

  def age
    puts "Your #{model} is #{years_old} years old."
  end

  def current_speed
    puts "You are going at #{speed} mph."
  end

  def speed_up(number)
    self.speed += number
    puts "You push the gas and are going #{speed} mph."
  end

  def brake(number)
    self.speed -= number
    puts "You push the brake and are going #{speed} mph."
  end

  def shut_off
    self.speed = 0
    puts "Your car has shut off. Oh no."
  end

  def spray_paint(color)
    self.color = color
    puts "Your new #{color} paint job looks great!"
  end

  def self.calc_gas_mileage(gallons, miles)
    puts "Your gas mileage is #{miles/gallons} miles per gallon of gas."
  end

  def self.vehicles_created
    puts "At this point, you've created #{@@vehicles_created} instances of the Vehicle class."
  end

  private

  def years_old
    Time.now.year - self.year
  end
end

class MyCar < Vehicle
  NUMBER_OF_DOORS = 4

  def initialize(year, color, model)
    super(year, color, model)
  end
end

class MyTruck < Vehicle
  include Towable

  NUMBER_OF_DOORS = 2

  def initialize(year, color, model)
    super(year, color, model)
  end
end

# Script

car = MyCar.new(2014, 'grey', 'Hyundai Sonata')
puts car
car.speed_up(60)
car.brake(15)
car.shut_off
car.spray_paint('pearl')
puts car
car.age
Vehicle.calc_gas_mileage(10, 100)
Vehicle.vehicles_created

puts "~~~~~~~~~~~"

truck = MyTruck.new(2016, 'white', 'Ford Fusion')
puts truck
truck.speed_up(40)
truck.brake(5)
truck.shut_off
truck.spray_paint('red')
puts truck
p truck.can_tow?(1000)
Vehicle.vehicles_created
```

``` ruby
require 'pry'

class Student
  attr_reader :name

  def initialize(name, grade)
    @name = name
    @grade = grade
  end

  def better_grade_than?(other_student)
    self.grade > other_student.grade
  end

  protected

  attr_writer :name
  attr_accessor :grade

end

joe = Student.new("Joe", 90)
bob = Student.new("Bob", 84)
puts "Well done!" if joe.better_grade_than?(bob)
```
