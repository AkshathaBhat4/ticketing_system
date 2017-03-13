require 'rails_helper'

RSpec.describe UsersController, type: :controller do
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

  def agent_user
    agent_user_type = UserType.where(name: 'agent').first_or_create
    @agent_user = User.create!({email: 'agent@gmail.com',
      name: 'agent',
      password: 'agent@123456',
      password_confirmation: 'agent@123456',
      user_type_id: agent_user_type.id
    })
  end

  before(:each) do
    admin_user
  end

  before(:example, customer_user: true) do
    customer_user
  end

  before(:example, agent_user: true) do
    agent_user
  end

  def response_hash_structure
    {
      "id" => an_instance_of(Fixnum),
      "name" => be_an_instance_of(String),
      "email" => be_an_instance_of(String),
      "user_type_id" => an_instance_of(Fixnum),
      "user_type" => {"name" => be_an_instance_of(String)}
    }
  end

  describe "Get Users" do
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

    it "loads all users (admin login)", customer_user: true, agent_user: true do
      sign_in @admin_user
      get :show
      hash_body = nil
      expect { hash_body = JSON.parse(response.body) }.not_to raise_exception
      expect(hash_body).to match(a_collection_including(response_hash_structure))
    end

    it "render error for customer user", customer_user: true, agent_user: true do
      sign_in @customer_user
      get :show
      hash_body = nil
      expect { hash_body = JSON.parse(response.body) }.not_to raise_exception
      expect(hash_body).to match(a_hash_including({"error" => 'action not allowed'}))
    end

    it "render error for agent user", customer_user: true, agent_user: true do
      sign_in @agent_user
      get :show
      hash_body = nil
      expect { hash_body = JSON.parse(response.body) }.not_to raise_exception
      expect(hash_body).to match(a_hash_including({"error" => 'action not allowed'}))
    end
  end

  describe "Create New User" do
    def valid_user_params
      {
        user: {
          name: 'User 1',
          email: 'user@email.com',
          password: 'user@123456',
          password_confirmation: 'user@123456'
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

    it "create user response (admin login)", customer_user: true, agent_user: true do
      sign_in @admin_user
      post :create, params: valid_user_params
      hash_body = nil
      expect { hash_body = JSON.parse(response.body) }.not_to raise_exception
      expect(hash_body).to match(a_hash_including(response_hash_structure))
    end

    it "create user error response for customer user", customer_user: true, agent_user: true do
      sign_in @customer_user
      post :create, params: valid_user_params
      hash_body = nil
      expect { hash_body = JSON.parse(response.body) }.not_to raise_exception
      expect(hash_body).to match(a_hash_including({"error" => 'action not allowed'}))
    end

    it "create user error response for agent user", customer_user: true, agent_user: true do
      sign_in @agent_user
      post :create, params: valid_user_params
      hash_body = nil
      expect { hash_body = JSON.parse(response.body) }.not_to raise_exception
      expect(hash_body).to match(a_hash_including({"error" => 'action not allowed'}))
    end

    it "create user validation error response for admin login", customer_user: true, agent_user: true do
      sign_in @admin_user
      post :create, params: {user: {name: 'User 1'}}
      hash_body = nil
      expect { hash_body = JSON.parse(response.body) }.not_to raise_exception
      expect(hash_body).to match(a_hash_including({"email"=>["can't be blank"], "password"=>["can't be blank"]}))
    end
  end

  describe "Update User" do
    def valid_update_user_params(user)
      {
        user: {
          name: 'User 1',
          email: 'user@email.com',
          password: 'user@123456',
          password_confirmation: 'user@123456'
        },
        id: user.id
      }
    end

    def invalid_update_user_params(user)
      {
        user: {
          name: 'User 1',
          email: '',
          password: '',
          password_confirmation: ''
        },
        id: user.id
      }
    end

    it "returns http success", customer_user: true, agent_user: true do
      sign_in @admin_user
      put :update, params: valid_update_user_params(@customer_user)
      expect(response).to have_http_status(:success)
    end

    it "returns http fail", customer_user: true, agent_user: true do
      sign_in nil
      put :update, params: valid_update_user_params(@customer_user)
      expect(response).to have_http_status(:found)
    end

    it "update user response (admin login)", customer_user: true, agent_user: true do
      sign_in @admin_user
      put :update, params: valid_update_user_params(@customer_user)
      hash_body = nil
      expect { hash_body = JSON.parse(response.body) }.not_to raise_exception
      expect(hash_body).to match(a_hash_including(response_hash_structure))
    end

    it "update user error response for customer user", customer_user: true, agent_user: true do
      sign_in @customer_user
      put :update, params: valid_update_user_params(@customer_user)
      hash_body = nil
      expect { hash_body = JSON.parse(response.body) }.not_to raise_exception
      expect(hash_body).to match(a_hash_including({"error" => 'action not allowed'}))
    end

    it "update user error response for agent user", customer_user: true, agent_user: true do
      sign_in @agent_user
      put :update, params: valid_update_user_params(@customer_user)
      hash_body = nil
      expect { hash_body = JSON.parse(response.body) }.not_to raise_exception
      expect(hash_body).to match(a_hash_including({"error" => 'action not allowed'}))
    end

    it "update user validation error response for admin login", customer_user: true, agent_user: true do
      sign_in @admin_user
      put :update, params: invalid_update_user_params(@customer_user)
      hash_body = nil
      expect { hash_body = JSON.parse(response.body) }.not_to raise_exception
      expect(hash_body).to match(a_hash_including({"email"=>["can't be blank"], "password"=>["can't be blank"]}))
    end
  end

  describe "Delete User" do
    it "returns http success", customer_user: true do
      sign_in @admin_user
      delete :destroy, params: {id: @customer_user.id}
      expect(response).to have_http_status(:success)
    end

    it "returns http fail", customer_user: true do
      sign_in nil
      delete :destroy, params: {id: @customer_user.id}
      expect(response).to have_http_status(:found)
    end

    it "delete user response (admin login)", customer_user: true do
      sign_in @admin_user
      delete :destroy, params: {id: @customer_user.id}
      expect(response).to have_http_status(:no_content)
    end

    it "delete user error response for customer user", customer_user: true do
      sign_in @customer_user
      delete :destroy, params: {id: @customer_user.id}
      hash_body = nil
      expect { hash_body = JSON.parse(response.body) }.not_to raise_exception
      expect(hash_body).to match(a_hash_including({"error" => 'action not allowed'}))
    end

    it "delete user error response for agent user", customer_user: true, agent_user: true do
      sign_in @agent_user
      delete :destroy, params: {id: @customer_user.id}
      hash_body = nil
      expect { hash_body = JSON.parse(response.body) }.not_to raise_exception
      expect(hash_body).to match(a_hash_including({"error" => 'action not allowed'}))
    end
  end

  describe "Get User Tabs" do
    it "returns http success", customer_user: true do
      sign_in @admin_user
      get :get_user_tabs
      expect(response).to have_http_status(:success)
    end

    it "returns http fail", customer_user: true do
      sign_in nil
      get :get_user_tabs
      expect(response).to have_http_status(:found)
    end

    it "get user tabs", customer_user: true do
      sign_in @admin_user
      get :get_user_tabs
      hash_body = nil
      expect { hash_body = JSON.parse(response.body) }.not_to raise_exception
      expect(hash_body).to match(an_instance_of(Hash))
    end
  end

  describe "Get User States" do
    it "returns http success", customer_user: true do
      sign_in @admin_user
      get :allowed_states
      expect(response).to have_http_status(:success)
    end

    it "returns http fail", customer_user: true do
      sign_in nil
      get :allowed_states
      expect(response).to have_http_status(:found)
    end

    it "get user states", customer_user: true do
      sign_in @admin_user
      get :allowed_states
      hash_body = nil
      expect { hash_body = JSON.parse(response.body) }.not_to raise_exception
      expect(hash_body).to match(an_instance_of(Hash))
    end
  end

  describe "Get All States" do
    it "returns http success", customer_user: true do
      sign_in @admin_user
      get :all_states
      expect(response).to have_http_status(:success)
    end

    it "returns http fail", customer_user: true do
      sign_in nil
      get :all_states
      expect(response).to have_http_status(:found)
    end

    it "get all states", customer_user: true do
      sign_in @admin_user
      get :all_states
      hash_body = nil
      expect { hash_body = JSON.parse(response.body) }.not_to raise_exception
      expect(hash_body).to match(an_instance_of(Array))
    end
  end
end
