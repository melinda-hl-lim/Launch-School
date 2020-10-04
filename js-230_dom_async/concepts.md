# HTTP Requests From JS

## XMLHttpRequest

`XMLHttpRequest` is a browser API that provides network programming functionality to JS applications.

The *request-response cycle* is the underlying foundation for web applications. 

- Typically, when the user clicks a link, the browser automatically requests the page and renders it upon receiving a response.

- However, reloading an entire HTML page is a limiting factor with more interactive sites and complex interfaces. 

**Asynchronous JavaScript and XML (AJAX)** is a technique that allows us to fetch data and update only parts of the page.

- With AJAX, JS code initiates the HTTP request, typically from an event listener. When the browser receives a response, JS code takes the response's body and updates the page as needed. 


> Side note: Single Page Applications
>
> SPAs run entirely within a single HTML page. These apps fetch data in a serialized format and create the DOM entirely from JS running in a client's browser. 

### Methods

``` js
let request = new XMLHttpRequest();

request.open('GET', 'url'); 

request.setRequestHeader('header', 'value');

request.send(); 
// Can optionally send a `data` argument
// Is asynchronous - use event listeners to know when the request completes

request.abort(); 
// Cancel an active request

request.getResponseHeader(header);
// return the response's value for `header`
```

### Properties

``` js
request.timeout = 1000; 
// set a 1000 millisecond period until the request times out

request.readyState; 
// What state the request is in

request.responseText;
// raw text of response body

request.response;
// parsed content of response - not usually meaningful...?
```

### Events

Two main events fire during an `XMLHttpRequest`:

- `loadstart`: request sent to server
- `loadend`: response loading done and all other events have fired. Last event to fire.

Before `loadend` triggers, one other event will be fired based on whether the request succeeded:

- `load`: a complete response loaded
- `abort`: the request was interrupted before it could complete
- `error`: an error occured
- `timeout`: a response wasn't received before the timeout period ended

**Any request that receives a complete response is successful.** Even if the response is a non-200 status. In this case, the application code should determine if the response was successful in the `load` event handler:

``` js
request.addEventListener('load', (event) => { 
  // ... 
})
```

---

## Data Serialization

**Data serialization** provides a common way for systems to pass data to each other. Serialization lets both the client and server transfer data in a format that preserves information without interfering with the communication protocol.

Three ways we've learnt: 
- query string/url encoding
- multipart forms
- JSON

### Query String/URL Encoding:

- Use JS function `encodeURIComponent` to encode names or values
- Then combine name-value pairs with `=`
- Then combine multiple pairs with `&` 

`GET` requests:
``` 
GET /path?title=Do%20Androids%20Dream%20of%20Electric%20Sheep%3F&year=1968 HTTP/1.1
Host: example.test
Accept: */*
```

`POST` requests:
``` 
POST /path HTTP/1.1
Host: example.test
Content-Length: 54
Content-Type: application/x-www-form-urlencoded; charset=utf-8
Accept: */*

title=Do%20Androids%20Dream%20of%20Electric%20Sheep%3F&year=1968
```
- Set `Content-Type` to `application/x-www-form-urlencoded; charset=utf-8`


### Multipart Forms

`POST` requests use *multipart form formats* for forms that: 
- include file uploads
- use `FormData` objects to collect data
``` 
POST /path HTTP/1.1
Host: example.test
Content-Length: 267
Content-Type: multipart/form-data;boundary=----WebKitFormBoundarywDbHM6i57QWyAWro
Accept: */*

------WebKitFormBoundarywDbHM6i57QWyAWro
Content-Disposition: form-data; name="title"

Do Androids Dream of Electric Sheep?
------WebKitFormBoundarywDbHM6i57QWyAWro
Content-Disposition: form-data; name="year"

1968
------WebKitFormBoundarywDbHM6i57QWyAWro--
```
- Set `Content-Type` to: 
  1. `multipart/form-data;`
  2. a **boundary delimiter** to separate each name-value pair: `boundary=----WebKitFormBoundarywDbHM6i57QWyAWro`
- Final boundary delimiter has extra `--` marking the end of the multipart content


### JSON (JavaSCript Object Notation)

Supports arrays, objects, strings, numbers and booleans. Does not support complex data types like dates and times. 

A `GET` request can return JSON.

Use `POST` request to send JSON data:
``` 
POST /path HTTP/1.1
Host: example.test
Content-Length: 62
Content-Type: application/json; charset=utf-8
Accept: */*

{"title":"Do Androids Dream of Electric Sheep?","year":"1968"}
```
- Set `Content-Type` to `application/json; charset=utf-8`

### Examples

#### Loading HTML via XHR

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

#### Submitting a Form via XHR

**URL encoding POST parameters**

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

**Submitting a form**
``` html
<form id="form">
  <p><label>Title: <input type="text" name="title"></label></p>
  <p><label>Author: <input type="text" name="author"></label></p>
  <p><button type="submit">Submit</button></p>
</form>
```
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

**Submitting a form with `FormData` (Multipart forms)**

**`FormData`** is a built-in API provided by modern browsers. It only uses input fields that have a `name` attribute.
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

#### Loading JSON via XHR

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
Notice how above we have to handle any errors that may occur from parsing the JSON response. 

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

#### Sending JSON via XHR

``` js
let request = new XMLHttpRequest();
request.open('POST', 'https://ls-230-book-catalog.herokuapp.com/books');

request.setRequestHeader('Content-Type', 'application/json');

let data = { title: 'Eloquent JavaScript', author: 'Marijn Haverbeke' };
let json = JSON.stringify(data);

request.send(json);
```

## Cross-Domain XMLHttpRequests with CORS

The **origin** is defined with: scheme, hostname, and port of a web page's URL.

A **cross-origin request** occurs when the page tries to access a resource from a different origin. Such requests can have security vulnerabilities that can be exploited (specifically cross-domain requests).

Browsers implement the **same-origin policy**. The application can request resources from the origin domain, but a request from any other domain causes an error. 

To allow cross-origin access to resources (ex: info from a weather API), applications use the **Cross-Origin Resource Sharing (CORS)**.

### Cross-Origin Resource Sharing

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

