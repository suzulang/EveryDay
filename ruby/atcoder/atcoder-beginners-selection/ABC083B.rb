# Iterate through all numbers less than or equal to N
n, a, b = gets.chomp.split.map(&:to_i)
sum = 0
(1..n).each do |e|
	# The sum of the digits of e should be between [a, b]
	# Convert e to a string, then to a character array, then use map to convert each character to a number, and call the sum method on the array
	t = e.to_s.chars.map(&:to_i).sum
	sum += e if t.between?(a, b)
end
puts sum
