require_relative '../lib/war_player'

describe 'WarPlayer' do
  it 'initializes with a hand' do
    war_player = WarPlayer.new
    expect(war_player).to respond_to :hand
  end
end
