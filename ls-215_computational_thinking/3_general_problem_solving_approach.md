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


## Problem 2

The Luhn formula is a simple checksum formula used to validate a variety of identification numbers, such as credit card numbers, Canadian Social Insurance Numbers.

The formula verifies a number against its included check digit, which is usually appended to a partial number to generate the full number. This number must pass the following test:
- counting from the rightmost digit and moving left, double the value of every second digit
- For any digit that thus become 10 or more, subtract 9 from the result
- Add all these digits together

If the total (the checksum) ends in 0, then the number is valid according to the Luhn Formula; otherwise, it's not valid. 

Write a program that, given a number in string format, check if it is valid per the Luhn formula. This should treat, for example, "2323 2005 7766 3554" as valid. You can ignore all non-numeric characters in the input string.

*Melinda work*

Input: identification number (a string)
Output: validation of number (boolean)

Steps to verify number:
1) Starting from the right side of the number, double every second digit
  1.5) If the doubled digit > 10, then -9 from it
2) Sum all digits together
3) If sum of all digits ends in 0, it's a valid number!

Additional Rules:
- ignore all non-numeric characters in the argument 


Examples:

console.log(verifyLuhns('2323 2005 7766 3554')); // true
console.log(verifyLuhns('1111')); // false

console.log(verifyLuhns('1&h1k    1 1!')); // false - testing different char input
console.log(verifyLuhns('\n8____7 6horses:3')); // true - testing different char input
console.log(verifyLuhns('')); // empty string input?


Data structure: array of digits
  - iteration for doubling behaviour easier
  - can use an accumulator to find the sum of all digits


Algorithm:
- Clean and prepare input for processing
  - Remove any non-numeric characters from the argument. The result should be a string of digits.
    - replace(/~regex to replace non-digits/ with "")
  - Convert the string of digits into an array of digits. 
    - split("")
    - convert each digit from string to number

- Process the inputted id number using Luhn's formula's steps
  - Reverse the array of digits - this will help us iterate through the id number digits in reverse!

  - Iterate through each digit of the reversed array:
    - If the digit is in an [even number position]!!!, then double its value. 
      - Note: even number position is actually odd if we count the digits' places from 0 instead of 1. So we want to double the value of every odd index in the array of digits.
      - If, after doubling the digit, its value is more than 10, then subtract 9

  - After the iteration and doubling of digits is complete, we want to sum all digits together. 
    - reduce()

- Validate the number 
  - Check to see if the sum is a multiple of 10
    - If so, it's a valid number!
    - We want to return whether it's a valid number around here.

``` js
function verifyLuhns(idNumber){
  let prepareId = idNumber => {
    return idNumber.replace(/[^0-9]/g, '')
                  .split('')
                  .map(Number);
  }
  let processForLuhns = idNumber => {
    let reversedId = idNumber.reverse();

    return reversedId.map((digit, position) => {
      if (position % 2 === 1) {
        let newDigit = digit * 2;

        if (newDigit >= 10) {
          newDigit = newDigit - 9;
        }
        return newDigit;
      } else {
        return digit;
      }
    })
  }

  let idDigits = prepareId(idNumber);
  let processedId = processForLuhns(idDigits);
  let checkSum = processedId.reduce((sum, digit) => sum + digit);
  return checkSum % 10 === 0;
}
```

Notes:
- I don't fully understand this sentence: "The formula verifies a number against its included check digit, which is usually appended to a partial number to generate the full number." I think it's okay in this case, since this partial number appended to the full number may not play a role in the verification process...?
- I'm not sure how we want to handle inputs with no digits. This method assumes the input contains at least 1 digit. Otherwise we get errors about empty arrays. 



## Problem 3

A collection of spelling block has two letters per block as shown in this list:
``` 
B:O    X:K    D:Q    C:P    N:A    G:T
R:E    F:S    J:W    H:U    V:I    L:Y
Z:M
```
This limits the words you can spell with the blocks to only those words that do not use both letters from any given block. You can also only use each block once.

Write a function that takes a word string as an argument and returns `true` if the word can be spelled using the set of block, `false` otherwise. You can consider the letters to be case-insensitive when you apply the rules.

Given tests:
``` js
console.log(isBlockWord('BATCH'));      // true
console.log(isBlockWord('BUTCH'));      // false
console.log(isBlockWord('jest'));       // true
console.log(isBlockWord('boOk'));       // false
console.log(isBlockWord('BkDpNtRs'));   // true
```

*Melinda section*

Input: a word (string)
Output: if the word can be made with our blocks (boolean)

Rules:
- Use each block once
- Use one letter from one block
- Case doesn't matter

Data structures:
- storing letter blocks: object 
  - {letterBlock: used?, ...}
  - iterate through each block of letters (keys)
  - can check if the block has been used (value)

- word we're checking: string? array of string chars?
  - iterate character by character

Algorithm:

- clean input for processing
  - remove case 
  - split into an array of characters
  - "ButcH" --> "[b, u, t, c, h]"

- iterate through each character in the given word
  - for each character: 
    - check if character is valid
      - iterate through all letter blocks (keys of the object)
        - check if each key includes the character
          - if it does include the character, we check if its value is true
            - if the value is true, then the letterblock has been used --> return false;
            - if the value is false, letterBlock is just used now! set value to true.
  
  - if we reach the end of our iteration, we return true!


``` js
function isBlockWord(word) {
  let letterBlocksTracker = {
    bo: false,
    xk: false,
    dq: false,
    cp: false,
    na: false,
    gt: false,
    re: false,
    fs: false,
    jw: false,
    hu: false,
    vi: false,
    ly: false,
    zm: false,
  } // key: values of format - letterBlock: used?
  const letterBlocks = Object.keys(letterBlocksTracker);
  let wordChars = word.toLowerCase().split('');

  for (let wordIndex = 0; wordIndex < wordChars.length; wordIndex += 1) {
    let currentChar = wordChars[wordIndex];

    for (let blockIndex = 0; blockIndex < letterBlocks.length; blockIndex += 1) {
      let currentBlock = letterBlocks[blockIndex];

      if (currentBlock.includes(currentChar)) {
        if (letterBlocksTracker[currentBlock]) {
          // letter block has been used
          return false;
        } else {
          letterBlocksTracker[currentBlock] = true;
        };
      };
    };
  };

  return true;
}
```

Notes: 
- Handle empty string input? The function I made doesn't...
- On iteration... a valid character means:
  - isn't part of a block that has a used character
    - if a block has a used character, the value should be `true`


## Problem 4

You are given a list of numbers in a "short-hand" range where only the the significant part of the next number is written because we know the numbers are always increasing (ex. "1, 3, 7, 2, 4, 1" represents `[1, 3, 7, 12, 14, 21]`).  Some people use different separators for their ranges (ex. "1-3, 1-2", "1:3, 1:2", "1..3, 1..2" represent the same numbers `[1, 2, 3, 11, 12]`). Range limits are always inclusive.

Your job is to return a list of complete numbers.

The possible separators are: `["-", ":", ".."]`.

More examples:
- "1, 3, 7, 2, 4, 1" --> 1, 3, 7, 12, 14, 21
- "1-3, 1-2" --> 1, 2, 3, 11, 12
- "1:5:2" --> 1, 2, 3, 4, 5, 6, ... 12
- "104-2" --> 104, 105, ... 112
- "104-02" --> 104, 105, ... 202
- "545, 64:11" --> 545, 564, 565, .. 611
- "545, 64:11, 13-9, 700, 1..3" --> 545, 564, 565, .. 611, 613 .. 619, 700, 701, 702, 703

*Melinda work*

Input: a string of numbers and separator characters
Output: an array of numbers 

Rules: 
- numbers always increment in count
- the sequence can begin with a full number
  - we count up from this first number!
- following the first number, ones place digit is specified
  - sometimes the tens and ones place digit is specified...?
- separator characters (-, :, ..) refer to ranges of numbers
- separator character (,) used to listing numbers
- range limit is inclusive (include that last number!)

Data types: strings and numbers. Conversions. Think about this...
- need to be in number form to += 1
- need to be in string form to check end digits
- need to be in string form to detect separator type


Data structure: an array of strings

- num, --> list num and move on
- num- --> 
- num: --> 
- num.. --> list num and start counting up by one until we reach num2 where num2 ends with the digits following the separator


Algorithm:
- prepare input for processing
  - convert the string of digits into an array of strings, separating at a space character

- initialize output array -- call this finalNumbers

- process each number shorthand in our array of strings
  - split the current number shorthand by range separators 
    - result: an array of string digits
  - initialize variable to hold last digits we pushed - call this lastDigits
  - for each string digits:
    - loop!
      - take lastDigits and add 1 - call currentDigits
      - see if currentDigits (change to string form) holds the current string-digits in its end
        - currentDigits.endsWith(string-digits)
        - if so, then push current number to the array (push number!)
        - if not, continue this looping of adding 1 and checking 

- return array. should be array of numbers. 

``` js
function expandNumbers(shorthand) {
  let shortDigits = shorthand.split(" ");
  let finalNumbers = [];

  shortDigits.forEach(shortDigit => {
    let currentDigits = shortDigit.match(/\d+/g);
    let lastNumber = finalNumbers[finalNumbers.length - 1] || 0;
    let range = !(currentDigits.length === 1);

    currentDigits.forEach(currentDigit => {
      while (true) {
        lastNumber += 1;

        if (range) {
          finalNumbers.push(lastNumber);
        } else {
          if (String(lastNumber).endsWith(currentDigit)) {
            finalNumbers.push(lastNumber);
          } 
        }

        if (String(lastNumber).endsWith(currentDigit)) {
          break;
        }
      }
    })
  })

  return finalNumbers;
}
```

Assumptions:
- input never empty string
- only positive numbers



## Problem 5

Implement encoding and decoding for the rail fence cipher. 

The rail fence cipher is a form of transposition cipher that gets its name from the way in which its encoded. 

In the Rail Fence cipher, the message is written downwards on successive "rails" of an imaginary fence, then moving up when we get to the bottom (like a zig zag). Finally the message is read off in rows. 