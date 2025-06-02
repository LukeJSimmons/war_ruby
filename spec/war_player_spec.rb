require_relative '../lib/war_player'

describe 'WarPlayer' do
  it 'initializes with 26 cards in hand' do
    war_player = WarPlayer.new
    expect(war_player.hand.length).to eq 26
  end
end
