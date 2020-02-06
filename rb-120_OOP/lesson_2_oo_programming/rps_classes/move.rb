class Move # Move object is a collaborator of human and computer classes
  attr_reader :value

  WINNING_CHOICES = { 'rock' => ['scissors', 'lizard'],
                      'paper' => ['rock', 'spock'],
                      'scissors' => ['paper', 'lizard'],
                      'lizard' => ['paper', 'spock'],
                      'spock' => ['rock', 'scissors'] }.freeze
  VALUES = WINNING_CHOICES.keys

  def initialize(value)
    @value = value
  end

  def to_s
    value
  end

  def >(other_move)
    WINNING_CHOICES[value].include?(other_move.value)
  end

  def ==(other_move)
    value == other_move.value
  end
end
