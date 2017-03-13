require 'rails_helper'

RSpec.describe TicketsController, type: :controller do
  def admin_user
    admin_user_type = UserType.where(name: 'admin').first_or_create
    @admin_user = User.create!({email: 'admin@gmail.com',
      name: 'Admin',
      password: 'admin@123456',
      password_confirmation: 'admin@123456',
      user_type_id: admin_user_type.id
    })
  end

  def customer_user
    customer_user_type = UserType.where(name: 'customer').first_or_create
    @customer_user = User.create!({email: 'customer@gmail.com',
      name: 'Customer',
      password: 'customer@123456',
      password_confirmation: 'customer@123456',
      user_type_id: customer_user_type.id
    })
  end

  before(:each) do
    admin_user
  end

  before(:example, customer_user: true) do
    customer_user
  end

  before(:example, default_tickets: true) do
    customer_user
    @ticket1 = @customer_user.customer_tickets.create(name: 'Customer Ticket 1', description: 'Customer Ticket 1 description')
    @ticket2 = @customer_user.customer_tickets.create(name: 'Customer Ticket 2', description: 'Customer Ticket 2 description')
    @ticket3 = @customer_user.customer_tickets.create(name: 'Customer Ticket 3', description: 'Customer Ticket 3 description')
    @ticket4 = @customer_user.customer_tickets.create(name: 'Customer Ticket 4', description: 'Customer Ticket 4 description')
    @ticket5 = @customer_user.customer_tickets.create(name: 'Customer Ticket 5', description: 'Customer Ticket 5 description')
  end

  def response_hash_structure
    {
      "id" => an_instance_of(Fixnum),
      "name" => be_an_instance_of(String),
      "description" => be_an_instance_of(String),
      "customer" => {"name" => be_an_instance_of(String)},
      "state" => {"name" => be_an_instance_of(String)}
    }
  end

  describe "Get Tickets" do
    it "returns http success" do
      sign_in @admin_user
      get :show
      expect(response).to have_http_status(:success)
    end

    it "returns http fail" do
      sign_in nil
      get :show
      expect(response).to have_http_status(:found)
    end

    it "loads all of the tickets", default_tickets: true do
      # Admin Login
      sign_in @admin_user
      response = get :show
      hash_body = nil
      expect { hash_body = JSON.parse(response.body) }.not_to raise_exception
      expect(hash_body).to match(a_collection_including(response_hash_structure))
      sign_out @admin_user

      # Customer Login
      sign_in @customer_user
      response = get :show
      hash_body = nil
      expect { hash_body = JSON.parse(response.body) }.not_to raise_exception
      expect(hash_body).to match(a_collection_including(response_hash_structure))
    end

    it "loads individual ticket", default_tickets: true do
      sign_in @admin_user
      response = get :show, params: { id: @ticket1.id }
      hash_body = nil
      expect { hash_body = JSON.parse(response.body) }.not_to raise_exception

      expect(hash_body).to match(a_hash_including(response_hash_structure))
    end

    it "loads tickets depending in search status", default_tickets: true do
      sign_in @admin_user
      @ticket2.close_state!
      @ticket3.close_state!
      response = get :show, params: { state: 'close' }
      hash_body = nil
      expect { hash_body = JSON.parse(response.body) }.not_to raise_exception

      expect(hash_body).to match(a_collection_including({
        "id" => an_instance_of(Fixnum),
        "name" => be_an_instance_of(String),
        "description" => be_an_instance_of(String),
        "customer" => {"name" => be_an_instance_of(String)},
        "state" => {"name" => 'close'}
      }))
    end
  end

  describe "Create Tickets" do
    def valid_user_params
      {
        ticket: {
          name: 'Ticket Name 1',
          description: 'Ticket Description 1'
        }
      }
    end
    it "returns http success" do
      sign_in @admin_user
      post :create, params: valid_user_params
      expect(response).to have_http_status(:success)
    end

    it "returns http fail" do
      sign_in nil
      post :create, params: valid_user_params
      expect(response).to have_http_status(:found)
    end

    it "returns created ticket", customer_user: true do
      sign_in @customer_user
      response = post :create, params: valid_user_params
      hash_body = nil
      expect { hash_body = JSON.parse(response.body) }.not_to raise_exception
      expected_output = []
      expect(hash_body).to match(a_hash_including({
        "id" => an_instance_of(Fixnum),
        "name" => be_an_instance_of(String),
        "description" => be_an_instance_of(String),
        "customer" => {"name" => be_an_instance_of(String)},
        "state" => {"name" => 'new'}
      }))

    end
  end

  describe "Change Ticket State" do
    def valid_params_for(ticket, state)
      {
        id: ticket.id,
        state: state
      }
    end
    it "returns http success", default_tickets: true do
      sign_in @customer_user
      state = 'delete'
      put :change_state, params: valid_params_for(@ticket1, state)
      expect(response).to have_http_status(:success)
    end

    it "returns http fail", default_tickets: true do
      sign_in nil
      state = 'delete'
      put :change_state, params: valid_params_for(@ticket1, state)
      expect(response).to have_http_status(:found)
    end

    it "valid change state", default_tickets: true do
      sign_in @customer_user
      state = 'delete'

      response = put :change_state, params: valid_params_for(@ticket1, state)
      hash_body = nil
      expect { hash_body = JSON.parse(response.body) }.not_to raise_exception

      expect(hash_body).to match(a_hash_including({
        "id" => an_instance_of(Fixnum),
        "name" => be_an_instance_of(String),
        "description" => be_an_instance_of(String),
        "customer" => {"name" => be_an_instance_of(String)},
        "state" => {"name" => state}
      }))
    end

    it "invalid change state", default_tickets: true do
      sign_in @customer_user
      state = 'inprogress'
      response = put :change_state, params: valid_params_for(@ticket1, state)
      hash_body = nil
      expect { hash_body = JSON.parse(response.body) }.not_to raise_exception

      expect(hash_body).to match(a_hash_including({state => 'state not allowed'}))
    end
  end
end
