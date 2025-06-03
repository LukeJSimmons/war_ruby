class WarPlayer
  attr_reader :hand, :name

  def initialize(name = '', hand = [])
    @hand = hand
    @name = name
  end

  def play_card
    hand.pop
  end

  def add_card(cards)
    hand.unshift(*Array(cards))
  end
end
