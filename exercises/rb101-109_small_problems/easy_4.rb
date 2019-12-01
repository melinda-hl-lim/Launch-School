# Short Long Short

# input: two strings
# output: 1 string

#1. determine longer string
#2. add strings as: short + long + short

def short_long_short(str1, str2)
  return (str1 + str2 + str1) if (str1.length <= str2.length)
  str2 + str1 + str2
end

puts short_long_short('abc', 'defgh') == "abcdefghabc"
puts short_long_short('abcde', 'fgh') == "fghabcdefgh"
puts short_long_short('', 'xyz') == "xyz"

# Andrew and LS feedback: writing the two lines as an `if ... else` statement would be easier to read

# What Century Is That?


