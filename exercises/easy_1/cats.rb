class Pet
  def initialize(name, age)
    @name = name
    @age = age
  end
end

class Cat < Pet
  attr_reader :name, :age, :color
  
  def initialize(name, age, color)
    super(name, age)
    @color = color
  end
  
  def to_s
    "My cat #{name} is #{age} years old and has #{color} fur."
  end
end

pudding = Cat.new("Pudding", 7, "black and white")
butterscotch = Cat.new("Butterscotch", 10, "tan and yellow")
puts pudding, butterscotch

# I chose to keep the @color instance variable in the Cat class rather than moving
# it up to the superclass, in the spirit of keeping superclasses as flexible/general 
# as possible and pushing specifics down to the subclasses. We don't know that color
# will be a meaningful attribute for all subclasses of Pet, and we also don't want to 
# break our existing subclasses.
