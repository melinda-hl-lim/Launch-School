# Octal

# Implement octal to decimal conversion. Given an octal input string, your program should produce a decimal output.

# Note: 
# Implement the conversion yourself. Do not use something else to perform the conversion for you. Treat invalid input as octal 0.

# About Octal (Base-8):
# Decimal is a base-10 system. A number 233 in base 10 notation can be understood as the linear combination of powers of 10:
# (10^2 * 2) + (10^1 * 3) + (10^0 * 3) = 233
# So in octal 233 means:
# (8^2 * 2) + (8^1 * 3) + (8^0 * 3) = 155 in decimal

###########

# Input: an octal number
# Output: the decimal equivalent

# Steps:
# Prepare for calculations
  # Create a string copy of the input number
  # With that string number, split each digit into an element of an array
  # Then reverse said array of digits
# Calculate 
  # Initialize an accumulator
  # Iterate through the array of digits
    # At each iteration, calculate 8^index * value
    # Add ^ result to accumulator
# Return accumulator

class Octal
  BASE = 8
  INVALID_OCTAL = /\D|[8-9]/

  attr_reader :octalString

  def initialize(value)
    @octalString = value
  end

  def to_decimal
    return 0 if @octalString =~ INVALID_OCTAL

    octalDigits = self.octalString.split("").reverse!
    octalDigits.map! { |digit| digit.to_decimal }
    decimalValue = 0

    octalDigits.each_with_index do |digit, index|
      decimalValue += BASE**index * digit
    end

    decimalValue
  end
end
