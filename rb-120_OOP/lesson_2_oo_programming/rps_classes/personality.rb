class Personality
  attr_reader :type, :move_pool

  TYPES = ["random",
           "unyielding",
           "hustler",
           "sore_loser",
           "cheater"]

  def initialize(type, other_player)
    @type = type
    initialize_move_choices(@type, other_player)
  end

  # TODO: rubocop isn't happy with the complexity, ABCsize...
  # Is there another way to make unique choose methods for each
  # personality without having case statements?
  def choose
    case type
    when "random"
      move_pool.sample
    when "unyielding"
      move_pool[0]
    when "hustler"
      num = rand(0..99)
      num < 66 ? move_pool[0] : move_pool[1]
    when "sore_loser"
      # For the first move, select randomly
      if move_pool.length < 2
        mv = Move::VALUES.sample
        return Move.new(mv)
      end
      # For all other moves, use the human player's previous move choice
      move_pool[-2]
    else # It's a cheater personality
      # The cheater looks into the human's current choice
      # and create a move that beat human's choice
      mv = Move::WINNING_CHOICES[move_pool[-1].value].sample
      Move.new(mv)
    end
  end

  private

  attr_writer :move_pool

  def random_move
    mv = Move::VALUES.sample
    Move.new(mv)
  end

  def initialize_move_choices(type, other_player) # .-.
    case type
    when "random"
      @move_pool = []
      Move::VALUES.each { |mv| @move_pool << Move.new(mv) }
    when "unyielding"
      @move_pool = [random_move]
    when "hustler"
      @move_pool = [random_move]
      opposite_moves = Move::WINNING_CHOICES[random_move.value]
      @move_pool << Move.new(opposite_moves[0])
    else # it's a sore loser or cheater
      @move_pool = other_player.move_history
    end
  end
end
