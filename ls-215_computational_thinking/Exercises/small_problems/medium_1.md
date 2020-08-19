## 2. Rotation Part 2

Write a function that rotates the last `n` digits of a `number`. For the rotation, rotate by one digit to the left, moving the first digit to the end.

Inputs: 
  - number: a number with many digits
  - n: a number (assume it's less than length of number)
Output: 
  - rotated number

Rules: 
  - rotate the last `n` digits of the original number 
    - rotate means: slice of the first digit off the number we are rotating and append it to the back of the number
  - any digits not included in the last `n` digits are left unchanged

  ^ two parts to the number: first unchanged digits; last `n` digits we rotate

Algorithm:
  - convert the number into a form we can work with: 
    - input: a number
    - convert the number into a string 
    - then split that string into an array of digits 
  - counting from the end of the digits, we want to identify and rotate the nth digit
    - 
  - reverse the conversion: our array of digits returns to its number form
    - 


``` js
function rotateRightmostDigits(number, n) {

}
```