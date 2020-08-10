The course focused on these specifics of the JavaScript launguage:
- language grammar, syntax, and data types
- functions and higher-order functions
- arrays and objects as data structures
- core built-in methods
- writing idiomatic and stylistic code 


## Misc. Terminology

**Expressions**: any valid code that resolves to a value

**Statements**: generally control the execution of the program. Examples include variable declarations, conditional statements (`if ... else ...` or `switch`), loops, ... Statements always evaluate as `undefined`. 

**Arguments**: used when invoking a function

**Parameters**: used when defining a function

**Shallow Copy**: the new object has the same structure as the old object, but the values it holds are not cloned; both new and old objects reference the same values in memory


## Primitive Values, Types and Type Conversions

### Primitive Types and Their Nuances

Within JavaScript, we have the following primitive data types...:
- number
- boolean
- string
- null
- undefined
- ES6: symbols
- ES9: big integers

And the following compound data type:
- object

**Primitive values are immutable.**

#### Numbers

Within JS, we have one number type: `number`. It uses *Double Precision Floats*. 

There are a few *special number values*:
- `Infinity` and `-Infinity` represent a number greater than/less than any other number
- `NaN` means "not a number" - this usually appears when a math function encounters an error.


#### Strings

Strings have no size limit and can contain any amount of text. It can hold any character in the UTF-16 character set, including `\n`, `\t`, `\r`, ...

We can create strings with single or double quote marks: there is no functional distinction.


### Explicit Primitive Type Coercions

Use the `Number` function to *turn strings into numbers*: 
``` js
Number('1');      // 1
Number('abc123'); // NaN
```
The `parseInt` and `parseFloat` global functions also turn strings to numbers.

Use the `String` function, the `toString` method or string concatenation `+` to turn *numbers, booleans into strings*:
``` js
String(123);         // "123"
(true).toString(); // "123.12"
'' + 123.12;         // "123.12"
```

There is no coercion of strings to booleans.

Use the `Boolean` function or `!!` operator to convert *any value into a boolean* value based on truthy/falsy rules:
``` js
Boolean(null);           // false
Boolean(NaN);            // false
Boolean(0);              // false
Boolean('');             // false
Boolean(false);          // false
Boolean(undefined);      // false

Boolean('abc');          // other values will be true
!!('false');             // true
```
Note the list of six falsey values in JS.

### Implicit Primitive Type Coercions

Avoid implicit type conversions. Alwways use explicit type coercions and strict equality operators.

#### The plus `+` operator

The plus `+` operator converts a value into a number following the same rules as the `Number` function.
``` js
+('123')        // 123
+(true)         // 1
+('\n')         // 0
+(null)         // 0
+(undefined)    // NaN
+('a')          // NaN
```

When `+` is used with *a string and another type*, JS converts the other type operand into a string.

When `+` is used with *a number and non-string types*, JS converts the non-number operand into a number.

#### Other arithmetic operators

Operators `-`, `*`, `/`, `%` are only defined for numbers, so JS converts both operands to numbers. 

#### Non-strict equality operators

When the operands are *a string and a number*, the string is converted to a number.

When *one operand is a boolean*, the boolean is converted into a number.

When the operands are *`null` and `undefined`*, the operator always returns `true`. 

When *one operand is `null`, `undefined` or `NaN`*, the operator always returns `false`. 

  *Side note*: `NaN === NaN` returns `false`. To check if a variable holds the value `NaN` we need to use the `Number.isNaN` function.

#### Relational Operators

The operators `<`, `>`, `<=`, and `>=` are defined only for numbers (numeric comparison) and strings (lexographic order).

When *both operands are strings*, JS compares them lexicographically.

With *any other operand type combinations*, JS converts both operands to numbers.



## Variable Scopes and Hoisting

### Variable Basics

Variables **must** be declared before they are used. There is some terminology to remember:
``` js
let number; // Here we DECLARE the variable `number`
number = 3; // We then ASSIGN the value 3 to variable `number` 

// An ASSIGNMENT is a standalone expression that gives a variable a new value

// We can combine the variable declaration with an INITIALIZER
let number = 3; // the initializer is the expression to the right of the `=`
```
A variable that is declared but not initialized or assigned will have the value `undefined`.

*Side note: Constants*
Constants must be initialized when declared; we can't assign a new value to a constant.

JavaScript is **dynamically typed**, meaning a variable can hold a reference to any data type, and can be reassigned to a different type.

### Variable Scopes

A variable that is assigned but not found is created as a new global variable.

### Hoisting

The JS engine operates in two phases:
- Creation phase: preliminary work including
  - finding all variable, function and class *declarations*
  - hoisting said declarations
- Execution phase: program runs code line-by-line 

**Hoisting** is the process of "moving" declarations to the top of their respective function/block

**Variables: The Temporal Dead Zone**

When we declare variables, the keyword we use affects how the variable is hoisted:
- When a `var` variable is hoisted, JS gives it an initial value of `undefined`
- When a `let` or `const` variable is hoisted, they are left "unset" - they aren't defined, but they are *not* `undefined`

Unset variables live in the **Temporal Dead Zone (TDZ)**

Therefore, if we try to access a `let` or `const` variable before it's set, we get this error:
``` js
console.log(foo); // Uncaught ReferenceError: Cannot access 'foo' before initialization
let foo;
```

**Undefined behaviour: Hoisting nested functions declarations**

*If a function declaration is nested inside a non-function block*, there is no defined behaviour. Avoid the following:
``` js
function foo() {
  if (true) {
    function bar() {
      console.log("bar");
    }
  } else {
    function qux() {
      console.log("qux");
    }
  }
}
```

**Hoisting Variable and Function Declarations**

When both a variable and function declaration exists, the function declaration is hoisted first. 

**Best Practices**

- Whenever possible, use `let` and `const` instead of `var`
- If we must use `var`, declare all variables at the top of the scope
- If we can use `let` and `const`, declare them as close as possible to their first usage
- Declare functions before calling them



## Function Declarations, Expressions and Scopes

### Function Basics

**Return values**: If a function does not contain an explicit `return` or if the `return` statement does not include a value, the function implicitly returns the value `undefined`. 

**Argument numbers**:
- calling a function with too few or too many arguments doesn't raise an error
- if an argument wasn't provided, its value within the function will be `undefined`

### Function Declarations and Function Expressions

**Function Declarations**

A function declaration (a.k.a. a function statement) *defines a variable* whose type is `function`. The value of the function variable is the function itself. 

``` js
function hello() {
  return "hellow!";
}
```

**Function Expressions**

A function expression defines a function as part of a larger expression syntax (typically variable assignment).

Creating an anonymouse function assigned to `foo`:
``` js
let foo = function () {
  return 1;
  };
};
```

Creating a named function using a function expression:
``` js
let hello = function foo() {
  console.log(typeof foo);
};
```
Note: the name `foo` is only accessible within the function itself. Naming function expressions is useful for debugging; however, most function expressions use anonymous functions. 

**Declaration vs. Expression**

If a *statement* begins with the `function` keyword, it's a function declaration. Otherwise, it's a function expression.

``` js
function foo() {
  console.log('function declaration');
}

// Simply adding parentheses around the function declaration turns it into a function expression
(function bar() {
  console.log('function expression');
});

foo();    // function declaration
bar();    // Uncaught ReferenceError: bar is not defined
```

**Arrow Functions**

Introduced in ES6, arrow functions are a special type of function definition. Right now, we can think of arrow functions as a shorthand way to writing function expressions.
``` js
const multiply = (a, b) => {
  return a * b;
}

// even shorter arrow function
const multiply = (a, b) => a * b;
```

Use arrow functions (mostly) as **callback functions**. 
``` js
[1, 2, 3].map(function (element) {
  return 2 * element;
}); // returns [2, 4, 6]

// simplify the above with an arrow function
[1, 2, 3].map(element => 2 * element); // returns [2, 4, 6]
```

Note: arrow functions inherit the "execution context" from the surrounding code.


### Function Scopes

**A variable's scope** is the part of the program that can access that variable by name.

JavaScript uses **lexical scoping** to resolve variables: it uses the *structure of the source code* to determine the variable's scope. 

- Every function declaration creates a new local variable scope. 
- Every block creates a new local variable scope.
- All variables in the same or surrounding scopes are visible inside functions and blocks.

``` js
let name = 'Julian';       // `name` is in global scope

function greet() {         // `greet` is also in global scope
  let counter = 0;         // `counter` is in function scope
  while (counter < 3) {
    let myName = name;     // `myName` is in block scope
    console.log(myName);
    counter += 1;
  }

  // console.log(myName); // would raise an error (myName not in scope)
  console.log(counter);   // => 3
}

greet();                  // => Julian (3 times)
// console.log(myName);   // would raise an error (not in scope)
// console.log(counter);  // would raise an error (not in scope)
```


## Naming Conventions (Legal vs. Idiomatic)

First lesson on convention: https://launchschool.com/lessons/7377ece4/assignments/88ed1c52

AirBnB style guide: https://github.com/airbnb/javascript

## Object Properties and Mutation

### Object Properties Basics

We can create, assign and access object properties using *dot notation* and *bracket notation*:
``` js
let pets = {}; // create an empty object

pets.puppi = true;
pets['puppi'];   // true -- note the use of string to access with bracket notation...

pets["hercules"] = false;
pets.hercules; // false
```

And the reserved keyword `delete` to delete properties from objects:
``` js
let pets = {
  puppi: true,
  bella: 'unsure',
};

delete pets.bella;
```

### Mutability of Values and Objects

Objects are mutable: we are able to change the values that are stored. However, if a value is a primitive data type, then we can reassign the value that the object holds to a new primitive (since primitives are immutable).

## Assignments and Comparison

## Pure Functions and Side Effects

A function *call* has **side effects** if:
- reassign any non-local variable
- mutates the value of any object referenced by a non-local variable
- reads from or writes to any data entity (files, network connections, ...) that is non-local to your program
- raises an exception
- calls another function that has side effects

We say that the *function call* (not function) has side effects. A function given one set of arguments may have no side effects, but given a different set of arguments may result in a side effect

A **pure function**:
- has no side effects
- always returns a value that is dependent on the arguments passed in
- always returns the same value for the same set of arguments *during the function's lifetime*

The consistent return value is possibly the most important feature of pure functions: because the same arguments always produce the same return value, it's implied that nothing else in the program can influence the function during its lifetime.

**Review the problems at the end of this reading**: https://launchschool.com/lessons/79b41804/assignments/88138dd5

## Handy Tools

Documentation: https://developer.mozilla.org/en-US/docs/Web/JavaScript

Compatability table: http://kangax.github.io/compat-table/es2016plus/

Transpiler (JS versions): https://babeljs.io/

## To-Re-Review

Closures: https://launchschool.com/lessons/7cd4abf4/assignments/0ea7c745

Where did I get the below???
- scope and variable declaration keywords
  - variables declared with `var` have a scope at the *function-level*, not block-level
  - variables declared with `let` have a scope at the *block-level*, not function-level