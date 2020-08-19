## Introduction

Programming can be separated into two steps:
1. Understanding the problem to be solved and building a mental model to solve the problem abstractly
2. Implement the model and code it

We will be focusing on the first step.

Learning objectives of the course:
- thinking logically: analyzing the problem and solutions paths; center and edge cases
- thinking procedurally and the bottom-up, imperative solution expressions
- thinking abstractly and the top-down, declarative solution expressions
- common problem-solving patterns

Useful JS review links:
- `let` and `const`: https://launchschool.com/gists/8d57ccb1
- arrow functions: https://launchschool.com/gists/0c48e9dc
- strict mode: https://launchschool.com/gists/406ba491
- syntactic sugar: https://launchschool.com/gists/2edcf7d7


## Passing Fucntions as Arguments

Functions are *first-class values* in JS. We can store them in variables and pass them as arguments to other Functions. We can combine multiple Functions, each with a simple behaviour, to create complex behaviours.

**Abstractions allow code to specialize.** We want to organize code by its simplest purpose and responsibility.

**Passing functions as arguments:** allows us to control more aspects of the behaviour. 

Look at the two implementations of the same behaviour:
``` js
// initialize an array for both code blocks
let count = [1, 2, 3, 4];

// one function to iterate and log elements of an array
function iterate(array) {
  for (let i = 0; i < array.length; i += 1) { 
    console.log(array[i]);                    
  }
}

// one function that iterates through an array
// receives a function as an argument to "do a thing" to the element
function iterate(array, callback) {
  for (let i = 0; i < array.length; i += 1) { 
    callback(array[i]);                       
  }
}

function logger(number) {
  console.log(number);
}

iterate(count, logger);
```

**Behaviour as arguments to allow abstractions:** when a Function takes an argument that contains a function expression, the argument provides supplemental behaviour for the Function. 

This allows us to write a Function that solves a *specific problem*: iterate through an array and log the elements. We now can also write an *abstraction*: iterate through an array and do something.


## Declarative Programming with Abstractions

**Imperative programming**: focuses on the steps or mechanics of solving the problem.

**Declarative programming**: We tell the computer *what* to do, not *how* to do it. The higher level of abstraction, the more declarative your code is.

*We raise the abstraction level of a program by moving from "how to do something" to "what we need to do".*

For example, we increase the level of abstraction by extracting specific implementation into a function's body.
- By storing code to find odd numbers in Function `isOdd`, we change the though process from "how do we find odd numbers" to "we find the odd numbers"

``` js
let array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

function isOddNumber(number) {
  return number % 2 === 1;
}

// filtering for odd numbers
let oddNumbers = array.filter(element => isOddNumber(element));

// filtering with abstraction that reflects the purpose clearly
let oddNumbers = array.filter(isOddNumber);
```

The second code snippet:
- is more readable since it fits the mental model of the problem
- more conscise
- more robust since we now use a built-in abstraction instead of writing our own implementation


## List Processing Abstractions

Each Array method listed takes a Function as an argument. This Function implements an abstraction of some sort, and the method invokes this Function for each element in the Array. The developer defines how to implement the chosen abstraction. Because the methods "call back" the Function, we often refer to this Function as a callback.

See table here: https://launchschool.com/lessons/bfc761bc/assignments/d2af4ac0


## Iteration

Iterate over a JS Array with the `forEach` method:
``` js
let names = ['Eunice', 'Lucas', 'Mariana'];
names.forEach((name, index, array) => console.log(name, index, array[index]));
```

*Three arguments*:
- value of the current element in the array
- index of current element
- array being processed

`forEach` doesn't use the return value of the callback

*Return value*: returns `undefined`. Therefore `forEach` must have side effects to be useful.

**Building `myForEach`**
``` js
function myForEach(array, func) {
  for (let index = 0; index < array.length; index++) {
    func(array[index], index, array);
  }
}
```


## Filtering/Selection

Filtering is the process of creating a new Array that contains a subset of an existing Array. Use the `filter` method:
``` js
let count = [1, 2, 3, 4, 5];
let filtered = count.filter((number, index, array) => number % 2 === 0);
```

*One argument in `filter`*: a Function object that will be invoked once for each element

Callback function called with three arguments:
- current element in Array
- index of current element
- array being iterated over

Callback returns `true` or `false`

*Return value of `filter`*: a new Array with elements whose return value in callback was `true`

**Building `myFilter`**
``` js
function myFilter(array, func) {
  let filteredArray = [];
  
  array.forEach((element, index, array) => {
    if (func(element, index, array)) {filteredArray.push(element)};
  }) 

  return filteredArray;
}
```


## Transformation

Transformation of an Array is the creation of a new Array that contains values calculated from the values in the original Array. Use `map`:
``` js
let count = [1, 2, 3, 4, 5];
let doubled = count.map((number, index, array) => number * 2);
```

`map` takes one argument: a callback Function.
- It calls the function for each element, passing in three arguments: value of current element, index of current element, array being processed.

Return value of `map`: a new Array containing one element for each element in the original Array - each element is the value returned by the callback Function

**Build `myMap`**
``` js
function myMap(array, func) {
  let newArray = []

  array.forEach((element, index, array) => {
    let transformed = func(element, index, array);
    newArray.push(transformed);
  })

  return newArray;
```


## Reducing

Reduce is a more complex operation: each invocation of the callback affects later invocations. We use the `reduce` method to perform reduce operations:
``` js
function add(previousValue, element) {
  return previousValue + element;
}

let count = [1, 2, 3, 4, 5];
count.reduce(add); 
```

`reduce` takes two arguments:
- required: a callback Function 
- optional: the `initialValue`, the first argument in the first call to the callback function

callback Function takes four arguments: 
- `accumulator`: return value of previous callback invocations
- `currentValue`: value of current element
- `currentIndex`: index of current element
- `array`: array being processed

`reduce` return value: value returned by the final callback invocation

**Build `myReduce`**
``` js
function myReduce(array, func, initial) {
    let value;
  let index;

  if (initial === undefined) {
    value = array[0];
    index = 1;
  } else {
    value = initial;
    index = 0;
  }

  array.slice(index).forEach(element => value = func(value, element));
  return value;
}
```


## Interrogation

Interrogation lets us determine how many of an Array's elements satisfy some condition. We can use two Array methods: `some` and `every`:
``` js
function odd(number) {
  return number % 2 === 1;
}

let count = [1, 2, 3, 4, 5];
count.some(odd);             
count.every(odd);
```

`some` and `every` both take one argument: a callback Function

The callback function is passed three arguments: value of current element, index of current element, array being processed

Return value of `every`: `false` if at least one callback function returns `false`; `true` otherwise

Return value of `some`: `true` if at least one callback function returns `true`; `false` otherwise

**Build `myOwnEvery`**
``` js
function myOwnEvery(array, func) {
  for (let i = 0; i < array.length; i += 1) {
    if (!func(array[i])) {
      return false;
    }
  }

  return true;
}
```

**Note**: If your code needs an early return while processing a list, **use a `for` loop**. The JavaScript list processing abstractions, other than `every` and `some`, all traverse the entire list, and that may be wasted effort.


## Sort

Review when making cheatsheet: https://launchschool.com/lessons/bfc761bc/assignments/936f8325

Sort lets use rearrange the elements of an Array from lowest to highest or vice versa, based on any desired criteria. We use the `sort` method to do so.

`sort` takes a callback function as an argument
`sort` performs an **in-place** sort of the Array (it mutates the Array), and returns a reference to the sorted Array.

``` js
function compareScores(score1, score2) {
  if (score1 < score2) {
    return -1;
  } else if (score1 > score2) {
    return 1;
  } else {
    return 0;
  }
}

let scores = [5, 88, 50, 9, 60, 99, 12, 23];
scores.sort(compareScores); // [ 5, 9, 12, 23, 50, 60, 88, 99 ]
scores;  // mutated to [ 5, 9, 12, 23, 50, 60, 88, 99 ]
```


## Combining Abstractions

We see how to use multiple Array processing methods in conjunction to solve a more complex problem: given an array of names, find the most common first letter.

Techniques learnt:
- Break problem down into English steps and describe the return value/result of each step
- Then to plan the problem further, label the abstraction (i.e. processing action) and method name to each step

Review tables and whole process: https://launchschool.com/lessons/bfc761bc/assignments/6e5fb053


## Functional Abstractions on Objects

JS doesn't have a set of built-in higher-order functions for Objects as it does for Arrays. However, we can use `Object.keys` or `Object.values` to work with objects with higher-level abstractions.

**Iteration**: iterate over an object's keys and values by:
- using `Object.keys` to get an array of keys
- calling `forEach` on the Array of keys

**Map, Reduce, Filter and More?**

If we have to iterate over an Object's keys or values, we have to *rely on side effects* to build up a new data structure.


## Don't Be Afraid to Use Low Level Abstraction

Sometimes the top-down, abstraction-focused problem solving approach won't yield the best results. Sometimes there is no good abstraction. 


---


## Practice Problems

### Total Square Area 

For this problem, we represent rectangesl as Arrays with two elements: a height and a width.

Write a Function named `totalArea` that takes an Array of rectangles as an argument. The Function should return the total area covered by all the rectangles. 

Given test case:
``` js
let rectangles = [[3, 4], [6, 6], [1, 8], [9, 9], [2, 2]];

totalArea(rectangles);    // 141
```

**Planning**
Input: an Array of rectangles (array of arrays)
Output: the total area of all rectangles (a number)

Steps:
  - Initialize running total to 0 -- number
  - Iterate through each rectangle 
    - Find the rectangle's area -- number
    - Add it to a running total -- number
  - Return running total
Or...
  - create an array of areas (map)
  - add all areas together (reduce)

``` js
function totalArea(rectangles) {
  let areas = rectangles.map(rectangle => rectangle[0] * rectangle[1]);
  let totalAreas = areas.reduce((sum, area) => sum + area);
  return totalAreas;
}
```

Now write a second function `totalSquareArea` that calculates the total area of a set of rectangles, but only includes squares in its calculations - ignore rectangles that aren't squares.

**Planning**

Steps:
  - filter through rectangles to find only squares
  - call totalArea on remaining squares

``` js
function totalSquareArea(rectangles) {
  let squares = rectangles.filter(rectangle => rectangle[0] === rectangle[1]);
  return totalArea(squares);
}
```


### Processing Releases

Write a Function named `processReleaseData` that processes the following movie release data:

``` js
let newReleases = [
  {
    'id': 70111470,
    'title': 'Die Hard',
    'boxart': 'http://cdn-0.nflximg.com/images/2891/DieHard.jpg',
    'uri': 'http://api.netflix.com/catalog/titles/movies/70111470',
    'rating': [4.0],
    'bookmark': [],
  }, 
  /// ... more data
```

The Function should generate an Array of Objects that contain only the `id` and `title` key/value pairs. You may assume that `id` and `title`, when existing, is an integer greater than `0` and non-empty string.

Keep only releases that have both `id` and `title` present. Keep only the `id` and `title` data for each release.

``` js
// sample return value
[{ id: 70111470, title: 'Die Hard'}, { id: 675465, title: 'Fracture' }];
```

**Planning**

Input: an array of objects
Output: an array of objects

Steps:
  - Filter through every movie data object to keep the ones with ids and titles
  - Collect the id and title for every remaining movie data object (map)

``` js
function processReleaseData(data) {
  return data.filter(datum => datum.id && datum.title)
             .map(datum => {
                return {
                  id: datum.id,
                  title: datum.title,
                };
              });
}
```


### Octal

Write a Function named `octalToDecimal` that performs octal to decimal converesion. When invoked on a String that contains the representation of an octal number, the Function returns a decimal version of that value as a Number. (We need to implement the conversion ourselves).

**Planning**

Input: an octal number (string)
Output: a decimal number (number)

Steps:
  - Split the input into an array of digits
    - Reverse the order for ease of calculations
  - Iterate backwards through the octal number
    - Change each digit into decimal form by doing math things
  - Add them all together

``` js
function octalToDecimal(octalString) {
  let decimalParts = octalString.split('').map((digit, index) => {
    return Number(digit) * Math.pow(8, numberString.length - index - 1);
  })

  return decimalParts.reduce((sum, decimal) => sum + decimal);
}
```


### Anagrams

Write a Function named `anagram`. 

Two arguments:
- a word
- an array of words

Return: an array containing all the words from the array argument that are anagrams

**Planning**
Goal: find all anagrams of word
  - find all words with same characters as word

Steps:
  - sort word into list of characters in order
  - iterate through list of words
    - sort each word into list of characters in order
    - if character lists match that of word argument, add current word to list of anagrams
  - return list of anagrams

``` js
function anagram(word, list) {
  return list.filter(candidate => areAnagrams(candidate, word));
}

function areAnagrams(source, target) {
  let sourceLetters = source.split("").sort();
  let targetLetters = target.split("").sort();
  return compareArrays(sourceLetters, targetLetters);
}

function compareArrays(array1, array2) {
  if (array1.length !== array2.length) {
    return false;
  }

  return array1.every((elem, idx) => elem === array2[idx])
}
```


### Formatting Bands

Given the following Array of band information:
``` js
let bands = [
  { name: 'sunset rubdown', country: 'UK', active: false },
  { name: 'women', country: 'Germany', active: false },
  { name: 'a silver mt. zion', country: 'Spain', active: true },
];
```

We need to clean the data:
- band countries should all have 'Canada' as the country
- band name should have all words capitalized
- remove all dots from band names

``` js
function processBands(bands) {
  return bands.map(band => {
    let capitalizedName = capitalizePhrase(band.name);
    let newBandName = removeDotsInString(capitalizedName);

    return {
      name: newBandName,
      country: 'Canada',
      active: band.active,
    };
  });
}

function capitalizePhrase(phrase) {
  return phrase.split(' ')
               .map(word => capitalizeString(word))
               .join(' ');
}

function capitalizeString(string) {
  let initial = string[0].toUpperCase();
  let rest = string.slice(1, string.length);
  return initial + rest;
}

function removeDotsInString(string) {
  return string.replace(/\./g, '');
}
```


### Class Records Summary

At the end of each term, faculty members need to prepare a class record summary for students based on the weighted scores of exams and exercises. In this practice problem, we will prepare one such summary from some provided student records.

Exams: 
- weighted 65%
- four each term
- max score of 100

Exercises:
- weighted 35%.
- maxmium total points of 100 (for all exercises)

Calculation:
- compute average exam score
- calculate total exercise score
- apply weights and round to nearest percentage
- look up letter equivalent

Data format:
``` js
let studentScores = {
  student1: {
    id: <idNumber>,
    scores: {
      exams: [],
      exercises: [],
    },
  },
  // more students...
```

Output format:
``` js
{
  studentGrades: [ '87 (B)', '73 (D)', '84 (C)', '86 (B)', '56 (F)' ],
  exams: [
    { average: 75.6, minimum: 50, maximum: 100 },
    { average: 86.4, minimum: 70, maximum: 100 },
    { average: 87.6, minimum: 60, maximum: 100 },
    { average: 91.8, minimum: 80, maximum: 100 },
  ],
}
```

**Planning**

We want to extract these sets of data from the records:
- each student's exam and exercise scores (grouped by student)
- each exam's scores (grouped by exam)

Then we can do whatever calculations need to be done.

``` js
function studentGrades(records) {
  let students = Object.keys(records);
  students.map(student => {
    return {
      exams: records[student].scores.exams,
      exercises: records[student].scores.exercises,
    }
  });
  return students;
};
```


### Even more exercises

More exercises on list processing: https://launchschool.com/exercise_sets/8023101b