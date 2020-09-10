## Closures and Function Review

All functions obey the same lexical scoping rules:
- they can access any variable defined within it
- they can access any variables that were in scope based on the context where the function was *defined*

Linked review: https://launchschool.com/lessons/7cd4abf4/assignments/0b1349b7

Optional Closures reading: https://medium.com/dailyjs/i-never-understood-javascript-closures-9663703368e8


## Higher-Order Functions

**Higher-order Functions** work with other functions. They can:
- accept a function as an argument (input value is a function)
- return a function when invoked (output value is a function)
- do both! 

*Side note: First-class Functions* means that the language treats functions as values that you can assign to a variable, pass around, ... 

The two concepts are distinct, but closely related.

In JS, functions are first-class functions so we can think of them as values, objects. 

**Examples of Higher-order Functions**

We've already seen higher-order functions that take other functions as arguments:
``` js
[1, 2, 3, 4].forEach(function(number) {
  console.log(number);
});
```

Now here's an example of a higher-order function returning a function:
``` js
function helloFactory() {
  return function() {
    console.log('hi');
  };
}

// helloFactory() returns a function
helloFactory();              
// => function() {...} 

// immediate function invocation of return value
helloFactory()();           
// => hi

// storing returned function in a variable and invoking it later
let hello = helloFactory();  
hello();                    
// => hi
```

An example of a higher-order function that takes a function as an argument *and* returns a function:
``` js
function timed(func) {
  return function() {
    let start = new Date();
    func();
    let stop = new Date();
    console.log((stop - start).toString() + ' ms have elapsed');
  };
}
```


## Closures and Private Data

Functions *close over* or *enclose* the context at their definition point, so we call them closures. They will always have access to that context, regardless of when and where the program invokes the function. 

Here's some code that uses a closure to increment and log a number with each call:
``` js
function makeCounter() {
  let count = 0;       // declare a new variable
  return function() {
    count += 1;        // references count from the outer scope
    console.log(count);
  };
}

let counter = makeCounter();
counter(); // 1
counter(); // 2
```
In the snippet above, within `makeCounter`, `count` is declared and set to `0`. The function returned from `makeCounter` retains access to `count` through a closure. 

When `counter` is invoked, `count` is still accessible within the function's body through a closure. 


Note that `count` is **private data** for the function returned by `makeCounter`. It is only available to the closure formed by the function. The closure makes it **impossible** to access the value of `count` from outside itself:
``` js
let counter = makeCounter();

console.log(count);
// ReferenceError: count is not defined
console.log(counter.count);
// undefined: Declarations inside closures aren't accessible from outside
```


## Practice Problems: Closures

3. Write a function named `later` that takes two arguments: a function and an argument for that function. The return value should be a new function that calls the input function with the provided argument, like this:
``` js
> let logWarning = later(console.log, 'The system is shutting down!');
> logWarning();
The system is shutting down!
```

Solution:
``` js
function later(func, argument) {
  return function() {
    func(argument);
  };
}
```
**Partial application**: the original function already has some of its arguments defined. In effect, the program partiallly applies them ahead of time. Since we already have the arguments' values, we don't need to provide them when we invoke the function. 

Here, `later` partially applies functions that take a single argument. 


## Objects and Closures

We implemented a `makeList` function that provides an interface to `add`, `remove` or `list` items on a private list. 

Here, we use closures to make the `items` data private. 

``` js
function makeList() {
  let items = [];

  return {
    add(item) {
      let index = items.indexOf(item);
      if (index === -1) {
        items.push(item);
        console.log(item + ' added!');
      }
    },

    list() {
      if (items.length === 0) {
        console.log('The list is empty.');
      } else {
        items.forEach(function(item) {
          console.log(item);
        });
      }
    },

    remove(item) {
      let index = items.indexOf(item);
      if (index !== -1) {
        items.splice(index, 1);
        console.log(item + ' removed!');
      }
    },
  };
}
```

We want to make data private to:
- restrict data access so that developers are forced to use the intended interface
- help protect data integrity - since developers must use the defined interface, they can only manipulate the data in certain ways

A drawback of making data private is:
- difficulty extending the code. 

If we want to add a `clear` method, we can't just write: `list.clear = function() { ... }`.
We have to update the original definition of `makeList` to add our `clear` method.


## Project: Banking with Objects and Closures

``` js
function makeBank() {
  const accounts = [],
  
  function makeAccount(number) {
    let balance = 0;
    const transactions = [];

    return {
      number() { return number; },

      balance() { return balance; },

      transactions() { return transactions; },

      deposit(amount) {
        balance += amount;
        transactions.push({ type: 'deposit', amount });
        return amount;
      },

      withdraw(amount) {
        if (amount > balance) {
          amount = balance;
        }
        balance -= amount;
        transactions.push({ type: 'withdrawal', amount });
        return amount;
      },
    };
  }

  return {
    openAccount() {
      const number = accounts.length + 101;
      const newAccount = makeAccount(number);
      accounts.push(newAccount);
      return newAccount;
    },

    transfer(source, destination, amount) {
      return destination.deposit(source.withdraw(amount));
    },
  };
}
```


## Garbage Collection

**Garbage collection** is the process of "automatically" freeing memory up. 

Without garbage collection, developers would have to worry about deallocating memory. With other memory-management tasks the programming flow would look like:
- claiming memory
- test and handle memory allocation errors
- copy value into allocated memory
- use value as intended -- the one step we actually have to do
- releasing memory

Objects and values become *eligible for garbage collection when there are no more references to them*. That is, no more variables, objects or closures maintaining a reference to the object/value.


## How Closures Affect Garbage Collection

When we create a closure, it stores a reference to all variables it (the closure) can access. As long as the closure exists, the variables referenced remain in existence, which means the objects or values referenced can't be garbage collected. 

**Example 1:**

``` js
function makeHello(name) {
  return function() {
    console.log("Hello, " + name + "!");
  };
}

let helloSteve = makeHello("Steve");
```
Once the code above runs, `helloSteve` references a function that closed over the local variable `name`, which contains the string `'Steve'`. 

Since the closure must keep `name` around, the reference to `'Steve'` must also stick around, which means JS can't garbage collect `'Steve'`. 

If we want to *explicitly* remove the closure that has access to `'Steve'`, assign `null` to the item that references it: `helloSteve = null;`.

**Example 2:**

``` js
function makeHello(name) {
  let message = "Hello, " + name + "!";
  return function() {
    console.log(message);
  };
}

let helloSteve = makeHello("Steve");
```
This code returns a function that closes over both the `name` and `message` variables, which reference strings `'Steve'` and `'Hello, Steve!'` respectively. 

In this case, `helloSteve` doesn't reference `name` within its function. *Depending on the browser*, `'Steve'` may or may not be garbage collected. 


## Partial Function Application

Closures let us build useful tools that provide more flexible ways to invoke functions.

**Partial function application** uses a function (*generator*) that creates a new function (*applicator*) to call a third function (*primary*) that the generator receives as an argument. 

``` js
function primaryFunction(arg1, arg2) {
  console.log(arg1);
  console.log(arg2);
}

function generatorFunction(primary, arg1) {
  return function(arg2) { // applicator function
    return primary(arg1, arg2);
  }
}

let applicatorFunction = generatorFunction(primaryFunction, 'Hello');

applicatorFunction('World');   
// Performs primaryFunction('Hello', 'World');
// => Hello
// => World
```
The generator receives some of the primary's arguments, while the applicator receives the rest when it gets invoked. The applicator then calls the primary and passes it all its arguments.

This behavior is made possible by closures. When a new function is created, it retains access to all of the references visible to it in the lexical location of its creation.

Note: terms generator, applicator and primary are LS made up.


Example:
``` js
function add(first, second) {
  return first + second;
}

function makeAddN(addend) {                 
  // Saves addend via closure; uses addend when function invoked.
  return function(number) {                 
    return add(addend, number);             
  }
}

let add1 = makeAddN(1);
add1(1);                           // 2
add1(41);                          // 42

let add9 = makeAddN(9);
add9(1);                           // 10
add9(9);                           // 18
```
The closure allows the applicator functions (`add1` and `add9`) to use the value of `addend` later. 

In effect, closures let us define private data that persists for the function's lifetime. This technique is useful when we need to *package both data and functionality together* - we can pass around functions and not lose the private data. 


*Important side note*: closures and objects both provide the means to organize code into data and a chunk of behaviour that relies on the data. 


## Immediately Invoked Function Expressions

An **immediately invoked function expression (IIFE)** is a function that we define and invoke simultaneously. 

``` js
(function(a) {
  return a + 1;
})(2);  // 3
```

Note the extra `()` around the function expression - these parentheses are a *grouping operator* that controls the evaluation in expressions.

With IIFEs, we use the parentehses to make it explicit that we want to parse the function definition into an expression. As an expression, it means there is a value returned -- the function -- which we can immediately invoke.

**A couple syntax notes:**

This is invalid:
``` js
function() {
  console.log('hello');
}();  // SyntaxError: Unexpected token
```

We can move the arguments list inside the outer set of parentheses:
``` js
(function(a) {
  return a + 1;
})(2);   // 3
```

We can omit the parentehses around an IIFE when the function definition is an expression that doesn't occur at the beginning of a line:
``` js
let foo = function() {
  return function() {
    return 10;
  }();
}();

console.log(foo);       // => 10
```


## Creating a Private Scope with an IIFE

Scenario: imagine we need to add some code into a large and messy JS program. The code we add should loop through and log numbers 0 to 99.

Our solution can use an IIFE:
``` js
// thousands of lines of messy JavaScript code!

(function(number) {
  for (let i = 0; i < number; i += 1) {
    console.log(i);
  }
})(100);

// more messy JavaScript code
```
This way, we:
- *create a private scope* for variables `i` and `number`
  - therefore, we avoid overwriting any variables `i` or `number` that may exist in the global scope
- we avoid overwriting any function names that may already exist (since our IIFE is anonymous)


## Creating Private Data with an IIFE

**Using an IIFE to Return a Function with Access to Private Data**

``` js
let generateStudentId = (function() {
  let studentId = 0;

  return function() {
    studentId += 1;
    return studentId;
  };
})();
```

*Melinda writing*

In the code above, we assign the return value of the IIFE - the anonymous function incrementing and returning `studentId` - to the variable `generateStudentID`. 

When we define the anonymous function, JS closures allow us to maintain reference to the variable `studentId` and it's value. Therefore, the anonymous function can access and modify the value of `studentId`. 

However, since `studentId` was declared within the scope of the IIFE, it is not accessible anywhere outside the already-invoked IIFE and the resulting anonymous function.

Thus, we have created the private data `studentId` and a function that can access said private data. 


**Using an IIFE to Return an Object with Access to Private Data**

``` js
let inventory = (function() {
  let stocks = [];
  function isValid(newStock) {
    return stocks.every(function(stock) {
      return newStock.name !== stock.name;
    });
  }

  return {
    stockCounts() {
      stocks.forEach(function(stock) {
        console.log(stock.name + ': ' + String(stock.count));
      });
    },
    addStock(newStock) {
      if (isValid(newStock)) { stocks.push(newStock) }
    },
  };
})();

```


## Summary

- Closures let a function access any variable that was in scope when the function was defined

- Values that are no longer accessible from anywhere in the code are eligible for **garbage collection**, which frees up the memory that they used for resuse by other parts of the program

- You can use closures to make variables "private" to a function, or set of functions, and inaccessible elsewhere

- Closures allow functions to "carry around" values for later use

- **Higher-order functions** are functions that take a function as an argument, return a function, or both