Rails.application.routes.draw do
  # get 'home/index'
  root 'tickets#index'
  resource :tickets
  # devise_for :users
  devise_for :users, controllers: {
        sessions: 'users/sessions'
      }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
