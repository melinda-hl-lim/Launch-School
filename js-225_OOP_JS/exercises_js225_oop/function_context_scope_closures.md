## 1. What is This

What will the following code log?

``` js
const person = {
  firstName: 'Rick ',
  lastName: 'Sanchez',
  fullName: this.firstName + this.lastName,
};

console.log(person.fullName);
```

The code will log `NaN`. 

**Anywhere outside a function, the keyword `this` is bound to the global object.** 

Since `window.firstName` and `window.lastName` are not defined, the operation performed is `undefined + undefined` which evaluates to `NaN`. 


## 2. The Franchise

The method `franchise.allMovies` is supposed to return the following array:
``` 
[
  'How to Train Your Dragon 1',
  'How to Train Your Dragon 2',
  'How to Train Your Dragon 3'
]
```

Explain why this method will not return the desired object. Try fixing this problem by taking advantage of JS lexical scoping rules.

``` js
const franchise = {
  name: 'How to Train Your Dragon',
  allMovies() {
    let self = this; // fix
    return [1, 2, 3].map(function(number) {
      return `${self.name} ${number}`; // changed `this` into `self`
    });
  },
};
```

The given code did not log the desired array because `this` within the callback function in `map` referenced the global object, not the `franchise` object. 

Functions that are invoked wtihin methods do not inherit the execution context from the method invocation. To ensure that `this` within the function will reference the `franchise` object, we can declare a local variable `self` and initialize it to the value of `this`. Then within the function, we can change `this.name` to `self.name`. Because of JS closures, `self` still references `this` within the function, thus preserving the execution context.


## 3. The Franchise - Solution 2

Solve the previous problem again by passing a hard-bound anonymous function to `map`.

``` js
const franchise = {
  name: 'How to Train Your Dragon',
  allMovies() {
    return [1, 2, 3].map(function(number) {
      return `${self.name} ${number}`;
    }.bind(this));
  },
};
```


## 4. Our Very Own Bind()

Create a function `myBind` that accepts two arguments: 1) The function to bind, 2) The context object, and returns a new function that's hard-bound to the passed in context object.

``` js
function myBind(func, obj) {
  return function(...args) {
    return func.apply(obj, args);
  };
}
```

LS discussion:

The above solutions leverages Function.prototype.apply and the concept of closures to return a bound function. `myBind` receives a function and a context object as arguments. Then it returns a new function, which when called will call the original function using `apply` while passing in the `args` array in case the function has any arguments.


## 5. myBind() Improved

The earlier implementation of `myBind` was simplistic. `Function.prototype.bind` has another trick up its sleeve - it's called partial function application. 

Alter the `myBind` function written in the previous exercise to support partial function application.

``` js
function myBind(func, context, ...partialArgs) {
  return function (...args) {
    const fullArgs = partialArgs.concat(args);
    return func.apply(context, fullArgs);
  };
}
```


## 6. myFilter()

In this exercise, we'll update the implementatino of `myFilter` by adding the functionality of accepting an optional `thisArg` just like the original `Array.prototype.filter`.

Modify the original (given) implementation. Don't use the `thisArg` argument of `Array.prototype.forEach`.

``` js
function myFilter(array, func) {
  const result = [];

  array.forEach(value => {
    if (func(value)) {
      result.push(value);
    }
  });

  return result;
}

const filter = {
  allowedValues: [5, 6, 9],
};

myFilter([2, 1, 3, 4, 5, 6, 12], function(val) {
  return this.allowedValues.includes(val);
}, filter); // returns [5, 6]
```

Solution: 
``` js
function myFilter(array, func, thisArg) {
  const result = [];

  array.forEach((value) => {
    if (func.call(thisArg, value)) {
      result.push(value);
    }
  });

  return result;
}
```


## 7. Garbage Collection

Read the folllowing code carefully. Will the JS garbage collection mechanism garbage collect the variable `count` after the function `counter` is run on line 10?

``` js
function makeCounter() {
  let count = 1;

  return () => {
    console.log(count++)
  };
}

const counter = makeCounter();
counter();
```

No. The variable `count` will not be garbage collected after `counter` is run on line 10. The function assigned to `counter` references the `count` variable through closing over the parent scope in which `count` exists. As long as `counter` exists, the variable `count` is required for it to function properly.


## 8. Make a Stack

A stack is a compound data type like an array. The difference between an array and a stack is that in an array you can insert and remove elements in any order you want, but a stack has a rule whereby you can only add new elements at the end and remove the last inserted element.

Create a function `newStack` that when called returns a stack object with three methods: 
- `push` takes a value and inserts it at the end of the stack
- `pop` removes the last element from the stack
- `printStack` logs each remaining element of the stack on its own line. 

Internally, use an array to implement the stack. Make sure that the array is not accessible from outside the methods. 

``` js
function newStack() {
  const stack = [];

  return {
    push(elem) {
      stack.push(elem);
    },

    pop() {
      return stack.pop();
    },

    printStack() {
      stack.forEach((elem) => console.log(elem));
    },
  };
}
```


## 9. Don't Pollute My Window

Consider the following code:

``` js
const name = 'Naveed';
const greeting = 'Hello';

const greeter = {
  message: `${greeting} ${name}!`,
  sayGreetings() {
    console.log(this.message);
  }
};
```

We want to change the code such that:
- we have no global variables `name` or `greeting`
- we still use variables and string interpolation to create the message

``` js
const greeter = {
  message: (() => {
    const name = 'Naveed';
    const greeting = 'Hello';
    return `${greeting} ${name}!`;
  })(),
  sayGreetings() {
    console.log(this.message);
  },
};
```


## 10. School Improved

Melinda has not done this problem...