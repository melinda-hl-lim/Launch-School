# Assessment Checklist

## Classes and objects []

*Classes define objects. Objects are created from classes.*
- Class is to Object, as Blueprint is to House
- Classes define the *attributes* and *behaviours* of its objects

When defining a class, we focus on two things:
- *States*: track attributes for individual objects
- *Behaviours*: what objects are capable of doing

**Def'n Instantiation.** The workflow of creating a new object/instance from a class

*Side note:* Everything in Ruby are objects except methods and blocks

*Side note:* Every class we create subclasses from the Ruby class `Object`


## Use attr_* to create setter and getter methods []

- Getter and setter methods provide us a way to expose and manipulate objects' states
- `attr_*` methods take a `Symbol` as a parameters


## How to call setters and getters []

- By convention, a getter/setter method shares a name with the object attribute it gets/sets
- Within a class, the setter method must be invoked as `self.setter_method`; otherwise, Ruby will think we are instantiating a new local variable called `setter_method`. 


## Instance methods vs. class methods []

**Def'n Instance methods.**

**Def'n Class methods.** Methods we can call directly on the class itself without having to instantiate any objects
- When defining a class method, prepend the method name with `self`
- Class methods contain functionality that does not pertain to individual objects (i.e. a method that doesn't deal with any objects' states)


## Referencing and setting instance variables vs. using getters and setters []

Using getters and setters is preferred to referencing and setting instance variables directly, as using these methods allow us to define how we want to retrive or set the object's state in one location.

Example: We create a getter method for `@ssn` that only reveals the last four digits - this logic is stored within the getter method and can be changed in one location easily.

Example: We create a setter method for entering a value in `@ssn` - this setter method contains logic that ensures the SSN is the correct length and divided into three sections correctly


## Class inheritance, encapsulation, and polymorphism []

**Def'n Inheritance.** The concept referencing a class inheriting behaviour from another class (the *superclass*)

**Def'n Encapsulation.** Hiding pieces of functionality and making it unavailable to the rest of the code base
- Provides protection for data so they cannot be manipulated in unexpected ways

**Def'n Polymorphism.** The ability for data to be represented in multiple forms  


## Modules []

**Def'n Module.** A collection of behaviours usable in other classes via *mixins*
- A module is **"mixed in"** to a class using the `include` method invocation
- Modules provide another way to apply polymorphic structures


## Method lookup path []

- Use the `ancestors` method on any *class* to see the method lookup path

## self []

**Def'n `self`.** A reserved keyword within Ruby


### Calling methods with self []

- Setter methods are either called with `self` or an instance of the class 


### More about self []

`self` can reference different things depending on the context. 
- Inside of an instance method in a class, `self` references the calling object of the method
- Outside of an instance method in a class, `self` references the class itself


## Reading OO code []

## Fake operators and equality []

See the table here: https://launchschool.com/lessons/d2f05460/assignments/9a7db2ee

## Truthiness []
c
## Working with collaborator objects []



--- 
---


# Additional Notes

## Object Oriented Programming
- A programming paradigm created to deal with complex, large software systems
    - Larger programs became diffiult to maintain because of all the dependencies
    - OOP gives us the flexibility to use pre-written code for new purposes
- Create containers for data to section off code


---


## Classes and Objects

Classes define objects. Objects are created from classes. 
- Class is to Object, as Blueprint is to House 
- Classes define the attributes and behaviours of its objects

When defining a class, we focus on two things: 
- States: track attributes for individual objects 
- Behaviours: what objects are capable of doing

### Variable Types

*Constants*:
- variables with values we never want to change

*Class Variables*:
- keep track of class level details
- created by prepending `@@` symbol
- can be accessed from within instance methods

*Instance Variables*:
- keep track of objects' unique states
- are scoped at the object (instance) level
- exist as long as the object instance exists


### Instance Methods

*Instance Methods*:
- expose behaviours for objects
- are defined in a class and are available to objects of that class

**Def'n Instantiation**: the entire workflow of creating a new object (an instance). An object is returned by calling the *class method* `new`.

**Initializing a New Object**

The `initialize` method is also known as a *constructor*, and gets called every time you create a new object.

Calling the `new` *class* method leads us to the `initialize` *instance* method.

**Accessor Methods**

Accessor methods:
- allow us to expose and change an object's state
- are instance methods
- Note: we can use these methods from within the class

*Getter* methods allow us to access values stored in instance variables.

*Setter* methods allow us to set values stored in instance variables.
- With ruby syntactical sugar, a setter method `name` is defined as `def name=(n)` but can be called as `name = Puppi'`
- When invoking a setter method from inside the class, we need to call it with `self` (ex: `self.name = 'Puppi'`). Otherwise Ruby will think we're initializing local variables

**`attr_accessor`**: a method provided by Ruby to automatically create getter and setter methods
- *`attr_reader`*: Ruby method to create a getter method
- *`attr_writer`*: Ruby method to create a setter method

**The `to_s` Method**

- Comes built into every Ruby class
- Automatically called when `puts` method is invoked or during *string interpolation*
    - `puts puppi` is equivalent to `puts puppi.to_s`

Side note: calling `p puppi` is the same as `puts puppi.inspect`

### Class Methods

*Class Methods*:
- can be called directly on the class itself with no instances of class
- are defined by prepending method name with reserved word `self`
- contain functionality not pertaining to individual objects (i.e. does not deal with states of an object)

### More About `self`

We use `self` to specify a certain scope for our program. Depending on when it's used, `self` can refer to different things:
- *within* an instance method inside the class, `self` references the instance (object) that called the method
- *outside* an instance method, `self` references the class and can be used to define class methods


---


## Inheritance

*Inheritance* is when a class inherits behaviour from another class. The class inheriting is the *subclass*, and the class its inheriting from is the *superclass*

Ruby implements inheritance through:
    - *class inheritence*
    - *mixing in modules*

*Pros*:
- allows programmers to define basic classes with large reusability and smaller subclasses for more detailed behaviours
- allows us to extract common behaviours from classes that share that behaviour, keeping logic in one place
- greate for models that are naturally hierarchical

We can override methods provided by a superclass in the subclass because Ruby checks the object's class first for the method before looking in the superclass

*The `super` method* allows us to call methods up the inheritance hierarchy - Ruby looks for a method by the same name within the classes and modules within the *method lookup path*

#### Inheritance vs. Modules

- *Class inheritance* usually results in a subclass that is a more specialized form of its super class; *Interface inheritance* from mixing in modules provides the class an interface from the module
- You can only subclass from one class, but you can mix in as many modules as you'd like
- If it's an "is-a" relationship, choose class inheritance. If it's a "has-a" relationship, choose modules
- You can't instantiate modules



## Encapsulation

**Def'n**: hiding pieces of functionality and making it unavailable to the rest of the code base

*Pros*:
- data protection
- programmers can think on a new level of abstraction


## Polymorphism

**Def'n**: ability for data to be represented as many different types

*Pros*:
- gives flexibility in using pre-wrtten code for new purposes

---

## Module

*Modules* contain a collection of behaviours usable in other classes via *mixins*

*Modules* are used for:
- *namespacing* and grouping common methods together (i.e. is a *container* for common methods)
- applying polymorphic structures
- DRYing up code

Object cannot be created from a module. For a class and its objects to access the module's methods, it must be *mixed in* via the `include` method

**Namespacing**
Def'n: organizing/grouping similar classes under a module.
- Makes it easier for us to recognize related classes
- Reduces the likelihood of classes colliding with other siilarly named classes in codebase

**Module Methods (i.e. containers for methods)**
Use modules to house methods that may be out of place within code

---

## Method Lookup

When calling a method, Ruby knows where to look for the method because of a distinct lookup path. We can use the `ancestors` method on any class to find out the method lookup chain.

- When including a module in a class, the module is checked after the class in the method lookup path.

---

## Private, Protected and Public

**Public methods**: a method that is available to anyone who knows either the class name or the object's name
- readily available for the rest of the program to use
- comprise the class's *interface* (i.e. how other classes and objects will interact with this class and its objects)

**Private methods**: Methods that are doing work in the class but don't need to be available to the rest of the program.
- only accessible from other methods in the class when called without `self`
- not accessible outside of the class definition at all

**Protected methods**: Follow two rules to understand this approach in-between public and private
- from outside the class, `protected` methods act like `private` methods
- from inside the class, `protected` methods are accessible just like `public` methods
