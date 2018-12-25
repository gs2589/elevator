class Elevator
  attr_accessor :current_floor, :queue_of_requests, :queue_of_calls, :current_direction, :floors
  CALL_VALUES = [:none, :up, :down, :stop]
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
    if [:up, :rest].include?(current_direction)
      next_stop = self.current_floor + queue_of_requests[self.current_floor..floors].index do |floor|
                    floor == :stop
                  end
    elsif [:down].include?(current_direction)
      next_stop = queue_of_requests[0..self.current_floor].rindex do |floor|
                    floor == :stop
                  end
    end

    if !next_stop.nil?
      self.current_floor = next_stop
      queue_of_requests[next_stop] = :none
    end

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