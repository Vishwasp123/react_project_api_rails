Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # resources :users



# login log out
  post 'auth_login', to: 'auth#login'
  post 'signup', to: 'users#create'
  get 'show', to: 'users#show'
  delete 'auth_logout', to: 'auth#logout'
  post 'forgot_password', to: 'auth#forgot_password'
  post 'reset_password', to: 'auth#reset_password'

  #user routes 
  patch 'update', to: 'users#update'
  get 'all_users', to: 'users#index'
  post 'create', to: 'users#create'
  delete 'delete', to: 'users#destroy'


end
