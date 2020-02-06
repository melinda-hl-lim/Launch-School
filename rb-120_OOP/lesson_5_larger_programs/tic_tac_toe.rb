require 'pry'

class Board
  INITIAL_MARKER = " "

  def initialize
    @squares = {}
    (1..9).each { |key| @squares[key] = Square.new(INITIAL_MARKER) }
  end

  def get_square(key)
    @squares[key]
  end

  def mark_square(key, marker)
    @squares[key].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |k, v| @squares[k].unmarked? }
  end
end

class Square
  attr_accessor :marker

  def initialize(marker)
    @marker = marker
  end

  def to_s
    marker
  end

  def unmarked?
    marker == Board::INITIAL_MARKER
  end
end

class Player
  attr_reader :marker

  def initialize(marker)
    @marker = marker
  end
end

class TTTGame
  HUMAN_MARKER = "X"
  COMPUTER_MARKER = "O"

  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
  end

  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
    puts ""
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def display_board
    puts ""
    puts "       |       |"
    puts "   #{board.get_square(1)}   |   #{board.get_square(2)}   |   #{board.get_square(3)}   "
    puts "       |       |"
    puts "-------+-------+-------"
    puts "       |       |"
    puts "   #{board.get_square(4)}   |   #{board.get_square(5)}   |   #{board.get_square(6)}   "
    puts "       |       |"
    puts "-------+-------+-------"
    puts "       |       |"
    puts "   #{board.get_square(7)}   |   #{board.get_square(8)}   |   #{board.get_square(9)}   "
    puts "       |       |"
    puts ""
  end

  def human_moves
    puts "Choose a square (#{board.unmarked_keys.join(', ')}):"
    square = ""
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end

    board.mark_square(square, human.marker)
  end

  def computer_moves
    num = board.unmarked_keys.sample
    board.mark_square(num, computer.marker)
  end

  def play
    display_welcome_message
    display_board
    loop do
      human_moves
      #break if someone_won? || board_full?

      computer_moves
      #break if someone_won? || board_full?

      display_board
    end
    #display_result
    display_goodbye_message
  end
end

game = TTTGame.new
game.play
