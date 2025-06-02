 require_relative 'card_deck'
 require_relative 'war_player'
 
 class WarGame
  attr_reader :deck, :player1, :player2

  def initialize
    @deck = CardDeck.new
    @player1 = WarPlayer.new('Player 1')
    @player2 = WarPlayer.new('Player 2')
  end

  def deal_cards
    (CardDeck::BASE_DECK_SIZE / 2).times do
      player1.add_card(deck.deal)
      player2.add_card(deck.deal)
    end
  end

  def start
    deck.shuffle!
    deal_cards
  end

  def winner
    return player1 if player2.hand.empty?
    return player2 if player1.hand.empty?
  end

  def play_round(cards=[])
    message = ""
    
    cards.unshift(player1.play_card)
    cards.unshift(player2.play_card)
    
    p1_card = cards[1]
    p2_card = cards[0]

    if p1_card.has_greater_value_than?(p2_card)
      cards.each { |card| player1.add_card(card) }
      message += "Player 1"
    elsif p2_card.has_greater_value_than?(p1_card)
      cards.each { |card| player2.add_card(card) }
      message += "Player 2"
    else
      play_round(cards) unless player1.hand.empty? || player2.hand.empty?
    end

    message += " took "
    cards[0..cards.count-2].each { |card| message += "#{card.rank} of #{card.suit} with " }
    message += "#{cards[-1].rank} of #{cards[-1].suit}"
    message
  end
 end
