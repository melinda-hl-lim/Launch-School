################
#  Pseudocode  #
################
# Ask the user for two numbers
# Ask the user for an operation to perform
# Perform the operation on the two numbers
# Output the result


################
# MINI CALC #1 #
################

# puts("Welcome to the Calculator!")

# puts("Please enter the first number")
# num1 = gets().chomp().to_f

# puts("Please enter the second number")
# num2 = gets().chomp().to_f

# puts("Please enter an operation to perform")
# op = gets().chomp()

# result = num1.method(op).(num2) # I found this method() method online!  
# puts("Your result is: " + result.to_s)


################
# MINI CALC #2 #
################

puts("Welcome to the Calculator!")

puts("Please enter the first number")
num1 = gets().chomp().to_f

puts("Please enter the second number")
num2 = gets().chomp().to_f

puts("What operation would you like to perform? (1) Add (2) Subtract (3) Multiply (4) Divide ")
op = gets().chomp()

case op
when "1"
  result = num1 + num2
when "2"
  result = num1 - num2
when "3"
  result = num1 * num2
when "4"
  result = num1 / num2
end

puts("Your result is: " + result.to_s)

