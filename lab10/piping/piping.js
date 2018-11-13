/*
 * Write a function called buildPipe that returns a function
 * which runs all of it's input functions in a pipeline
 * let timesTwo = (a) => a*2;
 * let timesThree = (a) => a*3;
 * let minusTwo = (a) => a - 2;
 * let pipeline = buildPipe(timesTwo, timesThree, minusTwo);
 *
 * pipeline(6) == 34
 *
 * pipeline(x) in this case is the same as minusTwo(timesThree(timesTwo(x)))
 *
 * test with `node test.js`
 */
 
const pipe = (first, second, third) => (...args) => third(second(first(...args)))

function buildPipe(first, second, third) {
    const maths = pipe(first, second, third)
    return maths;
}

module.exports = buildPipe;
