input1 = gets.chomp.to_i
input2 = gets.chomp
input3 = gets.chomp
new_input2 = input2.split.map(&:to_i)
puts "#{input1+new_input2[0]+new_input2[1]} #{input3}"