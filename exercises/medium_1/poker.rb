class Deck
  RANKS = ((2..10).to_a + %w(Jack Queen King Ace)).freeze
  SUITS = %w(Hearts Clubs Diamonds Spades).freeze

  attr_reader :cards

  def initialize
    reset
  end

  def draw
    reset if cards.empty?
    cards.pop
  end

  private

  def reset
    @cards = build_deck
  end

  def build_deck
    combos = RANKS.product(SUITS)
    combos.map! { |rank, suit| Card.new(rank, suit) }
    combos.shuffle
  end
end

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

class PokerHand
  attr_reader :deck, :hand

  def initialize(deck)
    @deck = deck
    @hand = build_hand
  end

  def print
    puts hand
  end

  def evaluate
    case
    when royal_flush?     then 'Royal flush'
    when straight_flush?  then 'Straight flush'
    when four_of_a_kind?  then 'Four of a kind'
    when full_house?      then 'Full house'
    when flush?           then 'Flush'
    when straight?        then 'Straight'
    when three_of_a_kind? then 'Three of a kind'
    when two_pair?        then 'Two pair'
    when pair?            then 'Pair'
    else                       'High card'
    end
  end

  private

  def build_hand
    hand = []
    5.times { hand << deck.draw }
    hand
  end

  def all_one_suit?
    hand.map(&:suit).uniq.size == 1
  end

  def ranks_in_sequence?
    sorted_ranks = hand.sort
    Card::RANKS.join.include?(sorted_ranks.map(&:rank).join)
  end

  def n_of_a_kind(n)
    sorted_ranks = hand.map(&:rank).sort_by { |rank| Card::RANKS.index(rank.to_s) }
    sorted_ranks.chunk_while { |a, b| a == b }.map(&:size).max == n
  end

  def royal_flush?
    royal_flush_ranks = hand.sort.map(&:rank).join == "10JackQueenKingAce"
    royal_flush_ranks && all_one_suit?
  end

  def straight_flush?
    ranks_in_sequence? && all_one_suit?
  end

  def four_of_a_kind?
    n_of_a_kind(4)
  end

  def full_house?
    ranks = hand.sort.map(&:rank).chunk_while { |a, b| a == b }.to_a
    ranks.one? { |elem| elem.size == 3 } && ranks.one? { |elem| elem.size == 2 }
  end

  def flush?
    all_one_suit? && !ranks_in_sequence?
  end

  # high-Ace straignt only, not low-Ace straight
  def straight?
    ranks_in_sequence? && !all_one_suit?
  end

  def three_of_a_kind?
    n_of_a_kind(3)
  end

  def two_pair?
    sorted_ranks = hand.map(&:rank).sort_by { |rank| Card::RANKS.index(rank.to_s) }
    sorted_ranks.chunk_while { |a, b| a == b }.map(&:size).max(2).all? { |count| count == 2 }
  end

  def pair?
    n_of_a_kind(2) && !two_pair?
  end
end

# Improved implementation
##########################################################################

class Deck
  RANKS = ((2..10).to_a + %w(Jack Queen King Ace)).freeze
  SUITS = %w(Hearts Clubs Diamonds Spades).freeze

  def initialize
    @cards = nil
    reset_deck
  end

  def draw
    reset_deck if @cards.empty?
    @cards.pop
  end

  private

  def reset_deck
    combos = RANKS.product(SUITS)
    combos.map! { |rank, suit| Card.new(rank, suit) }
    @cards = combos.shuffle
  end
end

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

class PokerHand
  def initialize(deck)
    @deck = deck
    @hand = deal_new_hand
    @ranks_count = count_ranks
  end

  def print
    puts @hand
  end

  def evaluate
    case
    when royal_flush?     then 'Royal flush'
    when straight_flush?  then 'Straight flush'
    when four_of_a_kind?  then 'Four of a kind'
    when full_house?      then 'Full house'
    when flush?           then 'Flush'
    when straight?        then 'Straight'
    when three_of_a_kind? then 'Three of a kind'
    when two_pair?        then 'Two pair'
    when pair?            then 'Pair'
    else                       'High card'
    end
  end

  private

  def deal_new_hand
    hand = []
    5.times { hand << @deck.draw }
    hand
  end

  def count_ranks
    ranks_count = Hash.new(0)
    @hand.each { |card| ranks_count[card.rank] += 1 }
    ranks_count
  end

  def n_of_a_kind?(n)
    @ranks_count.values.include?(n)
  end

  def royal_flush?
    ranks = @hand.map { |card| Card::RELATIVE_RANKS.key(card.rank) }
    straight_flush? && (ranks.min == 9)
  end

  def straight_flush?
    straight? && flush?
  end

  def four_of_a_kind?
    n_of_a_kind?(4)
  end

  def full_house?
    three_of_a_kind? && pair?
  end

  def flush?
    @hand.map(&:suit).uniq.size == 1
  end

  def straight?
    ranks = @hand.map { |card| Card::RELATIVE_RANKS.key(card.rank) }
    ranks.uniq.size == 5 && (ranks.max - ranks.min == 4)
  end

  def three_of_a_kind?
    n_of_a_kind?(3)
  end

  def two_pair?
    @ranks_count.values.count(2) == 2
  end

  def pair?
    @ranks_count.values.count(2) == 1
  end
end

##################################################################################################3
# Given solution

class Card
  include Comparable
  attr_reader :rank, :suit

  VALUES = { 'Jack' => 11, 'Queen' => 12, 'King' => 13, 'Ace' => 14 }

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def to_s
    "#{rank} of #{suit}"
  end

  def value
    VALUES.fetch(@rank, @rank)
  end

  def <=>(other_card)
    value <=> other_card.value
  end
end

class Deck
  RANKS = ((2..10).to_a + %w(Jack Queen King Ace)).freeze
  SUITS = %w(Hearts Clubs Diamonds Spades).freeze

  def initialize
    reset
  end

  def draw
    reset if @deck.empty?
    @deck.pop
  end

  private

  def reset
    @deck = RANKS.product(SUITS).map do |rank, suit|
      Card.new(rank, suit)
    end

    @deck.shuffle!
  end
end

class PokerHand
  def initialize(cards)
    @cards = []
    @rank_count = Hash.new(0)

    5.times do
      card = cards.draw
      @cards << card
      @rank_count[card.rank] += 1
    end
  end

  def print
    puts @cards
  end

  def evaluate
    if    royal_flush?     then 'Royal flush'
    elsif straight_flush?  then 'Straight flush'
    elsif four_of_a_kind?  then 'Four of a kind'
    elsif full_house?      then 'Full house'
    elsif flush?           then 'Flush'
    elsif straight?        then 'Straight'
    elsif three_of_a_kind? then 'Three of a kind'
    elsif two_pair?        then 'Two pair'
    elsif pair?            then 'Pair'
    else 'High card'
    end
  end

  private

  def flush?
    suit = @cards.first.suit
    @cards.all? { |card| card.suit == suit }
  end

  def straight?
    return false if @rank_count.any? { |_rank, count| count > 1 }
    @cards.min.value == @cards.max.value - 4
  end

  def n_of_a_kind?(n)
    @rank_count.one? { |_rank, count| count == n }
  end

  def straight_flush?
    flush? && straight?
  end

  def royal_flush?
    straight_flush? && @cards.min.rank == 10
  end

  def four_of_a_kind?
    n_of_a_kind?(4)
  end

  def full_house?
    n_of_a_kind?(3) && n_of_a_kind?(2)
  end

  def three_of_a_kind?
    n_of_a_kind?(3)
  end

  def two_pair?
    @rank_count.select { |_rank, count| count == 2 }.size == 2
  end

  def pair?
    n_of_a_kind?(2)
  end
end

# Dangerous monkey-patching for testing purposes only
class Array
  alias_method :draw, :pop
end

hand = PokerHand.new(Deck.new)
hand.print
puts hand.evaluate

hand = PokerHand.new([
  Card.new(10,      'Hearts'),
  Card.new('Ace',   'Hearts'),
  Card.new('Queen', 'Hearts'),
  Card.new('King',  'Hearts'),
  Card.new('Jack',  'Hearts')
])
puts hand.evaluate == 'Royal flush'

hand = PokerHand.new([
  Card.new(8,       'Clubs'),
  Card.new(9,       'Clubs'),
  Card.new('Queen', 'Clubs'),
  Card.new(10,      'Clubs'),
  Card.new('Jack',  'Clubs')
])
puts hand.evaluate == 'Straight flush'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Four of a kind'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(5, 'Hearts')
])
puts hand.evaluate == 'Full house'

hand = PokerHand.new([
  Card.new(10, 'Hearts'),
  Card.new('Ace', 'Hearts'),
  Card.new(2, 'Hearts'),
  Card.new('King', 'Hearts'),
  Card.new(3, 'Hearts')
])
puts hand.evaluate == 'Flush'

hand = PokerHand.new([
  Card.new(8,      'Clubs'),
  Card.new(9,      'Diamonds'),
  Card.new(10,     'Clubs'),
  Card.new(7,      'Hearts'),
  Card.new('Jack', 'Clubs')
])
puts hand.evaluate == 'Straight'

hand = PokerHand.new([
  Card.new('Queen', 'Clubs'),
  Card.new('King',  'Diamonds'),
  Card.new(10,      'Clubs'),
  Card.new('Ace',   'Hearts'),
  Card.new('Jack',  'Clubs')
])
puts hand.evaluate == 'Straight'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(6, 'Diamonds')
])
puts hand.evaluate == 'Three of a kind'

hand = PokerHand.new([
  Card.new(9, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(8, 'Spades'),
  Card.new(5, 'Hearts')
])
puts hand.evaluate == 'Two pair'

hand = PokerHand.new([
  Card.new(2, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(9, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Pair'

hand = PokerHand.new([
  Card.new(2,      'Hearts'),
  Card.new('King', 'Clubs'),
  Card.new(5,      'Diamonds'),
  Card.new(9,      'Spades'),
  Card.new(3,      'Diamonds')
])
puts hand.evaluate == 'High card'
