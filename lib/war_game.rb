 require_relative 'card_deck'
 require_relative 'war_player'
 
 class WarGame
  attr_reader :deck, :player1, :player2

  def initialize
    @deck = CardDeck.new.shuffle
    @player1 = WarPlayer.new
    @player2 = WarPlayer.new
  end

  def deal_cards
    26.times do
      player1.hand << deck.deal
      player2.hand << deck.deal
    end
  end
 end
