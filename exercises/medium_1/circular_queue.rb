class CircularQueue
  def initialize(size)
    @buffer = Array.new(size)
    @next_position = 0
    @oldest_position = 0
  end
  
  def enqueue(obj)
    unless @buffer[@next_position].nil?
      @oldest_position = increment(@next_position)
    end
    
    @buffer[@next_position] = obj
    @next_position = increment(@next_position)
  end
  
  def dequeue
    value = @buffer[@oldest_position]
    @buffer[@oldest_position] = nil
    @oldest_position = increment(@oldest_position) unless value.nil?
    value
  end
  
  private
  
  def increment(position)
    (position + 1) % @buffer.size
  end
end

# Further exploration

# [newest, middle, oldest]
# Or think of it as a spectrum: oldest at the end, newest at the front

class CircularQueue
  def initialize(size)
    @buffer = Array.new(size)
  end

  def enqueue(obj)
    @buffer.pop
    @buffer.unshift(obj)
  end

  def dequeue
    dequeued = nil
    (@buffer.size - 1).downto(0) do |idx|
      unless @buffer[idx].nil?
        dequeued = @buffer[idx]
        @buffer[idx] = nil
        return dequeued
      end
    end
    dequeued
  end
end

queue = CircularQueue.new(3)
puts queue.dequeue == nil

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil

queue = CircularQueue.new(4)
puts queue.dequeue == nil

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 4
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil
