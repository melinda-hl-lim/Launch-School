# JavaScript Basics

## About This Course

This course will focus on specifics of the JavaScript launguage:
- language grammar, syntax, and data types
- functions and higher-order functions
- arrays and objects as data structures
- core built-in methods
- writing idiomatic and stylistic code 


## JavaScript Versions

Fun fact: The official name of JavaScript is ECMAScript .

Most recent browsers support most, if not all, ES6 features. Older browsers, however, do not. For this reason, we should use a [compatability table](http://kangax.github.io/compat-table/es2016plus/) to determine what browsers support what features.

Tools like [Babel](https://babeljs.io/) can also be used to transpile modern JS into older JS.


## Running Your Code

We can run code by placing it in an HTML file and opening it in Chrome. There are two ways to do this.

1. Begin with a nearly empty HTML file and add the `<script>` tags:
``` HTML
<body>
  <script>
    console.log('I run automatically!');
  </script>
</body>
```

2. Start with minimal HTML file and add the following code instead:
``` HTML
<body>
  <script src="my_javascript.js"></script>
</body>
```
This tells the browser to load some JS from a file name `my_javascript.js`. 

**Note**: do not combine the two methods. If a javascript file is specified by the `src` attribute, then only that script will run.


## Code Style

*Variable names and object properties*
- start with lower case
- with multiple words, use camelCase

*Constant names*
- written in all caps
- with multiple workds, use SCREAMING_SNAKE_CASE

*Function names*
- use camelCase
- *constructors*, however, use PascalCase

*Formatting*
- indent code with two spaces
- If we have a block of multiple lines in curly braces, the opening brace is on the same line as the initial statement and the ending brace is on its own line.
- Semicolons always terminate a statement
- use one `let` declaration for each variable


## Data Types

Primitives:
- number
- boolean
- string
- null
- undefined
- symbols (ES6)
- big integers (ES9)

A compound data type:
- object

We can use **`typeof` operator** to get the data type of any value.
``` js
typeof 1.2;        // "number"
typeof 'hello';    // "string"
typeof false;      // "boolean"
typeof undefined;  // "undefined"
typeof { a: 1 };   // "object"
typeof [1, 2, 3];  // "object" (yes: an array is an object)
typeof null;       // "object" (null both is and isn't an object)
```
The last two examples show special cases we should be aware of:
- Arrays are objects in JS. They differ in some ways from most ordinary objects, but they *are* objects.
- In a bug that goes back to the very origins of JavaScript, `typeof null` returns "`object`" instead of the more logical "`null`". Unfortunately, a significant amount of existing code depends on this bug. If the bug were fixed, it would break those programs. Therefore, the bug will probably never be fixed. 

### Number

JS uses *Double Precision Floats*. 
- The largest number that can be precisely stored is 9,007,199,254,740,991 (`Number.MAX_SAFE_INTEGER`).
- The maximum numeric value that can be represented is 1.7976931348623157e+308 (`Number.MAX_VALUE`)
- Any number greater than this is represented as `Infinity`

Numbers support basic arithmetic operations (ex: `+`, `-`, `*`, `/`)

JS uses a floating point system to represent all numbers. This in unlike other languages that have distinct data types to represent integers, floats, doubles, reals or decimals.

Special number values:
- `Infinity`
- `-Infinity`
- `NaN`: not a number. We'll see this when a math function encounters an error.

### Boolean

Two possible values: `true` and `false`

### String

A sequence of characters used to represent text within a JS program. 
- JS strings have no size limit and can contain any amount of text. 
- We can use either single or double quote marks for strings. There's no functional distinction between the two.
- A common operation is concatenation. It uses the `+` operator.


## More on Strings

### Special Characters

Strings can hold any character in the *UTF-16 character set*. Some special characters that need to be formatted include:
- `\n`: new line
- `\t`: tab
- `\r`: carriage return
- `\v`: vertical tab
- `\b`: backspace
- quotes (`'`, `"`) in strings if the string is started with said quote character

### String Concatenation

We can append content to an existing string using **concatenation** with the `+` operator.

### Character Access

Strings act like a collection of characters. We can access a character in a string using the `String.prototype.charAt` method on the string.

Examples:
``` js
'hello'.charAt(1); // "e"
'hello'[1]; // "e"
```

Note: Unlike Ruby (where bracket notation is a method), bracket notation in JS is an operator.

### String Length

Strings have a `length` property: `'hello'.length; // 5`

### Working with Long Strings

When working with long strings, readability is an issue. We can divide the string by using:
- `+` for concatenation
- `\` at the end of each line: this tells JS to ignore the following newline character and concatenate the next line to the current string


## Primitive Values are Immutable

**All JS primitives are immutable.** Once created, they cannot be changed.

If primitives appear to be changing, it's an illusion. JS isn't changing the value assigned to the variable - it assigns wholly new values to variables. *This means we need to remember to assign an expression to change the value in the variable.*

All other JS language constructs are Objects. Objects are mutable.


## Variables

Variables provide a way of associating data with descriptive names so our programs can be understood more clearly by humans. It's helpful to think of variables as containers that hold data.

### Naming Variables

Guidelines for naming variables:
- JS is case-sensitive, so `myvariable` is not the same as `myVariable`
- Variable names can be of any length
- It must start with a Unicode letter, an underscore (`_`) or a dollar sign (`$`)
- It must not be a reserved word

### Declaring Variables

Variables should generally be decalred before they are used. There's a sublte but important difference between declared and undeclared names (discussed later).

JS variables are primarily declared using the following keywords: `let`, `const`, `var`.
- `var` is the traditional way of declaring variables
- `let` and `const` were introduced in ES6. When possible, use these.
- `var` is similar to `let` in the way it's used, but there are differences we'll learn later

### Variable Assignment and Initializers

Once a variable is declared, you can use the `=` operator to assign a value to it:
``` js
let number;
number = 3;
```

Or we can combine the variable declaration with an **initializer**:
``` js
let myVariable = 'Hello world';
```

*Initializers vs. Assignment*: 
- An assignment is a standalone expression that gives a variable a new value
- An initializer is the expression to the right of the `=` in a variable declaration

A variable that is declared but not assigned will have a value of `undefined`.

*Constants*: once a constant is declared, it cannot be assigned a new value. Therefore we have to initialize constants when we declare them:
``` js
const BAR; // Uncaught SyntaxError: Missing initializer in const declaration

const FOO = 3;
FOO = 4; // Uncaught TypeError: Assignment to constant variable
```

### Dynamic Typing

When initializing variables, another thing to note is the implication of the data type.

JS is a *dynamically typed language*, meaning that a variable can hold a reference to any data type, and can be reassigned a different type without error.


## Operators

An operator is a symbol that tells the computer to perform operations on values (a.k.a. operands). 

### Arithmetic Operators

Standard: `+`, `-`, `/`, `*`, `%`

Note: the remainder operator `%` is not the same as the modulo operator found in other langauges. This operator returns the remainder of an integer division. With positive integers, there's no distinction: `10 % 3` returns `1`. But with negative numbers, `10 % 3` returns `1`, not `-1`. 

### Assignment Operators

We have the `=` assignment operator. There are also shorthand notations for a couple of the arithmetic operators: `+=`, `-=`, `*=`, `/=`, `%=`.

### Comparison Operators

Compariosn operator compares its operands and returns a boolean value. 

- `==`: equal
- `!=`: not equal
- `===`: Strict equal - returns true if operands are equal and of the same type
- `!==`: Strict not equal - returns true if operands are not equal and/or not the same type
- `>`: greater than
- `<`: less than

### String Operators

We can compare strings as is they were numbers. And don't forget the concatenation operator! We can use `+` and `+=`.

### Logical Operators

Logical operators also work with non-boolean values.

- `&&`: Logical And
- `||`: Logical Or
- `!`: Logical Not


## Expressions and Statements

### Exprssions

An expression is any valid code that resolves to a value.
``` js
'hello';   // a single string is an expression
10 + 13;   // arithmetic operations are expressions
sum = 10;  // assignments are expressions
```

The most common expression types are:
- arithmetic
- string
- logical

Expressions can appear anywhere that JS epects or allows a value.

### Operator Precedence

To determine which operator it evaluates first, JS uses rules simlar to those found in other languages. They weren't specified in LS, however, so I might need to look up the rules.

### Increment and Decrement Operators in Expressions

The increment `++` and decrement `--` operators increment or decrement their operands by `1`. When used alone, it doesn't matter if we prefix or postfix the operator.

However, when used in more complex expressions prefix and postfix forms behave differently:
- postfix (i.e. after the operand): JS evaluates the expression then modifies the operand
- prefix (i.e. before the operand): JS modifies the operand and then evaluates the expression

### Logical Short Circuit Evaluation in Expressions

When an expression contains `&&` or `||` operators, JS evaluates using "short circuit" rules:
- For `a || b`, if `a` is `true` then the result is always true. `b` remains unevaluated.
- For `a && b`, JS returns `false` if `a` is `false`. `b` remains unevaluated.

### Statements

Statements in JS don't necessarily resolve into a value. Statements generally control the execution of the program. 

Examples of statements include:
- variable declarations: `let a;`
  - note: variable assignments are expressions
- `if ... else ...`: a branching logical condition
- `switch`: another branching logical condition
- `while`: a loop
- `for`: another loop

Statements always evaluate as `undefined`. You cannot use a statement as part of another expression.

Some statements include expressions as part of their syntax. 

**Remember: expressions evaluate to a value; statements do not.**


## Input and Output

### Using prompt() to Get User's Input

The `prompt` method pops up a dialog box with an optional message that asks users to enter some text. 

``` js
let name = prompt('What is your name?');
let guess = prompt();           // blank prompt window
```

The dialog box has `Ok` or `Cancel`. If `Ok` is clicked, `prompt` returns the text as *a string*; if `Cancel` is clicked, it returns `null`.

### Using alert() to Prompt a Message to the User

The `alert` method displays a dialog with a message and an `Ok` button. We use `alert` to notify the user of an event/item of interest, but don't take any input from the user.

``` js
alert('Hello, world');   // alert dialog box with a message
alert();                 // an empty alert dialog box
```

### Logging Debugging Messages to the JavaScript Console

The `console.log` method outputs a message to the JS console. This is used only for debugging purposes. 


## Explicit Primitive Type Coercions

**Coercions** or **conversions** are operations that convert JS values into values of different types. Since primitives in JS are immutable, it doesn't convert the value - it returns a new value of the proper type.

### Converting Strings to Numbers

We can use the `Number` function to turn strings with numeric value into a number:
``` js
Number('1');             // 1
Number('abc123');        // Strings that can't be converted return NaN
```

The `parseInt` and `parseFloat` global functions turn strings to numbers, with each only handling numeric values in an integer or floating-point form:
``` js
parseInt('123', 10);     // 123
parseInt('123.12');      // 123
parseFloat('123.12');    // 123.12, can handle floating point values
```
Note that `parseInt` takes an optional `radix` argument, representing the numerical base.

### Converting Numbers to Strings

There are three ways to convert numbers into strings.

1. We can use the `String` function to turn numbers into strings:
``` js
String(123);             // "123"
String(1.23);            // "1.23"
```
2. We can also use the `toString` method:
``` js
(123).toString();        // "123"
(123.12).toString();     // "123.12"
```
3. We can also convert a number into a string with the `+` operator to "add" it to a string:
``` js
123 + '';                // "123"
'' + 123.12;             // "123.12"
```

### Booleans to Strings

Like numbers, we can use the `String` function or the `toString` method to convert booleans into strings.

### Primitives to Booleans?

There is no direct coercion of strings into booleans. Therefore, if we have a string representation of a boolean we can just compare it with the string `'true'` to determine if it's `true` or `false`.

### `Boolean`

We can use the `Boolean` function to convert any value into a boolean value based on the truthy and falsy JS rules.

``` js
// Falsey values
Boolean(null);           // false
Boolean(NaN);            // false
Boolean(0);              // false
Boolean('');             // false
Boolean(false);          // false
Boolean(undefined);      // false

// Truthy values
Boolean('abc');          // other values will be true
Boolean(123);            // true
Boolean('true');         // including the string 'true'
Boolean('false');        // but also including the string 'false'!
```

The double `!` operator provides a simpler way to coerce a truthy or falsy value to its boolean equivalenet:
``` js
!!('abc');               // true
!!(123);                 // true
!!(NaN);                 // false
!!(0);                   // false
```


## Implicit Primitive Type Coercions

In general, avoid implicit type conversions. 

### The Plus (+) Operator

The *unary plus operator* converts a value into a number, following the same rules as the `Number` function:
``` js
+('123')        // 123
+(true)         // 1
+(false)        // 0
+('')           // 0
+(' ')          // 0
+('\n')         // 0
+(null)         // 0
+(undefined)    // NaN
+('a')          // NaN
+('1a')         // NaN
```

The *binary plus operator* means either addition for numbers of concatenation for strings. If a string is one of the operands, the other operand will be coerced into a string:

``` js
'123' + 123     // "123123" -- if a string is present, coerce for string concatenation
123 + '123'     // "123123"
null + 'a'      // "nulla" -- null is coerced to string
'' + true       // "true"
```
When both operands are a combination of numbers, booleans, `null`s, or `undefined`s, non-numbers are converted into numbers and then added:
``` js
1 + true        // 2
1 + false       // 1
true + false    // 1
null + false    // 0
null + null     // 0
1 + undefined   // NaN
```

*Side note*: When one of the operands is an object (including arrays and functions), both operands are converted into strings and concatenated together. 

### Other Arithmetic Operators

Other arithmetic operators (`-`, `*`, `/`, `%`) are only defined for numbers, so JS converts both operands to numbers.

### Equality Operators

JS provides non-strict equality operators - `==` and `!=` - and strict equality operators - `===` and `!==`. The strict operators never perform type coercions.

The non-strict operators have a set of rules for coercing types before comparison:

- When one operand is a string and the other a number, the string is converted into a number
``` js
'42' == 42            // true
42 == '42'            // true
42 == 'a'             // false -- becomes 42 == NaN
0 == ''               // true -- becomes 0 == 0
0 == '\n'             // true -- becomes 0 == 0
```

- When one operand is a boolean, it is converted to a number
``` js
42 == true            // false -- becomes 42 == 1
0 == false            // true -- becomes 0 == 0
'0' == false          // true -- becomes '0' == 0, then 0 == 0 (two conversions)
'' == false           // true -- becomes '' == 0, then 0 == 0
true == '1'           // true
true == 'true'        // false -- becomes 1 == 'true', then 1 == NaN
```

- When one operand is `null` and the other is `undefined`, the non-strict operator returns `true`. 
- When *only one* operand is `null` or `undefined`, the operator *always* returns `false`
``` js
null == undefined      // true
undefined == null      // true
null == null           // true
undefined == undefined // true
undefined == false     // false
null == false          // false
undefined == ''        // false
undefined === null     // false -- strict comparison
```

- When *one* operand is `NaN`, the comparison *always* returns `false`

### Relational Operators

The relational operators `<`, `>`, `<=`, and `>=` are defined for numbers and strings. 

- When both operands are strings, JS compares them lexicographically
- Otherwise, JS converts both operands to numbers and compares
``` js
11 > '9'              // true -- '9' is coerced to 9
'11' > 9              // true -- '11' is coerced to 11
123 > 'a'             // false -- 'a' is coerced to NaN; any comparison with NaN is false
123 <= 'a'            // also false
true > null           // true -- becomes 1 > 0
true > false          // true -- also becomes 1 > 0
null <= false         // true -- becomes 0 <= 0
undefined >= 1        // false -- becomes NaN >= 1
```

### Best Practices

**Always use explicit type coercions. Always use strict equality operators.**


## Conditionals

### if ... else

``` js
if (condition1) {
  // statements
} else if (condition2) {
  // statements
} else if (conditionN) {
  // statements
} else {
  // statements
}
```

### Truthy and Falsey

There are *six* possible falsey values:
``` js
if (false)        // falsy
if (null)         // falsy
if (undefined)    // falsy
if (0)            // falsy
if (NaN)          // falsy
if ('')           // falsy
```

Logical operator return values and truthy/falsey values:
``` js
// With the logical operator the return values are such:
1 || 2;           // 1
1 && 2;           // 2

// Using the logical operator as a `condition` in an if statement
if (1 || 2)       // truthy
if (1 && 2)       // truthy
```

### Switch

The `switch` statement compares an expression with multiple `case` labels. 

``` js
let reaction = 'negative';

switch (reaction) {
  case 'positive':
    console.log('The sentiment of the market is positive');
    break;
  case 'negative':
    console.log('The sentiment of the market is negative');
    break;
  case 'undecided':
    console.log('The sentiment of the market is undecided');
    break;
  default:
    console.log('The market has not reacted enough');
}
```
Note that execution "falls through" to the next case. This means that if one of the `case` labels matches the expression, then all cases following it will be executed until it reaches the `default` clause or a `break` statement.

We usually want to just execute one of the `case` branches. So we must add `break` in each `case` statement to ensure only one case is hit. 

### Comparing values with NaN

`NaN` is a special value in JS that represents an illegal operation on numbers. It stands for "Not a Number", but is a number in JS. 

Using `NaN` in a comparison **always** returns false, even if you're comparing `NaN` to `NaN`. 
``` js
console.log(NaN === NaN);    // false
```

To check whether a variable holds `NaN`, we need to use the `Number.isNaN` function. 
``` js
let foo = NaN;
console.log(Number.isNaN(foo));      // true

console.log(Number.isNaN('hello'));  // return false since `'hello'` is not NaN
```


## Practice Problems: Operators and Conditionals

Conditional ternary operator:
``` js
function getFee(isMember) {
  return (isMember ? '$2.00' : '$10.00');
}
```


## Looping and Iteration

### The "While" Loop

The `while` loop first evaluates the condition, then executes the statements in the loop body if the condition has a truthy value.
``` js
let counter = 0;
let limit = 10;

while (counter < limit) {
  console.log(counter);
  counter += 2;
}
```

### Infinite Loops

An infinite loop results if the statements in the body of the loop never make the condition turn falsey. 

### Break and Continue

The `break` statement exits the loop immediately. 

The `continue` statement skips the current iteration of a loop and returns to the top of the loop.

``` js
let counter = 0;
let limit = 10;

while (true) {
  counter += 2;
  if (counter === 4) {
    continue;
  }

  if (counter > limit) {
    break;
  }

  console.log(counter);
}
```

### The "Do ... While" Loop

The `do ... while` loop iterates at least once.

``` js
let counter = 0;
let limit = 0;

do {
  console.log(counter);
  counter += 1;
} while (counter < limit);
```

### The "For" Loop

The `for` loop combines three key elements of a loop: setting the initial state, evaluating a condition, and making some type of change before re-evaluating the condition.

``` js
for (let i = 0; i < 10; i += 1) {
  console.log(i);
}

// put initialization outside of the loop
let index = 0;
for (; index < 10; index += 1) {
  console.log(index);
}

// manually check condition and break out of the loop
// If you omit the condition component in the "for", JavaScript assumes true
for (let index = 0; ; index += 1) {
  if (index >= 10) {
    break;
  }

  console.log(index);
}

// manually increment the iterator
for (let index = 0; index < 10; ) {
  console.log(index);
  index += 1;
}
```


## Exercises




