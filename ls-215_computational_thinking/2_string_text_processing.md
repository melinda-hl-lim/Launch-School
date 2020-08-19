## String Processing Patterns

String or text processing is the manipulation of text-based content. It usually follow this pattern:
1. Declare a new string/array to contain the result. 
2. Break down or parse the original string. Remove any unneeded characters from the text.
3. Apply suitable list processing strategy
4. Combine the individual results into a new string if needed

We can also use **Regular Expressions**, a sequence of "patterns" that define/create a search criterion. We can use to: search and replace; build a list; validate text, ... 

JavaScript has two built-in objects with regular expressions:
- `String` with methods `String.prototype.search`, `String.prototype.match`, `String.prototype.replace`
- `RegExp` with methods `RegExp.prototype.exec`, `RegExp.prototype.test`


## String Methods

Reviewing some string methods:

- `indexOf`: returns numeric index of a character/substring within a string. Returns `-1` if the char/substring doesn't exist.

- `lastIndexOf`: returns numeric index of last occurrence of a character/substring. Return `-1` if no match.

- `replace`: performs a substitution operation on the original string and returns the result as a new string
  - if you use a substring, it only replaces the first occurance
  - if you use regex, it replaces all occurances

- `split`: splits the string into an array of strings based on a separator.

- `substring`: extracts and returns a portion of the original string that lies in the range specified by two arguments, the indices of the string we wish to extract.

**Note**: `substring` and `substr` are two different string methods. They interpret the second argument differently.
  - `substr`: second argument specifies number of characters to include afterwards
  - `substring`: second index specifies index of first character to not include (i.e. index end range)

- `toUpperCase` and `toLowerCase`

Find all the other string methods here: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String


## Regular Expressions

Regex is important for text processing: we can write highly expressive and declarative code for matching patterns in strings. 

Now is time to read the regex book...

Regex book has a cheatsheet in the conclusion!


## Reverse a String

Implement a function that takes a string as an argument and returns a new string that contains the original string in reverse.

``` js
function reverse(string) {
  let splitStr = string.split("");
  let reverseStr = ""

  for (let index = splitStr.length - 1; index >= 0; index--) {
    reverseStr += splitStr[index];
  }

  return reverseStr;
}
```


## Acronym

Write a function that generates and returns an acronym from a string of words. For example, the function should return "PNG" for the string "Portable Network Graphics". Count compound words (words connected with a dash) as separate words.

``` js
function acronym(string) {
  let splitStr = string.split(/(\s|-)/);
  let acronym = "";

  splitStr.forEach(word => acronym += word[0].toUpperCase());
  return acronym;
}
```
**The REGEX in the solution above is wrong. Function misbehaves.**


## Email Validation

Implement a function that checks whether an email address is valid. The email address has two parts: a "local part" and a "domain part". An `@` sign separates the two parts: `local-part@domain-part`. 

For this problem, use the following criteria to determine whether an email address is valid:
- There must be one `@` sign
- Local part must contain one or more letters or digits - no other characters
- the domain part must contain two or more components with a single `.` between each component. Each component must contain one or more letters only.

``` js
function isValidEmail(email) {
  return /^[a-z0-9]+@([a-z]+\.)+[a-z]+$/i.test(email);
}
```


## Matching Parentheses

Write a function that takes a string as an argument and returns `true` if the string contains properly balanced parentheses, `false` otherwise. Parentheses are properly balanced only when `(` and `)` occur in matching pairs, with each pair starting with `(`.

``` js
function isBalanced(string) {
  let counter = 0;

  for (let index = 0; index < string.length; index++) {
    if (string[index] === "(") {
      counter++;
    } else if (string[index] === ")") {
      counter--;
    };

    if (counter < 0) {return false;}
  }

  return counter === 0;
}
```


## Sentiment Analysis 1

Implement a function that takes some text as an argument and logs some information about whether the text has a positive, negative or netural sentiment.

``` js
let positiveWords = ['fortune', 'dream', 'love', 'respect', 'patience', 'devout', 'noble', 'resolution'];
let negativeWords = ['die', 'heartache', 'death', 'despise', 'scorn', 'weary', 'trouble', 'oppress'];

function sentiment(text) {
  let positive = [];
  let negative = [];

  let wordList = text.toLowerCase().match(/[a-z']+/g);

  wordList.forEach(word => {
    if (positiveWords.includes(word)) {
      positive.push(word);
    } else if (negativeWords.includes(word)) {
      negative.push(word);
    };
  })

  console.log(
    `There are ${positive.length} positive words in the text. 
    \nPositive sentiments: ${positive.join(", ")}
    \n
    \nThere are ${negative.length} negative words in the text.
    \nNegative sentiments: ${negative.join(", ")}
    \n
    \nThe sentiment of the text is ${positive.length > negative.length ? 'positive' : 'negative'}.`)
}
```


## Sentiment Analysis 2

Re-implement the sentiment analysis with regex-based positive and negative word lists. In the previous practice problem, we did not count words that were just different forms of the words in the positive and negatiev word lists.

We could add the variations of each word: fortune --> fortunes; respect --> respected; ... This work,s but we can use regex to make the relationship between variants more evident.

``` js
let positiveRegex = /\bfortunes?\b|\bdream(s|t|ed)?\b|love(s|d)?\b|respect(s|ed)?\b|\bpatien(ce|t)?\b|\bdevout(ly)?\b|\bnobler?\b|\bresolut(e|ion)?\b/gi;
let negativeRegex = /\bdie(s|d)?\b|\bheartached?\b|death|despise(s|d)?\b|\bscorn(s|ed)?\b|\bweary\b|\btroubles?\b|\boppress(es|ed|or('s)?)?\b/gi;

function sentiment(text) {
  let positives = text.match(positiveRegex).map(toLowerCaseWord);
  let negatives = text.match(negativeRegex).map(toLowerCaseWord);

  console.log('There are ' + String(positives.length) + ' positive words in the text.');
  console.log('Positive sentiments: ' + positives.join(', '));
  console.log('');
  console.log('There are ' + String(negatives.length) + ' negative words in the text.');
  console.log('Negative sentiments: ' + negatives.join(', '));
  console.log('');

  let textSentiment;
  if (positives.length > negatives.length) {
    textSentiment = 'Positive';
  } else if (positives.length < negatives.length) {
    textSentiment = 'Negative';
  } else {
    textSentiment = 'Neutral';
  }

  console.log('The sentiment of the text is ' + textSentiment + '.');
}

function toLowerCaseWord(word) {
  return word.toLowerCase();
}
```


## Mail Count

The objective of this practice problem is to build a function that parses a string of email data. The function takes an argument that contains the data, parses it, then produces two basic statistics about the email:

- The number of email messages found in the string
- The date range of the email messages

The email messages string has the following characteristics:

- The string contains multiple email messages separated by the delimiter string ##||##.

- Each email message has five parts. The delimiter string #/# separates the parts.

- The five parts are:
  - Sender
  - Subject
  - Date
  - Recipient
  - Body

``` js
// Number emails in string
// Date range of emails

// input: string of email data
// output: print to console

function mailCount(emailData) {
  const DATE_POSITION = 2;
  let emails = formatEmailData(emailData);
  let numberEmails = emails.length;

  // initialized with largest possible "dates" in milliseconds
  let minDate = Date.now();
  let maxDate = 0; 

  emails.forEach(email => {
    let date = parseDate(email[DATE_POSITION]);
    if (date.getTime() < minDate) {
      minDate = date;
    } else if (date.getTime() > maxDate) {
      maxDate = date;
    }
  }) 

  minDate = minDate.toDateString();
  maxDate = maxDate.toDateString();

  outputMailCount(numberEmails, minDate, maxDate);
}

function formatEmailData(emailData) {
  let emails = emailData.split("##||##");
  emails = emails.map(email => email.split("#/#"));
  return emails;
}

function parseDate(dateString) {
  let date = dateString.match(/[0-9]{2}\-[0-9]{2}\-[0-9]{4}/);
  let month, day, year;
  [month, day, year] = date[0].split("-");
  return new Date(year, month - 1, day)
}

function outputMailCount(numberEmails, minDate, maxDate) {
  console.log(`Count of email: ${numberEmails}`);
  console.log(`Date Range: ${minDate} - ${maxDate}`);
}
```


## Longest Sentence (Code Review)

Write a program that determines the sentence with the most words in some text. 

Sentences may end with:
- periods (`.`), 
- exclamation points (`!`)
- question marks (`?`). 

Sentences always begin with a word character. 

You should treat any sequence of characters that are not spaces or sentence-ending characters, as a word. 

Log the longest sentence and its word count to the console. 

``` js
function longestSentence(text) {
  let longestSentence = {
    wordCount: 0,
    sentence: "",
  };
  // Separate text into sentences
  let sentences = text.match(/\w[^.?!]*?[.!?]/g);

  // Find the longest sentence
  for (let index = 0; index < sentences.length; index++) {
    let currentSentence = sentences[index];

    words = currentSentence.split(" ");

    if (words.length > longestSentence.wordCount) {
      longestSentence.wordCount = words.length;
      longestSentence.sentence = currentSentence;
    }
  }

  // Display longest sentence stats
  console.log(longestSentence.sentence);
  console.log("");
  console.log(`The longest sentence has ${longestSentence.wordCount} words.`);
}
```


## More Exercises

TODO: https://launchschool.com/exercise_sets/2edda272

