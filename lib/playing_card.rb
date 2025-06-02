 class PlayingCard
  attr_reader :rank, :suit

  SUITS = ['H', 'D', 'C', 'S']
  RANKS = ['2','3','4','5','6','7','8','9','10','J','Q','K','A']

   def initialize(rank, suit)
    raise StandardError unless SUITS.include?(suit)
    raise StandardError unless RANKS.include?(rank)
     @rank = rank
     @suit = suit
   end

   def ==(other_card)
     rank == other_card.rank &&
     suit == other_card.suit
   end
 end
