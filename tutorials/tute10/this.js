// this can be confusing
const o = {
   // Creating an object
   bb: 0,
   f() {
      console.log(this.bb);
   }
};

// What does this print out
o.f();

// What does this line do
// 'a' is now a function. Contains the contents of f
let a = o.f;

// What would this print out
// Prints out undefined because it a doesn't have accesss to 'bb', a is 'outside of the scope'
a();

const oo = {bb: 'Barry'};

// What does call do and what will it print out?
// a() and a.call() are the same
// Can pass into call what you want to be defined as 'this'
// This function prints out 'Barry'
a.call(oo);

// What does bind do, is f() the same as a()?
// 'bind' adds the function a to the object 'oo', basically 'oo' is always contained in a
const f = a.bind(oo);

// what does this print out
f();