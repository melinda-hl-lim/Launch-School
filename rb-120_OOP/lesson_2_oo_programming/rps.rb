require 'pry'

class Player
  attr_accessor :name, :move, :score, :move_history

  def initialize
    @score = 0
    @move_history = []
  end

  def update_score
    self.score += 1
  end
end

class Human < Player
  def initialize(message)
    super()
    get_name(message)
  end

  def choose(message)
    self.move = Move.new(valid_human_choice(message))
  end

  private

  def get_name(message)
    response = ""
    loop do
      message.prompt_name
      response = gets.chomp.strip
      break unless response.empty?
      message.invalid_name
    end
    self.name = response.capitalize
  end

  def valid_human_choice(message)
    choice = nil
    loop do
      message.prompt_human_choice
      choice = gets.chomp
      break if Move::VALUES.include? choice
      message.invalid_choice
    end
    choice
  end
end

class Computer < Player
  attr_reader :move_pool

  def initialize
    super()
    select_name
  end

  private

  attr_writer :move_pool

  def select_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny'].sample
  end

  def random_move
    mv = Move::VALUES.sample
    Move.new(mv)
  end
end

class Haphazard < Computer
  def initialize(_)
    initialize_move_choices
    super()
  end

  def choose
    self.move = move_pool.sample
    move_history << move
  end

  private

  def initialize_move_choices
    @move_pool = []
    Move::VALUES.each { |mv| @move_pool << Move.new(mv) }
  end
end

class Unyielding < Computer
  def initialize(_)
    initialize_move_choices
    super()
  end

  def choose
    self.move = move_pool[0]
    move_history << move
  end

  private

  def initialize_move_choices
    @move_pool = [random_move]
  end
end

class Hustler < Computer
  def initialize(_)
    initialize_move_choices
    super()
  end

  def choose
    num = rand(0..99)
    self.move = num < 66 ? move_pool[0] : move_pool[1]
    move_history << move
  end

  private

  def initialize_move_choices
    @move_pool = [random_move]
    opposite_moves = Move::WINNING_CHOICES[random_move.value]
    @move_pool << Move.new(opposite_moves[0])
  end
end

class SoreLoser < Computer
  def initialize(other_player)
    initialize_move_choices(other_player)
    super()
  end

  def choose
    if move_pool.length < 2
      # For the first move, select randomly
      mv = Move::VALUES.sample
      self.move = Move.new(mv)
    else
      # For all other moves, use the human player's previous move choice
      self.move = move_pool[-2]
    end
    move_history << move
  end

  private

  def initialize_move_choices(other_player)
    @move_pool = other_player.move_history
  end
end

class Cheater < Computer
  def initialize(other_player)
    initialize_move_choices(other_player)
    super()
  end

  def choose
    # The cheater looks into the human's current choice
    # and create a move that beat human's choice
    human_move = move_pool[-1].value
    winning_moves = Move::WINNING_CHOICES.select do |_, v|
      v.include? human_move
    end
    cheater_choice = winning_moves.keys.sample
    self.move = Move.new(cheater_choice)
    move_history << move
  end

  private

  def initialize_move_choices(other_player)
    @move_pool = other_player.move_history
  end
end

class Move # Move object is a collaborator of human and computer classes
  attr_reader :value

  WINNING_CHOICES = { 'rock' => ['scissors', 'lizard'],
                      'paper' => ['rock', 'spock'],
                      'scissors' => ['paper', 'lizard'],
                      'lizard' => ['paper', 'spock'],
                      'spock' => ['rock', 'scissors'] }.freeze
  VALUES = WINNING_CHOICES.keys

  def initialize(value)
    @value = value
  end

  def to_s
    value
  end

  def >(other_move)
    WINNING_CHOICES[value].include?(other_move.value)
  end

  def ==(other_move)
    value == other_move.value
  end
end

class Message
  def display_welcome_message
    puts "Welcome to the ultimate RPS-off!"
  end

  def prompt_name
    line_break
    puts "What's your name?"
  end

  def invalid_name
    puts "That doesn't look like a name, silly. Please tell me your name."
  end

  def prompt_set_game_limit
    line_break
    puts "Would you like to battle to a certain score?"
    puts "Once someone reaches that score, they are the winner!"
    puts "Please choose y/n."
  end

  def prompt_score_limit
    line_break
    puts "What score would you like to play to?"
  end

  def invalid_score_limit
    puts "Please enter a score (i.e. number)."
  end

  def prompt_human_choice
    valid_choices = "#{Move::VALUES[0...-1].join(', ')} or #{Move::VALUES[-1]}"
    puts "Please choose one: #{valid_choices}."
  end

  def invalid_choice
    puts "Sorry, that's not a choice I understand."
  end

  def display_choices(game)
    line_break
    puts "#{game.human.name} chose #{game.human.move}."
    puts "#{game.computer.name} chose #{game.computer.move}."
  end

  def display_score(game)
    puts "#{game.human.name}'s score is #{game.human.score}"
    puts "#{game.computer.name}'s score is #{game.computer.score}"
  end

  def move_history(game)
    human = game.human
    computer = game.computer
    num_rounds = human.move_history.length
    line_break
    puts "Here's the plays in each round so far... "
    num_rounds.times do |i|
      display = "Round #{i + 1}".center(12) + "|"
      display += "#{human.move_history[i].value}".center(12) + "|"
      display += "#{computer.move_history[i].value}".center(12)
      puts display
    end
    line_break
  end

  def continue_game?
    line_break
    puts "Press enter to continue."
    gets.chomp
  end

  def tie
    puts "It's a tie!"
  end

  def winner(winner)
    puts "#{winner.name} won that round! Plus one to #{winner.name}'s score!"
  end

  def final_winner(winner)
    puts "After a grueling tournament, one fighter has remained standing."
    puts "Ladies and gentlemen, the greatest RPS-er of all time is..."
    puts "#{winner.name}!" unless winner.nil?
    puts "No one! It's a tie!" if winner.nil?
  end

  def display_goodbye_message
    puts "Thanks for playing. Bye~"
  end

  def play_again?
    line_break
    puts "Would you like to play again? (y/n)"
    answer = nil
    loop do
      answer = gets.chomp
      break if ['y', 'n'].include? answer.downcase
      puts "Sorry, please choose either y or n."
    end
    answer == 'y'
  end

  private

  def line_break
    puts "\n"
  end
end

class RPSGame
  attr_accessor :message, :human, :computer, :game_limit, :score_limit

  PERSONALITIES = [Haphazard, Unyielding, Hustler, SoreLoser, Cheater]

  def initialize
    system("clear")
    @message = Message.new
    message.display_welcome_message
    @human = Human.new(message)
    @computer = PERSONALITIES.sample.new(@human)
    set_game_limit
    set_score_limit if game_limit
  end

  def play
    loop do
      system("clear")
      human.choose(message)
      computer.choose
      message.display_choices(self)
      message.move_history(self)
      round_winner = determine_round_winner
      display_round_winner(round_winner, message)
      round_winner.update_score unless round_winner.nil?
      message.display_score(self)
      message.continue_game? if game_limit
      break if play_again
    end
    system("clear")
    display_final_results
    message.display_goodbye_message
  end

  private

  def set_game_limit
    message.prompt_set_game_limit
    response = ''
    loop do
      response = gets.chomp.strip
      break if ['y', 'n'].include? response
      message.invalid_choice
    end
    response == "y" ? @game_limit = true : @game_limit = false
  end

  def set_score_limit
    message.prompt_score_limit
    response = 3
    loop do
      response = gets.chomp
      break if response.empty? || response.to_i > 0
      message.invalid_score_limit
    end
    @score_limit = response.to_i
  end

  def determine_round_winner
    return nil if human.move == computer.move
    human.move > computer.move ? human : computer
  end

  def display_round_winner(winner, message)
    winner.nil? ? message.tie : message.winner(winner)
  end

  def score_limit_reached?
    if game_limit
      return (human.score == score_limit) || (computer.score == score_limit)
    end
    false
  end

  def play_again
    game_limit ? score_limit_reached? : !(message.play_again?)
  end

  def display_final_results
    if human.score == computer.score
      winner = nil
    elsif game_limit
      winner = human.score == score_limit ? human : computer
    else
      winner = human.score > computer.score ? human : computer
    end
    message.final_winner(winner)
    message.display_score(self)
  end
end

RPSGame.new.play
