# Objects

## Introduction to Objects

JS is an *object-oriented language*, meaning objects are used to organize code and data.

### Standard Built-in Objects

JS provides built-in objects, including: `String`, `Array`, `Object`, `Math`, `Date`, ...

Some built-in objects share their names with primitive data types. While the names are the same, they are different from each other.

*You can only call methods on the object data type.*

JavaScript temporarily coerces primitives (all types except `null` or `undefined`) to their object counterpart when necessary:
``` js
let a = 'hi';                        // Create a primitive string with value "hi"
typeof a;                            // "string"; This is a primitive string value

let stringObject = new String('hi'); // Create a string object
typeof stringObject;                 // "object"; This is a String object

a.toUpperCase();                     // "HI"
stringObject.toUpperCase();          // "HI"

typeof a;                            // "string"; The coercion is only temporary
typeof stringObject;                 // "object"
```

### Creating Custom Objects

Create objects using *object literal notation*:
``` js
let colors = {
  red: '#f00',
  orange: '#ff0',
};

typeof colors;      // "object"
colors.red;         // "#f00"
colors.orange;      // "#ff0"
```

Two more ways to create objects:
- object constructor function: `new String('puppi')`
- with the `Object.create` method

#### Properties

Objects are containers for two things: data and behaviour. Data consists of named items with values; values represent the attributes of the object.

**Def'n Properties.** Associations between a name/key and a value within the object.

Accessing and assigning properties:
``` js
let colors = {
  red: '#f00',
  orange: '#ff0',
};

colors.red;             // "#f00"
colors.blue = '#00f';
```

#### Methods

Functions define the behaviour of an object. When the function is part of an object, we call it a **method**. 

Access methods as if we were accessing an object property (because a method is a property):
``` js
(5.234).toString();       // "5.234"
'pizza'.match(/z/);       // [ "z", index: 2, input: "pizza" ]
Math.ceil(8.675309);      // 9
Date.now();               // 1467918983610
```

Within *ES6*, there's a **compact method syntax**. Rather than writing the property name, colon, and then a function expression, we can use a simplified syntax:

``` js
let myObj = {
  foo(who) {
    console.log(`hello ${who}`);
  },

  bar(x, y) {
    return x + y;
  },
};

// This is without the compact method syntax
let myObj = {
  foo: function (who) {
    console.log(`hello ${who}`);
  },

  bar: function (x, y) {
    return x + y;
  },
};
```

*Arrow functions and methods*: it's not a good idea since arrow functions have subtle behaviour that makes them unsuitable for use as methods. 


## Object Properties

### Property Names and Values

A property name for an object can be any valid string, and a property value can be any valid expression:

``` js
let object = {
  a: 1,                           // a is a string with quotes omitted
  'foo': 2 + 1,                   // property name with quotes
  'two words': 'this works too',  // a two word string
  true: true,                     // property name is implicitly converted to string "true"
  b: {                            // object as property value
    name: 'Jane',
    gender: 'female',
  },
  c: function () {                // function expression as property value
    return 2;
  },
  d() {                           // compact method syntax
    return 4;
  }
};
```

Access property values using "dot notation" or "bracket notation":
``` js
let object = {
  a: 'hello',
  b: 'world',
};

object.a;                 // "hello", dot notation
object['b'];              // "world", bracket notation
object.c;                 // undefined when property is not defined
```

To add a new property to an object, use "dot notation" or "bracket notation" and assign a value to the result.

We can use the keyword `delete` to delete properties from objects:
``` js
let foo = {
  a: 'hello',
  b: 'world',
};

delete foo.a;
foo;                      // { b: "world" }
```


## Stepping Through Object Properties

Objects are a collection type. We can perform some action for each element in an object with a `for ... in` loop:
``` js
let nicknames = {
  joseph: 'Joey',
  margaret: 'Maggie',
};

for (let nick in nicknames) {
  console.log(nick);
  console.log(nicknames[nick]);
}

// logs on the console:
joseph
Joey
margaret
Maggie

Object.keys(nicknames);  // [ 'joseph', 'margaret' ]
```


## Practice Problems: Working with Object Properties

1. Write a function name `objectHasProperty` that takes two arguments: an Object and a String. The function should return true if the Object contains a property with the name given by the String, false otherwise.

``` js
function objectHasProperty(object, propertyName) {
  let keys = Object.keys(object);
  return keys.indexOf(propertyName) !== -1;
}
```

2. Write a function named `incrementProperty` that takes two arguments: an Object and a String. If the Object contains a property with the specified ame, the function should increment the value of that property. If the property doesn't exist, the function should add a new property with a value of `1`. The function should return the new value of the property.

``` js
function incrementProperty(object, propertyName) {
  if (object[propertyName]) {
    object[propertyName] += 1;
  } else {
    object[propertyName] = 1;
  }

  return object[propertyName];
}
```

3. Write a function named `copyProperties` that takes two Objects as arguments. The function should copy all properties from the first object to the second. The function should return the number of properties copied.

``` js
function copyProperties(source, destination) {
  let count = 0;
  for (let property in source) {
    destination[property] = source[property];
    count++;
  }

  return count;
}
```

4. Write a function named `wordCount` that takes a single String as an argument. The function should return an Object that contains the counts of each word that appears in the provided String. In the returned Object, you should use the words as keys, and the counts as values. 

``` js
function wordCount(string) {
  let count = {}
  let sentence = string.split(' ');

  for (let word of sentence) {
    if (count[word]) {
      count[word]++;
    } else {
      count[word] = 1;
    }
  }

  return count;
}
```


## Arrays and Objects

JS uses arrays and objects as data structures to represent compound data. When should we use one over the other?

### Array

Use an array if your data is more like a list that contains many items and/or you need to maintain data in a specific order.

Most common interaction patterns: CRUD elements, iterating over elements

### Object

Use an object if your data is more like an entity with many parts, especially if you need to access values based on the names of those values.

With objects, most interactions involve "keyed" access: CRUD specific data item. Since each key is associated with a specific datum, we can use the term "associative array" to refer to objects.

### Arrays are Objects

``` js
let a = ['hello', 'world'];

console.log(typeof a);        // "object"
console.log(a['1']);          // "world", object's bracket notation to access value
console.log(Object.keys(a));  // ["0", "1"], the keys of the object!

// line 1 is equivalent of:

let a = {
  '0': 'hello',
  '1': 'world',
};

console.log(typeof a);        // "object"
console.log(a['1']);          // "world", object's bracket notation to access value
console.log(Object.keys(a));  // ["0", "1"], the keys of the object!
```

### Arrays and the Length Property

JS built-in Array methods take the value of the `length` property into consideration when performing operations.

However, not all keys of the array object are array indexes included in the `length` property:
``` js
let myArray = [];
myArray['foo'] = 'bar';
myArray[0] = 'baz';
myArray[1] = 'qux';

console.log(myArray);         // logs ['baz', 'qux', foo: 'bar']
myArray.length;               // returns 2 since foo: 'bar' is not an element
myArray.indexOf('bar');       // returns -1 since 'bar' isn't in an element

myArray[-1] = 'hello';
myArray[-2] = 'world';
myArray.length;               // returns 2
myArray.indexOf('hello');     // returns -1 since 'hello' is not in an element
                              // the fact that myArray[-1] is 'hello' is
                              // coincidental
myArray.indexOf('world');     // returns -1 since 'world' is not in an element

console.log(myArray);         // logs ['baz', 'qux', foo: 'bar', '-1': 'hello', '-2': 'world']
Object.keys(myArray).length;  // returns 5 (there are 5 keys at this point)
myArray.length;  
```

### Using Object Operations with Arrays

Arrays are objecs, so we can use object operations like `in` and `delete` on arrays. However, we shouldn't use these operators because they sometimes yield surprising results. 

`in`: allows you to see if an Object contains a specific key
- just check if array has certain index by using `length` property

`delete`: removes a property from an object
- use `Array.prototype.splice` to remove elements


## Mutability of Values and Objects

Primitive values are *immutable*. Operations on primitives return a new value of the same type.

Objects are *mutable*: we can modify them without changing their identity. Objects contain data inside themselves, it's this inner data we can change.


## Pure Functions and Side Effects

**Def'n Side Effects.** Changes to the world outside the Function. Remember, we've seen Functions:
- modify variables defined in outer scopes
- mutate Objects passed to the Function as arguments.

**Def'n Pure Function.** When a Function has no side effects and always has the same return values given the same arguments. 

*Pure functions always return values (otherwise it wouldn't do much of anything)*

### Pure Function Return Value vs Non-Pure Function Side Effects

If we use a function for its return value, we usually want the function call as part of an expression (as the right hand side of an assignment). These functions usually avoid non-obvious side effects.

If we want to use a function for a side effect, try to pass the variables we will mutate as arguments.


## Working with the Math Object

Methods covered in these exercises:
- `Math.PI`
- `Math.abs(number)`
- `Math.sqrt(number)`
- `Math.pow(base, power)`
- `Math.round(number)`: rounds to nearest int
- `Math.floor(number)`
- `Math.ceil(number)`
- `Math.random`: returns random float between `0` and `1`, excluding `1`.


## Working with Dates

- `new Date()`: current date and time
- `Date.getDay()`: returns the day of the week (0-6)
- `Date.getDate()`: returns day of the month (1-31)
- `Date.getMonth()`: returns month of the year (0-11)
- `Date.getFullYear()`
  - DEPRECATED: `Date.getYear()`
- `Date.getTime()`: milliseconds since Jan 1st, 1970


## Working with Function Arguments

Earlier we saw that:
- not passing in arguments assigns the local variable to `undefined`
- passing in extra arguments leads to the extra arguments being ignored

We can circumvent these limitations and handle an arbitrary number of arguments with the following techniques...

### The Traditional Approach

The `arguments` object is an *Array-like* local variable that is available inside all Functions. It contains *all* arguments passed to the Function, regardless of how many arguments are defined. 
``` js
function logArgs(a) {
  console.log(arguments[0]);
  console.log(arguments[1]);
  console.log(arguments.length);
}

logArgs(1, 'a');

// logs:
1
a
2
```
`arguments` is Array-like in that we can use bracket notation to access values and that is has a `length` property. That's it. 

We can create an Array from `arguments` object with this:
``` js
let args = Array.prototype.slice.call(arguments);
```

#### Functions that accept any number of arguments

``` js
function sum() {
  let result = 0;
  for (let index = 0; index < arguments.length; index += 1) {
    result += arguments[index];
  }

  return result;
}

sum();                 // 0
sum(1, 2, 3);          // 6
sum(1, 2, 3, 4, 5);    // 15
```

Note: the definition of `sum` doesn't list any arguments, but we can call the Function with any number of arguments. It makes it a little harder to read - an inherent weakness of using the `arguments` object.

### The Modern Approach

In ES6 we can use **rest parameters** (instead of the `arguments` object).
``` js
function logArgs(...args) { // 3 periods followed by an array name
  console.log(args[0]);
  console.log(args[1]);
  console.log(args.length);
}

logArgs(1, 'a');

// logs:
1
a
2
```
Above, `...args` tells JS to expect any number of arguments (0 or more). 

In this case, the array used in rest parameters is a genuine array. 

**In general, we should use rest parameters instead of the `arguments` object.**


## Practice Problem: Welcome Stranger

Write a function that takes two arguments, an array and an object. The array will contain two or more elements that, when combined with spaces, produce a person's full name. The object will contain two keys, `title` and `occupation`, and suitable values for both items. Your function should log a greeting to the console that uses the person's full name, and mentions the person's title and occupation.

``` js
function greetings(name, occupation) {
  let fullName = name.join(' ');
  let jobTitle = String(occupation.title) + ' ' + String(occupation.occupation);

  console.log(`Hello, ${fullName}! Nice to have a ${jobTitle} around.`)
}
```


## Practice Problem: Repeated Characters

mplement a function that takes a `String` as an argument and returns an object that contains a count of the *repeated* characters.

Note that `repeatedCharacters` does a bit more than simply count the frequency of each character: it determines the counts, but only returns counts for characters that have a count of 2 or more. It also ignores the case.

``` js
function repeatedCharacters(string) {
  let count = {};
  string = string.toLowerCase();

  for (let index = 0; index < string.length; index++) {
    let currentChar = string[index]
    if (Object.keys(count).includes(currentChar)) {
      count[currentChar] += 1;
    } else {
      count[currentChar] = 1;
    }
  }

  let allChars = Object.keys(count)
  for (let char of allChars) {
    if (count[char] === 1) {
      delete count[char];
    }
  }

  return count;
}
```



