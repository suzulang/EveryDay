def leap_year?(y)
	return true if y % 4 == 0 && y % 100 != 0
	true if y % 400 == 0
end
y = gets.chomp.to_i
leap_year?(y)? puts('366'): puts('365')