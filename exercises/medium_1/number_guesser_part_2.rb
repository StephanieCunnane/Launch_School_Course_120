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
