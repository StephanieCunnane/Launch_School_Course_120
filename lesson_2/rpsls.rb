module Displayable
  def display_welcome_message
    puts "****************************************************"
    puts "Welcome to Rock, Paper, Scissors, Lizard, Spock!"
    puts "The first player to #{RPSLSGame::WINNING_SCORE} " \
          "points is the overall winner."
    puts "Good luck!!"
    puts "****************************************************"
    puts
  end

  def display_moves
    puts "#{human.name} chose #{human.move}, " \
         "#{computer.name} chose #{computer.move}."
  end

  def display_round_winner
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

  def display_history
    puts
    puts "Moves so far:"
    summarize_moves
    puts
  end

  def display_round_wrapup
    display_moves
    display_round_winner
    display_score
    display_history
  end

  def display_game_winner
    if human.score > computer.score
      puts "#{human.name} is the overall winner!"
    else
      puts "#{computer.name} is the overall winner!"
    end
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors, Lizard, Spock. Goodbye!"
  end

  def clear_screen
    system('clear') || system('cls')
  end
end

class Move
  VALUES = {
    'rock'     => 'rock',
    'r'        => 'rock',
    'paper'    => 'paper',
    'p'        => 'paper',
    'scissors' => 'scissors',
    'sc'       => 'scissors',
    'lizard'   => 'lizard',
    'l'        => 'lizard',
    'spock'    => 'spock',
    'sp'       => 'spock'
  }

  WINNING_MOVES = {
    'rock'     => ['scissors', 'lizard'],
    'paper'    => ['rock', 'spock'],
    'scissors' => ['lizard', 'paper'],
    'lizard'   => ['paper', 'spock'],
    'spock'    => ['scissors', 'rock']
  }

  def initialize(value)
    @value = value
  end

  def >(other_move)
    WINNING_MOVES[@value].include?(other_move.to_s)
  end

  def to_s
    @value
  end
end

class Player
  attr_accessor :move, :name, :score, :move_history

  def initialize
    @score = 0
    @move_history = []
    set_name
  end
end

class Human < Player
  def choose
    choice = nil
    loop do
      puts
      puts "Please choose rock, paper, scissors, lizard or spock:"
      choice = gets.chomp.downcase
      puts
      break if Move::VALUES.keys.include?(choice)
      puts "Sorry, invalid choice."
    end
    self.move = Move.new(Move::VALUES[choice])
    move_history << move
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
    move_history << move
  end

  private

  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end
end

class GameHistory
  def initialize
    @history = {}
  end
end

class RPSLSGame
  include Displayable

  WINNING_SCORE = 5

  attr_accessor :human, :computer, :rounds_completed, :round_winner

  def initialize
    display_welcome_message
    @human = Human.new
    @computer = Computer.new
    @rounds_completed = 0
    @round_winner = nil
    @history = GameHistory.new
  end

  def play
    loop do
      human.choose
      computer.choose
      determine_round_winner
      add_point
      clear_screen
      increment_rounds_completed
      display_round_wrapup
      display_game_winner if overall_winner?
      break if overall_winner?
      play_again? if overall_winner?
    end
    display_goodbye_message
  end

  private

  def determine_round_winner
    self.round_winner = nil
    self.round_winner = human if human.move > computer.move
    self.round_winner = computer if computer.move > human.move
  end

  def add_point
    human.score += 1 if round_winner == human
    computer.score += 1 if round_winner == computer
  end

  def increment_rounds_completed
    self.rounds_completed += 1
  end

  def summarize_moves
    1.upto(human.move_history.size) do |round|
      puts "#{round}. #{human.name}: #{human.move_history[round - 1]} | " \
           "#{computer.name}: #{computer.move_history[round - 1]}"
    end
  end

  def overall_winner?
    human.score == WINNING_SCORE || computer.score == WINNING_SCORE
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
end

RPSLSGame.new.play
