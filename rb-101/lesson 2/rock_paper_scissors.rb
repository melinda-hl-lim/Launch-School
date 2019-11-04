require 'pry'

VALID_CHOICES = %w(rock paper scissors)

def prompt(message)
  Kernel.puts("=> #{message}")
end

def win?(first, second)
  return true if (first == 'rock' && second == 'scissors') ||
    (first == 'paper' && second == 'rock') ||
    (first == 'scissors' && second == 'paper')
end

def display_results(player_choice, computer_choice)
  if win?(player_choice, computer_choice)
    prompt("You won! :D")
  elsif (player_choice == computer_choice)
    prompt("It's a tie! :o")
  else
    prompt("The computer won! D:")
  end
end


###############
# GAME SCRIPT #
###############

prompt("Welcome to #{VALID_CHOICES}!")
loop do

  choice = ''
  loop do
    prompt("Choose one: #{VALID_CHOICES.join(', ')}")
    choice = Kernel.gets().chomp().downcase()

    VALID_CHOICES.include?(choice) ? break : prompt("That's not a valid choice.")
  end

  computer_choice = VALID_CHOICES.sample()

  prompt("You chose #{choice}. The computer chose #{computer_choice}.")
  display_results(choice, computer_choice)

  prompt("Do you want to play again? y/n")
  answer = Kernel.gets().chomp()
  break unless answer.downcase().start_with?('y')

end
prompt("Thank you for playing! Bye ^u^")
