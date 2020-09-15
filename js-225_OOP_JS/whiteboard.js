// It has a default seed value of 0.

// Calling the function with no arguments returns the current value of the seed and increments the seed value by 1.

// Calling the function with an integer sets the current value of the seed to the integer passed. It returns the current value of the seed and increments the seed value by 1.

function makeSerialCounter() {
  let count = -1;

  return function (seed) {
    if (seed !== undefined) {
      count = seed;
      return count;
    }
    count += 1;
    return count;
  };
}
