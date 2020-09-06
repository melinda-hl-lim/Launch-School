## 1. Lettercase Percentage Ratio

Write a function that takes a string, and returns an object containing the following three properties:

- the percentage of characters in the string that are lowercase letters
- the percentage of characters that are uppercase letters
- the percentage of characters that are neither

You may assume that the string will always contain at least one character.

Examples:
``` js
letterPercentages('abCdef 123');
// { lowercase: "50.00", uppercase: "10.00", neither: "40.00" }

letterPercentages('AbCd +Ef');
// { lowercase: "37.50", uppercase: "37.50", neither: "25.00" }

letterPercentages('123');
// { lowercase: "0.00", uppercase: "0.00", neither: "100.00" }
```

Input: a string with at least 1 character
Output: an object with keys: lowercase, uppercase, neither and percentages for each value

Goal: count each character of the given string and categorize as lowercase, uppercase, or neither

Questions:
- do spaces count as a character? 

Data structure: an array of characters

Algorithm
- initialize object to hold char type counts
- convert the input string into an array of characters
  - split('')
- iterate through each character within the array
  - if it's uppercase, add 1 to the uppercase count
  - if it's lowercase, add 1 to the lowercase count
  - otherwise, it's neither - add 1 to the neither count
- return our object that holds char type counts

``` js
function letterPercentages(str) {
  const totalChars = str.length;
  const chars = str.split('');

  const lowerChars = chars.filter((char) => /[a-z]/.test(char));
  const upperChars = chars.filter((char) => /[A-Z]/.test(char));
  const neitherChars = chars.filter((char) => /[^a-z]/i.test(char));

  return {
    lowercase: (lowerChars.length / totalChars) * 100,
    uppercase: (upperChars.length / totalChars) * 100,
    neither: (neitherChars.length / totalChars) * 100,
  };
}
```

## 2. Triangle Sides

A triangle is classified as follows:

- Equilateral: All three sides are of equal length.
- Isosceles: Two sides are of equal length, while the third is different.
- Scalene: All three sides are of different lengths.

To be a valid triangle, the sum of the lengths of the two shortest sides must be greater than the length of the longest side, and every side must have a length greater than 0. If either of these conditions is not satisfied, the triangle is invalid.

Write a function that takes the lengths of the three sides of a triangle as arguments, and returns one of the following four strings representing the triangle's classification: `'equilateral'`, `'isosceles'`, `'scalene'`, or `'invalid'`.

Input: three numbers, each representing a side of a triangle
Output: the type of triangle it is (string)

Rules: 
- Equilateral: all 3 sides are equal
- Isoceles: two side are equal
- Scalene: all sides are different
- Valid: 
  - Sum of two shorter sides > longest side
  - All sides > 0

Algorithm

- Check to see if we were passed in the sides of a valid triangle
- If it's a valid triangle, determine which triangle category it belongs to and return triangle category
  - See if 3 sides equal each other -- it's equilateral
  - See if 2 sides equal each other -- it's isoceles
  - Otherwise, it's scalene

Valid triangle:
- if any of the arguments === 0, return false
- find longest side 
- find shortest side
- find middle side
- return if shortest + middle > longest

``` js
function validTriangle(...sides) {
  if (sides.length !== 3) { return false; }
  if (sides.includes(0)) { return false; }

  const perimeter = sides.reduce((sum, side) => sum + side);

  const longestSide = Math.max(...sides);
  const shortestSide = Math.min(...sides);
  const middleSide = perimeter - longestSide - shortestSide;

  return (shortestSide + middleSide) > longestSide;
}

function triangle(...sides) {
  if (!validTriangle(...sides)) { return 'invalid'; }

  if (sides[0] === sides[1] && sides[1] === sides[2]) {
    return 'equilateral';
  } if (sides[0] === sides[1] || sides[1] === sides[2] || sides[0] === sides[2]) {
    return 'isoceles';
  }
  return 'scalene';
}
```

## 3. Tri-Angless

A triangle is classified as follows:
- Right: one angle is exactly 90 degrees
- Acute: all three angles < 90 degrees
- Obtuse: one angle > 90 degrees

To be a valid triangle, the sum of the angles must be exactly 180 degrees, and every angle must be greater than 0. If either of these conditions is not satisfied, the triangle is invalid.

Write a function that takes the three angles of a triangle as arguments, and returns one of the following four strings representing the triangle's classification: `'right'`, `'accute'`, `'obtuse'`, or `'invalid'`. 

You may assume that all angles have integer values, so you do not have to worry about floating point errors. You may also assume tha the arguments are in degrees.

Examples:
``` js
triangle(60, 70, 50);       // "acute"
triangle(30, 90, 60);       // "right"
triangle(120, 50, 10);      // "obtuse"
triangle(0, 90, 90);        // "invalid"
triangle(50, 50, 50);       // "invalid"
```

*Melinda work*

Input: three angles in degrees (numbers)
Output: string describing type of triangle

Algorithm:
- Check if the angles are that of a valid triangle
  - are any angles 0?
  - is the sum exactly 180 degrees?
- Check if it's a right triangle
  - is one angle exactly 90 degrees?
- Check if it's an obtuse triangle
  - is one angle > 90 degrees?
- If we're here, it's an acute triangle

``` js
function triangle(angle1, angle2, angle3) {
  const validAngles = () => {
    if (angle1 === 0 || angle2 === 0 || angle3 === 0) {
      return false;
    } if (angle1 + angle2 + angle3 !== 180) {
      return false;
    }
    return true;
  };

  const rightTriangle = () => (angle1 === 90 || angle2 === 90 || angle3 === 90);

  const obtuseTriangle = () => (angle1 > 90 || angle2 > 90 || angle3 > 90);

  if (!validAngles()) {
    return 'invalid';
  } if (rightTriangle()) {
    return 'right';
  } if (obtuseTriangle()) {
    return 'obtuse';
  }
  return 'acute';
}
```

Launch School's Solution uses Array methods
``` js
function triangle(angle1, angle2, angle3) {
  const angles = [angle1, angle2, angle3];
  if (isValid(angles)) {
    return getTriangleType(angles);
  } else {
    return 'invalid';
  }
}

function isValid(angles) {
  const totalAngle = angles.reduce((total, angle) => total + angle);

  const allNonZero = angles.every(angle => angle > 0);

  return totalAngle === 180 && allNonZero;
}

function getTriangleType(angles) {
  if (angles.some(testRightTriangle)) {
    return 'right';
  } else if (angles.every(testAcuteTriangle)) {
    return 'acute';
  } else {
    return 'obtuse';
  }
}

function testRightTriangle(angle) {
  return angle === 90;
}

function testAcuteTriangle(angle) {
  return angle < 90;
}
```

## 4. Unlucky Days

Write a function that takes a year as an argument, and returns the number of 'Friday the 13ths' in that year. You may assume that the year is greater than `1752` (when the modern Gregorian Calendar was adopted by the UK). You may also assume that the same calendar will remain in use for the foreseeable future.

``` js
function fridayThe13ths(year) {
  const thirteenths = [];

  for (let i = 0; i < 12; i += 1) {
    thirteenths.push(new Date(year, i, 13));
  }

  return thirteenths.reduce((count, day) => day.getDay() === 5 ? (count + 1) : count, 0);
}
```

## 5. Next Featured Number Higher than a Given Value

A featured number (something unique to this exercise) is an odd number that is a multiple of 7, with all of its digits occuring exactly once each. For example, 49 is a featured number, but 98 is not (it is not odd), 97 is not (it is not a multiple of 7), and 133 is not (the digit 3 appears twice).

Write a function that takes an integer as an argument and returns the next featured number greater than the integer. Issue an error message if there is no next featured number. 

NOTE: the largest possible featured number is `9876543201`.

Examples:
``` js
featured(12);           // 21
featured(20);           // 21
featured(21);           // 35
featured(997);          // 1029
featured(1029);         // 1043
featured(999999);       // 1023547
featured(999999987);    // 1023456987
```

Input: a number
Output: a number (next featured number)

Rules:
- Featured numbers must:
  - be odd
  - be a multiple of 7
  - contain all unique digits

Algorithm
- Check if the given number is a featured number. If so, return itself...?
- Loop until we find a featured number
  - Find the next multiple of 7 following the given number
    - (7 - num % 7) -- the difference between given number and next multiple of 7
    - num + (7 - num % 7) -- should give the next multiple of 7
  - See if this multiple of 7 is:
    - odd
    - contains all unique digits
  - If it's a featured number, break 
- return next featured number 

``` js
function isOdd(num) {
  return num % 2 === 1;
}

function isMultipleOf7(num) {
  return num % 7 === 0;
}

function allUniqueDigits(num) {
  const digits = String(num).split('');
  const nonDuplicates = [];

  digits.forEach((digit) => {
    if (!nonDuplicates.includes(digit)) {
      nonDuplicates.push(digit);
    }
  });

  return digits.length === nonDuplicates.length;
}

function isFeaturedNumber(num) {
  return isOdd(num) && isMultipleOf7(num) && allUniqueDigits(num);
}

function featured(num) {
  let nextMultipleSeven = num + (7 - num % 7);

  while (true) {
    if (isFeaturedNumber(nextMultipleSeven)) { break; }
    nextMultipleSeven += 7;
  }

  return nextMultipleSeven;
}
```

## 6. Sum Square - Square Sum

Write a function that computes the difference between the square of the sum of the first n positive integers and the sum of the squares of the first n positive integers.

Examples:
``` js
sumSquareDifference(3);      // 22 --> (1 + 2 + 3)**2 - (1**2 + 2**2 + 3**2)
sumSquareDifference(10);     // 2640
sumSquareDifference(1);      // 0
sumSquareDifference(100);    // 25164150
```

First find:
  - square of the sum of first `n` integers
    - sum 1 through n
    - then square that sum
  - sum of the squares of the first `n` integers
    - find squares of ints 1 through n
    - then sum all the squares
Then find the difference between the two sums

``` js
function squareOfSum(n) {
  const integers = new Array(n).fill(0).map((val, idx) => idx + 1);
  const sum = integers.reduce((sum, num) => sum + num);
  return sum ** 2;
}

function sumOfSquares(n) {
  const integers = new Array(n).fill(0).map((val, idx) => idx + 1);
  const squares = integers.map((int) => int ** 2);
  return squares.reduce((sum, num) => sum + num);
}

function sumSquareDifference(n) {
  return squareOfSum(n) - sumOfSquares(n);
}
```

## 7. Bubble Sort

A bubble sort works by making multiple passes (iterations) through an array. On each pass, the two values of each pair of consecutive elements are compared. If the first value is greater than the second, the two elements are swapped. This process is repeated until a complete pass is made without performing any swaps — at which point the array is completely sorted.

We can stop iterating the first time we make a pass through the array without making any swaps because this means that the entire array is sorted.

Write a function that takes an array as an argument and sorts that array using the bubble sort algorithm described above. The sorting should be done "in-place" — that is, the function should mutate the array. You may assume that the array contains at least two elements.

*Melinda work*

Input: an array with at least 2 elements
Output: same array with elements sorted 

Notes: 
- Mutates the input array
- Cue to stop iterating: first time we iterate completely through the array with no swaps made
- Sorting mechanism
  - Iterate through the array in pairs of consecutive elements
    - For each pair of consecutive elements, if first > second, then swap the two elements

Algorithm:
- Initialize tracker variables
  - sorted to false
  - swapped to false

- While sorted is false
  - Iterate through array and swap elements 
    - How to swap elements
      - Compare if current element > next element
        - if so, swap values 
        - then set swapped to true
  - After one round of iteration:
    - If swapped it false, then sorted becomes true
      - Break out of iteration
    - Otherwise, swapped is true and we are still sorting
      - Reset swapped to false
      - Then continue iterating

- Return sorted array

``` js
function bubbleSort(arr) {
  while (true) {
    let swapped = false;

    for (let index = 0; index < arr.length - 1; index += 1) {
      if (arr[index] > arr[index + 1]) {
        const temp = arr[index];
        arr[index] = arr[index + 1];
        arr[index + 1] = temp;

        swapped = true;
      }
    }

    if (!swapped) { break; }
  }

  return arr;
}
```
