require 'pry'

CARD_VALUES = %w(2 3 4 5 6 7 8 9 10 Jack Queen King Ace).freeze
VALID_INPUTS = %w(hit stay h s).freeze
WINNING_NUMBER = 21
DEALER_STAY = 17

# Helper methods

def prompt(msg)
  puts "=> #{msg}"
end

def clear
  system('clear')
end

def initialize_deck
  deck = []
  CARD_VALUES.cycle(4) { |val| deck << val }
  deck.shuffle!
end

def valid_option
  human_input = ''
  prompt("Would you like to hit or stay?")
  loop do
    human_input = gets.chomp.downcase
    break if VALID_INPUTS.include?(human_input)
    prompt("I'm sorry, that's not a valid input. Please choose one: hit, stay.")
  end
  human_input
end

def computer_hit_or_stay
  VALID_INPUTS[rand(0..1)]
end

def sort_cards(cards)
  sorted_cards = []
  aces = []
  cards.each do |card|
    card == "Ace" ? aces << card : sorted_cards << card
  end
  sorted_cards += aces
end

def royal
  10
end

def ace(total)
  (total + 11) > WINNING_NUMBER ? 1 : 11
end

def check_card_value(card, total)
  return ace(total) if card == "Ace"
  return royal if card.to_i == 0
  card.to_i
end

def sum_cards(cards)
  cards = sort_cards(cards)
  total = 0
  cards.each { |card| total += check_card_value(card, total) }
  total
end

def bust?(cards)
  total = sum_cards(cards)
  total > WINNING_NUMBER
end

def display_cards(player_cards, dealer_cards, situation)
  player_msg = "You have: #{player_cards.join(' ')}"
  player_msg += "with a total of #{sum_cards(player_cards)}."
  prompt(player_msg)
  case situation
  when "playing round"
    dealer_cards = dealer_cards[0...-1]
    msg = "Dealer has: #{dealer_cards.join(' ')} and an unknown card"
    msg += " with a visible total of #{sum_cards(dealer_cards)}."
    prompt(msg)
  when "someone lost"
    msg = "Dealer has: #{dealer_cards.join(' ')}"
    msg += "with a total of #{sum_cards(dealer_cards)}."
    prompt(msg)
  end
end

def who_won(player_total, dealer_total)
  return "no one! ... It's a tie... " if player_total == dealer_total
  if player_total <= WINNING_NUMBER && dealer_total <= WINNING_NUMBER
    player_total > dealer_total ? "you, the human!" : "the computer!"
  elsif player_total > WINNING_NUMBER
    "the computer!"
  else # dealer_total > WINNING_NUMBER
    "you, the human!"
  end
end

# Game sub rounds

def initialize_game
  clear
  deck = initialize_deck
  human_cards = deck.shift(2)
  computer_cards = deck.shift(2)
  return deck, human_cards, computer_cards
end

def player_round(human_cards, computer_cards, deck)
  loop do
    sleep(3)
    clear
    display_cards(human_cards, computer_cards, "playing round")
    human_choice = valid_option
    break if human_choice == 'stay' || human_choice == 's'
    human_cards << deck.shift
    break if bust?(human_cards)
  end
end

def computer_round(human_cards, computer_cards, deck)
  loop do
    sleep(3)
    clear
    display_cards(human_cards, computer_cards, "playing round")
    computer_choice = computer_hit_or_stay
    prompt("The computer chose to #{computer_choice}.")
    break if computer_choice == 'stay'
    computer_cards << deck.shift
    break if sum_cards(computer_cards) >= DEALER_STAY || bust?(computer_cards)
  end
end

def player_bust?(human_cards, computer_cards)
  sleep(3)
  clear
  if bust?(human_cards)
    prompt("You've busted!")
    display_final_results(human_cards, computer_cards)
    return true
  end

  false
end

def dealer_bust?(player_cards, dealer_cards)
  sleep(3)
  clear
  if bust?(dealer_cards)
    prompt("The computer busted!")
    display_final_results(player_cards, dealer_cards)
    return true
  end

  false
end

def display_final_results(player_cards, dealer_cards)
  player_total = sum_cards(player_cards)
  dealer_total = sum_cards(dealer_cards)
  prompt("The winner is #{who_won(player_total, dealer_total)}")
  display_cards(player_cards, dealer_cards, "someone lost")
end

# Main Game Loop

loop do
  deck, human_cards, computer_cards = initialize_game

  player_round(human_cards, computer_cards, deck)

  break if player_bust?(human_cards, computer_cards)

  computer_round(human_cards, computer_cards, deck)

  break if dealer_bust?(human_cards, computer_cards)

  display_final_results(human_cards, computer_cards)
  break
end
