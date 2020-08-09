# Writing Better Code

## JavaScript Style Guide

Use the [AirBnB JS style guide](https://github.com/airbnb/javascript).


## Strict Mode

**GO READ THIS AGAIN LATER BECAUSE A LOT OF UNINTRODUCED TOPICS IN HERE**

JS ES5 introduced **strict mode**. This mode modifies the semantics of JS and prevents certain kinds of errors and syntax.

To focus on:
- What is strict mode? How does it differ from sloppy mode?
- How do you enable strict mode at the global or function level?
- Describe how code behaves under both strict and sloppy mode.
- When is strict mode enabled automatically?
- When should you use (or not use) strict mode?

### What Does Strict Mode Do?

Strict mode makes three changes to JS semantics:
- Eliminates some silent errors so that they throw errors instead
- Prevents some code that inhibit JS's ability to optimize a program
- Prohibits using names and syntax that may conflict with future versions of JS

### Enabling Strict Mode

Enable strict mode by adding this to the beginning of the program file or function definition:
``` js
"use strict";
```
The above is a **pragma**, a language construct that tells a compiler, interpreter, or translator to process the code in a different way. 

Once you enable strict mode, you *can't disable it later* in the same program or function.

Strict mode is *lexically scoped*. 

Global strict mode:
``` js
"use strict";
// The rest of the program. Everything from here to the end of
// the file runs in strict mode.

function foo() {
  // strict mode is enabled here too.
}

// Strict mode is still enabled
foo();
```

Function strict mode:
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

### Implicit Global Variables

Strict mode prevents defining undeclared variables as global variables by setting the default *execution context* to `undefined` instead of the global object. 

### Implicit Context in Functions

skipped

### Forgetting to Use `this`

skipped

### Leading Zeros

If you use a literal integer that begins with `0` but doesn't contain the digits `8` or `9`, sloppy mode JavaScript interprets it as an octal number:
``` js
console.log(1234567);  // 1234567
console.log(01234567); // 342391 (the same as octal 0o1234567)
```

In strict mode, Octal numbers aren't allowed.

### Other Strict Mode Differences

In addition to the changes described above, strict mode:

- prevents you from using function declarations in blocks.
- prevents declaring two function parameters with the same name.
- prevents using some newer reserved keywords, such as `let` and `static`, as variable names.
- prevents you from using the `delete` operator on a 
- forbids binding of `eval` and `arguments` in any way.
- disables access to some properties of the `arguments` object in functions.
- disables the `with` statement, a statement whose use is not recommended even in sloppy mode.

### When Should I Use Strict Mode?

Use strict mode in any new code we write. If we're adding new functions to an old codebase, use function-level strict mode in the new functions. 


## Syntactic Sugar

Article: https://launchschool.com/gists/2edcf7d7

Review this once in a while so I can recognize (and eventually use) the sweet sweet syntactical sugar!


## Errors

The terms *exception* and *error* are synonymous. These are both *raised* and *thrown* (and these verbs are used synonymously). 

`ReferenceError`: when we reference a variable/function that doesn't exist

`TypeError`: occurs when we try to access a property on a value that doesn't have any properties. Calling something that isn't a function also raises this error.

`SyntaxError`: something is wrong in the text of the program!


## Preventing Errors

**Guard Clauses**

A *guard clause* is code that guarantees data meets certain preconditions before it gets used. 

We use guard clauses when a function can't trust its arguments are valid (i.e. incorrect types, structures, values, properties).

**Detecting Edge Cases**

Error prevention stems from examining the assumptions in our code. We need to think if the program can violate those assumptions -- these situations are called *edge cases* because they often involve values at the extreme end of possible values. 

**Planning Your Code**

Try to write out the common use cases for a new Function. This can help us find edge cases!


## Catching Errors

We can **catch** errors with a `try/catch/finally` block:
``` js
try {
  // Do something that might fail here and throw an Error.
} catch (error) {
  // This code only runs if something in the try clause throws an Error.
  // "error" contains the Error object.
} finally {
  // This code always runs, no matter if the above code throws an Error or not.
  // THE FINALLY CLAUSE IS OPTIONAL
}
```

We use the `try/catch/finally` blocks when all of the following are true:
- a built-in JS Function or method can throw an Error and you need to handle/prevent the Error
- A simple guard clause is impossible/impractical to prevent the error