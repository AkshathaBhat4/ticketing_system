class HomeController < ApplicationController
  def index
    @user_types = Hash[*UserType.pluck('id,name').flatten]
  end
end
