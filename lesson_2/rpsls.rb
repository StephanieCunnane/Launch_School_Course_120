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
    prompt("#{human.name} chose #{human.move}, " \
         "#{computer.name} chose #{computer.move}.")
  end

  def display_round_winner
    if round_winner
      prompt("#{round_winner.name} won this round!")
    else
      prompt("It's a tie!")
    end
  end

  def display_score
    puts
    prompt("Current score")
    prompt("#{human.name}: #{human.score}")
    prompt("#{computer.name}: #{computer.score}")
    puts
  end

  def display_history
    prompt("Moves so far:")
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
    prompt("Thanks for playing Rock, Paper, Scissors, Lizard, Spock. Goodbye!")
  end

  def prompt(msg)
    puts "==> #{msg}"
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

  attr_reader :value

  def initialize(value)
    @value = value
  end

  def >(other_move)
    WINNING_MOVES[value].include?(other_move.to_s)
  end

  def to_s
    @value
  end
end

class Player
  include Displayable

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
      prompt("Please choose (r)ock, (p)aper, (sc)issors, (l)izard or (sp)ock:")
      choice = gets.chomp.downcase
      puts
      break if Move::VALUES.keys.include?(choice)
      prompt("Sorry, invalid choice.")
    end
    self.move = Move.new(Move::VALUES[choice])
    move_history << move
  end

  private

  def set_name
    n = ""
    loop do
      prompt("What's your name?")
      n = gets.chomp
      break unless n.gsub(/\s+/, '').empty?
      prompt("Sorry, must enter a value.")
    end
    self.name = n.strip
  end
end

class Computer < Player
  def choose
    apply_weighting
    move_history << move
  end

  private

  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def last_two_moves_same?
    move_history.size >= 2 &&
      move_history.last(2).map(&:value).uniq.size == 1
  end

  def apply_weighting
    last_two_moves_same? ? weighted_choose : unweighted_choose
  end

  def idx_of_repeated_move
    Move::VALUES.values.uniq.index(move_history.last.to_s)
  end

  def build_weights_arr
    initial_weights = [0.2, 0.2, 0.2, 0.2, 0.2]
    weights = Array.new(5, (1.0 / (initial_weights.size - 1)))
    weights[idx_of_repeated_move] = 0
    weights
  end

  def weighted_sample(weights)
    pool = []
    element_occurrences = weights.map { |weight| (weight * 100).to_i }
    temp = element_occurrences.zip(Move::VALUES.values.uniq)
    temp.each do |occurrences, move_value|
      occurrences.times { pool << Move.new(move_value) }
    end
    pool.sample
  end

  def weighted_choose
    self.move = weighted_sample(build_weights_arr)
  end

  def unweighted_choose
    self.move = Move.new(Move::VALUES.values.sample)
  end
end

class RPSLSGame
  include Displayable

  WINNING_SCORE = 10

  attr_accessor :human, :computer, :rounds_completed, :round_winner, :history

  def initialize
    display_welcome_message
    @human = Human.new
    @computer = Computer.new
    @rounds_completed = 0
    @round_winner = nil
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
      next unless overall_winner?
      break if end_game?
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

  def reset
    self.rounds_completed = 0
    human.score = 0
    human.move_history = []
    computer.score = 0
    computer.move_history = []
  end

  def end_game?
    if play_again?
      reset
      return false
    end
    true
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
