require 'pry'

def greatestProduct(number)
  digits = number.split("").map(&:to_i)
  products = []
  last_combo = number.length - 5

  digits.each_with_index do |digit, idx|
    next if idx > last_combo
    binding.pry
    products << digits[idx...idx+5].reduce(&:*)
  end

  products.max
end

puts greatestProduct("123834539327238239583") #3240