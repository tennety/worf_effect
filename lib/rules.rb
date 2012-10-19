require 'ruleby'
require_relative 'data_types'

include Ruleby

class WorfEffectRulebook < Rulebook
  def rules
    rule :worf_loses, {priority: 10},
      [Klingon, :worf,
       m.name == "Worf"],

      [Badass, :badass,
       m.name => :n],

      [FightStat, :f,
       m.badasses(:worf, :badass, &c{|bs, w, b| bs.include?(w) && bs.include?(b)}),
       m.winner == b(:badass)]\
    do |vars|
      puts "Worf loses!"
      vars[:badass].badass_level = vars[:worf].badass_level + 10
      modify vars[:badass]
      retract vars[:f]
    end

    rule :worf_wins, {priority: 10},
      [Klingon, :worf,
       m.name == "Worf"],

      [Badass,  :badass,
       m.name => :n],

      [FightStat, :f,
       m.badasses(:worf, :badass, &c{|bs, w, b| bs.include?(w) && bs.include?(b)}),
       m.winner == b(:worf)]\
    do |vars|
      puts "Worf wins!"
      vars[:badass].badass_level = vars[:worf].badass_level - 10
      modify vars[:badass]
      retract vars[:f]
    end

    rule :more_badass,
      [Klingon, :worf,
       m.name == "Worf",
       m.badass_level => :worf_level],

      [Badass, :badass,
       m.name => :n,
       m.badass_level(:worf_level, &c{|my_level, worf_level| my_level > worf_level}) => :my_level]\
    do |vars|
      puts "#{vars[:badass].name} defeated #{vars[:worf].name}, so (s)he must be *really* badass."
      puts "(S)he has #{vars[:my_level]} points!"
    end

    rule :less_badass,
      [Klingon, :worf,
       m.name == "Worf",
       m.badass_level => :worf_level],

      [Badass, :badass,
       m.name => :n,
       m.badass_level(:worf_level, &c{|my_level, worf_level| my_level <= worf_level}) => :my_level]\
    do |vars|
      puts "#{vars[:badass].name} was defeated by #{vars[:worf].name}, so (s)he must not be *really* badass."
      puts "(S)he has #{vars[:my_level]} points!"
    end
  end
end

worf = Klingon.new("Worf", 100)
riker = Badass.new("Riker", 100)
borg = Badass.new("Drone", 100)

engine :engine do |e|
  WorfEffectRulebook.new(e).rules
  [worf, riker, borg].map{|badass| e.assert badass}
  e.assert FightStat.new([riker, worf], worf)
  e.assert FightStat.new([borg, worf], borg)

  # puts e.print

  e.match
end
