Rails.application.routes.draw do
  root "users#profile"

  resources :users, only: [ :new, :create, :edit, :update, :destroy ]

  get "/login", to: "sessions#new", as: "new_session"
  post "/login", to: "sessions#create", as: "login_user"
  delete "/logout", to: "sessions#destroy", as: "logout_user"
  resources :passwords, param: :token
end
