class Move
  VALUES = {
    'rock'     => 'rock',
    'r'        => 'rock',
    'paper'    => 'paper',
    'p'        => 'paper',
    'scissors' => 'scissors',
    's'        => 'scissors'
  }

  def initialize(value)
    @value = value
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def scissors?
    @value == 'scissors'
  end

  def >(other_move)
    (rock? && other_move.scissors?) ||
      (paper? && other_move.rock?) ||
      (scissors? && other_move.paper?)
  end

  def <(other_move)
    (rock? && other_move.paper?) ||
      (paper? && other_move.scissors?) ||
      (scissors? && other_move.rock?)
  end

  def to_s
    @value
  end
end

class Player
  attr_accessor :move, :name, :score

  def initialize
    @score = 0
    set_name
  end
end

class Human < Player
  def choose
    choice = nil
    loop do
      puts
      puts "Please choose rock, paper or scissors:"
      choice = gets.chomp.downcase
      puts
      break if Move::VALUES.keys.include?(choice)
      puts "Sorry, invalid choice."
    end
    self.move = Move.new(Move::VALUES[choice])
  end

  private

  def set_name
    n = ""
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.gsub(/\s+/, '').empty?
      puts "Sorry, must enter a value."
    end
    self.name = n.strip
  end
end

class Computer < Player
  def choose
    self.move = Move.new(Move::VALUES.values.sample)
  end

  private

  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end
end

class RPSGame
  WINNING_SCORE = 10

  attr_accessor :human, :computer, :round_winner

  def initialize
    display_welcome_message
    @human = Human.new
    @computer = Computer.new
    @round_winner = nil
  end

  def play
    loop do
      human.choose
      computer.choose
      determine_round_winner
      add_point
      display_round_wrapup
      display_score
      display_game_winner if overall_winner?
      break if overall_winner? || !play_again?
      clear_screen
    end
    display_goodbye_message
  end

  private

  def display_welcome_message
    puts "****************************************************"
    puts "Welcome to Rock, Paper, Scissors!"
    puts "The first player to 10 points is the overall winner."
    puts "Good luck!!"
    puts "****************************************************"
    puts
  end

  def determine_round_winner
    self.round_winner = nil
    self.round_winner = human if human.move > computer.move
    self.round_winner = computer if computer.move > human.move
  end

  def add_point
    human.score += 1 if round_winner == human
    computer.score += 1 if round_winner == computer
  end

  def display_round_wrapup
    puts "#{human.name} chose #{human.move}, " \
         "#{computer.name} chose #{computer.move}."

    if round_winner
      puts "#{round_winner.name} won this round!"
    else
      puts "It's a tie!"
    end
  end

  def display_score
    puts
    puts "Current score"
    puts "#{human.name}: #{human.score}"
    puts "#{computer.name}: #{computer.score}"
    puts
  end

  def overall_winner?
    human.score == WINNING_SCORE || computer.score == WINNING_SCORE
  end

  def display_game_winner
    if human.score > computer.score
      puts "#{human.name} is the overall winner!"
    else
      puts "#{computer.name} is the overall winner!"
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if ['y', 'n', 'yes', 'no'].include?(answer)
      puts "Sorry, must be y or n."
    end
    ['y', 'yes'].include?(answer)
  end

  def clear_screen
    system('clear') || system('cls')
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors. Goodbye!"
  end
end

RPSGame.new.play
