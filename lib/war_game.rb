 require_relative 'card_deck'
 require_relative 'war_player'
 
 class WarGame
  attr_reader :deck, :player1, :player2

  def initialize
    @deck = CardDeck.new
    @player1 = WarPlayer.new('P1')
    @player2 = WarPlayer.new('P2')
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

  def play_round
    "P1 plays #{player1.play_card.rank} of #{player1.play_card.suit} | P2 plays #{player2.play_card.rank} of #{player2.play_card.suit}"
  end
 end
