class Elevator
  attr_accessor :current_floor, :queue_of_requests, :queue_of_calls, :current_direction, :floors
  CALL_VALUES = [:none, :up, :down, :both]
  REQUEST_VALUES = [:stop, :none]

  def initialize(floors)
    @floors = floors
    @current_direction = :rest
    @current_floor = 1
    @queue_of_requests = Array.new(floors + 1, :none)
    @queue_of_calls = Array.new(floors + 1, :none)
    @queue_of_calls[0] = nil
    @queue_of_requests[0] = nil
  end

  def request_stop(floor)
    queue_of_requests[floor] = :stop
  end

  def call (floor, direction)
    existing_direction = queue_of_calls[floor]
    return if direction == existing_direction
    queue_of_calls[floor] = direction_after_call(existing_direction, direction)
  end

  def visit_next_floor
    set_new_direction

    case current_direction
      when :up
        next_stop = next_stop_above
        update_queue_of_calls = next_stop == next_call_above
      when :down
        next_stop = next_stop_below
        update_queue_of_calls = next_stop == next_call_below
      when :rest
        return
    end
      
    self.current_floor = next_stop
    queue_of_requests[next_stop] = :none
    if update_queue_of_calls
      queue_of_calls[next_stop] = direction_after_stop(queue_of_calls[next_stop])
    end
  end

  def set_new_direction
    case self.current_direction
      when :up
        self.current_direction = :rest unless next_stop_above
      when :down
        self.current_direction = :rest unless next_stop_below
    end
    if self.current_direction == :rest
        self.current_direction = :up if next_stop_above
        self.current_direction = :down if next_stop_below  
    end
  end


  private

  def next_stop_above
    [next_request_above, next_call_above].compact.min
  end

  def next_stop_below
    [next_request_below, next_call_below].compact.max
  end

  def next_request_above
     queue_of_requests[self.current_floor..floors].index do |floor|
      floor == :stop
     end&.+ self.current_floor
  end

  def next_request_below
    queue_of_requests[0..self.current_floor].rindex do |floor|
      floor == :stop
    end
  end

  def next_call_above
    next_call = queue_of_calls[self.current_floor..floors].index do |floor|
      [:both, :up].include? floor 
    end&.+ self.current_floor

    last_call = queue_of_calls[self.current_floor..floors].index do |floor|
      [:down].include? floor 
    end&.+ self.current_floor

    next_call || last_call
  end

  def next_call_below
    next_call = queue_of_calls[0..self.current_floor].rindex do |floor|
      [:both, :down].include? floor
    end

    last_call = queue_of_calls[0..self.current_floor].rindex do |floor|
      [:up].include? floor
    end

    next_call || last_call
  end

  def direction_after_call(existing_direction, call_direction)
    case existing_direction
      when :none, call_direction
        call_direction
      when :up, :down
        :both
    end
  end

  def direction_after_stop(existing_direction)
    case existing_direction
      when :up, :down, :none
        :none
      when :both
        (CALL_VALUES - [:none, :both, self.current_direction]).first
      else
        existing_direction
    end
  end


end