## Objects and Methods

**Methods vs. Functions:**
- Methods are Functions with a receiver (i.e. object the method is called on)
  - Object methods are properties that happen to have a Function value
- Thus, if a method has no explicit receiver, it's a function

``` js
let greeter = {
  morning: function() {
    console.log('Good morning!');
  },
};

function evening() {
  console.log('Good evening!');
}

// METHOD INVOCATION
greeter.morning();   // greeter is the receiver/calling object; morning() is a method

// FUNCTION INVOCATION
evening();           // there is no explicit receiver; evening() is a function
```

**`this` during method invocations**

The value of `this` is a reference to the object itself.

*From next lesson*: Every function has a context assigned at execution time - JS assigns the context automatically when a function call uses the `()` syntax.


## Walkthrough: Object Methods

Goal: learn how to use functions inside objects as methods.

We ended up creating a person management system with CRUD for each person object...

``` js
let people = {
  collection: [me, friend, mother, father],
  fullName: function(person) {
    console.log(`${person.firstName} ${person.lastName}`);
  },

  rollCall: function() {
    this.collection.forEach(this.fullName);
  },

  add: function(person) {
    this.collection.push(person);
  },
}
```

## Practice Problems: Objects

We're creating a JS object to help us keep track of invoices.

1. Create new object `invoices` - requires property named `unpaid` that is initially an empty array

2. Write a method `add` for the `invoices` object. It takes two arguments: a string for client name, and a number for amount owed. `add` creates a new object with two arguments as properties, and pushes them onto the `unpaid` array.

3. Create a method on `invoices` object named `totalDue` - iterates over the `unpaid` array and computes the total `amount` for its contents. Returns the total at the end of the method.

4. Test the `totalDue` method.

5. Add a `paid` property to the `invoices` object and initialize it as an empty Array - store paid invoices here.

Then create a method named `payInvoice` that takes a client name as an argument. Method should iterate over unpaid invoices and check the name of each invoice - if name matches, push invoice to `paid` property; if name does not match, push invoice object to new array defined as local variable in method. When loop ends, replace existing unpaid property with newly created array of remaining unpaid invoices. 

6. Create a method that is functionally identical to the `totalDue` method, but that computes and returns the total of the paid invoices. Name this new method `totalPaid`.

``` js
const invoices = {
  // 1, 5
  paid: [],
  unpaid: [],
  // 2
  add(name, amount) {
    this.unpaid.push({
      name,
      amount,
    });
  },
  // 3
  totalDue() {
    return this.unpaid.map((invoice) => invoice.amount)
      .reduce((total, amount) => total + amount);
  },
  // 5
  payInvoice(name) {
    let unpaid = [];
    let i;

    for (i = 0; i < this.unpaid.length; i += 1) {
      if (name === this.unpaid[i].name) {
        this.paid.push(this.unpaid[i]);
      } else {
        unpaid.push(this.unpaid[i]);
      }
    }

    this.unpaid = unpaid;
  },
  // 6
  totalPaid() {
    return this.paid.map((invoice) => invoice.amount)
      .reduce((total, amount) => total + amount);
  },
};
```


## Mutating Objects

Most JavaScript Objects are mutable. 

Recall: JS *primitive types are immutable* - we can replace them with another value, but the original value doesn't change. Variables store the primitive values *in* themselves.

A simple variable passed as an argument to a Function:
``` js
function change(a) {
  a = 2;
  console.log(a);
}

var b = 1;
change(b);          // => 2
console.log(b);     // => 1
```
Note: the Function can't change the value of a primitive variable that it received as an argument.

*With Objects*, however, the variable holds a **reference** to the Object:
``` js
function increment(thing) {
  thing.count += 1;
  console.log(thing.count);
}

let counter = { count: 0 };
console.log(counter) // { count: 0 }
increment(counter);
console.log(counter) // { count: 1 }
```
Above, when we pass `counter` to `increment`, JS places an identical reference to `thing` making both `thing` and `counter` variables reference the same Object.

**NOTE TODO**: There's a video linked at the end of this lesson. Must watch!


## Practice Problems: Mutating Objects

4. What will the code log to console?
``` js
let a = 10;
let obj = {
  a
}

let newObj = obj;
newObj.a += 10;

console.log(obj.a === a);
console.log(newObj === obj);
```

It first logs `false`, then `true`. 

Primitive values are immutable and `newObj.a += 10` reassigns the property `a` to a new value. Therefore, the first `console.log` line returns `false`.

Objects are mutable, so `newObj` (which references the same object assigned `obj`) can be altered without breaking the reference to the object in memory.

5. Consider the code below:
``` js
let animal = {
  name: 'Pumbaa',
  species: 'Phacochoerus africanus',
};

let menagerie = {
  warthog: animal,
};

animal = {
  name: 'Timom',
  species: 'Suricata suricatta',
};

menagerie.meerkat = animal;

menagerie.warthog === animal; // false
menagerie.meerkat === animal; // true
```

If objects are mutable, why does the second to last line return false?

Line 10 creates a new object and assigns it to `animal`, reassigning the variable rather than mutating the original value. This new object isn't the same as the object initialized on line 1, and as a result, line 17 evaluates to `false`, and line 18 evaluates to `true`.


## Functions as Object Factories

An Object is a useful organizational tool that collects related data and behaviour together. These benefits become evident when an application uses more than one instance of a given Object type.

One way to create objects is using functions, a.k.a. an **object factory**. 

### Problems: The creation of the `makeCar` Object Factory

**Context:** We want to design an object that represents a vehicle. We can start with:

``` js
let sedan = {
  speed: 0,
  rate: 8,
  accelerate() {
    this.speed += this.rate;
  },
};
```

However, if we need another car, we have no easy way to make another except to duplicate the code. We can also make:

``` js
let coupe = {
  speed: 0,
  rate: 12,
  accelerate() {
    this.speed += this.rate;
  },
};
```

With code duplication, it's *hard to see what attributes of each car define their identity*: what makes them similar, and what makes them unique?

**To clarify similarities and differences in code**, we can move the object similarities into one location (object factory Function) and set the differences when we define individual objects.

1. Write a `makeCar` function that works as shown above.

``` js
function makeCar(rate) {
  return {
    speed: 0,
    rate,

    accelerate() {
      this.speed += this.rate;
    },
  }
}
```

2. Use your new definition of `makeCar` to create a hatchback car whose rate of acceleration is 9 mph/s.

``` js
let hatchback = makeCar(9);
```

3. Our application now needs to handle braking to slow down. Extend the code from problem 1 to handle specifying a braking rate for each car. Also, add a method that tells the car to apply the brakes for one second. 

``` js
function makeCar(accelRate, breakRate) {
  return {
    speed: 0,
    accelRate,
    breakRate,
    accelerate() {
      this.speed += this.accelRage;
    },
    break() {
      this.speed -= this.breakRate;
      if (this.speed < 0) {
        this.speed = 0;
      }
    },
  }
}
```


## Practice Problems: Functions as Object Factories

Goal: Develop a factory function for objects representing countries. 

Requirements:
- Implement a factory function for our country objects following the given template:

``` js
let chile = makeCountry('The Republic of Chile', 'South America');
let canada = makeCountry('Canada', 'North America');
let southAfrica = makeCountry('The Republic of South Africa', 'Africa');

chile.getDescription();       // "The Republic of Chile is located in South America."
canada.getDescription();      // "Canada is located in North America."
southAfrica.getDescription(); // "The Republic of South Africa is located in Africa."
```
- The country object should also have a `visited` property, with the default value being `false` if no argument is provided
- A method `visitCountry` that sets the `visited` property to `true`
- Update `getDescription` function to reflect the `visited` data. 

``` js
function makeCountry(name, continent, visited = false) {
  return {
    name,
    continent,
    visited,
    getDescription() {
      return `${this.name} is located in ${this.continent}.. I ${this.visited ? 'have' : 'haven\'t'} visited ${name}.`;
    },
    visitCountry() {
      this.visited = true;
    }
  }
}
```


## Object Orientation

Objects:
- organize related data and code together
- are useful when a program needs more than one instance of something
- become more useful as the codebase size increases

At its core, object-oriented programming is a pattern that uses objects as the basic building blocks of a program instead of local variables and functions.

The object-oriented approach to programming puts data and procedures that manipulate that data into objects, containers for that data.

By doing so, we:

- Abstract away some complexity: 
We no longer deal soley with primitives; instead, we have "smart" objects that can perform actions on the data they own. This way we move complexity inside objects instead of exposing it globally.

- Limit ripple effects of changing code: 
When we must make changes, we can restrict those changes to those objects; they don't ripple throughout the entire project. Maintenance is easier when we can limit the scope of changes.

- Make the code easier to read and understand: 
It's easier to understand the important concepts in the program, the properties of the object, how to create the object, what operations can be performed on the object, and where we should add new properties and methods.


## Practice Problems: Object Orientation

Goal: Build an object-oriented inventory management system

Requirements:
- item has properties `id`, `name`, `stock`, and `price`
- function to set the price of a product
  - args: product object and non-negative number
  - if price is >= 0, then set the new price for the object. 
  - if price is <0, then return an alert 'invalid price'
- function to output descriptions of products
  - arg: product object
  - output: name, id, price, stock
- create two products: scissors and drill

``` js
function createProduct(id, name, stock, price) {
  return {
    id,
    name,
    stock,
    price,
    setPrice(newPrice) {
      if (newPrice >= 0) {
        this.price = newPrice;
      } else {
        alert('Invalid price!');
      }
    },
    describe() {
      console.log(`Name: ${this.name}`);
      console.log(`ID: ${this.id}`);
      console.log(`Price: $${this.price}`);
      console.log(`Stock: ${this.stock}`);
    },
  };
}

const scissors = createProduct(0, 'scissors', 10, 5);
const drill = createProduct(1, 'drill', 35, 10);
```


## Summary

- Object-oriented programming is a pattern that uses objects to organize code instead of Functions. Objects can also contain data or state.

- You can call the property of an object a method when the value you assign to it is a function.

- When you invoke an object's methods, they can access the object to which they belong by using this.

- Objects become more useful as projects become larger and more complicated.
