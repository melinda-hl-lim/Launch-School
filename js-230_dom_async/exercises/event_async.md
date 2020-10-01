## 1. Randomizer

Write a `randomizer` function that accepts `n` callbacks and calls each callback at some random point in time btween now and `2 * n` seconds from now. For instance, if the caller provides 5 callbacks, the function should run them all sometime within 10 seconds.

While running, `randomizer` should log the elapsed time every second: `1`, `2`, ... `2 * n`.

``` js
function randomizer(...args) {
    const maxSeconds = args.length * 2;
    let seconds = 0;

    const ticker = setInterval(() => {
      if (seconds === maxSeconds) {
        clearInterval(ticker);
      }
      seconds += 1;
      console.log(seconds);
    }, 1000);

    args.forEach((callback) => {
      setTimeout(callback, (Math.random() * maxSeconds));
    });
  }
```


## 2. Reverse Engineer

Without changing the behaviour of the following code, remove the call to `event.stopPropagation` and refactor the result.

Given:
``` js
document.querySelector('html').addEventListener('click', () => {
  document.querySelector('#container').style = 'display: none';
});

document.querySelector('#container').addEventListener('click', event => {
  event.stopPropagation();
});
```

Refactored:
``` js
document.querySelector('html').addEventListener('click', (event) => {
    const container = document.querySelector('#container');

    if (!container.contains(event.target)) {
      container.style = 'display: none';
    }
  });
```


## 3. Bold Element + Custom

Implement a function that makes an element bold and allows the user of the function to optionally do something else with it.

``` js
function makeBold(element, callback) {
    element.style.fontWeight = 'bold';

    if (callback && typeof callback === 'function') {
      callback(element);
    }
  }
```


## 4. Buggy Code

Why is the given code buggy? We expect nothing to happen when the user clicks on the image. 

Answer: The given code uses `event.stopPropagation`, which prevents subsequent event listeners from firing. However, we want the click to result in no behaviour. To do so, we should use `event.preventDefault`, which will prevent the browser from redirecting when we click the link.


## 5. Content Menus

Given the following markup, implement distinct context menus for the `main` and `sub` areas of the web page. 

We can represent a context menu as an alert box that displays the name of the respective area (i.e. `alert("sub")`). Only one context menu should appear when the event occurs. 

Side notes (MDN):
- The `contextmenu` event fires when the user attempts to open a context menu. 
- This event is typically triggered by clicking the *right mouse button* or by pressing the *context menu key*

``` js
mainArea.addEventListener('contextmenu', (event) => {
    event.preventDefault();
    
    if (subArea.contains(event.target)) {
      event.stopPropagation();
      alert('sub');
    } else {
      alert('main');
    }
  });
```


## 6. Selection Filters

Given the HTML below, write some JS code that updates the options on one dropdown when the selection in the other dropdown changes. 

For instance, when the user chooses an option under Classifications, the items in the Animals dropdown should change accordingly. 

Use the lookup tables below to see which animals and classifications go together.

WIP
``` js
document.addEventListener('DOMContentLoaded', () => {
  const linkedOptions = {
    classifications: {
      Vertebrate: ['Bear', 'Turtle', 'Whale', 'Salmon', 'Ostrich'],
      'Warm-blooded': ['Bear', 'Whale', 'Ostrich'],
      'Cold-blooded': ['Salmon', 'Turtle'],
      Mammal: ['Bear', 'Whale'],
      Bird: ['Ostrich'],
    },
    animals: {
      Bear: ['Vertebrate', 'Warm-blooded', 'Mammal'],
      Turtle: ['Vertebrate', 'Cold-blooded'],
      Whale: ['Vertebrate', 'Warm-blooded', 'Mammal'],
      Salmon: ['Vertebrate', 'Cold-blooded'],
      Ostrich: ['Vertebrate', 'Warm-blooded', 'Bird'],
    },
  };
});
```


## 7. Article Highlighter

Given HTML and CSS, implement JS code that does the following:
- When the user clicks on a navigation link: 
  - the browser scrolls to that article in the `<main>` element
  - adds the `highlight` class to that article
  - remove the `highlight` class from other elements that have the `highlight` class
- When the user clicks on an `article` element or any of its child elements
  - the browser adds the `highlight` class to it
  - remove `highlight` class from any other element that has it
- When the user clicks anywhere else on the page, 
  - browser adds the `highlight` class to the `main` element
  - removes `highlight` class from any other elements that have `highlight`

``` js
function removeHighlight() {
    const highlighted = document.querySelectorAll('.highlight');
    highlighted.forEach((node) => node.classList.remove('highlight'));
  }

  const main = document.querySelector('main');
  const nav = document.querySelector('ul');

  main.addEventListener('click', (event) => {
    const article = event.target.closest('article');
    removeHighlight();

    if (article) {
      article.classList.add('highlight');
    } else {
      main.classList.add('highlight');
    }
  });

  nav.addEventListener('click', (event) => {
    if (event.target.tagName === 'A') {
      removeHighlight();

      const article = document.querySelector(event.target.getAttribute('href'));
      article.classList.add('highlight');
    }
  });
```


## 8. Delegate Event Function

Implement a function named `delegateEvent` that delegates events to the descendant (inner) elements of a parent element that match a given selector.

The function takes four arguments: `parentElement`, `selector`, `eventType`, and `callback`. 

It returns `true` if it was able to add an event listener and `undefined` if it wasn't. 

Assume all event handlers listen during the bubbling phase. 

``` js
function delegateEvent(parentElement, selector, eventType, callback) {
    if (!parentElement && parentElement instanceof Element) {
      return undefined;
    }

    const children = [].slice.call(parentElement.querySelectorAll(selector));

    parentElement.addEventListener(eventType, (event) => {
      if (children.includes(event.target)) {
        callback(event);
      }
    });

    return true;
  }
```


## 9. Events Tracker

Implement a function that tracks events on a web page. 

Your function should take a callback function as an argument and return a new function that:
- records the event
  - add each event to a `tracker` object
- executes the original callback function

Use the given markup and sample scenario to ascertain the expected behaviour of the `tracker` object.

Assume that the user clicks the elements in the following order: `div#blue`, `div#red`, `div#orange`, `div#green`

*Melinda did not understand what the problem wanted.*

Launch School Solution:
``` js
const divRed = document.querySelector('#red');
  const divBlue = document.querySelector('#blue');
  const divOrange = document.querySelector('#orange');
  const divGreen = document.querySelector('#green');

  const tracker = (() => {
    const events = [];
    return {
      list() {
        return events.slice();
      },
      elements() {
        return this.list().map(({ target }) => target);
      },
      add(event) {
        events.push(event);
      },
      clear() {
        events.length = 0;
        return events.length;
      },
    };
  })();

  function track(callback) {
    function isEventTracked(events, event) {
      return events.includes(event);
    }

    return (event) => {
      if (!isEventTracked(tracker.list(), event)) {
        tracker.add(event);
      }

      callback(event);
    };
  }

  divRed.addEventListener('click', track((event) => {
    document.body.style.background = 'red';
  }));

  divBlue.addEventListener('click', track((event) => {
    event.stopPropagation();
    document.body.style.background = 'blue';
  }));

  divOrange.addEventListener('click', track((event) => {
    document.body.style.background = 'orange';
  }));

  divGreen.addEventListener('click', track((event) => {
    document.body.style.background = 'green';
  }));
```