## 1. Sum of Digits

Write a function that takes one argument, a positive integer, and returns the sum of its digits. Do this without using `for`, `while`, or `do...while` loops - instead, use a series of method calls to perform the sum.

*Melinda work*

Input: a positive integer (number)
Output: sum of the digits

Algorithm:
- convert the inputted number into a string 
- split the string into an array of digits
- map a string-to-number conversion for each digit
- reduce array to sum

``` js
function sum(number) {
  return String(number).split('')
    .map((digit) => Number(digit))
    .reduce((accumulator, digit) => accumulator + digit);
}
```

## 2. Alphabetical Numbers

Write a function that takes an array of integers between `0` and `19`, and returns an array of those integers sorted based on the English word for each number:
``` js
alphabeticNumberSort(
   [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19]);
// [8, 18, 11, 15, 5, 4, 14, 9, 19, 1, 7, 17, 6, 16, 10, 13, 3, 12, 2, 0]
```

*Melinda work*

Input: an array of integers between 0 and 19
Output: a sorted array of integers based on English spelling

Algorithm: 
- create a mapping of int to word
  - object with key:value of int:word
- invoke array.sort with a custom comparison function
  - we want to compare obj[int1] < obj[int2]
- return sorted array

``` js
function alphabeticNumberSort(numbers) {
  const intToWords = {
    0: 'zero',
    1: 'one',
    2: 'two',
    3: 'three',
    4: 'four',
    5: 'five',
    6: 'six',
    7: 'seven',
    8: 'eight',
    9: 'nine',
    10: 'ten',
    11: 'eleven',
    12: 'twelve',
    13: 'thirteen',
    14: 'fourteen',
    15: 'fifteen',
    16: 'sixteen',
    17: 'seventeen',
    18: 'eighteen',
    19: 'nineteen',
  };

  numbers.sort((int1, int2) => {
    if (intToWords[int1] < intToWords[int2]) {
      return -1;
    }
    if (intToWords[int1] > intToWords[int2]) {
      return 1;
    }

    return 0;
  });

  return numbers;
}
```

## 3. Multiply All Pairs

Write a function that takes two array arguments, each containing a list of numbers, and returns a new array containing the products of all combinations of number pairs that exist between the two arrays. The returned array should be sorted in ascending numerical order. You may assume that neither argument will be an empty array.

Examples:
`multiplyAllPairs([2, 4], [4, 3, 1, 2]);`

*Melinda work*

Input: two arrays of numbers
Output: an array with every multiplication pair from each array's numbers

Algorithm:
- initialize array of multiples
- for each number in array1
  - map multiplication of array1num to each number in array2
  - concatenate resulting mapped array to array of multiples
- return array of multiples

``` js
function multiplyAllPairs(array1, array2) {
  let multiples = [];

  array1.forEach((number) => {
    const currentMultiples = array2.map((number2) => number2 * number);
    multiples = multiples.concat(currentMultiples);
  });

  return multiples.sort((a, b) => a - b);
}
```

## 4. Sum of Sums

Write a function that takes an array of numbers, and returns the sum of the sums of each leading subsequence for that array. You may assume that the array always contains at least one number.

Examples: 
``` js
sumOfSums([3, 5, 2]);        // (3) + (3 + 5) + (3 + 5 + 2) --> 21
sumOfSums([1, 5, 7, 3]);     // (1) + (1 + 5) + (1 + 5 + 7) + (1 + 5 + 7 + 3) --> 36
sumOfSums([4]);              // 4
sumOfSums([1, 2, 3, 4, 5]);  // 35
```

*Melinda work*

Input: an array of numbers
Output: a number

Steps:
- initialize accumulator array
- iterate through the given array
  - sum current number and all numbers preceeding
    - slice the array from 0 until current index
    - reduce array to a sum
  - store sum in accumulator array
- reduce accumulator array to find sum of sums! return this.

``` js
function sumOfSums(numbers) {
  const sums = [];

  for (let index = 1; index <= numbers.length; index += 1) {
    const currentSequence = numbers.slice(0, index);
    const currentSum = currentSequence.reduce((accum, number) => accum + number);
    sums.push(currentSum);
  }

  return sums.reduce((accum, sum) => accum + sum);
}
```

Launch School's Solution:
``` js
function sumOfSums(numbers) {
  return numbers.map((number, idx) => numbers.slice(0, idx + 1)
                                             .reduce((sum, value) => sum + value))
                                             .reduce((sum, value) => sum + value);
}
```
If the LS solution doesn't make much sense, go look at their explanation!

## 5. Leading Substrings

## 6. All Substrings

## 7. Palindromic Substrings

## 8. Grocery List

## 9. Inventory Item Transactions

## 10. Inventory Item Availability

