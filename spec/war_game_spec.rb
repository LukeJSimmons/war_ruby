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

  it 'returns player1 if he is the winner' do
    game = WarGame.new
    p1_card = PlayingCard.new('A','Hearts')
    game.player1.add_card(p1_card)
    expect(game.winner).to eq game.player1
    expect(game.winner).to_not eq game.player2
  end

  it 'gives P2 card to P1 if P1 wins round' do
    game = WarGame.new
    p1_card = PlayingCard.new('A','Hearts')
    p2_card = PlayingCard.new('2','Hearts')
    game.player1.add_card(p1_card)
    game.player2.add_card(p2_card)
    game.play_round
    expect(game.player1.hand.count).to eq 2
    expect(game.player2.hand.count).to eq 0
  end

  it 'handles a tie properly' do
    game = WarGame.new
    game.player1.add_card(PlayingCard.new('2','Hearts'))
    game.player2.add_card(PlayingCard.new('10','Hearts'))
    game.player1.add_card(PlayingCard.new('A', 'Clubs'))
    game.player2.add_card(PlayingCard.new('A', 'Hearts'))
    game.play_round
    expect(game.player1.hand.count).to eq 0
    expect(game.player2.hand.count).to eq 4
  end

  it 'displays an overview message each round' do
    game = WarGame.new
    p1_card = PlayingCard.new('A','Hearts')
    p2_card = PlayingCard.new('2','Hearts')
    game.player1.add_card(p1_card)
    game.player2.add_card(p2_card)
    expect(game.play_round).to eq "Player 1 took 2 of Hearts with A of Hearts"
  end

  it 'displays tie message when players tie' do
    game = WarGame.new
    p1_card = PlayingCard.new('A','Hearts')
    p2_card = PlayingCard.new('2','Hearts')
    p1_card = PlayingCard.new('A','Clubs')
    p2_card = PlayingCard.new('A','Diamonds')
    game.player1.add_card(p1_card)
    game.player2.add_card(p2_card)
    expect(game.play_round).to eq " took A of Diamonds with A of Clubs"
  end
end
