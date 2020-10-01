## Assignment: Arithmetic Calculator

``` html
<body>
  <main>
    <h1 id="result">0</h1>

    <form action="" method="post">
      <fieldset>
        <input type="number" name="first-number" id="first-number" value="0" />
        <select name="operator" id="operator">
          <option>+</option>
          <option>-</option>
          <option>*</option>
          <option>/</option>
        </select>
        <input type="number" name="second-number" id="second-number" value="0" />
        <input type="submit" value="=" />
      </fieldset>
    </form>
  </main>
</body>
```
``` js
document.addEventListener('DOMContentLoaded', () => {
  const form = document.querySelector('form');

  function calculate(value1, value2, operator) {
    const number1 = parseInt(value1);
    const number2 = parseInt(value2);
    let result;

    switch (operator) {
      case '+':
        result = number1 + number2;
        break;
      case '-':
        result = number1 - number2;
        break;
      case '*':
        result = number1 * number2;
        break;
      default:
        result = number1 / number2;
        break;
    }

    return result;
  }

  function getValueOf(selector) {
    return document.querySelector(selector).value;
  }

  form.addEventListener('submit', (event) => {
    event.preventDefault();

    const value1 = getValueOf('#first-number');
    const value2 = getValueOf('#second-number');
    const operator = getValueOf('#operator');

    const result = calculate(value1, value2, operator);
    document.querySelector('#result').textContent = String(result);
  });
});
```

Launch School differences:
- They use a *dispatch table* rather than a switch/case statement:
``` js
const Calculate = {
  "+": (firstNumber, secondNumber) => firstNumber + secondNumber,
  "-": (firstNumber, secondNumber) => firstNumber - secondNumber,
  "*": (firstNumber, secondNumber) => firstNumber * secondNumber,
  "/": (firstNumber, secondNumber) => firstNumber / secondNumber,
};
```
- Rather than using `parseInt` to convert the string into an integer, they used the `+` unary operator:
``` js
let firstNumber = +getValueOf('#first-number');
```


## Grocery List

``` html
<body>
  <main>
    <form action="" method="post">
      <h2>Add an item</h2>
      <fieldset>
        <label for="name">Item name</label>
        <input type="text" name="name" id="name" />
        <label for="quantity">Quantity</label>
        <input type="text" name="quantity" id="quantity" />
        <input type="submit" value="Add" />
      </fieldset>
    </form>
    <h1>Groceries</h1>
    <ul id="grocery-list"></ul>
  </main>
</body>
```
``` js
document.addEventListener('DOMContentLoaded', () => {
  function addToList(item, quantity) {
    const list = document.querySelector('#grocery-list');

    const listItem = document.createElement('LI');
    listItem.textContent = `${quantity} ${item}`;
    list.appendChild(listItem);
  }

  const form = document.querySelector('form');

  form.addEventListener('submit', (event) => {
    event.preventDefault();

    const item = document.querySelector('#name').value;
    const quantity = document.querySelector('#quantity').value || '1';

    if (item) {
      addToList(item, quantity);
      form.reset();
    } else {
      alert('Please enter an item name.');
    }
  });
});
```


## Team Member Profile Modals

We're going to revisit our Space Design website from an earlier course, and add more information about our team members. Our designer has come up with a common means of displaying more information as an overlay on the page content, called a modal. 

A modal acts like a separate sub-window of content that can be closed in order to return to the main content, all without leaving the page. These always use CSS positioning to place the modal and an optional overlay element over the top of the content. The overlay acts as a blocking element to prevent interacting with the page underneath the modal. It is good practice to have at least a close link and a close action bound to clicking on the overlay that will remove the modal and the overlay.
