require 'pry'

class Board
  attr_reader :squares

  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  def initialize
    @squares = {}
    reset
  end

  def get_square(key)
    @squares[key]
  end

  def []=(num, marker)
    @squares[num].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |k, _| @squares[k].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def markers_in_line(line)
    squares.values_at(*line).collect(&:marker)
  end

  def two_in_a_line?(line, marker)
    markers = markers_in_line(line)
    markers.count(marker) == 2
  end

  def three_identical_markers?(line)
    markers_in_line = line.select(&:marked?).collect(&:marker)
    return false if markers_in_line.size != 3

    markers_in_line.min == markers_in_line.max
  end

  # Return winning marker or nil
  def winning_marker
    WINNING_LINES.each do |line|
      squares_in_line = @squares.values_at(*line)
      if three_identical_markers?(squares_in_line)
        return squares_in_line.first.marker
      end
    end
    nil
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  # rubocop:disable Metrics/AbcSize
  def draw
    puts "       |       |"
    puts "   #{@squares[1]}   |   #{@squares[2]}   |   #{@squares[3]}   "
    puts "       |       |"
    puts "-------+-------+-------"
    puts "       |       |"
    puts "   #{@squares[4]}   |   #{@squares[5]}   |   #{@squares[6]}   "
    puts "       |       |"
    puts "-------+-------+-------"
    puts "       |       |"
    puts "   #{@squares[7]}   |   #{@squares[8]}   |   #{@squares[9]}   "
    puts "       |       |"
  end
end
# rubocop:enable Metrics/AbcSize

class Square
  INITIAL_MARKER = " "
  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end
end

class Player
  attr_reader :marker

  def initialize(marker)
    @marker = marker
  end
end

class Computer < Player
  def select_move(board)
    offense = offensive_move(board)
    defense = defensive_move(board)
    valid_squares = board.unmarked_keys

    offense || defense || valid_squares.sample
  end

  def defensive_move(board)
    one_empty_square_in_a_line(board, TTTGame::HUMAN_MARKER)
  end

  def offensive_move(board)
    one_empty_square_in_a_line(board, TTTGame::COMPUTER_MARKER)
  end

  def one_empty_square_in_a_line(board, marker)
    Board::WINNING_LINES.each do |line|
      if board.two_in_a_line?(line, marker)
        markers = board.markers_in_line(line)
        initial_marker = markers.find_index(Square::INITIAL_MARKER)
        return line[initial_marker] unless initial_marker.nil?
      end
    end

    nil
  end
end

class Human < Player
  def select_move(valid_squares_keys)
    puts "Please choose a square: (#{valid_squares_keys.join(', ')})"
    square_num = ""
    loop do
      square_num = gets.chomp.to_i
      break if valid_squares_keys.include?(square_num)

      puts "Sorry, that's not a valid choice."
    end
    square_num
  end
end

class TTTGame
  HUMAN_MARKER = "X"
  COMPUTER_MARKER = "O"
  FIRST_TO_MOVE = HUMAN_MARKER

  attr_reader :board, :human, :computer

  def play
    display_welcome_message
    loop do
      display_board
      loop do
        current_player_moves
        break if board.someone_won? || board.full?

        clear_screen_and_display_board if human_turn?
      end
      display_result
      break unless play_again?

      reset
      display_play_again_message
    end
    display_goodbye_message
  end

  private

  def initialize
    @board = Board.new
    @human = Human.new(HUMAN_MARKER)
    @computer = Computer.new(COMPUTER_MARKER)
    @current_marker = FIRST_TO_MOVE
  end

  def clear
    system "clear"
  end

  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
    puts ""
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def display_board
    puts "You're a #{human.marker}. Computer is a #{computer.marker}."
    puts ""
    board.draw
    puts ""
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def current_player_moves
    valid_choices_keys = board.unmarked_keys
    if human_turn?
      square_num = human.select_move(valid_choices_keys)
      board[square_num] = human.marker
      @current_marker = COMPUTER_MARKER
    else
      square_num = computer.select_move(board)
      board[square_num] = computer.marker
      @current_marker = HUMAN_MARKER
    end
  end

  def human_turn?
    @current_marker == HUMAN_MARKER
  end

  def display_result
    display_board

    case board.winning_marker
    when human.marker
      puts "You won!"
    when computer.marker
      puts "The computer won!"
    else
      puts "It's a tie!"
    end
  end

  def play_again?
    answer = ""
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %(y n).include? answer

      puts "Sorry, please answer either 'y' or 'n'."
    end
    answer == 'y'
  end

  def reset
    board.reset
    @current_marker = FIRST_TO_MOVE
    clear
  end

  def display_play_again_message
    puts "Let's play again!"
    puts ""
  end
end

game = TTTGame.new
game.play
