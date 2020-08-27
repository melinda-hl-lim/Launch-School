## 1. Uppercase Check

Write a function that takes a string argument, and returns `true` if all of the alphabetic characters inside the string are uppercase; `false` otherwise. Ignore characters that are not alphabetic.

``` js
function isUppercase(string) {
  return !/[a-z]/.test(string);
}
```

Using `RegExp.prototype.test()`: the `test()` method executes a search for a match between a regular expression and a specified string. If there is at least one match, it returns `true`.

## 2. Delete Vowels

Write a function that takes an array of strings and returns an array of the same strings values without the vowels (aeiou).

Examples:
``` js
removeVowels(['abcdefghijklmnopqrstuvwxyz']);         
// ["bcdfghjklmnpqrstvwxyz"]
removeVowels(['green', 'YELLOW', 'black', 'white']);  
// ["grn", "YLLW", "blck", "wht"]
removeVowels(['ABC', 'AEIOU', 'XYZ']);                
// ["BC", "", "XYZ"]
```

``` js
function removeVowels(strings) {
  return strings.map((string) => string.replace(/[aeiou]/gi, ''));
}
```

## 3. Lettercase Counter

Write a function that takes a string and returns an object containing three properties; one representing the number of characters in the string that are lowercase letters, one representing the number of characters that are uppercase letters, and one representing the number of characters that are neither.

Examples:
``` js
letterCaseCount('abCdef 123');  
// { lowercase: 5, uppercase: 1, neither: 4 }
letterCaseCount('AbCd +Ef');    
// { lowercase: 3, uppercase: 3, neither: 2 }
letterCaseCount('123');         
// { lowercase: 0, uppercase: 0, neither: 3 }
letterCaseCount('');            
// { lowercase: 0, uppercase: 0, neither: 0 }
```

Algorithm:
- initialize counter object
- split the string into an array of characters
- for each character in the string
  - looks like a case switch
  - if it matches lowercase regex, add 1 to this count
  - if it matches uppercase regex, add 1 to this count
  - if it matches neither letter regex, add 1 to this count
- return counter object

``` js
function letterCaseCount(string) {
  const counts = {
    lowercase: 0,
    uppercase: 0,
    neither: 0,
  };
  const chars = string.split('');
  console.log(chars);

  chars.forEach((char) => {
    if (/[a-z]/.test(char)) {
      counts.lowercase += 1;
    } else if (/[A-Z]/.test(char)) {
      counts.uppercase += 1;
    } else {
      counts.neither += 1;
    }
  });

  return counts;
}
```

Launch School's Solution
``` js
function letterCaseCount(string) {
  const lowerArray = string.match(/[a-z]/g) || [];
  const upperArray = string.match(/[A-Z]/g) || [];
  const neitherArray = string.match(/[^a-z]/gi) || [];

  return {
    lowercase: lowerArray.length,
    uppercase: upperArray.length,
    neither: neitherArray.length,
  };
}
```

## 4. Capitalize Words

Write a function that takes a string as an argument, and returns that string with the first character of every word capitalized and all subsequent characters in lowercase. 

You may assume that a word is any sequence of non-whitespace characters.

Examples:
``` js
wordCap('four score and seven');       
// "Four Score And Seven"
wordCap('the javaScript language');    
// "The Javascript Language"
wordCap('this is a "quoted" word');    
// 'This Is A "quoted" Word'
```

Algorithm
- Split the string into an array of words
- map to each word
  - first char in upper case + rest of word
- join words into a string
- return 

``` js
function wordCap(string) {
  return string.split(' ')
    .map((word) => word.slice(0, 1).toUpperCase() + word.slice(1))
    .join(' ');
}
```

## 5. Swap Case

Write a function that takes a string as an argument and returns that string with every lowercase letter changed to uppercase and every uppercase letter changed to lowercase. Leave all other characters unchanged.

``` js
swapCase('CamelCase');              // "cAMELcASE"
swapCase('Tonight on XYZ-TV');      // "tONIGHT ON xyz-tv"
```

Algorithm
- split the string into an array of characters
- for each character
  - if it matches uppercase regex, 
    - convert it to a lowercase
  - if it matches lowercase regex
    - convert it to an uppercase
  - else
    - do nothing with that character
- join characters back into a string
- return

``` js
function swapCase(words) {
  return words.split('')
    .map((char) => {
      if (/[a-z]/.test(char)) {
        return char.toUpperCase();
      }
      if (/[A-Z]/.test(char)) {
        return char.toLowerCase();
      }
      return char;
    })
    .join('');
}
```

## 6. Staggered Caps Part 1

Write a function that takes a string as an argument, and returns that string with a staggered capitalization scheme. Every other character, starting from the first, should be capitalized and should be followed by a lowercase or non-alphabetic character. Non-alphabetic characters should not be changed, but should be counted as characters for determining when to switch between upper and lower case.

Examples:
``` js
staggeredCase('I Love Launch School!');        
// "I LoVe lAuNcH ScHoOl!"
staggeredCase('ALL_CAPS');                     
// "AlL_CaPs"
staggeredCase('ignore 77 the 444 numbers');    
// "IgNoRe 77 ThE 444 NuMbErS"
```

Rules:
- staggered capitalization: first character upper case, every other character following should be uppercase
- non-alphabet characters aren't changed but count in our character count
  - i.e. OnE TwO --> notice how E and T are both capitalized? The space counted as a "lowercase" character

Algorithm
- split the given string into an array of characters
- for every character in the array
  - if the array index is even ( % 2 === 0) 
    - convert this character into uppercase
  - else the array index is odd
    - convert this character into lowercase
- join the characters back into a string
- return string

``` js
function staggeredCase(string) {
  return string.split('')
    .map((char, idx) => {
      if (idx % 2 === 0) {
        return char.toUpperCase();
      }
      return char.toLowerCase();
    })
    .join('');
}
```

## 7. Staggered Caps Part 2

Modify the function from the previous exercise so that it ignores non-alphabetic characters when determining whether a letter should be upper or lower case. Non-alphabetic characters should still be included in the output string, but should not be counted when determining the appropriate case.

Examples:
``` js
staggeredCase('I Love Launch School!');        
// "I lOvE lAuNcH sChOoL!"
staggeredCase('ALL CAPS');                     
// "AlL cApS"
staggeredCase('ignore 77 the 444 numbers');    
// "IgNoRe 77 ThE 444 nUmBeRs
```

Algorithm
- Create staggercase counter - set to 0
- Split string into array of characters
- For each character in array
  - if it's an alphabet character
    - if the counter is even
      - change to uppercase char
    - else change to lowercase char
    - then increment counter
  - if it's not a letter, do nothing with the character
- Join the characters into a string
- Return

``` js
function staggeredCase(string) {
  let staggerCounter = 0;
  let chars = string.split('');

  chars = chars.map((char) => {
    if (/[a-z]/i.test(char)) {
      if (staggerCounter % 2 === 0) {
        staggerCounter += 1;
        return char.toUpperCase();
      }
      staggerCounter += 1;
      return char.toLowerCase();
    }
    return char;
  });

  return chars.join('');
}
```

Launch School's Solution:
``` js
function staggeredCase(string) {
  let needUpper = true;
  let newChar;

  return string.split('').map(char => {
    if (char.match(/[a-z]/i)) {
      if (needUpper) {
        newChar = char.toUpperCase();
      } else {
        newChar = char.toLowerCase();
      }

      needUpper = !needUpper;
      return newChar;
    } else {
      return char;
    }
  }).join('');
}
```
Rather than using a counter, using a boolean that flips from true to false is a much clearer way of conveying what's happening. 

## 8. How Long Are You

Write a function that takes a string as an argument, and returns an array that contains every word from the string, with each word followed by a space and the word's `length`. If the argument is an empty string or if no argument is passed, the function should return an empty array.

You may assume that every pair of words in the string will be separated by a single space.

Examples:
``` js
wordLengths('cow sheep chicken');
// ["cow 3", "sheep 5", "chicken 7"]

wordLengths('baseball hot dogs and apple pie');
// ["baseball 8", "hot 3", "dogs 4", "and 3", "apple 5", "pie 3"]

wordLengths("It ain't easy, is it?");
// ["It 2", "ain't 5", "easy, 5", "is 2", "it? 3"]

wordLengths('Supercalifragilisticexpialidocious');
// ["Supercalifragilisticexpialidocious 34"]

wordLengths('');      // []
wordLengths();        // []
```

Input: a string of words
Output: an array where each element is the word and its length

Rules:
- if argument is an empty string, return an empty array

Algorithm:
- split string into an array of words
- map to each word
  - word = `word + ${length}`
- return the array

``` js
function wordLengths(words) {
  if (!(words)) { return []; }

  return words.split(' ')
    .map((word) => `${word} ${String(word.length)}`);
}
```

## 9. Search Word Part 1

Write a function that takes a `word` and a string of `text` as arguments, and returns an integer representing the number of times the `word` appears in the `text`.

You may assume that the `word` and `text` inputs will always be provided.

Example:
``` js
const text = 'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?';

searchWord('sed', text); // 3
```

``` js
function searchWord(word, text) {
  const regex = new RegExp(word, 'gi');
  const matches = text.match(regex);

  return matches ? matches.length : 0;
}
```

To make sure this function doesn't match `word` when it's a substring of another word (i.e. 'pup' in 'Puppi'), we can use word boundaries with our regex:
``` js
const regex = new RegExp(`\\b${word}\\b`, 'gi');
```

## 10. Search Word Part 2

The function from the previous exercise returns the number of occurrences of a word in some text. Although this is useful, there are also situations in which we just want to find the word in the context of the text.

For this exercise, write a function that takes a `word` and a string of `text` as arguments, and returns the `text` with every instance of the `word` highlighted. To highlight a word, enclose the word with two asterisks ( ** ) on each side and change every letter of the word to uppercase (e.g. '**HIGHLIGHTEDWORD**').

``` js
function searchWord(word, text) {
  const regex = new RegExp(`\\b${word}\\b`, 'gi');
  return text.replace(regex, `**${word.toUpperCase()}**`);
}
```