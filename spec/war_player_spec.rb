require_relative 'spec_helper'

require_relative '../lib/war_player'
require_relative '../lib/playing_card'

describe 'WarPlayer' do
  describe '#initialize' do
    it 'initializes with a hand, name, and client' do
      war_player = WarPlayer.new
      expect(war_player).to respond_to :hand
      expect(war_player).to respond_to :name
      expect(war_player).to respond_to :client
    end
  end

  describe '#play_card' do
    it 'plays last card in hand' do
      war_player = WarPlayer.new('', [PlayingCard.new('A', 'Hearts'), PlayingCard.new('A', 'Clubs')])
      top_card = war_player.hand.last
      played_card = war_player.play_card
      expect(played_card).to eq top_card
      expect(played_card).to respond_to :suit
    end
  end

  describe '#add_card' do
    it 'adds card to first spot of deck' do
      war_player = WarPlayer.new('', [PlayingCard.new('A', 'Hearts')])
      new_card = PlayingCard.new('Q', 'Hearts')
      war_player.add_card(new_card)
      expect(war_player.hand.first).to eq new_card
    end

    it 'can add multiple cards at once' do
      war_player = WarPlayer.new('', [PlayingCard.new('A', 'Hearts')])
      new_cards = [PlayingCard.new('Q', 'Hearts'), PlayingCard.new('2', 'Hearts')]
      war_player.add_card(new_cards)
      expect(war_player.hand[0..1]).to eq new_cards
    end
  end
end
