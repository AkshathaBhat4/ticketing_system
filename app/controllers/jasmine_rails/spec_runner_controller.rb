# Consits of JavaScript Test Specific Classes & Methods
module JasmineRails
  # Consists of JavaScript Test Specific Actions Specific Actions
  #
  # Overrides original SpecRunnerController < JasmineRails::ApplicationController
  #
  class SpecRunnerController < JasmineRails::ApplicationController
    helper JasmineRails::SpecHelper rescue nil
    before_filter :auto_login

    def index
      JasmineRails.reload_jasmine_config
    end

    private

    # Auto Login As Admin User For Javascript Testing
    def auto_login
      user = User.find_by(email: 'admin@gmail.com')
      scope = Devise::Mapping.find_scope!(user)
      resource ||= user
      sign_in(scope, resource) unless warden.user(scope) == resource
    end
  end
end
