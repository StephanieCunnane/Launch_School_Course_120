class Something
  def initialize
    @data = 'Hello'
  end
  
  def dupdata
    @data + @data
  end
  
  def self.dupdata
    'Byebye'
  end
end

thing = Something.new
puts Something.dupdata
puts thing.dupdata

# Output:
# Byebye
# HelloHello
