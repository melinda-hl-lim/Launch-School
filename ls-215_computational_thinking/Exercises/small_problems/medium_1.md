## 1. Rotation Part 1

Write a function that rotates an array by moving the first element to the end of the array. Do not modify the original array.

- If the input is not an array, return `undefined`
- If the input is an empty array, return an empty array

Review the test cases below, then implement the solution accordingly.

``` js
rotateArray([7, 3, 5, 2, 9, 1]);       // [3, 5, 2, 9, 1, 7]
rotateArray(['a', 'b', 'c']);          // ["b", "c", "a"]
rotateArray(['a']);                    // ["a"]
rotateArray([1, 'a', 3, 'c']);         // ["a", 3, "c", 1]
rotateArray([{ a: 2 }, [1, 2], 3]);    // [[1, 2], 3, { a: 2 }]
rotateArray([]);                       // []

// return `undefined` if the argument is not an array
rotateArray();                         // undefined
rotateArray(1);                        // undefined


// the input array is not mutated
const array = [1, 2, 3, 4];
rotateArray(array);                    // [2, 3, 4, 1]
array;                                 // [1, 2, 3, 4]
```

*Melinda work*

Input: an array with elements 
Output: a rotated array with same elements in a different order

Rules:
- Rotate an array
  - moving the first element to the end of the array
- Do NOT mutate input array
- Funky inputs
  - not array - return `undefined`
  - empty array - return `[]`

Algorithm:

- Guard checks to validate input type
  - if input's not an array, return undefined
  - if input's an empty array, return an empty array

- At this point, we know our input is an array with at least 1 element.

- Rotate the array: move first element to end of array
  - Make a new array that contains all elements of the input array from the first index through the last index 
    - (note: the only element that is not copied is the first element that we want to move to the end of the array)
  - Append first element (that wasn't copied) to the end of the new array

- Return the new array

``` js
function rotateArray(array) {
  if (!(Array.isArray(array))) { return undefined; }

  if (array.length === 0) { return []; }

  const sliceOfArray = array.slice(1);
  sliceOfArray.push(array[0]);
  return sliceOfArray;
}
```


## 2. Rotation Part 2

Write a function that rotates the last `n` digits of a `number`. For the rotation, rotate by one digit to the left, moving the first digit to the end.

Examples:
``` js
rotateRightmostDigits(735291, 1);      // 735291
rotateRightmostDigits(735291, 2);      // 735219
rotateRightmostDigits(735291, 3);      // 735912
rotateRightmostDigits(735291, 4);      // 732915
rotateRightmostDigits(735291, 5);      // 752913
rotateRightmostDigits(735291, 6);      // 352917
```

*Melinda work*

Input:
  - a number to rotate
  - last `n` digits to rotate
Output:
  - rotated number

Rules: 
  - To rotate `n` digits means to remove the first digit and append it to the end of the rest of the digits 
    - 1234 rotated becomes 2341
  - In a larger number with `x` digits where `x > n`, rotating the last `n` digits means the first `x - n` digits remain unchanged.

Steps:
  - Split the input number into two sections
    - 1. The first `length - n` digits that remain unchanged
    - 2. The last `n` digits to be rotated
  - ROTATE the last `n` digits
  - Recombine the two sections of the input number (untouched first section, and rotated last `n` digits) and return

Steps 2: 
  - Split the input number into two sections
    - 1. The first `length - n` digits that remain unchanged
    - 2. The last `n` digits to be rotated

    - Convert number into string
      - 123 --> '123'
    - Split string into an array of digits
      - ['1', '2', '3']
    - Slice the array to create the two sections of the number (2 slices)
      - Last n digits: Index to slice from: `length - n `
      - Original unmodified front: slice from 0 to `length - n`

  - ROTATE the last `n` digits
    - Take the first element of the array, remove it and then append it to the end of the array
      - `array.push(array.shift());`
    - OR use function from previous problem

  - Recombine the two sections of the input number (untouched first section, and rotated last `n` digits) and return
    - concat to join two array halves
    - join to combine all digits into one string
    - convert back to number

``` js
function rotateRightmostDigits(number, n) {
  const allDigits = String(number).split('');
  const firstSec = allDigits.slice(0, allDigits.length - n);
  let secondSec = allDigits.slice(allDigits.length - n);

  secondSec = rotateArray(secondSec);

  return Number(firstSec.concat(secondSec).join(''));
}
```


## 3. Rotation Part 3

Take the number `735291` and rotate it by one digit to the left, getting `352917`. Next, keep the first digit fixed in place and rotate the remaining digits to get `329175`. Keep the first two digits fixed in place and rotate again to get `321759`. Keep the first three digits fixed in place and rotate again to get `321597`. Finally, keep the first four digits fixed in place and rotate the final two digits to get `321579`. The resulting number is called the maximum rotation of the original number.

Write a function that takes an integer as an argument, and returns the maximum rotation of that ingeter. You can (and probably should) use the `rotateRightmostDigits` function from the previous exercise.

``` js
maxRotation(735291);          // 321579
maxRotation(3);               // 3
maxRotation(35);              // 53
maxRotation(105);             // 15 -- the leading zero gets dropped
maxRotation(8703529146);      // 7321609845
```

*Melinda work*

Input: a number
Output: a maximumly rotated number

Rules:
  - Maximum rotation: For each digit position (i.e. index), we:
    - Take the digit at that position and all following digits
    - Rotate said set of digits
    - Mutating: as we iterate to the next digit position, the numbers will have shifted position from the most recent rotation 

Algorithm:
  - First, find length of number (i.e. number of digits in number) by converting into a string and accessing the length property

  - Initialize numberInRotation to number

  - Iterate through each digit position index from 0 to < length from above
    - For each digit position, 
      - call function rotateRightmostDigits on numberInRotation with index of length - index
      - Reassign numberInRotation to the new rotated number
  
  - Return numberInRotation 

``` js
function maxRotation(number) {
  const numLength = String(number).length;
  let numberInRotation = number;

  for (let index = 0; index < numLength; index += 1) {
    numberInRotation = rotateRightmostDigits(numberInRotation, numLength - index);
  }

  return numberInRotation;
}
```


## 4. Stack Machine Interpretation

A stack is a list of values that grows and shrinks dynamically. A stack may be implemented as an `Array` that uses two Array methods: `Array.prototype.push` and `Array.prototype.pop`.

A stack-and-register programming language is a language that uses a stack of values. Each operation in the language operates on a register, which can be thought of as the current value. The register is not part of the stack. An operation that requires two values pops the topmost item from the stack (i.e., the operation removes the most recently pushed value from the stack), operates on the popped value and the register value, and stores the result back in the register.

Consider a `MULT` operation in a stack-and-register language. It multiplies the `stack` value with the `register` value, removes the value from the stack, and stores the result back in the `register`. For example, if we start with a `stack` of `[3, 6, 4]` (where 4 is the topmost item in the stack) and a `register` value of `7`, the `MULT` operation transforms the `stack` to `[3, 6]` (the `4` is removed), and the result of the multiplication, `28`, is left in the `register`. If we do another `MULT` at this point, the stack is transformed to `[3]`, and the `register` is left with the value `168`.

Write a function that implements a miniature stack-and-register-based programming language that has the following commands (also called operations or tokens):

- `n` : Place a value, `n`, in the `register`. Do not modify the stack. 
- `PUSH` : Push the `register` value onto the `stack`. Leave the value in the `register`.
- `ADD` : Pop a value from the `stack` and add it to the `register` value, storing the result in the `register`.
- `SUB` : Pop a value from the `stack` and subtract it from the `register` value, storing the result in the `register`.
- `MULT` : Pop a value from the `stack` and multiply it by the `register` value, storing the result in the `register`.
- `DIV` : Pop a value from the `stack` and divide it into the register `value`, storing the integer result in the `register`.
- `MOD` : Pop a value from the `stack` and divide it into the `register` value, storing the integer remainder of the division in the `register`.
- `POP` : Remove the topmost item from the `stack` and place it in the `register`.
- `PRINT` : Print the `register` value. 

All operations are *integer* operations.

Programs will be supplied to your language function via a string argument. Your function may assume that all arguments are valid programs — i.e., they will not do anything like trying to pop a non-existent value from the `stack`, and they will not contain any unknown tokens.

Initialize the `stack` and `register` to the values `[]` and `0`, respectively.

*Melinda work*

Input: a string of commands
Output: Sometimes we output a number to console. Sometimes we only modify the stack and register with no output.

Steps:
- Initialize stack and register ([] and 0)

- Parse the string into separate commands
  - Commands look like they're separated by spaces -- split string into array of strings 

- Iterate through the separated commands (array of strings)
  - Case statements for each command
  - If number n: reassign register to value of n 
  - If PUSH: stack.push(register's value)
  - If ADD, SUB, MULT, DIV, MOD: 
    - remove last value from stack
    - MATH_OP last value with value in register
    - Store new value in register
  - If POP: remove last value from stack and reassign register to this value
  - If PRINT: console.log(register's value)

- Program should be finished

## 5. Word to Digit

Write a function that takes a sentence string as an argument, and returns that string with every occurence of a "number word" - `'zero'`, `'one'`, `'two'`, ... - converted to its corresponding digit character. 

Example:
``` js
wordToDigit('Please call me at five five five one two three four. Thanks.');
// "Please call me at 5 5 5 1 2 3 4. Thanks."
```

*Melinda work*
Input: a string with spelt out numbers
Output: a string with spelt out numbers replaced with digits

Algorithm:
- Create a mapping of digit to spelling
  - Array: index is the digit, spelling is the element
- Split the string into an array of words
- For each word within the array
  - See if our digit-spelling mapping contains the word
  - If so, find the index of the word within our mapping 
  - and then replace the current word with that index/digit
- Join our array of words into a string
- Return string

``` js
function wordToDigit(string) {
  const numbers = ['zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine'];
  let words = string.split(' ');

  words = words.map((word) => {
    if (numbers.includes(word)) {
      return String(numbers.indexOf(word));
    }
    return word;
  });

  return words.join(' ');
}
```


## 6. Fibonacci Numbers (Recursion)

Write a recursive function that computes the `nth` Fibonacci number, where `nth` is an argument passed into the function.

Examples: 
``` js
fibonacci(1);       // 1
fibonacci(2);       // 1
fibonacci(3);       // 2
fibonacci(4);       // 3
fibonacci(5);       // 5
fibonacci(12);      // 144
fibonacci(20);      // 6765
```

*Melinda work*

- Input: integer `n`
- Output: the `n`th Fibonacci number

- Algorithm:
- Base cases
  - if n === 1 return 1
  - if n === 2 return 1
  - Assumption: input `n >= 1`
- Recursive call:
  - add together two calls to self with inputs `n-1` and `n-2`

``` js
function fibonacci(n) {
  if (n === 1 || n === 2) { return 1; }
  return fibonacci(n - 1) + fibonacci(n - 2);
}
```

## 7. Fibonacci Numbers (Procedural)

Rewrite the recursive `fibonacci` function so that it computes its results without using recursion. 

Note that JS can accurately compute integers up to 16 digits long. This means `fibonacci(78)` is the largest Fibonacci number you can accurately compute with simple operations in JS.

Examples:
``` js
fibonacci(20);       // 6765
fibonacci(50);       // 12586269025
fibonacci(75);       // 2111485077978050
```

*Melinda work*

- Input: n
- Output: nth fibonacci number

Algorithm:
- Initialize array of fib numbers to hold each fib number we calculate: [1, 1]
- Initialize counter: currentNum = 2
  - currentNum is the last fib number we calculated and lives at index currentNum - 1 of the array.

- While currentNum < n (so while we haven't calculated the nth fib number yet)
  - calculate the next fib number
    - array[currentNum - 1] + array[currentNum - 2]
  - add next fib number to array of fib numbers
  - increment counter

- return last fib number in array (should be nth fib number)

``` js
function fibonacci(n) {
  const fibNums = [1, 1];
  let currentNum = 2;

  while (currentNum < n) {
    fibNums.push(fibNums[currentNum - 1] + fibNums[currentNum - 2]);
    currentNum += 1;
  }

  return fibNums[currentNum - 1];
}
```

Launch school solution takes less memory:
``` js
function fibonacci(nth) {
  let previousTwo = [1, 1];

  for (let counter = 3; counter <= nth; counter += 1) {
    previousTwo = [previousTwo[1], previousTwo[0] + previousTwo[1]];
  }

  return previousTwo[1];
}
```

## 8. Fibonacci Numbers (Memoization)

Memoization is an approach that involves saving a computed answer for future reuse, instead of computing it from scratch every time it is needed. In the case of our recursive fibonacci function, using memoization saves calls to `fibonacci(nth - 2)` because the necessary values have already been computed by the recursive calls to `fibonacci(nth - 1)`.

For this exercise, your objective is to refactor the recursive `fibonacci` function to use memoization.

*Melinda work*

Input: 
- n, the fib number to calculate

Data structures
- Memoization storage: object with key:value n:fibNum

Algorithm
- Base case: if n <= 2, return 1
- Look up fibNumbers object to see if n has been calculated
  - if so, return value
- Otherwise, we haven't calculated the current fibnum
  - make recursive call for n-1 and n-2
  - sum the results of recursive call 
  - add result to memo object
  - and return

``` js
const fibMemo = {
  1: 1,
  2: 1,
};

function fibonacci(n) {
  if (n <= 2) { return 1; }
  if (fibMemo[n]) { return fibMemo[n]; }
  
  const nextFib = fibonacci(n - 1) + fibonacci(n - 2);
  fibMemo[n] = nextFib;
  return nextFib;
}
```