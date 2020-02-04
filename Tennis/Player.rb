class Player
  @@score_translate = ["love","15","30","40"]

  def initialize(name)
    @name = name
    @score = 0
  end

  def getName()
    @name
  end

  def getScore()
    score = @@score_translate[@score]
    score = "game" if score.nil?
    score
  end

  def getScoreInt()
    @score
  end

  def setScore()
    @score += 1
  end

  def resetScore()
    @score = 0
  end

end