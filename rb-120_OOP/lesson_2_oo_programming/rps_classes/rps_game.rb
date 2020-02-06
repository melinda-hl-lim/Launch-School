class RPSGame
  attr_accessor :message, :human, :computer, :game_limit, :score_limit

  def initialize
    system("clear")
    @message = Message.new
    message.display_welcome_message
    @human = Human.new(message)
    @computer = Computer.new(@human)
    set_game_limit
    set_score_limit if game_limit
  end

  def play
    loop do
      system("clear")
      human.choose(message)
      computer.choose
      message.display_choices(self)
      message.move_history(self)
      round_winner = determine_round_winner
      display_round_winner(round_winner, message)
      round_winner.update_score unless round_winner.nil?
      message.display_score(self)
      message.continue_game? if game_limit
      break if play_again
    end
    system("clear")
    display_final_results
    message.display_goodbye_message
  end

  private

  def set_game_limit
    message.prompt_set_game_limit
    response = ''
    loop do
      response = gets.chomp.strip
      break if ['y', 'n'].include? response
      message.invalid_choice
    end
    response == "y" ? @game_limit = true : @game_limit = false
  end

  def set_score_limit
    message.prompt_score_limit
    response = 3
    loop do
      response = gets.chomp
      break if response.empty? || response.to_i > 0
      message.invalid_score_limit
    end
    @score_limit = response.to_i
  end

  def determine_round_winner
    return nil if human.move == computer.move
    human.move > computer.move ? human : computer
  end

  def display_round_winner(winner, message)
    winner.nil? ? message.tie : message.winner(winner)
  end

  def score_limit_reached?
    if game_limit
      return (human.score == score_limit) || (computer.score == score_limit)
    end
    false
  end

  def play_again
    game_limit ? score_limit_reached? : !(message.play_again?)
  end

  def display_final_results
    if human.score == computer.score
      winner = nil
    elsif game_limit
      winner = human.score == score_limit ? human : computer
    else
      winner = human.score > computer.score ? human : computer
    end
    message.final_winner(winner)
    message.display_score(self)
  end
end
