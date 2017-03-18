require 'rails_helper'

RSpec.describe User, type: :model do
  def admin_user
    @admin_user = User.create!({
      email: 'admin@gmail.com',
      name: 'Admin',
      password: 'admin@123456',
      password_confirmation: 'admin@123456',
      user_type_id: @admin_user_type.id
    })
  end

  def agent_user
    @agent_user = User.create!({
      email: 'agent@gmail.com',
      name: 'Agent',
      password: 'agent@123456',
      password_confirmation: 'agent@123456',
      user_type_id: @agent_user_type.id
    })
  end

  def customer_user
    @customer_user = User.create!({email: 'customer@gmail.com',
      name: 'Customer',
      password: 'customer@123456',
      password_confirmation: 'customer@123456',
      user_type_id: @customer_user_type.id
    })
  end

  before(:each) do
    @admin_user_type = UserType.where(name: 'admin').first_or_create
    @agent_user_type = UserType.where(name: 'agent').first_or_create
    @customer_user_type = UserType.where(name: 'customer').first_or_create
  end

  before(:example, all_users: true) do
    admin_user
    agent_user
    customer_user
  end

  before(:example, customer_user: true) do
    customer_user
  end

  before(:example, agent_user: true) do
    agent_user
  end

  before(:example, admin_user: true) do
    admin_user
  end

  context "validate user" do
    it "duplicate email id", customer_user: true do
      user = User.create({email: 'customer@gmail.com',
        name: 'Customer',
        password: 'customer@123456',
        password_confirmation: 'customer@123456'
      })
      expect(user.errors.messages).to eq({email: ["has already been taken"]})
    end

    it "blank password" do
      user = User.create({email: 'customer@gmail.com',
        name: 'Customer'
      })
      expect(user.errors.messages).to eq({password: ["can't be blank"]})
    end
  end

  context "validate new user type" do
    it "default user type" do
      user = User.create!({email: 'customer@gmail.com',
        name: 'Customer',
        password: 'customer@123456',
        password_confirmation: 'customer@123456'
      })
      expect(user.user_type_name).to eq('customer')
    end

    it "all user type", all_users: true do
      expect(@customer_user.user_type_name).to eq('customer')
      expect(@agent_user.user_type_name).to eq('agent')
      expect(@admin_user.user_type_name).to eq('admin')
    end

    it "is user type?", all_users: true do
      expect(@customer_user.is_customer?).to eq(true)
      expect(@agent_user.is_agent?).to eq(true)
      expect(@admin_user.is_admin?).to eq(true)
    end

    it "user type delegate", customer_user: true do
      expect(@customer_user.user_type_name).to eq(@customer_user.user_type.name)
    end
  end

  context "validate user scopes" do
    it "admin users", all_users: true do
      expect(User.non_admin_users).to eq([@agent_user, @customer_user])
      expect(User.non_admin_users).not_to include(@admin_user)
    end
  end

  context "validate user tabs" do
    it "admin user tab", admin_user: true do
      user_tabs = {
        'users': 'Manage Users',
        'tickets': 'Manage Tickets',
        'new_ticket': 'Raise Ticket'
      }
      expect(@admin_user.user_tabs).to eq(user_tabs)
      expect(@admin_user.user_tabs).to eq(@admin_user.admin_tabs)
    end

    it "agent user tab", agent_user: true do
      user_tabs = {
        'tickets': 'Manage Tickets'
      }
      expect(@agent_user.user_tabs).to eq(user_tabs)
      expect(@agent_user.user_tabs).to eq(@agent_user.agent_tabs)
    end

    it "customer user tab", customer_user: true do
      user_tabs = {
        'tickets': 'Manage Tickets',
        'new_ticket': 'Raise Ticket'
      }
      expect(@customer_user.user_tabs).to eq(user_tabs)
      expect(@customer_user.user_tabs).to eq(@customer_user.customer_tabs)
    end
  end

  context "validate user allowed ticket states" do
    it "admin user states", admin_user: true do
      expect(@admin_user.allowed_ticket_state).to eq(@admin_user.admin_state)
      expect(State.admin_state.pluck(:name)).to eq(@admin_user.admin_state.keys)
    end

    it "agent user states", agent_user: true do
      expect(@agent_user.allowed_ticket_state).to eq(@agent_user.agent_state)
      expect(State.agent_state.pluck(:name)).to eq(@agent_user.agent_state.keys)
    end

    it "customer user states", customer_user: true do
      expect(@customer_user.allowed_ticket_state).to eq(@customer_user.customer_state)
      expect(State.customer_state.pluck(:name)).to eq(@customer_user.customer_state.keys)
    end
  end

  context "validate tickets" do
    it "customer tickets", customer_user: true do
      ticket1 = @customer_user.customer_tickets.create(name: 'Customer Ticket 1', description: 'Customer Ticket 1 description')
      ticket2 = @customer_user.customer_tickets.create(name: 'Customer Ticket 2', description: 'Customer Ticket 2 description')
      expect(@customer_user.customer_tickets).to eq([ticket1, ticket2])
    end

    it "agent tickets", customer_user: true, agent_user: true do
      ticket1 = @customer_user.customer_tickets.create(name: 'Customer Ticket 1', description: 'Customer Ticket 1 description')
      ticket2 = @customer_user.customer_tickets.create(name: 'Customer Ticket 2', description: 'Customer Ticket 2 description')
      ticket2.update_attributes(agent_id: @agent_user.id)
      ticket2.reload
      expect(@customer_user.agent_tickets).to eq([])
      expect(@agent_user.agent_tickets).to eq([ticket2])
      expect(@agent_user.agent_tickets).not_to include(ticket1)
    end
  end
end
