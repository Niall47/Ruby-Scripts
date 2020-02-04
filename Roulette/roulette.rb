count = 0.to_f
purse = 1000.to_f
bet = 1.to_f
wins = 0

while purse < 2000 or bet >= purse do 
	roll = rand(0..37)
	if roll.even?
		purse = purse + bet
		wins +=1
	elsif roll == 0 or roll.odd?
		purse = purse - bet
	end
	bet = bet * 1.5
	count +=1
end
	p "------------------"
	p "Count = #{count.to_i}"
	p "Purse = #{purse.to_i}"
	p "Bet = #{bet.to_i}"
	p "Wins: #{wins} - Losses: #{(count - wins).to_i}"
	p "------------------"				

