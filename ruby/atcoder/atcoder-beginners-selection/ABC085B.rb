# get input and put them into the array
# remove the repeated elements
# count the number of element in array
number = gets.chomp.to_i
arr = []
number.times do
	arr.push(gets.chomp.to_i)
end
arr.uniq!
puts arr.count