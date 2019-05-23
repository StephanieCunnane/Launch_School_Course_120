class Deck
  RANKS = ((2..10).to_a + %w(Jack Queen King Ace)).freeze
  SUITS = %w(Hearts Clubs Diamonds Spades).freeze
  
  attr_accessor :cards
  
  def initialize
    @cards = build_deck
  end
  
  def draw
    self.cards = build_deck if cards.empty?
    cards.pop
  end
  
  private
  
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

# Improved implementation
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

# Given solution
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

deck = Deck.new
drawn = []
52.times { drawn << deck.draw }
p drawn.count { |card| card.rank == 5 } == 4
p drawn.count { |card| card.suit == 'Hearts' } == 13

drawn2 = []
52.times { drawn2 << deck.draw }
puts drawn != drawn2
