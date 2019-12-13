## Pass By Reference Vs. Pass By Value


### Definitions

"Pass by Value": The method has a *copy* of the original object. Operations performed on the object within the method have no effect on the original object outside the method.

"Pass by Reference": The method receives a reference (address in stack) to the original object. Operations within the method can affect the original object.


### Variables as Pointers

*Recall*: Variables are pointers to physical space in memory. Objects each get their own space in memory. See examples below:

Below, `a` and `b` initially point at the same location in memory. However, `a` is assigned to a new String object, so in the end `a` and `b` point to different locations in memory.

``` ruby
a = "hi there"
b = a
a = "not here"
# => a = "not here"
# => b = "hi there"
```

Below, `a` and `b` point at the same location in memory. The object in that location is then mutated to add ", Puppi".

```ruby
a = "hi there"
b = a
a << ", Puppi"
# => a = "hi there, Puppi"
# => b = "hi there, Puppi"
```

---

**Additional note supplements from Medium posts**

### Variable References and Mutability of Ruby Objects

This article discusses how Ruby manipulates variables and objects. In particular, we focus on *how objects are passed around in the Ruby program*.

#### Variables and References

**Def'n Object.** A bit of data that has some sort of state (a.k.a. value) and associated behaviour.

Here's how to assign a variable to an object: `greeting = "Hello"`

After assigning a variable to an object we can say:
- The variable `greeting` refers to the `String` object with value `"Hello"`
- Variable `greeting` is *bound to* the `String` object

We can then assign variable `greeting` to another variable:
``` ruby
>> whazzup = greeting
# => "Hello"

>> greeting
# => "Hello"

>> whazzup
# => "Hello"
```
Above, both variables `greeting` and `whazzup` refer to the same `String` object. In addition, the two variables are *aliases* for each other. We can use either variable to *mutate* the `String` object they refer to:

``` ruby
>> greeting.upcase!
# => "HELLO"

>> whazzup
#==> "HELLO"
```

#### Reassignment

Continuing with the example above, we can assign a new object to one of these variables:

``` ruby
>> greeting = "Woof!"
# => "Woof!"

>> whazzup
# => "HELLO!"
```

Reassignment doesn't change the object referenced by the variable -- it binds the variable to a completely new object.

**Reassigning a variable to a new object is DIFFERENT from mutating the object a variable refers to**

#### Mutability

Object can be mutable (can be changed) or immutable (cannot be changed).

Understanding the mutability of an object is necessary for understanding how the language deals with the object.

##### Immutable Objects

Some listed examples include: Numbers (Ints, Floats, ...), Booleans, and `nil`.
Any class can establish itself as immutable by not providing any methods that alter *the object's state*.

##### Mutable Objects

Most objects in Ruby are mutable. Depending on the object's class, we can modify the object via setter methods or by calling mutating methods that perform complex operations.

#### A Brief Introduction to Object Passing

The ability of a method to modify arguments depends on:
- mutability/immutability of the object
- how the argument is passed to the method

*Passing by value*: arguments are copied, and that copy is passed to the method. The original object is not accessible by the method.

*Pass by reference*: arguments reference the original object, so the method has access to the original object. The object can be modified if it's mutable.

Know which strategy is used for a given argument & method so we can understand if the method modifies its arguments.

#### Conclusion

- Ruby variables are references to objects in memory
- Multiple variables can reference the same object -- changing the value of the object will be reflected in the other variables bound to that object
- Assignment and reassignment changes the object that the variable is bound to (i.e. original object *not* mutated)



### Mutating and Non-Mutating Methods in Ruby

### Object Passing in Ruby - Pass by Reference of Pass by Value?
