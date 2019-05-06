module Hand
  BLACKJACK = 21

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
    total > BLACKJACK
  end

  def total
    values = cards.map(&:value)

    sum = 0
    values.each do |value|
      sum += if value.match?(/Ace/)
               11
             elsif value.match?(/(King|Queen|Jack)/)
               10
             else
               value.to_i
             end
    end

    values.count('Ace').times do
      sum -= 10 if sum > BLACKJACK
    end

    sum
  end
end

class Participant
  include Hand

  attr_accessor :cards, :score
  attr_reader :referred_to_as

  def initialize
    @cards = []
    @score = 0
  end
end

class Player < Participant
  def initialize
    @referred_to_as = 'Your'
    super
  end

  def hit!(deck)
    cards << deck.deal_card
    puts 'You chose to hit!'
    display_hand
  end

  def stay
    puts "You stayed at #{total}."
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

  def take_turn(deck)
    loop do
      choice = choose_hit_or_stay
      hit!(deck) if %w(h hit).include?(choice)
      break if %w(s stay).include?(choice) || busted?
    end

    stay unless busted?
  end
end

class Dealer < Participant
  DEALER_MIN_SCORE = 17

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

  def hit!(deck)
    cards << deck.deal_card
    puts 'Dealer hits!'
    display_hand
  end

  def stay
    puts "Dealer stayed at #{total}."
  end

  def take_turn(deck)
    puts ''
    puts "Now it's the dealer's turn..."

    loop do
      break if total >= DEALER_MIN_SCORE
      hit!(deck)
    end

    stay unless busted?
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
    when 'H' then 'Hearts'
    when 'D' then 'Diamonds'
    when 'S' then 'Spades'
    when 'C' then 'Clubs'
    end
  end

  def value
    case @value
    when 'A' then 'Ace'
    when 'K' then 'King'
    when 'Q' then 'Queen'
    when 'J' then 'Jack'
    else @value
    end
  end

  def to_s
    "#{value} of #{suit}"
  end
end

class Game
  WINNING_SCORE = 5

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
      play_round
      display_game_result if someone_won?
      break if someone_won? || !play_again?
      reset
    end

    display_goodbye_message
  end

  private

  def display_welcome_message
    puts '***************************************************'
    puts ''
    puts 'Hello and welcome to 21!'
    puts "The first player to #{WINNING_SCORE} points is the overall winner."
    puts "Let's see if you can beat the dealer!"
    puts 'Good luck!!'
    puts ''
    puts '***************************************************'
    puts ''
    sleep(3.5)
  end

  def setup_round
    shuffle_the_deck
    deal_initial_cards
    display_score
    display_initial_cards
  end

  def add_point
    player.score += 1 if [:player, :dealer_busted].include?(round_result)
    dealer.score += 1 if [:dealer, :player_busted].include?(round_result)
  end

  def play_round
    setup_round
    player.take_turn(deck)
    dealer.take_turn(deck) unless player.busted?
    add_point
    display_round_result
  end

  def display_spinner
    5.times do
      ["-", "\\", "|", "/"].each do |symbol|
        print symbol
        sleep(0.065)
        print "\b"
      end
    end
  end

  def shuffle_the_deck
    print "Shuffling the deck... "
    display_spinner
    puts ''
    puts ''
  end

  def display_dealing_cards_message
    print "Dealing the cards... "
    display_spinner
    puts ''
    puts ''
  end

  def deal_initial_cards
    display_dealing_cards_message

    2.times do
      player.cards << deck.deal_card
      dealer.cards << deck.deal_card
    end
  end

  def display_score
    clear_screen
    puts '##### Current score #####'
    puts "You: #{player.score}"
    puts "Dealer: #{dealer.score}"
    puts '#########################'
    puts ''
  end

  def display_initial_cards
    player.display_hand
    dealer.display_initial_hand
  end

  def player_round_score
    player.total
  end

  def dealer_round_score
    dealer.total
  end

  def round_result
    if player.busted?
      :player_busted
    elsif dealer.busted?
      :dealer_busted
    elsif player_round_score > dealer_round_score
      :player
    elsif dealer_round_score > player_round_score
      :dealer
    else
      :tie
    end
  end

  def display_round_result
    result = round_result

    case result
    when :player_busted then puts 'Player busted -> Dealer wins!'
    when :dealer_busted then puts 'Dealer busted -> Player wins!'
    when :player then puts 'Player is the winner!!'
    when :dealer then puts 'Dealer is the winner!!'
    else puts "It's a tie!"
    end
  end

  def someone_won?
    player.score == WINNING_SCORE || dealer.score == WINNING_SCORE
  end

  def display_game_result
    puts "And we have a winner!"
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
