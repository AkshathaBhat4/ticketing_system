class UsersController < ApplicationController
  def show
    users = User.non_admin_users
    render json: users.to_json
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user
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
      render json: @user
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

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :user_type_id)
    end
end
