## Introduction

**Why do function execution context rules exist?**

JavaScript has **first-class functions**, meaning the developer can:
- add them to objects, 
- execute them in the context of those objects, 
- remove them from their objects, 
- pass them to other functions, 
- and run them in entirely different contexts

First class Functions initially have no context -- they receive one when the program executes them. 

Since JS is both an object-oriented language and a language with first-class functions, we need a way to meet the requirements for both.

In the case of first-class functions, we need a way (as developers) to control the execution context.


## Prerequisites

Understanding JS strict mode: https://launchschool.com/gists/406ba491

See gists.md for notes.


## The Global Object

When JS starts running, it creates a **global object**. This global object serves as the *implicit execution context*. 

In a browser, it's the `window` global object. Note: there's a section below about browser vs. node.

Global values (ex: `Infinity` and `NaN`) and global fuctions (ex: `parseInt`) are properties of the global object.

### Global Object as Implicit Context

When we evaluate expressions, the global object is the implicit context:

``` js
foo = 1;
foo; // 1
```

In the code above, `foo` is assigned as a property on the global object with a value of `1`. 

JS gives `foo` an implicit evaluation context of the global object, thus making `foo = 1` equivalent to `window.foo = 1`.

Note: we don't *declare* a global variable (since we don't use any keywords `let`, `var` or `const`). This is important to note, as discussed in the section below.

### Global Variables and Function Declarations

When we declare global variables with `var` or functions, JS adds the to the global object as properties. We can see this by examining the `window` object.

Note below that `evenMoreFoo` declared with `let` is *not* added to the global `window` object.

``` js
foo = 1;
var moreFoo = 3;
let evenMoreFoo = 42;

function bar() {
  return 7;
}

console.log(window.foo);           // 1
console.log(window.moreFoo);       // 3
console.log(window.evenMoreFoo);   // undefined
console.log(window.bar);           // function bar() { return 1; }

delete window.foo;         // deleted
delete window.moreFoo;     // not deleted
delete window.bar;         // not deleted

console.log(window.foo);       // undefined
console.log(Object.hasOwnProperty(window, "foo")); // false
console.log(window.moreFoo);   // 3
console.log(window.bar());     // 7
```

**Important Note**: We can delete global variables we *don't* declare, but we cannot delete those that we do declare.

### Strict Mode and The Global Object

In strict mode, we don't have access to the global object as the implicit context. This:
- prevents access to variables that have not been previously declared
- guards against misspellings creating new global properties

### Browsers vs. Node

- In browser, the global object is the `window` object. 
- In node, the global object is the `global` object.

- In node, there's also an additional "module" scope. 
  - variables in the module scope are those declared at the top level of a node.js file
    - thus, these variables are not added to the global object
  - module-scoped variables are only accessible from within the file

Still fuzzy on the node sidenote...


## Implicit and Explicit Function Execution Contexts

### Function Execution Context 

Every time a JS function is invoked, it has access to an object called the **execution context** of that function. The execution context is accessible through the keyword `this`. 

Execution context of a function changes based on how the function is invoked.

Two types of execution contexts:
- Implicit: execution context JS implicitly sets
- Explicit: execution context that we explicitly set

**`this` Binding.**

The rules to determine `this` binding are *entirely* different from the rules that determine the scope of the variable. *Do not apply lexical scoping rules*. `this` gets bound based on how a function is invoked.

### Implicit Function Execution Context

The implicit *function* execution context (a.k.a. implicit binding for functions) is the context for a function that you invoke without supplying an explicit context. 

*JavaScript binds such functions to the global object.*

``` js
let object = {
  foo() {
    return 'this here is: ' + this;
  },
};

object.foo();             // "this here is: [object Object]"

let bar = object.foo;
bar();                    // "this here is: [object Window]"
```

The code example above demonstrates that binding a function to a context object occurs *when you execute the function, not when you define it.*

Note that in strict mode, `this` in the global scope is `undefined`.

### Implicit Method Execution Context

The implicit *method* execution context is the execution context for any method (i.e. function referenced as an object property) invoked without an explicit context provided. 

*JavaScript implicitly binds methods invoked in this manner to the owning/calling object.* `this` is the value of the calling object when the method is invoked.

``` js
let foo = {
  bar() {
    return this;
  },
};

foo.bar() === foo; // true

let baz = foo.bar;

baz() === foo;    // false
baz() === window; // true
```

Above, we see the implicit binding of `this` to the object `foo` when we invoke `foo.bar()`. 

However, the last two comparison statements show that implicit execution context is bound upon invocation. We assign the Function `bar` to the variable `baz`. Then we execute the function `baz` in the global context, where `this` is the `window` object.

### Explicit Function Execution Context

Methods `call` and `apply` allow us to explicitly bind a function's execution context to an object during invocation.

``` js
let a = 1;

let object = {
  a: 'hello',
  b: 'world',
};

function foo() {
  return this.a;
}

foo();                  // 1 (context is global object)
foo.call(object);       // "hello" (context is object)
```

The Function methods `call` and `apply` can pass arguments to the function. 

``` js
let iPad = {
  name: 'iPad',
  price: 400,
};

let kindle = {
  name: 'kindle',
  price: 300,
};

function printLine(lineNumber, punctuation) {
  console.log(lineNumber + ': ' + this.name + ', ' + this.price + ' dollars' + punctuation);
}

printLine.call(iPad, 1, ';');        
// => 1: iPad, 400 dollars;
printLine.apply(kindle, [2, '!']);
// => 2: kindle, 300 dollars!
```

This little mnemonic can help remember how to pass arguments in:
- `call`: Count the Commas 
  - (count the number of args to match called function)
- `apply`: Argument as Array


## Hard Binding Functions with Contexts

JavaScript has a `bind` method that lets us bind a function to a context object permanently. 

``` js
let object = {
  a: 'hello',
  b: 'world',
  foo() {
    return this.a + ' ' + this.b;
  },
};

let bar = object.foo;
bar();                                // "undefined undefined"

let baz = object.foo.bind(object);
baz();                                // "hello world"

let object2 = {
  a: 'hi',
  b: 'there',
};

baz.call(object2);  // "hello world" - `this` is still `object`
```

Unlike `call` or `apply`, `bind` does *not* execute the function. Instead, it **creates and returns a new Function** and **permanently binds the new Function to a given object**. 

Since the binding is permanent, we can pass the function around without concern that its context will change. It won't. Not even with an explicitly declared execution context:

``` js
let obj = {
  a: 'Amazebulous!',
};

let otherObj = {
  a: "That's not a real word!",
};

function foo() {
  console.log(this.a);
}

let bar = foo.bind(obj);
bar.call(otherObj); // Amazebulous!
```

**Note**: `bind` can't be called on a function declaration, but can be called on a function expression.


## Example: Changing Function Context

Worthy of reviewing if confused about:
- use of `call`, `apply`, or `bind`
- want examples of assigning functions to variables or objects

## Dealing with Context Loss Summary

Three ways a function can lose its context:
1. Method losing context when it's taken out of an object
2. Internal function losing method context
3. Function as argument losing surrounding context

Ways to fix context loss:

Loss 1:
- add an extra parameter to the function in which our function/method was passed
  - this extra parameter accepts an object and sets the execution context to the object

- create a hard binding to the function with `bind`

Loss 2: 
- preserve context with a local variable in the lexical scope (`let self = this;`)

- pass context to internatl functions with `call` and `apply`

- bind the context with a function expression
  - use `bind` when we define the function to provide a permanent context to the function

Loss 3: 
- preserve context with a local variable in the lexical scope

- bind the argument function with the surrounding context (use `.bind(this)` at the end of the function expression)

- use an optional `thisArg` argument
  - Array methods `map`, `every`, `some`, and `forEach` take a `thisArg` argument

- use arrow functions for the callback


## Dealing with Context Loss (1) 

Goals of next 3 lessons:
- learn most common ways a function can lost its context
- learn how to preserve the context and avoid errors

**Method Losing Context When Taken Out of Object**

If you remove a method from its containing object and execute it, it loses its context.

A straight forward example of context loss:
``` js
let john = {
  firstName: 'John',
  lastName: 'Doe',
  greetings() {
    console.log('hello, ' + this.firstName + ' ' + this.lastName);
  },
};

let foo = john.greetings;
foo();
// => hello, undefined undefined
```

A more convoluted example of context loss (one that confused me initially):
``` js
function repeatThreeTimes(func) {
  func();       // can't do func.call(john), out of scope
  func();
  func();
}

function foo() {
  let john = {
    firstName: 'John',
    lastName: 'Doe',
    greetings() {
      console.log('hello, ' + this.firstName + ' ' + this.lastName);
    },
  };

  repeatThreeTimes(john.greetings); //
}

foo();
// => hello, undefined undefined
// => hello, undefined undefined
// => hello, undefined undefined
```

**Solutions to this context loss**

To reapply context, we can add an extra parameter to the function to pass in the desired context:

``` js
function repeatThreeTimes(func, context) {
  func.call(context);
  func.call(context);
  func.call(context);
}

// ... same code as above until...
// inside `foo` function - last line now says:
  repeatThreeTimes(john.greetings, john);
}

foo();
// hello, John Doe
// hello, John Doe
// hello, John Doe
```

Or we can create a **hard binding** with `bind`:

``` js
// ... same code as above until...
// inside `foo` function - last line now says:
  repeatThreeTimes(john.greetings.bind(john));
}
```


## Dealing with Context Loss (2)

**Internal Function Losing Method Context**

``` js
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

In the code example above, we see that `this` in the `bar` function invocation is the global object. 

Even though `foo` executes within the `obj` context, the call to `bar` does not provide an explicit context, which means that JavaScript binds the global object to the function. As a result, `this` is the global object, not `obj`.

*Key point: Unless a function invocation is explicitly given a context, JS implicitly sets the context of `this` within a function invocation to the global object.* It doesn't matter where the function invocation is located lexically. 

**Solutions to this context loss**

1. Preserve Context with a Local Variable in the Lexical Scope

Save `this` in a local variable named `self` or `that` before calling the function, then reference the variable in the function. 
``` js
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
};

obj.foo();
// => hello world
```

2. Pass the Context to Internal Functions

We can pass the context object to the function with `call` or `apply`.
``` js
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

obj.foo();
// => hello world
```

3. Bind the Context with a Function Expression

We can use `bind` when we define the function to provide a permanent context to `bar`. 

An advantage this offers: we can use `bind` once and call it as often as we'd like without explicitly providing context.
``` js
let obj = {
  a: 'hello',
  b: 'world',
  foo() {
    let bar = function() {
      console.log(this.a + ' ' + this.b);
    }.bind(this);

    bar();
    bar();
  }
}

obj.foo();
// => hello world
// => hello world
```


## Dealing with Context Loss (3)

**Function as Argument Losing Surrounding Context**

``` js
function repeatThreeTimes(func) {
  func();
  func();
  func();
}

let john = {
  firstName: 'John',
  lastName: 'Doe',
  greetings() {
    repeatThreeTimes(function() {
      console.log('hello, ' + this.firstName + ' ' + this.lastName);
    });
  },
};

john.greetings();

// => hello, undefined undefined
// => hello, undefined undefined
// => hello, undefined undefined
```

In this example, we call `repeatThreeTimes` with a function argument that contains this. `repeatThreeTimes` calls its argument three times, but each time it does so *without an explicit context*. As we've learned, this means the context is the global object. Thus, `this` inside the function is the global object, not `john`.

Another example:
``` js
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

**Solutions to this context loss**

1. Use a local variable in the lexical scope to store this
``` js
let obj = {
  a: 'hello',
  b: 'world',
  foo() {
    let self = this;
    [1, 2, 3].forEach(function(number) {
      console.log(String(number) + ' ' + self.a + ' ' + self.b);
    });
  },
};
```

2. Bind the argument function with the surrounding context
``` js
let obj = {
  a: 'hello',
  b: 'world',
  foo() {
    [1, 2, 3].forEach(function(number) {
      console.log(String(number) + ' ' + this.a + ' ' + this.b);
    }.bind(this));
  },
};
```

3. Use the optional `thisArg` argument

Some methods that take function arguments allow an optional argument that defines the context to use when executing the function. This argument makes it easy to work around this context loss problem.
``` js
let obj = {
  a: 'hello',
  b: 'world',
  foo() {
    [1, 2, 3].forEach(function(number) {
      console.log(String(number) + ' ' + this.a + ' ' + this.b);
    }, this);
  },
};
```

4. Use an arrow function for the callback

*Arrow functions don't have a `this` binding.* Instead of `this` being dependent on the location of the function invocation, JS resolves it by looking at the enclosing scopes.

``` js
let obj = {
  a: 'hello',
  b: 'world',
  foo() {
    [1, 2, 3].forEach((number) => {
      console.log(String(number) + ' ' + this.a + ' ' + this.b);
    });
  },
};
```
`this` resolves to `obj` which is the immediately enclosing scope.


## Summary

*Summary reading*: https://web.archive.org/web/20180209163541/https://dmitripavlutin.com/gentle-explanation-of-this-in-javascript/


- Function invocations (e.g., `parseInt(numberString)`) rely upon implicit execution context that resolves to the global object. 
- Method invocations (e.g., `array.forEach(processElement)`) rely upon implicit context that resolves to the object that holds the method.

- All JavaScript code executes within a context. The top-level context in a web browser is the `window` object. All global methods and Objects (such as `parseInt` or `Math`) are properties of this object. 
- In Node, the top-level context is called `global`. However, be aware that Node has some peculiarities that cause it to behave differently from browsers.

- You can't use `delete` to delete variables and functions declared at the global scope:

- `this` is the current execution context of a function.

- The value of `this` changes based on how you invoke a function, not how you define it.

- In strict mode, `this` inside functions resolve to `undefined` when referring to the global execution context.

- JavaScript has first-class functions which have the following characteristics:
  - You can add them to objects and execute them in the respective object's contexts.
  - You can remove them from their objects, pass them around, and execute them in entirely different contexts.
  - They're initially unbound, but dynamically bound to a context object at execution time.

- `call` and `apply` invoke a function with an explicit execution context.

- `bind` permanently binds a function to a context and returns a new function

- Method invocations can operate on the data of the owning object




