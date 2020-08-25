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

Write a function that takes a string argument, and returns a list of all substrings that start from the beginning of the string, ordered from shortest to longest.

Examples:
``` js
leadingSubstrings('abc');      // ["a", "ab", "abc"]
leadingSubstrings('a');        // ["a"]
leadingSubstrings('xyzzy');    // ["x", "xy", "xyz", "xyzz", "xyzzy"]
```

Input: a string
Output: Every sequential substring that starts with the first character of the string

Algorithm: 
- Prepare the string for processing
  - Split the string into an array of characters
    - ['c', 'a', 't']

- Find all sequential substrings starting with first char
  - Change each element of the array of characters such that the element is the an array of characters, first char of the string up through the current
  - Then for each subarray, combine all elements into a string and un-array-ify
    - ['c', 'ca', 'cat']
    - arr.mapWIdx( arr.slice(0, idx).join('') ) 
      - (map returns new array)
  
  - at this point, we should have an array of the correct substrings

- return array of substrings 

``` js
function leadingSubstrings(string) {
  const chars = string.split('');

  const subStrings = chars.map((char, idx) => chars.slice(0, idx + 1).join(''));

  return subStrings;
}
```

Launch School Solution:
``` js
function leadingSubstrings(string) {
  let substrings = [];
  for (let length = 1; length <= string.length; length += 1) {
    substrings.push(string.slice(0, length));
  }

  return substrings;
}
```

## 6. All Substrings

Write a function that returns a list of all substrings of a string. Order the returned list by where in the string the substring begins. This means that all substrings that start at position 0 should come first, then all substrings that start at position 1, and so on. Since multiple substrings will occur at each position, return the substrings at a given position from shortest to longest.

You may (and should) use the `leadingSubstrings` function you wrote in the previous exercise.

Example:
``` js
substrings('abcde');

// returns
[ "a", "ab", "abc", "abcd", "abcde",
  "b", "bc", "bcd", "bcde",
  "c", "cd", "cde",
  "d", "de",
  "e" ]
```

*Melinda work*

``` js
function substrings(string) {
  let allSubstrings = [];

  for (let index = 0; index < string.length; index += 1) {
    const currentSlice = string.slice(index);
    allSubstrings = allSubstrings.concat(leadingSubstrings(currentSlice));
  }

  return allSubstrings;
}
```

## 7. Palindromic Substrings

Write a function that returns a list of all substrings of a string that are palindromic. That is, each substring must consist of the same sequence of characters forwards as backwards. The substrings in the returned list should be sorted by their order of appearance in the input string. Duplicate substrings should be included multiple times.

You may (and should) use the `substrings` function you wrote in the previous exercise.

For the purpose of this exercise, you should consider all characters and pay attention to case; that is, `'AbcbA'` is a palindrome, but `'Abcba'` and `'Abc-bA'` are not. In addition, assume that single characters are not palindromes.

Examples:
``` js
palindromes('abcd');       // []
palindromes('madam');      // [ "madam", "ada" ]
```

*Melinda work*

Input: a string
Output: an array of palindromic substrings

Rules: 
- all characters count (including non-alphanumeric)
- palindromes are case-sensitive

Substrings returns all sequential substrings

Algorithm:
- isPalindrome?
  - input: string
  - output: boolean

  - split the string into two halves
    - if it's odd, then the most-center character is left out
    - Math.floor(string.length) --> index of the last character in the first half
    - first half: string.slice(0, ^)
    - second half: string.slice(-^)
  - reverse the characters in the second half of the string
    - split reverse join
  - see if first half === second half
    - if true, return true
    - else return false
    - ^ don't actually write if...else...

- main palindrome finder function
  - initialize array to accumulate palindromes
  - create an array of all seq substrings using substrings function
  - iterate through each of the substrings
    - see if it is a palindrom
      - if so, add to accumulator array
  - return array of palindromes

``` js
function isPalindrome(string) {
  if (string.length === 1) { return false; }

  const chars = string.split('');
  const halfLength = Math.floor(string.length);
  const firstHalf = string.slice(0, halfLength);
  const secondHalf = string.slice(-1 * halfLength)
    .split('')
    .reverse()
    .join('');

  return firstHalf === secondHalf;
}

function palindromes(string) {
  const palindromicSubstrings = [];
  const allSubstrings = substrings(string);

  allSubstrings.forEach((substring) => {
    if (isPalindrome(substring)) {
      palindromicSubstrings.push(substring);
    }
  });

  return palindromicSubstrings;
}
```

Launch School Solution:
``` js
function isPalindrome(word) {
  return word.length > 1 && word === word.split('').reverse().join('');
}

function palindromes(string) {
  return substrings(string).filter(isPalindrome);
}
```

## 8. Grocery List

Write a function that takes a grocery list (a 2D array) with each element containing a fruit and a quantity, and returns a one-dimensional array of fruits in which each fruit appears a number of times equal to its quantity.

Example:
``` js
buyFruit([['apple', 3], ['orange', 1], ['banana', 2]]);
// returns ["apple", "apple", "apple", "orange", "banana", "banana"]
```

*Melinda work*

Input: a 2D array where every subelement is fruit-quantity
Output: a 1D array where every subelement is fruit

``` js
function buyFruit(list) {
  const newList = list.flatMap((item) => {
    const fruit = item[0];
    const quantity = item[1];
    let counter = 0;
    const newItem = [];

    do {
      newItem.push(fruit);
      counter += 1;
    } while (counter < quantity);

    return newItem;
  });

  return newList;
}
```

Note to self: I wanted to try using `flatMap` and a `do...while...` loop. 


## 9. Inventory Item Transactions

Write a function that takes two arguments, `inventoryItem` and `transactions`, and returns an array containing only the transactions for the specified `inventoryItem`. 

Examples:
``` js
const transactions = [ { id: 101, movement: 'in',  quantity:  5 },
                       { id: 105, movement: 'in',  quantity: 10 },
                       { id: 102, movement: 'out', quantity: 17 },
                       { id: 101, movement: 'in',  quantity: 12 },
                       { id: 103, movement: 'out', quantity: 15 },
                       { id: 102, movement: 'out', quantity: 15 },
                       { id: 105, movement: 'in',  quantity: 25 },
                       { id: 101, movement: 'out', quantity: 18 },
                       { id: 102, movement: 'in',  quantity: 22 },
                       { id: 103, movement: 'out', quantity: 15 }, ];

console.log(transactionsFor(101, transactions));
// returns
// [ { id: 101, movement: "in",  quantity:  5 },
//   { id: 101, movement: "in",  quantity: 12 },
//   { id: 101, movement: "out", quantity: 18 }, ]
```

*Melinda work*

Input: 
  - an item id (number)
  - an array of transactions 
    - transaction (object with keys id, movement, quantity)
Return:
  - an array of transactions for inputted item with matching id
    - array of transaction objects

Algorithm:
  <!-- - Setup
    - Initialize accumulator array -->
  
  - Iterate through transactions 
    - Check if transaction contains matching item ID 
      - If so, push transaction object to accumulator 
    - Filter??? returns new array? so no accumulator required
  <!-- - Return accumulator -->

``` js
function transactionsFor(itemId, transactions) {
  return transactions.filter((transaction) => transaction.id === itemId);
}
```

## 10. Inventory Item Availability

Building on the previous exercise, write a function that returns `true` or `false` based on whether or not an inventory `item` is available. As before, the function takes two arguments: an inventory `item` and a list of `transactions`. The function should return `true` only if the sum of the `quantity` values of the `item`'s transactions is greater than zero. Notice that there is a `movement` property in each transaction object. A `movement` value of `'out'` will decrease the `item`'s `quantity`. 

You may (and should) use the `transactionFor` function from the previous exercise.

*Melinda work*

Input: an item id (number) and transactions (array of objects)
Output: true or false

Algorithm:
- retrieve all transactions of desired item using `transactionFor`
- for each transaction of desired item
  - if the movement is in
    - add quantity to accumulator
  - else movement is out
    - subtract quantity from accumulator
- return if accumulator is > 0

``` js
function isItemAvailable(itemId, transactions) {
  const itemTransactions = transactionsFor(itemId, transactions);
  let numAvailable = 0;

  itemTransactions.forEach((record) => {
    if (record.movement === 'in') {
      numAvailable += record.quantity;
    } else {
      numAvailable -= record.quantity;
    }
  });

  return numAvailable > 0;
}
```

Launch School solution with reduce:
``` js
function isItemAvailable(item, transactions) {
  const quantity = transactionsFor(item, transactions).reduce((sum, transaction) => {
    if (transaction.movement === 'in') {
      return sum + transaction.quantity;
    } else {
      return sum - transaction.quantity;
    }
  }, 0);

  return quantity > 0;
}
```