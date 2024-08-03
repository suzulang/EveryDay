# iterate through values from 0 to a, then 0 to b, then 0 to c
# set i, j, k in nested loops
# if 500*i + 100*j + 50*k equals the target, increase count by 1
a = gets.chomp.to_i
b = gets.chomp.to_i
c = gets.chomp.to_i
count = 0
target = gets.chomp.to_i
(0..a).each do |i|
	(0..b).each do |j|
		(0..c).each do |k|
			count += 1 if 500*i + 100*j + 50*k == target
		end
	end
end
puts count