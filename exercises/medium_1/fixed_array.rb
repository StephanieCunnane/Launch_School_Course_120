class FixedArray
  def initialize(size)
    @size = size
    @arr = Array.new(size)
  end
  
  def [](idx)
    arr.fetch(idx)
  end
  
  def []=(idx, value)
    raise IndexError if idx > @size - 1
    arr[idx] = value
  end
  
  # the receiver is requesting an Array version of itself (the FixedArray instance, self)
  # But this methos is passing back a REFERENCE to the original Array object stored in @arr.
  # So with the reference, destructive things can happen the the main data structure of our FixedArray instance -> use #clone
  def to_a
    arr.clone
  end
  
  def to_s
    "#{arr}"
  end
  
  private
  
  attr_reader :arr
end

# Given solution
class FixedArray
  def initialize(max_size)
    @array = Array.new(max_size)
  end
  
  def [](idx)
    @array.fetch(idx)
  end
  
  def []=(idx, value)
    self[idx] # force FixedArray#[]= to raise an error if the idx is out of bounds
    @array[idx] = value
  end
  
  def to_a
    @array.clone
  end
  
  def to_s
    to_a.to_s
  end
end

fixed_array = FixedArray.new(5)
puts fixed_array[3] == nil
puts fixed_array.to_a == [nil] * 5

fixed_array[3] = 'a'
puts fixed_array[3] == 'a'
puts fixed_array.to_a == [nil, nil, nil, 'a', nil]

fixed_array[1] = 'b'
puts fixed_array[1] == 'b'
puts fixed_array.to_a == [nil, 'b', nil, 'a', nil]

fixed_array[1] = 'c'
puts fixed_array[1] == 'c'
puts fixed_array.to_a == [nil, 'c', nil, 'a', nil]

fixed_array[4] = 'd'
puts fixed_array[4] == 'd'
puts fixed_array.to_a == [nil, 'c', nil, 'a', 'd']
puts fixed_array.to_s == '[nil, "c", nil, "a", "d"]'

puts fixed_array[-1] == 'd'
puts fixed_array[-4] == 'c'

begin
  fixed_array[6]
  puts false
rescue IndexError
  puts true
end

begin
  fixed_array[-7] = 3
  puts false
rescue IndexError
  puts true
end

begin
  fixed_array[7] = 3
  puts false
rescue IndexError
  puts true
end
