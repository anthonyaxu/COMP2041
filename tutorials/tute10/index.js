// let's note the power with cleaning some user data.
const users = [
    {
      name: 'Jeff',
      age: 52,
      gender: 'male'
    },
    {
      name: 'Andy',
      age: 25,
      gender: 'male'
    },
    {
      name: 'Sarah',
      age: 30,
      gender: 'female'
    },
    {
      name: 'Phoebe',
      age: 21,
      gender: 'female'
    },
    {
      name: 'Doris',
      age: 81,
      gender: 'female'
    }
];

// Essentially a function (arrow notation)
// isMale becomes a function because (person) is a function
// '===' checks for 'deep' equality. Makes sure every single key in the object is equal
// '==' checks for a 'shallow' equality. Only makes sure the objects (type)? are equal
// Using curly braces ({}), it must return something
// const isMale = (person) => { return person.gender === 'male'} is how you're supposed to use it
// const isMale = (person) => { person.gender === 'male' } Not meant to use it like this
const isMale = (person) => person.gender === 'male';

// These two functions are essentially the same (but no exactly)
// funnction isMale(person) {
//   person.gender === 'male';
// }

const startsWith = (letter) => (person) => person.name.startsWith(letter);
const sum = (total, current) => total + current;

const ageOfMaleNamesStartingWithA = users.filter(isMale).filter(startsWith('A')).map(({ age }) => age);

const average_ages = ageOfMaleNamesStartingWithA.reduce(sum, 0)/ageOfMaleNamesStartingWithA.length();

console.log(average_ages);