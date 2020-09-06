## 1. 1000 Lights

You have a bank of switches before you, numbered from `1` to `n`. Every switch is connected to exactly one light that is initially off. You walk down the row of switches and toggle every one of them. You walk back to the beginning of the row and start another pass. On this second pass, you toggle switches `2`, `4`, `6`, and so on. On the third pass, you go back to the beginning again, this time toggling switches `3`, `6`, `9`, and so on. You continue to repeat this process until you have gone through `n` repetitions.

Write a program that takes one argument — the total number of switches — and returns an array of the lights that are on after `n` repetitions.

*Melinda work*

Input: a number `n` 
Output: an array of numbers where each number is the light number that is on

Rules: 
- n switches numbered 1-n
- pass each light n times (traverse the row n times)
- on the x traverse, you toggle the switch if the light number is a multiple of x

Algorithm:

Iteration 1:
- create our lights
- iterate n times through each of the lights
  - if the light number is a multiple of the current iteration number, then toggle the switch
- check our lights to see which lights are on
  - store the number of the ones that are on in the recording array
- return the recording array

Iteration 2:
- create our lights
  - initialize an empty object
  - for n times: add key-value of iterationNum-false to the object
    - NOTE: we need to start iterating from 1 and go through n
    - key: number of the light
    - value: true = on, false = off

- record keys of our lights object to collect all light numbers
- initialize recording array

- iterate n times through each of the lights
  - iterate through the keys/light numbers
    - if the light number is a multiple of the current iteration number
      - then toggle the switch --> change the value of the light number/key: boolean switch

- check our lights to see which lights are on
  - iterate through  the keys/light numbers
  - store the number of the ones that are on in the recording array
    - if value of key/light number is true, then push to a recording array

- return the recording array

``` js
function lightsOn(n) {
  const createLights = () => {
    const lights = {};

    for (let index = 1; index <= n; index += 1) {
      lights[index] = false;
    }

    return lights;
  };

  const lights = createLights();
  const lightsNumbers = Object.keys(lights);
  const lastLightsOn = [];

  for (let index = 1; index <= n; index += 1) {
    lightsNumbers.forEach((number) => {
      if (number % index === 0) {
        lights[number] = !(lights[number]);
      }
    });
  }

  lightsNumbers.forEach((number) => {
    if (lights[number]) { lastLightsOn.push(number); }
  });

  return lastLightsOn;
}
```

## 2. Diamonds

Write a function that displays a four-pointed diamond in an `n` x `n` grid, where `n` is an odd integer supplied as an argument to the function. You may assume that the argument will always be an odd integer.

Examples:
``` js
diamond(1);
// logs
*

diamond(3);
// logs
 *
***
 *
```

*Melinda work*

Input: an odd integer `n`
Output: log a diamond shape!

Rules:
- The widest-most part of the diamond contains `n` `*`s
- The diamond is built with `n` rows
- Each row has difference of two `*`s with consecutive rows (both up and down)
- Each row has odd number `*`s from `1` through `n`



## 3. Now I Know My ABCs

Done in lesson...? Probably 3: General Problem Solving Approach


## 4. Caesar Cipher

Write a function that implements the *Caesar Cipher*. The Caesar Cipher encrypts the `plaintext` message by substituting each letter by a letter located a given number of positions away in the alphabet. 

For example, if the letter 'A' is right-shifted by 3 positions, it will be substituted with the letter 'D'. This shift value is often referred to as the key. The "encrypted plaintext" (ciphertext) can be decoded using this key value.

The Caesar Cipher only encryptes letters (both upper and lower case). Any other character is left as is. The substituted letters are in the same letter case as the original letter. If the `key` value for shifting exceeds the length of the alphabet, it wraps around from the beginning.

Examples:
``` js
// simple shift
caesarEncrypt('A', 0);       // "A"
caesarEncrypt('A', 3);       // "D"

// wrap around
caesarEncrypt('y', 5);       // "d"
caesarEncrypt('a', 47);      // "v"

// all letters
caesarEncrypt('ABCDEFGHIJKLMNOPQRSTUVWXYZ', 25);
// "ZABCDEFGHIJKLMNOPQRSTUVWXY"
caesarEncrypt('The quick brown fox jumps over the lazy dog!', 5);
// "Ymj vznhp gwtbs ktc ozrux tajw ymj qfed itl!"

// many non-letters
caesarEncrypt('There are, as you can see, many punctuations. Right?; Wrong?', 2);
// "Vjgtg ctg, cu aqw ecp ugg, ocpa rwpevwcvkqpu. Tkijv?; Ytqpi?"
```

*Melinda work*

Input: a string and a key value for shifting
Output: an encrypted string

Rules:
- cipher is case-sensitive
- cipher does not affect non-letter characters
- if the key for shifting is longer than the alphabet, we wrap around and continue counting from the beginning

Data structure: none - use character codes for conversion

Char code values:
- A: 65
- Z: 90
- a: 97
- z: 122

How to convert character:
- Find char code of current letter
- Add increment steps to current letter
- If resulting char code is out of range
  - Convert into range with: (A/a char code - 1) + (charcode % Z/z char code)

Algorithm:
- initialize new string - we build the encrypted text here

- iterate through the string character by character
  - if it's an upper case character
    - convert with upper case limits
  - if it's a lower case character
    - convert with lower case limits
  - push new/punctuation character to new string

- return new string with encrypted text

``` js
function caesarEncrypt(message, step) {
  const encrypt = (currentCharCode, charCodeLimits) => {
    const [A_CODE, Z_CODE] = charCodeLimits;

    let newCharCode = currentCharCode + step;
    if (newCharCode > Z_CODE) {
      newCharCode = (A_CODE - 1) + (newCharCode % Z_CODE);
    }

    return String.fromCharCode(newCharCode);
  };

  const UPPER_CHAR_CODE_LIMITS = [65, 90];
  const LOWER_CHAR_CODE_LIMITS = [97, 122];
  let encrypted = '';

  for (let index = 0; index < message.length; index += 1) {
    let currentChar = message[index];
    const currentCharCode = message.charCodeAt(index);

    if (/[a-z]/.test(currentChar)) {
      currentChar = encrypt(currentCharCode, LOWER_CHAR_CODE_LIMITS);
    }
    if (/[A-Z]/.test(currentChar)) {
      currentChar = encrypt(currentCharCode, UPPER_CHAR_CODE_LIMITS);
    }
    encrypted += currentChar;
  }

  return encrypted;
}
```


## 5. Vigenere Cipher

The *Vigenere Cipher* encrypts alphabetic text using polyalphabetic substitution. It uses a series of *Caesar Ciphers* based on the letters of a `keyword`. Each letter of the `keyword` is treated as a shift value. For instance, the letter `'B'` corresponds to a shift value of `1`, and the letter `'d'` corresponds to a shift value of `3`. In othe words, the shift value used for a letter is equal to its index value in the alphabet. This means that the letters `'a'-'z'` are equivaluent to the numbers `0-25`. The upper case letters `'A'-'Z'` are also equivalent to `0-25`.

Applying the Vigenere Cipher is done sequentially for each character by applying the current shift value to a Caesar Cipher for the particular character To make this more concrete, let's look at the following example:
```
plaintext: Pineapples don't go on pizzas!
keyword: meat

Applying the Vigenere Cipher for each alphabetic character:
plaintext : Pine appl esdo ntgo onpi zzas
shift     : meat meat meat meat meat meat
ciphertext: Bmnx mtpe qwdh zxgh arpb ldal

result: Bmnxmtpeqw dhz'x gh ar pbldal!
```
Notice that in the example, the key isn't moved forward if the character isn't in the alphabet. Like the Caesar Cipher, the Vigenere Cipher only encrypts alphabetic characters.

Write a function that implements the Vigenere Cipher. The case of the `keyword` doesn't matter.

*Melinda work*

Input: a message to encrypt, and a keyword for steps
Output: encrypted message

Rules:
- encryption keyword
  - case-insensitive mapping of a-z to 0-25
  - applied character by character to consecutive letters within the message
  - value of keyword letter determines step shift for encryption
- only letters are encrypted (case-sensitively)

``` js
function vigenereEncrypt(message, keyword) {
  const letterToStep = (letter) => {
    const alphabet = 'abcdefghijklmnopqrstuvwxyz';
    return alphabet.indexOf(letter);
  };

  const encrypt = (currentCharCode, step, charCodeLimits) => {
    const [A_CODE, Z_CODE] = charCodeLimits;

    let newCharCode = currentCharCode + step;
    if (newCharCode > Z_CODE) {
      newCharCode = (A_CODE - 1) + (newCharCode % Z_CODE);
    }

    return String.fromCharCode(newCharCode);
  };

  const UPPER_CHAR_CODE_LIMITS = [65, 90];
  const LOWER_CHAR_CODE_LIMITS = [97, 122];
  const STEPS = keyword.split('').map(letterToStep);

  let encrypted = '';
  let stepTracker = 0;

  for (let index = 0; index < message.length; index += 1) {
    let currentChar = message[index];
    const currentCharCode = message.charCodeAt(index);

    if (/[a-z]/.test(currentChar)) {
      currentChar = encrypt(currentCharCode, STEPS[stepTracker], LOWER_CHAR_CODE_LIMITS);
      stepTracker = (stepTracker + 1) % STEPS.length;
    }
    if (/[A-Z]/.test(currentChar)) {
      currentChar = encrypt(currentCharCode, STEPS[stepTracker], UPPER_CHAR_CODE_LIMITS);
      stepTracker = (stepTracker + 1) % STEPS.length;
    }
    encrypted += currentChar;
  }

  return encrypted;
}
```


## 6. Seeing Stars

