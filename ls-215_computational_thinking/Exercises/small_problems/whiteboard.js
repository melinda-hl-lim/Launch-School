function transactionsFor(itemId, transactions) {
  return transactions.filter((transaction) => transaction.id === itemId);
}

function isItemAvailable(itemId, transactions) {
  const itemTransactions = transactionsFor(itemId, transactions);
  let numAvailable = 0;

  itemTransactions.forEach((record) => {
    if (record.movement === 'in') {
      numAvailable += record.quantity;
    } else {
      numAvailable -= record.quantity;
    }
  });

  return numAvailable > 0;
}
