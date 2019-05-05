module Hand
  def display_cards
    puts "#{referred_to_as} cards: "
    cards.each do |card|
      puts " - #{card}"
    end
    puts ''
    puts "Hand total: #{total(cards)}"
    puts ''
  end

  def busted?
  end

  def total(cards)
    values = cards.map(&:value)

    sum = 0
    values.each do |value|
      sum += if value.match?(/ace/)
               11
             elsif value.match?(/(king|queen|jack)/)
               10
             else
               value.to_i
             end
    end

    values.count('A').times do
      sum -= 10 if sum > 21
    end

    sum
  end
end

class Participant
  include Hand

  attr_reader :cards, :referred_to_as

  def initialize
    @cards = []
  end
end

class Player < Participant
  def initialize
    @referred_to_as = 'Your'
    super
  end

  def hit
  end

  def stay
  end
end

class Dealer < Participant
  def initialize
    @referred_to_as = "Dealer's"
    super
  end

  def display_initial_cards
    puts "Dealer's cards: "
    puts " - #{cards[0]}"
    puts ' - ?'
    puts ''
  end

  def hit
  end

  def stay
  end
end

class Deck
  attr_reader :cards

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

  def deal_card
    cards.pop
  end
end

class Card
  SUITS = %w(H D S C)
  VALUES = %w(2 3 4 5 6 7 8 9 10 J Q K A)

  def initialize(suit, value)
    @suit = suit
    @value = value
  end

  def suit
    case @suit
    when 'H' then 'hearts'
    when 'D' then 'diamonds'
    when 'S' then 'spades'
    when 'C' then 'clubs'
    end
  end

  def value
    case @value
    when 'A' then 'ace'
    when 'K' then 'king'
    when 'Q' then 'queen'
    when 'J' then 'jack'
    else @value
    end
  end

  def to_s
    "the #{value} of #{suit}"
  end
end

class Game
  attr_reader :player, :dealer, :deck

  def initialize
    @player = Player.new
    @dealer = Dealer.new
    @deck = Deck.new
  end

  def start
    clear
    display_welcome_message
    deal_cards
    display_initial_cards
    player_turn
    #dealer_turn
    #display_result
    display_goodbye_message
  end

  private

  def clear
    system('clear') || system('cls')
  end

  def display_welcome_message
    puts '***************************************************'
    puts 'Hello and welcome to 21!'
    puts "Let's see if you can beat the dealer!"
    puts 'Good luck!!'
    puts '***************************************************'
    puts ''
  end

  def display_initial_cards
    player.display_cards
    dealer.display_initial_cards
  end

  def choose_hit_or_stay
    choice = nil
    loop do
      puts 'Would you like to (h)it or (s)tay?'
      choice = gets.chomp.downcase
      break if %w(h hit s stay).include?(choice)
      puts "Sorry, must enter 'h'or 's'."
    end
    choice
  end

  def player_turn
    loop do
      choice = choose_hit_or_stay

      if %w(h hit).include?(choice)
        player.cards << deck.deal_card
        puts 'You chose to hit!'
        player.display_cards
      end

      break if %w(s stay).include?(choice)
    end
  end

  def display_goodbye_message
    puts ""
    puts "That's enough 21 for now!"
    puts 'Thanks for playing! Goodbye!'
  end

  def deal_cards
    2.times do
      player.cards << deck.deal_card
      dealer.cards << deck.deal_card
    end
  end
end

game = Game.new
game.start
