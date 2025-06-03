require_relative '../lib/playing_card'

describe 'PlayingCard' do
  it 'initializes with a rank, suit, and value' do
    card = PlayingCard.new('A', '♥')
    expect(card.rank).to eq 'A'
    expect(card.suit).to eq '♥'
    expect(card.value).to eq 12
  end

  it 'compares by proper card values' do
    card1 = PlayingCard.new('A', '♥')
    card2 = PlayingCard.new('A', '♥')
    expect(card1).to eq card2
  end

  it 'raises an error unless suit is valid' do
    expect { PlayingCard.new('A', 'Z') }.to raise_error StandardError
  end

  it 'raises an error unless rank is valid' do
    expect { PlayingCard.new('25', '♣') }.to raise_error StandardError
  end

  it 'returns true if card is greater than other cards value' do
    card1 = PlayingCard.new('A', '♥')
    card2 = PlayingCard.new('Q', '♥')
    expect(card1.has_greater_value_than?(card2)).to eq true
  end
end
