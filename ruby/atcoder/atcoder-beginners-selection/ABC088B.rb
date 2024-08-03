# Each player takes the optimal strategy
# 1. Alice picks first, takes the largest number from the array, and removes it from the array
# 2. Bob takes the largest number from the remaining array, and removes it
# 3. When all numbers are taken, calculate the difference between Alice's and Bob's scores
# Point: Control alternating picks
# flag being true means it's Alice's turn, after her turn it is set to false

number = gets.to_i
arr = gets.chomp.split.map(&:to_i)
alice_score, bob_score = 0, 0
flag = true

while arr.any?
	if flag
		alice_score += arr.max
		arr.delete_at(arr.index(arr.max))
		flag = false
	else
		bob_score += arr.max
		arr.delete_at(arr.index(arr.max))
		flag = true
	end
end

puts alice_score - bob_score
