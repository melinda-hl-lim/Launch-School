require "pry"

INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'
WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                [[1, 5, 9], [3, 5, 7]]

def prompt(msg)
  puts "=> #{msg}"
end

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

# rubocop:disable Metrics/AbcSize
def display_board(board)
  puts "       |       |       "
  puts "   #{board[1]}   |   #{board[2]}   |   #{board[3]}   "
  puts "       |       |       "
  puts "-----------------------"
  puts "       |       |       "
  puts "   #{board[4]}   |   #{board[5]}   |   #{board[6]}   "
  puts "       |       |       "
  puts "-----------------------"
  puts "       |       |       "
  puts "   #{board[7]}   |   #{board[8]}   |   #{board[9]}   "
  puts "       |       |       "
end
# rubocop:enable Metrics/AbcSize

def empty_squares(board)
  board.keys.select { |num| board[num] == INITIAL_MARKER }
end

def player_turn!(board)
  square = ''
  loop do
    prompt("Choose an empty square: #{empty_squares(board).join(' ')}")
    square = gets.chomp.to_i
    break if empty_squares(board).include?(square)
    prompt "Sorry, that's not a valid choice"
  end
  board[square] = PLAYER_MARKER
end

def computer_turn(board)
  square = empty_squares(board).sample
  board[square] = COMPUTER_MARKER
end

def winner?(board)
  WINNING_LINES.each do |line|
    slots = [board[line[0]], board[line[1]], board[line[2]]]
    if slots.all?(PLAYER_MARKER) || slots.all?(COMPUTER_MARKER)
      return slots[0] == PLAYER_MARKER ? PLAYER_MARKER : COMPUTER_MARKER
    end
  end
  false
end

def full?(board)
  empty_squares(board).empty?
end

def replay?
  prompt("Would you like to play again? y/n")
  replay = ''
  loop do
    replay = gets.chomp
    break if %(y n).include?(replay)
    prompt("I'm sorry, that's not a valid response.")
  end
  replay == 'y'
end

# Main Game Loop

loop do
  board = initialize_board
  display_board(board)

  loop do
    player_turn!(board)
    break if winner?(board) || full?(board)
    computer_turn(board)
    break if winner?(board) || full?(board)
    display_board(board)
  end

  winner?(board) ? prompt("#{winner?(board)} won!") : prompt("It's a tie!")
  break unless replay?
end
