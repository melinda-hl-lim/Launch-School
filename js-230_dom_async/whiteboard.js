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
