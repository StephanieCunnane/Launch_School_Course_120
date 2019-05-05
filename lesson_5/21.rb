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
  SUITS = %w(H D S C)
  VALUES = %w(2 3 4 5 6 7 8 9 10 J Q K A)
  
# I think it's a little weird to have a Deck object with a state of @deck. I have to either leave this or create another label. 
  def initialize
    @deck = build_deck
  end
  
  def build_deck
    combos = SUITS.product(VALUES)
    combos.map! do |combo|
      Card.new(combo)
    end
    combos.shuffle
  end
  
  def deal
    # who deals - the dealer or the deck?
  end
end

class Card
  # I think it's a litle weird to have a Card object with a state of @card
  def initialize(suit_and_value_combo)
    @card = suit_and_value_combo
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
game.start
