require 'rails_helper'

RSpec.describe State, type: :model do
  context "validate state scopes" do
    before(:each) do
      @new_state = State.where(name: 'new').first_or_create
      @inprogress_state = State.where(name: 'inprogress').first_or_create
      @close_state = State.where(name: 'close').first_or_create
      @delete_state = State.where(name: 'delete').first_or_create
    end

    it "admin state" do
      expect(State.admin_state).to eq([@inprogress_state, @close_state, @delete_state])
      expect(State.admin_state).not_to include(@new_state)
    end

    it "customer state" do
      expect(State.customer_state).to eq([@delete_state])
    end

    it "agent state" do
      expect(State.agent_state).to eq([@inprogress_state, @close_state])
      expect(State.agent_state).not_to include(@new_state)
      expect(State.agent_state).not_to include(@delete_state)
    end
  end
end
