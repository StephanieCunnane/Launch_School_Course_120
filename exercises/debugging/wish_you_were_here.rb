# As originally written, puts ada.location == grace.location returns false because we haven't defined a #== method that is specific to GeoLocation objects. We haven't specified how we want GeoLocation objects to compare themselves to one another, so we are falling back to BasicObject#==, which tests *object* equality and is definitely not what we really want. We can fix our problem by writing a GeoLocation#== method.

class Person
  attr_reader :name
  attr_accessor :location
  
  def initialize(name)
    @name = name
  end
  
  def teleport_to(latitude, longitude)
    @location = GeoLocation.new(latitude, longitude)
  end
end

class GeoLocation
  attr_reader :latitude, :longitude
  
  def initialize(latitude, longitude)
    @latitude = latitude
    @longitude = longitude
  end
  
  def ==(other_location)
    to_s == other_location.to_s
  end
  
  def to_s
    "(#{latitude}, #{longitude})"
  end
end

ada = Person.new('Ada')
ada.location = GeoLocation.new(53.477, -2.236)

grace = Person.new('Grace')
grace.location = GeoLocation.new(-33.89, 151.277)

ada.teleport_to(-33.89, 151.277)

puts ada.location
puts grace.location

puts ada.location == grace.location
