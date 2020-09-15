## 1. Ancestors

Implement an `ancestors` method that returns the prototype chain (ancestors) of a calling object as an array of object names. Here's an example output: 

``` js
// name property added to make objects easier to identify
const foo = {name: 'foo'};
const bar = Object.create(foo);
bar.name = 'bar';
const baz = Object.create(bar);
baz.name = 'baz';
const qux = Object.create(baz);
qux.name = 'qux';

qux.ancestors();  // returns ['baz', 'bar', 'foo', 'Object.prototype']
baz.ancestors();  // returns ['bar', 'foo', 'Object.prototype']
bar.ancestors();  // returns ['foo', 'Object.prototype']
foo.ancestors();  // returns ['Object.prototype']
```

*Melinda attempt that doesn't work*

``` js
// eslint-disable-next-line no-extend-native
Object.prototype.ancestors = function () {
  const mostRecentAncestor = Object.getPrototypeOf(this);
  
  if (mostRecentAncestor) {
    return [mostRecentAncestor].concat(mostRecentAncestor.ancestors());
  }
  return [];
};
```

*Launch School Solution*

``` js
Object.prototype.ancestors = function ancestors() {
  const ancestor = Object.getPrototypeOf(this);

  if (Object.prototype.hasOwnProperty.call(ancestor, 'name')) {
    return [ancestor.name].concat(ancestor.ancestors());
  }

  return ['Object.prototype'];
};
```


## 2. Delegate

Write a `delegate` function that can be used to delegate the behaviour of a method or function to another object's method. `delegate` takes a minimum of two arguments: (1) the object and (2) name of the method on the object. The remaining arguments, if any, are passed as arguments to the objects' method that it delegates to. 

LS solution: (Melinda couldn't do it...)

``` js
function delegate(context, methodName, ...args) {
  return () => context[methodName].apply(context, args);
}
```

The challenge of this exercise was maintaining the reference to the function and its context. The LS solution handles this by using the concept of closures so that we can return, and consequently assign to a method, a function that maintains a reference to the context object. 


## 3. Classical Object Creation

Implement the following diagram using the pseudo-classical approach. Subclasses should inherit everything from the superclass and not just the methods. Reuse the constructors of the superclass when implementing a subclass.

``` js
function Person(firstName, lastName, age, gender) {
  this.firstName = firstName;
  this.lastName = lastName;
  this.age = age;
  this.gender = gender;
}

Person.prototype.fullName = function () {
  console.log(`${firstName} ${lastName}`);
};

Person.prototype.communicate = function () {
  console.log('Communicating');
};

Person.prototype.eat = function () {
  console.log('Eating');
};

Person.prototype.sleep = function () {
  console.log('Sleeping');
};

function Doctor(firstName, lastName, age, gender, specialization) {
  Person.call(this, firstName, lastName, age, gender);
  this.specialization = specialization;
}

Doctor.prototype = Object.create(Person.prototype);
Doctor.prototype.constructor = Doctor;

Doctor.prototype.diagnose = function () {
  console.log('Diagnosing');
};
```

Learning points:

- use `Function.prototype.call` to have the subclass "inherit" properties from the parent class
- use `Function.prototype = Object.create(obj)` to "inherit" methods from the parent class
- use `Function.prototype.constructor` to manually reset the property to point back to the appropriate constructor


## 4. Classical Object Creation with Mixin

In this exercise, you'll make an `extend` function and use it to add a mixin to the previous exercise. The mixin adds an `invoice` and `payTax` methods.

LS Solution: 
``` js
function delegate(callingObject, methodOwner, methodName) {
  const args = Array.prototype.slice.call(arguments, 3);
  return () => methodOwner[methodName].apply(callingObject, args);
}

function extend(object, mixin) {
  const methodNames = Object.keys(mixin);

  methodNames.forEach(name => {
    object[name] = delegate(object, mixin, name);
  });

  return object;
}

const professional = {
  invoice() {
    console.log(`${this.fullName()} is Billing customer`);
  },

  payTax() {
    console.log(`${this.fullName()} is Paying taxes`);
  },
};

const professor = extend(new Professor('foo', 'bar', 21, 'gender', 'Systems Engineering'), professional);
```

Melinda solution that doesn't work. 
Error: `Uncaught TypeError: Cannot read property 'constructor' of undefined` for the line with originalMixinConstructor

``` js
function extend(object, mixin) {
  const currentAncestor = Object.getPrototypeOf(object);

  // set mixin prototype to current Ancestor
  const originalMixinConstructor = mixin.prototype.constructor;
  mixin.prototype = Object.create(currentAncestor);
  mixin.prototype.constructor = originalMixinConstructor;

  // set object prototype to mixin
  const originalObjectConstructor = object.prototype.constructor;
  object.prototype = Object.create(mixin);
  object.prototype.constructor = originalObjectConstructor;
}
```

There are multiple problems with my solution:
- Firstly, I try to access a `prototype` property on all the objects. This is wrong. The `[[prototype]]` property on objects is actually hidden, and must be acessed with `Object.getPrototypeOf(obj)`. 
  - The `prototype` property I'm confusing it with is that of the constructor function. 
- With my idea of implementation, we will be modifying the prototype chain for that mixin permanently. That means ALL classes that want to use the mixin MUST share the same prototype inheritance chain. This is terrible coding design.


## 5. Anonymizer

Using OLOO create an `Account` prototype object that anonymizes user objects on `init`. The created object should not have accesss to the function that anonymizes a user other than through the `init` and reanonymize methods. The function that anonymizes creates a 16 character sequence composed of letters and numbers. The following are the properties and methods on the `Account` object:

Other than the properties and methods specified and properties inherited from `Object.prototype`, no other method or property should exist on the object returned by the `Account` prototype object.

``` js
const Account = (() => {
  let userEmail;
  let userPassword;
  let userFirstName;
  let userLastName;

  function isValidPassword(testPassword) {
    return userPassword === testPassword;
  }

  function getRandomLetterNumber() {
    const randomIndex = Math.floor(Math.random() * 62);
    return 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRTSUVWXYZ1234567890'[randomIndex];
  }

  function anonymize() {
    let result = '';

    for (let i = 0; i < 16; i += 1) {
      result += getRandomLetterNumber();
    }

    return result;
  }

  return {
    init(email, password, firstName, lastName) {
      userEmail = email;
      userPassword = password;
      userFirstName = firstName;
      userLastName = lastName;
      this.displayName = anonymize();
      return this;
    },

    reanonymize(password) {
      if (isValidPassword(password)) {
        this.displayName = anonymize();
        return true
      } else {
        return 'Invalid Password';
      }
    },

    resetPassword(currentPassword, newPassword) {
      if (isValidPassword(currentPassword)) {
        userPassword = newPassword;
        return true;
      } else {
        return 'Invalid Password';
      }
    },

    firstName(password) {
      if (isValidPassword(password)) {
        return userFirstName;
      } else {
        return 'Invalid Password';
      }
    },

    lastName(password) {
      if (isValidPassword(password)) {
        return userLastName;
      } else {
        return 'Invalid Password';
      }
    },

    email(password) {
      if (isValidPassword(password)) {
        return userEmail;
      } else {
        return 'Invalid Password';
      }
    },
  };
})();
```

## 6. Mini Inventory Management System

In this exercise, you'll build a simple inventory management system. The system is composed of:

- An item creator: makes sure that all necessary information are present and valid

An item requires this information:
- SKU code: UID consisting of first 3 letters of item and the first 2 letters of category. 
- Item name: name of item with minimum of 5 characters. Spaces are not characters.
- Category: consists of 5 characters minimum. Must be 1 word.
- Quantity: this is the quantity in stock of an item. This must not be blank. You may assume that a valid number will be provided.

Items creator: Melinda solution
``` js
const Item = (() => {
  const createSku = (name, category) => {
    const nameSection = name.replace(/\s+/g, '').slice(0, 3);
    const catSection = category.slice(0, 2);
    return nameSection + catSection;
  };

  const validName = (name) => {
    const withoutSpaces = name.replace(/\s+/g, '');
    return withoutSpaces.length >= 5;
  };

  const validCategory = (category) => !(category.includes(' ')) && category.length >= 5;

  return {
    init(name, category, quantity) {
      if (validName(name)) {
        this.name = name;
      } else {
        return 'Invalid name';
      }

      if (validCategory(category)) {
        this.category = category;
      } else {
        return 'Invalid category';
      }

      if (quantity) {
        this.quantity = quantity;
      } else {
        return 'Quantity must be included';
      }

      this.sku = createSku(name, category);

      return this;
    },
  };
})();
```

- An items manager: responsible for creating items, updating information about items, deleting items, and quering info about items

- A reports manager: generates reports for a specific item or ALL items. Reports for specific items are generated from report objects created from the report manager. The report manager is repsonsible for reports for all items.

*Launch School Solution*

The key take-away for this exercise is practicing creating and using objects that interact or collaborate with each other. The notable parts of the solution are the following:

- Using a constructor function that has private methods.
- Having an explicit return value for a constructor function.
- Maintaining a reference to an object using closures (i.e., createReporter method of ReportManager).
