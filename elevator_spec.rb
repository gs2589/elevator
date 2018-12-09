require "./elevator.rb"
require 'pry'

RSpec.describe Elevator do 

  describe "current_floor" do
    let(:elevator_instance) { Elevator.new }
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
    let(:elevator_instance) { Elevator.new }
    subject { elevator_instance.queue_of_requests }

    it "returns an empty queue for a newly initialized instance" do 
      elevator_instance
      expect(subject).to eq([])
    end

    it "it returns an updated queue when items have been added" do 
      elevator_instance.queue_of_requests<<5
      expect(subject).to eq([5])
    end

  end

  describe "request_stop" do
    let(:elevator_instance) { Elevator.new }
    subject { elevator_instance.request_stop(5) }

    context "requested floor not present in queue" do
      let(:elevator_instance) { Elevator.new }

      it "adds the given floor to the queue_of_requests" do
        subject
        expect(elevator_instance.queue_of_requests).to eq([5])
      end
    end
    
    context "requested floor present in queue" do
      let(:elevator_instance) { Elevator.new() }


      it "does not add the floor to the queue_of_requests" do
        elevator_instance.queue_of_requests << 5
        subject
        expect(elevator_instance.queue_of_requests).to eq([5])
      end
    end

  end

  describe "call" do
    let(:elevator_instance) { Elevator.new }
    subject { elevator_instance.call(5, :up) }

    # context "requested floor not present in queue" do

    #   it "adds the given floor to the end queue_of_requests" do
    #     elevator_instance.queue_of_calls << 1
    #     subject
    #     expect(elevator_instance.queue_of_requests).to eq([1,5])
    #   end

    #   it "keeps the queue in oder when adding new stop requests" do 
    #     elevator_instance.queue_of_requests += [1,2,6]
    #     subject
    #     expect(elevator_instance.queue_of_requests).to eq([1,2,5,6])
    #   end

    # end
    
    context "requested floor present in queue" do
      let(:elevator_instance) { Elevator.new() }


      it "does not add the floor to the queue_of_requests" do
        elevator_instance.call(5, :up)
        subject
        expect(elevator_instance.queue_of_calls).to eq([5, :up])
      end
    end

  end


  describe "visit_next_floor" do 
    let(:elevator_instance) { Elevator.new }
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