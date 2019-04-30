class Board
  def initialize
    # We'll need a way to model the 3x3 grid. Maybe squares?
    # What data structure should we use?
    #    - an array/hash of Square objects?
    #    - an array/hash of strings or integers
  end
end

class Square
  def initialize
    # maybe a 'status' to keep track of this square's mark?
  end
end

class Player
  def initialize
    # maybe a 'marker' to keep track of the player's symbol (X or O)
  end
  
  def mark
  end
end

class TTTGame
  def play
    display_welcome_message
    loop do
      display_board
      first_player_moves
      break if winner? || board_full?
      
      display_board
      second_player_moves
      break if winner? || board_full?
    end
    display_result 
    display_goodbye_message
  end
end

game = TTTGame.new
game.play
