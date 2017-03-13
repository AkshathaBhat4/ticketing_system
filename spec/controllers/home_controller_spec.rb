require 'rails_helper'

RSpec.describe HomeController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "returns index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

end
