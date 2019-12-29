##################
# 1 Banner Class #
##################
# Given an incomplete class for constructing boxed banner, complete the class so that the test cases work as intended. You are free to add any methods or instance variables you need. However, do not make the implementation details public.

class Banner
  def initialize(message, length=message.length)
    @message = message
    @length = length # answer: bonus feature
  end

  def to_s
    [horizontal_rule, empty_line, message_line, empty_line, horizontal_rule].join("\n")
  end

  private

  def horizontal_rule
    create_edge("+-", "-") # answer
  end

  def empty_line
    create_edge("| ", " ") # answer
  end

  def message_line
    "| #{@message} |"
  end

  # def message_line -- answer: bonus feature
  #   "| " + @message.center(@length) + " |"
  # end

  def create_edge(end_piece, mid_piece) # answer
    edge = end_piece.clone
    @length.times { |_| edge << mid_piece }
    edge << end_piece.reverse
    edge
  end
end

# Test cases:
banner = Banner.new('To boldly go where no one has gone before.')
puts banner
# +--------------------------------------------+
# |                                            |
# | To boldly go where no one has gone before. |
# |                                            |
# +--------------------------------------------+

banner = Banner.new('')
puts banner
# +--+
# |  |
# |  |
# |  |
# +--+

# LS's answer:
#   def empty_line
#     "| #{' ' * (@message.size)} |"
#   end

#   def horizontal_rule
#     "+-#{'-' * (@message.size)}-+"
#   end


########################
# 2 What's the Output? #
########################
# Given the following code, what output does this code print? Fix the class so that there are no surprises waiting in store for the unsuspecting developer.

class Pet
  attr_reader :name

  def initialize(name)
    @name = name.to_s
  end

  def to_s
    @name.upcase!
    "My name is #{@name}."
  end
end

name = 'Fluffy'
fluffy = Pet.new(name)
puts fluffy.name # My name is FLUFFY."
puts fluffy  # "My name is My name is FLUFFY."
puts fluffy.name  # "My name is FLUFFY."
puts name # 'Fluffy'
