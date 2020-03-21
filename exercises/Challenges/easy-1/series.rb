require 'pry'

class Series
  def initialize(sequence)
    @sequence = sequence
  end

  def slices(len)
    all_slices = []
    max_first_idx = @sequence.length - len
    max_first_idx.times do |idx|
      all_slices << @sequence[idx..idx+len]
    end
    all_slices
  end
end