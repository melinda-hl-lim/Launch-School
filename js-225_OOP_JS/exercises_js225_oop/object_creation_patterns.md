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
Object.prototype.ancestors = function ancestors() {
  let object = this;
  const ancestorsList = [];

  while (object) {
    const ancestor = Object.getPrototypeOf(this);
    ancestorsList.push(ancestor);
    object = ancestor;
  }

  return ancestorsList;
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



## 3. Classical Object Creation

## 4. Classical Object Creation with Mixin

## 5. Anonymizer

## 6. Mini Inventory Management System

