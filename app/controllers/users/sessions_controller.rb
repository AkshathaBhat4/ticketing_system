class Users::SessionsController < Devise::SessionsController
  after_filter :set_csrf_headers, only: [:create, :destroy]
  respond_to :json

  protected
  def set_csrf_headers
    if request.xhr?
      response.headers['X-CSRF-Param'] = request_forgery_protection_token
      response.headers['X-CSRF-Token'] = form_authenticity_token
    end
  end

# before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
