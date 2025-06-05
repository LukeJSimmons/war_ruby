require_relative 'spec_helper'

require_relative '../lib/war_game'

describe 'WarGame' do
  subject(:game) { WarGame.new }

  before do
    allow($stdout).to receive(:write)
  end

  describe '#initialize' do
    it 'initalizes with deck, players, and rounds' do
      expect(game).to respond_to :deck
      expect(game).to respond_to :player1
      expect(game).to respond_to :player2
      expect(game).to respond_to :rounds
    end
  end

  describe '#start' do
    it 'shuffles the deck' do
      unshuffled_deck = CardDeck.new
      game.start
      expect(game.deck).to_not eq unshuffled_deck
    end

    it 'deals half the deck to each player' do
      game.start
      expect(game.player1.hand.length).to eq CardDeck::BASE_DECK_SIZE/2
      expect(game.player2.hand.length).to eq CardDeck::BASE_DECK_SIZE/2
    end

    it 'can play a whole game' do
    game.start
    puts game.play_round until game.winner
    expect(game.winner).to respond_to :hand
  end
  end

  describe '#winner' do
    it 'returns player1 if he is the winner' do
      p1_card = PlayingCard.new('A', 'Hearts')
      game.player1.add_card(p1_card)
      expect(game.winner).to eq game.player1
      expect(game.winner).to_not eq game.player2
    end

    it 'returns player2 if he is the winner' do
      p2_card = PlayingCard.new('A', 'Hearts')
      game.player2.add_card(p2_card)
      expect(game.winner).to eq game.player2
      expect(game.winner).to_not eq game.player1
    end
  end

  describe '#play_round' do
    it 'gives P2 card to P1 if P1 wins round' do
      p1_card = PlayingCard.new('A', 'Hearts')
      p2_card = PlayingCard.new('2', 'Hearts')
      game.player1.add_card(p1_card)
      game.player2.add_card(p2_card)
      game.play_round
      expect(game.player1.hand.count).to eq 2
      expect(game.player2.hand.count).to eq 0
    end

    it 'handles a tie properly' do
      game.player1.add_card(PlayingCard.new('A', 'Clubs'))
      game.player2.add_card(PlayingCard.new('A', 'Hearts'))
      game.player1.add_card(PlayingCard.new('2', 'Hearts'))
      game.player2.add_card(PlayingCard.new('10', 'Hearts'))
      game.play_round
      expect(game.player1.hand.count).to eq 0
      expect(game.player2.hand.count).to eq 4
    end

    it 'displays an overview message each round' do
      p1_card = PlayingCard.new('A', 'Hearts')
      p2_card = PlayingCard.new('2', 'Hearts')
      game.player1.add_card(p1_card)
      game.player2.add_card(p2_card)
      output = game.play_round
      expect(output).to include 'A of Hearts'
      expect(output).to include '2 of Hearts'
    end

    it 'displays tie message when players tie' do
      p1_cards = [PlayingCard.new('A', 'Clubs'), PlayingCard.new('A', 'Hearts')]
      p2_cards = [PlayingCard.new('2', 'Hearts'), PlayingCard.new('A', 'Diamonds')]
      game.player1.add_card(p1_cards)
      game.player2.add_card(p2_cards)
      output = game.play_round
      expect(output).to include 'A of Clubs'
      expect(output).to include 'A of Diamonds'
    end

    it 'increments rounds by one each round' do
      starting_round = game.rounds
      game.start
      game.play_round
      expect(game.rounds).to eq starting_round + 1
    end
  end
end
