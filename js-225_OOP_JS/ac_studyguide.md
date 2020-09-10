# Assessment JS225
## Objects

- [x] **Organizing code into appropriate objects**

  - Objects prevent the application from becoming 1 giant dependency blob

  - Organize related data and code together

  - Useful when a program needs more than one instance of something

  - Becomes more useful as the codebase size increases

- [x] **Object factories**

  - Object factories are functions that create & return objects

    ```js
      const createPerson = (firstName, lastName = '') => {
        return {
          firstName,
          lastName,
          fullName() {
            return (this.firstName + ' ' + this.lastName).trim();
          },
        };
      }
    ```

  - Reduces duplicate code

  - Disadvantages include:

    - Each object created by the factory function owns the same methods, which can be redundant.

    - There is no way to tell whether an object was created by any given function.

## Determining/setting function execution context (this)

- [x] **Implicit function execution context**

  - This is an execution context that JavaScript *implicitly* sets

  - Implicitly binds methods invoked in this manner to the owning or calling object

    ```js
      let foo = {
        bar() {
          return this;
        },
      };

      let baz = foo.bar;

      baz() === foo;     // false
      foo.bar() === foo; // true
      baz() === window;  // true
    ```

- [x] **Explicit function execution context**

  - This is an execution context that you *explicitly* set

    - `call` or `apply` can change a function's execution context at execution time

      ```js
        let strings = {
          a: 'hello',
          b: 'world',
          foo() {
            return this.a + this.b;
          },
        };

        let numbers = {
          a: 1,
          b: 2,
        };

        strings.foo.call(numbers); // 3
      ```

      - `call` can also pass arguments to the function:
        
        `someObject.someMethod.call(context, arg1, arg2, arg3, ...)`

      - `apply` method is identical to `call`, except that it uses an array to pass arguments:

        `someObject.someMethod.apply(context, [arg1, arg2, arg3, ...])`

      - Call: Count the Commas (you have to count the number of arguments to match the called function)

      - Apply: Arguments as Array

- [x] **Dealing with context loss**

    **Method Losing Context when Taken Out of Object**

    ```js
      let greeting = obj.greeting
    ```

    - Pass the context to a helper function

      ```js
        function repeatThreeTimes(func, context) {
          func.call(context);
          func.call(context);
          func.call(context);
        }
      ```

    - Bind the context to the object

      ```js
        repeatThreeTimes(john.greetings.bind(john))
      ```

  **Internal Function Losing Method Context**

    ```js
      let obj = {
        a: 'hello',
        b: 'world',
        foo() {
          function bar() {
            console.log(this.a + ' ' + this.b);
          }

          bar();
        },
      };

      obj.foo();        // => undefined undefined
    ```

    - Solutions:

      - Preserve Context with a Local Variable in the Lexical Scope

        ```js
          let obj = {
            a: 'hello',
            b: 'world',
            foo() {
              let self = this;

              function bar() {
                console.log(self.a + ' ' + self.b);
              }

              bar();
            }
          }
        ```

      - Pass the Context to Internal Functions

        ```js
          let obj = {
            a: 'hello',
            b: 'world',
            foo() {
              function bar() {
                console.log(this.a + ' ' + this.b);
              }

              bar.call(this);
            }
          };
        ```
      
      - Bind the Context with a Function Expression

        ```js
          let obj = {
            a: 'hello',
            b: 'world',
            foo() {
              let bar = function() {
                console.log(this.a + ' ' + this.b);
              }.bind(this);

              bar();
            }
          };
        ```

  **Function as Argument Losing Surrounding Context**

    ```js
      let obj = {
        a: 'hello',
        b: 'world',
        foo() {
          [1, 2, 3].forEach(function(number) {
            console.log(String(number) + ' ' + this.a + ' ' + this.b);
          });
        },
      };

      obj.foo();

      // => 1 undefined undefined
      // => 2 undefined undefined
      // => 3 undefined undefined
    ```

    - Solutions:

      - Use a local variable in the lexical scope to store this

        ```js
          let self = this;

          foo() {
            [1, 2, 3].forEach(function(number) {
              console.log(String(number) + ' ' + self.a + ' ' + self.b);
            });
          }
        ```

      - Bind the argument function with the surrounding context

        ```js
          foo() {
            [1, 2, 3].forEach(function(number) {
              console.log(String(number) + ' ' + this.a + ' ' + this.b);
            }.bind(this));
          }
        ```
      
      - Use the optional thisArg argument

        ```js
          foo() {
            [1, 2, 3].forEach(function(number) {
              console.log(String(number) + ' ' + this.a + ' ' + this.b);
            }, this);
          }
        ```
      
      - Use arrow function for the callback. Arrow functions do not have a `this` binding. Instead of this being dependent on the location of the function invocation, JavaScript resolves it by looking at the enclosing scopes.

        ```js
          foo() {
            [1, 2, 3].forEach((number) => {
              console.log(String(number) + ' ' + this.a + ' ' + this.b);
            });
          }
        ```

## Scope and Closures

- [x] **Creating and using private data**

  - Functions at their definition point *enclose* the context which makes them **closures**

    ```js
      function makeCounter() {
        let count = 0;       // `count` is private data that will not be accessible
        return function() {
          count += 1;        // references count from the outer scope
          console.log(count);
        };
      }
    ```

- [x] **Garbage collection**

  - Values are allocated memory

  - The process of "automatically" freeing memory up is called garbage-collection

  - This occurrs when there are no variables, objects, or closures that maintain a reference to the object or value

    ```js
      function logName() {
        let name = 'Sarah'; // Declare a variable and set its value. The JavaScript
                            // runtime automatically allocates the memory.
        console.log(name);  // Do something with name
        return name;        // Returns "Sarah" to caller
      }

      let loggedName = logName(); // loggedName variable is assigned the value "Sarah"
                                  // the "Sarah" assigned to `loggedName` is NOT eligible for GC
                                  // the "Sarah" assigned to `name` IS eligible for GC
    ```
  
  - Theoretically, as long as a closure exists, those variables referenced by the closure remain in memory

- [ ] **IIFEs**

  - Immediately Invoked Function Expressions are functions that we define and invoke simultaneously

    ```js
      (function(a) {
        return a + 1;
      })(2);

      let foo = function() {
        return 10
      }() // 10
    ```

  - Because functions create a private scope, IIFE's are great when working in large, poorly maintain code bases. Your variables may clash with other globally scope variables. This is why the new scope is recommended

- [ ] **Partial Function Application**

  - Partial function application uses a function that creates a new function to call a third function that the generator receives as an argument

    ```js
      function primaryFunction(arg1, arg2) {
        console.log(arg1);
        console.log(arg2);
      }

      function generatorFunction(primary, arg1) {
        return function(arg2) { // applicator
          return primary(arg1, arg2);
        }
      }

      let applicatorFunction = generatorFunction(primaryFunction, 'Hello');
      applicatorFunction(37.2);   // Performs primaryFunction('Hello', 37.2);
      // => Hello
      // => 37.2
    ```

## Object creation patterns

- [x] **Constructor functions**

  - Intended to be called with the `new` operator

    ```js
      // constructor function
      function Person(firstName, lastName = '') { // constructor functions are capitalized
        this.firstName = firstName;
        this.lastName = lastName;
        this.fullName = function() {
          return (this.firstName + ' ' + this.lastName).trim();
        };
      }

      let john = new Person('John', 'Doe');
      let jane = new Person('Jane');

      john.constructor;             // function Person(..)
      jane.constructor;             // function Person(..)

      john instanceof Person;       // true
      jane instanceof Person;       // true
    ```

  - `new` operator

    - A new object is created

    - `this` represents the newly created object

    - The code in the function is executed

    - `this` is returned if the constructor doesn't explicitly return an object

  - Invoking constructor functions without `new` results in `this` being the global object

- [x] **Prototype objects**

  - Every object has a `__proto__` property

    - "dunder proto" or "double underscore"

    - points to a different object

    - When we use the `Object.create` method to create an object, it sets the __proto__ property of the created object to the object passed in:

      ```js
        let foo = {
          a: 1,
          b: 2,
        };

        let bar = Object.create(foo);
        bar.__proto__ === foo;    // true
        // foo is the prototype object
      ```

  - `Object.getPrototypeOf(obj)` to get the prototype object of `obj`
    
  - `obj.isPrototypeOf(foo)` to check if `obj` is a prototype object of `foo`

  - `Object.create` can be used for prototype chains with `Object.prototype` being the prototype of the original object (foo)

    ```js
      let foo = {
        a: 1,
        b: 2,
      };

      let bar = Object.create(foo);
      let baz = Object.create(bar);
      let qux = Object.create(baz);

      Object.getPrototypeOf(qux) === baz;       // true
      Object.getPrototypeOf(baz) === bar;       // true
      Object.getPrototypeOf(bar) === foo;       // true

      foo.isPrototypeOf(qux);                   // true - because foo is on qux's prototype chain
    ```

- [x] **Behavior delegation**

  - Objects can be created directly from other objects and behaviors (methods) can be shared via the prototype chain

    ```js
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
    ```
  
  - **Behavior Delegation**

    - Objects on the bottom of the prototype chain can "delegate" requests to the upstream objects to be handled

    - `hasOwnProperty` tests if a property is defined on the object itself

    - `getOwnPropertyNames` returns an array of an object's own property names

    - Objects can override default behaviors by reassigning the behavior to a new function

  - It doesn’t matter if properties are added to an object’s prototype chain after the object has been created - the inheriting object will look for methods at execution

    ```js
      var animal = {}
      var dog = Object.create(animal);
      var terrier = Object.create(dog);

      dog.speak = function() { 
        console.log("Woof Woof"); 
      };

      terrier.speak(); // "Woof Woof"
    ``` 

- [x] **OLOO and Pseudo-Classical patterns**

  - **OLOO (Objects Linking to Other Objects)**

    - Define the shared behaviors on a prototype object, then use Object.create to create objects that delegate directly from that object

    ```js
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
    ```

  - **Pseudo-Classical**

    - Combination of the constructor pattern and the prototype pattern

    ```js
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
    ```

## Prerequisites

- [x] **let & const**

  - `let`

    - Allows variables to be reassigned

  - `const`

    - Cannot be reassigned, only mutated (properties of an object or elements of an array)

  - `let` & `const`

    - Are not hoisted

      - Technically, they are hoisted but not initialized so they behave as if they are not hoisted

    - Block-scoped instead of `var` which is function-scoped

      ```js
        // { } defined a new block
        if (something) {
          // Block 1
        } else {
          // beginning of Block 2
          while {
            // Block 3 (this block is nested inside of block 2)
          } // end of Block 2
        }
      ```

- [x] **Arrow Functions**

  - Type of anonymous function

  - Determine the value of `this` lexically instead of using the invocation syntax

  - Recommended to use primarily for callback functions

    - Should not use arrow functions as callbacks when the invoking function may set the value of this

  ```js
    // ES5
    var multiplyES5 = function(x, y) {
      return x * y;
    };

    // ES6
    const multiplyES6 = (x, y) => x * y // return & { } aren't neccessary when arrow functions are 1 liners
    const multiplyByTenES6 = x => x * 10 // () aren't neccessary when only 1 parameter is declared
  ```

- [x] **Concise Property & Concise Method Syntax**

  - Syntaxical sugar

    ```js
      // ES5
      function foo(bar) {
        return {
          bar: bar,
          qux: function() {
            console.log("hello");
          },
        };
      }

      // ES6
      function foo(bar) {
        return {
          bar,                      // same as bar: bar - Concise Property Syntax
          qux() {                   // same as qux: function() - Concise Method Syntax
            console.log("hello");
          },
        };
      }
    ```

- [x] **Strict Mode**

  - Use strict mode in any new code that you write

  - Eliminates some silent errors that occur in sloppy mode by changing them so that they throw errors instead

  - Prevents some code that can inhibit JavaScript's ability to optimize a program so that it runs faster

  - Prohibits using names and syntax that may conflict with future versions of JavaScript

  - How to enable: Add `"use strict"` to the top of a file

  - `this` in the global scope is `undefined`

  - Does not allow assigning variables that are not declared

    - Js will make a global variable for undeclared variables in sloppy mode

    ```js
      "use strict";

      function foo() {
        bar = 3.1415; // ReferenceError: bar is not defined
      }

      foo();
    ```

  - Using function call syntax on a method sets this to undefined

    ```js
      "use strict";

      let obj = {
        a: 5,
        go() {
          this.a = 42; // TypeError: Cannot set property 'a' of undefined
        },
      };

      let doIt = obj.go;
      doIt();
    ```

  - Lexically scoped

    ```js
      function foo() {
        "use strict";
        // All code here runs in strict mode
      }

      function bar() {
        // All code here runs in sloppy mode
        foo(); // This invocation is sloppy mode, but `foo` runs in strict mode
        // All code here runs in sloppy mode
      }
    ```

- [x] **Class Syntactic Sugar**

  - Es6 introduced the `class` keyword

  - Syntactic sugar that wraps around one of the object creation patterns 

  - All methods defined within the class definition, with the exception of `constructor`, are defined on the prototype object. In this case, on Point.prototype

  - **Caveats**

    - All code in `class` executes in strict mode

    - Class declarations are not hoisted. Instaniating an object above the class declaration will result in a ReferenceError

    - Invoking a class constructor without the keyword `new` will result in an error

    ```js
      // Es5 Pseduo-classical pattern
      function Point(x = 0, y = 0) {
        this.x = x;
        this.y = y;
      };

      Point.prototype.onXAxis = function() {
        return this.y === 0;
      };

      Point.prototype.onYAxis = function() {
        return this.x === 0;
      };

      Point.prototype.distanceToOrigin = function() {
        return Math.sqrt((this.x * this.x) + (this.y * this.y));
      };

      // Es6 class syntacial sugar
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
    ```

- [x] **Object Destructuring**

  ```js
    let obj = {
      foo: "foo",
      bar: "bar",
      qux: 42,
    };

    // ES5
    let foo = obj.foo;
    let bar = obj.bar;
    let qux = obj.qux;

    // ES6 
    let { foo, bar, qux } = obj;
  ```

- [x] **Array Destructuring**

  ```js
    let foo = [1, 2, 3];
    // ES5
    let first = foo[0];
    let second = foo[1];
    let third = foo[2];
    // ES6
    let [ first, second, third ] = foo;

    let bar = [1, 2, 3, 4, 5, 6, 7];
    let [ first, , , fourth, fifth, , seventh ] = bar;
  ```