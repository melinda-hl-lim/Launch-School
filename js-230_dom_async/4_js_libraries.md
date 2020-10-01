## Introduction

Previous browser compatability issues led to the emergence of JS libraries like jQuery. These libraries abstracted away the complexities of working around browser inconsistencies and provide easy-to-use APIs for DOM manipulations, event handling, and Ajax.


## jQuery

jQuery is a JS library that provides a convenient API to manipulate elements, handle events, and make AJAX requests. This library works consistently across most browsers and platforms. 

### The jQuery Function

At its core, *jQuery is a function that wraps a collection of DOM elements and some convenience methods into an object*. 

Give the function an argument:
- if arg is a *string* or *DOM element*, it wraps a collection of jQuery objects and returns them
- if arg is a *function*, jQuery uses that function as a callback when the document is ready

Use name `jQuery` or alias `$` when calling jQuery. We pass a string that resembles a CSS selector:
``` js
var $content = jQuery('#content');
var $sameContent = $('#content');
```

**What we're learning: Using jQuery to access HTML element by passing in a CSS-like selector to the jQuery function.**

For `#id` selectors, the returned object represents *one element* (since ids should be unique on the page).

For other selectors, the returned object may reference *any number* of elements.

*Style note*: We prefix variables that reference jQuery objects with `$`

#### Collections

The **return value of jQuery is a collection**.
``` js
let $lis = $('li'); // select all list items on a page
console.log($lis.length); // 3
```

#### The `jquery` Property

Check the `jquery` property to see if a variable or property references a jQuery object:
``` js
console.log($content.jquery);
```
If the property exists and is a version number that matches the jQuery version, then it's a jQuery object!

### The DOM Ready Callback

The DOM ready callback (since most of jQuery acts on DOM elements):
``` js
$(document).ready(function() {
  // DOM loaded and ready, referenced image on img tags are not ready
});
```
The callback function we pass to `ready` executes after the document and its dependencies finish loading. 

If we need to work with images:
``` js
$(window).load(function() {
  // DOM loaded and ready, referenced image on img tags loaded and ready
});
```

A shorter way to write a DOM ready callback - skip traversing the document and binding to its `ready` event. Instead, pass a callback function directly to the jQuery function `$()`:
``` js
$(function() {
  // DOM is now loaded
});
```

### jQuery Object Methods

Change `font-size` (an attribute...?) for all elements represented by the object with the `css` method:
``` js
$content.css('font-size', '18px ');
```
#### Getters and Setters

The `css` method has both a *getter* and *setter* form:
``` js
console.log($content.css('font-size'));    // getter
$content.css('font-size', '18px');         // setter
```

Methods `width` and `height` also act as getters and setters:
``` js
let width = $content.width();  // 800 (getter)
$content.width(width / 2);     // Sets to 400
```

#### Chaining Method Calls

We can take advantage of the fact that *most jQuery methods return an object that contains jQuery methods* and chain method calls together:
``` js
$content.css('font-size', '18px').css('color', '#b00b00');
```

#### Object Argument

We can also pass in (at least to the `css` method) an object of key/value pair:
``` js
$content.css({ 
  "font-size": "18px", 
  "color": "#b00b00" 
});
```

#### Property Name Syntax

We can write property names as strings with the `-` separator (ex: `'font-size'`) or as camelCase (ex: `fontSize`).

### Convenience Methods 

Check what type a variable is: `$.isArray`; `$.isFunction`

Concatenate two arrays: `$.merge`
Make a new array: `$.map`

Make AJAX requests easily: `$.ajax`


## jQuery DOM Traversal

Previously we learnt: How to access an HTML element
Now we will learn: How to get to other elements from said accessed element

### Looking Outwards from an Object

Methods covered:
- `parent`
- `closest`
- `parents`

`parent`: used with and without a selector
``` js
let $p = $('p');
$p.parent();
```
Restrict parent elements selected with string selector argument:
``` js
$p.parent('.highlight');
```

`closest`: useful for finding the first ancestor element that meetes the criteria passed to the method
``` html
<ul id="navigation">
  <li>
    <a href="#">Categories</a>
    <ul>
      <li><a id="html" href="#">HTML</a></li>
      <li><a id="css" href="#">CSS</a></li>
      <li><a id="javascript" href="#">Javascript</a></li>
    </ul>
  </li>
</ul>
```
``` js
$('#javascript').closest('ul'); 
```

Note that `closest` first looks at the current element to see if it is a match. Therefore, if we write something like:
``` js
$('p').closest('p');
```
we may end up with the same elements that we already have in our collection.

`parents`: Find all parent elements of type `x` all the way up to root element
``` js
$('#javascript').parents('ul');
```

### Looking Inwards from an Object

Methods covered:
- `find`
- `children`

`find`: Call it on existing jQuery object to traverse to one of its child elements using another CSS-like selector. Will return any matching nodes lower.
``` js
$('ul#navigation').find('li').length; // with above HTML, length is 4
```

`children`: collect *immediate* children elements. May take CSS-like selector string.
``` js
$('#navigation').children().length; // with above HTML, length is 1
```

### Find Sibling Elements

Methods covered:
- `nextAll`
- `prevAll`
- `siblings`
- `next`
- `prev`

`nextAll` and `prevAll`: return all siblings after or before, with optional selector argument.
- `siblings`: return all siblings
``` js
// Find all list items after the CSS list item and hide them
var $css = $('#css').closest('li');
$css.nextAll().hide();

// Find all list items before the CSS list item and hide them
$css.prevAll().hide();

// Find all sibling lis and show them
$css.siblings().show();
```
- `next` and `prev`: return one sibling either immediately after or immediately before current


## jQuery Events

### A Simple Click Handler

Given HTML:
``` html
<ul>
  <li><a href="#">Apples</a></li>
  <li><a href="#">Bananas</a></li>
  <li><a href="#">Oranges</a></li>
</ul>

<p>Choose your favorite fruit!</p>
```

`on`: method to register a click handler
``` js
$(function () {
  $('a').on('click', function (event) {
    event.preventDefault();
  });
})
```
- First arg: is the event type
- Second arg: event handler

Within an event handler, we can get a **DOM element** with:
- `target`
- `currentTarget`
- `this`
To get the element that is clicked we can use `target` or `this`

Buidling on the JS code from before:
``` js
$(function () {
  $('a').on('click', function (event) {
    event.preventDefault();
    let $anchor = $(this);
    let $p = $('p');
    $p.text('Your favourite fruit is ' + $anchor.text());
  });
})
```

### Convenience Methods

jQuery has conveninence methods for many events. These methods have the same name as the event types and let us bind listeners to the events less verbosely. 

``` js
$(function() {
  var $p = $('p');
  var OUTPUT = 'Your favorite fruit is ';

  $('a').click(function(e) {
    e.preventDefault();
    var $event = $(this);
    $p.text(OUTPUT + $event.text());
  });

  $('form').submit(function(e) {
    e.preventDefault();
    var $input = $(this).find('input[type=text]');
    $p.text(OUTPUT + $input.val());
  });
});
```

### jQuery Event Delegation

If we had a list of items, each with a delete link, we'd want to attach the event listener to the parent `ul` element, not each `li` element:
``` js
// This callback is bound to a single element, yet it is able to process
// click events on any of the remove anchors within it.

$('ul').on('click', 'a', function(e) {
  e.preventDefault();
  $(e.target).closest('li').remove();
});
```


## HTML Templating with JS

Client-side templating libraries help use create HTML templates and populate them with data cleanly and efficiently. Libraries like Mustache, Underscore and Handlebars are useful for templating in JS. 

Handlesbars uses a fast and complex method of string replacement that will allow us to write the names of properties of objects within handlebars, and have them replaced with property values.

We get this HTML template:
``` html
<li>
  <h3>{{name}}</h3>
  <dl>
    <dt>Quantity:</dt>
    <dd>{{quantity}}</dd>
    <dt>Price:</dt>
    <dd>${{price}}</dd>
  </dl>
</li>
```
with property names surrounded by `{{ }}`.

Handlebar properties can be placed anywhere within the HTML string. 
``` js
// Quantity as the value of a *data attribute* on a list item
<li data-quantity="{{quantity}}">
```

Handlebars also has the ability to check properties for truthy values. A Handlebars conditional is `false` if the property value is `false`, `undefined`, `null`, `''`, `0`, or `[]`.

With any Handlebars-executed template code, we prefix it with a `#` sign.
``` html
...
    <dd>
      ${{price}}
      {{#if on_sale}}
      <strong>SALE!</strong>
      {{/if}}
    </dd>
...
```

**More on Handlebars that I didn't absorb**


## AJAX Requests

Alternatives to `XMLHttpRequest` for AJAX functionality:

- jQuery Ajax
- Fetch API (a web API): leverages Promise syntax to provide simpler interface

Pros and Cons - comparing different Ajax methods:

- `XMLHttpRequest` sufficient for simple Ajax requests. Using callbacks can lead to complex, difficult to parse code

- Fetch has a simpler interface. However, it's a newer API so older browsers may not support it.


## Summary

- Use documentation efficiently to ramp up quickly on a new library or API when you need to use it for a particular project.

- Use Developer Tools built in to the browser as part of your work-flow to test and debug your front-end code.

- At its core, jQuery is a function that wraps a collection of DOM elements and some convenience methods into an object.

- jQuery provides methods for many aspects of front-end development, such as interacting with the DOM, managing browser events, and making Ajax calls.

- Handlebars is a minimal templating library which allows you to easily add and update sections of a web page.

- The Fetch API and jQuery's ajax() are alternatives to XMLHttpRequest for making Ajax calls. At a high level they all do the same thing: make a HTTP request and then process the response once it is received.