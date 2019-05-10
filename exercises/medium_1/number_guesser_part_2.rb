class GuessingGame
  def initialize(lower_bound, upper_bound)
    @lower_bound = lower_bound
    @upper_bound = upper_bound
    @range = (@lower_bound..@upper_bound)
    @secret_number = rand(@range)
    @guesses_remaining = calculate_max_guesses
  end

  def play
    display_welcome_message
    loop do
      display_guesses_remaining
      submit_guess
      compare_guess_to_secret_number
      decrement_guesses_remaining unless player_won?
      break if player_won? || @guesses_remaining.zero?
    end
    display_result
  end

  private

  def calculate_max_guesses
    Math.log2(@upper_bound - @lower_bound).to_i + 1
  end

  def display_welcome_message
    puts "Welcome to the number guessing game."
    puts "You have #{@guesses_remaining} guesses to find the secret number between #{@lower_bound} and #{@upper_bound}."
    puts "Good luck!"
  end

  def display_guesses_remaining
    puts ''
    if @guesses_remaining == 1
      puts "You have 1 guess remaining."
    else
      puts "You have #{@guesses_remaining} remaining."
    end
  end

  def submit_guess
    print "Enter an number between #{@lower_bound} and #{@upper_bound} (inclusive): "

    answer = nil
    loop do
      answer = gets.chomp.to_i
      break if @range.cover?(answer)
      print "Invalid guess. Enter an number between #{@lower_bound} and #{@upper_bound} (inclusive): "
    end

    @player_guess = answer
  end

  def compare_guess_to_secret_number
    case @player_guess
    when @secret_number then return
    when (@secret_number + 1..@upper_bound) then puts "Your guess is too high."
    else
      puts "Your guess is too low."
    end
  end

  def player_won?
    @player_guess == @secret_number
  end

  def decrement_guesses_remaining
    @guesses_remaining -= 1
  end

  def display_result
    puts(player_won? ? "You won!" : "You have no more guesses. You lost!")
  end
end

game = GuessingGame.new(1, 200)
game.play

# Given solution
class GuessingGame
  RESULT_OF_GUESS_MESSAGE = {
    high:  "Your number is too high.",
    low:   "Your number is too low.",
    match: "That's the number!"
  }.freeze

  WIN_OR_LOSE = {
    high:  :lose,
    low:   :lose,
    match: :win
  }.freeze

  RESULT_OF_GAME_MESSAGE = {
    win:  "You won!",
    lose: "You have no more guesses. You lost!"
  }.freeze

  def initialize(low, high)
    @range = low..high
    @max_guesses = Math.log2(high - low + 1).to_i + 1
    @secret_number = nil
  end

  def play
    reset
    game_result = play_game
    display_game_end_message(game_result)
  end

  private

  def reset
    @secret_number = rand(@range)
  end

  def play_game
    result = nil
    @max_guesses.downto(1) do |remaining_guesses|
      display_guesses_remaining(remaining_guesses)
      result = check_guess(obtain_one_guess)
      puts RESULT_OF_GUESS_MESSAGE[result]
      break if result == :match
    end
    WIN_OR_LOSE[result]
  end

  def display_guesses_remaining(remaining)
    puts
    if remaining == 1
      puts 'You have 1 guess remaining.'
    else
      puts "You have #{remaining} guesses remaining."
    end
  end

  def obtain_one_guess
    loop do
      print "Enter a number between #{@range.first} and #{@range.last}: "
      guess = gets.chomp.to_i
      return guess if @range.cover?(guess)
      print "Invalid guess. "
    end
  end

  def check_guess(guess_value)
    return :match if guess_value == @secret_number
    return :low if guess_value < @secret_number
    :high
  end

  def display_game_end_message(result)
    puts '', RESULT_OF_GAME_MESSAGE[result]
  end
end

game = GuessingGame.new(1, 200)
game.play
