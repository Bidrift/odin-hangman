# A hangman class, added for future customization
class Hangman
  attr_reader :health

  def initialize
    @health = 7
  end

  def step
    @health -= 1
    @dead = true if @health.zero?
  end

  def dead?
    @dead
  end
end
