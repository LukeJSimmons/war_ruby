require_relative 'playing_card'

class CardDeck
  attr_reader :cards

  def initialize
    @cards = build_deck
  end

  def build_deck
    new_deck = []
    for suit in PlayingCard::SUITS do
      for rank in PlayingCard::RANKS do
        new_deck << PlayingCard.new(rank, suit)
      end
    end
    new_deck
  end

  def cards_left
    @cards.length
  end

  def deal
    @cards.pop
  end

  def shuffle
    cards.shuffle
  end
end
