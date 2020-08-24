## 1. Ddaaiillyy ddoouubbllee

Write a function that takes a string argument, and returns a new string that contains the value of the original string with all consecutive duplicate characters collapsed into a single character.

*Melinda work*

Input: string 
Output: new string

Rules: for any character that appears >1 times consecutively, reduce into one character

Given test cases:
``` js
crunch('ddaaiillyy ddoouubbllee');    // "daily double"
crunch('4444abcabccba');              // "4abcabcba"
crunch('ggggggggggggggg');            // "g"
crunch('a');                          // "a"
crunch('');                           // ""
```

Algorithm:
- split the string into an array of characters
- initialize new string
- iterate through characters starting from zeroth through second last
  - if current character === next character
    - continue iterating through
  - else
    - append current character to new string
- last check: see if second last character === last character
  - if not, then append last character to new string
- return new string

``` js
function crunch(str) {
  let newStr = '';

  if (str === '') { return newStr; }

  for (let index = 0; index < str.length - 2; index += 1) {
    if (str[index] !== str[index + 1]) {
      newStr += str[index];
    }
  }

  newStr += str[str.length - 1];

  return newStr;
}
```

Launch School solution:
``` js
function crunch(text) {
  let index = 0;
  let crunchText = '';

  while (index <= text.length - 1) {
    if (text[index] !== text[index + 1]) {
      crunchText += text[index];
    }

    index += 1;
  }

  return crunchText;
}
```
*Notes:*

Since they (LS) iterate using a `while` loop:
- it's possible to input an empty string `''` argument and still return the correct answer without having to use a guard clause.
Since they iterate to the last character of the given string and check it against `str[str.length]`, it ensures that the last character is appropriately added to the crunched string without having a floating line `newStr += str[str.length]` to add the last character.

Potential regex use:
`'ddaaiillyy ddoouubbllee'.match(/(.)(?!\1)/g) // => ['d', 'a', 'i', 'l', 'y', ' ', 'd', 'o', 'u', 'b', 'l', 'e',]`
The above solution uses **lookaheads**. They are "zero-length assertions", meaning that any characer they match will not be included in any matches returned by the regex. A "negative lookahead" works for this situation, as we want to search for something (current character) that is followed by the absence of something else (don't repeat the current character!).

Another example: 
We want to match `q`s that are *not* followed by `u`s:
`"I type quickly on my qwerty keyboard".match(/q(?!u)/g)`


## 2. Bannerizer

Write a function that will take a short line of text, and write it to the console log within a box. You may assume that the output will always fit in your browser window. 

Example: 
``` js
logInBox('To boldly go where no one has gone before.');
// logs
+--------------------------------------------+
|                                            |
| To boldly go where no one has gone before. |
|                                            |
+--------------------------------------------+

logInBox('');
// logs
+--+
|  |
|  |
|  |
+--+
```

*Melinda work*

Input: string
Output: log a banner into console with the string in the middle! 

Rules: 
- Banner has five lines: top border, top padding (spaces), centered string, bottom padding (spaces), bottom border
- Middle line contains string padded with one space in front and one space in back
- Corners are denoted with "+"
- Vertical borders denoted with "|"
- Horizontal borders denoted with "_"

Algorithm:
- create centered string line
  - initialize new string
  - concatenate "| " + input string + " |"
- now that we have the centered string, we know the length of the banner and we can build the other components
  - initialize variable to hold length of centered string line
- create horizontal border component
  "+" + "_".repeat(strLength - 3) + "+"
- create top/bottom padding component
  " ".repeat(strLength - 1)
- assemble banner into output
  - console.log horizontal border
                padding
                centered string
                padding
                horizontal border

``` js
function logInBox(str) {
  const centeredStr = `| ${str} |`;
  const lenBanner = centeredStr.length;

  const horizontalBorder = `+${'_'.repeat(lenBanner - 2)}+`;
  const padding = `|${' '.repeat(lenBanner - 2)}|`;

  console.log(horizontalBorder);
  console.log(padding);
  console.log(centeredStr);
  console.log(padding);
  console.log(horizontalBorder);
}
```

## 3. Stringy Strings

Write a function that takes one argument, a positive integer, and returns a string of alternating `'1'`s and `'0'`s, always starting with a `'1'`. The `length` of the string should match the given integer.

Exmaples:
``` js
stringy(6);    // "101010"
stringy(9);    // "101010101"
stringy(4);    // "1010"
stringy(7);    // "1010101"
```

*Melinda work*

Input: an integer specifying length of output string
Output: string

Algorithm:
- Initialize new string
- Initialize counter - so we know how many times we've looped out of the inputted number

- For input times (while counter < input), add 1 or 0 to the new string
  - if string.slice(-1) is '0'
    - then add string '1'
  - else string[last] '1'
    - then add string '0'

- return new string

``` js
function stringy(times) {
  let binaryStr = '';
  let counter = 0;

  while (counter < times) {
    binaryStr += binaryStr.slice(-1) === '1' ? '0' : '1';
    counter += 1;
  }

  return binaryStr;
}
```

## 4. Fibonacci Number Location by Length

The Fibonacci series is a series of numbers (`1, 1, 2, 3, 5, 8, 13, 21, ...`) such that the first two numbers are `1` by definition, and each subsequent number is the sum of the two previous numbers. This series appears throughout the natural world.

Computationally, the Fibonacci series is a simple series, but the results grow at an incredibly rapid rate. For example, the 100th Fibonacci number is 354,224,848,179,261,915,075—that's enormous, especially considering that it takes six iterations just to find the first 2-digit Fibonacci number.

Write a function that calculates and returns the index of the first Fibonacci number that has the number of digits specified by the argument. (The first Fibonacci number has an index of `1`.)

You may assume that the argument is always an integer greater than or equal to `2`.

Examples:
``` js
findFibonacciIndexByLength(2);       // 7 (length of array)
findFibonacciIndexByLength(10);      // 45
findFibonacciIndexByLength(16);      // 74
```

*Melinda work*

Input: length of fibonacci number
Output: index of fib number with inputted length
  - First fibonacci has an index of '1'

Data structure: array of fib numbers

Algorithm:
- Initialize fibArray: start with [1, 1]
- Current index = 2; 
  - We need to start from 2 since there's already 2 fib numbers in the array!

- While looping
  - calculate next fibonacci number
    - newFib = fibArray[index - 1] + fibArray[index - 2]
    - push newFib to array (make sure it's a number!)
    - increment current index by 1
    - if string version of newFib has input length number of digits
      - break out of loop

- return array length 

``` js
function findFibonacciIndexByLength(length) {
  const fibArray = [1, 1];
  let currentIndex = 2;

  while (true) {
    const nextFib = fibArray[currentIndex - 1] + fibArray[currentIndex - 2];
    currentIndex = fibArray.push(nextFib);

    if (String(nextFib).length === length) { break; }
  }

  return fibArray.length;
}
```

## 5. Right Triangles

Write a function that takes a positive integer, `n`, as an argument, and logs a right triangle whose sides each have `n` stars. The hypotenuse of the triangle (the diagonal side in the images below) should have one end at the lower-left of the triangle, and the other end at the upper-right.

``` js
triangle(5);

    *
   **
  ***
 ****
*****

triangle(9);

        *
       **
      ***
     ****
    *****
   ******
  *******
 ********
*********
```

*Melinda work*

Input: number of stars per side
Output: log triangle to console

Rules: 
- triangle hypotenuse stretches from bottom left corner to top right corner 
  - length of 'drawing box' is input number stars
- increment the number of stars in each successive row by 1
- draw each row of stars from right (add spaces to the left of star)

Algorithm:
- initialize counter to 1. This'll be a star counter for each row, and the looping counter
- while counter <= input number 
  - build the current row
    - " ".repeat(starNum - counter) + "*".repeat(counter)
  - console.log current row

``` js
function triangle(numStars) {
  let starCounter = 1;

  while (starCounter <= numStars) {
    const currentRow = ' '.repeat(numStars - starCounter) + '*'.repeat(starCounter);
    console.log(currentRow);
    starCounter += 1;
  }
}
```

## 6. Madlibs

Madlibs is a simple game where you create a story template with "blanks" for words. You, or another player, then construct a list of words and place them into the story, creating an often silly or funny story as a result.

Create a simple madlib program that prompts for a noun, a verb, an adverb, and an adjective, and injects them into a story that you create.

Example:
``` js
Enter a noun: dog
Enter a verb: walk
Enter an adjective: blue
Enter an adverb: quickly

// console output
Do you walk your blue dog quickly? That's hilarious!
```

*Melinda work*

- collect user input
  - noun, verb, adjective, adverb
  - use prompt('question')

- output madlibstring

``` js
function madLibs() {
  const noun = prompt('Enter a noun: ');
  const verb = prompt('Enter a verb: ');
  const adjective = prompt('Enter a adjective: ');
  const adverb = prompt('Enter a adverb: ');

  console.log(`Do you ${verb} your ${adjective} ${noun} ${adverb}? That's hilarious! XD`);
}
```

## 7. Double Doubles

A double number is an even-length number whose left-side digits are exactly the same as its right-side digits. For example, `44`, `3333`, `103103`, and `7676` are all double numbers, whereas `444`, `334433`, and `107` are not.

Write a function that returns the number provided as an argument multiplied by two, unless the argument is a double number; return double numbers as-is.

Examples:
``` js
twice(37);          // 74
twice(44);          // 44
twice(334433);      // 668866
twice(444);         // 888
twice(107);         // 214
twice(103103);      // 103103
twice(3333);        // 3333
twice(7676);        // 7676
```

*Melinda work*

Input: a number
Output: a number - either double-double or input * 2

Rules:
- double double number means:
  - split number into two halves: first x digits and last x digits
  - both halves should have the same value to be a double-double
- if number is double double, return as is
- else double the number and return 

Two parts: 
- identify double double
- handle input according to rules 

Algorithm:
- identify double double
  - convert number into string
  - check length of string? if it's an odd number, then it isn't a double double.
  - split string into array of digits
  - compare first half values to second half values
    - find half way index: array.length / 2 (index of first digit in second half)
    - iterate through the first half of the array (0-array.length % 2 exclusive)
      - if (current digit !== digit at current index + half way index)
        - then return false
  - if we reach the end of all this and haven't returned false, it's a double-double! return true
    
- main function
  - if number is a double-double
    - return number
  - else
    - return number * 2

``` js
function isDouble(number) {
  const strNumber = String(number);

  if (strNumber.length % 2 === 1) { return false; }

  const digits = strNumber.split('');
  const secondHalfStart = digits.length / 2;

  for (let index = 0; index < secondHalfStart; index += 1) {
    if (digits[index] !== digits[index + secondHalfStart]) {
      return false;
    }
  }

  return true;
}

function twice(number) {
  return isDouble(number) ? number : number * 2;
}
```

Launch School's isDouble function:
``` js
function isDoubleNumber(number) {
  const stringNumber = String(number);
  const center = stringNumber.length / 2;
  const leftNumber = stringNumber.substring(0, center);
  const rightNumber = stringNumber.substring(center);

  return leftNumber === rightNumber;
}
```
