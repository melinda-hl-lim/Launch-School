# Arrays

## Array

Arrays are the basic collection type used in JS.

We can create arrays useing a simple Array literal syntax: `[1, 2, 3]` or using the `Array` constructor: `new Array(1, 2, 3);`. 

The main interactions with Arrays are:
- iterating through the array and performing an action on each value
- accessing and manipulating specific elements of the Array

### Iterating Through An Array

`for` loop example:
``` js
let count = [1, 2, 3, 4];
for (let index = 0; index < count.length; index += 1) {
  console.log(count[index]);
}
```

*Note*: The bracket notation for Strings, Arrays and Objects is an operator, not a method.

### Accessing, Modifying and Detecting Values

We can access, modify, or assign a value to an array using bracket notation:
``` js
let fibonacci = [0, 0, 1, 2, 3, 5, 8, 13];

fibonnaci[3]; // Access: 2
fibonnaci[1] = 1 // Modify/assign
fibonnaci[8] = 21; // Add a new value
```

For indexes that don't have a value explicitly assigned, JS designates it as empty. Empty items have no value; when accessed, they return `undefined`. 

### Arrays are Objects

JS Arrays are Objects.
``` js
typeof [];        // "object"
```

To see if a value is an Array, we can use the `Array.isArray` method instead.
``` js
Array.isArray([]);        // true
Array.isArray('array');   // false
```


## Practice Problems: Arrays

1. Write a function `lastInArray` that returns the value of the last element in the array provided by the function's argument.

``` js
function lastInArray(array) {
  return array[array.length - 1];
}

// As a one line function
let lastInArray = arr => arr[arr.length - 1];
```

2. Create a function named `rollCall` that takes an array of first names as an argument and logs all names to console, one name per line. 

``` js
function rollCall(names) {
  for (index in names) {
    console.log(names[index]);
  }
}
```

3. Create a function that returns the contents of the array it receives as an argument, but with the values in reversed order. 

``` js
function reverseArray(array) {
  let reversedArray = []
  for (let index = array.length - 1; index >= 0; index--){
    reversedArray.push(arr[index]);
  }

  return reversedArray;
}
```

4. Write a function that returns a string of all the values in an array with no intervening content. 

``` js
function arrayToString(array) {
  let string = ''
  for (let index = 0; index < array.length; index++){
    string += String(array[index]);
  }

  return string;
}
```


## Array Operations: push, pop, shift, and unshift

Here we will be writing some common array methods. These methods are included in the standard library.

Note the return value, whether the argument is mutated, etc.

JavaScript has an `Array` **global object**; this object has something called a **prototype object**. The prototype object defines the methods for Arrays - all JS arrays inherit from the prototype object.

1. Write a function named `push` that accepts two arguments:
- an array
- any other value
The function should append the second argument to the end of the Array and return the new length of the array.

``` js
function push(array, value) {
  array[array.length] = value;
  return array.length;
}
```

*The actual method is `Array.prototype.push()`. It mutates the array.*

2. Write a function named `pop` that accepts one argument: an Array. The function should remove the last element from the array and return it.

``` js
function pop(array) {
  if (array.length === 0) {return undefined;}

  let poppedElement = array[array.length - 1];
  array.length = array.length - 1;
  return poppedElement;
}
```

*The actual method is `Array.prototype.pop()`. It mutates the array.*

3. Write a function named `unshift` that accepts two arguments: an Array and a value. The function should insert the value at the beginning of the Array and return the new length of the array. 

``` js
function unshift(array, value) {
  for (let index = array.length; index > 0; index--) {
    array[index] = array[index - 1];
  }

  array[0] = value;
  return array.length;
}
```

*The actual method is `Array.prototype.unshift`. It mutates the original array.*

4. Write a function named `shift` that accepts one argument: an Array. The function should remove the first value from the beginning of the array and return it.

``` js
function shift(array) {
  let shiftedValue = array[0];

  if (array.length === 0) {return undefined;}

  for (let index = 0; index < array.length - 2; index++) {
    array[index] = array[index + 1];
  }

  array.length = array.length - 1;
  return shiftedValue;
}
```

*The actual method is `Array.prototype.shift`. It mutates the array.*


## Array Operations: indexOf and lastIndexOf

1. Write a function `indexOf` that accepts two arguments: an array and a value. The function returns the first index at which the value can be found, or -1 if the value is not present.

``` js
function indexOf(array, value) {
  for (let index = 0; index < array.length; index++) {
    if (array[index] === value) {
      return index;
    }
  }

  return -1;
}
```

*The actual method is `Array.prototype.indexOf`.*

2. Write a function `lastIndexOf` that accepts two arguments: an array and a value. The function returns the last index at which the value can be found in the array, or `-1` if the value is not present.

``` js
function lastIndexOf(array, value) {
  for (let index = array.length - 1; index >= 0; index--) {
    if (array[index] === value) {
      return index;
    }
  }

  return -1;
}
```

*The actual method is `Array.prototype.lastIndexOf`.*


## Array Operations: slice, splice, concat, and join

1. Write a function named `slice` that accepts three arguments: an array, a start index, and an end index. The function should return a new Array that contains values from the original Array starting with the value at the starting index, and including all values up to (but not including) the end index. Do not modify the original array.

``` js
function slice(array, start, end) {
  let sliceArray = [];
  for (let index = start; index < end; index++) {
    sliceArray.push(array[index]);
  }

  return sliceArray;
}
```

*Actual method: `Array.prototype.slice`. A different behaviour from our solution: if end index is greater than length of the array the return value of our solution adds `undefined` values.*

2. Write a function named `splice` that accepts three arguments: an Array, a start index, and the number of values to remove. The function should remove values from the original Array, starting with the first index and removing the specified number of values. The function should return the removed values in a new Array.

``` js
function splice(array, start, number) {
  let spliceArray = [];
  let counter = 0;

  while (counter <= number) {
    spliceArray.push(array[start + counter]);
  }

  for (let index = start; index < start + number; index++) {
    array[index] = array[index + number];
  }

  array.length = array.length - number;

  return spliceArray;
}
```

*The method `Array.prototype.splice()` is a little different than what we wrote. You can insert or replace elements at specified indicies.*

3. Write a function named `concat` that accepts two Array arguments. The function should return a new Array that contains the values from each of the original Arrays.

``` js
function concat(array1, array2) {
  let newArray = [];
  for (let index = 0; index < array1.length; index++) {
    newArray.push(array1[index]);
  }

  for (let index = 0; index < array2.length; index++) {
    newArray.push(array2[index]);
  }

  return newArray;
}
```

*The actual method: `Array.prototype.concat`. This method also leaves both original arrays unmodified, and returns a new array.*

4. Write a function named `join` that accepts two arguments: an Array and a String. The function should coerce each value in the Array to a String, and then join those values together using the second argument as a separator. You may assume that a separator will always be passed.

``` js
function join(array, separator) {
  let str = ''

  for (let index = 0; index < array.length; index++) {
    str += String(array[index]);

    if (index < array.length - 1) {
      result += separator;
    }
  }

  return str;
}
```

*The actual method: `Array.prototype.join`.*


## Array Methods

The array methods we have just learnt include:
- push
- pop
- unshift
- shift
- indexOf
- lastIndexOf
- slice
- splice
- concat
- join


## Arrays and Operators

Operators form much of the syntax a rogrammer uses when writing programs. The JS operators we know so far include:
`+, -, *, /, %, +=, -=, ==, !=, ===, !==, >, >=, <, <=`

*However, they're almost useless with Array objects.*

### Arithmetic Operators

Arithmetic operators *convert arrays to strings* before performing the operation. After the conversion, the operation works in the same way as described in the *Implicit Primitive Type Coercions* section.

**The real danger of using operators on arrays isn't the fact that the results are useless. It's because these operations run without producing a warning, making it easy to make new bugs.**

### Comparison Operators

Neither equality `==` or strict equality `===` consider arrays with the same values to be equal. 
``` js
let friends = ['Bob', 'Josie', 'Sam'];
let enemies = ['Bob', 'Josie', 'Sam'];
friends == enemies;                    // false
friends === enemies;                   // false
[] == [];                              // false
[] === [];                             // false
```
These operators are checking to see if it's the same array object. 

*The relational comparison operators, `>, >=, <, and <=`, are useless with arrays and objects. They return true or false in unexpected ways. Don't use them with arrays or objects.*


## Practice Problem: Comparing Arrays

Write a function named `arraysEqual` that takes two arrays as arguments. The function should return `true` if the arrays contain the same values, or `false` if they do not.

``` js
function arraysEqual(array1, array2) {
  if (array1.length !== array2.length) {
    return false;
  }

  for (let index = 0; index < array1.length; index++) {
    if (array1[index] !== array2[index]) {
      return false;
    }
  }

  return true;
}
```


## Practice Problems: Basic Array Uses

1. Write a function that returns the first element of an array passed in as an argument.

``` js
function firstElementOf(arr) {
  return arr[0];
}
```

2. Write a function that returns the last element of an array passed in as an argument.

``` js
function lastElementOf(arr) {
  return arr[arr.length - 1];
}
```

3. Write a function that accepts two arguments, an array and an integer index position, and returns the element at the given index. 

``` js
function nthElementOf(arr, index) {
  return arr[index];
}
```

What happens if the index is greater than the length of the array? *The function will return `undefined`.*

What happens if it's a negative integer? *The function will return `undefined`.*

4. Can we insert data into an array at a negative index? If so, why is this possible?

We can insert data at a negative index because all arrays are objects. I guess we defined a negative index?

The nuance: the added element becomes part of the "array object", but it isn't properly one of the array elements. 

5. Write a function that accepts an array as the first argument and an integer `count`. It should return a new array that contains the first `count` elements of the array.

``` js
function firstNOf(arr, count) {
  return arr.slice(0, count);
}
```

6. Write a function like the previous one, except this time return the last `count` elements as a new array.

``` js
function lastNOf(arr, count) {
  return arr.slice(arr.length - count)
}
```

7. Using the function from the previous problem, what happens if you pass a `count` greater than the length of the array? How can you fix the function so it returns a new instance of the entire array when `count` is greater than the array length?

``` js
function lastNOf(arr, count) {
  let startIndex = arr.length - count;

  if (startIndex < 0) {
    startIndex = 0;
  }
  return arr.slice(startIndex)
}
```

8. Write a function that accepts two arrays as arguments and returns an array with the first element from the first array and the last element from the second array.

``` js
function endsOf(beginningArr, endingArr) {
  return [beginningArr[0], endingArr[endingArr.length - 1]];
}
```


## Practice Problems: Intermediate Array Uses

1. Write a function that creates and returns a new array from its array argument. The new array should contain all values from the argument array whose positions have an odd index.

``` js
function oddElementsOf(arr) {
  let newArray = []
  for (let index = 0; index < arr.length; index++) {
    if (index % 2 === 1) {
      newArray.push(arr[index]);
    }
  }

  return newArray;
}
```

2. Write a function that takes an array argument and returns a new array that contains all the argument's elements in their original order followed by all the argument's elements in reverse order.

``` js
function mirroredArray(arr) {
  let mirrorArray = [];

  arr.forEach(elem => mirrorArray.push(elem));
  for (let index = arr.length - 1; index >=0; index--) {
    mirrorArray.push(arr[index]);
  }

  return mirrorArray;
}

// LS SOLUTION
function mirroredArray(arr) {
  return arr.concat(arr.slice().reverse());
}
```

*Note*: Note that `slice` performs a shallow copy; it doesn't create copies of the element values, just of the array structure. This is usually fine for most duplication operations. However, you should always keep this in mind since both arrays now share the objects stored in each element.

3. Use the array sort method to create a function that takes an array of numbers and returns a new array of numbers sorted in descending order. Do not alter the original array.

``` js
function sortDescending(arr) {
  return arr.sort().reverse(); // alters original array! D:
}

// LS SOLUTION
function sortDescending(arr) {
  let arrCopy = arr.slice();
  return arrCopy.sort((a, b) => b - a);
}
```

4. Write a function that takes an array of arrays as an argument, and returns a new array that contians the sums o each of the sub-arrays.

``` js
function matrixSums(arr) {
  let sums = [];
  for (let index = 0; index < arr.length; index++){
    let currentSum = 0;
    let subarray = arr[index];
    subarray.forEach(element => currentSum += element);
    sums.push(currentSum);
  }
  
  return sums;
}
```

5. Write a function that takes an array, and returns a new array with duplicate elements removed.

``` js
function uniqueElements(arr) {
  let uniqueArray = [];

  arr.forEach(function(element) {
    if (!uniqueArray.includes(element)) {
      uniqueArray.push(element);
    }
  })
  
  return uniqueArray;
}
```


## Practice Problems: Find Missing Numbers

Write a function that takes a sorted array of integers as an argument, and returns an array that includes all the missing integers (in order) between the first and last elements of the argument.

``` js
function missing(array) {
  let missingNums = [];
  let startNum = array[0];
  let endNum = array[array.length - 1];
  let counter = startNum;

  while (counter <= endNum) {
    if (!array.includes(counter)) {
      missingNums.push(counter);
    }
    counter++;
  }

  return missingNums;
}
```


