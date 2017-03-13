class UsersController < ApplicationController
  before_action :validate_admin_user, except: [:get_user_tabs, :allowed_states, :all_states]

  def show
    users = User.non_admin_users
    render json: users.as_json
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user.as_json
    else
      render json: @user.errors.to_json, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    head :no_content
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      render json: @user.as_json
    else
      render json: @user.errors.to_json, status: :unprocessable_entity
    end
  end

  def get_user_tabs
    render json: current_user.user_tabs
  end

  def allowed_states
    render json: current_user.allowed_ticket_state
  end

  def all_states
    states = State.all.pluck(:name)
    states.insert(0, 'all')
    render json: states
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :user_type_id)
    end

    def validate_admin_user
      if !current_user.is_admin?
        render json: {error: 'action not allowed'}, status: :unprocessable_entity
        false
      end
    end
end
