class Human < Player
  def initialize(message)
    super()
    get_name(message)
  end

  def choose(message)
    self.move = Move.new(valid_human_choice(message)) # TODO: Why is `self` required for `self.move` for RPS to work ...
    move_history << move # but `self` is not required for `move_history` or `move` down here?
  end

  private

  def get_name(message)
    response = ""
    loop do
      message.prompt_name
      response = gets.chomp.strip
      break unless response.empty?
      message.invalid_name
    end
    self.name = response.capitalize
  end

  def valid_human_choice(message)
    choice = nil
    loop do
      message.prompt_human_choice
      choice = gets.chomp
      break if Move::VALUES.include? choice
      message.invalid_choice
    end
    choice
  end
end
