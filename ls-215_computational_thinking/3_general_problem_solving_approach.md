## The "PEDAC" Problem Solving Process

P: Understand the **P**roblem
- We want to split the problem description into a specific, explicit set of **definitions** and **rules**. 

E: **E**xamples and Test Cases

D: **D**ata Structure
A: **A**lgorithms
C: **C**ode

Notice how the last step is code. Spend time on the first four steps to make sure I really understand the problem.

https://medium.com/launch-school/solving-coding-problems-with-pedac-29141331f93f


## Understanding the Problem and Writing Test Cases

**Small Code Challenge Problems**

- 20 - 45 minutes
- typical solutions: 10 - 40 lines of code
- used extensively in interviews for a reason
  - mastery of a language
  - logic / reasoning
  - communications
- not a skill that you "acquire and file away", but needs a lot of practice

**Understand the Problem**

- requirements are explicit
  - take notes
  - the "odd words" problem
- requirements are not so explicit and need to be modeled
  - examples need to be described in computational words
  - "diamond of stars"
- implicit knowledge needs to be captured
  - convert to explicit rules, in computational language
  - "what century is that"
- identifying and defining important terms and concepts
  - "queen attack"
  - same row; same column; especially same diagonal
- ask questions to verify your understanding!

**Examples / Test Cases**

- Input / Output
- Test cases serve two purposes:
  - help you understand the problem
  - allow you to verify your solution
- Happy paths
  - combination of requirements; the "obvious" result
- Edge cases
  - focus on input
  - emptiness (nil/null, "", [], {})
  - boundary conditions
  - repetition / duplication
  - upper case / lower case
  - data types
- Failures / Bad Input
  - raise exceptions / report errors
  - return a special value (nil/null, 0, "", [], etc.)
- ask questions to verify your understanding!


## Data Structure and Algorithms

**Data Structure**

- input data
- rules/requirements as data
  - hash/object

- string, array, hash/object, number
  - string
    - concact, strip, reverse, etc.
    - Regular Expression! split, replace, match...
  - array
    - need to walk through it (iteration)
    - index
    - abstractions!!
      - map
      - reduce
      - select/filter
      - all
      - ...
  - hash/object
    - lookup table / dictionary
    - partition data for more efficient access downstream
    - digest
  - number
    - math operations
    - number as string may have advantage over numbers
- compound data structures
  - array of arrays
  - hash with array/object values, etc.

**Algorithm**

- algorithms have to be described in the language of chosen data structure!
  - "then solve it" doesn't count
- have to be really fluent with
  - String / Regex
  - Array
    - Ruby: Enumerable
    - JavaScript: Higher-Order Functions
  - Hash / Object
    - Creation (default values)
    - Access (default values)
    - Iteration
- verify your algorithm with your examples / test cases


## An Example Problem: Comparing Version Numbers

Write a function that takes any two version numbers in this format and compares them, with the result of this comparison showing whether the first is less than, equal to, or greater than the second version.

- If `version 1 > version 2`, we should return `1`
- If `version 1 < version 2`, we should return `-1`
- If `version 1 === version 2`, we should return `0`
- If either version number contains characters other than digits and the `.` character, we should return `null`

Input: two versions; strings
Output: either 1, -1, 0 or null

Test cases:

  console.log(compareVersions('0.1', '1')) // -1
  console.log(compareVersions('1', '1.0.0')) // 0
  console.log(compareVersions('1.0.0', '0.0.1')) // 1

  console.log(compareVersions('13.37', '1.18.2')) // 1

  console.log(compareVersions('0O', '0.1')) // null
  console.log(compareVersions('', '')) // null


Steps:

**validation:**
input: a string 
output: true or false

  - a valid version is only made of digits (0-9) and dots (.)
  - sounds like a regex problem
  - if valid versions are not given, return null

- At this point, we have valid versions. We want to compare each component of each version - component meaning a number section before/between dots

**formatting version number steps:**
  - split version inputs into component numbers: array of digits?
    - for comparison, we want these arrays to be of equal length. so populate empty slots at end with 0 for the shorter version number 

**comparing version numbers:**
  - compare respective components as you would normal numbers
    - if component numbers are equal, move on to the next components
    - if component number 1 > component number 2, return 1
    - if component number 1 < component number 2, return -1
  - if we've finished looping through component numbers and reach this point, then the versions are exactly the same. so we would have to return 0. 


``` js
function compareVersions(version1, version2) {
  if (!validVersion(version1) || !validVersion(version2)) {
    return null;
  }

  let formatV1 = formatVersion(version1);
  let formatV2 = formatVersion(version2);

  if (formatV1.length !== formatV2.length) {
    evenLengths(formatV1, formatV2);
  }

  for (let index = 0; index < formatV1.length; index++) {
    if (formatV1[index] === formatV2[index]) {
      continue;
    } else if (formatV1[index] > formatV2[index]) {
      return 1;
    } else {
      return -1;
    }
  }
  return 0;
}

// ISSUE WITH THIS FUNCTION
// nature of match: when there is no match, it throws an error... 
// also, '0p' is a valid version number
function validVersion(version) {
  let validVersion = /[0-9]+(.[0-9]+)*/g;
  let match = version.match(validVersion);

  return match.length === 1;
}

function formatVersion(version) {
  return version.split(".");
}

function evenLengths(array1, array2) {
  if (array1.length > array2.length) {
    array2.length = array1.length;
    array2.map(element => {
      return element === undefined ? 0 : element;
    })
  } else if (array2.length > array1.length) {
    array2.length = array1.length;
    array2.map(element => {
      return element === undefined ? 0 : element;
    })
  }
}
```


## Problem 1

Write a program that cleans up user-entered phone numbers so that they can be sent as SMS messages. Other than digits, the number may also contain special character such as spaces, dash, dot, and parentheses that should be ignored.

The rules are as follows:
- If the phone number is less than 10 digits, assume that it is a bad number.
- If the phone number is 10 digits, assume that it is good.
- If the phone number is 11 digits and the first number is 1, trim the 1 and use the last 10 digits.
- If the phone number is 11 digits and the first number is not 1, then it is a bad number.
- If the phone number is more than 11 digits, assume that it is a bad number.

For bad numbers, just return a string of 10 `0`s.

*Melinda starts here!*

Acceptable characters: [0-9], space ( ), dash (-), dot (.), parentheses (()).

Rules:
- Length of given number should be 10 or 11 *digits*
- First digit of an 11 digit number must be 1

Input: some kind of phone number - I assume string?
Return: a string of 10 digits

Test cases:
console.log(cleanNumber('9095417221')) // already formatted number
console.log(cleanNumber('19095417221')) // already formatted number with 1 at the beginning
console.log(cleanNumber('(909) 541-7221')) // 10 digits with special characters
console.log(cleanNumber('1 (909).541-7221')) // 11 digits with all special characters

console.log(cleanNumber('123 456 789')) // 9 digit input => 0000000000
console.log(cleanNumber('123 456 789 102')) // 12 digit input => 0000000000
console.log(cleanNumber(''))

Steps
- Clean phone number to just digits
  - remove any spaces, dashes, dots, parentheses
  - alternate phrase: extract only digits from original string

- Check if phone number is valid
  - is length 10 or 11 digits?
  - if length is 11 digits, is first digit 1?

``` js
function cleanNumber(number) {
  const INVALID_NUMBER = '0000000000';
  let digits = number.match(/[0-9]/g) || [];

  if (digits.length !== 10 && digits.length !== 11) {
    return INVALID_NUMBER;
  }

  if (digits.length === 11) {
    if (digits[0] !== '1') {
      return INVALID_NUMBER;
    } else {
      digits.shift();
      return digits.join('');
    }
  }

  return digits.join('');
}
```


