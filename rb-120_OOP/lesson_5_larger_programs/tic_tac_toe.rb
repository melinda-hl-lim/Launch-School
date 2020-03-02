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

  def []=(num, marker)
    @squares[num].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |k, _| @squares[k].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def markers_in_line(line)
    squares.values_at(*line).collect(&:marker)
  end

  def two_in_a_line?(line, marker)
    markers = markers_in_line(line)
    markers.count(marker) == 2
  end

  def winning_marker
    WINNING_LINES.each do |line|
      next if empty_line?(line)
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
    puts "1      |2      |3      "
    puts "   #{@squares[1]}   |   #{@squares[2]}   |   #{@squares[3]}   "
    puts "       |       |"
    puts "-------+-------+-------"
    puts "4      |5      |6      "
    puts "   #{@squares[4]}   |   #{@squares[5]}   |   #{@squares[6]}   "
    puts "       |       |"
    puts "-------+-------+-------"
    puts "7      |8      |9      "
    puts "   #{@squares[7]}   |   #{@squares[8]}   |   #{@squares[9]}   "
    puts "       |       |"
  end
  # rubocop:enable Metrics/AbcSize

  private

  def empty_line?(line)
    markers_in_line(line).all?(Square::INITIAL_MARKER)
  end

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
  attr_reader :name, :marker
  attr_accessor :score

  def initialize(marker)
    @marker = marker
    @score = 0
  end
end

class Computer < Player
  NAMES = %w(R2D2 Wheatley Watson)

  def initialize(other_player_marker)
    @name = NAMES.sample
    marker = select_marker(other_player_marker)
    super(marker)
  end

  def select_move(board, other_player_marker)
    move = offensive_move(board, self.marker) #
    move ||= defensive_move(board, other_player_marker)
    move ||= pick_middle_square(board)
    move ||= board.unmarked_keys.sample
  end

  private

  def select_marker(other_player_marker)
    other_player_marker == 'X' ? 'O' : 'X'
  end

  # An attempt at meta programming after reading some cool articles
  ['defensive', 'offensive'].each do |method_name|
    define_method("#{method_name}_move") do |board, marker|
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

  def pick_middle_square(board)
    board.squares[Board::MIDDLE_SQUARE].marked? ? nil : Board::MIDDLE_SQUARE
  end
end

class Human < Player
  def initialize
    @name = enter_name
    marker = select_marker
    super(marker)
  end

  def select_move(board)
    valid_choices = board.unmarked_keys
    puts "Please choose a square: (#{valid_choices.join(', ')})"
    square = ""
    loop do
      square = gets.chomp.to_i
      break if valid_choices.include?(square)

      puts "Sorry, that's not a valid choice."
    end
    square
  end

  private

  def enter_name
    puts ""
    puts "What's your name?"
    name = ""
    loop do
      name = gets.chomp.capitalize
      break unless name.empty?

      puts "That's not a name, silly!"
    end
    name
  end

  def select_marker
    puts ""
    puts "Please choose your player marker: 'X' or 'O'."
    marker = ""
    loop do
      marker = gets.chomp.upcase
      break if %(X O).include? marker

      puts "Please choose either 'X' or 'O' for your marker."
    end
    marker
  end
end

class TTTGame
  SLEEP_TIMER = 3

  attr_reader :board, 
              :human, 
              :computer, 
              :round,
              :tournament, 
              :winning_score,
              :final_winner 


  def play
    loop do
      display_start_round_message
      display_board if human_turn?
      loop do
        current_player_moves
        break if someone_won? || board.full?

        clear_screen_and_display_board if human_turn?
      end
      round_results
      break unless next_round?

      reset
    end
    determine_final_winner
    display_final_results 
 
    display_goodbye_message
  end

  private

  attr_writer :round

  def initialize
    display_welcome_message
    setup_game_pieces
    setup_game_settings
    setup_game_information
    clear
  end

  def setup_game_pieces
    @board = Board.new
    @human = Human.new
    @computer = Computer.new(human.marker)
  end

  def setup_game_settings
    @tournament = play_to_winning_score?
    @winning_score = set_winning_score if @tournament
    @first_player = select_first_player
    first_player_declaration_message
  end

  def setup_game_information
    @current_marker = @first_player
    @round = 0
  end

  def clear
    system "clear"
  end

  def line_break
    puts ""
  end

  def display_welcome_message
    line_break
    puts "Welcome to Tic Tac Toe!"
  end

  def display_start_round_message
    puts "Round #{round} - FIGHT!"
  end

  def determine_final_winner
    if human.score > computer.score 
      @final_winner = human.name
    elsif computer.score > human.score 
      @final_winner = computer.name 
    else
      @final_winner = nil
    end  
  end 

  def display_final_results
    if @final_winner
      puts "After #{round} rounds, one has emerged victorious... "
      puts "The winner is: #{@final_winner}!"
    else
      puts "After #{round} rounds, you have both proven to be worthy Tic Tac Toe masters."
      puts "It's a tie!"
    end
    display_final_scores 
  end

  def display_final_scores
    puts "Final Scores"
    puts "#{human.name}: #{human.score}"
    puts "#{computer.name}: #{computer.score}"
  end 

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def display_board
    puts "You're a #{human.marker}. Computer is a #{computer.marker}."
    line_break
    board.draw
    line_break
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def current_player_moves
    if human_turn?
      square_num = human.select_move(board)
      board[square_num] = human.marker
      @current_marker = computer.marker
    else
      square_num = computer.select_move(board, human.marker)
      board[square_num] = computer.marker
      @current_marker = human.marker
    end
  end

  def human_turn?
    @current_marker == human.marker
  end

  def someone_won?
    board.winning_marker
  end

  def round_results
    winning_marker = board.winning_marker
    finalize_round_results(winning_marker)
    display_round_results(winning_marker)
    display_player_scores
    sleep(SLEEP_TIMER)
  end

  def finalize_round_results(winning_marker)
    case winning_marker
    when human.marker
      human.score += 1
    when computer.marker
      computer.score += 1
    end

    self.round += 1
  end

  def display_round_results(winning_marker)
    display_board

    case winning_marker
    when human.marker
      puts "You won this round!"
    when computer.marker
      puts "The computer, #{computer.name}, won this round!"
    else
      puts "This round is a tie!"
    end
  end

  def display_player_scores
    puts "The scores so far are..."
    puts "#{human.name}: #{human.score}"
    puts "#{computer.name}: #{computer.score}"
  end

  def play_to_winning_score?
    line_break
    puts "Would you like to play a tournament? ( y / n )"
    puts "The tournament winner is the first to win X rounds."
    answer = ""
    loop do
      answer = gets.chomp.downcase
      break if %(y n).include? answer

      puts "Sorry, please answer either 'y' or 'n'."
    end
    answer == 'y'
  end

  def set_winning_score
    line_break
    puts "What would you like the winning score to be in this tournament?"
    answer = ""
    loop do
      answer = gets.chomp.to_i
      break if answer > 0

      puts "Please enter the score (i.e. a NUMBER) you would like to play to."
    end
    answer
  end

  def select_first_player
    answer = first_player_message
    case answer
    when 'a'
      human.marker
    when 'b'
      computer.marker
    when 'c'
      (rand(0..1) == 0) ? human.marker : computer.marker
    end
  end

  def first_player_message
    line_break
    puts "Set the first player. Here are your options:"
    puts "(a) You, #{human.name}, go first."
    puts "(b) The computer, #{computer.name}, goes first."
    puts "(c) We flip a coin to determine the first player!"
    answer = ""
    loop do
      answer = gets.chomp.downcase
      break if %(a b c).include? answer

      puts "Please choose one of the options above: a, b, or c."
    end
    answer
  end

  def first_player_declaration_message
    puts "The first player is #{@first_player}."
  end

  def next_round?
    @tournament ? !(winning_score_reached?) : play_again?
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

  def winning_score_reached?
    human.score == winning_score || computer.score == winning_score
  end

  def reset
    board.reset
    @current_marker = @first_player
    clear
  end
end

game = TTTGame.new
game.play
