
function sum(list) {

    // PUT YOUR CODE HERE
    var sum = 0;
    for (var num in list) {
        sum += Number(list[num]);
        //console.log(list[num]);
    }
    return sum;
    //console.log(sum);
}

module.exports = sum;
