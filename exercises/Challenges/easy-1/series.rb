require 'pry'

class Series
  attr_reader :sequence

  def initialize(sequence)
    @sequence = sequence
  end

  def slices(len)
    if len > sequence.length
      raise ArgumentError, "Slice length is longer than the sequence"
    end

    # One-line implementation not from Melinda
    # sequence.each_char.map(&:to_i).each_cons(len).to_a
    
    all_slices = []
    sequence_copy = sequence.clone

    sequence.length.times do |_|
      slice = return_first_slice(sequence_copy, len)
      unless slice.nil?
        slice = convert_to_int_array(slice)
        all_slices << slice
      end
      sequence_copy = sequence_copy[1..-1]
    end

    all_slices
  end

  private 

  def return_first_slice(str, len)
    len > str.length ? nil : str[0..len-1]
  end

  # Input: a string of integers
  # Output: an array where each element is one integer
  def convert_to_int_array(slice)
    slice.split("").map { |num| num.to_i }
  end
end


