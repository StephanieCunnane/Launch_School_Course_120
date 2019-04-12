class Pet
  attr_reader :name
  
  def initialize(name)
    # this FORCES @name to be a string, no matter what type of
    # object is passed in to the ::new method
    @name = name.to_s
  end
  
  def to_s
    @name.upcase!
    "My name is #{@name}."
  end
end

name = 'Fluffy'
fluffy = Pet.new(name)
# puts automatically calls the #to_s appropriate to its 
# argument (a string in this case)
puts fluffy.name
# But puts calls the custom #to_s method here bc the argument
# to puts is a Pet object
puts fluffy
# The custom to_s method called on line 23 was destructive to 
# @name
puts fluffy.name
# And since name and @name point to the same object, name
# is affected by @name.upcase! as well
puts name
