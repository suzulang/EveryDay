row, col = gets.chomp.split.map(&:to_i)
arr = []
res_arr = Array.new(row) { Array.new(col,0) }
row.times do
	line = gets.chomp.split.map(&:to_i)
	arr << line
end
arr.each_with_index do |row_arr,row_index| #row = [1, 2] row_index = 0
	row.each_with_index do |e, col_index| #e = 1, col_index = 0
		transposed_arr = arr.transpose
		col_sum = transposed_arr[col_index].sum
		row_sum = row.sum
		insert_e = col_sum + row_sum - e
		res_arr[row_index][col_index] = insert_e
	end
end
res_arr.each do |row_arr|
	puts row.join(' ')
end