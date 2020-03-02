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
    update_score(card)
  end 

  def display_hand
    puts "Here's #{name}'s hand so far..."
    line_break
    puts "TOTAL SCORE: #{score}"
    puts "NUMBER CARDS IN HAND: #{hand.length}"
    puts "CARDS IN HAND: "
    @hand.each { |card| card.display }
    line_break
  end 

  def update_score(card)
    if card.value.to_i == 0
      @score += send(card.value)
    else 
      @score += card.value.to_i 
    end 
  end 

  def A
    @score + 11 > 21 ? 1 : 11
  end 

  def score_of_ten
    10
  end 
  
  alias_method "K", "score_of_ten"
  alias_method "Q", "score_of_ten"
  alias_method "J", "score_of_ten"

  def busted?
    score > 21
  end 

  def seventeen?
    score == 17
  end
end

class Dealer < Participant
  NAMES = %w(Bryce Edward Tommy).freeze

  def initialize
    super(NAMES.sample)
  end

  def choose_move
    if score >= 17 # TODO: self.seventeen? 
      "stay"
    else 
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

  ['player', 'dealer'].each do |participant|
    define_method("#{participant}_turn") do |current_player|
      puts "Now it's #{current_player}'s turn to shine~"
      pause
      loop do 
        choice = current_player.choose_move 
        if choice == "stay" 
          break 
        else
          draw_card(current_player)
          display_updated_hand(current_player)
        end 
        if game_over?
          puts "Oh no! #{current_player} busted!"
          return :busted
        end 
      end 
    end 
  end 

  # Dealer class; computer object
  # Player class; human object

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
    elsif human.score >= computer.score
      human
    else 
      computer  
    end 
  end 

  def display_winner(winner)
    puts "And the winner of this Black Jack game is..."
    puts "#{winner}!"
  end 
end

game = TwentyOneGame.new
game.play