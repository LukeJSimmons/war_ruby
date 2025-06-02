require 'ostruct'

class FakeWarGame
  def start
  end

  def play_round
    winner = rand(2) + 1
    loser = (winner % 2) + 1
    loser_card = %w(2 3 4 5 6 7 8).sample
    winner_card = %w(9 10 J Q K A).sample
    "Player #{winner} took #{loser_card} of #{suit} with #{winner_card} of #{suit}"
  end

  def suit
    %w(Clubs Diamonds Hearts Spades).sample
  end

  def winner
    @winner ||= OpenStruct.new(name: "Player 1") if rand(10) == 9
    @winner
  end
end
