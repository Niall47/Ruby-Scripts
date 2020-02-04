class Game

  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
  end

  def checkForWinner()
    true if @player1.getScoreInt + 2 > @player2.getScoreInt || @player2.getScoreInt + 2 > @player1.getScoreInt
  end

  def playPoint
    [@player1, @player2].sample.setScore
    p "#{@player1.getName}: #{@player1.getScore} - #{@player2.getName}: #{@player2.getScore}"

  end

  def whoWon()
    if @player1.getScoreInt > @player2.getScoreInt
      @player1
    else
      @player2
    end
  end

end