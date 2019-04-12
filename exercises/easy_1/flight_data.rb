class Flight
  attr_accessor :database_handle
  
  def initialize(flight_number)
    @database_handle = Database.init
    @flight_number = flight_number
  end
end

# In the code above, we should get rid of the call to #attr_accessor
# completely. The database_handle information is an implementation
# detail that users shouldn't need to use directly, so we shouldn't be
# providing access to @database_handle.

