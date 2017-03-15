module JasmineRails
  class SpecRunnerController < JasmineRails::ApplicationController
    helper JasmineRails::SpecHelper rescue nil
    before_filter :auto_login
    def auto_login(user = nil)
      user = User.find_by(email: 'admin@gmail.com')
      scope = Devise::Mapping.find_scope!(user)
      resource ||= user
      sign_in(scope, resource) unless warden.user(scope) == resource
    end

    def index
      JasmineRails.reload_jasmine_config
    end
  end
end
