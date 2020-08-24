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

## 3. Now I Know My ABCs

## 4. Caesar Cipher

## 5. Vigenere Cipher

## 6. Seeing Stars

