# Functions And Variable Scope

## Defining Functions

As we often need to execute a piece of code repeatedly, programming languages let us build constructs called *procedures*. 

Procedures let us extract the common code to one place and use the code from anywhere else in the program. We use the term **functions** to refer to procedures in JS. 

*Return values*: A function that does not contain an explicit `return` statement with a value will implicitly return the value `undefined`. 

### Parameters vs. Arguments

``` js
function multiply(a, b) {
  return a * b;
}
```
The function `multiply` takes two *parameters*, `a` and `b`. The actual values passed to a function during execution are its *arguments*. 

In other words: 
- when *defining a function* we use *parameters*
- when *invoking a function* we use *arguments*


## Function Invocations and Arguments

The standard way to invoke a function is to append `()` to its name: `startle();`.

Function names are local variables that happen to have a function as a value. So we can assign the function to a new local variable:

``` js
function startle() {
  console.log('Yikes!');
}

let surprise = startle;
surprise();

// logs:
Yikes!
```

We can pass in fewer or more arguments to a function and no error will be raised. See example and comments below.

``` js
function takeTwo(a, b) {
  console.log(a);
  console.log(b);
  console.log(a + b);
}

// Fewer arguments:
takeTwo(1);
// logs:
1
undefined // An argument that isn't provided in the function call will have the value `undefined`
NaN

// More arguments
takeTwo(1, 2, 4);
// logs:
1
2
3
```


## Nested Functions

You can nest functions inside other functions:
``` js
function circumference(radius) {
  function double(number) {      // nested function declaration
    return 2 * number;
  }

  return 3.14 * double(radius);  // call the nested function
}
```
There's no hard limit of how deep you can nest functions and this is a source of enormous expressive power for JavaScript.


## Functional Scopes and Lexical Scoping

A variable's scope is the part of the program that can access that variable by name. Variable scoping rules describe how and where the language finds and retrieves values from previously declared variables.

### The Global Scope

### Function Scope

The code within an inner scope can access any variables in the same scope or any surrounding scope. 

### Closures

When we define a function, it retains access to (or closes over) the variable scope currently in effect. We call this *creating a closure*. 

A closure retains references to everything that is in scope when the closure is created, and retains those references for as long as the closure exists. 

### Lexical Scoping

JS uses *lexical scoping* (a.k.a. static scoping) to resolve variables. In other words, it uses the structure of the source code to determine the variable's scope. **The source code defines the scope.** 

When JS tries to find a variable, it searches the scope hiearchy from local scope up to the global scope. 

### Adding Variables to the Current Scope

To create a variable in the current scope:
- use the `let` or `const` keywords
- use the `var` keyword
- define parameters for a function - each parameter is a local variable
- a function declaration creates a variable with the same name as the function
- a class declaration creates a variable with the same name as the class

### Variable Assignment

Variable scoping rules apply to both assignment and referencing. 

``` js
country = 'Australia';
```

The code above checks the current scope and all higher scopes looking for a variable with the name `country`. JS sets the first `country` variable it finds to `"Australia"`.

If no matching variable is found, it creates a new global variable instead. This is often a source of bugs. 

### Variable Shadowing

Variables in the inner scope shadows those in outer scopes (closer to global).

### Important Variable Scoping Rules

- every function declaration creates a new variable scope
- lexical scope uses the structure of the source code to determine the variable's scope. (So code doesn't have to be executed for the scope to exist.)
- All variables in the same or surrounding scopes are available to your code


## Function Declarations and Function Expressions

### Function Declarations

A function declaration (a.k.a. function statement) defines a variable whotes type is `function`. The value of of the function variable is the function itself. 

``` js
function hello() {
  return 'hello world!';
}

console.log(typeof hello);    // function
```

Note: function declaration creates both a function and a variable. 

### Function Expressions

A function expression defines a function as part of a larger expression syntax (usually a variable assignment).

``` js
const hello = function () {   // We can also use let instead of const
  return 'hello';
};

console.log(typeof hello);    // function
console.log(hello());         // hello
```

Another example:
``` js
let foo = function () {
  return function () {   // function expression as return value
    return 1;
  };
};

let bar = foo();         // bar is assigned to the returned function

bar();                   // 1
```

Here, the anonymous function assigned to `foo` returns another anonymous function. On line 7, we call `foo` and assign the returned function expression to the variable `bar`. We can then call `bar` to get the return value `1` of the anonymous function.

### Named Function Expressions

We can also name function expressions. However, the name is only available inside the function's local scope.

``` js
let hello = function foo() {
  console.log(typeof foo);   // function
};

hello();

foo();                       // Uncaught ReferenceError: foo is not defined
```

Naming function expressions is useful for debugging. The debugger can show the function's name in the call stack. 

### Arrow Functions

Addition to ES6 JS. Arrow functions are like a shorthand way to write a function expression.

``` js
const multiply = (a, b) => {
  return a * b;
};

// rewritten even shorter
const multiply = (a, b) => a * b;
```

Arrow functions are most often used as **callback functions**. 

``` js
[1, 2, 3].map(function (element) {
  return 2 * element;
}); // returns [2, 4, 6]

// rewritten with arrow function
[1, 2, 3].map((element) => 2 * element); // returns [2, 4, 6]
```

Arrow functions also inherit the "execution context" from the surrounding code. This will mean something later...

### Style Notes

- use arrow functions for callbacks
- use function declarations or function expressions for other functions, but choose one as the primary choice
- if you use function expressions, name function expressions for debugging purposes


## Hoisting

### What Is Hoisting?

Hoisting effectively moves the **variable declarations** to the *top of the scope*. 

In JS, variable declarations are processed before any code is executed. So all variables defined in a particular scope are known throughout that whole scope.

``` js
console.log(a);  // Will this code execute? What will it log?
var a = 123;
var b = 456;

// With hoisting, above is equivalent to below:
var a;           // hoisted to the top of the scope
var b;

console.log(a);  // logs `undefined`
a = 123;
b = 456;
```

**Note**: JS only hoists variable declarations, *not initializations*. 

### The Temporal Dead Zone

Variables declared with `let` and `const` are also hoisted, but, instead of initializing them to `undefined` as with `var` variables, JavaScript leaves them in an "unset" state. If you try to access a variable in this unset state, you'll receive an error:
``` js
console.log(foo); // Uncaught ReferenceError: Cannot access 'foo' before initialization
let foo;
```

Such unset variables are said to be in the **Temporal Dead Zone (TDZ)**. 

The error message is different from a variable we have not declared:
`console.log(foo); Uncaught ReferenceError: foo is not defined`

### Hoisting for Function Declarations

JS hoists the entire function declaration, including the body.
``` js
console.log(hello());

function hello() {
  return 'hello world';
}

// equivalent with hoisting to:
function hello() {
  return 'hello world';
}

console.log(hello());      // logs "hello world"
```

**Note**: There are strange, undefined behaviours when function hoisting *a function that is nested inside a non-function block*.

### Hoisting for Function Expressions

Since function expressions are just variable declarations, they obey the hoisting rules for variable declarations. 

``` js
console.log(hello());

var hello = function () {
  return 'hello world';
};

// the above is equivalent to the below with hoisting
var hello;

console.log(hello());    // raises "Uncaught TypeError: hello is not a function"

hello = function () {
  return 'hello world';
};
```

### Hoisting Variable and Function Declarations

Function declarations are hoisted first before variable declarations.

``` js
bar();              // logs undefined
var foo = 'hello';

function bar() {
  console.log(foo);
}

// The equivalent with hoisting
function bar() {
  console.log(foo);
}

var foo;

bar();          // logs undefined
foo = 'hello';
```

### Best Practices to Avoid Confusion

- Whenever possible, use `let` or `const` instead of `var`
- If you must use `var`, declare all of the variables at the top of the scope
- If you can use `let` and `const`, declare them as close to their first usage as possible
- Declare functions before calling them


## Additional Notes

- scope and variable declaration keywords
  - variables declared with `var` have a scope at the *function-level*, not block-level
  - variables declared with `let` have a scope at the *block-level*, not function-level

The lesson called "Practice Problems: Variable Scopes in JS (2)" has exercises that explore the different hoisting behaviours of `let` and `var`. 

*Scope* describes how and where the language finds and retrieves values from declared variables.
