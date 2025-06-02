require_relative '../lib/war_game'

describe 'WarGame' do
  it 'initalizes with deck and players' do
    game = WarGame.new
    expect(game).to respond_to :deck
    expect(game).to respond_to :player1
    expect(game).to respond_to :player2
  end

  it 'deals half the deck to each player' do
    game = WarGame.new
    game.deal_cards
    expect(game.player1.hand.length).to eq 26
    expect(game.player2.hand.length).to eq 26
  end
end
