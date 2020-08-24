function sumOfSums(numbers) {
  const sums = [];

  for (let index = 1; index <= numbers.length; index += 1) {
    const currentSequence = numbers.slice(0, index);
    const currentSum = currentSequence.reduce((accum, number) => accum + number);
    sums.push(currentSum);
  }

  return sums.reduce((accum, sum) => accum + sum);
}
