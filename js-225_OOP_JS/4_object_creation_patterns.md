## Introduction

JavaScript doesn't implement behaviour sharing using class-based inheritance: instead, *it uses the object prototype to share properties*. 

This distinction is important to understanding how JS generates individual objects, and forms the basis of object-creation patterns that feature behaviour sharing. 

Good video overview of different object creation methods: http://www.objectplayground.com/


## Factory Functions

Factory functions allow us to create the same "type" of objects easily with a pre-defined "template".

``` js
function createPerson(firstName, lastName = '') {
  return {
    firstName,
    lastName,
    fullName() {
      return (this.firstName + ' ' + this.lastName).trim();
    },
  };
}
```

However, some disadvantages include:
- every object created with the factory function has a full copy of all the methods, which can be redundant
- we can't inspect an object and know whether we created it from a factory function. This makes it difficult to identify whether an object is a specific "type"


## Constructor Pattern

A **constructor function** is a regular JS function intended to be called with the `new` operator. Conventionally, we capitalize the first letter in the function name to show it's a constructor.

In the example below, the `Person` function is a constructor function that we use to create objects. 
``` js
// constructor function
function Person(firstName, lastName = '') {
  this.firstName = firstName;
  this.lastName = lastName;
  this.fullName = function() {
    return (this.firstName + ' ' + this.lastName).trim();
  };
}

let john = new Person('John', 'Doe');
let jane = new Person('Jane');

john.fullName();              // "John Doe"
jane.fullName();              // "Jane"

john.constructor;             // function Person(..)
jane.constructor;             // function Person(..)

john instanceof Person;       // true
jane instanceof Person;       // true
```

If we call the `Person` constructor *without* the `new` operator:
``` js
Person('John', 'Doe');
window.fullName();          // "John Doe"
```

`this` in the function points to the global object, so we've defined properties and functions on the global object itself.

When we *call a function with the `new` operator*, the following happens:
1. a new object is created
2. `this` in the function is set to point to the new object
3. The code in the function is executed
4. `this` is returned if the constructor doesn't explicitly return an object.

*Why constructors must return objects*

Suppose we want to validate the presence of a last name in our `Person` constructor. If no last name is provided, we return a string saying so:
``` js
function Person(firstName, lastName) {
  if (!lastName) {
    return 'Please provide a last name';
  }

  this.firstName = firstName;
  this.lastName = lastName;
  this.fullName = function() {
    return (this.firstName + ' ' + this.lastName).trim();
  };
}

let noLastName = new Person('John');
console.log(noLastName);   
// logs an instance of the Person constructor
console.log(noLastName instanceof Person); 
// => true
```

Since we didn't return an object during our validation check, the value that the function returns is in instance of the `Person` constructor function. 

To make sure the value returned is not an instance of the `Person` constructor function, we have to return an object in our validation check:
``` js
function Person(firstName, lastName) {
  if (!lastName) {
    return { invalidInput: 'Please provide a last name' };
  }

  this.firstName = firstName;
  this.lastName = lastName;
  this.fullName = function() {
    return (this.firstName + ' ' + this.lastName).trim();
  };
}
```


## Objects and Prototypes

Every JS Object has a special hidden property called `[[Prototype]]`. 

When we create an object with `Object.create`, it sets the `[[Prototype]]` property of the created object to be the passed-in object.

``` js
let foo = {};
let bar = {};

let qux = Object.create(foo);
console.log(Object.getPrototypeOf(qux) === foo); // true
console.log(foo.isPrototypeOf(qux));             // true

Object.setPrototypeOf(qux, bar);
console.log(Object.getPrototypeOf(qux) === bar); // true
console.log(bar.isPrototypeOf(qux));             // true
```

Above, we say that `foo` is the **prototype object** of the object returned by `Object.create` and assigned to `qux`.

Methods introducted:
- `Object.getPrototypeOf`
- `Object.setPrototypeOf`
- `Object.isPrototypeOf`
- `Object.create`

### Prototype Chain and the Object.prototype Object

We can use `Object.create` to create objects that form a prototype chain:

``` js
let foo = {
  a: 1,
  b: 2,
};

let bar = Object.create(foo);
let baz = Object.create(bar);

Object.getPrototypeOf(baz) === bar;       // true
Object.getPrototypeOf(bar) === foo;       // true

foo.isPrototypeOf(qux);                   
// true - because foo is on qux's prototype chain
```

The `Object.prototype` object is at the end of the prototype chain for all JS objects. If you don't create an object from a prototype, it's prototype is the `Object.prototype` object (like `foo` in the exmaple above).


## Prototypal Inheritance and Behaviour Delegation

**Prototype Chain Lookup for Property Access**

When we try to access a property or method, JS searches not only the object itself, but also all objects on its prototype chain until it reaches the end.

``` js
let foo = {
  hello() {
    return 'hello ' + this.name;
  },
};

let bar = Object.create(foo);
bar.name = 'world';
bar.hello();          // returns hello world
```

In this case, the `hello` method is found on the `bar` object's prototype object (`foo`), then called with the context of the `bar` object itself.

**Protoypal Inheritance and Behaviour Delegation**

JS's prototype chain lookup for properties gives us the ability to store an object's data and behaviours not just in the object itself, but anywhere on its prototype chain. This is very powerful when we want to share data or behaviours:

``` js
let dog = {
  say() {
    console.log(this.name + ' says Woof!');
  },

  run() {
    console.log(this.name + ' runs away.');
  },
};

let fido = Object.create(dog);
fido.name = 'Fido';
fido.say();             // => Fido says Woof!
fido.run();             // => Fido runs away.

let spot = Object.create(dog);
spot.name = 'Spot';
spot.say();             // => Spot says Woof!
spot.run();             // => Spot runs away.
```

We defined methods `say` and `run` on `dog`, the prototype object of all dogs. Doing so give us these advantages:
- we can create dogs easily with the `dog` prototype
- we avoid duplicating methods `say` and `run` on every object
- if we need to add/remove/update behaviours to apply to all dogs, we can just modify the prototype object

This patterns is sometimes called **Prototypal Inheritance**, and sometimes called **Behaviour Delegation**. 
- from a top-down / design time POV, objects on the bottom of the prototype chain "inherited" properties and behaviours of all the upstream objects
- from a bottom-up / run time POV, objects on the bottom of the prototype chain can "delegate" requests to the upstream objects to be handled. 

**Overriding Default Behaviour**

Objects created from prototypes can override shared behaviours by defining the same methods locally:

``` js
let dog = {
  say() {
    console.log(this.name + ' says Woof!');
  },
};

let fido = Object.create(dog);
fido.name = 'Fido';
fido.say = function() {
  console.log(this.name + ' says Woof Woof!');
};

fido.say();             // => Fido says Woof Woof!
let spot = Object.create(dog);
spot.name = 'Spot';
spot.say();             // => Spot says Woof!
```

**Object.getOwnPropertyNames and object.hasOwnProperty**

With behaviour delegation, `obj.prop !== undefined` is no longer a reliable test to see if a property is defined on an object. If `prop` is defined anywhere in the object's prototype chain, then the expression returns true.

Instead, we can use these methods to check an object's own property:
- `hasOwnProperty` method tests if a property is defined on the object
- `Object.getOwnPropertyNames` returns an array of an object's own property names.

**Methods on Object.prototype**

Some useful methods:
- `Object.prototype.toString()`: returns string representation of the object
- `Object.prototype.isPrototypeOf(obj)`: test if the object is in another object's prototype chain
- `Object.prototype.hasOwnProperty(prop)`: test whether the property is defined on the object itself


## Practice Problems: Prototypes and Prototypal Inheritance

Good problems worthy of reviewing. There's lots of little JS nuances that I can learn from these problems and solutions.


## Function Prototypes and Object Prototypes 

**Function prototypes** are properties of functions. This `prototype` property is assigned an object. When the function is used as a *constructor*, all objects which the function constructs will have this prototype object set as their prototype.

``` js
let Foo = function() {};
let obj = Foo.prototype;

let bar = new Foo();
Object.getPrototypeOf(bar) === obj;  // true
bar.constructor === Foo;             // true; bar is created from Foo
bar instanceof Foo;                  // true; bar is an instance of Foo
```

Every time we call a function as a constructor, JS creates an object that is prototype-linked to the object assigned to the constructor's `prototpe` property. This helps us create the *prototype chain*.

Recall that **object prototypes** are the next object in the lookup for property access. *We can define shared behaviors on the constructor's `prototype` property to create behaviour delegation*. This is called the **Prototype Pattern** of object creation.

``` js
let Dog = function() {};

Dog.prototype.say = function() {
  console.log(this.name + ' says Woof!');
}

Dog.prototype.run = function() {
  console.log(this.name + ' runs away.');
}

let fido = new Dog();
fido.name = 'Fido';
fido.say();             // => Fido says Woof!
fido.run();             // => Fido runs away.
```

We will cover the two terms and learn how to use them to create a prototype chain for behaviour delegation using constructor functions.


## Constructors, Prototypes, and the Prototype Chain

We're expanding our `Dog` example by extending the prototype chain:
`Dog.prototype --> Animal.prototype --> Object.prototype`

There are two methods for doing extending the prototype chain:
1) Use the object returned by the `Animal` constructor
2) Use the object created by `Object.create(Animal.prototype)`

**Method 1: Using the Object Returned by the Animal Constructor**

``` js
function Animal(type) {
  this.type = type;     // values can be land, air, or water
}

Animal.prototype.move = function() {
  console.log('Animal is moving.');
};

let Dog = function() {};
Dog.prototype = new Animal('land'); // THIS IS THE IMPORTANT LINE

Dog.prototype.say = function() {
  console.log(this.name + ' says Woof!');
};

let fido = new Dog;
fido.type;    // returns 'land'
```

On the important line, we use the object that `Animal` constructor returns as the value assigned to `Dog.prototype`. So any object we create from the `Dog` constructor will, by default, have the properties of the object returned from the `Animal` constructor. 

An issue with this approach is the delegation of `type = land` property from `Dog` to `Animal`. Only behaviours are usually delegated. So we don't expect `fido.type` to exist or return `land`.

**Method 2: Using the Object Created by Object.create(Animal.prototype)**

``` js
function Animal(type) {
  this.type = type;      // value can be land, air, or water
}

Animal.prototype.move = function() {
  console.log('Animal is moving.');
};

let Dog = function() {};
Dog.prototype = Object.create(Animal.prototype); // THIS IS THE IMPORTANT LINE 

Dog.prototype.say = function() {
  console.log(this.name + ' says Woof!');
};

let fido = new Dog;
fido.type;    // returns undefined
```

This method uses `Object.create` on `Animal.prototype`. Doing so leverages the fact that objects that `Object.create` return have their `[[Prototype]]` property set to the object that was pass in as an argument. 

A benefit of this approach is that no new properties can be found on the created object -- only behaviour is shared. 


**Note: Consequence of Extending Prototype Chain**

Both methods above replace the original `Dog.prototype`, which had a `constructor` property that referenced the `Dog` constructor function.

As a result of the replacement, `Dog.prototype.constructor` now points to the `Animal` constructor, not the `Dog` constructor. 

This matters [in some situations where the value of the `constructor` property is important](https://2ality.com/2011/06/constructor-property.html).

When this happens, we need to reassign the `constructor` property:

``` js
let myDog = new Dog;
myDog.constructor;  // returns `Animal` constructor function

Dog.prototype.constructor = Dog;
myDog.constructor;  // returns `Dog` constructor function (an anonymous function)
```

**Note: Wild Code with Unexpected Behaviours**

We may see this code in the wild:
``` js
function Animal(type) {
  this.type = type;      // values can be land, air, or water
}

let Dog = function() {};
Dog.prototype = Animal.prototype; // THIS IS THE IMPORTANT LINE
```
Assigning `Animal.prototype` to `Dog.prototype` makes both prototype properties point to the *exact same object*. Thus, when we mutate `Dog.prototype` the change is reflected in `Animal.prototype`.



## Practice Problems: Constructor Functions and Prototypes (2)

Worthy of reviewing for a couple nuances in JS object construction. These are also good brainteasers to think of implementations around JS limitations.


## The Pseudo-classical Pattern and the OLOO Pattern

Here are two best practice patterns for creating objects in JavaScript:
1) The Pseudo-classical Pattern
2) the Object Linking to Other Object (OLOO) Pattern

**Object Creation Considerations**

When we have many instances of an object type, we typically want each instance to:
- have their own **state**
- share **behaviours** that all objects of the type should know

**The Pseudo-classical Pattern**

The Pseudo-classical pattern is a combination of the constructor pattern and the prototype pattern. We use constructors to set object states, and put shared methods on the constructor function's prototype.

``` js
let Point = function(x = 0, y = 0) {            // capitalized constructor name as a convention
  this.x = x;                                   // initialize states with arguments
  this.y = y;                                   // 0 as default value
};

Point.prototype.onXAxis = function() {  // shared behaviors added to constructor's prototype property
  return this.y === 0;
};

Point.prototype.onYAxis = function() {  // these methods are added one by one
  return this.x === 0;
};

Point.prototype.distanceToOrigin = function() {
  return Math.sqrt((this.x * this.x) + (this.y * this.y));
};

let pointA = new Point(30, 40);         // use new to create objects
let pointB = new Point(20);

pointA instanceof Point;                // use instanceof to check type
pointB instanceof Point;

pointA.distanceToOrigin();              // 50
pointB.onXAxis();                       // true
```

**The OLOO Pattern**

This pattern embraces JavaScript's prototype-based object model. With the OLOO pattern, we define the shared behaviours on a prototype object, then use `Object.create` to create objects that delegate directly from that object. 

``` js
let Point = {                       // capitalized name for the prototype as a convention
  x: 0,                             // default value defined on the prototype
  y: 0,

  onXAxis() {             // shared methods defined on the prototype
    return this.y === 0;
  },

  onYAxis() {
    return this.x === 0;
  },

  distanceToOrigin() {
    return Math.sqrt((this.x * this.x) + (this.y * this.y));
  },

  init(x, y) {            // optional init method to set states
    this.x = x;
    this.y = y;
    return this;
  },
};

let pointA = Object.create(Point).init(30, 40);
let pointB = Object.create(Point);

Point.isPrototypeOf(pointA);        // use isPrototypeOf to check type
Point.isPrototypeOf(pointB);

pointA.distanceToOrigin();          // 50
pointB.onXAxis();                   // true
```

**TODO: read the linked extra articles. They're good and worthy of review.**


## The Class Syntactic Sugar

ES6 introduced the `class` keyword as another way to create objects as well as establish inheritance. JS doesn't have true classes -- `class` is just syntactic sugar that wraps around the pseudo-classical pattern of object creation.

``` js
class Point {
  constructor(x = 0, y = 0) {
    this.x = x;
    this.y = y;
  }

  onXAxis() {
    return this.y === 0;
  }

  onYAxis() {
    return this.x === 0;
  }

  distanceToOrigin() {
    return Math.sqrt((this.x * this.x) + (this.y * this.y));
  }
}

// Instantiating Objects
let pointA = new Point(30, 40);
let pointB = new Point(20);

pointA instanceof Point;                // true
pointB instanceof Point;                // true

pointA.distanceToOrigin();              // 50
pointB.onXAxis();                       // true
```

Syntactically, there are three main differences:

1. The use of the keyword `class` instead of `function`
2. Parameters are defined and states are set within the `constructor` function, which automatically runs whenever an object is created
3. All methods defined within the `class` definition (except `constructor`) are defined on the prototype object

**A Couple Of Caveats**

1. All code in `class` executes in strict mode

2. Unlike function declarations, class declarations are not hoisted:
``` js


let pointA = new Point(30, 40);           
// ReferenceError: Point is not defined

class Point {
  constructor(x = 0, y = 0) {
    this.x = x;
    this.y = y;
  }

// rest of the code
}
```

3. Invoking the class constructor without the `new` keyword raises an error:
``` js
class Point {
  constructor(x = 0, y = 0) {
    this.x = x;
    this.y = y;
  }

// other code
}

let pointA = Point(30, 40);               
// TypeError: Class constructor Point cannot be invoked without 'new'
```

TODO: There are some gists to read on the second time round


## More Methods on the Object Constructor

**Object.create and Object.getPrototypeOf**

The `getPrototypeOf` method on `Object` returns the prototype object of an object that is passed in. 

When combined with `Object.create`, we can create a prototype chain that mimics classical inheritance.

``` js
Object.getPrototypeOf([]) === Array.prototype;    // true

function NewArray() {}
NewArray.prototype = Object.create(Object.getPrototypeOf([]));
```

**Object.defineProperties**

With the `defineProperties` method on `Object`, we can provide properties and values and set whether each property can be changed or not. 

``` js
let obj = {
  name: 'Obj',
};

Object.defineProperties(obj, {
  age: {
    value: 30,
    writable: false,
  },
});

console.log(obj.age); // => 30
obj.age = 32;
console.log(obj.age); // => 30
```

**Object.freeze**

We can use `Object.freeze` to make an object's properties all immutable, as long as the property values are not objects. Note though: if you freeze an object, it cannot be unfrozen.

``` js
let frozen = {
  integer: 4,
  string: 'String',
  array: [1, 2, 3],
  object: {
    foo: 'bar'
  },
  func() {
    console.log('I\'m frozen');
  },
};

Object.freeze(frozen);
frozen.integer = 8;
frozen.string = 'Number';
frozen.array.pop();
frozen.object.foo = 'baz';
frozen.func = function() {
  console.log('I\'m not really frozen');
};

console.log(frozen.integer);      // => 4
console.log(frozen.string);       // => String
console.log(frozen.array);        // => [1, 2]
console.log(frozen.object.foo);   // => baz
frozen.func();                    // => I'm frozen
```


## Modules

An introduction to modules in this gist: https://launchschool.com/gists/e7d0531f


## Summary

**Factory functions (a.k.a. Factory Object Creation Pattern)**
- Instantiate and return a new object in the function body
- They allow us to create new objects based on a pre-defined template
- Two drawbacks: 
  - There's no way to tell based on the returned object itself whether the object was created by a factory function
  - All objects created by factory functions that share behaviour have an owned copy of the method, which can be redundant

**Constructor functions**
- Are meant to be invoked with the `new` operator
- Instantiate a new object behind the scenes and allow the developer to manipulate it using the `this` keyword
- A typical constructur is used with the following pattern:
  - Constructor is invoked with `new`
  - A new object is created by the JS runtime
  - The new object inherits from the constructor's prototype
  - The new object is assigned to `this` inside the function body
  - The code inside the function is executed
  - `this` is returned unless there's an explicit return

**The `[[Prototype]]` property**
- Every object has a `[[Prototype]]` property that points to a special object, the object's prototype
- The object's prototype is used to lookup properties that don't exist on the object itself
- Usefule methods:
  - `Object.create` returns a new object with the argument object as its prototype
  - `Object.getPrototypeOf` can be used to retrieve the prototype object for an object
  - `Object.setPrototypeOf` can be used to replace an object's prototype object with another object
  - `obj.isPrototypeOf` can be used to check for prototype relationships between objects

*Following has not been melinda reviewed*

 The prototype chain property lookup is the basis for "prototypal inheritance", or property sharing through the prototype chain. Downstream objects "inherit" properties and behaviors from upstream objects, or, put differently, downstream objects can "delegate" properties or behaviors upstream.

    A downstream object shadows an inherited property if it has a same-named property on itself.
    Object.getOwnPropertyNames and obj.hasOwnProperty can be used to test whether a given property is owned by an object.

Every function has a prototype property that points to an object with a constructor property, that points back to the function itself. If the function is used as a constructor, then the returned object's [[Prototype]] will be set to the constructor's prototype property. This behavior allows us to set properties on the constructor's prototype object that will be shared by all objects returned by it. This is called the "Prototype Pattern" of object creation.
The Pseudo Classical Pattern of object creation generates objects using a constructor function that defines state, and then defines shared behaviors on the constructor's prototype.
The Objects Linking to Other Objects (OLOO) pattern of object creation uses a prototype object and Object.create to generate objects with shared behavior.

    An optional init method on the prototype object is defined to set unique states on the returned objects.


**Learnt from the quiz**

Given this:
``` js
function Foo() {}
```

What is the difference between `Foo.prototype` and the `[[Prototype]]` property of `Foo`?

Answer: 

`Foo.prototype` is the prototype object for any object returned by `Foo` when it is invoked as a constructor. 

The `[[Prototype]]` property is a reference to `Function.prototype`.
