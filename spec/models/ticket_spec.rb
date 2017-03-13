require 'rails_helper'

RSpec.describe Ticket, type: :model do
  def customer_user
    @customer_user = User.create!({email: 'customer@gmail.com',
      name: 'Customer',
      password: 'customer@123456',
      password_confirmation: 'customer@123456',
      user_type_id: @customer_user_type.id
    })
  end

  before(:each) do
    @customer_user_type = UserType.where(name: 'customer').first_or_create
  end

  before(:example, default_tickets: true) do
    customer_user
    @ticket1 = @customer_user.customer_tickets.create(name: 'Customer Ticket 1', description: 'Customer Ticket 1 description')
    @ticket2 = @customer_user.customer_tickets.create(name: 'Customer Ticket 2', description: 'Customer Ticket 2 description')
    @ticket3 = @customer_user.customer_tickets.create(name: 'Customer Ticket 3', description: 'Customer Ticket 3 description')
    @ticket4 = @customer_user.customer_tickets.create(name: 'Customer Ticket 4', description: 'Customer Ticket 4 description')
    @ticket5 = @customer_user.customer_tickets.create(name: 'Customer Ticket 5', description: 'Customer Ticket 5 description')
    @ticket6 = @customer_user.customer_tickets.create(name: 'Customer Ticket 6', description: 'Customer Ticket 6 description')
    @ticket7 = @customer_user.customer_tickets.create(name: 'Customer Ticket 7', description: 'Customer Ticket 7 description')
    @ticket8 = @customer_user.customer_tickets.create(name: 'Customer Ticket 8', description: 'Customer Ticket 8 description')
  end

  before(:example, customer_user: true) do
    customer_user
  end

  context "validate states" do
    it "default state", customer_user: true do
      ticket = @customer_user.customer_tickets.create(name: 'Customer Ticket 1', description: 'Customer Ticket 1 description')
      expect(ticket.state_name).to eq('new')
      expect(ticket.state_name).to eq(ticket.state.name)
    end

    it "all state transition", customer_user: true do
      ticket = @customer_user.customer_tickets.create(name: 'Customer Ticket 1', description: 'Customer Ticket 1 description')
      expect(ticket.state_name).to eq('new')
      expect(ticket.state_name).to eq(ticket.state.name)

      ticket.inprogress_state!
      ticket.reload
      expect(ticket.state_name).to eq('inprogress')
      expect(ticket.state_name).to eq(ticket.state.name)

      ticket.close_state!
      ticket.reload
      expect(ticket.state_name).to eq('close')
      expect(ticket.state_name).to eq(ticket.state.name)

      ticket.delete_state!
      ticket.reload
      expect(ticket.state_name).to eq('delete')
      expect(ticket.state_name).to eq(ticket.state.name)
    end
  end

  context "validate scopes" do
    it "get all customer tickets ( customer_id)", customer_user: true do
      user1 = @customer_user
      user2 = User.create({email: 'customer1@gmail.com',
        name: 'Customer 1',
        password: 'customer@123456',
        password_confirmation: 'customer@123456'
      })
      ticket1 = user1.customer_tickets.create(name: 'Customer Ticket 1', description: 'Customer Ticket 1 description')
      ticket2 = user1.customer_tickets.create(name: 'Customer Ticket 2', description: 'Customer Ticket 2 description')
      ticket3 = user2.customer_tickets.create(name: 'Customer Ticket 3', description: 'Customer Ticket 3 description')

      expect(Ticket.customer_tickets(user1.id)).to eq([ticket1, ticket2])
      expect(Ticket.customer_tickets(user1.id)).not_to include(ticket3)

      expect(Ticket.customer_tickets(user2.id)).to eq([ticket3])
      expect(Ticket.customer_tickets(user2.id)).not_to include(ticket1)
      expect(Ticket.customer_tickets(user2.id)).not_to include(ticket2)
    end

    it "get all state tickets (state_name)", default_tickets: true do
      expect(Ticket.state_tickets('new')).to eq([@ticket1, @ticket2, @ticket3, @ticket4, @ticket5, @ticket6, @ticket7, @ticket8])

      @ticket1.inprogress_state!
      @ticket2.inprogress_state!
      @ticket3.close_state!
      @ticket4.close_state!
      @ticket5.delete_state!
      @ticket6.delete_state!

      expect(Ticket.state_tickets('new')).to eq([@ticket7, @ticket8])
      expect(Ticket.state_tickets('inprogress')).to eq([@ticket1, @ticket2])
      expect(Ticket.state_tickets('close')).to eq([@ticket3, @ticket4])
      expect(Ticket.state_tickets('delete')).to eq([@ticket5, @ticket6])
    end

    it "get all all last month closed tickets", default_tickets: true do
      @ticket3.close_state!
      @ticket4.close_state!
      @ticket5.close_state!
      @ticket6.close_state!

      updated_date = Date.today.prev_month - 1.day
      @ticket6.update_column(:updated_at, updated_date)

      expect(Ticket.last_month_closed_tickets).to eq([@ticket3, @ticket4, @ticket5])
    end
  end
end
