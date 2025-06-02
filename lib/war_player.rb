 
class WarPlayer
  attr_reader :hand

  def initialize(hand=[])
    @hand = hand
  end

  def play_card
    @hand.pop
  end
end