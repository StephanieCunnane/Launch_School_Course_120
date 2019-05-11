# As originally written, the use of super in Songbird#initialize raises an ArgumentError. This is because super with no arguments and no empty parens passes up ALL the arguments given to its enclosing method. In this case it's 3 arguments, but the next initialize method in the method lookup chain is Animal#initialize, which only takes 2 arguments. We can fix this by explicitly giving 2 arguments to super.

class Animal
  def initialize(diet, superpower)
    @diet = diet
    @superpower = superpower
  end
  
  def move
    puts "I'm moving!"
  end
  
  def superpower
    puts "I can #{@superpower}!"
  end
end

class Fish < Animal
  def move
    puts "I'm swimming!"
  end
end

class Bird < Animal
end

class FlightlessBird < Bird
  def move
    puts "I'm running!"
  end
end

class SongBird < Bird
  def initialize(diet, superpower, song)
    super(diet, superpower)
    @song = song
  end
  
  def move
    puts "I'm flying!"
  end
end

unicornfish = Fish.new(:herbivore, 'breathe underwater')
penguin = FlightlessBird.new(:carnivore, 'drink sea water')
robin = SongBird.new(:omnivore, 'sing', 'chirp chirrr chirp chirp chirrrr')
