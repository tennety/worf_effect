class Badass
  attr_accessor :name, :badass_level

  def initialize(name, badass_level)
    @name, @badass_level = name, badass_level
  end
end

class Klingon < Badass
end

class FightStat
  attr_accessor :badasses, :winner
  def initialize(badasses, winner)
    @badasses = badasses
    @winner = winner
  end
end

