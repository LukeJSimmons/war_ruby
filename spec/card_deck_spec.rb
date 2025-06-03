require_relative '../lib/card_deck'

describe 'CardDeck' do
  it 'Should have 52 cards when created' do
    deck = CardDeck.new
    expect(deck.cards_left).to eq CardDeck::BASE_DECK_SIZE
  end

  it 'should deal the top card' do
    deck = CardDeck.new
    card = deck.deal
    expect(card).to_not be_nil
    expect(deck.cards_left).to eq CardDeck::BASE_DECK_SIZE-1
    expect(card).to respond_to :suit
  end

  it 'should deal a different card each time' do
    deck = CardDeck.new
    card1 = deck.deal
    card2 = deck.deal
    expect(card1).to_not eq card2
  end

  it 'should be able to shuffle deck' do
    deck = CardDeck.new
    unshuffled_deck = CardDeck.new
    expect(deck).to eq unshuffled_deck
    deck.shuffle!
    expect(deck).to_not eq(unshuffled_deck)
  end
end
