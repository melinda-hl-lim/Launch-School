## 1. Odd Numbers

Log all odd numbers from `1` to `99`, inclusive, to the console. Log all numbers on separate lines.

*Melinda work*

Input: none
Output: logging to console - all odd numbers, one per line

Algorithm:
- Iterate through all numbers 1 through 99
  - If the current number is odd (i.e. % 2 === 1) 
    - log the number to console

``` js
function oddNumbers() {
  for (let index = 1; index <= 99; index += 1) {
    if (index % 2 === 1) { console.log(index); }
  }
}
```

## 2. Even Numbers

Log all even numbers from `1` to `99`, inclusive, to the console. Log all numbers on separate lines.

*Melinda work*

Copy the code from problem 1 and tweak the conditional:
``` js
function evenNumbers() {
  for (let index = 1; index <= 99; index += 1) {
    if (index % 2 === 0) { console.log(index); }
  }
}
```

## 3. How Big is the Room

Build a program that asks the user to enter the length and width of a room in meters, and then logs the area of the room to the console in both square meters and square feet.

Note: 1 square meter = 10.7639 square feet

Do not worry about validating the input at this time. Use the `readlineSync.prompt` method to collect user input.

*Melinda work*

Input: length and width of room in meters
Output: logging to console: area of room in meters and feet

Algorithm:
- collect use input via the `readlineSync.prompt` method
- Multiply the two inputs together to find the area in m^2
- Multiply the area in m^2 by 10.7639 to find the area in ft^2
- Log both areas to console

``` js
function roomArea() {
  const readlineSync = require("readline-sync");
  const length = readlineSync.prompt('Enter the length of the room in meters:');
  const width = readlineSync.prompt('Enter the width of the room in meters:');

  const areaMeters = length * width;
  const areaFeet = areaMeters * 10.7639;

  console.log(`The area of the room is ${areaMeters.toFixed(2)} square meters (${areaFeet.toFixed(2)} square feet).`);
}
```

This solution doesn't work. I'm having trouble including `readline-sync`. I also didn't realize that the `readlineSync.prompt` method doesn't take the prompt string as an input (they should just be logegd to console) and returns a string.

## 4. Tip Calculator

Create a simple tip calculator. The program should prompt for a bill amount and a tip rate. The program must compute the tip, and then log both the tip and the total amount of the bill to the console. You can ignore input validation and assume that the user will put in numbers. 

*Melinda work*

It's a program, so no functions. Just scripting.

Steps:
- prompt for the bill amount
- prompt for a tip rate
- calculate the tip: bill amount * tip rate (as a percentage of the bill)
- calculate total amount with tip included
- log the tip and the total amount to conosle

``` js
const bill = parseFloat(prompt('What is the bill?'));
const tipRate = parseFloat(prompt('What is the tip percentage?'));

const tipAmount = parseFloat((bill * (tipRate / 100)));
console.log(typeof bill);
console.log(typeof tipAmount);
const totalAmount = bill + tipAmount;

console.log(`The tip is ${tipAmount.toFixed(2)}`);
console.log(`The total is ${totalAmount.toFixed(2)}`);
```

## 5. Sum or Product of Consecutive Integers

Write a program that asks the user to enter an integer greater than `0`, then asks if the user wants to determine the sum or the product of all numbers between `1` and the entered integer, inclusive.

*Melinda work*

- prompt user to enter a positive integer
- enter either "s" for sum, "p" for product

- initialize accumulator 

- iterate through numbers 1 and entered number
  - if sum, then add to accumulator
  - if product, then multiple to accumulator

- return the accumulator value in a console log statement

``` js
const int = Number(prompt('Please enter an integer greater than 0:'));
const operation = prompt('Enter "s" to compute the sum, or "p" to compute the product.');

let accumulator = 1;

for (let index = 2; index <= int; index += 1) {
  if (operation === 's') { accumulator += index; }
  if (operation === 'p') { accumulator *= index; }
}

console.log(`The ${operation === 's' ? 'sum' : 'product'} of the integers between 1 and ${int} is ${accumulator}.`);
```

## 6. Short Long Short

Write a function that takes two strings as arguments, determines the longer of the two strings, and then returns the result of concatenating the shorter string, the longer string, and the shorter string once again. You may assume that the strings are of different lengths.

Input: two strings
Output: shortString + longString + shortString (string)

- determine which of the two strings is longer
  - assign to appropriate variable names
- return short-long-short concatenated

``` js
function shortLongShort(string1, string2) {
  const longer = string1.length > string2.length ? string1 : string2;
  const shorter = string1.length < string2.length ? string1 : string2;

  return string1 + string2 + string1;
}
```

## 7. Leap Years Part 1

In the modern era under the Gregorian Calendar, leap years occur in every year that is evenly divisible by 4, unless the year is also divisible by 100. If the year is evenly divisible by 100, then it is not a leap year, unless the year is also evenly divisible by 400.

Assume this rule is valid for any year greater than year 0. Write a function that takes any year greater than 0 as input, and returns true if the year is a leap year, or false if it is not a leap year.

Input: a year (number)
Output: if year is a leap year (boolean)

Steps:
- leap years are divisible by 4
- if year is divisible by 4 and 100, then it must be divisible by 400 to be a leap year

``` js
// Melinda solution
function isLeapYear(year) {
  if (year % 4 === 0) {
    if (year % 100 === 0) {
      if (year % 400 === 0) {
        return true;
      }
      return false;
    }
    return true;
  }
  return false;
}

// Launch School solution
function isLeapYear(year) {
  if (year % 400 === 0) {
    return true;
  } else if (year % 100 === 0) {
    return false;
  } else {
    return year % 4 === 0;
  }
}
```

## 8. Leap Years Part 2

This is a continuation of the previous exercise. 

The British Empire adopted the Gregorian Calendar in 1752, which was a leap year. Prior to 1752, they used the Julian Calendar. Under the Julian Calendar, leap years occur in any year that is evenly divisible by 4.

Using this information, update the function from the previous exercise to determine leap years both before and after 1752.

Input: year (number)
Output: if the year is a leap year (boolean)

Rules:
- Julian calendar in years before 1752 (not inclusive)
- Under Julian calendar, leap years divisible by 4.

``` js
function isLeapYear(year) {
  if (year < 1752) {
    if (year % 4 === 0) { return true; }
    return false;
  }
  if (year % 400 === 0) {
    return true;
  } if (year % 100 === 0) {
    return false;
  }
  return year % 4 === 0;
}
```

## 9. Multiples of 3 and 5

Write a function that computes the sum of all numbers between `1` and some other number, inclusive, that are multiples of `3` or `5`. For instance, if the supplied number is `20`, the result should be `98` (`3 + 5 + 6 + 9 + 10 + 12 + 15 + 18 + 20`).

You may assume that the number passed in is an integer greater than `1`.

*Melinda work*

Input: n - an integer greater than 1
Output: The sum of all multiples of 3 and 5 between 1 through n

Rules: 
- number added to the sum is a multiple of 3 or 5
- Lower limit: 1
- Upper limit (inclusive): n

Algorithm: 
- initialize accumulator 
- iterate over numbers from 1 through n
  - if number is a multiple of 3 or 5
    - add to accumulator
return accumulator

``` js
function multisum(n) {
  let sum = 0;

  for (let index = 1; index <= n; index += 1) {
    if (index % 3 === 0 || index % 5 === 0) {
      sum += index;
    }
  }

  return sum;
}
```

## 10. ASCII String Value

Write a function that determines and returns the ASCII string value of a string passed in as an argument. The ASCII string value is the sum of the ASCII values of every character in the string. (You may use `String.prototype.charCodeAt()` to determine the ASCII value of a character.)

*Melinda work*

Input: a string
Output: a number representing the ascii value of the string

Rules:
- The ascii string value is the sum of all ascii values 

Steps:
- Initialize accumulator
- Iterate through every character in the given string
  - find the ascii code using charCodeAt and add to accumulator
- return accumulator

``` js
function asciiValue(string) {
  let asciiSum = 0;

  for (let index = 0; index < string.length; index += 1) {
    asciiSum += string.charCodeAt(index);
  }

  return asciiSum;
}
```