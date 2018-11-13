function total_bill(bill_list) {

    var total = 0;
  for (var i = 0; i < bill_list.length; i++) {
    for (let food of bill_list[i]) {
        var price = food.price.replace(/^\$/, '');
        total += Number(price);
    }
  }
    return total;
}

module.exports = total_bill;
