require 'pry'

class Board
  attr_reader :squares

  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                  [[1, 5, 9], [3, 5, 7]]              # diagonals
  MIDDLE_SQUARE = 5

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
  # rubocop:enable Metrics/AbcSize

  private

  def three_identical_markers?(line)
    markers_in_line = line.select(&:marked?).collect(&:marker)
    return false if markers_in_line.size != 3

    markers_in_line.min == markers_in_line.max
  end
end


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

    offense || defense || pick_middle_square(board) || valid_squares.sample
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

  def pick_middle_square(board)
    board.squares[Board::MIDDLE_SQUARE].marked? ? nil : Board::MIDDLE_SQUARE
  end
end

class Human < Player
  def select_move(valid_squares)
    puts "Please choose a square: (#{valid_squares.join(', ')})"
    square_num = ""
    loop do
      square_num = gets.chomp.to_i
      break if valid_squares.include?(square_num)

      puts "Sorry, that's not a valid choice."
    end
    square_num
  end
end

class TTTGame
  HUMAN_MARKER = "X"
  COMPUTER_MARKER = "O"
  FIRST_TO_MOVE = HUMAN_MARKER

  attr_reader :board, :human, :computer, :round, :game_limit

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
      break unless next_round?

      reset
      display_play_again_message
    end
    display_goodbye_message
  end

  private

  attr_writer :round

  def initialize
    # Set up game pieces
    @board = Board.new
    @human = Human.new(HUMAN_MARKER)
    # ^ Input name
    @computer = Computer.new(COMPUTER_MARKER)
    @current_marker = FIRST_TO_MOVE

    # Choose game settings
    @tournament = play_to_game_limit?
    @game_limit = set_game_limit if @tournament
    @round = 1
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
    valid_choices = board.unmarked_keys
    if human_turn?
      square_num = human.select_move(valid_choices)
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

  # TODO: This method is doing more than displaying the round's result.
  # Break it down some more.
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

    self.round += 1
  end

  def play_to_game_limit?
    puts "Would you like to play a tournament? \n
          The tournament winner is the first to win X rounds."
    answer = ""
    loop do
      answer = gets.chomp.downcase
      break if %(y n).include? answer

      puts "Sorry, please answer either 'y' or 'n'."
    end
    answer == 'y'
  end

  def set_game_limit
    puts "How many rounds would you like in this tournament?"
    answer = ""
    loop do
      answer = gets.chomp.to_i
      break if answer > 0

      puts "Please enter the NUMBER of rounds you'd like to play."
    end
    answer
  end

  def next_round?
    @tournament ? game_limit_reached? : play_again?
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

  def game_limit_reached?
    round == game_limit
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
