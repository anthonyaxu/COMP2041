function species_count(target_species, whale_list) {

  // PUT YOUR CODE HERE
  var sum = 0;
  for (let whales of whale_list) {
    if (whales.species === target_species) {
        sum += whales.how_many;
        //console.log(whales.species);
    }
  }
  return sum;
}

module.exports = species_count;
