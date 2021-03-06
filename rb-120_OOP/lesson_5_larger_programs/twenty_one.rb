require 'pry'

module Displayable
  def line_break
    puts ""
  end

  def pause(time=1.5)
    sleep(time)
  end

  def clear
    system "clear"
  end
end

class Participant
  include Displayable

  attr_accessor :name, :hand, :score

  def initialize(name="Player 1")
    @name = name
    @hand = [] # cards in hand
    @score = 0
  end

  def to_s
    name
  end

  def add_card_to_hand(card)
    hand << card
    update_score
  end

  def display_hand
    puts "Here's #{name}'s hand so far..."
    line_break
    puts "TOTAL SCORE: #{score}"
    puts "NUMBER CARDS IN HAND: #{hand.length}"
    puts "CARDS IN HAND: "
    hand.each(&:display)
    line_break
  end

  def update_score
    self.score = 0
    order_cards_in_hand
    calculate_total_score
  end

  def order_cards_in_hand
    not_aces = hand.filter { |card| card.value != "A" }
    aces = hand.filter { |card| card.value == "A" }
    self.hand = not_aces + aces
  end

  def calculate_total_score
    hand.each do |card|
      card_value = card.value.to_i
      self.score += card_value == 0 ? send(card.value.downcase) : card_value
    end
  end

  def a
    score + 11 > 21 ? 1 : 11
  end

  def score_of_ten
    10
  end

  alias_method "k", "score_of_ten"
  alias_method "q", "score_of_ten"
  alias_method "j", "score_of_ten"

  def busted?
    score > 21
  end
end

class Dealer < Participant
  NAMES = %w(Bryce Edward Tommy).freeze
  DEALER_LIMIT = 17

  def initialize
    super(NAMES.sample)
  end

  def choose_move
    if score > DEALER_LIMIT
      puts "#{name} chose to stay"
      pause(3)
      "stay"
    else
      puts "#{name} chose to hit!"
      pause(3)
      "hit"
    end
  end
end

class Player < Participant
  def choose_move
    puts "Would you like to hit or stay?"
    answer = ""
    loop do
      answer = gets.chomp.downcase
      break if %w(hit stay).include?(answer)

      puts "I'm sorry, that's not a valid response."
    end
    answer
  end
end

class Deck
  SUITS = %w(Clubs Diamonds Hearts Spades).freeze
  VALUES = %w(2 3 4 5 6 7 8 9 10 J Q K A).freeze

  attr_reader :cards

  def initialize
    reset_and_shuffle
  end

  private

  def reset_and_shuffle
    @cards = []
    VALUES.each do |value|
      SUITS.each do |suit|
        @cards << Card.new(suit, value)
      end
    end
    @cards.shuffle
  end
end

class Card
  include Displayable

  attr_reader :value

  def initialize(suit, value)
    @suit = suit
    @value = value
    @drawn = false
  end

  def draw
    @drawn = true
  end

  def display
    puts "    #{@value} of #{@suit}"
  end
end

class TwentyOneGame
  include Displayable

  attr_reader :human, :computer, :deck

  def initialize
    @human = Player.new
    @computer = Dealer.new
    @deck = Deck.new
  end

  def play
    welcome_sequence
    deal_cards
    display_initial_cards
    human_result = player_turn(human)
    computer_result = dealer_turn(computer) unless human_result == :busted
    show_result(human_result, computer_result)
  end

  private

  def welcome_sequence
    display_welcome_message
    set_player_name
    display_dealer_introduction
  end

  def display_welcome_message
    line_break
    puts "Welcome to Black Jack - Command Line Edition"
    line_break
  end

  def set_player_name
    puts "Before we begin, may I get your name?"
    name = ""
    loop do
      name = gets.chomp.capitalize
      break unless name.empty?
    end
    human.name = name
  end

  def display_dealer_introduction
    puts "Your dealer today is #{computer}, the computer."
    puts "Now let's get started!"
    line_break
    pause
    clear
  end

  def deal_cards
    display_dealing_cards_message
    2.times { draw_card(human) }
    2.times { draw_card(computer) }
  end

  def display_dealing_cards_message
    puts "#{computer} is dealing the cards..."
    line_break
    pause
  end

  def display_initial_cards
    human.display_hand
    computer.display_hand
  end

  def display_current_player(player)
    line_break
    puts "Now it's #{player}'s turn to shine~"
    line_break
  end

  ['player', 'dealer'].each do |participant|
    define_method("#{participant}_turn") do |current_player|
      display_current_player(current_player)
      pause
      loop do
        choice = current_player.choose_move
        break if choice == "stay"

        draw_card(current_player)
        display_updated_hand(current_player)

        if game_over?
          puts "Oh no! #{current_player} busted!"
          line_break
          return :busted
        end
      end
    end
  end

  def game_over?
    human.busted? || computer.busted?
  end

  def draw_card(holder)
    drawn_card = deck.cards.sample
    # Create correct associations for drawn card
    holder.add_card_to_hand(drawn_card)
    drawn_card.draw
    # Remove card from deck
    deck.cards.reject! { |card| card == drawn_card }
  end

  def display_updated_hand(player)
    clear
    last_card_drawn = player.hand.last
    puts "#{player} drew: "
    last_card_drawn.display
    player.display_hand
  end

  def show_result(human_result, computer_result)
    winner = determine_winner(human_result, computer_result)
    display_winner(winner)
  end

  def determine_winner(human_result, computer_result)
    if human_result == :busted
      computer
    elsif computer_result == :busted
      human
    elsif human.score > computer.score
      human
    elsif computer.score > human.score
      computer
    end
  end

  def display_winner(winner)
    line_break
    puts "And the winner of this Black Jack game is..."
    puts "#{winner.nil? ? 'No one! It\'s a tie!' : winner}!"
  end
end

game = TwentyOneGame.new
game.play
