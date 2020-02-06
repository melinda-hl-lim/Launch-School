class Computer < Player
  attr_accessor :personality

  # TODO: I feel uncomfortable passing other_player around...
  # Is this okay to do? Is there an alternate solution?
  def initialize(other_player) # .-.
    super()
    select_name
    select_personality(other_player)
  end

  def choose
    self.move = personality.choose # TODO: Same question with `self.move`, `self.personality.choose`, and `self.move_history` as the question above
    move_history << move
  end

  private

  def select_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny'].sample
  end

  def select_personality(other_player)
    self.personality = Personality.new(Personality::TYPES.sample, other_player)
  end
end
