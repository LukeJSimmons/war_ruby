 class PlayingCard
  attr_reader :rank, :suit, :value

  SUITS = ['H', 'D', 'C', 'S']
  RANKS = ['2','3','4','5','6','7','8','9','10','J','Q','K','A']

   def initialize(rank, suit)
    raise StandardError unless SUITS.include?(suit)
    raise StandardError unless RANKS.include?(rank)
     @rank = rank
     @suit = suit
     @value = RANKS.find_index(rank)
   end

   def ==(other_card)
     rank == other_card.rank &&
     suit == other_card.suit
   end

   def has_greater_value_than?(other_card)
     value > other_card.value
   end
 end
