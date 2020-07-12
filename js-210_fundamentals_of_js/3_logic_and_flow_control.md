## Odd Numbers

Write a function that takes a positive integer as an argument, and logs all the odd numbers from 1 to the passed in number (inclusive). All numbers should be logged on separate lines.

``` js
function logOddNumbers(maxNum) {
  for (let num = 1; num <= maxNum; num++) {
    if (num % 2 === 1) {
      console.log(num);
    }
  }
}
```

## Multiples of 3 and 5

Write a function that logs the integers from 1 to 100 (inclusive) that are multiples of either 3 or 5. If the number is divisible by both 3 and 5, append an "!" to the number.

``` js
function multiplesOfThreeAndFive() {
  for (let currentNum = 1; currentNum <= 100; currentNum++) {
    if (currentNum % 3 === 0 && currentNum % 5 === 0) {
      console.log(String(currentNum) + '!');
    } else if (currentNum % 3 === 0 || currentNum % 5 === 0) {
      console.log(String(currentNum));
    }
  }
}
```

## Print Multiples

Write a function `logMultiples` that takes one argument `number`. It should log all multiples of the argument between 0 and 100 inclusive that are also odd numbers. Log the values in descending order.

You may assume that `number` is an integer between 0 and 100.

``` js
function logMultiples(number) {
  let remainderFrom100 = 100 % number;
  let largestMultiple = 100 - remainderFrom100;
  let largestMultiplier = largestMultiple / number;

  for (let multiplier = largestMultiplier; multiplier >= 1; multiplier--) {
    if (multiplier % 2 === 1) {
      console.log(String(number * multiplier));
    }
  }
}
```

## FizzBuzz

Write a function that iterates over the integers from 1 to 100, inclusive. For multiples of three, log "Fizz" to the console. For multiples of five, log "Buzz". For numbers which are multiples of both three and five, log "FizzBuzz". For all other numbers, log the number.

``` js
function fizzbuzz() {
  for (let num = 1; num <= 100; num++) {
    if (num % 3 === 0 && num % 5 === 0) {
      console.log('FizzBuzz');
    } else if (num % 3 === 0) {
      console.log('Fizz');
    } else if (num % 5 === 0) {
      console.log('Buzz');
    } else {
      console.log(String(num));
    }
  }
}

// A more concise, readable solution
let fizzbuzz = () => {
  for (let index = 1; index <= 100; index += 1) {
    let message = '';

    if (index % 3 === 0) {
      message += 'Fizz';
    }

    if (index % 5 === 0) {
      message += 'Buzz';
    }

    console.log(message || index);
  }
};
```

## Prime Check

Write a function that takes a number argument, and returns `true` if the number is prime, or `false` if it is not.

You may assume that the input is always a non-negative integer.

``` js
function isPrime(number) {
  if (number === 0 || number === 1) {
    return false;
  }

  for (let divisor = 2; divisor < number; divisor++) {
    if (number % divisor === 0) {
      return false;
    }
  }

  return true;
}
```

## XOR

For boolean values, the `||` operator returns `true` if either or both of its operands are `true`, `false` if both operands are `false`. 
The `&&` operator, on the other hand, returns `true` if both of its operands are `true`, and `false` if either operand is `false`. 
This works great until you need only one of two conditions to be true, the so-called "exclusive or", or `XOR`.

Write a function named `isXor` that takes two arguments and returns `true` if exactly one argument is *truthy*, false otherwise. Your function should work with the boolean values of `true` and `false`, but also any JS values based on their "truthiness". 

``` js
function isXor(value1, value2) {
  return !!value1 !== !!value2;
}

const isXor = (val1, val2) => !!val1 !== !!val2;
```

## Guessing the Password

Write a password guessing program that tracks how many times the user enters the wrong password. If the user enters the password wrong three times, log `'You have been denied access.'` and terminate the program. If the password is correct, log `'You have successfully logged in.'` and end the program.

``` js
const PASSWORD = 'Puppi';
let numberAttempts = 0;

while (true) {
  let guess = prompt('What is the password:');

  if (guess === PASSWORD) {
    console.log('You have successfully logged in.');
    break;
  }

  numberAttempts += 1;

  if (numberAttempts === 3) {
    console.log('You have been denied access.');
    break;
  }
}
```

## Student Grade

Write a program to determine a student's grade based on the average of three scores you get from the user. Use these rules to compute the grade:
- if average score >= 90, then grade is 'A'
- if 70 <= average score < 90, then grade is 'B'
- if 50 <= average score < 70, then grade is 'C'
- if average score <  50, then grade is 'F'

``` js
let score1 = prompt('Enter score 1:');
let score2 = prompt('Enter score 2:');
let score3 = prompt('Enter score 3:');
let average = (score1 + score2 + score3) / 3;

let grade;
if (average >= 90) {
  grade = 'A';
} else if (average >= 70 && average < 90) {
  grade = 'B';
} else if (average >= 50 && average < 70) {
  grade = 'C';
} else {
  grade = 'F';
}

console.log('Based on the average of your 3 scores your letter grade is "' + grade + '".');
```

## Greatest Common Divisor

Create a function that computes the Greatest Common Divisor of two positive integers.

``` js
function gcd(num1, num2) {
  var temp;

  while (num2 !== 0) {
    temp = num2;
    num2 = num1 % num2;
    num1 = temp;
  }

  return num1;
}
```

## Goldbach Numbers

Write a function named `checkGoldbach` that uses Goldbach's Conjecture to log every pair of primes that sum to the number supplied as an argument. 

The conjecture states that "you can express every even integer greater than 2 as the sum of two primes". The function takes as its only parameter, an integer `expectedSum`, and logs all combinations of two prime numbers whose sum is `expectedSum`. Log the prime pairs with the smaller number first. If `expectedSum` is odd or less than 4, your function should log `null`.

Your `checkGoldbach` function may call the `isPrime` function you wrote for a previous practice problem.

``` js
function isPrime(number) {
  if (number === 0 || number === 1) {
    return false;
  }

  for (let divisor = 2; divisor < number; divisor++) {
    if (number % divisor === 0) {
      return false;
    }
  }

  return true;
}

// Finds all primes less than number
// Returns array of primes
function findSmallerPrimes(number) {
  let primes = []

  for (let num = 2; num < number; num++) {
    if (isPrime(num)) {
      primes.push(num);
    }
  }

  return primes;
}

function checkGoldbach(expectedSum) {
  if (expectedSum < 4 || expectedSum % 2 === 1) {
    console.log(null);
    return;
  }

  let primes = findSmallerPrimes(expectedSum);
  
  primes.forEach( (number, index) => {
    let number2 = (expectedSum - number)
    if (primes.includes(number2)) {
      console.log(number, number2);
      let pos = primes.indexOf(number2);
      let removedPrime = primes.splice(pos, 1);
    }
  })
}
```

## Pattern Generation

Write a function tha takes a number of rows as the argument `nStars` and logs a square of numbers and asterisks. For example, if `nStars` is 7, log the following pattern:

``` js
generatePattern(7);

// console output
1******
12*****
123****
1234***
12345**
123456*
1234567
```

You may assume that `nStars` is greater than 1 and less than 10.

``` js
function generatePattern(nStars) {
  for (let row = 1; row <= nStars; row++) {
    let msg = '';

    for (let num = 1; num <= row; num++){
      msg += num;
    }

    while (msg.length < nStars) {
      msg += '*';
    }

    console.log(msg);
  }
}
```

## Index of Substring

Write two functions that each take two strings as arguments. Their expected behaviours are as follows:

- Both functions described below will return `-1` if `firstString` does not contain the substring specified by `secondString`.

- The `indexOf` function searches for the *first* instance of a substring in `firstString` that matches the string `secondString`, and returns the index of the character where that substring begins. 

- The `lastIndexOf` function searches for the *last* instance of a substring in `firstString` that matches the string `secondString`, and returns the index of the character where the substring begins.

You may use the square brackets (`[]`) to access a character by index (as shown below), and the `length` property to find the string length. However, you may not use any other properties or methods from JavaScript's built-in String class.

``` js
function indexOf(firstString, secondString) {
  let m = firstString.length;
  let n = secondString.length;

  for (let i = 0; i < m; i++) {
    let potentialSubstring = '';
    let counter = 0;

    while (counter <= n) {
      potentialSubstring += firstString[i + counter];
      counter++;
    }
    console.log(potentialSubstring)
    if (potentialSubstring === secondString) {
      return i;
    }
  }

  return -1;
}

"I CAN'T DO THIS PROBLEM..."

function indexOf(firstString, secondString) {
  let limit = firstString.length - secondString.length;

  for (let indexFirst = 0; indexFirst <= limit; indexFirst += 1) {
    let matchCount = 0;

    for (let indexSecond = 0; indexSecond < secondString.length; indexSecond += 1) {
      if (firstString[indexFirst + indexSecond] === secondString[indexSecond]) {
        matchCount += 1;
      } else {
        break;
      }
    }

    if (matchCount === secondString.length) {
      return indexFirst;
    }
  }

  return -1;
}
```

``` js
function lastIndexOf(firstString, secondString) {
  let limit = firstString.length - secondString.length;

  for (let indexFirst = limit; indexFirst >= 0; indexFirst -= 1) {
    let matchCount = 0;

    for (let indexSecond = 0; indexSecond < secondString.length; indexSecond += 1) {
      if (firstString[indexFirst + indexSecond] === secondString[indexSecond]) {
        matchCount += 1;
      } else {
        break;
      }
    }

    if (matchCount === secondString.length) {
      return indexFirst;
    }
  }

  return -1;
}
```

## Trimming Spaces

Write a function that takes a string as an argument, and returns the string stripped of spaces from both ends. Do not remove or alter internal spaces.

``` js
trim('  abc  ');  // "abc"
trim('abc   ');   // "abc"
trim(' ab c');    // "ab c"
trim(' a b  c');  // "a b  c"
trim('      ');   // ""
trim('');         // ""
```

``` js
function trim(string) {
  let trimmed = trimLeft(string);
  trimmed = trimRight(trimmed);

  return trimmed;
}

function trimLeft(string) {
  let newString = '';
  let copyMode = false;

  for (let index = 0; index < string.length; index += 1) {
    if (string[index] !== ' ') {
      copyMode = true;
    }

    if (copyMode) {
      newString += string[index];
    }
  }

  return newString;
}

function trimRight(string) {
  let newString = '';
  let copyMode = false;

  for (let index = string.length - 1; index >= 0; index -= 1) {
    if (string[index] !== ' ') {
      copyMode = true;
    }

    if (copyMode) {
      newString = string[index] + newString;
    }
  }

  return newString;
}
```

## Splitting a String

Write a function that takes two arguments:
- a string to be split
- a delimiter character

The function logs the split strings to the console, as shown below:

``` js
splitString('abc,123,hello world', ',');
// logs:
// abc
// 123
// hello world

splitString('hello');
// logs:
// ERROR: No delimiter

splitString('hello', '');
// logs:
// h
// e
// l
// l
// o

splitString('hello', ';');
// logs:
// hello

splitString(';hello;', ';');
// logs:
//  (this is a blank line)
// hello
```

``` js
function splitString(str, delimiter) {
  if (delimiter === undefined) {
    console.log("ERROR: No delimiter");
    return;
  }

  let tempStr = '';

  for (let index = 0; index < str.length; index++) {
    if (str[index] === delimiter) {
      console.log(tempStr);
      tempStr = '';
    } else if (delimiter === '') {
      console.log(string[index]);
    } else {
      tempStr += str[index];
    }
  }
  if (tempString) {
    console.log(tempStr);
  }
}
```

## Repeating Strings

Implement a function that takes a string and a number `times` as arguments. The function should return the string repreated `times` number of times. If `times` is not a number, return `undefined`. If it is a negative number, return `undefined` also. If times is `0`, return an empty string. You may ignore the possibility that `times` is a number that isn't an integer.

``` js
function repeat(string, times) {
  if (typeof(times) !== "number" || times < 0) {
    return undefined;
  }

  let repeatedString = '';
  let counter = 0;

  while (counter < times) {
    repeatedString += string;
    counter++;
  }

  return repeatedString;
}
```

## String StartsWith

Implement a function that determines whether a tring begins with another string. If it does, the function should return `true`, or `false` otherwise.

``` js
function startsWith(string, searchString) {
  let lenSubstr = searchString.length;
  let matchCounter = 0;

  for (let index = 0; index < lenSubstr; index++) {
    if (string[index] === searchString[index]) {
      matchCounter++;
    }
  }

  if (matchCounter === lenSubstr) {
    return true;
  } else {
    return false;
  }
}

function startsWith(string, searchString) {
  for (let index = 0; index < searchString.length; index += 1) {
    if (string[index] !== searchString[index]) {
      return false;
    }
  }

  return true;
}
```

## Converting Strings to Lower Case

Write a function that returns a string converted to lowercase.

To convert a single uppercase character to a lowercase character, get its ASCII numeric representation from the ASCII table, add 32 to that number, then convert the number back to a character using the same ASCII table. You can use the `String.fromCharCode` and the `String.charCodeAt` methods for these operations. 

``` js
function toLowerCase(string) {
  const CONVERSION_OFFSET = 32;
  let firstLowerCaseNum = 97; // Any uppercase character will have ASCII code less than 97
  let lowercaseStr = '';

  for (let index = 0; index < string.length; index++) {
    let asciiNumeric = string.charCodeAt(index);
    if (asciiNumeric < firstLowerCaseNum) {
      asciiNumeric += CONVERSION_OFFSET;
      lowercaseStr += String.fromCharCode(asciiNumeric);
    } else {
      lowercaseStr += string[index];
    }
  }

  return lowercaseStr;
}
```

## Substring (1)

Write a function that returns a substring of a string based on a starting index and length. 

- The `start` argument is the starting index. If negative, treat it as `strLength + start` where `strLength` is he length of the string. For example, if start is -3, treat it as `strLength - 3`. 
- The `length` argument is the maximum length of the desired substring. If `length` exceeds the number of characters avaialble, just use the available characters. 

``` js
function substr(string, start, length) {
  if (start < 0) {
    start = string.length + start;
  }

  let newString = '';
  for (let counter = 0; counter < length; counter += 1) {
    let index = start + counter;

    if (string[index] === undefined) {
      break;
    }

    newString += string[index];
  }

  return newString;
}
```

## Substring (2)

This practice problem is similar to the previous one. This time though, both arguments are indices of the provided string. The following rules apply:

- If both `start` and `end` are positive integers, `start` is less than `end`, and both are within the boundary of the string, return the substring from the `start` index (inclusive), to the `end` index (NOT inclusive). 
- If the value of `start` is greater than `end`, swap the values of the two, then return the substring as described above. 
- If `start` is equal to `end`, return an empty string.
- If `end` is omitted, the `end` variable inside the function is `undefined`. Return the substring starting at position `start` up through (and including) the end of the string. 
- If either `start` or `end` is less than 0 or NaN, treat it as 0. 
- If either `start` or `end` is greater than the length of the string, treat it as equal to the string length. 

``` js
function substr(string, start, length) {
  if (end === undefined) {
    end = string.length;
  }

  if (start < 0 || isNaN(start)) {
    start = 0;
  }

  if (end < 0 || isNaN(end)) {
    end = 0;
  }

  if (start > end) {
    [start, end] = [end, start];
  }

  if (start > string.length) {
    start = string.length;
  }

  if (end > string.length) {
    end = string.length;
  }

  let newString = '';
  for (let counter = 0; counter < length; counter += 1) {
    let index = start + counter;

    if (string[index] === undefined) {
      break;
    }

    newString += string[index];
  }

  return newString;
}
```

## Rot13 Cipher: (1) Code review and (2) Reference Solution

Rot13 ("rotate by 13 places") is a letter-substitution cipher that translates a String into a new String:

For each character in the original String:
- If the character is a letter in the modern English alphabet, change it to the character 13 positions later in the alphabet. Thus, `a` becomes `n`. If you reach the end of the alphabet, return to the beginning. Thus, `o` becomes `b`.
- Letter transformations preserve case. `A` becomes `N` while `a` becomes `n`.
- Don't modify characters that are not letters.

Write a Function, rot13, that takes a String and returns that String transformed by the rot13 cipher.

``` js
function rot13(sentence) {
  const ROTATION_SIZE = 13;
  const ALPHABET_SIZE = 26;
  const ALPHABET = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'];

  let rotSentence = '';

  for (let index = 0; index < sentence.length; index++) {
    const currentChar = sentence[index];
    let caseChange = false;

    // find the index of the current character in ALPHABET
    let alphabetIndex = ALPHABET.indexOf(currentChar);

    // convert upper case characters into lower case characters to find index in ALPHABET
    if (alphabetIndex === -1) {
      alphabetIndex = ALPHABET.indexOf(currentChar.toLowerCase());
      caseChange = true;
    }

    // case for non-alphabet character we append unrotated
    if (alphabetIndex === -1) {
      rotSentence += currentChar;
      continue;
    }

    // rot13 the alphabet character
    alphabetIndex = (alphabetIndex + ROTATION_SIZE) % ALPHABET_SIZE;

    // add the new character to rotSentence
    if (caseChange === true) {
      rotSentence += ALPHABET[alphabetIndex].toUpperCase();
    } else {
      rotSentence += ALPHABET[alphabetIndex];
    }
  }

  return rotSentence;
}

```