Rails.application.routes.draw do
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  # get 'home/index'
  root 'home#index'
  resource :tickets do
    put 'change_state'
    post 'generate_report'
  end
  resource :users do
    get 'get_user_tabs'
    get 'allowed_states'
    get 'all_states'
  end
  # devise_for :users
  devise_for :users, only: :sessions, controllers: {
        sessions: 'users/sessions'
      }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
