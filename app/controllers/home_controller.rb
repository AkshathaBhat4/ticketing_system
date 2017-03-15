# Home Controller Specifies Actions Required To Render Root Page
class HomeController < ApplicationController
  # Processes Required data for root page
  #
  # @return [#index page]
  def index
    @user_types = Hash[*UserType.pluck('id,name').flatten]
  end
end
