require_relative '../lib/playing_card'

describe 'PlayingCard' do
  it 'initializes with a rank and suit' do
    card = PlayingCard.new('A', 'H')
    expect(card.rank).to eq 'A'
    expect(card.suit).to eq 'H'
  end

  it 'compares by proper card values' do
    card1 = PlayingCard.new('A', 'H')
    card2 = PlayingCard.new('A', 'H')
    expect(card1).to eq card2
  end

  it 'raises an error unless suit is valid' do
    expect { PlayingCard.new('A', 'Z') }.to raise_error
  end

  it 'raises an error unless rank is valid' do
    expect { PlayingCard.new('25', 'C') }.to raise_error
  end
end
