## [ ] Objects

### [ ] Organizing code into appropriate objects

### [X] Object factories

Object factories are functions that return objects. They provide a way we can template and easily create objects with the same properties and methods.

``` js
function makeDog(name, age, breed) {
  return {
    name,
    age,
    breed,

    introduce() {
      console.log(`Woof! My name is ${name} and I'm a ${breed}!`)
    },
  }
}
```

Two disadvantages of object factories are:
1. We cannot examine the resulting object in any way to determine if it was created by an object factory.
2. Each object created by the object factory will have its own copy of the common methods. This can lead to a lot of redundancy.


## [X] Determining/setting function execution context (this)

Why do we have function execution contexts?

JS functions are *first-class functions*, meaning they are objects that we can add to other objects, execute in context of other objects, remove from other objects, pass to other functions, etc.

Since first-class functions initially have no context, they receive one when we invoke them. 

Thus, we need a way as developers to control the execution context. 

### [X] Implicit function execution context

We use the implicit function execution context whenever we do *not* explicitly declare a function execution context.

A function's execution context is accessible through `this`. The execution context is determined by how the function is invoked, not by the location in which the function is defined. 

With *function invocations*, the implicit execution context - the value of `this` - is the global object (`window` in a browser). 

``` js
function hello(name) {
  console.log(`Hello ${name}. I am ${this}.`);
}

hello('Puppi'); // => Hello Puppi. I am [object Window].
```

With *method invocations*, the implicit execution context is the calling/owning object.

``` js
let puppi = {
  name: 'Puppi',
  bark() {
    console.log(`Woof! I'm ${this.name}!`);
  },
}

puppi.bark(); // => Woof! I'm Puppi!
```

### [X] Explicit function execution context

We can invoke functions with an explicit execution context using three methods:
- `call`: the first argument is the execution context; all arguments following are passed as arguments to the function being invoked
- `apply`: the first argument is the execution context; the second argument is an array of arguments passed to the function being invoked
- `bind`: this returns a new function that is permanently bound to the first argument as its execution context

``` js
let puppi = {
  name: 'Puppi',
  bark(other) {
    console.log(`Woof! I'm ${this.name}! You are ${other}!`);
  },
}

let barkIntro = puppi.bark;

barkIntro('Herc'); // => Woof! I'm undefined! You are Herc!
barkIntro.call(puppi, 'Herc'); // => Woof! I'm Puppi! You are Herc!
barkIntro.apply(puppi, ['Herc']); // => Woof! I'm Puppi! You are Herc!

let puppiBark = barkIntro.bind(puppi); 
puppiBark('Herc'); // => Woof! I'm Puppi! You are Herc!
```

### [X] Dealing with context loss

A function can lose it's context with these three common ways:

1. A method loses its context when it is pulled out of its object
2. An inner function within a method loses its method context
3. A function is passed in as an argument loses the surrounding context

``` js
let puppi = {
  name: 'Puppi',
  bark() {
    console.log(`Woof! I'm ${this.name}!`);
  },
}

// Context loss 1
let barkIntro = puppi.bark;
barkIntro(); // => Woof! I'm undefined!

// Context loss 2
puppi.bark = function() {
  function innerBark() {
    console.log(`Woof! I'm ${this.name}!`);
  }

  innerBark();
}

// Context loss 3
function barkThreeTimes(func) {
  func();
  func();
  func();
};
barkThreeTimes(puppi.bark);
```

We can remedy this context loss with the following solutions:

- Add an extra parameter `thisArg` to the function in which our function/method was passed/invoked

``` js
// Context loss 3 fixed!
function barkThreeTimes(func, thisArg) {
  func.call(thisArg);
  func.call(thisArg);
  func.call(thisArg);
};
barkThreeTimes(puppi.bark, puppi);
```

- Define a local variable `self` in lexical scope to reference `this`, and then use `self` within the function invocation 

``` js
// Context loss 2 fixed!
puppi.bark = function() {
  function innerBark() {
    let self = this;
    console.log(`Woof! I'm ${self.name}!`);
  }

  innerBark();
}
```

- Use `bind`, `call`, or `apply` to set an explicit execution context

``` js
// Context loss 1 fixed!
let barkIntro = puppi.bark;
barkIntro.apply(puppi); // => Woof! I'm Puppi!
```

- Use arrow functions (since they determine the value of `this` lexically)

``` js
let obj = {
  a: 'hello',
  b: 'world',
  foo() {
    [1, 2, 3].forEach((number) => {
      console.log(`${String(number)} ${this.a} ${this.b}` );
    })
  }
}
```

### [X] Lexical scope

JS uses lexical scoping to resolve variables. In other words, it uses the structure of the source code to determine the variable's scope. 

Lexical scoping rules do *not* apply to determining the value of `this`. 


## [X] Scope and Closures

### [X] Higher-order functions

Higher-order functions are functions that:
- take other functions as arguments
- return another functions
- do both

### [X] Creating and using private data

We can create private data using JS closures. Closures "close over" or "enclose" any artifacts - variables, function names, pieces of code - that it needs to execute properly. 

When a closure closes over some local variable and it is the only reference to that variable, the variable becomes inaccessible anywhere else other than from inside the closure.

We can create private data by returning an object that holds the interface to interact with our private data. 
``` js
let inventory = function () {
  const inventory = [];

  return {
    addItem(item) {
      if (!inventory.includes(item)) {
        inventory.push(item);
      }
    },

    removeItem(item) {
      let idx = inventory.indexOf(item);
      if (idx !== -1) {
        inventory.splice(idx, 1);
      }
    },
  }
}
```

We can also return a function that closes over the private data.
``` js
function makeCounter() {
  let counter = 0;

  return function incrementCount() {
    counter += 1;
    console.log(counter);
  }
}
```

We can also create private data with an immediately invoked function expression.
``` js
let generateStudentId = (function() {
  let studentId = 0;

  return function() {
    studentId += 1;
    return studentId;
  }
})();
```

### [X] Garbage collection

Garbage collection is the process of deallocating memory. Within JS, this process happens automatically.

A value is only eligible for garbage collection when they are no longer accessible from anywhere in the code. 

This means that values enclosed within a closure are not eligible for garbage collection.

### [X] IIFEs

Immediately invoked function expressions are functions that we immediately invoke after defining. 

``` js
(function invokeMe() {
  let universe = 42;
  console.log('I have been invoked! The universe is ' + universe);
  return 42;
})();
```

They can create a *private scope* within a larger program. Therefore, the `universe` variable in the IIFE above is contained within the scope of the `invokeMe` function. Furthermore, since the function is immediately invoked and returns a value, the name `invokeMe` exists within the scope of the IIFE too. 

IIFEs can also be used to create *private data*. See the `studentId` example above. 

### [X] Partial Function Application

Closures let us build useful tools that provide more flexible ways to invoke functions. For example, we have these partial function applications.

A function `makeGreeter` creates a new function (anonymous on creation) to call a third function `greet`. However, the `makeGreeter` function receives part of the arguments for `greet` and *applies* them before returning the anonymous function. 

``` js
function greet(greeting, name) {
  console.log(`${greeting}, ${name}!`);
}

function makeGreeter(greeting) {
  return function (name) {
    greet(greeting, name);
  }
}

const englishGreet = makeGreeter('Hello');
englishGreet('Puppi');

const chineseGreet = makeGreeter('Ni hao');
chineseGreet('Andrew');
```

This behaviour is made possible by closures. When a new function is created, it retains access to all of the references visible in the lexical location of its creation. 


## [ ] Object creation patterns

### [ ] Constructor functions

Constructor functions are normal functions that are created with the intention of being invoked with the `new` keyword.

``` js
function Dog(name, age) {
  this.name = name;
  this.age = age;
}

let puppi = new Dog('Puppi', 8);
```
They allow us to define the same properties for objects of a kind, while assigning different states to each individual object. For example, here we have the `name` and `age` properties common to all objects created by `Dog`, but the value these properties hold are unique to the object instance.

Constructor functions have a property called `prototype` that references the prototype object all instances will delegate to. 

On the flip side, this object referenced by `prototype` has a property `constructor` that references the constructor function itself. 

In the case above we'd have:
``` js
console.log(Dog.prototype);
// Returns an object with a constructor attribute with a function value
// {constructor: f}

console.log(Dog.prototype.constructor);
// returns the Dog constructor we defined above
// ƒ Dog(name, age) {
//  this.name = name;
//  this.age = age;
// }
```

### [ ] Prototype objects

Every *object* has a hidden `[[prototype]]` property. This property points to that object's prototype object. This property and the deprecated `__proto__` (dunder proto) both refer to the object's prototype.

Every *function* has a hidden `prototype` property. With a constructor function, the `prototype` property points to the prototype object which all objects created from this constructor will have as their prototype. 

All objects have a prototype object -- if it's not one that we set, then it is `Object.prototype` (or `Function.prototype` in the case of functions).

### [ ] Behavior delegation

We can use the *prototypal chain* to allow objects down the chain to delegate behaviours to objects up the chain.

For example, we have the prototypal chain `Animal` -> `Pet` -> `Dog`. Since all `Animal`s eat, we can define a method `Animal.eat()`. With behaviour delegation through the prototypal chain, we can invoke `Dog.eat()` with no error. JS will search the `Dog` object for an `eat` method. If none exists, it will search every object up the chain -- `Pet` and then `Animal` -- until it find the `eat` method. 

### [X] OLOO and Pseudo-Classical patterns

#### Pseudo-Classical pattern

``` js
function Pet(name) {
  this.loved = true;
}

Pet.prototype.giveLove = function () {
  console.log('Petting the pet! So much love <3');
}

function Dog(name, age, breed) {
  Dog.call(this, name);
  this.age = age;
  this.breed = breed;
}

Dog.prototype = Object.create(Pet.prototype);
Dog.prototype.constructor = Dog;

Dog.prototype.greet = function () {
  console.log(`Woof! I'm ${this.name}!`);
};

Dog.prototype.dig = function () {
  console.log('Digging dig dig~');
};

const puppi = new Dog('Puppi', 8);
console.log(puppi.name); // => Puppi
puppi.greet(); // => Woof! I'm Puppi!
puppi.giveLove(); // => Petting the pet! So much love <3
```

- use `Function.prototype.call` to have the subclass "inherit" properties from the parent class
- use `Function.prototype = Object.create(obj)` to "inherit" methods from the parent class
- use `Function.prototype.constructor` to manually reset the property to point back to the appropriate constructor


#### OLOO

``` js
const Pet = {
  loved: true,

  giveLove() {
    console.log('Petting the pet! So much love <3');
  },
};

const Dog = Object.create(Pet);
Dog.init = function (name, age) {
  this.name = name;
  this.age = age;
  return this;
};
Dog.greet = function () {
  console.log(`Woof! I'm ${this.name}!`);
};

Dog.dig = function () {
  console.log('Digging dig dig~');
};

const puppi = Object.create(Dog).init('Puppi', 8);
console.log(puppi.name); // => Puppi
puppi.greet(); // => Woof! I'm Puppi!
puppi.giveLove(); // => Petting the pet! So much love <3
```

