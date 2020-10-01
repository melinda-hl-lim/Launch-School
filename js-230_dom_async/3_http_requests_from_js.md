## Introduction

We'll look at `XMLHttpRequest`, one of the browser APIs that provide network programming functionality to JS applications. 

### What to Focus On

- Think HTTP: HTTP is the protocol used by the network operations we cover in this lesson.
  - Request-response cycle
  - Components of each part (of above cycle)
  - How to access above values from JS

- Be familiar with `XMLHttpRequest`. Know how to:
  - send requests 
  - execute code at specific points as the request moves through its lifecycle
  - handle successful and unsuccessful requests

- Understand how to serialize data. Use `XMLHttpRequest` to: 
  - submit a form from a webpage
  - send requests using JSON-formated data

- Decompose functionality into API requests
  - example: translate "create a post on the server" into "make a POST request to `/posts` with the required JSON data"

- Read API Documentation

## HTTP Review

HTTP book: https://launchschool.com/books/http

Request-response cycle video: https://launchschool.com/lessons/cc97deb5/assignments/83ae67aa


## Book: Working with Web APIs

Find notes here: none so far!


## Network Programming in JS

*Request-response cycle*: the underlying foundation of web applications. The cycle process usually looks like:
1. User clicks link in web page
2. Browser sends HTTP request to server
3. Server returns entire HTML page
4. Browser parses and displays new page

Noteworthy notes about cycle:
- When user clicks a link, browser automatically requests the page
- When browser receives a response, it renders it in the viewport

However, with more interactive sites and more complex interfaces, *reloading an entire HTML page becomes a limiting factor*. 


**(AJAX) Asynchronous JavaScript And XML** is a tenique that:
- allows us to fetch data (HTML or XML) and update only parts of the page
- JS code (not browser) initiates the HTTP request, typically from an event listener
- when the browser receives a response, JS code takes the response's body and updates the page as needed

**When requesting a resource using JS, we must write code that initiates the request and handles the response.**

### Single Page Applications

*Single page applications* often run entirely within a single HTML page. These apps fetch data in a serialized format and create the DOM entirely from JS running in a client's browser. This model of application does all interactions by passing data to and from the server, often encoded as JSON. 


## Making a Request with XMLHttpRequest

We use the `XMLHttpRequest` object to send a HTTP request with JS. This object is part of the browser API, not the JS language. 

Parameters required to send a request:
- a method
- a host
- a path

Send a `GET` request for `/path` from the local host. 
``` js
// Instantiate new XMLHttpRequest object
let request = new XMLHttpRequest(); 
// Set HTTP method and URL on request
request.open('GET', '/path'); 
// Send request      
request.send();                     
```

Before the request completes, those properties contain empty strings of `0`.
``` js
request.responseText;     // => ""
request.status;           // => 0
request.statusText;       // => ""
```

`request.send` is asynchronous - the `XMLHttpRequest` object uses event listeners to notify when the request completes:
``` js
request.addEventListener('load', (event) => {
  let request = event.target; // The XMLHttpRequest object

  request.responseText;    // body of response
  request.status;          // status code of response
  request.statusText;      // status text from response

  request.getResponseHeader('Content-Type');  // response header
})
```

### Overview of XMLHttpRequest Methods

**Methods:**

- `open(method, url)`: open a connection to `url` using `method`

- `send(data)`: send the requestion, optionally sending along `data`

- `setRequestHeader(header, value)`: set HTTP `header` to `value`

- `abort()`: cancel an active request

- `getResponseHeader(header)`: return the response's value for `header`

**Properties:**
- If a property is not explicitly listed as writable, then it is not writable

- `timeout`: maximum time a request can take to complete (in milliseconds)
  - default value: `0`
  - is a writable property

- `readyState`: what state the request is in

- `responseText`: raw text of the response body
  - default value: `null`

- `response`: parsed content of response -- not meaninful usually
  - default value: `null`

*Note the difference between `responseText` and `response`.* This is important for sending and receiving JSON data.

### Practice

Make a request to the Rails repo on Github. Then use the `load` event to access the HTTP response and its values. 
``` js
const url = 'https://api.github.com/repos/rails/rails';

const request = new XMLHttpRequest();
request.open('GET', url);
request.send();

request.addEventListener('load', (event) => {
  const request = event.target;

  console.log(request.status);

  console.log('\nrequest.responseText\n');
  console.log(request.responseText);

  console.log('\n\nrequest.response');
  console.log(request.response);
});
```


## XMLHttpRequest Events

Here, we look at all the events we can use in the lifecycle of an `XMLHttpRequest`.

To run some code when an event occurs on an `XMLHttpRequest` object, we can use the same `addEventListener` method that we used for handling user or page events:
``` js
let request = new XMLHttpRequest();

request.addEventListener('load', (event) => {
  let xhr = event.target; // the request
})
```

Two main events fire during an `XMLHttpRequest` cycle: 
- `loadstart`: request sent to server
- `loadend`: response loading done and all other events have fired. Last event to fire.

Before `loadend` triggers, another event will be fired based on whether the request succeeded:
- `load`: a complete response loaded
- `abort`: the request was interrupted before it could complete
- `error`: an error occured
- `timeout`: a response wasn't received before the timeout period ended

**Note**: the browser considers *any request that receives a complete response as successful*, even if the response has a non-200 status. Whether `load` or another event fires is determined by whether the HTTP request-response cycle loads a complete response. 

It's the responsibility of the application code to determine whether a `request` was successful from its perspective by inspecting the response within a `load` event handler. 

- `readystatechange` event: fires when the value of `readyState` changes
- `progress` event: fires when response data is received *in some situations*


## Data Serialization

**Data serialization** provides a common way for systems to pass data to each other, with a guarantee that each system will be able to understand the data.

Serialization lets both the client and server transfer data in a format that preserves information without interfering with the communication protocol. 

### Request Serialization Formats

**Query String/URL Encoding**

- Use JS function `encodeURIComponent` to encode names or values
- Then combine name-value pairs with `=`
- Then combine multiple pairs with `&` 
``` 
// without encodeURIComponent
title=Do Androids Dream of Electric Sheep?&year=1968

// with encodeURIComponent
title=Do%20Androids%20Dream%20of%20Electric%20Sheep%3F&year=1968
```

Once the URL is properly encoded, we can append it to a *GET request's path*
``` 
GET /path?title=Do%20Androids%20Dream%20of%20Electric%20Sheep%3F&year=1968 HTTP/1.1
Host: example.test
Accept: */*
```

In *POST requests*, we have to include a `Content-Type` header with a value of `application/x-www-form-urlencoded`. Place the encoded name-value string in the request body.
``` 
POST /path HTTP/1.1
Host: example.test
Content-Length: 54
Content-Type: application/x-www-form-urlencoded; charset=utf-8
Accept: */*

title=Do%20Androids%20Dream%20of%20Electric%20Sheep%3F&year=1968
```

### Multipart Forms

POST requests use *multipart form formats* for forms that include file uploads or that use `FormData` objects to collect data. This format isn't really an encoding format. 
``` 
POST /path HTTP/1.1
Host: example.test
Content-Length: 267
Content-Type: multipart/form-data; boundary=----WebKitFormBoundarywDbHM6i57QWyAWro
Accept: */*

------WebKitFormBoundarywDbHM6i57QWyAWro
Content-Disposition: form-data; name="title"

Do Androids Dream of Electric Sheep?
------WebKitFormBoundarywDbHM6i57QWyAWro
Content-Disposition: form-data; name="year"

1968
------WebKitFormBoundarywDbHM6i57QWyAWro--
```
Notice: 
- name-value pairs are placed in a separate section of the request body
- `Content-Type` header sets:
  - `multipart-form-data`
  - A **boundary delimiter** to separate each name-value pair
- The final boundary delimiter has an extra `--` at the end, marking the end of the multipart content

### JSON Serialization

JSON (JavaScript Object Notation) is a popular data serialization format. 

It can exchange arrays, objects, strings, numbers and booleans. 
- It doesn't support complex data types like dates and times

A `GET` request can return JSON.

We must use a `POST` request to send JSON data.
``` 
POST /path HTTP/1.1
Host: example.test
Content-Length: 62
Content-Type: application/json; charset=utf-8
Accept: */*

{"title":"Do Androids Dream of Electric Sheep?","year":"1968"}
```
Notice:
- `Content-Type` header has value of `application/json; charset=utf-8`
  - Required to use JSON as the request serialization format.
  - Helps server parse the request correctly

`charset` is optional, but it's best practice to include it (except when using multipart form format)
  - providing `charset` ensures the server interpretes the data with the correct encoding


## Example: Loading HTML via XHR

We'll use `XMLHttpRequest` object to *embed a web store in an existing web page*. 
``` html
<h1>Existing Page</h1>

<div id="store"></div>
```

We'll use the JS below to fetch the list of products from a web store and insert it in the `div` with an `id` of `store`:
``` js
document.addEventListener('DOMContentLoaded', () => {
  const request = new XMLHttpRequest();
  request.open('GET', 'https://ls-230-web-store-demo.herokuapp.com/products')

  request.addEventListener('load', (event) => {
    const store = document.getElementById('store');
    store.innerHTML = request.response;
  })

  request.send();
})
```

With the JS above though, all of the product links don't work. Clicking one causes the entire page to reload, and we get a 404 error since the links don't exist at CodePen.

So we need to *add event handlers that listen for clicks within the embedded content* (i.e. clicks on the product links). Building of the JS above:
``` js
document.addEventListener('DOMContentLoaded', () => {
  const store = document.getElementById('store');

  const request = new XMLHttpRequest();
  request.open('GET', 'https://ls-230-web-store-demo.herokuapp.com/products');

  request.addEventListener('load', (event) => store.innerHTML = request.response);
  request.send();

  store.addEventListener('click', (event) => {
    const target = event.target;
    if (target.tagName !== 'A') { return ; }

    event.preventDefault();

    const request = new XMLHttpRequest();
    request.open('GET', 'https://ls-230-web-store-demo.herokuapp.com' + target.getAttribute('href'));

    request.addEventListener('load', (event) => store.innerHTML = request.response);
    request.send();
  })
})
```

**Learning Points**:

1. We can use an `XMLHttpRequest` object to fetch content and insert it in an existing web page without a full page reload

2. We can attach event listeners to content embedded in the page to circumvent the browser's default behaviour and create custom interactions


## Example: Submitting a Form via XHR

There are three steps to submitting a form using JS:
1. Serialize the form data
2. Send the request using `XMLHttpRequest`
3. Handle the response

As steps 2 and 3 are similar to what was covered in the previous lesson, *we'll focus on step 1: serialize the form data*.

### URL-encoding POST Parameters

URL encoding works with `POST` requests, but we have to include:
- a `Content-Type` header with value `application/x-www-form-urlencoded`
- Place the encoded name-value string in the request body 
``` js
const request = new XMLHttpRequest();
request.open('POST', 'https://ls-230-book-catalog.herokuapp.com/books');

request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

let data = 'title=Effective%20JavaScript&author=David%20Herman';

request.addEventListener('load', () => {
  if (request.status === 201) {
    console.log(`This book was added to the catalog: ${request.responseText}`);
  }
});
```

### Submitting a Form

We're given a web page with the following form:
``` html
<form id="form">
  <p><label>Title: <input type="text" name="title"></label></p>
  <p><label>Author: <input type="text" name="author"></label></p>
  <p><button type="submit">Submit</button></p>
</form>
```

To access the values from this form, we can use the `HTMLFormElement.elements` property within an event listener that receives control when the user submits the form:
``` js
let form = document.getElementById('form');

form.addEventListener('submit', (event) => {
  // Prevent the browser from submitting the form
  event.preventDefault(); 

  // Access the inputs using form.elements and serialize into a string
  const keyAndValues = [];

  for (let index = 0; index < form.elements.length; index += 1) {
    let element = form.elements[i];
    let key;
    let value;

    if (element.type !== 'submit') {
      key = encodeURIComponent(element.name);
      value = encodeURIComponent(element.value);
      keysAndValues.push(`${key}=${value}`);
    }
  }

  const data = keysAndValues.join('&');

  // Submit the data
  const request = new XMLHttpRequest();
  request.open('POST', 'https://ls-230-book-catalog.herokuapp.com/books');
  request.setRequestHeader("Content-type", "application/x-www-form-urlencoded");)

  request.addEventListener('load', () => {
    if (request.statues === 201) {
      console.log(`This book was added to the catalog: ${request.responseText}`);
    }
  });

  request.send(data);
});
```

Both *URL-encoding POST parameters* and *Submitting a Form* result in the same following POST request:
``` 
POST /books HTTP/1.1
Host: ls-230-book-catalog.herokuapp.com
Content-Length: 13
Content-type: application/x-www-form-urlencoded
Accept: */*

title=Effective%20JavaScript&author=David%20Herman
```

### Submitting a Form with FormData

**FormData** is a built-in API provided by modern browsers. It provides an alternative to the manual, error-prone process from the *Submitting a Form* section above.

`FormData` only uses input fields that have a `name` attribute.

``` js
let form = document.getElementById('form');

form.addEventListener('submit', event => {
  // prevent the browser from submitting the form
  event.preventDefault();

  let data = new FormData(form);

  let request = new XMLHttpRequest();
  request.open('POST', 'https://ls-230-book-catalog.herokuapp.com/books');

  request.addEventListener('load', () => {
    if (request.status === 201) {
      console.log(`This book was added to the catalog: ${request.responseText}`);
    }
  });

  request.send(data);
});
```

`FormData` uses a different serialization format called *multipart*.

The HTTP request sent by the above code looks like this:
```
POST /books HTTP/1.1
Host: ls-230-book-catalog.herokuapp.com
Content-Length: 234
Content-Type: multipart/form-data; boundary=----WebKitFormBoundaryf0PCniJK0bw0lb4e
Accept: */*

------WebKitFormBoundaryf0PCniJK0bw0lb4e
Content-Disposition: form-data; name="title"

Effective JavaScript
------WebKitFormBoundaryf0PCniJK0bw0lb4e
Content-Disposition: form-data; name="author"

David Herman
------WebKitFormBoundaryf0PCniJK0bw0lb4e--
```


## Example: Loading JSON via XHR

So far we've looked at retrieving HTML fragments from a server and inserting them into a page. This works well for *server-side rendering* to generate the user interface.

We can also load data in a primitive data structure and render it with the *client-side* code. This often occurs when the user interface has widgets the server doesn't render.

We can use the following code to load some JSON data from Github:
``` js
let request = new XMLHttpRequest();
request.open('GET', 'http://ls-230-book-catalog.herokuapp.com/invalid_book');

request.addEventListener('load', event => {
  try {
    let data = JSON.parse(request.response);
    // do something with the data
  } catch(e) {
    console.log('Cannot parse the received response as JSON.')
  }
});

request.send();
```
Notice how we have to handle any errors that may occur from parsing the JSON response. 

We can set `responseType = 'json'` to simplify our code:
``` js
let request = new XMLHttpRequest();
request.open('GET', 'https://api.github.com/repos/rails/rails');
request.responseType = 'json';

request.addEventListener('load', event => {
  // request.response will be the result of parsing the JSON response body
  // or null if the body couldn't be parsed or another error occurred.

  let data = request.response;
});

request.send();
``` 


## Example: Sending JSON via XHR

Steps for sending JSON data to a server:
1. Serialize the data *into valid JSON*
2. Send the request using `XMLHttpRequest` *with a `Content-Type: application/json` header*
3. Handle the response

The steps are similar to submitting a form, with italicized differences.

Such a `POST` request can be made in JS like so:
``` js
let request = new XMLHttpRequest();
request.open('POST', 'https://ls-230-book-catalog.herokuapp.com/books');

request.setRequestHeader('Content-Type', 'application/json');

let data = { title: 'Eloquent JavaScript', author: 'Marijn Haverbeke' };
let json = JSON.stringify(data);

request.send(json);
```
- Notice how `data` is an object literal with values as Strings - JSON format!
- Setting the `Content-Type` request header to `application/json` tells the server to expect JSON data. 
- Note how we have to use `JSON.stringify(data)` to change the object literal into an acceptable JSON format

The HTTP request will look like:
```
POST /books HTTP/1.1
Host: ls-230-book-catalog.herokuapp.com
Content-Type: application/json
Accept: */*

{"title": "Eloquent JavaScript", "author": "Marijn Haverbeke"}
```
The browser will probably add additonal headers, but the above should exist.


## Cross-Domain XMLHttpRequests with CORS

The **origin** is defined with: scheme, hostname, and port of a web page's URL.

A **cross-origin request** occurs when the page tries to access a resource from a different origin.

A cross-origin request could be a request for an image, a JavaScript file, an XHR, or any other resource. The most important kind of cross-origin request for our purposes is a cross-domain request: a request from one domain (hostname) to another domain. These requests have security vulnerabilities that can be exploited: google XSS and CSRF to learn about these attacks.

### Cross-Origin Requests with XHR

By default, the `XHR` object *can't* send cross-origin requests. 

All browsers implement a security feature called **the same-origin policy**. The application can request resources from the oigin domain, but a request from any other domain causes an error.

To allow cross-origin access to resources (ex: info from a weather API), applications use the **Cross-Origin Resource Sharing (CORS)**.

### CORS

Cross-Origin Resource Sharing is a W3C specification that defines how the browser and server must communicate when accessing resources across origins. 

Applications use custom HTTP request and response headers to implement this mechanism.

1. When the browser sends an `XMLHttpRequest`, it includes the `Origin` header: 
```
Origin: http://localhost:8080
```

2. When the server receives the request, it checks the `Origin` header to determine if the request came from an origin that is allowed to see the response. 

3. If so, then the response includes this header:
```
Access-Control-Allow-Origin: http://localhost:8080
```
Or if the server wants to make the resource available to everyone, it can send the header with value `*`

4. When the browser sees the `Access-Control-Allow-Origin` header, it checks the value to see if it's the correct origin or `*`. If not, it'll raise an error.

**Learning Point**

The Cross-Origin Resource Sharing specification fulfills the need for legitimate cross-origin requests. It gives us a standard way to access resources from different origins without the security problems associated with cross-origin requests.


## Project: Search Autocomplete

**Throttling** requests means that we delay sending an XHR to the server for a short period, and avoid sending the request if we no longer need it.

The technique waits for some specified time before sending a request to the server. If, in the interim, that request becomes irrelevant due to a newer request, we discard the original request and start a new delay period for the newer request.

Here we implement our custom version of such a throttling method"
``` js
export default (func, delay) => {
  let timeout;
  return (...args) => {
    if (timeout) { clearTimeout(timeout) }
    timeout = setTimeout(() => func.apply(null, args), delay);
  }
}
```

**Misc. things to clarify:**

- What does each part of the code do? :P
- Why do I need to add `type=module` to the HTML JS import when we imported `debounce.js` into `autocomplete.js`?
- How does `debounce` work? Can I apply it to an event listener that gets fired off too much?

## Summary

- AJAX is a technique used to exchange data between a browser and a server without causing a page reload

- Modern browsers provide an API called the `XMLHttpRequest` to send AJAX requests

- Some modern applications rely exclusively on JavaScript and `XMLHttpRequest` to communicate with the server and build up the DOM. Such applications are called *single page applications*.

- Sending requests through `XMLHtpRequest` mainly involves the following steps:
  - Create a new `XMLHttpRequest` object
  - Use the `open` method on the XHR object to specify the method and URL for the request
  - Use the `setRequestHeader` method on the XHR object to set headers you'd like to send with the request. 
  - Use the `send` method on the XHR object to trigger the whole action. On `POST` request we can also pass serialized data as an argument.
  - Attach an event handler for the `load` event to the XHR object to handle the response
  - Attach an event handler for the `error` event to the XHR object to handle any connection errors. 

- XHR objects send asynchronous requests by default, meaning that the rest of the code continues to execute without waiting for the request to complete. 

- Important properties on an XHR object: `responseText`, `response`, `status`, and `statusText`

- The data sent along with requests, if any, must be serialized into a widely supported format.

- Three request serialization formats in widespread use include: 1) query string/url encoding; 2) multi-part form data; 3) JSON.

- It's good practice to send a `Content-Type` header with XHR. This helps the server parse the request data. 

- Three popular response formats: 1) HTML; 2) JSON; 3) XML

- Most popular serialization format: JSON

- To submit a form via XHR, an instance of `FormData` can be used to convenienntly serialize the form into multi-part data format

- One useful property on an XHR object is `responseType`. It's particularly useful when the response is expected to be JSON. When its value is set to `"json"`, the XHR object's response property gives us parsed JSON.

- One major constraint on XHR is the browsers' same-origin policy that limits communication to the same domain, the same port, and the same protocol. Any attempt to communicate outside these limits result in a security error.

- The standard solution for cross-origin restrictions is a W3C specification called Cross-Origin Resource sharing (CORS). CORS recommends using an `Origin` header on the request and an `Access-Control-Allow-Origin` header on the response for cross-origin communications.