require 'pry'

class Move # Move object is a collaborator of human and computer classes
  VALUES = ['rock', 'paper', 'scissors']

  def initialize(value)
    @value = value
  end

  def to_s
    @value
  end

  def >(other_move)
    return other_move.scissors? if rock?
    return other_move.rock? if paper?
    return other_move.paper? if scissors?
  end

  def <(other_move)
    return other_move.paper? if rock?
    return other_move.scissors? if paper?
    return other_move.rock? if scissors?
  end

  protected

  def scissors?
    @value == 'scissors'
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end
end

class Player
  attr_accessor :name, :move

  def initialize
    set_name
  end
end

class Human < Player
  def choose
    self.move = Move.new(valid_human_choice)
  end

  private

  def set_name
    n = ""
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, please tell me your name!"
    end
    self.name = n
  end

  def valid_human_choice
    choice = nil
    loop do
      puts "Please choose one: rock, paper, or scissors."
      choice = gets.chomp
      break if Move::VALUES.include? choice
      puts "Sorry, that's an invalid choice."
    end
    choice
  end
end

class Computer < Player
  def choose
    mv = Move::VALUES.sample
    self.move = Move.new(mv)
  end

  private

  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny'].sample
  end
end

class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def play
    display_welcome_message
    loop do
      human.choose
      computer.choose
      display_choices
      display_winner
      break unless play_again?
    end
    display_goodbye_message
  end

  private

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors!"
  end

  def display_goodbye_message
    puts "Thanks for playing. Bye~"
  end

  def display_choices
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
  end

  def display_winner
    if human.move > computer.move
      puts "#{human.name} won!"
    elsif human.move < computer.move
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end
  end

  def play_again?
    puts "Would you like to play again? (y/n)"
    answer = nil
    loop do
      answer = gets.chomp
      break if ['y', 'n'].include? answer.downcase
      puts "Sorry, please choose either y or n."
    end
    answer == 'y'
  end
end

RPSGame.new.play

# class Rule
#   def initialize
#     # not sure what the "state" of a rule object should be
#   end
# end
