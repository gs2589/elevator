class Elevator
  attr_accessor :current_floor, :queue_of_requests, :queue_of_calls


  def initialize(floors)
    @current_floor = 1
    @queue_of_requests = []
    @queue_of_calls = Array.new(floors + 1, :none)
    @queue_of_calls[0] = nil
  end

  def request_stop(floor)
    queue_of_requests.include?(floor) ? return : queue_of_requests << floor
    queue_of_requests.sort!
  end

  def call (floor, direction)
    existing_direction = queue_of_calls[floor]
    return if direction == existing_direction
    queue_of_calls[floor] = direction_after_call(existing_direction, direction)
  end

  def visit_next_floor
    return if queue_of_requests.empty?  
    self.current_floor = queue_of_requests.shift
  end

  private

  def direction_after_call(existing_direction, call_direction)
    case existing_direction
      when :none, call_direction
        call_direction
      when :up, :down
        :both
    end
  end


end