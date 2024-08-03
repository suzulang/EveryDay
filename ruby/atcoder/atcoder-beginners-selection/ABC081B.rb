number = gets.chomp.to_i
arr = gets.chomp.split.map(&:to_i)
count = 0

while arr.all? { |e| e.even? } do
	arr.map! { |e| e / 2 }
	count += 1
end

puts count
