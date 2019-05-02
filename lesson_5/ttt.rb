class Board
  MOST_STRATEGIC_POSITION = 5
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  def initialize
    @squares = {}
    reset
  end

  def []=(num, marker)
    @squares[num].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def offensive_move
    WINNING_LINES.each do |line|
      computer_markers = @squares.select do |k, v|
        line.include?(k) && v.marker == TTTGame::COMPUTER_MARKER
      end
      unmarked_squares = @squares.values_at(*line).select(&:unmarked?)

      if computer_markers.size == 2 && unmarked_squares.size == 1
        return (line - computer_markers.keys).first
      end
    end

    nil
  end

  def defensive_move
    WINNING_LINES.each do |line|
      human_markers = @squares.select do |k, v|
        line.include?(k) && v.marker == TTTGame::HUMAN_MARKER
      end
      unmarked_squares = @squares.values_at(*line).select(&:unmarked?)

      if human_markers.size == 2 && unmarked_squares.size == 1
        return (line - human_markers.keys).first
      end
    end

    nil
  end

  def strategic_position
    MOST_STRATEGIC_POSITION if unmarked_keys.include?(MOST_STRATEGIC_POSITION)
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  # rubocop:disable Metrics/AbcSize
  def draw
    puts '     |     |'
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts '     |     |'
    puts '-----+-----+-----'
    puts '     |     |'
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts '     |     |'
    puts '-----+-----+-----'
    puts '     |     |'
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts '     |     |'
  end
  # rubocop:enable Metrics/AbcSize

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).map(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end
end

class Square
  INITIAL_MARKER = ' '

  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def marked?
    marker != INITIAL_MARKER
  end

  def unmarked?
    marker == INITIAL_MARKER
  end
end

class Player
  attr_reader :marker
  attr_accessor :score

  def initialize(marker)
    @marker = marker
    @score = 0
  end
end

class TTTGame
  HUMAN_MARKER = 'X'
  COMPUTER_MARKER = 'O'
  FIRST_MOVER = 'choose'
  WINNING_SCORE = 3

  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
    @current_marker = FIRST_MOVER
    prepare_game
  end

  def play
    loop do
      display_board

      loop do
        current_player_moves
        break if board.someone_won? || board.full?
        clear_screen_and_display_board if human_turn?
      end

      round_wrapup
      break if game_won? || !play_again?
      reset
      display_play_again_message
    end

    display_goodbye_message
  end

  private

  def prepare_game
    clear
    display_welcome_message
    determine_first_mover if FIRST_MOVER == 'choose'
  end

  def display_welcome_message
    puts "***************************************************"
    puts "Welcome to Tic Tac Toe!"
    puts "The first player to #{WINNING_SCORE} points is the overall winner."
    puts "Good luck!!"
    puts "***************************************************"
    puts
  end

  def user_first_mover_choice
    loop do
      puts "Who should go first? ((m)e, (c)omputer, or (e)ither)"
      answer = gets.chomp.downcase
      return answer if %w(m me c computer e either).include?(answer)
      puts "Sorry, that's an invalid answer."
    end
  end

  def determine_first_mover
    answer = user_first_mover_choice
    @current_marker = case answer
                      when 'm', 'me' then HUMAN_MARKER
                      when 'c', 'computer' then COMPUTER_MARKER
                      else [HUMAN_MARKER, COMPUTER_MARKER].sample
                      end
  end

  def display_goodbye_message
    puts "And #{game_winner} the overall winner - congratulations!" if game_won?
    puts 'Thanks for playing Tic Tac Toe! Goodbye!'
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def display_board
    puts "You're an #{human.marker}. Computer is an #{computer.marker}."
    puts "The current score is:"
    puts "Human: #{human.score}"
    puts "Computer: #{computer.score}"
    puts ''
    board.draw
    puts ''
  end

  def human_turn?
    @current_marker == HUMAN_MARKER
  end

  def joinor(arr, delimiter=', ', joining_word='or')
    case arr.size
    when 1 then arr.first
    when 2 then arr.join(" #{joining_word} ")
    else
      arr[-1] = "#{joining_word} #{arr.last}"
      arr.join(delimiter)
    end
  end

  def human_moves
    puts "Choose a square (#{joinor(board.unmarked_keys)}): "
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end

    board[square] = human.marker
  end

  def computer_moves
    square = board.offensive_move ||
             board.defensive_move ||
             board.strategic_position ||
             board.unmarked_keys.sample

    board[square] = computer.marker
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_marker = COMPUTER_MARKER
    else
      computer_moves
      @current_marker = HUMAN_MARKER
    end
  end

  def add_point
    human.score += 1 if board.winning_marker == HUMAN_MARKER
    computer.score += 1 if board.winning_marker == COMPUTER_MARKER
  end

  def game_won?
    human.score == WINNING_SCORE || computer.score == WINNING_SCORE
  end

  def game_winner
    human.score > computer.score ? 'you are' : 'computer is'
  end

  def round_wrapup
    add_point
    display_result
  end

  def display_result
    clear_screen_and_display_board

    case board.winning_marker
    when human.marker
      puts 'You won!'
    when computer.marker
      puts 'Computer won!'
    else
      puts "It's a tie!"
    end
  end

  def play_again?
    answer = nil
    loop do
      puts 'Would you like to play again? (y/n)'
      answer = gets.chomp.downcase
      break if %w(y n yes no).include?(answer)
      puts 'Sorry, must be y or n.'
    end

    answer == 'y' || answer == 'yes'
  end

  def clear
    system('clear') || system('cls')
  end

  def reset
    board.reset
    @current_marker = FIRST_MOVER
    clear
  end

  def display_play_again_message
    puts "Let's play again!"
    puts ''
  end
end

game = TTTGame.new
game.play
