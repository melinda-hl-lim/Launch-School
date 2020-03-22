require 'pry'

class Sieve
  attr_reader :min, :max

  def initialize(max)
    @min = 2
    @max = max
  end

  # returns an array of all prime numbers from 2 to max
  def primes
    range = (min..max).to_a
    primes = (min..max).to_a

    range.each do |mod|
      primes.delete_if do |num| 
        composite?(num, mod) unless num == mod
      end
      range = primes
    end
    primes
  end

  private

  def composite?(num, mod)
    num % mod == 0
  end
end

