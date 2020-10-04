# HTTP Requests From JavaScript

## XMLHttpRequest 

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

### Misc.

- Events `readystatechange` and `readyState`???


## Data Serialization

Three ways we've learnt: 
- query string/url encoding
- multipart forms
- JSON


**Query String/URL Encoding:**

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


**Multipart Forms**

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


**JSON (JavaSCript Object Notation)**

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
