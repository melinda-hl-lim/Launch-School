## Asynchronous Execution with `setTimeout`

**Sequential code** is when each line of the program runs in sequence, one at a time.

**Asynchronous code** doesn't run continuosly or even when the runtime encounters it. It can partly run now, then pause and continue to run later. 

`setTimeout` is a function that takes two arguments: (1) a callback function and (2) a time to wait specified in milliseconds. It sets a timer that waits until the given time delay elapses, then invokes the callback function. 

Note: `setTimeout` isn't part of the JS lang - most browsers and NodeJS (not Node) provide it 

When working with asynchronous code, we need to reason about both *what* the code does and *when* it does it. 


## Repeating Execution with `setInterval`

`setInterval` invokes a callback function again and again at intervals until told to stop. 
- This isn't part of the JS language

`setInterval` returns an identifier that we can pass to `clearInterval` to cancel the timer and stop the repeated execution of the callback.


## User Interfaces and Events

An **event** is an object that represents some occurence; it contains information about what happened and where it happened. 

Events can be triggered by:
- the browser as the page loads
- the user as it interacts with the page
- the browser performing some action required by the program

User interfaces are inherently event-driven. Since web applications consist mainly of a user interface, the code within them has two main tasks:
1. Set up the user interface and display it
2. Handle events resulting from user or browser actions

The code that the browser runs in response to the event is an **event listener**.


## A Simple Example

Language side notes:
- We *register* an event listener for `click` events on `addButton`
- When the user clicks the button, the `click` event *fires* and the browser runs *the handler*
  - The handler is a synonym for the event listener. 


## Page Lifecycle Events

A rough mental model of how the browser loads a web page:
![complete_page_loading](https://d3905n0khyu9wc.cloudfront.net/images/complete_page_loading.png)

The `DOMContentLoaded`event is used when we have JS code that must access the DOM. 

The `load` event fires when everything on the page loads, including images, videos, etc. This event is less useful than `DOMContentLoaded`.


## User Events

Building interactive web apps means responding to user actions. We may need to detect and react to these user-initiated events and more:
- Keyboard: `keydown`, `keyup`, `keypress`
- Mouse: `mouseenter`, `mouseleave`, `mousedown`, `mouseup`, `click`
- Touch: `touchdown`, `touchup`, `touchmove`
- Window: `scroll`, `resize`
- Form: `submit`

We'll be looking at the different event types following this.

*Keep in mind*: an event's type determines the kind of code it makes sense to run within an event handler, but registering and triggering events is the same for all.


## Adding Event Listeners

The rest of this chapter focuses on JS code that uses **event listeners**, also known as **event handlers**. 

**Event listeners** are functions that the JS runtime calls when a particular event occurs.

There are four steps to setup an event handler:

1. Identify the event you need to handle.

> We want something to happen when the user clicks the "Alert" button, so we need to handle the `click` event

2. Identify the element that will receive the event

> We'll use the button since that's where the interaction will occur

3. Define a function to call when this event occurs

``` js
function displayAlert() {
  let message = document.getElementById('message').value;
  alert(message);
}
```

4. Register the function as an event listener

``` js
document.addEventListener('DOMContentLoaded', () => {
  let button = document.getElementById('alert');
  button.addEventListener('click', displayAlert);
});
``` 

The `GlobalEventHandlers` mixin provides a different way to register a function as an event listener.

Rather than adding a `click` handler with `button.addEventListener`, we can assign the listener on the `onclick` property of the `button` element. 

``` js
document.addEventListener('DOMContentLoaded', () => {
  let button = document.getElementById('alert');
  button.onclick = displayAlert;
});
```

However, `GlobalEventHandlers` mixins isn't exactly equivalent to using `EventTarget.addEventListener`


## The Event Object

The **`Event` object** provides extra contextual information (beyond "a click occured"), and is *passed as an argument to the event handler*.

Some useful properties of the `Event` object include:
- `type`: the name of the event (e.g. "click")
- `currentTarget`: the current object that the event object is on. It always refers to the element that has the event listener attached to it.
- `target`: The initial object to receive notification of the event (e.g. the element clicked by the user)

### Mouse Events

Most events have properties specific to their type.

Some unique to the mouse event include:
- `button`: which button was pressed?
- `clientX`: horizontal position of mouse when event occured
- `clientY`: vertical position of mouse when event occured

### Keyboard Events

- `key`: the string value of the pressed key
- `shiftKey`: boolean indicating if it's shift
- `altKey`: boolean indicating if it's alt
- `ctrlKey`: "                    " control
- `metaKey`: "                    " meta/command


## Capturing and Bubbling 

**Event delegation** is a technique that provides a solution to the following problems. 

Problems with adding event listeners to each element of interest:
- we can't add an event listener to an element until the DOM is ready, which means we have to wait for the `DOMContentLoaded` event to fire
- we have to add event handlers manually when we add new elements to the page
- adding handlers to many elements can be slow, and leads to complicated, difficult-to-maintain code

We will touch on *event delegation* in a later lesson. This lesson is about **capturing** and **bubbling**.

### Capturing and Bubbling

The number of elements we can interact with is equal to the element the event listener was added to plus the number of its **"nested"** inner elements. 

Recall:
- `target`: the element on which the event occured
- `currentTarget`: the element to which an event listener was added

The value of `this` within the handler (when using a function expression) is the `currentTarget`

**Capturing** and **bubbling** are phases that an `event` object goes through after the event initially fires.

The event first gets dispatched to the global `window` object, then to the `document` object, all the way down to the `target` element. 

At this point, the dispatch process reverses and from the `target` element the event works its way up until it reaches the `window` object.

As the `event` object moves through capturing and bubbling phases, it checks if there are any listeners for the event on the DOM objects that it passes.

If there is an event listener, the event listener fires on the target element, which is described as firing on the **target phase**. 

The event gets dispatched to each element twice, once during capturing and once during bubbling. However, the *event listener* only gets called/fired in one phase. By default, the listener is set to fire during the *bubbling phase*. To set it to listen on the capturing phase, we can use a third optional argument for `addEventListener`: set `useCapture` to `true`.

**Note**: The capturing and bubbling mechanism implies that events do not start or end on the `target` element.


## Preventing Propagation and Default Behaviours

We look at a couple of methods on the `event` object that can affect its behaviour as it moves through the capturing and bubbling phases: `event.stopPropagation` and `event.preventDefault`

### Stopping Propagation

`event.stopPropagation` stops the `event` object from continuing its path along the capturing and bubbling phases. 

The minute we invoke `event.stopPropagation`, the caputuring and bubbling phases stop. *Even if we don't reach the `target`*, it stops. Period.

See examples on this page for a refresher.

### Preventing Default Behaviours

`event.preventDefault` tells the browser that it shouldn't perform any actions that it might otherwise perform in response to a user's action (i.e. default behaviour rather than the event listener).

*Note*: it's good practice to call `preventDefault` and `stopPropagation` as soon as possible in an event handler. Doing so:
- emphasizes the presence of those methods to people reading the code
- ensures that these methods run before any errors occur


## Event Delegation

One benefit to the bubbling behaviour of DOM events is that you can structure the listener code in different ways. 

**Event delegation** takes advantage of event bubbling to address these problems:
- waiting for the DOM to finish loading before adding event handlers
- if we add an element after the page loads, we have to explicitly add an event handler
- too many listeners has a cost in performance and memory

With event delegation, we can add a single handler to any parents elements rather than each element we want to watch. 

*A con of event delegation*: the listener may become complicated if it must handle multiple situations. 

### When to Use Event Delegation

The best approach is to start by binding event handlers directly to elements when a project is new and small. As the code grows in size and complexity, delegation may make sense to reduce the number of event handlers required.

jQuery, which we'll look at in an upcoming chapter, includes functionality that makes delegation comparatively easy while avoiding the complexity drawback.


## What is the Event Loop

With asynchronous code provided by WebAPIs in JS, when we execute a function invocation such as:

``` js
setTimeout(function callback() {
  console.log('Hi!');
}, 5000);
```

- The function is sent to the *stack* for invocation
- Invoking `setTimeout` results in the *WebAPI* counting for 5000 milliseconds. This is not on the stack - in fact, the function invocation was completed so it's cleared off the stack.
- After counting, the WebAPI adds a task to the *task queue* - the callback function that should be invoked after 5000 milliseconds
- If the stack is empty, the *Event Loop* pops that callback task of the task queue and adds it to the stack
- The callback on the stack runs

*The Event loop's job is to*:
- check the stack and check the task queue
- if the stack is empty, 
  - pop first task off task queue 
  - and add to stack

*Side note*: If we want to defer a task until the stack is clear, then we can wrap the task with:
``` js
setTimeout(function task() {
  // some task to complete once the stack is clear
}, 0);
```


## Assignment: Guessing Game

Create a guessing game that asks the player to guess an integer between 1 and 100 chosen by the computer. 

- The program first picks a random value using a random number generator.
- The player then enters her guess and submits it, 
- Then the program checks whether the guess is higher, lower, or equal to the computer's chosen number, and reports the result.
- The player may continue to play until the number is guessed.

``` js
document.addEventListener('DOMContentLoaded', () => {
  let answer;
  const paragraph = document.querySelector('p');
  const input = document.querySelector('#guess');
  const form = document.querySelector('form');
  const newGame = document.querySelector('a');

  function initializeGame() {
    answer = Math.ceil(Math.random() * 100);
    paragraph.textContent = 'Guess a number from 1 to 100';
    form.reset();
  }

  initializeGame();

  function validGuess(guess) {
    return guess >= 1 && guess <= 100;
  }

  function createMessage(guess) {
    if (guess > answer) {
      return `My number is lower than ${String(guess)}`;
    } if (guess < answer) {
      return `My number is higher than ${String(guess)}`;
    }
    return 'You guessed my number!';
  }

  form.addEventListener('submit', (event) => {
    event.preventDefault();

    const guess = parseInt(input.value, 10);
    if (validGuess(guess)) {
      const message = createMessage(guess);
      paragraph.textContent = message;
    } else {
      paragraph.textContent = 'Please guess a number between 1 and 100';
    }
  });

  newGame.addEventListener('click', (event) => {
    event.preventDefault();
    initializeGame();
  });
});
```


## Assignment: Build an Input Box

In this assignment, we'll use HTML, CSS, and JavaScript to build an approximation of an input element. You'll never do this in a real project, but doing so here gives us an opportunity to create an interface that must handle more than one event type.

``` js
document.addEventListener('DOMContentLoaded', () => {
  const inputBox = document.querySelector('.text-field');
  const inputText = document.querySelector('.content');
  let cursorBlink;
  let focusedInputBox;

  inputBox.addEventListener('click', (event) => {
    event.stopPropagation();
    inputBox.classList.add('focused');
    focusedInputBox = true;

    cursorBlink = cursorBlink || setInterval(() => {
      inputBox.classList.toggle('cursor');
    }, 500);
  });

  document.addEventListener('click', (event) => {
    clearInterval(cursorBlink);
    cursorBlink = null;
    inputBox.classList.remove('cursor'); inputBox.classList.remove('focused');
    focusedInputBox = false;
  });

  document.addEventListener('keydown', (event) => {
    const METACHARS = ['Shift', 'Backspace', 'Meta', 'Alt', 'Control', 'CapsLock', 'Tab'];

    if (focusedInputBox) {
      if (!METACHARS.includes(event.key)) {
        inputText.textContent += event.key;
      } else if (event.key === 'Backspace') {
        inputText.textContent = inputText.textContent.slice(0, inputText.textContent.length - 1);
      }
    }
  });
});
```


## Promises

Information in a gist: https://launchschool.com/gists/58925b8e

The `Promise` object represents the *eventual resulting value* of the completion/failure of an asynchronous operation. They provide a way to register behaviour that needs to run after an event.

They're a little like event listeners except:

- A promise can only succeed or fail once. It cannot succeed or fail twice, neither can it switch from success to failure or vice versa.

- If a promise has succeeded or failed and you later add a success/failure callback, the correct callback will be called, even though the event took place earlier.

Terminology: A promise can be:
- fulfilled: The action relating to the promise succeeded
- rejected: The action relating to the promise failed
- pending: Hasn't fulfilled or rejected yet
- settled: Has fulfilled or rejected

``` js
// Create a promise
let promise = new Promise((resolve, reject) => {
  let sum = 1 + 1;
  if (sum === 2) {
    resolve('Successful summation!');
  } else {
    reject('Failure message goes here');
  }
});
```
The promise constructor takes one argument: a callback function. 

This callback function has two paraameters: `resolve` and `reject`.

We do something within the callback, then call `resolve` if everything worked; otherwise, call `reject`.



``` js
// Interact with promise: what should we do if it succeeds of fails?
promsise.then((message) => {
  console.log(`This is called if the promise is resolved: ${message}`)
}).catch((message) => {
  console.log(`This is called if the promise is rejected: ${message}`);
});
```

*Promises help us avoid callback hell.*

We like this video: https://www.youtube.com/watch?v=DHvZLI7Db8E&feature=youtu.be


### Async/Await

Async/await is syntactical sugar to make JS promises easier to work with.

We like this video: https://www.youtube.com/watch?v=V_Kr9OSfDeU&feature=youtu.be


## Summary

- `setTimeout(callback, delay)` invokes a function after the specified number of milliseconds

- `setInterval(callback, delay)` invokes a function repeatedly in intervals of some specified number of milliseconds. 
- `clearInterval` clears the interval and prevents future invocations of the Function.

- An **event** is an object that represents some occurence and contains a variety of information about what happened and where it happened. 
  - The browser triggers some events as it loads a page and when it accomplishes some actions directed by an application. 
  - The user triggers events when he/she interacts with the page

- Code that must access the DOM should be invoked after the `DOMContentLoaded` event fires on `document`

- User events drive most user interfaces and can result from a user interacting with the keyboard, mouse, touchscreen, window or other devices. Examples of these user events are `click`, `mouseover`, `keydown`, and `scroll`.

- **Event listeners** are callbacks that the browser will invoke when a matching event occurs

- `element.addEventListener` registers an event listener. You can also use specific `GlobalEventHandlers` like `element.onclick` to register an event handler. 

- The Event object provides the useful properties `type`, `target`, and `currentTarget`. 

- Keyboard events have properties (such as `key`) that describe the keys the user pressed.
- Mouse events similarly provide `button`, `clientX`, and `clientY`

- Events propagate in three phases: capturing, target, and bubbling

- `event.preventDefault` prevents default browser behaviour in response to an event. 
- `event.stopPropagation` stops the current capturing or bubbling phase, which prevents the event from firing on containing or contained elements. 

- **Event delegation** is a technique used to handle events triggered by multiple elemnts using a single event handler. 



Random:

- `node.contains(otherNode)` determines whether the `otherNode` is the `node` itself or if its a child of `node`