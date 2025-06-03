require_relative 'card_deck'
require_relative 'war_player'

class WarGame
  attr_reader :deck, :player1, :player2
  attr_accessor :rounds

  def initialize
    @deck = CardDeck.new
    @player1 = WarPlayer.new('Player 1')
    @player2 = WarPlayer.new('Player 2')
    @rounds = 0
  end

  def start
    deck.shuffle!
    deal_cards
  end

  def winner
    return player1 if player2.hand.empty?

    player2 if player1.hand.empty?
  end

  def play_round(cards = [])
    self.rounds += 1 if cards.empty?
    p1_card = player1.play_card
    p2_card = player2.play_card
    cards.push(p1_card, p2_card).shuffle!
    round_winner = get_round_winner(p1_card, p2_card, cards)
    return play_round(cards) unless round_winner || winner
    display_message(round_winner, cards)
  end

  private

  def deal_cards
    (CardDeck::BASE_DECK_SIZE / 2).times do
      player1.add_card(deck.deal)
      player2.add_card(deck.deal)
    end
  end

  def get_round_winner(p1_card, p2_card, cards)
    if p1_card.has_greater_value_than?(p2_card)
      cards.each { |card| player1.add_card(card) }
      player1
    elsif p2_card.has_greater_value_than?(p1_card)
      cards.each { |card| player2.add_card(card) }
      player2
    end
  end

  def display_message(winner, cards)
    message = ''
    message += "#{winner.name} took "
    cards.each_with_index do |card, index|
      message += "#{card.rank} of #{card.suit} with " unless index == cards.count - 1
    end
    message += "#{"#{cards[-1].rank} of #{cards[-1].suit}"}"
    message
  end
end
