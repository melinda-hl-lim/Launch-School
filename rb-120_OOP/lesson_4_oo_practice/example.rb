class Cube
  attr_reader :volume

  def initialize(volume)
    @volume = volume
  end
end

box = Cube.new(10)
puts box
