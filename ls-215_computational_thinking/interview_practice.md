## Human Readable Time

Write a function, which takes a non-negative integer (seconds) as input and returns the time in a human-readable format (HH:MM:SS)
- HH = hours, padded to 2 digits, range: 00 - 99
- MM = minutes, padded to 2 digits, range: 00 - 59
- SS = seconds, padded to 2 digits, range: 00 - 59
The maximum time never exceeds 359999 (99:59:59).

Examples:
``` js
console.log(humanReadable(0) === '00:00:00');
console.log(humanReadable(359999) === '99:59:59');
console.log(humanReadable(5) === '00:00:05');
console.log(humanReadable(60) === '00:01:00');
console.log(humanReadable(86399) === '23:59:59');
```

Melinda solution:
``` js
function humanReadable(seconds) {
  const SECONDS_IN_HOUR = 3600;
  const SECONDS_IN_MINUTES = 60;

  const hours = Math.floor(seconds / SECONDS_IN_HOUR);
  const secondsWithoutHours = seconds % SECONDS_IN_HOUR;

  const minutes = Math.floor(secondsWithoutHours / SECONDS_IN_MINUTES);
  const remainingSeconds = secondsWithoutHours % SECONDS_IN_MINUTES;

  const formatTime = (time) => {
    let timeStr = String(time);
    if (timeStr.length === 1) { timeStr = `0${timeStr}`; }
    return timeStr;
  };

  const humanReadableTime = `${formatTime(hours)}:${formatTime(minutes)}:${formatTime(remainingSeconds)}`;

  return humanReadableTime;
}
```

Alternate solution:
``` js
function humanReadable(seconds) {
  const hours = parseInt( seconds / 3600 );
  const minutes = parseInt( seconds / 60 ) % 60;
  const seconds = seconds % 60;
  const pad = function(val){
    return val < 10 ? "0" + val : val;
  }
  return pad(hours) + ":" +pad(minutes) + ":" + pad(seconds);
}
```


## Clean String of '#'

Assume "#" is like a backspace in string. This means that string "a#bc#d" actually is "bd".
Your task is to process a string with "#" symbols.

Examples:
``` js
console.log(cleanString('abc#d##c')); // ==> "ac"
console.log(cleanString('abc##d######')); // ==> ""
console.log(cleanString('#######')); // ==> ""
console.log(cleanString('')); // ==> ""
console.log(cleanString('##f##dc')); // ==> "dc"
```

*Melinda work*

- Input: a string with pounds and other characters
- Output: a string with no pounds

- Rule: "#" is a backspace, meaning the character to the left of "#" is removed (and that "#" is also removed)

Algorithm:
- initialize new string variable - build new string here!
- iterate through the string character by character
  - if #
    - remove the last character from our new string
      - str = str.slice(0, str.length-1)
  - if not #
    - add current character to new string
      - str.concat("y")
- return the new string

``` js
function cleanString(string) {
  let cleanStr = '';

  for (let index = 0; index < string.length; index++) {
    if (string[index] === '#') {
      cleanStr = cleanStr.slice(0, cleanStr.length - 1);
    } else {
      cleanStr = cleanStr.concat(string[index]);
    }
  }

  return cleanStr;
}
```

## Double Cola

Sheldon, Leonard, Penny, Rajesh and Howard are in the queue for a "Double Cola" drink vending machine; there are no other people in the queue. The first one in the queue (Sheldon) buys a can, drinks it and doubles! The resulting two Sheldons go to the end of the queue. Then the next in the queue (Leonard) buys a can, drinks it and gets to the end of the queue as two Leonards, and so on.

For example, Penny drinks the third can of cola and the queue will look like this:
`Rajesh, Howard, Sheldon, Sheldon, Leonard, Leonard, Penny, Penny`

Write a program that will return the name of the person who will drink the n-th cola.

Examples:
``` js
whoIsNext(["Sheldon", "Leonard", "Penny", "Rajesh", "Howard"], 1) == "Sheldon"
whoIsNext(["Sheldon", "Leonard", "Penny", "Rajesh", "Howard"], 52) == "Penny"
whoIsNext(["Sheldon", "Leonard", "Penny", "Rajesh", "Howard"], 7230702951) == "Leonard"
```

*Melinda work*

Input: 
- An array of people
- A number n (count does not start from 0)

Output: 
- name of person drinking the nth drink

Rules: 
- For each "drink"
  - first person is removed from position 1 
  - first person becomes two people
  - the two versions of the first person are appended to the back of the line

Algorithm:
- Initialize counter to 0 -- this counts the number of colas drunk

- While counter is less than n 
  - remove the first person from the front of the line
  - duplicate the first person so there's two of them
  - append both versions of the first person to the back of the line
  - increment the drink counter

- Return the name of the person in the front of the line

``` js
function whoIsNext(people, drinkNum) {
  let currentDrink = 1;

  while (currentDrink < drinkNum) {
    const currentPerson = people.shift();
    people.push(currentPerson);
    people.push(currentPerson);
    currentDrink += 1;
  }

  return people[0];
}
```


## Value of Consonant Substrings 

Given a lowercase string that has alphabetic characters only and no spaces, return the highest value of consonant substrings. Consonants are any letters of the alphabet except "aeiou".

We shall assign the following values: a = 1, b = 2, c = 3, .... z = 26.

For example, for the word "zodiacs", let's cross out the vowels. We get: "z, d, cs".
- The consonant substrings are: "z", "d" and "cs" and the values are z = 26, d = 4 and cs = 3 + 19 = 22. The highest is 26.

Examples: 
``` js
console.log(solve('zodiac')); // 26
console.log(solve('strength')); // 57
console.log(solve('chruschtschov')); // 80
console.log(solve('khrushchev')); // 38
console.log(solve('catchphrase')); // 73
console.log(solve('twelfthstreet')); // 103
console.log(solve('mischtschenkoana')); // 80
```

// Input: a lowercase string of only a-z
// Output: return a number -- highest value of consonant substrings (consecutive consonants)

// Rules
// - We map a = 1, b = 2, ... z = 26
// - Don't count vowels
// - Empty string returns 0

// Data structure: array of strings

// Steps:
// - Guard clause: if empty string, return 0.

// - Initialize array of values and letters for all chars in alphabet
//     - ['', a, b, c, ... z]
//     - [0, 1, 2, ... 25] --> value of the letter is its index
// - Initialize a maximum value variable = 0

// - Remove the vowels from the inputted string
//   - split(/aeiou/) --> 'string' --> ['str', '', 'ng']

// Calculate the value of each consonant substring remaining
//   - Iterate through the array of consonant substrings
//      - sum the values of each character in the substring
//         - 'str' --> 'str'.split('') --> ['s', 't', 'r']
//         - ['s', 't', 'r'] --> map(char => alphabetArray.indexOf(char))
//         - [1, 2, 3] --> sum all elements together (reduce)
//     - I have the sum of the substring. Store in maximum value variable
//       - if currentsum > value in variable, reassign; else, do nothing.
//
// - Return the maximum consonant-substring-value -- stored in maximum value variable

``` js
function solve(string) {
  if (string === '') { return 0; }

  const letters = ['', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'];
  let maxConsonantValue = 0;

  const consonantSubstrs = string.split(/[aeiou]/g);

  consonantSubstrs.forEach((substr) => {
    const chars = subs=;tr.split('');
    const values = chars.map((char) => letters.indexOf(char));

    const sum = values.reduce((sum, value) => sum + value, 0);

    if (sum > maxConsonantValue) { maxConsonantValue = sum; }
  });

  return maxConsonantValue;
}
```

``` js
function solve(string) {
  let substrings = string.split(/[aeiou]+/)
    .filter(string => string.length > 0);
  let values = substrings.map(getValue);
  return values.reduce((max, current) => {
    if (current > max) {
      max = current; 
    }
    return max;
  }, 0);
}


function getValue(substring) {
  return substring.split('')
    .map(char => VALUES[char])
    .reduce((total, current) => total + current);
}
```

## Josephus Survivor

Return who is the "survivor", ie: the last person of a Josephus permutation.

Basically you have to assume that n people are put into a circle and that they are eliminated in steps of k people, like this:

``` js
josephus_survivor(7,3) => means 7 people in a circle;
one every 3 is eliminated until one remains
[1,2,3,4,5,6,7] - initial sequence
[1,2,4,5,6,7] => 3 is counted out
[1,2,4,5,7] => 6 is counted out
[1,4,5,7] => 2 is counted out
[1,4,5] => 7 is counted out
[1,4] => 5 is counted out
[4] => 1 counted out, 4 is the last element - the survivor!
```

Given test cases:
``` js
console.log(josephusSurvivor(7,3)) // 4
console.log(josephusSurvivor(11,19)) // 10
console.log(josephusSurvivor(1,300)) // 1
console.log(josephusSurvivor(14,2)) // 13
```

*Melinda work*

Assume that:
- there will always be at least 1 person in the circle (n >= 1)
- there will be more people in the circle than steps (n > k)

Input: 
- n: number of people in the circle
- k: steps to take before elimination

Output: the number representing the number of the survivor

Rules: 
- people/numbers are in a circle, so if we reach the last number we circle back to the first

Steps:
- Initialize our circle of people
  - Array from 1 through n
    - [1, 2, 3, 4] for `n = 4`
- Initialize currentPersonIdx to 0 (no one has been counted)

- Continuously loop through the following elimination process while array length > 1:

  - Initialize elimination counter to 0 (no steps taken to elimination)
  
  - while elimination tracker < k
    - increment person tracker 
      - if person tracker = array length
        - reinitialize person tracker to first element of circle
      - else 
        - increment by 1
    - increment elimination tracker
      - simple += 1
  
  - once elimination tracker = k
    - find the index of our current person on the pereson tracker
      - should be person tracker - 1
    - remove person from said index
      - circle.splice(index_of_person, 1 person to delete)
  
  - should return back to initializing elimination counter
    - though person counter should remain at the same value

- return survivor (i.e. only element in array)  

``` js
function josephusSurvivor(n, k) {
  // initialize circle of people
  const circle = [];
  for (let person = 1; person <= n; person += 1) {
    circle.push(person);
  }
  let currentPersonIdx = 0; // This is the first person's position
  let eliminationCounter = 1;

  while (circle.length > 1) {
    while (eliminationCounter < k) {
      if (currentPersonIdx >= circle.length - 1) {
        currentPersonIdx = 0;
      } else {
        currentPersonIdx += 1;
      }

      eliminationCounter += 1;
    }

    circle.splice(currentPersonIdx, 1);
    eliminationCounter = 0;
    currentPersonIdx -= 1;
  }

  return circle[0];
}
```

Dorey's Solution:
``` js
function josephusSurvivor(num, interval) {
  let survivors = new Array(num).fill(0).map((val, idx) => idx + 1);
  let count = 0;
  
  while (survivors.length > 1) {
    count = (count - 1 + interval) % survivors.length;
    console.log(`count ${count}`);
    survivors.splice(count, 1);
    console.log(survivors);
  }
  // console.log(survivors);
  
  return survivors[0];
}
```

## Factorial Decomposition

Decompose n! (factorial n) into its prime factors.

Examples:
``` js
n = 12; decomp(12) // "2^10 * 3^5 * 5^2 * 7 * 11"
// since 12! is divisible by 2 ten times, by 3 five times, by 5 two times and by 7 and 11 only once.

n = 22; decomp(22) // "2^19 * 3^9 * 5^4 * 7^3 * 11^2 * 13 * 17 * 19"

n = 25; decomp(25) // 2^22 * 3^10 * 5^6 * 7^3 * 11^2 * 13 * 17 * 19 * 23
```

Prime numbers should be in increasing order. When the exponent of a prime is 1 don't put the exponent.

Tests:
``` js
testing(17, "2^15 * 3^6 * 5^3 * 7^2 * 11 * 13 * 17")
testing(5, "2^3 * 3 * 5")
testing(22, "2^19 * 3^9 * 5^4 * 7^3 * 11^2 * 13 * 17 * 19")
```

### 

// Description:
// Encrypt this!

// You want to create secret messages which can be deciphered by the Decipher this! kata. Here are the conditions:

// Your message is a string containing space separated words.
// You need to encrypt each word in the message using the following rules:
// The first letter needs to be converted to its ASCII code.
// The second letter needs to be switched with the last letter
// Keepin' it simple: There are no special characters in input.

// Examples:
// encrypt_this("Hello") == "72olle"
// encrypt_this("good") == "103doo"
// encrypt_this("hello world") == "104olle 119drlo"

// encrypt_this("") == ""
// encrypt_this("do") == "100o"

// Input: string containing space-separated words
// Output: an encrypted string following rules

// Rules:
// - Convert the first letter into its ASCII code
// - 'string'.charCodeAt(idx)
// - Switch second letter with last letter
// - Input only contains alphanumeric


// Algorithm 

// - Split the string input into its word components
  // - 'puppi dog' -> ['puppi', 'dog']
  // - string.split(' ')

// - For each word component
  // - 'puppi'
  // - Replace the first character with its ASCII code
    // - to get ascii code: 'puppi'.charCodeAt(0)
    // - String(charcode) + 'uppi' (slice operation on the string)
  // - Switch the second letter with the last letter
    // - second character: 'puppi'.slice(1, 2)
    // - last character: 'puppi'.slice(-1)
    // - substring inbetween: 'puppi'.slice(2, length - 1)
    // - with these slices of strings, we can piece together the encrypted word!

// Rejoin the word components back into one string
  // - ['puppi', 'dog'] --> 'puppi dog' (except encrypted)
  // - words.join(' ')

// ^ Return string

function encrypt_this(sentence) {
  if (sentence === '') { return ''; }
  
  let words = sentence.split(' ');
  words = words.map(word => encryptWord(word));
  
  return words.join(' ');
}

function encryptWord(word) {
  const firstCharCode = String(word.charCodeAt(0));
  const secondChar = word.slice(1, 2);
  const lastChar = word.slice(-1);
  const inBetween = word.slice(2, word.length - 1);
  
  if (word.length <= 2) { return firstCharCode + secondChar }
  
  return firstCharCode + lastChar + inBetween + secondChar;
}


## Sentiment Analysis

/*
Sentiment analysis, sometimes known as opinion mining, attempts to ascertain subjective information from a text and convert it to something concrete. For example, by using lists of positive and negative words, we can analyze the words in some text to determine whether the mood is positive, negative, or neutral.

Sentiment analysis adds a dimension to content that is mostly text based. Its main task is to classify the polarity of the text. In this practice problem, we will build a tool that determines the mood of some text. Note that we will take a simplistic approach. We don't recommend this approach for live sentiment analysis.

There are many ways to implement sentiment analysis. Here, we will use two arrays of words. One array contains words that connote a "positive" sentiment, while the other contains words that connote a "negative" sentiment. Given the counts of positive and negative words in our text, we can compute a sentiment score as the difference between the two counts, "positive word count - negative word count." The sentiment of the text is positive if the difference is positive, negative if the difference is negative, and neutral if the difference is 0 (the word counts are equal).

Implement a function that takes some text as an argument and logs some information about whether the text has a positive, negative, or neutral sentiment.

Here's an excerpt of some text taken from a Wikipedia article that compares different versions of "To be, or not to be".

Input: a text block (string)
Output: in console -- we print a report

Data structures:
- given string block + sentinment lookup in arrays
- I'm going to work with an array of words

Algorithm:
- Initialize counts
  - positive = 0
  - negative = 0 
  
- Process the text block for analysis
  - Split the text into an array of words
  - (split())
  - 'hello world' --> ['hello', 'world']
  
- With our array of words, iterate through each word to assess it's sentiment
  - 'hello' --> is it good or bad?
  - want to check if 'hello' is included in positiveWords or negativeWords
    - includes() 
    - if the current word is included in positiveWords, 
      - increment our positiveWords count
    - if it's in the negativeWords
      - increment our negativeWords count

- We've determined whether each word is positive, negative or not either
- We've completed counting our positive and negative sentiments

- Output our report into console
  - copy and paste given report and format appropriately 

*/

let textExcerpt = 'To be or not to be-that is the question:\n' +
  'Whether \'tis nobler in the mind to suffer\n' +
  'The slings and arrows of outrageous fortune,\n' +
  'Or to take arms against a sea of troubles,\n' +
  'And, by opposing, end them. To die, to sleep-\n' +
  'No more-and by a sleep to say we end\n' +
  'The heartache and the thousand natural shocks\n' +
  'That flesh is heir to-\'tis a consummation\n' +
  'Devoutly to be wished. To die, to sleep-\n' +
  'To sleep, perchance to dream. Aye, there\'s the rub,\n' +
  'For in that sleep of death what dreams may come,\n' +
  'When we have shuffled off this mortal coil,\n' +
  'Must give us pause. There\'s the respect\n' +
  'That makes calamity of so long life.\n' +
  'For who would bear the whips and scorns of time,\n' +
  'Th\' oppressor\'s wrong, the proud man\'s contumely, [F: poor]\n' +
  'The pangs of despised love, the law’s delay, [F: disprized]\n' +
  'The insolence of office, and the spurns\n' +
  'That patient merit of the unworthy takes,\n' +
  'When he himself might his quietus make\n' +
  'With a bare bodkin? Who would fardels bear, [F: these Fardels]\n' +
  'To grunt and sweat under a weary life,\n' +
  'But that the dread of something after death,\n' +
  'The undiscovered country from whose bourn\n' +
  'No traveler returns, puzzles the will\n' +
  'And makes us rather bear those ills we have\n' +
  'Than fly to others that we know not of?\n' +
  'Thus conscience does make cowards of us all,\n' +
  'And thus the native hue of resolution\n' +
  'Is sicklied o\'er with the pale cast of thought,\n' +
  'And enterprises of great pitch and moment, [F: pith]\n' +
  'With this regard their currents turn awry, [F: away]\n' +
  'And lose the name of action.-Soft you now,\n' +
  'The fair Ophelia.-Nymph, in thy orisons\n' +
  'Be all my sins remembered';

let positiveWords = ['fortune', 'dream', 'love', 'respect', 'patience', 'devout', 'noble', 'resolution'];
let negativeWords = ['die', 'heartache', 'death', 'despise', 'scorn', 'weary', 'trouble', 'oppress'];

function sentiment(text) {
  let positive = [];
  let negative = [];
  const words = text.match(/\b[a-z]+\b/ig);
  
  words.forEach(word => {
    if (positiveWords.includes(word)) { 
      positive.push(word);
    };
    if (negativeWords.includes(word)) { 
      negative.push(word);
    };
  });
  
  let sentiment = '';
  
  if ((positive.length - negative.length) > 0) {
    sentiment = 'Positive';
  } else if ((positive.length - negative.length) < 0) {
    sentiment = 'Negative';
  } else {
    sentiment = 'Neutral';
  }
  
  console.log(`There are ${positive.length} positive words in the text.`)
  console.log(`Positive sentiments: ${positive.join(', ')}`);
  console.log('\n');
  console.log(`There are ${negative.length} negative words in the text.`)
  console.log(`Negative sentiments: ${negative.join(', ')}`);
  console.log('\n');
  console.log(`The sentiment of the text is ${sentiment}.`);
}

sentiment(textExcerpt);

/* console output

Algorithm:
- Initialize counts
  - positive = 0
  - negative = 0 
  
- Process the text block for analysis
  - Split the text into an array of words
  - 'hello world' --> ['hello', 'world']
  
- With our array of words, iterate through each word to assess it's sentiment
  - 'hello' --> is it good or bad?
  - want to check if 'hello' is included in positiveWords or negativeWords
    - includes() 
    - if the current word is included in positiveWords, 
      - increment our positiveWords count
    - if it's in the negativeWords
      - increment our negativeWords count

- We've determined whether each word is positive, negative or not either
- We've completed counting our positive and negative sentiments

- Output our report into console
  - copy and paste given report and format appropriately 


There are 5 positive words in the text.
Positive sentiments: fortune, dream, respect, love, resolution

There are 6 negative words in the text.
Negative sentiments: die, heartache, die, death, weary, death

The sentiment of the text is Negative.
*/


