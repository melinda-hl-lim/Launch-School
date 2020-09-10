function Pet() {
  this.loved = true;
}

Pet.prototype.giveLove = function () {
  console.log('Petting the pet! So much love <3');
};

function Dog(name, age) {
  this.name = name;
  this.age = age;
}

Dog.prototype = Object.create(Pet.prototype);
Dog.prototype.constructor = Dog;

Dog.prototype.greet = function () {
  console.log(`Woof! I'm ${this.name}!`);
};

Dog.prototype.dig = function () {
  console.log('Digging dig dig~');
};

const puppi = new Dog('Puppi', 8);
console.log(puppi.name); // => Puppi
puppi.greet(); // => Woof! I'm Puppi!
puppi.giveLove(); // => Petting the pet! So much love <3
