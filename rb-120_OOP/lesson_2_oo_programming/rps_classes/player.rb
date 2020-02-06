class Player
  attr_accessor :name, :move, :score, :move_history

  def initialize
    @score = 0
    @move_history = []
  end

  def update_score
    self.score += 1
  end
end
