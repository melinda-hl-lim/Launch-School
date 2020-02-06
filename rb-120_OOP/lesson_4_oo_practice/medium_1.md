## Practice Problems: Medium 1

### Question 1

Ben asked Alyssa to code review the following code:
``` ruby
class BankAccount
  attr_reader :balance

  def initialize(starting_balance)
    @balance = starting_balance
  end

  def positive_balance?
    balance >= 0
  end
end
```
Alyssa glanced over the code quickly and said - "It looks fine, except that you forgot to put the `@` before `balance` when you refer to the `balance` instance variable in the body of the `positive_balance?` method."

"Not so fast", Ben replied. "What I'm doing here is valid - I'm not missing an `@`!"

Who is right, Ben or Alyssa, and why?

Ben is right. Without the `@` symbol, simply referencing `balance` invokes the getter method `balance` for `@balance` set by the `attr_reader :balance` line.


### Question 2

Alan created the following code to keep track of items for a shopping cart application he's writing:
``` ruby
class InvoiceEntry
  attr_reader :quantity, :product_name

  def initialize(product_name, number_purchased)
    @quantity = number_purchased
    @product_name = product_name
  end

  def update_quantity(updated_count)
    # prevent negative quantities from being set
    quantity = updated_count if updated_count >= 0
  end
end
```
Alyssa looked at the code and spotted a mistake. "This will fail when `update_quantity` is called", she says.

Can you spot the mistake and how to address it?

Yes I can.

In the method implementation of `update_quantity`, the `quantity` is not actually setting `@quantity` to anything. In fact, `quantity` is a local variable that lives within the scope of `update_quantity` invocation.

To solve this provlem, we could simply add a `@` sybmol in front of `quantity`, or we could create a setter method for `quantity` (using `attr_writer`, `attr_accessor`, or our own implementation) and then prepend `self.` in front of `quantity`. This would make sure we are modifying the value of `@quantity`.


### Question 3

In the last question Alan showed Alyssa this code which keeps track of items for a shopping cart application:
``` ruby
class InvoiceEntry
  attr_reader :quantity, :product_name

  def initialize(product_name, number_purchased)
    @quantity = number_purchased
    @product_name = product_name
  end

  def update_quantity(updated_count)
    quantity = updated_count if updated_count >= 0
  end
end
```
Alyssa noticed that this will fail when `update_quantity` is called. Since quantity is an instance variable, it must be accessed with the `@quantity` notation when setting it. One way to fix this is to change `attr_reader` to `attr_accessor` and change `quantity` to `self.quantity`.

Is there anything wrong with fixing it this way?

The only issue with changing `attr_reader` to `attr_accessor` is that we have publically avaiable getter and setter methods for both instance variables `@quantity` and `@product_name`. If this information is okay to be publically manipulated, then there isn't anything wrong! It's only an issue if we want to be more strict about how users write values to these instance variables.

**Launch School elaboration**:
Nothing incorrect syntactically. However, you are altering the public interfaces of the class. In other words, *you are now allowing clients of the class to change the quantity directly (calling the accessor with the `instance.quantity = <new value>` notation) rather than by going through the `update_quantity` method*. It means that the protections built into the `update_quantity` method can be circumvented and potentially pose problems down the line.


### Question 4

Let's practice creating an object hierarchy.

Create a class called `Greeting` with a single method called `greet` that takes a string argument and prints that argument to the terminal.

Now create two other classes that are derived from `Greeting`: one called `Hello` and one called `Goodbye`.
    The `Hello` class should have a `hi` method that takes no arguments and prints "Hello".
    The `Goodbye` class should have a `bye` method to say "Goodbye".
Make use of the `Greeting` class `greet` method when implementing the `Hello` and `Goodbye` classes - do not use any puts in the `Hello` or `Goodbye` classes.

``` ruby
class Greeting
  def greet(string_greeting)
    puts string_greeting
  end
end

class Hello < Greeting
  def hi
    greet("Hello")
  end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end
```


### Question 5

You are given the following class that has been implemented:
``` ruby
class KrispyKreme
  attr_reader :filling_type, :glazing # add this

  def initialize(filling_type, glazing)
    @filling_type = filling_type.nil? ? "Plain" : filling_type # added ternary operator for value to be assigned
    @glazing = glazing
  end

  def to_s # added this method
    glazing.nil? ? "#{filling_type}" : "#{filling_type} with #{glazing}"
  end
end
```
And the following specification of expected behavior:
``` ruby
donut1 = KrispyKreme.new(nil, nil)
donut2 = KrispyKreme.new("Vanilla", nil)
donut3 = KrispyKreme.new(nil, "sugar")
donut4 = KrispyKreme.new(nil, "chocolate sprinkles")
donut5 = KrispyKreme.new("Custard", "icing")

puts donut1 # => "Plain"
puts donut2 # => "Vanilla"
puts donut3 # => "Plain with sugar"
puts donut4 # => "Plain with chocolate sprinkles"
puts donut5 # => "Custard with icing"
```
Write additional code for `KrispyKreme` such that the `puts` statements will work as specified above.

See comments in code block to see additions.


### Question 6

If we have these two methods:
``` ruby
class Computer
  attr_accessor :template

  def create_template
    @template = "template 14231"
  end

  def show_template
    template
  end
end
```
and
``` ruby
class Computer
  attr_accessor :template

  def create_template
    self.template = "template 14231"
  end

  def show_template
    self.template
  end
end
```
What is the difference in the way the code works?

**Launch School answer**:
There's actually *no difference in the result, only in the way each example accomplishes the task*. Compare both show_template methods. We can see in the first example that it works fine without self, therefore, self isn't needed in the second example. This is because show_template invokes the getter method template, which doesn't require self, unlike the setter method.

Both examples are technically fine, however, the general rule from the Ruby style guide is to *"Avoid self where not required."*


### Question 7

How could you change the method name below so that the method name is more clear and less repetitive?
``` ruby
class Light
  attr_accessor :brightness, :color

  def initialize(brightness, color)
    @brightness = brightness
    @color = color
  end

  def self.light_information
    "I want to turn on the light with a brightness level of super high and a colour of green"
  end

end
```

We could change it to `self.information` since the context of `Light` is already provided by the class that would be invoking the method.
