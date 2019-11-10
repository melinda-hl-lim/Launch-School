#####################
# Rotation (Part 1) #
#####################

# Write a method that rotates an array by moving the first element to the end of the array.
# The original array should not be modified.
# Do not use the method Array#rotate or Array#rotate! for your implementation.

# PSEUDOCODE
# Input: array
# Output: array (new object) with first element of input array as last element

def rotate_array(array)
  return array if array.empty?
  new_array = array[1..-1] + [array[0]]
end

# Test cases
rotate_array([7, 3, 5, 2, 9, 1]) == [3, 5, 2, 9, 1, 7]
rotate_array(['a', 'b', 'c']) == ['b', 'c', 'a']
rotate_array(['a']) == ['a']

x = [1, 2, 3, 4]
rotate_array(x) == [2, 3, 4, 1]   # => true
x == [1, 2, 3, 4]
rotate_array([])


#####################
# Rotation (Part 2) #
#####################

# Write a method that can rotate the last n digits of a number.
# Note that rotating just 1 digit results in the original number being returned.
# You may use the rotate_array method from the previous exercise if you want. (Recommended!)
# You may assume that n is always a positive integer.

# Clarification questions:
# - Is the return integer a new object or the original object?

# PSEUDOCODE
# Input: an integer and position of digit to rotate from right
# Output: modified integer

# Check: if n == 1, return original input integer
# Convert integer to string to array of string-integers
# Rearrange array based on n input:
  # new_array = array[0...n] + rotate_array(arr[n..-1])
# Then convert array into string into integer

def rotate_rightmost_digits(int, n)
  return int if n == 1
  int_array = int.to_s.split("")
  rotated_int_array = (int_array[0...-n] + rotate_array(int_array[-n..-1]))
  rotated_int_array.join.to_i
end

# Launch School Solution:
# def rotate_rightmost_digits(number, n)
#   all_digits = number.to_s.chars
#   all_digits[-n..-1] = rotate_array(all_digits[-n..-1])
#   all_digits.join.to_i
# end

# Test cases
rotate_rightmost_digits(735291, 1) == 735291
rotate_rightmost_digits(735291, 2) == 735219
rotate_rightmost_digits(735291, 3) == 735912
rotate_rightmost_digits(735291, 4) == 732915
rotate_rightmost_digits(735291, 5) == 752913
rotate_rightmost_digits(735291, 6) == 352917

#####################
# Rotation (Part 3) #
#####################

# If you take a number like 735291, and rotate it to the left, you get 352917.
# If you now keep the first digit fixed in place, and rotate the remaining digits, you get 329175.
# Keep the first 2 digits fixed in place and rotate again to 321759.
# Keep the first 3 digits fixed in place and rotate again to get 321597.
# Finally, keep the first 4 digits fixed in place and rotate the final 2 digits to get 321579.
# The resulting number is called the maximum rotation of the original number.

# Write a method that takes an integer as argument, and returns the maximum rotation of that argument. You can (and probably should) use the rotate_rightmost_digits method from the previous exercise.

# Note that you do not have to handle multiple 0s.

# Clarification Questions:
# - What are the different ways of handling 0?
#   - leading 0 is dropped
#   - middle 0s are kept
#.  - end 0...?
# - Are we mutating the original argument object or returning a new object?
# - What the hell is that underscore character? Do we treat it as an integer or as obstacles to move integers around?

# PSEUDOCODE
# convert integer input into string into array of characters
# initialize new integer array for modification (rotated_array)
# initialize counter
# while counter < length of integer
#   call rotate_array on each index (tracked by counter)
#     rotated_segment = rotate_array(integer_array[counter..-1])
#   rotated_array[counter..-1] = rotated_segment
#   counter++
# convert rotated_array back to str and then to int
# return

def max_rotation(int)
  int_arr = int.to_s.chars
  counter = 0
  while counter < int_arr.length
    rotated_segment = rotate_array(int_arr[counter..-1])
    int_arr[counter..-1] = rotated_segment
    counter += 1
  end
  int_arr.join.to_i
end

# Launch School Solution
# def max_rotation(number)
#   number_digits = number.to_s.size
#   number_digits.downto(2) do |n|
#     number = rotate_rightmost_digits(number, n)
#   end
#   number
# end

# Test cases
p max_rotation(735291) == 321579
p max_rotation(3) == 3
p max_rotation(35) == 53
p max_rotation(105) == 15 # the leading zero gets dropped
p max_rotation(8_703_529_146) == 7_321_609_845

# Further Exploration

# Assume you do not have the rotate_rightmost_digits or rotate_array methods. How would you approach this problem? Would your solution look different? Does this 3 part approach make the problem easier to understand or harder?

# There is an edge case in our problem when the number passed in as the argument has multiple consecutive zeros. Can you create a solution that preserves zeros?
