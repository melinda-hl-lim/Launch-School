### The `typeof` operator

Allows us to get the data type of any value.

``` js
typeof 1.2;        // "number"
typeof 'hello';    // "string"
typeof false;      // "boolean"
typeof undefined;  // "undefined"
typeof { a: 1 };   // "object"
```

Special cases:
``` js
typeof [1, 2, 3];  // "object" (yes: an array is an object)
typeof null;       // "object" (null both is and isn't an object)
```

### Input and Output

#### prompt() for user input

The `prompt` method pops up a dialog box with an optional message that asks the user to enter some text:
``` js
let name = prompt('What is your name?');
```
If the user clicks `Ok`, `prompt` returns the text as a string. If the user clicks `Cancel`, the method returns `null`.

#### alert() to give the user a message

The `alert` method displays a dialog with a message. 
``` js
alert('Hello world');
```

#### log debugging messages to JS console with console.log

The method `console.log` outputs a message to the JS console.


### Switch

With the JS `switch` statement, execution "falls through" to the next case. To prevent falling through, each case statement needs a `break`.

``` js
let reaction = 'negative';

switch (reaction) {
  case 'positive':
    console.log('The sentiment of the market is positive');
  case 'negative':
    console.log('The sentiment of the market is negative');
  case 'undecided':
    console.log('The sentiment of the market is undecided');
  default:
    console.log('The market has not reacted enough');
}

// console output
The sentiment of the market is negative
The sentiment of the market is undecided
The market has not reacted enough
```

### Looping and Iteration

The `break` statement exits from a loop immediately.

The `continue` statement skips the current iteration of a loop and returns to the top of the loop.

## Functions

### Function Types and Uses

- Use arrow functions for callbacks.
- Use function declarations or function expressions for other functions, but choose one or the other as your primary choice.
- If you use function expressions, named function expressions are better for debugging purposes. They also help clarify the intent of those functions.

### Function definitions

- Default parameter: The default value for parameter `greeting` is `'Hello'`.
``` js
function greet(greeting = 'Hello') {
  console.log(greeting + ', world');
}
```


## String Methods

Template literal (a kind of string interpolation - yes, use one set of backticks in the code): ` `${greeting}, Puppi!` `

- String.prototype.toUpperCase()
- repeat
- includes
- trim: removes white spaces
- slice
- split
- join
- substring
- substr


## Array Methods

- Array.prototype.push(): add element to end of array // all methods follow the same naming convention afterwards!
- pop
- shift: removes first element of array
- unshift: adds element to beginning of array
- indexOf
- lastIndexOf
- slice: returns selected element(s) (not mutating)
- splice: remove element(s) from array (mutating); return removed elemet(s)
- concat
- join
- filter

- Array.from(): 
  - can take a string and split each char into an array element
  - Can take an arrow function and create an array from results, where each result is an element


## Math Methods

- `Math.PI`
- `Math.abs(number)`
- `Math.sqrt(number)`
- `Math.pow(base, power)`
- `Math.round(number)`: rounds to nearest int
- `Math.floor(number)`
- `Math.ceil(number)`
- `Math.random`: returns random float between `0` and `1`, excluding `1`.

- Number.prototype.toFixed(): returns string representing number rounded to arg num of decimal places.


## Date Methods

- `new Date()`: current date and time
- `Date.getDay()`: returns the day of the week (0-6)
- `Date.getDate()`: returns day of the month (1-31)
- `Date.getMonth()`: returns month of the year (0-11)
- `Date.getFullYear()`
  - DEPRECATED: `Date.getYear()`
- `Date.getTime()`: milliseconds since Jan 1st, 1970


## Objects

### Iterating Over Object Properties

This article also goes over array iteration: https://medium.com/launch-school/javascript-weekly-an-introduction-to-iteration-and-enumerability-70bb1054064a


``` js
let nicknames = {
  joseph: 'Joey',
  margaret: 'Maggie',
};

// method 1
var nicknameKeys = Object.keys(nicknames);
for (var index = 0; index < nicknameKeys.length; index++) {
  var key = nicknameKeys[index];
  console.log(nicknames[key])
}

// method 2
for (var key in nicknames) {
  console.log(nicknames[key]);
}
```

### Shallow Copy of an Object

``` js
function createShallowCopy(obj) {
  return Object.assign({}, obj);
}
```