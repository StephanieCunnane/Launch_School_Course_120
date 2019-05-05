class Player
  def initialize
    # what would the data/states of a Player object be?
    # what is important to track about the player?
    # cards? current_total? busted? name?
  end
  
  def hit
  end
  
  def stay
  end
  
  def busted?
  end
  
  def total
    # we need to know about cards to produce some total
  end
end

class Dealer
  def initialize
    # will be very similar to Player -> do we need this? 
    # make Participant the superclass?
  end
  
  def deal
    # who deals - the dealer or the deck?
  end
  
  def hit
  end
  
  def stay
  end
  
  def busted?
  end
  
  def total
  end
end

class Participant
  # Move the shared behaviors from Player and Dealer here?
  # Or do away with this class in favor of a Hand module?
end

class Deck
  def initialize
    # we need a data structure to keep track of the cards
    # probably an array of Card objects
  end
  
  def deal
    # who deals - the dealer or the deck?
  end
end

class Card
  def initialize
    # what are the states of a Card object?
    # @suit -> string
    # @value -> string
    # Card data structure -> [@value, @suit]
  end
end

class Game
  def initialize
    # what objects collaborate with the Game class?
    # @player
    # @dealer
    # @deck
  end
  
  def start
    deal_cards
    display_initial_cards
    player_turn
    dealer_turn
    display_result
  end
end

Game.new.start
