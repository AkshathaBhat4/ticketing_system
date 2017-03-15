# Consists of Users Specific Actions
#
class UsersController < ApplicationController
  before_action :validate_admin_user, except: [:all_states]

  # Get All Non Admin Users
  # @api private
  # @return [Json]
  def show
    users = User.non_admin_users
    render json: users.as_json
  end

  # Create New User
  # @api private
  # = Valid Params
  #   param user[name] [String]
  #   param user[email] [String]
  #   param user[passworf] [String]
  # @return [Json]
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user.as_json
    else
      render json: @user.errors.to_json, status: :unprocessable_entity
    end
  end

  # Create New User
  # @api private
  # = Valid Params
  #   param id [Integer]
  # @return :no_content
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    head :no_content
  end

  # Update User Details
  # @api private
  # = Valid Params
  #   param id [Integer]
  #   param user[name] [String]
  #   param user[email] [String]
  #   param user[passworf] [String]
  # @return [Json]
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      render json: @user.as_json
    else
      render json: @user.errors.to_json, status: :unprocessable_entity
    end
  end

  # Gets Allowed User Tabs
  # @api private
  # @return [Json]
  def get_user_tabs
    render json: current_user.user_tabs
  end

  # Gets Allowed User States
  # @api private
  # @return [Json]
  def allowed_states
    render json: current_user.allowed_ticket_state
  end

  # Gets All States  (New / Inprogress / Close / Delete)
  # @api public
  # @return [Json]
  def all_states
    states = State.all.pluck(:name)
    states.insert(0, 'all')
    render json: states
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :user_type_id)
    end

    # Validates if the current logged in user is admin
    # @private
    def validate_admin_user
      if !current_user.is_admin?
        render json: {error: 'action not allowed'}, status: :unprocessable_entity
        false
      end
    end
end
