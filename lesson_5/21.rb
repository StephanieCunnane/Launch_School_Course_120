module Hand
  def busted?
  end

  def total
    # we need to know about cards to produce some total
  end
end

class Participant
  include Hand

  def initialize
    @cards = []
    @total = 0
  end
end

class Player < Participant
  def hit
  end

  def stay
  end
end

class Dealer < Participant
  def hit
  end

  def stay
  end
end

class Deck
  def initialize
    @cards = build_deck
  end

  def build_deck
    combos = Card::SUITS.product(Card::VALUES)
    combos.map! do |suit, value|
      Card.new(suit, value)
    end
    combos.shuffle
  end

  def deal
    # who deals - the dealer or the deck?
  end
end

class Card
  SUITS = %w(H D S C)
  VALUES = %w(2 3 4 5 6 7 8 9 10 J Q K A)

  def initialize(suit, value)
    @suit = suit
    @value = value
  end
end

class Game
  def initialize
    @player = Player.new
    @dealer = Dealer.new
    @deck = Deck.new
  end

  def start
   #deal_cards
   #display_initial_cards
   #player_turn
   #dealer_turn
   #display_result
  end
end

game = Game.new
