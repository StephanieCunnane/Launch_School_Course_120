module Hand
  def display_hand
    puts "#{referred_to_as} cards: "
    cards.each do |card|
      puts " - #{card}"
    end
    puts ''
    puts "Hand total: #{total}"
    puts ''
  end

  def busted?
    total > 21
  end

  def total
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

  attr_accessor :cards
  attr_reader :referred_to_as

  def initialize
    @cards = []
  end
end

class Player < Participant
  def initialize
    @referred_to_as = 'Your'
    super
  end

  def hit(deck)
    cards << deck.deal_card
    puts 'You chose to hit!'
    display_hand
  end

  def stay
    puts "You stayed at #{total}."
  end
end

class Dealer < Participant
  def initialize
    @referred_to_as = "Dealer's"
    super
  end

  def display_initial_hand
    puts "Dealer's cards: "
    puts " - #{cards[0]}"
    puts ' - ?'
    puts ''
  end

  def hit(deck)
    cards << deck.deal_card
    puts 'Dealer hits!'
    display_hand
  end

  def stay
    puts "Dealer stayed at #{total}."
  end
end

class Deck
  attr_reader :cards

  def initialize
    @cards = build_deck
  end

  def build_deck
    combos = Card::SUITS.product(Card::VALUES)
    combos.map! { |suit, value| Card.new(suit, value) }
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
  attr_accessor :deck
  attr_reader :player, :dealer

  def initialize
    @player = Player.new
    @dealer = Dealer.new
    @deck = Deck.new
  end

  def start
    display_welcome_message

    loop do
      shuffle_the_deck
      deal_initial_cards
      display_initial_cards
      player_turn
      dealer_turn unless player.busted?
      display_result
      break unless play_again?
      reset
    end

    display_goodbye_message
  end

  private

  def display_welcome_message
    puts '***************************************************'
    puts 'Hello and welcome to 21!'
    puts "Let's see if you can beat the dealer!"
    puts 'Good luck!!'
    puts '***************************************************'
    puts ''
  end

  def spinning
    10.times do
      ["-", "\\", "|", "/"].each do |symbol|
        print symbol
        sleep(0.1)
        print "\b"
      end
    end
  end

  def shuffle_the_deck
    print "Shuffling the deck... "
    spinning
    puts ''
    puts ''
  end

  def deal_initial_cards
    2.times do
      player.cards << deck.deal_card
      dealer.cards << deck.deal_card
    end
  end

  def display_initial_cards
    player.display_hand
    dealer.display_initial_hand
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
      player.hit(deck) if %w(h hit).include?(choice)
      break if %w(s stay).include?(choice) || player.busted?
    end

    player.stay unless player.busted?
  end

  def dealer_turn
    puts ''
    puts "Now it's the dealer's turn..."

    loop do
      break if dealer.total >= 17
      dealer.hit(deck)
    end

    dealer.stay unless dealer.busted?
  end

  def player_final_score
    player.total
  end

  def dealer_final_score
    dealer.total
  end

  def display_result
    if player.busted?
      puts 'Player busted -> Dealer wins!'
    elsif dealer.busted?
      puts 'Dealer busted -> Player wins!'
    elsif player_final_score > dealer_final_score
      puts 'Player is the winner!!'
    elsif dealer_final_score > player_final_score
      puts 'Dealer is the winner!!'
    else
      puts "It's a tie!"
    end
  end

  def play_again?
    puts '-------------'
    puts 'Do you want to play again? (y or n)'
    answer = gets.chomp.downcase
    answer == 'y' || answer == 'yes'
  end

  def clear_screen
    system('clear') || system('cls')
  end

  def reset
    clear_screen
    player.cards = []
    dealer.cards = []
    self.deck = Deck.new
  end

  def display_goodbye_message
    puts ""
    puts "That's enough 21 for now!"
    puts 'Thanks for playing! Goodbye!'
  end
end

Game.new.start
