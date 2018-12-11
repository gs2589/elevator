require "./elevator.rb"
require 'pry'

RSpec.describe Elevator do 

  describe "current_floor" do
    let(:elevator_instance) { Elevator.new(10) }
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
    let(:elevator_instance) { Elevator.new(10) }
    subject { elevator_instance.visit_next_floor }
   
    context "queue_of_requests is empty" do 

      it "does not change the current_floor of the elevator" do
        elevator_instance.queue_of_requests = []
        expect{ (subject) }.to_not change{ elevator_instance.current_floor }
      end
    end

    context "queue_of_requests is not empty" do
      
      it "changes the current_floor of the elevator to the first item in the queue" do
        elevator_instance.queue_of_requests = [5]
        expect{ (subject) }.to change{ elevator_instance.current_floor }.to(5)
      end

      it "removes the first item in the queue_of_requests " do
        elevator_instance.queue_of_requests = [5,1,6]
        subject
        expect(elevator_instance.queue_of_requests).to eq([1,6])

      end
    end

  end

end