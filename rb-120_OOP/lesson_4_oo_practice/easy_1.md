## Practice Problems: Easy 1

### Question 1

Which of the following are objects in Ruby? If they are objects, how can you find out what class they belong to?

1. `true`
2. `"hello"`
3. `[1, 2, 3, "happy days"]`
4. `142`

**Answer**: All of the above are objects in Ruby. To find the class of an object, we can invoke the method `Object#class` on the object.

### Question 2

If we have a `Car` class and a `Truck` class and we want to be able to `go_fast`, how can we add the ability for them to `go_fast` using the module `Speed`? How can you check if your `Car` or `Truck` can now go fast?

Given code:
``` ruby
module Speed
  def go_fast
    puts "I am a #{self.class} and going super fast!"
  end
end

class Car
  def go_slow
    puts "I am safe and driving slow."
  end
end

class Truck
  def go_very_slow
    puts "I am a heavy truck and like going very slow."
  end
end
```

To give access to the method `go_fast` for objects in the `Car` and `Truck` classes, we can include the module in both classes by placing `include Speed` right after the start of the class definitions.

To check if the `Car` and `Truck` objects can now go fast, we would have to initialize a new `Car` and `Truck` object and call the method on these objects as shown below:
``` ruby
Car.new.go_fast
Truck.new.go_fast
```

### Question 3

In the last question we had a module called `Speed` which contained a `go_fast` method. We included this module in the `Car` class as shown below.
``` ruby
module Speed
  def go_fast
    puts "I am a #{self.class} and going super fast!"
  end
end

class Car
  include Speed
  def go_slow
    puts "I am safe and driving slow."
  end
end
```
When we called the `go_fast` method from an instance of the `Car` class (as shown below) you might have noticed that the `string` printed when we go fast includes the name of the type of vehicle we are using. How is this done?
``` ruby
>> small_car = Car.new
>> small_car.go_fast
# => I am a Car and going super fast!
```

In the `Speed#go_fast` method, we have a string interpolation snippet that invokes the `Object#class` method on `self`. In context of an instance method, `self` refers to the object invoking the method. Therefore, `self.class` should return the class of the invoking object, which ends up being `Car` class for `small_car`.

**Launch School additional detail**:
We don't need to use `to_s` here because it is inside of a `string` and is interpolated which means it will take care of the `to_s` for us.

### Question 4

If we have a class `AngryCat` how do we create a new instance of this class?
The `AngryCat` class might look something like this:
``` ruby
class AngryCat
  def hiss
    puts "Hisssss!!!"
  end
end
```

To create a new instance of the `AngryCat` class, we invoke the `new` method like this: `AngryCat.new`.

### Question 5

Which of these two classes has an instance variable and how do you know?
``` ruby
class Fruit
  def initialize(name)
    name = name
  end
end

class Pizza
  def initialize(name)
    @name = name
  end
end
```

The `Pizza` class has an instance variable `@name`. We know its an instance variable because its prepended with a `@` symbol. In the case of the `Fruit` class, it defines a local variable `name` that lives within the scope of the `Fruit#initialize` method.

**Launch School Solution**:
You can find out if an object has instance variables by either looking at the class or asking the object. First, lets look at the class definitions.

(Melinda looked at the class in the solution she wrote.)

To complete the method of "asking the object": We first create a `Pizza` object and `Fruit` object. Then we can use the method `#instance_variables` to ask each object what instance variables they have.

### Question 6

What could we add to the class below to access the instance variable `@volume`?
``` ruby
class Cube
  def initialize(volume)
    @volume = volume
  end
end
```

We would need to add a getter method for `@volume`. To do so, we can either use Ruby's `attr_reader :volume`, or we can write a manual getter method like below:
``` ruby
def volume
  @volume
end
```

### Question 7

What is the default return value of `to_s` when invoked on an object? Where could you go to find out if you want to be sure?

The default return value of `to_s` is the object class and location. To find out if you want to be sure, you can open `irb`, create a new object, and find out!

**Launch School answer**: By default, the `to_s` method will return the name of the object's class and *an encoding of the object id*.

### Question 8

If we have a class such as the one below:
``` ruby
class Cat
  attr_accessor :type, :age

  def initialize(type)
    @type = type
    @age  = 0
  end

  def make_one_year_older
    self.age += 1
  end
end

kitty.make_one_year_older
```
You can see in the `make_one_year_older` method we have used `self`. What does `self` refer to here?

Since `make_one_year_older` is an instance method, `self` would refer to the instance of `Cat` (object) that is invoking the method.

### Question 9

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
In the name of the `cats_count` method we have used `self`. What does `self` refer to in this context?

In this context, `self` refers to the class `Cat`. The `self` prepended to `cats_count` makes this a class method!

### Question 10

If we have the class below, what would you need to call to create a new instance of this class?

``` ruby
class Bag
  def initialize(color, material)
    @color = color
    @material = material
  end
end
```

To create a new instance of the class, we would need call `Bag.new()` and pass in arguments for the bag `color` and `material`. Without passing in the arguments, we would get an `ArgumentError`.
