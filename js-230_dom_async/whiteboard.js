document.addEventListener('DOMContentLoaded', () => {
  const request = new XMLHttpRequest();
  request.open('GET', 'localhost:3000/api/schedules');
  debugger;

  request.addEventListener('load', (event) => {
    const request = event.target;
    debugger;
  });
  request.send();
});
