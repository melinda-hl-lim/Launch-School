## 1. Buggy Code 1

The code below is expected to output the following when run:
```
> const helloVictor = createGreeter('Victor');
> helloVictor.greet('morning');
= Good Morning Victor
```
``` js
function createGreeter(name) {
  return {
    name,
    morning: 'Good Morning',
    afternoon: 'Good Afternoon',
    evening: 'Good Evening',
    greet(timeOfDay) {
      let msg = '';
      switch (timeOfDay) {
        case 'morning':
          msg += `${this.morning} ${this.name}`;
          break;
        case 'afternoon':
          msg += `${this.afternoon} ${this.name}`;
          break;
        case 'evening':
          msg += `${this.evening} ${this.name}`;
          break;
        default:
      }

      console.log(msg);
    },
  };
}

const puppi = createGreeter('Puppi');
puppi.greet('morning');
```
However, it instead results in an error. What is the problem with the code? Why isn't it producing the expected results?

*Melinda answer*

The error is that the code doesn't print out anything. Originally, the code in the `case` statements did not include any `this`. So the variables `morning`, `afternoon`, `evening`, and `name` all referenced undeclared variables, not the keys of the calling object.


## 2. Buggy Code 2

A grocery store uses a JavaScript function to calculate discounts on various items. They are testing out various percentage discounts but are getting unexpected results. Go over the code, and identify the reason why they aren't getting the expected discounted prices from the function. Then, modify the code so that it produces the correct results.

``` js
const item = {
  name: 'Foo',
  description: 'Fusce consequat dui est, semper.',
  price: 50,
  quantity: 100,
  discount(percent) {
    const discount = this.price * percent / 100;
    // this.price -= discount;

    return this.price - discount;
  },
};
```

*Melinda answer*

The code above produces unexpected results because we are reassigning the item's price to the discounted price each time. This way, the discount isn't calculated off the original price of `50`; it's calculated off the most recent discounted price. 

To fix this problem we simply remove the line that reassigns price to the discounted price, and return `this.price - discount`. 


## 3. Testing Object Equality

In JS, comparing two objects either with `==` or `===` checks for object identity. In other words, the coparison evaluates to `true` if it's the same object on either side of `==` or `===`. This is a limitation, in a sense, because sometimes we need to check if two objects have the same key/value pairs. JS doesn't give us a way to do that.

Write a function `objectsEqual` that accepts two object arguments and returns `true` or `false` depending on whether the objects have the same key/value pairs.

Examples:
``` js
console.log(objectsEqual({a: 'foo'}, {a: 'foo'}));                      // true
console.log(objectsEqual({a: 'foo', b: 'bar'}, {a: 'foo'}));            // false
console.log(objectsEqual({}, {}));                                      // true
console.log(objectsEqual({a: 'foo', b: undefined}, {a: 'foo', c: 1}));  // false
```

``` js
function objectsEqual(a, b) {
  if (a === b) {
    return true;
  }

  return (keysMatch(a, b) && valuesMatch(a, b));
}

function keysMatch(a, b) {
  const aKeys = Object.getOwnPropertyNames(a).sort();
  const bKeys = Object.getOwnPropertyNames(b).sort();

  if (aKeys.length !== bKeys.length) {
    return false;
  }

  return aKeys.every((key, index) => key === bKeys[index]);
}

function valuesMatch(a, b) {
  const aKeys = Object.getOwnPropertyNames(a).sort();

  return aKeys.every(key => a[key] === b[key]);
}
```


## 4. Student

Create an object factory for a student object. The student object should have the following methods and it should produce the expected results demonstrated in the sample code:

- `info`: Logs the name and year of the student.
- `addCourse`: Enrolls student in a course. A course is an object literal that has properties for its `name` and `code`.
- `listCourses`: Returns a list of the courses student has enrolled in.
- `addNote`: Adds a `note` property to a course. Takes a code and a note as an argument. If a note already exists, the note is appended to the existing one.
- `updateNote`: Updates a `note` for a course. Updating a note replaces the existing note with the new note.
- `viewNotes`: Logs the notes for all the courses. Courses without notes are not displayed.

``` js
function createStudent(name, year) {
  return {
    name,
    year,
    courses: [],
    info() {
      console.log(`${name} is a student in year ${year}.`);
    },
    addCourse(courseName, code) {
      const course = { courseName, code };
      this.courses.push(course);
    },
    listCourses() {
      return this.courses;
    },
    addNote(course, note) {
      const idxCourse = this.courses.indexOf(course);
      const currentCourse = this.courses[idxCourse];
      currentCourse.note = note;
    },
    updateNote(course, note) {
      this.addNote(course, note);
    },
    viewNotes() {
      this.courses.forEach((course) => {
        if (course.note) {
          console.log(course.note);
        }
      });
    },
  };
}
```

Launch School's solution touches on a couple other things:
- For `addNote` and `updateNote`:
  - Both check if course exists first
  - If note exists on course, `addNote` appends the note to existing notes while `updateNote` overwrites the existing note
- Adding a course -- the argument is already a course object


## 5. School

Create a `school` object. The `school` object uses the `student` object from the previous exercise. It has methods that use and update information about the student. Be sure to check out the previous exercise for the other arguments that might be needed by the `school` object. Implement the following methods for the school object:

- `addStudent`: adds a student by creating a new student and adding the student to a collection of students. The method adds a constraint that the year can only be any of the following values: `'1st'`, `'2nd'`, `'3rd'`, `'4th'` or `'5th'`. Returns a student object if year is valid; otherwise it logs `'Invalid Year'`. 
- `enrollStudent`: Enrolls a student in a course
- `addGrade`: adds the grade of a student for a course
- `getReportCard`: Logs the grades of a student for all courses. If the course has no grade, it uses `'In Progress'` as a grade.
- `courseReport`: Logs the grades of all students for a given course name. Only student with grades are part of the course report. 