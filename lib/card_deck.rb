require_relative 'playing_card'

class CardDeck
  attr_reader :cards

  def initialize
    @cards = build_deck
  end

  def build_deck
    PlayingCard::SUITS.map do |suit|
      PlayingCard::RANKS.map do |rank|
        PlayingCard.new(rank, suit)
      end
    end.flatten
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
