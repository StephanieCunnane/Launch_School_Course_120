class Card
  RANKS = %w(2 3 4 5 6 7 8 9 10 Jack Queen King Ace)

  include Comparable

  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def <=>(other_card)
    RANKS.index(rank.to_s) <=> RANKS.index(other_card.rank.to_s)
  end

  def to_s
    "#{rank} of #{suit}"
  end
end

# Using a hash to order by rank
class Card
  include Comparable

  RELATIVE_RANKS = {
    1  => 2,
    2  => 3,
    3  => 4,
    4  => 5,
    5  => 6,
    6  => 7,
    7  => 8,
    8  => 9,
    9  => 10,
    10 => 'Jack',
    11 => 'Queen',
    12 => 'King',
    13 => 'Ace'
  }.freeze

  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def <=>(other_card)
    RELATIVE_RANKS.key(rank) <=> RELATIVE_RANKS.key(other_card.rank)
  end

  def to_s
    "#{rank} of #{suit}"
  end
end

# Given solution
class Card
  include Comparable

  VALUES = { 'Jack' => 11, 'Queen' => 12, 'King' => 13, 'Ace' => 14 }

  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def value
    VALUES.fetch(rank, rank)
  end

  def <=>(other_card)
    value <=> other_card.value
  end

  def to_s
    "#{rank} of #{suit}"
  end
end

cards = [Card.new(2, 'Hearts'),
         Card.new(10, 'Diamonds'),
         Card.new('Ace', 'Clubs')]
puts cards
puts cards.min == Card.new(2, 'Hearts')
puts cards.max == Card.new('Ace', 'Clubs')

cards = [Card.new(5, 'Hearts')]
puts cards.min == Card.new(5, 'Hearts')
puts cards.max == Card.new(5, 'Hearts')

cards = [Card.new(4, 'Hearts'),
         Card.new(4, 'Diamonds'),
         Card.new(10, 'Clubs')]
puts cards.min.rank == 4
puts cards.max == Card.new(10, 'Clubs')

cards = [Card.new(7, 'Diamonds'),
         Card.new('Jack', 'Diamonds'),
         Card.new('Jack', 'Spades')]
puts cards.min == Card.new(7, 'Diamonds')
puts cards.max.rank == 'Jack'

cards = [Card.new(8, 'Diamonds'),
         Card.new(8, 'Clubs'),
         Card.new(8, 'Spades')]
puts cards.min.rank == 8
puts cards.max.rank == 8

# Further Exploration

class Card
  include Comparable

  RELATIVE_RANKS = {
    1  => 2,
    2  => 3,
    3  => 4,
    4  => 5,
    5  => 6,
    6  => 7,
    7  => 8,
    8  => 9,
    9  => 10,
    10 => 'Jack',
    11 => 'Queen',
    12 => 'King',
    13 => 'Ace'
  }.freeze

  RELATIVE_SUITS = %w(Diamonds Clubs Hearts Spades).freeze

  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def compare_suits(other_card)
    RELATIVE_SUITS.index(suit) < RELATIVE_SUITS.index(other_card.suit) ? -1 : 1
  end

  def <=>(other_card)
    rank_cmp = RELATIVE_RANKS.key(rank) <=> RELATIVE_RANKS.key(other_card.rank)
    rank_cmp.zero? ? compare_suits(other_card) : rank_cmp
  end

  def ==(other_card)
    rank == other_card.rank
  end

  def to_s
    "#{rank} of #{suit}"
  end
end
