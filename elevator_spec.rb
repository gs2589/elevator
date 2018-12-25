require "./elevator.rb"
require 'pry'

RSpec.describe Elevator do

  describe "current_floor" do
    let(:elevator_instance) { Elevator.new(6) }
    subject { elevator_instance.current_floor }

    it "returns the default floor for a newly initialized instance" do
      elevator_instance
      expect(subject).to eq(1)
    end

    it "returns the current floor after it is updated" do
      elevator_instance.current_floor = 5
      expect(subject).to eq(5)
    end

  end

  describe "current_direction" do
    let(:elevator_instance) { Elevator.new(6) }
    subject { elevator_instance.current_direction }

    it "returns the default direction for a newly initialized instance" do
      elevator_instance
      expect(subject).to eq(:rest)
    end

    it "returns the current direction after it is updated" do
      elevator_instance.current_direction = :up
      expect(subject).to eq(:up)
    end

  end

  describe "queue_of_requests" do
    let(:elevator_instance) { Elevator.new(6) }
    subject { elevator_instance.queue_of_requests }

    it "returns an `empty` queue for a newly initialized instance" do
      elevator_instance
      expect(subject).to eq([nil, :none, :none, :none, :none, :none, :none])
    end

    it "it returns an updated queue when items have been added" do
      elevator_instance.queue_of_requests = [nil, :none, :none, :up, :none, :none, :none]
      expect(subject).to eq([nil, :none, :none, :up, :none, :none, :none])
    end

  end

  describe "request_stop" do
    let(:elevator_instance) { Elevator.new(6) }
    subject { elevator_instance.request_stop(5) }

    context "requested floor not present in queue" do

      it "adds the given floor" do
        subject
        expect(elevator_instance.queue_of_requests).to eq([nil, :none, :none, :none, :none, :stop, :none])
      end

    end
    
    context "requested floor present in queue" do
      let(:elevator_instance) { Elevator.new(6) }

      it "does nothing" do
        elevator_instance.queue_of_requests = [nil, :none, :none, :up, :none, :stop, :none]
        expect { subject }.to_not change {elevator_instance.queue_of_requests}
      end
    end

  end

  describe "call" do
    let(:elevator_instance) { Elevator.new(6) }
    subject { elevator_instance.call(floor, direction) }

    context "requested floor and direction not present in queue" do
      context "downward request" do
        let(:floor){ 5 }
        let(:direction){ :down }

        it "can keep track of the direction" do
          subject
          expect(elevator_instance.queue_of_calls).to eq([nil, :none, :none, :none, :none, :down, :none])
        end
      end

      context "upward request" do
        let(:floor){ 5 }
        let(:direction){ :up }

        it "can keep track of the direction" do
          subject
          expect(elevator_instance.queue_of_calls).to eq([nil, :none, :none, :none, :none, :up, :none])
        end
      end
      
      context "two requests, upward then downward" do
        let(:floor){ 5 }
        let(:direction){ :down }

        it "can keep track of both directions" do
          elevator_instance.call(5, :up)
          subject
          expect(elevator_instance.queue_of_calls).to eq([nil, :none, :none, :none, :none, :both, :none])
        end
      end

      context "two requests, downward then upward" do
        let(:floor){ 5 }
        let(:direction){ :down }

        it "can keep track of both directions" do
          elevator_instance.call(5, :up)
          subject
          expect(elevator_instance.queue_of_calls).to eq([nil, :none, :none, :none, :none, :both, :none])
        end
      end

    end
    
    context "requested floor and direction present in queue" do
      let(:floor){ 5 }
      let(:direction){ :up }

      it "does not add the floor to the queue_of_requests" do
        elevator_instance.call(5, :up)
        subject
        expect(elevator_instance.queue_of_calls).to eq([nil, :none, :none, :none, :none, :up, :none])
      end
    end

  end


  describe "visit_next_floor" do
    let(:elevator_instance) { Elevator.new(6) }
    subject { elevator_instance.visit_next_floor }
   
    context "there are requests in the queue_of_request but not in the queue_of_calls " do
      before do
        elevator_instance.queue_of_requests = [nil, :stop, :none, :none, :none, :stop, :none]
      end
      
      context "the elevator is not past the floor of the request in the queue_of_requests" do
        before do
          elevator_instance.current_floor = 6
          elevator_instance.current_direction = :down
        end
      
        it "updates the position of the elevator" do
          subject
          expect(elevator_instance.current_floor).to eq(5)
        end

        it "updates queues removing visited floors" do
          expect(elevator_instance.queue_of_requests[5]).to eq(:stop)
          subject
          expect(elevator_instance.queue_of_requests[5]).to eq(:none)
        end
      end

      context "the elevator is past the floor of the request in the queue_of_requests " do
        before do
          elevator_instance.current_floor = 3
          elevator_instance.current_direction = :up
        end

        it "visits all floors that the elevator has not passed before visiting the floor that is past" do
          subject 
          expect(elevator_instance.current_floor).to eq(5)
          subject
          expect(elevator_instance.current_floor).to eq(1)
        end
      end
    end


    context "there are requests in the queue_of_calls but not in the queue_of_requests" do
        
      context "the request in the queue_of_calls are not in the direction the elevator is traveling" do
      end

        context "the requests in the queue_of_calls are in the direction the elevator is traveling" do
          
          context "the elevator is past the floor of the request in the queue_of_calls " do
            
            it "visits all floors that the elevator has not passed before visiting the floor that is past" do
              skip
            end 
          
          end

          context "the elevator is not past the floor of the request in the queue_of_requests" do

            it "updates the position of the elevator" do
              skip
            end

            it "updates both queues removing visited floors" do
              skip
            end
          end
        end
    end

    context "the are requests in both of the queues" do
      
      it "updates the position of the elevator" do
        skip
      end

      it "updates both queues removing visited floors" do
        skip
      end

    end

    context "the elevator reaches the highest floor in the queues" do

    end

    context "the elevator reaches the lowes floor in the queues" do

    end

    context "both queues are empty" do
      before do
        elevator_instance.queue_of_requests = [nil, :none, :none, :none, :none, :none, :none]
      end 


      it "does not change the current_floor of the elevator" do
        skip
        expect{ subject }.to_not change{ elevator_instance.current_floor }
      end
    end
  end

end