class Machine
  def initialize
    @switch = :off
  end
  
  def start
    flip_switch(:on)
  end
  
  def stop
    flip_switch(:off)
  end
  
  def status
    switch
  end
  
  private
  
  attr_accessor :switch
  
  def flip_switch(desired_state)
    self.switch = desired_state
  end
end

machine = Machine.new

# Improved version

class Machine
  def start
    flip_switch(:on)
  end

  def stop
    flip_switch(:off)
  end

  def status
    puts "Current machine status: #{switch == :on ? "On" : "Off"}"
  end

  private

  attr_accessor :switch

  def flip_switch(desired_state)
    self.switch = desired_state
  end
end

machine = Machine.new
