// Write a function, which takes a non-negative integer (seconds) as input and returns the time in a human-readable format (HH:MM:SS)
//   HH = hours, padded to 2 digits, range: 00 - 99
//   MM = minutes, padded to 2 digits, range: 00 - 59
//   SS = seconds, padded to 2 digits, range: 00 - 59
// The maximum time never exceeds 359999 (99:59:59)
// You can find some examples in the test fixtures.

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

// Assume "#" is like a backspace in string. This means that string "a#bc#d" actually is "bd"
// Your task is to process a string with "#" symbols.

// input: a string with pounds and other characters
// output: a string with no pounds

// rule: "#" is a backspace, meaning the character to the left of "#" is removed (and that "#" is also removed)

// algorithm
// initialize new string variable - build new string here!
// iterate through the string character by character
// if #
// remove the last character from our new string
// str = str.slice(0, str.length-1)
// if not #
// add current character to new string
// str.concat("y")
// return the new string

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

console.log(cleanString('abc#d##c')); // ==> "ac"
console.log(cleanString('abc##d######')); // ==> ""
console.log(cleanString('#######')); // ==> ""
console.log(cleanString('')); // ==> ""
console.log(cleanString('##f##dc')); // ==> "dc"
