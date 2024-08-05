line1 = gets.chomp.to_i
arr = gets.chomp.split.map(&:to_i)
sorted_arr = arr.sort.reverse
second_max_e = sorted_arr[1]
puts arr.index(second_max_e) + 1