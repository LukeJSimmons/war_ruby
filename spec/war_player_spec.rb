require_relative '../lib/war_player'

describe 'WarPlayer' do
  it 'initializes with a hand' do
    war_player = WarPlayer.new
    expect(war_player).to respond_to :hand
  end

  it 'plays top card in hand' do
    war_player = WarPlayer.new([PlayingCard.new('A','H')])
    top_card = war_player.hand[0]
    played_card = war_player.play_card
    expect(played_card).to eq top_card
    expect(played_card).to respond_to :suit
  end
end
