require 'pry'

####################
# Longest Sentence #
####################

# Input: a text file
# Output: print the longest sentence in the file based on number of words, and the number of words in sentence
# Sentences end with '.', '!', or '?'
# Any characters that are not spaces or in %w( . ! ? ) of sentences are individual words

SENTENCE_END = %w(. ! ?)

def longest_sentence(file)
  file = File.open(file, "r")
end



######################
# Now I Know My ABCs #
######################

# We're given a collection of spelling blocks with two letter per block:
# B:O   X:K   D:Q   C:P   N:A
# G:T   R:E   F:S   J:W   H:U
# V:I   L:Y   Z:M

# This limits the words we can spell: we can only use each block once.

# Input: word-string
# Return: boolean indicating if we can use the blocks to spell word

BLOCKS = {'B' => 1, 'O' => 1,
          'X' => 2, 'K' => 2,
          'D' => 3, 'Q' => 3,
          'C' => 4, 'P' => 4,
          'N' => 5, 'A' => 5,
          'G' => 6, 'T' => 6,
          'R' => 7, 'E' => 7,
          'F' => 8, 'S' => 8,
          'J' => 9, 'W' => 9,
          'H' => 10, 'U' => 10,
          'V' => 11, 'I' => 11,
          'L' => 12, 'Y' => 12,
          'Z' => 13, 'M' => 13}

def block_word?(word)
  char_array = word.upcase.chars
  idx_array = []
  char_array.each do |char|
    idx_array << BLOCKS[char]
  end
  idx_array.uniq! ? false : true
end

block_word?('BATCH') == true
block_word?('BUTCH') == false
block_word?('jest') == true



###############################
# Lettercase Percentage Ratio #
###############################

# Input: a string
# Returns: has with 3 entries: (1) percent lowercase chars; (2) percent uppercase chars; (3) percent neither chars

UPPER_ORD = (65...90)
LOWER_ORD = (97...122)

def letter_percentages(string)
  percent_hash = {lowercase: 0,
                  uppercase: 0,
                  neither: 0}
  char_array = string.chars
  char_array.each do |char|
    ascii = char.ord
    if ascii >= 65 && ascii <= 90
      percent_hash[:uppercase] += 1
    elsif ascii >= 97 && ascii <= 122
      percent_hash[:lowercase] += 1
    else
      percent_hash[:neither] += 1
    end
  end
  total_length = string.size.to_f
  percent_hash.transform_values! { |value| (value * 100) / total_length }
end

letter_percentages('abCdef 123')
letter_percentages('AbCd +Ef')
letter_percentages('123')



#########################
# Matching Parentheses? #
#########################

# Input: string
# Return: boolean - if num open parenthesis == num close parenthesis

OPEN_ORD = 40
CLOSE_ORD = 41

def balanced?(str)
  counter = 0
  str.each_char do |char|
    counter += 1 if char == '('
    counter -= 1 if char == ')'
    break if counter < 0
  end
  counter.zero?
end

balanced?('What (is) this?') == true
balanced?('What is) this?') == false
balanced?('What (is this?') == false
balanced?('((What) (is this))?') == true
balanced?('((What)) (is this))?') == false
balanced?('Hey!') == true
balanced?(')Hey!(') == false
balanced?('What ((is))) up(') == false



##################
# Triangle Sides #
##################

# Input: length of 3 sides of a triangle
# Return: symbol :equilateral, :isosceles, :scalene, :invalid on the type of triangle

def triangle(len1, len2, len3)
  lengths = [len1, len2, len3].sort
  return :invalid unless valid_triangle?(lengths)
  return :equilateral if lengths.all?(lengths[0])
  return :scalene if lengths.uniq == lengths
  return :isosceles
end

def valid_triangle?(length_array)
  length_array[2] < (length_array[0] + length_array[1])
end

# triangle(3, 3, 1.5) == :isosceles
# triangle(3, 3, 3) == :equilateral
# triangle(3, 4, 5) == :scalene
# triangle(0, 3, 3) == :invalid
# triangle(3, 1, 1) == :invalid



##############
# Tri-Angles #
##############

# Input: 3 angles of a triangle
# Return: symbol :right, :acute, :obtuse, or :invalid

def tri_angle(ang1, ang2, ang3)
  angles = [ang1, ang2, ang3]
  return :invalid unless valid_angles?(angles)
  return :right if angles.include?(90)
  return :acute if angles.all? { |ang| ang < 90 }
  return :obtuse
end

def valid_angles?(angles)
  return false if angles.include?(0)
  return false if angles.reduce(&:+) != 180
  true
end

tri_angle(60, 70, 50) == :acute
tri_angle(30, 90, 60) == :right
tri_angle(120, 50, 10) == :obtuse
tri_angle(0, 90, 90) == :invalid
tri_angle(50, 50, 50) == :invalid


################
# Unlucky Days #
################

