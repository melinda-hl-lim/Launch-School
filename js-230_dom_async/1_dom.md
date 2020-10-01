## Introduction

- HTML defines the content to display
- CSS describes how to present elements
- JavaScript adds behaviour to user interfaces 

- The DOM lets developers change a document


## The Document Object Model (DOM)

The **Document Object Model (DOM)** is an in-memory object representation of an HTML document. It provides: 
- a way to interact with a web page using JS
- the functionality needed to build modern interactive user experiences


## A Hierarchy of Nodes

The DOM is a hierarchical tree structure of nodes. 

There are different types of DOM nodes, including but not limited to:
- Elements representing HTML tags
- text nodes representing text 
  - *empty nodes* are text nodes containing nothing but white space. These nodes are *not* reflected visually in the web browser
- comments

The browser may insert nodes that don't appear in the HTML due to invalid markup or omission of optional tags -- so the DOM does *not* have a one-to-one mapping with the HTML file.

*DOM Levels*: W3 specifications that define the DOM features that browsers should support. 


## Node Properties

`querySelector`: a method to get a reference to a DOM node; requires a node to call the method.

``` js
let p = document.querySelector("p");
```

The `document` node is the top-most node that represents the whole HTML document. `document` is an `HTMLDocument` element, which inherits from `Node`. 

*Note*: `toString`is a handy method for determining an object's type.

**Node Properties**

All DOM Nodes have certain properties in common:
- `nodeName`: contains a String that represents the node type
- `nodeType`: determine a node's type - returns a number that matches a node type constant
- `nodeValue`: references the value of a node
  - Element nodes have `null` values
  - Text nodes have the textual content as its value
- `textContent`: represents the textual content of *all* nodes inside the *Element* node


## Determining the Type of a Node

### Nodes and Elements

- **All** DOM objects are Nodes
- **All** DOM objects have a type that inherits from Node, which means they all have properties and methods they inherit from Node
- The most common DOM object types we'll use are **Element** and **Text**

Node type matters since its type determines what properties and methods are available to developers. 

### Inheritance in the DOM

This LS page has a mini, partial list of common node types and their hierarchy.

What to remember about the different node types:
- `EventTarget` provides the event-handling behaviour that supports interactive web applications
- `Node` provides common behaviour to *all* nodes
- `Text` and `Element` are chief subtypes of `Node`
- Most HTML tags map to a specific element subtype that inherits from `HTMLElement`
- Other element types exist, such as `SVGElement` and its subtypes

### Determining the Node Type

Two useful ways to determine a node type:
- In a browser's developer tools: `toString` method or `String` constructor
- In a program/code: `instanceof` function or `tagname` property

**`toString` method and `String` constructor**

Most nodes return the node type's name with `toString` or the `String` constructor. Some nodes don't, however.
``` js
> p.toString();
= "[object HTMLParagraphElement]"

// HTMLAnchorElement
> let a = document.querySelector('a');
> a
= <a href="http://domain.com/page">Page</a>
> a.toString();
= "http://domain.com/page"
```

To work around this inconsistency, we could call the node's `constructor` property - it'll reference a function that creates Objects of the appropriate Element type. However, this value is browser-dependent.
``` js
// Chrome
> document.querySelector('a').constructor;
= function HTMLAnchorElement() { [native code] }

// Firefox
> document.querySelector('a').constructor;
= function()
> document.querySelector('a').constructor.name; /* Note use of .name property! */
= "HTMLAnchorElement"
```

**`instanceof` function or `tagname` property**

`instanceof` checks whether an object has a type that matches or inherits from a named type
``` js
> let p = document.querySelector('p');
> p instanceof HTMLParagraphElement;
= true
> p instanceof HTMLAnchorElement;
= false
> p instanceof Element;
= true
```

If we don't need to know the type name, we can use the `tagName` property to check the node's HTML tag name instead:
``` js
> p.tagName;
= "P"
```
With element nodes, `tagName` returns the same value as `nodeName`.


## Traversing Nodes

DOM nodes connect with other DOM nodes via a set of properties that point from one node to another with defined relationships. 

Properties of parent nodes:
- `firstChild`: `childNodes[0]` or `null`
- `lastChild`: `childNodes[childNodes.length - 1]` or `null`
- `childNodes`: a *live* collection of all child nodes

A *live collection* automatically updates to reflect changes in the DOM.

Properties of child nodes given node at index `n`: 
- `nextSibling`: `parentNode.childNodes[n + 1]` or `null`
- `previousSibling`:  `parentNode.childNodes[n - 1]` or `null` 
- `parentNode`: Immediate parent of this node

### Walking the Tree

Walking the tree is a term that describes the process of visiting every node and doing something with each node. We use a *recursive* function to do this. 

A recursive function:
- returns to the previous level of recursion when it's hit the base case
- performs a bit of processing
- calls itself with "smaller" arguments

Example of function that "walks the tree":
``` js
// walk() calls the function "callback" once for each node
function walk(node, callback) {
  callback(node);    // do something with node
  for (let index = 0; index < node.childNodes.length; index += 1) { // for each child node
    walk(node.childNodes[index], callback);    // recursively call walk()
  }
}

walk(document.body, node => {    // log nodeName of every node
  console.log(node.nodeName);
});
```


## Element Attributes

### Getting and Setting Attributes

We can access the attributes of an Element using:
- `getAttribute(name)`
- `setAttribute(name, newValue)`
- `hasAttribute(name)`

``` js
> let p = document.querySelector('p');
> p;
= <p class="intro" id="simple">...</p>

> p.hasAttribute('class');
= true
> p.getAttribute('class');
= "intro"
> p.getAttribute('id');
= "simple"
> p.setAttribute('id', 'complex');
> p
= <p class="intro" id="complex">...</p>
```

### Attribute Properties

`getAttribute` and `setAttribute` work for *all* attributes. However, there are some special attributes we can access a different way.

The DOM exposes some special attributes: `id`, `name`, `title`, `value`. However, not all Element types have these properties. 
- Note: the `class` attribute is simlar, but uses the `className` property since `class` is reserved in JS
``` js
> p.className;
= "intro"
> p.className = 'outro';
```

### classList

When the element has more than one `class`, working with `className` is inconvenient.

For example, if we want to replace a class:
``` js
> let newClass = button.className.replace('btn-primary', 'btn-disabled');
> button.className = newClass;
= "btn btn-lg btn-disabled"
> button;
= <button class="btn btn-lg btn-disabled">...</button>
```

`classList` property references a special array-like `DOMTokenList` object that has these properties and methods:
- `add(name)`
- `remove(name)`
- `toggle(name)`
- `contains(name)`
- `length`

### style

Element nodes also have a `style` attribute that references a `CSSStyleDeclaration` Object:
``` js
> let h1 = document.querySelector('h1');
> h1.style;
= CSSStyleDeclaration {alignContent: "", alignItems: "", alignSelf: "", alignmentBaseline: "", all: "", ...}
```
We can use the `style` attribute to alter any CSS property.
``` js
> h1.style.color = 'red'; // set the heading color
> h1.style.color = null; // remove the css property
```

If the CSS property name has dashes, we need to use the camelCase version to access that property: `line-height` becomes `lineHeight`


## Finding DOM Nodes 

### Finding An Element By ID

The build-in method `getElementById` on `document` lets us find an element by ID. 

Given HTML:
``` html
<!doctype html>
<html lang="en-US">
  <head>
    <title>On the River</title>
  </head>
  <body>
    <p id="content">The sun is low</p>
  </body>
</html>
```
we can get a reference to the DOM element for the paragraph tag with:
``` js
> document.getElementById('content');
= <p id="content">...</p>
```

We often want to find more than one element though - elements that match some criteria. It's easier to maintain your application if you structure the code to find all matching elements instead of just one. 

### Finding More Than One Element

We need to find a better way to get more than one element.

Right now we can either:
- walk the DOM tree (lots of overhead)
- since `id` values are unique, to get another paragraph we'd have to copy and paste our code from above with a new `id` value

After doing some exercises we get a JS function that returns all nodes of an *element type(?)*:
``` js
function getElementsByTagName(tagName) {
  let matches = [];

  walk(document.body, node => {
    if (node.nodeName.toLowerCase() === tagName) {
      matches.push(node);
    }
  });

  return matches;
}
```

### Built-In Functions

There are built-in methods similar to our function above. Both return an `HTMLCollection` or `NodeList`of matching elements in *array-like* objects (not arrays):
- `document.getElementsByTagName(tagName)` 
- `document.getElementsByClassName(className)`

*What is a `HTMLCollection` or `NodeList`?*

Both types are array-like objects: they're containers for other objects index with non-negative integers.

These are *not* JS arrays, so they don't support methods like `forEach`. To loop through these objects, we can either:
- use a `for` loop
- convert the object into an Array and then use an Array method

LS didn't explain the difference between the two objects yet. All we need to know is some browsers return one, while other browsers return the other.

*LS talks about live collections here again*

### Using CSS Selectors

The nested structure of the elements in the DOM make finding a given subset of elements difficult -- the problem becomes more complicated as the DOM becomes larger and more complex.

Another way to search (rather than using tag name, class name or relationship between nodes) is to use *CSS selectors*. 

Browsers provide built-in support for selector searches with these two methods:
- `document.querySelector(selectors)`
- `document.querySelectorAll(selectors)`

Both methods take multiple CSS selectors as an argument. The argument is a string of one or more comma-separated css selectors. Both return *array-like* objects. 
``` html
<div id="divOne"></div>
<div id="divTwo"></div>
```
Using an `id` value as the CSS selector:
``` js
> document.querySelector('#divTwo, #divOne');
= <div id="divOne"></div>    
// returns the first matching element;
                             
> document.querySelectorAll('#divTwo, #divOne');
= NodeList(2) [div#divOne, div#divTwo]
```
These methods are available on all elements, not just `document`.


## Traversing Elements

Another set of DOM properties allow us to traverse the DOM:
- Parent Element Properties
  - `children`
  - `firstElementChild`
  - `lastElementChild`
  - `childElementCount`
- Child Element Properties
  - `nextElementSibling`
  - `previousElementSibling`

However, with these DOM properties, *only Element nodes* are included. 

### textContent

To access `Text` nodes while traversing only `Element` nodes, we can use the `textContent` property to access text. 

Given:
``` html
<body>
  <p>
    You can <a href="?page=2">go back</a> or <a href="/page/3">continue</a>.
  </p>
</body>
```
We can access the text in the link with:
``` js
> document.querySelector('a').textContent;
= "go back"
```
To change the value of the text content:
``` js
> document.querySelector('a').textContent = 'step backward';
= "step backward"
```
Be careful when setting `textContent`: doing so *removes all child nodes from the element* and replaces them with a text node that contains the value.

The best way to update text with JS is to place the original text-to-update within an element -- anything, even a bare `span` or `div` element. This way, we can select the Element node.


## Creating and Moving DOM Nodes

Learn how to create, add and remove nodes.

- `createElement`
- `appendChild`

Given HTML:
``` html
<!doctype html>
<html lang="en-US">
  <head>
    <title>Empty Page</title>
  </head>
  <body>
  </body>
</html>
```
We can create a paragraph and append it to the given HTML:
``` js
let paragraph = document.createElement('p');
paragraph.textContent = 'This is a test.';
document.body.appendChild(paragraph);
```
We can also create a text node and append it to the paragraph element:
``` js
let text = document.createTextNode('This is a test.');
let paragraph = document.createElement('p');
paragraph.appendChild(text);
document.body.appendChild(paragraph);
```

### Creating New Nodes

We can create nodes in two ways:

1. Create a new empty node
- `document.createElement(tagName)`
- `document.createTextNode(text)`

2. Clone an existing node hierarchy
- `node.cloneNode(deepClone)`, where `deepClone` is either `true` or `false`

### Adding Nodes to the DOM

We can append, insert and replace nodes with methods on the node's parent:
- `parent.appendChild(node)`
- `parent.insertBefore(node, targetNode)`
- `parent.replaceChild(node, targetNode)`

*Note*: `document.appendChild` causes an error - use `document.body.appendChild` instead.

**No Node may appear twice in the DOM.** If we try to add a node that already exists in the DOM, it gets removed from the original location. So we can *move nodes by inserting it where we want it*. 

These methods insert a node before, after or within an Element:
- Element node: `element.insertAdjacentElement(position, newElement)`
- Text node: `element.insertAdjacentText(position, text)`

...where `position` is one of these String values: `beforebegin`, `afterbegin`, `beforeend`, `afterend`.

### Removing Nodes

When we remove a node from the DOM, it becomes eligible for garbage collection unless we keep a reference to the node in a variable. We can't access an object that's eligible for garbage collection.
- `node.remove()`
- `parent.removeChild(node)`


## The Browser Object Model (BOM)

We can access other components of the browser with JS that goes beyond the page contents (captured in the DOM). 

These other components comprise the **Browser Object Model (BOM)** and include:
- the windows used to display web pages
- the browser's history
- sensors, including location


## Summary

- The **Document Object Model (DOM)** is an in-memory object representation of an HTML document. 
- The DOM provides a way to interact with a web page using JS, which provides the functionality required to build modern interactive user experiences. 

- The DOM is a hierarchy of **nodes**. Each node can contain any number of child nodes. 

- There are different types of nodes. The types you should be familiar with are **elements** and **text nodes**. 

- The whitespace in an HTML document may result in empty text nodes in the DOM. 

- Useful properties of nodes include `nodeName`, `nodeType`, `nodeValue`, and `textContent`

- Nodes have properties that traverse the DOM tree: `firstChild`, `lastChild`, `childNodes`, `nextSibling`, `previousSibling`, and `parentNode`

- Element nodes have `getAttribute`, `setAttribute`, and `hasAttribute` methods to manipulate HTML attributes

- Elements have properties that let you read and alter the `id`, `name`, `title`, and `value`.

- Elements let you read and change CSS classes and style properties via the `classList` and `style` properties

- `document.getElementById(id)` finds a single Element with the specified `id`

- `document.getElementsByTagName(name)` and `document.getElementsByClassName(name)` find any Elements with the specified `tagName` or `class`

- `document.querySelector(selector)` returns the first Element that matches a CSS selector. `document.querySelectorAll(selector)` is similar but returns all matching elements

- Elements have properties to traverse the DOM tree: `firstElementChild`, `lastElementChild`, `children`, `nextElementSibling`, and `previousElementSibling`

- You can create new DOM nodes with `document.createElement(tagName)` or `document.createTextNode(text)`

- You can create a copy of a node with `node.cloneNode(deepClone)`

- `parent.appendChild(node)`, `parent.insertBefore(node, targetNode)`, `parent.replaceChild(node, targetNode)`, `element.insertAdjacentElement(position, newElement)`, and `element.insertAdjacentText(position, text)` add nodes to the DOM

- `node.remove()` and `parent.removeChild(node)` remove nodes from the DOM.