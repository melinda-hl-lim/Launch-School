## 1. Privacy

Consider the following class
``` ruby
class Machine
  attr_writer :switch

  def start
    self.flip_switch(:on)
  end

  def stop
    self.flip_switch(:off)
  end

  def flip_switch(desired_state)
    self.switch = desired_state
  end
end
```
Modify this class so both `flip_switch` and the setter method `switch=` are private methods.


## 2. Fixed Array

A fixed-length array is an array that always has a fixed number of elements. Write a class that implements a fixed-length array, and provides the necessary methods to support the following code:
``` ruby
fixed_array = FixedArray.new(5)
puts fixed_array[3] == nil
puts fixed_array.to_a == [nil] * 5

fixed_array[3] = 'a'
puts fixed_array[3] == 'a'
puts fixed_array.to_a == [nil, nil, nil, 'a', nil]

fixed_array[1] = 'b'
puts fixed_array[1] == 'b'
puts fixed_array.to_a == [nil, 'b', nil, 'a', nil]

fixed_array[1] = 'c'
puts fixed_array[1] == 'c'
puts fixed_array.to_a == [nil, 'c', nil, 'a', nil]

fixed_array[4] = 'd'
puts fixed_array[4] == 'd'
puts fixed_array.to_a == [nil, 'c', nil, 'a', 'd']
puts fixed_array.to_s == '[nil, "c", nil, "a", "d"]'

puts fixed_array[-1] == 'd'
puts fixed_array[-4] == 'c'

begin
  fixed_array[6]
  puts false
rescue IndexError
  puts true
end

begin
  fixed_array[-7] = 3
  puts false
rescue IndexError
  puts true
end

begin
  fixed_array[7] = 3
  puts false
rescue IndexError
  puts true
end
```

### Answer: 

``` ruby
class FixedArray 
  def initialize(length)
    @length = length
    @array = Array.new(length)
  end 

  def [](idx)
    @array.fetch(idx)
  end 

  def []=(idx, value)
    self[idx]
    @array[idx] = value
  end 

  def to_a
    @array.clone
  end 

  def to_s
    to_a.to_s
  end 
end 
```

## 3. Students

Below we have 3 classes: `Student`, `Graduate`, and `Undergraduate`. Some details for these classes are missing. Make changes to the classes below so that the following requirements are fulfilled:
    1. Graduate students have the option to use on-campus parking, while Undergraduate students do not.
    2. Graduate and Undergraduate students have a name and year associated with them.

``` ruby
class Student
  def initialize(name, year)
    @name = name
    @year = year
  end
end

class Graduate
  def initialize(name, year, parking)
  end
end

class Undergraduate
  def initialize(name, year)
  end
end
```

### Answer:
``` ruby
class Student
  def initialize(name, year)
    @name = name
    @year = year
  end
end

class Graduate < Student
  def initialize(name, year, parking)
    @parking = parking
    super(name, year)
  end
end

class Undergraduate < Student
  def initialize(name, year)
    super
  end
end
```

## 4. Circular Queue

A circular queue is a collection of objects stored in a buffer that is treated as though it is connected end-to-end in a circle. When an object is added to this circular queue, it is added to the position that immediately follows the most recently added object, while removing an object always removes the object that has been in the queue the longest.

This works as long as there are empty spots in the buffer. If the buffer becomes full, adding a new object to the queue requires getting rid of an existing object; with a circular queue, the object that has been in the queue the longest is discarded and replaced by the new object.

Your task is to write a `CircularQueue` class that implements a circular queue for arbitrary objects. The class should obtain the buffer size with an argument provided to `CircularQueue::new`, and should provide the following methods:

    - `enqueue` to add an object to the queue
    - `dequeue` to remove (and return) the oldest object in the queue. It should return `nil` if the queue is empty.

You may assume that none of the values stored in the queue are `nil` (however, `nil` may be used to designate empty spots in the buffer).

Given test cases:
``` ruby
queue = CircularQueue.new(3)
puts queue.dequeue == nil

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil

queue = CircularQueue.new(4)
puts queue.dequeue == nil

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 4
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil
```

### Answer:
``` ruby
class CircularQueue 
  def initialize(buffer_length)
    @buffer_length = buffer_length
    @buffer = Array.new(buffer_length)
  end

  def enqueue(obj)
    buffer.delete_at(0) if full?
    buffer.push(obj)
    move_empty_slots_to_end
  end
  
  def dequeue
    return nil if buffer.empty?

    buffer.push(nil)
    buffer.delete_at(0)
  end

  private

  attr_reader :buffer, :buffer_length

  def full?
    !(buffer.include?(nil))
  end

  def move_empty_slots_to_end
    buffer.select! { |obj| obj != nil }
    missing_slots = buffer_length - buffer.length 
    missing_slots.times { buffer.push(nil) }
  end 
end
```


## 5. Stack Machine Interpretation


## 6. Number Guesser Part 1

Create an object-oriented number guessing class for numbers in the range 1 to 100, with a limit of 7 guesses per game. The game should play like this:
``` ruby
game = GuessingGame.new
game.play

You have 7 guesses remaining.
Enter a number between 1 and 100: 104
Invalid guess. Enter a number between 1 and 100: 50
Your guess is too low.

.
.
.

You have 3 guesses remaining.
Enter a number between 1 and 100: 81
Thats the number!

You won!
or
You have no more guesses. You lost!
```

Note that a game object should start a new game with a new number to guess with each call to #play.


### Answer
``` ruby
class GuessingGame
  GUESSES_LIMIT = 7
  
  def initialize
    select_winning_number
    @guesses_remaining = GUESSES_LIMIT
    @guessed = false
  end

  def play
    loop do 
      display_remaining_guesses
      guess = prompt_player_guess
      evaluate_guess_accuracy(guess)
      update_remaining_guesses
      break if game_over?
    end
  end

  private

  attr_reader :winning_number
  attr_accessor :guesses_remaining, :guessed

  def select_winning_number
    @winning_number = rand(1..100)
  end

  def display_remaining_guesses
    puts "You have #{guesses_remaining} guesses remaining."
  end

  def prompt_player_guess
    puts "Enter a number between 1 and 100: "
    guess = ""
    loop do
      guess = gets.chomp.to_i
      break if (1..100).include?(guess)
      puts "Invalid guess. Enter a number between 1 and 100: "
    end
    guess
  end

  def evaluate_guess_accuracy(guess)
    if guess == winning_number
      puts "Thats the number!" 
      puts "You won!"
      self.guessed = true
    else
      result = guess < winning_number ? "low" : "high"
      puts "Your guess is too #{result}."
      puts ""
    end
  end

  def update_remaining_guesses
    self.guesses_remaining = guesses_remaining - 1
  end

  def game_over?
    guessed || guesses_remaining == 0
  end
end
```