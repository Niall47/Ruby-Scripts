class Game

  attr_accessor :game
  attr_accessor :set

  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
    @game = []
    @set = []
  end

  def playPoint
    winner = [@player1, @player2].sample
    winner.setScore
    game.push(winner.getName)
    p "#{@player1.getName}: #{@player1.getScore} - #{@player2.getName}: #{@player2.getScore}"
    winner
  end

  def playGame
    playPoint
    until gameWinner?
      playPoint
    end
    @player1.resetScore
    @player2.resetScore
    whoWonGame
  end

  def playSet
    playGame
    until setWinner?
      playGame
    end
  end

  def gameWinner?()
    #has anyone reached the minimum points to win game?
    tooFewPoints = (@player1.getScoreInt > 3 || @player2.getScoreInt > 3)
    #Has a player won by a margin of two?
    advantage = !(@player1.getScoreInt + 2 > @player2.getScoreInt || @player2.getScoreInt + 2 > @player1.getScoreInt)
    return (tooFewPoints || advantage)
  end

  def setWinner?()
    winner = (whoWonSet.nil?)
    advantage = (countGames.key(@player1.getName).to_i > 6 || countGames.key(@player1.getName).to_i > 6)
    return (advantage || winner)
  end

  def whoWonGame()
    if @player1.getScoreInt > @player2.getScoreInt
      set.push(@player1.getName)
      @player1
    else
      set.push(@player2.getName)
      @player2
    end
  end

  def countGames()
    counts = Hash.new(0)
    @set.each { |name| counts[name] += 1 }
    counts
  end

  def whoWonSet()
    counts = countGames

    player1 = counts.key(@player1.getName)
    player2 = counts.key(@player2.getName)

    if player1.nil? then return player2 end
    if player2.nil? then return player1 end
    if player1 > player2 then return @player1 end
    if player2 > player1 then return @player2 end

  end
end