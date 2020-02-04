require_relative 'Player.rb'
require_relative 'Game.rb'

player1 = Player.new("Niall")
player2 = Player.new("James")
game = Game.new(player1, player2)

p "Tennis match between #{player1.getName} & #{player2.getName}"

game.playSet



