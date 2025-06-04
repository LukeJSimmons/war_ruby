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

  def play_round(pot = [])
    self.rounds += 1 if pot.empty?
    p1_card = player1.play_card
    p2_card = player2.play_card
    pot.push(p1_card, p2_card).shuffle!
    round_winner = get_round_winner(p1_card, p2_card, pot)
    return play_round(pot) unless round_winner || winner
    display_message(round_winner, pot) if round_winner
  end

  private

  def deal_cards
    (CardDeck::BASE_DECK_SIZE / 2).times do
      player1.add_card(deck.deal)
      player2.add_card(deck.deal)
    end
  end

  def get_round_winner(p1_card, p2_card, pot)
    if p1_card.has_greater_value_than?(p2_card)
      pot.each { |card| player1.add_card(card) }
      player1
    elsif p2_card.has_greater_value_than?(p1_card)
      pot.each { |card| player2.add_card(card) }
      player2
    end
  end

  def display_message(winner, pot)
    message = ''
    message += "ROUND #{rounds} | #{winner.name} took "
    pot.each do |card|
      message += "#{card.rank} of #{card.suit} with " unless card == pot.last
    end
    message += "#{"#{pot.last.rank} of #{pot.last.suit}"}"
    message
  end
end
