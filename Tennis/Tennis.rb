require_relative 'Player.rb'
require_relative 'Game.rb'

player1 = Player.new("Niall")
player2 = Player.new("James")
game = Game.new(player1, player2)

p "Tennis match between #{player1.getName} & #{player2.getName}"
p "#{player1.getName}: #{player1.getScore} - #{player2.getName}: #{player2.getScore}"

100.times do
  game.playPoint
  if player1.getScoreInt > 3 || player2.getScoreInt > 3
    if game.checkForWinner
      p "#{game.whoWon.getName} is the winner"
      break
    end
  end
end


