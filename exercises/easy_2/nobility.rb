module Walkable
  def walk
    "#{name} #{gait} forward"
  end
end

class Person
  include Walkable
  
  attr_reader :name

  def initialize(name)
    @name = name
  end

  private

  def gait
    "strolls"
  end
end

class Noble < Person
  attr_reader :name, :title
  
  def initialize(name, title)
    @name = name
    @title = title
  end
  
  def walk
    "#{title} #{name} struts forward"
  end
end

class Cat
  include Walkable
  
  attr_reader :name

  def initialize(name)
    @name = name
  end

  private

  def gait
    "saunters"
  end
end

class Cheetah < Cat
  private

  def gait
    "runs"
  end
end

mike = Person.new("Mike")
p mike.walk

kitty = Cat.new("Kitty")
p kitty.walk

flash = Cheetah.new("Flash")
p flash.walk

noble = Noble.new("Byron", "Lord")
p noble.walk

# Cleaner implementation
module Walkable
  def walk
    "#{name} #{gait} forward"
  end
end

class Person
  include Walkable
  
  attr_reader :name
  
  def initialize(name)
    @name = name
  end
  
  private
  
  def gait
    'strolls'
  end
end

class Noble < Person
  attr_reader :title
  
  def initialize(name, title)
    super(name)
    @title = title
  end
  
  def walk
    "#{title} " + super
  end
  
  private
  
  def gait
    'struts'
  end
end

class Cat
  include Walkable
  
  attr_reader :name
  
  def initialize(name)
    @name = name
  end
  
  private
  
  def gait
    'saunters'
  end
end

class Cheetah < Cat
  private
  
  def gait
    'runs'
  end
end


# Given solution
module Walkable
  def walk
    "#{self} #{gait} forward"
  end
end

class Person
  include Walkable
  
  attr_reader :name
  
  def initialize(name)
    @name = name
  end
  
  def to_s
    name
  end
  
  private
  
  def gait
    "strolls"
  end
end

class Cat
  include Walkable
  
  attr_reader :name
  
  def initialize(name)
    @name = name
  end
  
  def to_s
    name
  end
  
  private
  
  def gait
    "saunters"
  end
end

class Cheetah
  include Walkable
  
  attr_reader :name
  
  def initialize(name)
    @name = name
  end
  
  def to_s
    name
  end
  
  private
  
  def gait
    "runs"
  end
end

class Noble
  include Walkable
  
  attr_reader :name, :title
  
  def initialize(name, title)
    @title = title
    @name = name
  end
  
  def to_s
    "#{title} #{name}"
  end
  
  private
  
  def gait
    "struts"
  end
end

mike = Person.new("Mike")
p mike.walk

kitty = Cat.new("Kitty")
p kitty.walk

flash = Cheetah.new("Flash")
p flash.walk

noble = Noble.new("Byron", "Lord")
p noble.walk
