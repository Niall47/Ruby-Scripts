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
  end

  def playGame
    p "------GAME------"
    100.times do
      playPoint
      if @player1.getScoreInt > 3 || @player2.getScoreInt > 3
        if checkForGameWinner
          p "#{whoWonGame.getName} won the game"
          break
        end
      end
    end
    p "-----------------"
    @player1.resetScore
    @player2.resetScore
  end

  def playSet
    while checkForSetWinner == false
      playGame
    end
  end

  def checkForGameWinner()
    true if @player1.getScoreInt + 2 > @player2.getScoreInt || @player2.getScoreInt + 2 > @player1.getScoreInt
  end

  def checkForSetWinner()
    false unless set.count > 6
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

  def whoWonSet()
    counts = Hash.new(0)
    @set.each { |name| counts[name] += 1 }

    player1 = counts.key(@player1.getName)
    player2 = counts.key(@player2.getName)

    if player1.nil? then return player2 end
    if player2.nil? then return player1 end

    if player1 + 2 > player2
      @player1
    elsif player2 + 2 > player1
      @player2
    end

  end
end