n, m = gets.chomp.split.map(&:to_i)
arr = gets.chomp.split.map(&:to_i)
x = 0
loop do
	sum = arr.map { |i| [x, i].min }.sum
	break if sum > m
	x += 1
end
puts x - 1