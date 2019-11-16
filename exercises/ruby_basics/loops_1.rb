################
# Runaway Loop #
################

# The code below is an example of an infinite loop. The name describes exactly what it does: loop infinitely. This loop isn't useful in a real program, though. Modify the code so the loop stops after the first iteration.

loop do
  puts 'Just keep printing...'
  break # Melinda edition.
end


###############
# Loopception #
###############

# The code below is an example of a nested loop. Both loops currently loop infinitely. Modify the code so each loop stops after the first iteration.

loop do
  puts 'This is the outer loop.'

  loop do
    puts 'This is the inner loop.'
    break # Melinda edition
  end

  break # Melinda edition
end

puts 'This is outside all loops.'


####################
# Control the Loop #
####################
