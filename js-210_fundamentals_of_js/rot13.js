function rot13(sentence) {
  const ROTATION_SIZE = 13;
  const ALPHABET_SIZE = 26;
  const ALPHABET = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'];

  let rotSentence = '';

  for (let index = 0; index < sentence.length; index++) {
    const currentChar = sentence[index];
    let caseChange = false;

    // find the index of the current character in ALPHABET
    let alphabetIndex = ALPHABET.indexOf(currentChar);

    // convert upper case characters into lower case characters to find index in ALPHABET
    if (alphabetIndex === -1) {
      alphabetIndex = ALPHABET.indexOf(currentChar.toLowerCase());
      caseChange = true;
    }

    // case for non-alphabet character we append unrotated
    if (alphabetIndex === -1) {
      rotSentence += currentChar;
      continue;
    }

    // rot13 the alphabet character
    alphabetIndex = (alphabetIndex + ROTATION_SIZE) % ALPHABET_SIZE;

    // add the new character to rotSentence
    if (caseChange === true) {
      rotSentence += ALPHABET[alphabetIndex].toUpperCase();
    } else {
      rotSentence += ALPHABET[alphabetIndex];
    }
  }

  return rotSentence;
}
