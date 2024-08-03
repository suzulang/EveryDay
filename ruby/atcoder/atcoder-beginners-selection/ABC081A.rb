line = gets.chomp.split("").map(&:to_i)
output = line.count { |e| e==1 }
puts output