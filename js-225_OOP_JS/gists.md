## Strict Mode

JS ES5 introduced **strict mode**, a mode that modifies the semantics of JS and prevents certain kinds of errors and syntax.

We should be aware of how it changes the behaviour of JS and your code.

### What Does Strict Mode Do?

Strict mode makes three significant changes to JS semantics:
1) It eliminates some silent errors that occur in sloppy mode by changing them so that they throw errors instead
2) It prevents some code that can inhibit JS's ability to optimize a program so that it runs faster
3) It prohibits using names and syntax that may conflict with future versions of JS

### Enabling Strict Mode

To enable strict mode, we add this **pragma** to the *beginning* of the program file or function definition:
``` js 
"use strict";
```

- *Pragma* is a language construct that thells a compiler, interpreter or other translator to process the code in a different way. 

Once strict mode is enabled, you can't disable it later.
``` js
"use strict";
// The rest of the program. Everything from here to the end of the file runs in strict mode.

function foo() {
  // strict mode is enabled here too.
}

// Strict mode is still enabled
foo();
```

Strict mode is lexically scoped. It only applies to the code that enables it.
``` js
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
Above, even though `bar` runs in sloppy mode can calls `foo`, `foo` runs in strict mode. Similarly if we call a sloppy mode function from a strict mode function:
``` js
function foo() {
  // All code here runs in sloppy mode
}

function bar() {
  "use strict";
  // All code here runs in strict mode
  foo(); // This invocation is strict mode, but `foo` runs in sloppy mode
  // All code here runs in strict mode
}
```
`foo` runs in sloppy mode even though we call it from `bar`, a strict mode function.


- nested functions inherit strict mode from the surrounding scope
- JS is in strict mode automatically within the body of a `class` and with JS modules

### Changes From Strict Mode

#### Implicit Global Variables

In sloppy mode, if we assign a value to a variable without first declaring it, JS automatically creates a global variable (well, JS defines undeclared variables as properties on the global object):
``` js
function foo() {
  bar = 3.1415; // In strict mode, this raises an error -- ReferenceError: bar is not defined
}

foo();
console.log(bar); // 3.1415
```

*Strict mode disables this feature by setting the default execution context to `undefined` instead of the global object.* 

#### Implicit Context in Functions

In sloppy mode, the following code fails to set `obj.a` to `42` since we invoke the `go` method with function call syntax. Thus, the implicit execution context, `this`, is set to the global object.

``` js
let obj = {
  a: 5,
  go: function() {
    this.a = 42; // In strict mode raises error --  TypeError: Cannot set property 'a' of undefined
  },
};

let doIt = obj.go;
doIt();
console.log(obj.a); // 5
```

In strict mode, using function call syntax on a method sets `this` to `undefined`. So `this.a` raises an exception. This change in JS semantics helps us spot bugs caused by context loss. 

#### Forgetting to Use `this`

In this code, we forgot to use `this` on line 6 when we tried to assign a new age to the object. Instead of updating the `age` instance property on `leigh`, though, we created a global variable named `age`. With strict mode, we would receive a `ReferenceError`:
``` js
function Child(age) {
  this.age = age;
};

Child.prototype.setAge = function(newAge) {
  age = newAge; // should be this.age -- in strict mode, we get an error -- ReferenceError: age is not defined
}

let leigh = new Child(5);
leigh.setAge(6);
console.log(leigh.age); // 5; expected 6
```

#### Leading Zeros

If you use a literal integer that begins with `0` but doesn't contain the digits `8` or `9`, sloppy mode JavaScript interprets it as an octal number:
``` js
console.log(1234567);  // 1234567
console.log(01234567); // 342391 (the same as octal 0o1234567)
```

With strict mode, numbers that look like octal numbers raise an error.

#### Other Strict Mode Differences

In addition to the changes described above, strict mode:
- prevents you from using function declarations in blocks
- prevents declaring two function parameters with the same name
- prevents using some newer reserved keywords, such as `let` and `static`, as variable names
- prevents you from using the `delete` operator on a variable name
- forbids binding of `eval` and `arguments` in any way
- disables access to some properties of the `arguments` object in functions
- disables the `with` statement, a statement whose use is not recommended even in sloppy mode

### Summary

The most important changes strict mode makes are:
- you can't create global variables implicitly
- functions won't use the global object as their implicit context
- forgetting to use `this` in a method raises an error
- leading zeros on numeric integers are illegal 

## Syntactic Sugar

https://launchschool.com/gists/2edcf7d7

## `let` and `const`

https://launchschool.com/gists/8d57ccb1

## Arrow Functions

https://launchschool.com/gists/0c48e9dc

## Classes

https://launchschool.com/gists/6ba85481

## Inheritance with Classes

https://launchschool.com/gists/cdba6a8e

## Modules

https://launchschool.com/gists/e7d0531f