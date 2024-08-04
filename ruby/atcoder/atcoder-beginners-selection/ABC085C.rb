def result_three(a, b)
	(0..a).each do |i|
		(0..a-i).each do |j|
			t = a-i-j
			return [t, j, i] if 10000*t + 5000*j + 1000*i == b
		end
	end
	[-1, -1, -1]
end
a, b = gets.chomp.split.map(&:to_i)
rs= result_three(a,b)
puts "#{rs[0]} #{rs[1]} #{rs[2]}"
