class Elevator
  attr_accessor :current_floor, :queue_of_requests

  def initialize
    @current_floor = 1
    @queue_of_requests = [] 
  end

  def request_stop(floor)
     queue_of_requests.include?(floor) ? return : queue_of_requests << floor
  end

  def visit_next_floor
    return if queue_of_requests.empty?  
    self.current_floor = queue_of_requests.shift
  end


end