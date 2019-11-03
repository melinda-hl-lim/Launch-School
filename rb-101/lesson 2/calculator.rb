################
#  Pseudocode  #
################
# Ask the user for two numbers
# Ask the user for an operation to perform
# Perform the operation on the two numbers
# Output the result

def prompt(message)
  Kernel.puts("=> #{message}")
end

def valid_number?(num)
  num.to_i() != 0
end

def operation_to_message(op)
  case op
    when "1"
      'adding'
    when "2"
      'subtracting'
    when "3"
      'multiplying'
    when "4"
      'dividing'
  end
end


################
# MINI CALC    #
################

prompt("Welcome to the Calculator! Please enter your name.")

name = ''
loop do
  name = gets().chomp()
  if name.empty?()
    prompt('Please enter a valid name!')
  else
    break
  end
end

prompt("Hi, #{name}!")

loop do #main loop
  num1 = ''
  num2 = ''

  loop do
    prompt("Please enter the first number")
    num1 = gets().chomp().to_f

    if valid_number?(num1)
      break
    else
      prompt("That doesn't look like a valid number...")
    end
  end

  loop do
    prompt("Please enter the second number")
    num2 = gets().chomp().to_f

    if valid_number?(num2)
      break
    else
      prompt("That doesn't look like a valid number...")
    end
  end

  op_prompt = <<-MSG
    Please enter an operation to perform:
    (1) Add
    (2) Subtract
    (3) Multiply
    (4) Divide
  MSG

  prompt(op_prompt)
  op = ''
  loop do
    op = gets().chomp()
    if %w(1 2 3 4).include?(op)
      break
    else
      prompt("Please enter a valid operator: options 1, 2, 3, or 4.")
    end
  end

  result = case op
            when "1"
              result = num1 + num2
            when "2"
              result = num1 - num2
            when "3"
              result = num1 * num2
            when "4"
              result = num1 / num2
            end

  prompt("Now #{operation_to_message(op)} numbers #{num1.to_s} and #{num2.to_s}")

  prompt("Your result is: " + result.to_s)
  prompt("Do you want to perform another calculation?: y for yes; n for no")
  answer = gets().chomp()
  break unless answer.downcase().start_with?('y')
end

prompt("Thanks for using my calculator ^u^")



#########################
# Things to think about:#
#########################

# (1) Is there a better way to validate that the user has input a number? We'll cover this in more detail in a future assignment.
# We could use regex to check if the user input characters fall within the range of numerical string characters.


# (2) It looks like you can call to_i or to_f to convert strings to integers and floats, respectively. Look up the String#to_i and String#to_f documentation in Ruby docs and look at their various examples and use cases.


# (3) Our operation_to_message method is a little dangerous, because we're relying on the case statement being the last expression in the method. What if we needed to add some code after the case statement within the method? What changes would be needed to keep the method working with the rest of the program? We'll show a solution in an upcoming assignment.
# If the case statement is NOT the last expression in this method, then we would need to either:
# (a) add return statements within the case statement (if we want to just end with the case statement in some circumstances)
# (b) assign the values of each operator integer to a variable and return that variable at the very end of the method


# (4) Most Rubyists don't invoke methods with parentheses, unless they're passing in an argument. For example, we use name.empty?(), but most Rubyists would write name.empty?. Some Rubyists even go as far as not putting parentheses around method calls even when passing in arguments. For example, they would write prompt "hi there" as opposed to prompt("hi there").

# Try removing some of the optional parentheses when calling methods to get your eyes acquainted with reading different styles of Ruby code. This will be especially useful if you are using a DSL written in Ruby, like Rspec or Rails.


# (5) We're using Kernel.puts() and Kernel.gets(). But the Kernel. is extraneous as well as the parentheses. Therefore, we can just call those methods by gets and puts. We already know that in Ruby we can omit the parentheses, but how come we can also omit the Kernel.?
# We can omit the Kernel input class because the objects that we are handling (integers, floats, strings) are "children" (derived classes? descendent classes?) of the Kernel class, and therefore have access to their parent class's methods.

# (6) There are lots of messages sprinkled throughout the program. Could we move them into some configuration file and access by key? This would allow us to manage the messages much easier, and we could even internationalize the messages. This is just a thought experiment, and no need to code this up.
# I don't think I understand this question... ._. Yeah, lessons have a lot of messages. If only I had a configuration file uploaded in my brain ^^;
