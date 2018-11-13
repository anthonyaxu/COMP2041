/*
 * Fill out the Person prototype
 * function "buyDrink" which given a drink object which looks like:
 * {
 *     name: "beer",
 *     cost: 8.50,
 *     alcohol: true
 * }
 * will add the cost to the person expences if the person
 * is
 *    1. old enough to drink (if the drink is alcohol)
 *    2. buying the drink will not push their tab over $1000
 *
 * in addition write a function "getRecipt" which returns a list as such
 * [
 *    {
 *        name: beer,
 *        count: 3,
 *        cost: 25.50
 *    }
 * ]
 *
 * which summaries all drinks a person bought by name in order
 * of when they were bought (duplicate buys are stacked)
 *
 * run with `node test.js <name> <age> <drinks file>`
 * i.e
 * `node test.js alex 76 drinks.json`
 */
 
function bubbleSort(array) {
    var swapped;
    do {
        swapped = false;
        for (var i = 0; i < array.length-1; i++) {
            if (!(array[i].name < array[i+1].name)) {
                var temp = array[i];
                array[i] = array[i+1];
                array[i+1] = temp;
                swapped = true;
            }
        }
    } while (swapped);
    return array;
}

function Person(name, age) {
    this.name = name;
    this.age = age;
    this.tab = 0;
    this.history = {};
    this.historyLen = 0;
    this.canDrink = function() {
      return this.age >= 18;
    };
    this.canSpend = function(cost) {
      return this.tab + cost <= 1000;
    }
}

// write me
Person.prototype.buyDrink = function(drink) {
    if (drink.alcohol) {
        if (!this.canDrink()) {
            return;
        }
    }
    if (this.canSpend(drink.cost)) {
        this.tab += drink.cost;
        if (drink.name in this.history) {
            this.history[drink.name].count++;
            this.history[drink.name].total += drink.cost;
        } else {
            var liquid = {name: drink.name, count: 1, total: drink.cost}
            this.history[drink.name] = liquid;
            this.historyLen++;
        }
    }
}
// write me
Person.prototype.getRecipt = function() {
    bubbleSort(this.history);
    var drinks = [];
    var counter = 0;
    for (var drink in this.history) {
        if (counter > this.historyLen) {
            break;
        }
        drinks[counter] = this.history[drink];
        counter++;
    }
    return drinks;
}

module.exports = Person;
