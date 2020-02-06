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
