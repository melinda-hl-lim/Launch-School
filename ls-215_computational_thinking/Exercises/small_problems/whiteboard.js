function isDouble(number) {
  const strNumber = String(number);

  if (strNumber.length % 2 === 1) { return false; }

  const digits = strNumber.split('');
  const secondHalfStart = digits.length / 2;

  for (let index = 0; index < secondHalfStart; index += 1) {
    if (digits[index] !== digits[index + secondHalfStart]) {
      return false;
    }
  }

  return true;
}

function twice(number) {
  return isDouble(number) ? number : number * 2;
}

isDouble(3434);
