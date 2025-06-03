class WarPlayer
  attr_reader :hand, :name

  def initialize(name = '', hand = [])
    @hand = hand
    @name = name
  end

  def play_card
    hand.pop
  end

  def add_card(card)
    if card.is_a? Array
      hand.unshift(*card)
    else
      hand.unshift(card)
    end
  end
end
