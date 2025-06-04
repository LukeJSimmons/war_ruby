class WarPlayer
  attr_reader :hand, :name, :client

  def initialize(name = '', hand = [], client=nil)
    @hand = hand
    @name = name
    @client = client
  end

  def play_card
    hand.pop
  end

  def add_card(cards)
    hand.unshift(*Array(cards))
  end
end
